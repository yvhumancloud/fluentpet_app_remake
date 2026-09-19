/// Firebase Auth, behind one class.
///
/// The PRD's identity is a Firebase ID token — email/password or Google — and
/// this is the only file that talks to `firebase_auth` or `google_sign_in`.
/// Screens call the verbs below; the router reads [authRedirect]; the API
/// client (next phase) reads [AuthService.idToken]. Nothing else imports
/// Firebase.
///
/// ## Errors are outcomes, not exceptions
///
/// `FirebaseAuthException` carries a string `code`. The screens were designed
/// against a small set of states — rejected, locked out, address taken — and
/// [AuthFailure] is that set, so a screen switches over an enum rather than
/// matching strings. [AuthFailure.of] is the one place a code is read.
///
/// Sign-in deliberately folds `user-not-found`, `wrong-password` and
/// `invalid-credential` into one [AuthFailure.rejected]: telling them apart is
/// how an attacker enumerates accounts, and newer Firebase projects already
/// return `invalid-credential` for all three (email enumeration protection).
///
/// ## Verification
///
/// Email/password sign-up sends a verification mail and the router holds the
/// session on `VERIFY_EMAIL` until [User.emailVerified] is true — see
/// [needsVerification]. Google accounts arrive verified. Dropping the gate is
/// one line in [authRedirect]; the PRD does not require it, but a designed
/// screen exists for it and a junk account on somebody else's address is the
/// thing it prevents.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../env.dart';
import '../router/screens.g.dart';
import '../router/tabs.dart';

/// Why an auth call did not succeed, in the vocabulary the screens draw.
enum AuthFailure {
  /// Wrong address or wrong password — one answer for both, on purpose.
  rejected,

  /// Firebase rate-limited the account (`too-many-requests`).
  lockedOut,

  /// Sign-up: somebody already has this address.
  addressTaken,

  /// The user closed the Google sheet without choosing an account.
  cancelled,

  /// No network.
  offline,

  /// Everything else. The message is Firebase's own.
  other;

  static AuthFailure of(Object error) {
    if (error is GoogleSignInException) {
      return error.code == GoogleSignInExceptionCode.canceled
          ? AuthFailure.cancelled
          : AuthFailure.other;
    }
    if (error is! FirebaseAuthException) return AuthFailure.other;
    return switch (error.code) {
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' ||
      'invalid-email' ||
      'user-disabled' => AuthFailure.rejected,
      'too-many-requests' => AuthFailure.lockedOut,
      'email-already-in-use' => AuthFailure.addressTaken,
      'network-request-failed' => AuthFailure.offline,
      _ => AuthFailure.other,
    };
  }
}

class AuthService {
  AuthService(this._auth, this._google);

  final FirebaseAuth _auth;
  final GoogleSignIn _google;

  /// Fires on sign-in, sign-out, and on [reload] — which is what flips
  /// [User.emailVerified], so the verify screen watches this and not
  /// `authStateChanges`.
  Stream<User?> get changes => _auth.userChanges();

  User? get current => _auth.currentUser;

  /// The bearer token for `/api/v1`. Firebase refreshes it itself; `true`
  /// forces one, which the first call after sign-up needs so the `name`
  /// claim reaches `POST /me`'s provisioning.
  Future<String?> idToken({bool refresh = false}) =>
      _auth.currentUser?.getIdToken(refresh) ?? Future<String?>.value();

  Future<void> signIn({required String email, required String password}) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    if (name.isNotEmpty) await user.updateDisplayName(name);
    await user.sendEmailVerification();
    // The token minted at creation predates the display name.
    await user.getIdToken(true);
  }

  /// Android reads the OAuth client out of `google-services.json`, so
  /// `initialize()` takes no ids here. It is idempotent; calling it per
  /// sign-in is cheaper than a flag.
  Future<void> signInWithGoogle() async {
    await _google.initialize();
    final account = await _google.authenticate();
    final idToken = account.authentication.idToken;
    await _auth.signInWithCredential(
      GoogleAuthProvider.credential(idToken: idToken),
    );
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> sendVerification() async =>
      _auth.currentUser?.sendEmailVerification();

  /// Re-reads the user from Firebase. [changes] fires afterwards.
  Future<void> reload() async => _auth.currentUser?.reload();

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }
}

final Provider<AuthService> authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(FirebaseAuth.instance, GoogleSignIn.instance),
);

/// The signed-in user, or null. Every screen that draws differently for a
/// session watches this; the router re-evaluates its redirect on it.
final StreamProvider<User?> authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).changes,
);

/// True for an email/password account whose address is not yet confirmed.
/// Google accounts carry `emailVerified` already.
///
/// The `dev` environment skips the gate for any address containing `test`,
/// so a throwaway account on a domain that cannot receive mail still gets
/// into the app. `dev` only (`env.dart`): in `prod` a bypass keyed on the
/// address would be a bypass for anyone.
bool needsVerification(User user) {
  if (isDev && (user.email ?? '').contains('test')) return false;
  return !user.emailVerified &&
      user.providerData.any((p) => p.providerId == 'password');
}

/// Where a navigation must go instead, or null to allow it.
///
/// Signed out: only the `AUTHENTICATION` navigator's screens are reachable;
/// everything else lands on `WELCOME`. Signed in but unverified: only
/// `VERIFY_EMAIL`. Signed in and verified: the auth screens are skipped over
/// to the Activity tab, so a stale deep link into sign-in does not show a
/// sign-in form to somebody who has a session.
String? authRedirect(User? user, String location) {
  final screen = FpScreen.values.where((s) => s.path == location).firstOrNull;
  final onAuth = screen?.navigator == 'AUTHENTICATION';

  if (user == null)
    return onAuth || screen == null ? null : FpScreen.welcome.path;
  if (needsVerification(user)) {
    return screen == FpScreen.verifyEmail ? null : FpScreen.verifyEmail.path;
  }
  return onAuth ? FpTab.activity.root.path : null;
}

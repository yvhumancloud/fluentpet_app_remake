/// Which designed state each auth screen shows, decided from a fixture.
///
/// **This is not authentication and it is not a stand-in for authentication.**
/// It is the mechanism that makes every designed state reachable on a device,
/// which is the whole point of phase 1: a rejection state that nobody can get
/// to has not been designed, it has been described.
///
/// ## The one rule that shapes everything here
///
/// **Nothing in this file ever sees a password.** Every decision is made from
/// the email address alone. That has one visible consequence and it is worth
/// stating rather than hiding: the "that email and password don't match" state
/// is selected by *which address* is typed, not by the password being wrong.
/// That is backwards from how the real thing will work, and it is the price of
/// a rule worth more than the realism — no function in this app takes a
/// password as an argument except the two in `AuthRules` that measure its
/// length.
///
/// It imports nothing, for the same reason `auth_rules.dart` does not.
///
/// ## The addresses
///
/// Anything not listed behaves as an ordinary new address. The listed ones are
/// the doors to the states that are otherwise unreachable. They use the
/// `fluent.pet` domain so they read as demo data rather than as somebody's
/// real mailbox.
library;

/// What `SIGN_IN` shows after a submit that passed validation.
enum AuthSignInOutcome {
  /// Everything the screen can check is fine. Phase 1 stops here: no session
  /// is created and the screen says so.
  accepted,

  /// The pair was rejected. One message for a wrong address and a wrong
  /// password alike — telling them apart is how an attacker enumerates
  /// accounts.
  rejected,

  /// Rate limited. The real thing would be a server decision.
  lockedOut,
}

/// What `SIGN_UP` shows after a submit that passed validation.
enum AuthSignUpOutcome {
  /// The screen moves on to `VERIFY_EMAIL`.
  accepted,

  /// Somebody already has this address.
  addressTaken,
}

/// The fixture addresses and tokens, and the decisions they select.
class AuthFixture {
  const AuthFixture._();

  /// The account the rest of the fixtures belong to. Otis is the Learner the
  /// activity fixtures already use, so the demo reads as one household.
  static const String knownAddress = 'otis@fluent.pet';

  /// Signing in as this address is rejected.
  static const String rejectedAddress = 'wrong@fluent.pet';

  /// Signing in as this address is rate limited.
  static const String lockedAddress = 'locked@fluent.pet';

  /// How long the fixture says the lock-out lasts. Words, not a countdown:
  /// the screen has no clock to count against.
  static const String lockedOutFor = '15 minutes';

  /// How long a reset link lasts, as `CHECK_YOUR_EMAIL` states it. An
  /// unbounded link is a standing key to the account, so the screen says the
  /// bound out loud.
  static const String resetLinkLifetime = '1 hour';

  /// Seconds before a resend may be asked for again.
  ///
  /// Long enough that a double tap does not send two mails, short enough that
  /// somebody who genuinely did not receive the first one is not stuck. It is
  /// also what makes the "affordance removed, reason stated" disabled pattern
  /// reachable without contriving anything.
  static const int resendCooldownSeconds = 30;

  static bool _is(String candidate, String fixture) =>
      candidate.trim().toLowerCase() == fixture;

  /// Which sign-in state to show. Sees the address; never the password.
  static AuthSignInOutcome signIn(String email) {
    if (_is(email, rejectedAddress)) return AuthSignInOutcome.rejected;
    if (_is(email, lockedAddress)) return AuthSignInOutcome.lockedOut;
    return AuthSignInOutcome.accepted;
  }

  /// Which sign-up state to show.
  static AuthSignUpOutcome signUp(String email) =>
      _is(email, knownAddress) || _is(email, lockedAddress)
          ? AuthSignUpOutcome.addressTaken
          : AuthSignUpOutcome.accepted;
}

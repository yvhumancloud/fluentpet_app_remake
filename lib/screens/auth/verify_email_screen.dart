/// `VERIFY_EMAIL` — no React Native original. Designed for this app.
///
/// Where an email/password sign-up lands, and where the router keeps the
/// session until the address is confirmed (`authRedirect` — `needsVerification`).
/// Nothing navigates away from here: the moment [User.emailVerified] flips,
/// the redirect moves the session on.
///
/// ## Why the verified state is not a screen
///
/// Firebase's link opens its hosted "email verified" page in a browser, not the
/// app, so the app learns about it only by asking. "I've opened the link" calls
/// [AuthService.reload]; if the flag is now set the router takes over, and if
/// not the screen says so in a line rather than a banner. There is nothing to
/// draw for "verified" because nobody is on this screen for it.
///
/// ## Why this is not a code-entry screen
///
/// A six-digit code would be a third input pattern on top of the two the flow
/// already has, and it exists to work around apps that cannot receive a deep
/// link. Firebase's link plus one reload is one mechanism to build and one to
/// explain.
///
/// The `email` parameter is kept for a link that arrives without a session; a
/// signed-in user's own address wins over it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../auth/auth_service.dart';
import '../../auth/push_service.dart' show signOutProvider;
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../hardware/hardware_ui.dart' show HardwareNotice;
import '../log/log_controls.dart' show LogHairline, LogTextAction, logSay;
import 'auth_rules.dart';
import 'auth_ui.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({required this.email, super.key});

  /// The address the verification link went to, from the query string.
  /// Empty when opened from the drawer's route index; the session's own
  /// address takes precedence when there is one.
  final String email;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _checking = false;

  Future<void> _check() async {
    setState(() => _checking = true);
    final auth = ref.read(authServiceProvider);
    try {
      await auth.reload();
    } catch (_) {
      // Offline, most likely. The line below covers it.
    }
    if (!mounted) return;
    setState(() => _checking = false);
    final user = auth.current;
    if (user != null && !user.emailVerified) {
      logSay(context, 'Not confirmed yet — open the link in the mail first.');
    }
    // Verified: `userChanges` fired on reload and the router has moved on.
  }

  Future<void> _resend() async {
    try {
      await ref.read(authServiceProvider).sendVerification();
    } catch (e) {
      if (!mounted) return;
      logSay(
        context,
        AuthFailure.of(e) == AuthFailure.lockedOut
            ? 'Too many mails sent. Wait a while before asking again.'
            : 'Could not send the mail. Try again in a moment.',
      );
    }
  }

  /// "Typed the wrong address?" — the account exists under that address, so
  /// the way to another one is a new account. Signing out drops the session;
  /// WELCOME goes underneath so back has somewhere to go, SIGN_UP on top.
  Future<void> _startOver() async {
    await ref.read(signOutProvider)();
    if (!mounted) return;
    context.go(FpScreen.welcome.path);
    context.push(FpScreen.signUp.path);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final user = ref.watch(authStateProvider).value;
    final email = user?.email ?? widget.email;
    final back = context.canPop() ? () => context.pop() : null;

    if (email.isEmpty) {
      return AuthScaffold(
        title: 'Verify your email',
        onBack: back,
        children: <Widget>[
          HardwareNotice(
            icon: PhosphorIconsRegular.envelopeSimple,
            title: 'There is no address to verify',
            body:
                'This screen waits on a verification link for the address an '
                'account was just created with, so it is normally reached from '
                'the signup form.',
            action: LogTextAction(
              label: 'Create an account',
              onTap: () => context.go(FpScreen.signUp.path),
            ),
          ),
        ],
      );
    }

    return AuthScaffold(
      title: 'Verify your email',
      onBack: back,
      footer: AuthSubmit(
        label: "I'VE OPENED THE LINK",
        pendingLabel: 'CHECKING…',
        pending: _checking,
        onPressed: user == null ? null : _check,
        disabledReason: 'Sign in first, then confirm the address from here.',
      ),
      children: <Widget>[
        const AuthLead(
          'Your account exists. Open the link we sent to confirm the address '
          'is yours, then come back here.',
        ),
        const SizedBox(height: FpSpace.s6),
        AuthAddressWell(email),
        const SizedBox(height: FpSpace.s6),
        Text(
          "Nothing yet? It can take a minute, and it may have landed in spam.",
          style: FpType.bodySm.copyWith(color: c.textTertiary),
        ),
        const SizedBox(height: FpSpace.s3),
        AuthResendControl(
          label: 'Send it again',
          cooldownSeconds: AuthRules.resendCooldownSeconds,
          startCooling: true,
          onResend: _resend,
        ),
        const SizedBox(height: FpSpace.s5),
        const LogHairline(),
        const SizedBox(height: FpSpace.s5),
        Text(
          'Typed the wrong address?',
          style: FpType.bodySm.copyWith(color: c.textSecondary),
        ),
        LogTextAction(label: 'Start over with another one', onTap: _startOver),
      ],
    );
  }
}

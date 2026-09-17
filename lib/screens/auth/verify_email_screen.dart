/// `VERIFY_EMAIL` — no React Native original. Designed for this app.
///
/// Where `SIGN_UP` lands. Two states, and both are part of the flow rather
/// than one being an edge case:
///
/// * **waiting** — the account exists, the address has not been confirmed, and
///   the only thing that confirms it is a link in a message.
/// * **verified** — `?verified=1`, which is where that link comes back to. In a
///   real app the link opens the app at exactly this location.
///
/// The waiting state carries the same rate-limited resend as
/// `CHECK_YOUR_EMAIL`, and the same clearly-labelled simulation of the link,
/// for the same reason: without it the verified state is reachable only by
/// typing a URL.
///
/// **Nothing was sent and no account was created.** The screen says so at the
/// foot. Nothing here is stored and no credential reaches this screen at all —
/// only the address, as a query parameter, so it can be quoted back.
///
/// ## Why this is not a code-entry screen
///
/// A six-digit code would be a third input pattern on top of the two the flow
/// already has, and it exists to work around apps that cannot receive a deep
/// link. This one can: the `verified=1` parameter is the link's payload. One
/// mechanism for both mails is one mechanism to build and one to explain.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../hardware/hardware_ui.dart' show HardwareNotice;
import '../log/log_controls.dart' show LogHairline, LogTextAction, logSay;
import 'auth_fixture.dart';
import 'auth_ui.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({
    required this.email,
    required this.verified,
    super.key,
  });

  /// The address the verification link went to. Empty when the screen was
  /// opened from the drawer's route index rather than from sign-up.
  final String email;

  /// True where the link has been followed back into the app.
  final bool verified;

  @override
  Widget build(BuildContext context) {
    final back = context.canPop() ? () => context.pop() : null;

    if (email.isEmpty) {
      return AuthScaffold(
        title: 'Verify your email',
        onBack: back,
        children: <Widget>[
          HardwareNotice(
            icon: PhosphorIconsRegular.envelopeSimple,
            title: 'There is no address to verify',
            body: 'This screen waits on a verification link for the address an '
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

    return verified ? _verified(context, back) : _waiting(context, back);
  }

  Widget _waiting(BuildContext context, VoidCallback? back) {
    final c = context.fpColors;
    return AuthScaffold(
      title: 'Verify your email',
      onBack: back,
      footer: AuthSubmit(
        label: 'BACK TO SIGN IN',
        onPressed: () => context.go(FpScreen.signIn.path),
      ),
      children: <Widget>[
        const AuthLead(
          'Your account exists. Open the link we sent to confirm the address '
          'is yours — an unverified address cannot be used to reset a '
          'password.',
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
          cooldownSeconds: AuthFixture.resendCooldownSeconds,
          startCooling: true,
          onResend: () => logSay(
            context,
            'Phase 1 sends no mail. Nothing went out.',
          ),
        ),
        const SizedBox(height: FpSpace.s5),
        const LogHairline(),
        const SizedBox(height: FpSpace.s5),
        Text(
          'Typed the wrong address?',
          style: FpType.bodySm.copyWith(color: c.textSecondary),
        ),
        LogTextAction(
          label: 'Go back and change it',
          onTap: () =>
              back == null ? context.go(FpScreen.signUp.path) : back(),
        ),
        const SizedBox(height: FpSpace.s6),
        AuthPhaseNote(
          text: 'Phase 1 creates no account and sends no mail. Nothing you '
              'typed left this device.',
          demoLabel: 'Open the link (demo)',
          onDemo: () => context.pushReplacement(
            authLocation(FpScreen.verifyEmail.path, <String, String>{
              'email': email,
              'verified': '1',
            }),
          ),
        ),
      ],
    );
  }

  Widget _verified(BuildContext context, VoidCallback? back) {
    return AuthScaffold(
      title: 'Email verified',
      onBack: back,
      footer: AuthSubmit(
        label: 'SIGN IN',
        onPressed: () => context.go(FpScreen.signIn.path),
      ),
      children: <Widget>[
        const AuthBanner(
          tone: AuthBannerTone.success,
          title: 'That address is confirmed',
          message: 'The account is ready. Sign in and the Board, the Bases and '
              'the Household follow it.',
        ),
        const SizedBox(height: FpSpace.s6),
        AuthAddressWell(email),
        const SizedBox(height: FpSpace.s6),
        const AuthPhaseNote(
          text: 'Phase 1 verified nothing. There is no account behind this '
              'screen and no session to start.',
        ),
      ],
    );
  }
}

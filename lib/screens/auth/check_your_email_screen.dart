/// `CHECK_YOUR_EMAIL` — no React Native original. Designed for this app.
///
/// Where `FORGOT_PASSWORD` lands. It confirms that a reset link was *sent*, and
/// it is careful never to confirm that an account exists — see the note in
/// `forgot_password_screen.dart` on why answering that question is account
/// enumeration. Every sentence here works for an address with an account and
/// for one without.
///
/// **Nothing was sent.** Phase 1 has no mail. The screen says so at the foot
/// rather than only in this comment, on the same principle the rest of the app
/// already follows — `ProductGlyph` "stays honest about being a stand-in", and
/// `WELCOME`'s support bubble says phase 1 has no Intercom session.
///
/// The link in that mail opens Firebase Auth's hosted reset page, not a screen
/// in this app, so this is the last screen of the flow.
///
/// ## The resend, and the disabled treatment
///
/// The resend cools down for [AuthFixture.resendCooldownSeconds]. While it is
/// cooling the control is **removed**, not greyed: `text.disabled` and
/// `text.tertiary` are the same value, so a greyed link is a link. Components
/// § Disabled states names "affordance removed, not recoloured" and "a reason,
/// in words" as two of the four acceptable signals, and a `GestureDetector` has
/// no ripple to withhold — so this control uses both of the ones it can.
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

class CheckYourEmailScreen extends StatelessWidget {
  const CheckYourEmailScreen({required this.email, super.key});

  /// The address the link went to. Empty when the screen was opened from the
  /// drawer's route index rather than from the reset form.
  final String email;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final back = context.canPop() ? () => context.pop() : null;

    if (email.isEmpty) {
      // Not an error and not a blank screen. This route is reachable from the
      // drawer's route index, which exists precisely so every path can be
      // walked; the honest thing is to say what the screen needs and offer the
      // screen that supplies it.
      return AuthScaffold(
        title: 'Check your email',
        onBack: back,
        children: <Widget>[
          HardwareNotice(
            icon: PhosphorIconsRegular.envelopeSimple,
            title: 'There is no address to confirm',
            body: 'This screen reports on a reset link that has just been '
                'sent, so it is normally reached from the reset form.',
            action: LogTextAction(
              label: 'Reset a password',
              onTap: () => context.go(FpScreen.forgotPassword.path),
            ),
          ),
        ],
      );
    }

    return AuthScaffold(
      title: 'Check your email',
      onBack: back,
      footer: AuthSubmit(
        label: 'BACK TO SIGN IN',
        // `go`, not `pop`. The reset flow is finished: leaving it should not
        // leave the form and the confirmation stacked underneath, waiting for
        // a back gesture to walk somebody back into a request they have
        // already made.
        onPressed: () => context.go(FpScreen.signIn.path),
      ),
      children: <Widget>[
        const AuthLead(
          'If there is an account on this address, a link to choose a new '
          'password is on its way to it.',
        ),
        const SizedBox(height: FpSpace.s6),
        AuthAddressWell(email),
        const SizedBox(height: FpSpace.s6),
        Text(
          'The link lasts ${AuthFixture.resetLinkLifetime} and can be used '
          'once. Until you use it, the old password still works.',
          style: FpType.bodySm.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: FpSpace.s5),
        Text(
          "Nothing yet? It can take a minute, and it may have landed in spam.",
          style: FpType.bodySm.copyWith(color: c.textTertiary),
        ),
        const SizedBox(height: FpSpace.s3),
        AuthResendControl(
          label: 'Send another link',
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
          'Wrong address?',
          style: FpType.bodySm.copyWith(color: c.textSecondary),
        ),
        LogTextAction(
          label: 'Ask for it again',
          onTap: () => back == null
              ? context.go(FpScreen.forgotPassword.path)
              : back(),
        ),
        const SizedBox(height: FpSpace.s6),
        const AuthPhaseNote(
          text: 'Phase 1 sends no mail and has no account to send it about. '
              'Nothing you typed left this device.',
        ),
      ],
    );
  }
}

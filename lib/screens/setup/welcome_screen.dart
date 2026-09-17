/// `WELCOME` — `src/Authentication/Welcome/Welcome.tsx`.
///
/// The RN screen is almost entirely Auth0's own hosted login (`<Auth0Login
/// />`) wrapped in one line of copy ("Let's go"), an app-version caption and
/// an Intercom support bubble. Its button does not belong to it: the widget
/// supplies it, and tapping it opens Auth0 Universal Login in a system browser
/// against `https://auth.fluent.pet/authorize`. The RN app has no sign-in
/// screen of its own, and no signup screen at all —
/// `AuthenticationNavigator.tsx` registers exactly one screen, this one.
///
/// This app has native auth screens instead: `SIGN_IN`, `SIGN_UP`,
/// `FORGOT_PASSWORD`, `CHECK_YOUR_EMAIL` and
/// `VERIFY_EMAIL`, in `lib/screens/auth/`. They are designed rather than
/// ported, because there is nothing to port. So what this screen owes them is
/// a door, and what it keeps of the original is everything that **is**
/// presentation: the brand moment, the version mark, and the support
/// affordance, wired to a phase-1 notice rather than to Intercom.
///
/// **Invented:** the two actions, because the RN screen has none of its own.
/// SIGN IN pushes `SIGN_IN`; "Create an account" pushes `SIGN_UP`. Both are
/// pushes rather than replacements, so back out of the flow lands here rather
/// than nowhere.
///
/// An earlier pass put a single CONTINUE here that went straight to the
/// Activity tab, standing in for "an authenticated session now exists". That
/// stand-in is gone. It is worth saying why rather than only that: a button
/// that lands on the dashboard is a claim that somebody signed in, and there
/// is nothing in this app that can make that true. The auth screens do not
/// reintroduce it either — a submit that passes validation stops on a stated
/// phase-1 state and goes no further.
///
/// Fixtures only. Nothing on this screen or behind it authenticates, and no
/// credential is written anywhere.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../log/log_controls.dart'
    show LogActionBar, LogActionButton, LogTextAction, logSay;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'FluentPet',
                        style: FpType.displayLg.copyWith(color: c.textBrand),
                      ),
                      const SizedBox(height: FpSpace.s3),
                      Text(
                        "Let's go",
                        style:
                            FpType.headingLg.copyWith(color: c.textPrimary),
                      ),
                      const SizedBox(height: FpSpace.s6),
                      Divider(color: c.borderSubtle, height: FpStroke.hairline),
                      const SizedBox(height: FpSpace.s6),
                      Text(
                        'Sign in to talk with your Learner.',
                        style: FpType.bodyMd.copyWith(color: c.textSecondary),
                      ),
                      const SizedBox(height: FpSpace.s5),
                      Text(
                        'New here?',
                        style: FpType.bodySm.copyWith(color: c.textTertiary),
                      ),
                      LogTextAction(
                        label: 'Create an account',
                        onTap: () => context.push(FpScreen.signUp.path),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: FpSpace.s4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Semantics(
                      button: true,
                      label: 'Support',
                      child: GestureDetector(
                        onTap: () => logSay(
                          context,
                          'Support chat — phase 1 has no Intercom session.',
                        ),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: FpMetrics.headerBackHit,
                          height: FpMetrics.headerBackHit,
                          decoration: BoxDecoration(
                            color: c.surfaceRaised,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: c.borderSubtle,
                              width: FpStroke.hairline,
                            ),
                          ),
                          child: PhosphorIcon(
                            PhosphorIconsRegular.headset,
                            size: FpIconSize.sm,
                            color: c.textBrand,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: FpSpace.s3),
                    Text(
                      'v1.0.0 (phase 1)',
                      style: FpType.labelSm.copyWith(color: c.textTertiary),
                    ),
                  ],
                ),
              ),
              LogActionBar(
                children: <Widget>[
                  LogActionButton(
                    label: 'SIGN IN',
                    // Push, not go. The sign-in screen is on top of this one,
                    // so its back chevron has somewhere to go and the brand
                    // moment is still underneath. `go` would replace this
                    // screen and leave the flow with no way out of itself.
                    onPressed: () => context.push(FpScreen.signIn.path),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

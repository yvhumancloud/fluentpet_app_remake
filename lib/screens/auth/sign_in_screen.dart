/// `SIGN_IN` — no React Native original. Designed for this app.
///
/// The RN app has no sign-in screen at all. `AuthenticationNavigator.tsx`
/// registers exactly one screen, `WELCOME`, and signing in there means opening
/// Auth0 Universal Login in a system browser against
/// `https://auth.fluent.pet/authorize` — a hosted web page, not an app surface.
/// So nothing here is ported; it is designed, inside the established system.
///
/// **The submit path is deliberately absent.** This screen validates, shows
/// every state a sign-in can be in, and stops. It opens no connection, calls no
/// SDK, creates no session, and writes no credential anywhere — not to disk,
/// not to a provider, not to a log. The email and the password live in two
/// [TextEditingController]s and are read by exactly two things: the pure
/// predicates in `AuthRules`, and — for the address only, never the password —
/// `AuthFixture`, which chooses which designed state to draw. That is the
/// whole of it.
///
/// The predecessor to this screen was `WELCOME`'s invented CONTINUE, which went
/// straight to the Activity tab as a stand-in for "a session now exists". That
/// stand-in is gone, and this screen does not reintroduce it: a submit that
/// passes validation lands on a stated phase-1 state, not on the dashboard.
/// Landing on the dashboard would be the same lie in a new place.
///
/// ## The three post-submit states, and how to reach each
///
/// Selected by address, in `auth_fixture.dart`, because nothing in this app
/// takes a password as an argument:
///
/// * `wrong@fluent.pet` — rejected. One message for a wrong address and a
///   wrong password alike; telling them apart is how an attacker enumerates
///   accounts.
/// * `locked@fluent.pet` — rate limited.
/// * anything else — accepted as far as this screen can tell, and stopped.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../theme/fp_context.dart';
import '../log/log_controls.dart' show LogHairline, LogTextAction, logSay;
import 'auth_fixture.dart';
import 'auth_rules.dart';
import 'auth_ui.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  /// Errors are silent until the first submit.
  ///
  /// An address is invalid for every keystroke up to the last one, so a field
  /// that validates as you type spends most of its life telling you that you
  /// have not finished typing. After a submit the rule flips and the field
  /// re-validates live, because then the message is help rather than
  /// commentary.
  bool _submitted = false;

  bool _pending = false;
  AuthSignInOutcome? _outcome;

  @override
  void initState() {
    super.initState();
    _email.addListener(_onEdit);
    _password.addListener(_onEdit);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onEdit() {
    // Editing anything retracts the verdict on the last submission. A
    // "that didn't match" banner sitting above a field the user has since
    // changed is a statement about a form that no longer exists.
    if (_outcome != null) {
      setState(() => _outcome = null);
    } else {
      setState(() {});
    }
  }

  String? get _emailError =>
      _submitted ? AuthRules.emailError(_email.text) : null;

  String? get _passwordError =>
      _submitted ? AuthRules.currentPasswordError(_password.text) : null;

  bool get _hasBoth => _email.text.trim().isNotEmpty && _password.text.isNotEmpty;

  String get _disabledReason {
    final noEmail = _email.text.trim().isEmpty;
    final noPassword = _password.text.isEmpty;
    if (noEmail && noPassword) {
      return 'Enter your email address and password to sign in.';
    }
    return noEmail
        ? 'Enter your email address to sign in.'
        : 'Enter your password to sign in.';
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _outcome = null;
    });
    if (AuthRules.emailError(_email.text) != null ||
        AuthRules.currentPasswordError(_password.text) != null) {
      return;
    }

    setState(() => _pending = true);
    // A beat, so the working state is something that can be seen rather than
    // something described in a comment. There is nothing to wait for.
    await Future<void>.delayed(FpDuration.base * 2);
    if (!mounted) return;
    setState(() {
      _pending = false;
      _outcome = AuthFixture.signIn(_email.text);
    });
  }

  AuthBanner? get _banner => switch (_outcome) {
        null => null,
        AuthSignInOutcome.rejected => const AuthBanner(
            tone: AuthBannerTone.danger,
            title: "That combination didn't work",
            message: 'Check the address and the password and try again. If you '
                'are not sure of the password, reset it below.',
          ),
        AuthSignInOutcome.lockedOut => AuthBanner(
            tone: AuthBannerTone.danger,
            title: 'Too many attempts',
            message: 'Sign-in is paused for ${AuthFixture.lockedOutFor}. '
                'Resetting your password lets you back in sooner.',
          ),
        AuthSignInOutcome.accepted => const AuthBanner(
            title: 'Everything this screen can check is in order',
            message: 'Phase 1 stops here. Nothing was sent, no session was '
                'created, and neither the address nor the password was stored.',
          ),
      };

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final banner = _banner;

    return AuthScaffold(
      title: 'Sign in',
      onBack: context.canPop() ? () => context.pop() : null,
      footer: AuthSubmit(
        label: 'SIGN IN',
        pendingLabel: 'SIGNING IN…',
        pending: _pending,
        onPressed: _hasBoth ? _submit : null,
        disabledReason: _disabledReason,
      ),
      children: <Widget>[
        const AuthLead(
          'Your Board, your Bases and everyone in your Household are on your '
          'account.',
        ),
        const SizedBox(height: FpSpace.s6),
        if (banner != null) ...<Widget>[
          banner,
          const SizedBox(height: FpSpace.s6),
        ],
        // One AutofillGroup around both fields, so a password manager offers
        // the pair rather than the address alone. It lets the OS *fill*;
        // `TextInput.finishAutofillContext()`, the call that asks the OS to
        // save a credential, is made nowhere in this app.
        AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AuthField(
                controller: _email,
                label: 'Email address',
                hintText: 'you@example.com',
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const <String>[
                  AutofillHints.username,
                  AutofillHints.email,
                ],
                textInputAction: TextInputAction.next,
                maxLength: AuthRules.emailMaxLength,
                onSubmitted: (_) => _passwordFocus.requestFocus(),
              ),
              const SizedBox(height: FpSpace.s5),
              AuthField(
                controller: _password,
                focusNode: _passwordFocus,
                label: 'Password',
                errorText: _passwordError,
                obscurable: true,
                // `visiblePassword` rather than `text`: it asks for the
                // ASCII-capable keyboard, which is the one that does not
                // reshape what is typed when the reveal toggle turns the
                // field back into plain text.
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const <String>[AutofillHints.password],
                maxLength: AuthRules.passwordMaxLength,
                onSubmitted: (_) => _hasBoth ? _submit() : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: FpSpace.s4),
        LogTextAction(
          label: 'Forgot your password?',
          onTap: () => context.push(FpScreen.forgotPassword.path),
        ),
        const SizedBox(height: FpSpace.s5),
        AuthGoogleButton(
          onPressed: () => logSay(
            context,
            'Google sign-in arrives with Firebase Auth. Phase 1 signs nobody in.',
          ),
        ),
        const SizedBox(height: FpSpace.s5),
        const LogHairline(),
        const SizedBox(height: FpSpace.s5),
        Text(
          'New to FluentPet?',
          style: FpType.bodySm.copyWith(color: c.textSecondary),
        ),
        LogTextAction(
          label: 'Create an account',
          onTap: () => authSwap(context, FpScreen.signUp.path),
        ),
      ],
    );
  }
}

/// `SIGN_IN` — no React Native original. Designed for this app.
///
/// The RN app has no sign-in screen at all. `AuthenticationNavigator.tsx`
/// registers exactly one screen, `WELCOME`, and signing in there means opening
/// Auth0 Universal Login in a system browser against
/// `https://auth.fluent.pet/authorize` — a hosted web page, not an app surface.
/// So nothing here is ported; it is designed, inside the established system.
///
/// Submit calls [AuthService.signIn]; the Google button calls
/// [AuthService.signInWithGoogle]. Neither navigates: the router's
/// `authRedirect` sees the new session and moves off this screen itself, which
/// is one place for that rule instead of one per screen.
///
/// ## The post-submit states
///
/// [AuthFailure] is the set. `rejected` is one message for a wrong address and
/// a wrong password alike — telling them apart is how an attacker enumerates
/// accounts, and Firebase's email-enumeration protection returns the same
/// code for both anyway. `lockedOut` is Firebase's own rate limit. A cancelled
/// Google sheet is not an error and shows nothing.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_service.dart';
import '../../router/screens.g.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../theme/fp_context.dart';
import '../log/log_controls.dart' show LogHairline, LogTextAction;
import 'auth_rules.dart';
import 'auth_ui.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
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
  AuthFailure? _failure;

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
    if (_failure != null) {
      setState(() => _failure = null);
    } else {
      setState(() {});
    }
  }

  String? get _emailError =>
      _submitted ? AuthRules.emailError(_email.text) : null;

  String? get _passwordError =>
      _submitted ? AuthRules.currentPasswordError(_password.text) : null;

  bool get _hasBoth =>
      _email.text.trim().isNotEmpty && _password.text.isNotEmpty;

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
      _failure = null;
    });
    if (AuthRules.emailError(_email.text) != null ||
        AuthRules.currentPasswordError(_password.text) != null) {
      return;
    }
    await _run(
      () => ref
          .read(authServiceProvider)
          .signIn(
            email: AuthRules.normaliseEmail(_email.text),
            password: _password.text,
          ),
    );
  }

  Future<void> _google() async {
    setState(() => _failure = null);
    await _run(() => ref.read(authServiceProvider).signInWithGoogle());
  }

  /// One pending/failure wrapper for both doors. Success needs nothing here:
  /// the router redirects on the session change.
  Future<void> _run(Future<void> Function() call) async {
    setState(() => _pending = true);
    try {
      await call();
    } catch (e) {
      if (!mounted) return;
      final failure = AuthFailure.of(e);
      setState(() {
        if (failure != AuthFailure.cancelled) _failure = failure;
      });
    } finally {
      if (mounted) setState(() => _pending = false);
    }
  }

  AuthBanner? get _banner => switch (_failure) {
    null || AuthFailure.cancelled || AuthFailure.addressTaken => null,
    AuthFailure.rejected => const AuthBanner(
      tone: AuthBannerTone.danger,
      title: "That combination didn't work",
      message:
          'Check the address and the password and try again. If you '
          'are not sure of the password, reset it below.',
    ),
    AuthFailure.lockedOut => const AuthBanner(
      tone: AuthBannerTone.danger,
      title: 'Too many attempts',
      message:
          'Sign-in is paused for a while. Resetting your password '
          'lets you back in sooner.',
    ),
    AuthFailure.offline => const AuthBanner(
      tone: AuthBannerTone.danger,
      title: 'No connection',
      message:
          'Signing in needs the network. Try again when you are '
          'back online.',
    ),
    AuthFailure.other => const AuthBanner(
      tone: AuthBannerTone.danger,
      title: 'Could not sign in',
      message: 'Something went wrong on the way. Try again in a moment.',
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
        AuthGoogleButton(onPressed: _pending ? null : _google),
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

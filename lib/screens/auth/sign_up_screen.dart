/// `SIGN_UP` — no React Native original. Designed for this app.
///
/// The RN app has no signup screen either; account creation there happens on
/// Auth0's hosted page, in a system browser. This is designed, not ported.
///
/// Submit calls [AuthService.signUp], which creates the Firebase account,
/// records the name and sends the verification mail. Firebase signs the new
/// account in at once, so the router's `authRedirect` takes over from here —
/// it holds an unverified session on `VERIFY_EMAIL`.
///
/// ## The name field
///
/// Optional. `POST /me` names the first human Pusher after the token's `name`
/// claim, falling back to the email's local part — so without this, everyone's
/// Teacher is called "yogesh.vitekar". Google sign-in supplies it for free.
///
/// ## One password field, not two
///
/// There is no "confirm password". The reveal toggle is what a confirm field
/// was for: it lets somebody check what they typed, in one field, without
/// typing it twice. Two fields cost a second of every signup and catch only the
/// typo somebody makes identically twice — and this app has a working reset
/// flow behind it, which is the real remedy for a mistyped password. The live
/// requirement list is the other half: the rules are visible before they are
/// broken, rather than arriving as a rejection.
///
/// ## Why the rules are what they are
///
/// Ten characters, a cap at 128, not the address, and **no composition rules**.
/// The full argument is in `auth_rules.dart`; the short version is that NIST
/// SP 800-63B recommends against required digits, symbols and capitals because
/// they produce `Password1!` and lower real entropy. That absence is the thing
/// most likely to be read as an oversight, which is why it is written down in
/// two places.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_service.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../log/log_controls.dart' show LogHairline, LogTextAction;
import 'auth_rules.dart';
import 'auth_ui.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

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
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onEdit() => setState(() => _failure = null);

  String? get _emailError =>
      _submitted ? AuthRules.emailError(_email.text) : null;

  /// The password's error row, for what the requirement list cannot say.
  ///
  /// The list above already states the length rule and the address rule, live
  /// and before either is broken. Repeating one of them as a red row directly
  /// under it is the same sentence twice, once shouting — so those two are
  /// suppressed here. What the list has no line for still needs saying: an
  /// empty field on submit, and a password that is nothing but spaces.
  String? get _passwordError {
    if (!_submitted) return null;
    final message = AuthRules.newPasswordError(
      _password.text,
      email: _email.text,
    );
    if (message == null) return null;
    if (_password.text.isNotEmpty && !AuthRules.longEnough(_password.text)) {
      return null;
    }
    if (!AuthRules.notTheAddress(_password.text, _email.text)) return null;
    return message;
  }

  bool get _metAll =>
      AuthRules.newPasswordError(_password.text, email: _email.text) == null;

  bool get _hasBoth =>
      _email.text.trim().isNotEmpty && _password.text.isNotEmpty;

  String get _disabledReason {
    final noEmail = _email.text.trim().isEmpty;
    final noPassword = _password.text.isEmpty;
    if (noEmail && noPassword) {
      return 'Enter an email address and choose a password.';
    }
    return noEmail
        ? 'Enter the email address the account should belong to.'
        : 'Choose a password.';
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _failure = null;
    });
    if (AuthRules.emailError(_email.text) != null || !_metAll) return;
    await _run(
      () => ref
          .read(authServiceProvider)
          .signUp(
            name: _name.text.trim(),
            email: AuthRules.normaliseEmail(_email.text),
            password: _password.text,
          ),
    );
  }

  Future<void> _google() async {
    setState(() => _failure = null);
    await _run(() => ref.read(authServiceProvider).signInWithGoogle());
  }

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
    null || AuthFailure.cancelled => null,
    AuthFailure.addressTaken => const AuthBanner(
      tone: AuthBannerTone.danger,
      title: 'That address already has an account',
      message:
          'Sign in instead, or reset the password if you have '
          'forgotten it.',
    ),
    AuthFailure.offline => const AuthBanner(
      tone: AuthBannerTone.danger,
      title: 'No connection',
      message:
          'Creating an account needs the network. Try again when '
          'you are back online.',
    ),
    AuthFailure.rejected ||
    AuthFailure.lockedOut ||
    AuthFailure.other => const AuthBanner(
      tone: AuthBannerTone.danger,
      title: 'Could not create the account',
      message: 'Something went wrong on the way. Try again in a moment.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;

    return AuthScaffold(
      title: 'Create your account',
      onBack: context.canPop() ? () => context.pop() : null,
      footer: AuthSubmit(
        label: 'CREATE ACCOUNT',
        pendingLabel: 'CREATING…',
        pending: _pending,
        onPressed: _hasBoth ? _submit : null,
        disabledReason: _disabledReason,
      ),
      children: <Widget>[
        const AuthLead(
          'One account holds your Board, your Bases and everyone in your '
          'Household.',
        ),
        const SizedBox(height: FpSpace.s6),
        if (_banner != null) ...<Widget>[
          _banner!,
          const SizedBox(height: FpSpace.s6),
        ],
        AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AuthField(
                controller: _name,
                label: 'Your name',
                hintText: 'Optional — what the Household calls you',
                keyboardType: TextInputType.name,
                autofillHints: const <String>[AutofillHints.name],
                textInputAction: TextInputAction.next,
                maxLength: 80,
                onSubmitted: (_) => _emailFocus.requestFocus(),
              ),
              const SizedBox(height: FpSpace.s5),
              AuthField(
                controller: _email,
                focusNode: _emailFocus,
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
                keyboardType: TextInputType.visiblePassword,
                // `newPassword` rather than `password`: it is what makes a
                // password manager offer to generate one instead of offering
                // the one it already has for this domain.
                autofillHints: const <String>[AutofillHints.newPassword],
                maxLength: AuthRules.passwordMaxLength,
                onSubmitted: (_) => _hasBoth ? _submit() : null,
                below: AuthRequirementList(
                  requirements: <AuthRequirement>[
                    AuthRequirement(
                      label:
                          'At least ${AuthRules.passwordMinLength} '
                          'characters',
                      met: AuthRules.longEnough(_password.text),
                    ),
                    AuthRequirement(
                      label: 'Not your email address',
                      met:
                          _password.text.isEmpty ||
                          AuthRules.notTheAddress(_password.text, _email.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: FpSpace.s5),
        Text(
          'Spaces count, and a phrase you can remember beats a short string '
          'you cannot. Nothing else is required — no digit, no symbol, no '
          'capital.',
          style: FpType.bodySm.copyWith(color: c.textTertiary),
        ),
        const SizedBox(height: FpSpace.s5),
        AuthGoogleButton(onPressed: _pending ? null : _google),
        const SizedBox(height: FpSpace.s5),
        const LogHairline(),
        const SizedBox(height: FpSpace.s5),
        Text(
          'Already have an account?',
          style: FpType.bodySm.copyWith(color: c.textSecondary),
        ),
        LogTextAction(
          label: 'Sign in',
          onTap: () => authSwap(context, FpScreen.signIn.path),
        ),
      ],
    );
  }
}

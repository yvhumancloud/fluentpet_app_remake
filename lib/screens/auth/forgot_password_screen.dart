/// `FORGOT_PASSWORD` — no React Native original. Designed for this app.
///
/// Password recovery in the RN app is a link on Auth0's hosted page, so there
/// is nothing to port. This is designed.
///
/// Submit calls [AuthService.sendPasswordReset] and moves to
/// `CHECK_YOUR_EMAIL`. The link in that mail opens Firebase's hosted reset
/// page; the app has no reset screen of its own.
///
/// ## The screen does not say whether the account exists
///
/// It cannot and it must not. It cannot, because only the mail server knows;
/// it must not, because a screen that answers "no account with that address"
/// is a screen that answers, for any address anybody types, whether that person
/// has a FluentPet account. That is account enumeration, and it is worth more
/// to an attacker than most people expect. So the wording throughout is *"if
/// there is an account, a link is on its way"* — the same sentence for an
/// address that exists and one that does not.
///
/// This is the one place where being unhelpful is the design, so it is written
/// down rather than left to look like a copy oversight. It has a consequence
/// in code: Firebase's `user-not-found` on this call is swallowed and treated
/// as sent. (Projects with email-enumeration protection on never return it.)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_service.dart';
import '../../router/screens.g.dart';
import '../../theme/generated/fp_tokens.dart';
import 'auth_rules.dart';
import 'auth_ui.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController();

  bool _submitted = false;
  bool _pending = false;
  AuthFailure? _failure;

  @override
  void initState() {
    super.initState();
    _email.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  String? get _emailError =>
      _submitted ? AuthRules.emailError(_email.text) : null;

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _failure = null;
    });
    if (AuthRules.emailError(_email.text) != null) return;
    final email = AuthRules.normaliseEmail(_email.text);

    setState(() => _pending = true);
    try {
      await ref.read(authServiceProvider).sendPasswordReset(email);
    } catch (e) {
      final failure = AuthFailure.of(e);
      // `rejected` here is `user-not-found`: no account, and the screen must
      // not say so. It reads as sent, exactly like an address that exists.
      if (failure != AuthFailure.rejected) {
        if (mounted) setState(() => _failure = failure);
        return;
      }
    } finally {
      if (mounted) setState(() => _pending = false);
    }
    if (!mounted) return;

    // Push, not replace. Back from the confirmation means "that address was
    // wrong", and the form behind it still holds what was typed — which is the
    // whole of what somebody wants when they realise they typed `.con`.
    context.push(
      authLocation(FpScreen.checkYourEmail.path, <String, String>{
        'email': email,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Reset your password',
      onBack: context.canPop() ? () => context.pop() : null,
      footer: AuthSubmit(
        label: 'SEND THE LINK',
        pendingLabel: 'SENDING…',
        pending: _pending,
        onPressed: _email.text.trim().isEmpty ? null : _submit,
        disabledReason: 'Enter the email address the account was created with.',
      ),
      children: <Widget>[
        const AuthLead(
          'Give us the address on the account. If there is one, a link to '
          'choose a new password is on its way to it.',
        ),
        const SizedBox(height: FpSpace.s6),
        if (_failure != null) ...<Widget>[
          AuthBanner(
            tone: AuthBannerTone.danger,
            title: _failure == AuthFailure.offline
                ? 'No connection'
                : 'Could not send the link',
            message: _failure == AuthFailure.offline
                ? 'Sending the link needs the network. Try again when you are '
                      'back online.'
                : 'Something went wrong on the way. Try again in a moment.',
          ),
          const SizedBox(height: FpSpace.s6),
        ],
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
          maxLength: AuthRules.emailMaxLength,
          autofocus: true,
          onSubmitted: (_) => _email.text.trim().isEmpty ? null : _submit(),
        ),
      ],
    );
  }
}

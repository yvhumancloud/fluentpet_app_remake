/// `FORGOT_PASSWORD` — no React Native original. Designed for this app.
///
/// Password recovery in the RN app is a link on Auth0's hosted page, so there
/// is nothing to port. This is designed.
///
/// **The submit path is deliberately absent.** No mail is sent, no address is
/// looked up, nothing is stored and no credential exists on this screen to
/// store. Submitting validates the shape of the address and moves to
/// `CHECK_YOUR_EMAIL`, which says out loud that nothing went out.
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
/// down rather than left to look like a copy oversight.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import '../../theme/generated/fp_tokens.dart';
import 'auth_rules.dart';
import 'auth_ui.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController();

  bool _submitted = false;
  bool _pending = false;

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
    setState(() => _submitted = true);
    if (AuthRules.emailError(_email.text) != null) return;

    setState(() => _pending = true);
    await Future<void>.delayed(FpDuration.base * 2);
    if (!mounted) return;
    setState(() => _pending = false);

    // Push, not replace. Back from the confirmation means "that address was
    // wrong", and the form behind it still holds what was typed — which is the
    // whole of what somebody wants when they realise they typed `.con`.
    context.push(
      authLocation(FpScreen.checkYourEmail.path, <String, String>{
        'email': AuthRules.normaliseEmail(_email.text),
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
        disabledReason:
            'Enter the email address the account was created with.',
      ),
      children: <Widget>[
        const AuthLead(
          'Give us the address on the account. If there is one, a link to '
          'choose a new password is on its way to it.',
        ),
        const SizedBox(height: FpSpace.s6),
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

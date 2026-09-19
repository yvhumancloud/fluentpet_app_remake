/// `AI_CONSENT` — no RN original. PRD §12.8.
///
/// Shown once, before the first AI call, by [openAi]. It says exactly what
/// leaves the phone and to whom, because the privacy line in §12.8 is a
/// promise the app has to make in words the user reads, not in a policy
/// page: Pusher names, Button words, notes and timestamps go to Anthropic;
/// emails and sign-in ids do not.
///
/// "Not now" just pops. Nothing else changes, and the Activity tab works as
/// it did — the PRD's rule that the app works fully without AI is also the
/// rule that declining costs nothing.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../log/log_controls.dart';
import 'ai_state.dart';

class AiConsentScreen extends ConsumerWidget {
  const AiConsentScreen({required this.next, super.key});

  /// Where to go once agreed — the AI screen that was asked for.
  final String? next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Ask FluentPet',
              subtitle: 'BEFORE THE FIRST QUESTION',
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FpSpace.s6,
                  FpSpace.s2,
                  FpSpace.s6,
                  FpSpace.s8,
                ),
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(FpRadius.lg),
                      ),
                      child: Center(
                        child: PhosphorIcon(
                          PhosphorIconsRegular.sparkle,
                          size: FpIconSize.lg,
                          color: c.textBrand,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: FpSpace.s5),
                  Text(
                    'Answers come from your Household’s own log',
                    style: FpType.headingLg.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: FpSpace.s3),
                  Text(
                    'You can ask questions about what your Learners say and '
                    'describe a press in a sentence instead of tapping it in. '
                    'To answer, FluentPet sends part of your log to Anthropic, '
                    'the company behind the Claude models.',
                    style: FpType.bodyMd.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: FpSpace.s6),
                  _Fact(
                    icon: PhosphorIconsRegular.pawPrint,
                    title: 'What is sent',
                    body:
                        'Pusher names, Button words, Contexts, notes and '
                        'the times of presses — only what a question needs.',
                  ),
                  _Fact(
                    icon: PhosphorIconsRegular.lockSimple,
                    title: 'What is not',
                    body:
                        'Your email address, your sign-in and anything '
                        'about other Households.',
                  ),
                  _Fact(
                    icon: PhosphorIconsRegular.eyeSlash,
                    title: 'Not used for training',
                    body:
                        'Anthropic processes it under its commercial terms '
                        'and does not train on it.',
                  ),
                  _Fact(
                    icon: PhosphorIconsRegular.pencilSimpleSlash,
                    title: 'Nothing is written for you',
                    body:
                        'A described press becomes a draft you review before '
                        'it is saved. Answers never change your log.',
                  ),
                  const SizedBox(height: FpSpace.s4),
                  Text(
                    'You are asked once. The choice is kept on this phone only.',
                    style: FpType.bodySm.copyWith(color: c.textTertiary),
                  ),
                ],
              ),
            ),
            LogActionBar(
              children: <Widget>[
                LogActionButton(
                  label: 'I AGREE',
                  onPressed: () async {
                    await ref.read(aiConsentProvider.notifier).grant();
                    if (!context.mounted) return;
                    final target = next;
                    if (target == null) {
                      context.pop();
                    } else {
                      context.pushReplacement(target);
                    }
                  },
                ),
                const SizedBox(height: FpSpace.s3),
                LogActionButton(
                  label: 'NOT NOW',
                  tone: LogActionTone.secondary,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: FpSpace.s5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: FpSpace.s1),
            child: PhosphorIcon(icon, size: FpIconSize.md, color: c.textBrand),
          ),
          const SizedBox(width: FpSpace.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: FpType.labelLg.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: FpSpace.s1),
                Text(
                  body,
                  style: FpType.bodySm.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The consent screen's `next` parameter is an [FpScreen] path; anything
/// else is dropped so a crafted link cannot bounce through consent to an
/// arbitrary location.
String? aiConsentNext(String? raw) {
  if (raw == null) return null;
  return FpScreen.values.any((s) => s.path == raw) ? raw : null;
}

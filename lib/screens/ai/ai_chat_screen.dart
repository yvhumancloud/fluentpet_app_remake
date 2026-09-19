/// `AI_CHAT` — no RN original. PRD §12.4.
///
/// A thread with the model over `POST /ai/chat`. The model answers from the
/// Household's own log through two server-side tools and is told to say so
/// when a question is outside it; the screen's job is to make the thread
/// readable, keep the composer honest about the caps, and have a state for
/// every way a turn can fail.
///
/// ## Three states the composer can be in
///
/// * Ready — the caret, and the count of turns left today once known.
/// * Unavailable — the server has no key or the route is not deployed. The
///   composer stays, greyed, under a sentence that says the feature is off
///   rather than broken (PRD: *"the app must work fully without it"*).
/// * Rate limited — 30 turns a day. The sentence names the cap and the
///   composer waits.
///
/// Suggested questions on the empty state are the two shapes the PRD's tools
/// answer well: a summary over a window, and a pattern in one word.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/api/ai_client.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../hardware/hardware_ui.dart' show HardwareNotice;
import '../log/log_controls.dart';
import 'ai_state.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final content = (text ?? _input.text).trim();
    if (content.isEmpty) return;
    _input.clear();
    ref.read(aiChatProvider.notifier).send(content);
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: FpDuration.base,
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final chat = ref.watch(aiChatProvider);
    ref.listen(aiChatProvider, (_, next) => _scrollToEnd());
    final blocked =
        chat.failure == AiFailure.unavailable ||
        chat.failure == AiFailure.rateLimited;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Ask FluentPet',
              subtitle: chat.remainingToday == null
                  ? 'ANSWERS FROM YOUR OWN LOG'
                  : '${chat.remainingToday} QUESTIONS LEFT TODAY',
              onBack: context.canPop() ? () => context.pop() : null,
              trailing: chat.messages.isEmpty
                  ? null
                  : LogHeaderIconButton(
                      icon: PhosphorIconsRegular.broom,
                      semanticLabel: 'Start a new conversation',
                      onTap: () => ref.read(aiChatProvider.notifier).clear(),
                    ),
            ),
            Expanded(
              child: chat.messages.isEmpty
                  ? _Suggestions(onPick: _send)
                  : ListView(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(
                        FpSpace.s6,
                        FpSpace.s3,
                        FpSpace.s6,
                        FpSpace.s5,
                      ),
                      children: <Widget>[
                        for (final m in chat.messages) _Bubble(message: m),
                        if (chat.pending) const _Thinking(),
                        if (chat.failure != null)
                          _FailureLine(
                            failure: chat.failure!,
                            onRetry: () =>
                                ref.read(aiChatProvider.notifier).retry(),
                          ),
                      ],
                    ),
            ),
            _Composer(
              controller: _input,
              enabled: !chat.pending && !blocked,
              hint: switch (chat.failure) {
                AiFailure.unavailable => 'Not available right now',
                AiFailure.rateLimited => 'Back tomorrow',
                _ => 'Ask about your Learner…',
              },
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── empty state ───────────────────────────

class _Suggestions extends ConsumerWidget {
  const _Suggestions({required this.onPick});

  final void Function(String) onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final learner = (ref.watch(pushersProvider).value ?? const <Pusher>[])
        .where((p) => p.isLearner && !p.isHidden)
        .firstOrNull;
    final name = learner?.name ?? 'your Learner';
    final prompts = <String>[
      'What did $name say most this week?',
      'When does $name usually ask for outside?',
      'Summarise the last few days.',
      'Which new words has $name tried this month?',
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s4,
        FpSpace.s6,
        FpSpace.s5,
      ),
      children: <Widget>[
        Text(
          'Ask anything the log can answer',
          style: FpType.headingSm.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: FpSpace.s2),
        Text(
          'Counts, patterns, first words, what a day looked like. It reads '
          'only your Household’s presses and never makes one up.',
          style: FpType.bodySm.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: FpSpace.s5),
        for (final p in prompts)
          Padding(
            padding: const EdgeInsets.only(bottom: FpSpace.s3),
            child: _PromptChip(text: p, onTap: () => onPick(p)),
          ),
      ],
    );
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Material(
      color: c.surfaceRaised,
      borderRadius: BorderRadius.circular(FpRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(FpRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FpSpace.s4,
            vertical: FpSpace.s4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FpRadius.lg),
            border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
          ),
          child: Row(
            children: <Widget>[
              PhosphorIcon(
                PhosphorIconsRegular.sparkle,
                size: FpIconSize.sm,
                color: c.textBrand,
              ),
              const SizedBox(width: FpSpace.s3),
              Expanded(
                child: Text(
                  text,
                  style: FpType.bodyMd.copyWith(color: c.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── the thread ───────────────────────────

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final AiMessage message;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final mine = message.role == AiRole.user;
    return Padding(
      padding: const EdgeInsets.only(bottom: FpSpace.s3),
      child: Row(
        mainAxisAlignment: mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!mine) ...<Widget>[
            const _Sparkle(),
            const SizedBox(width: FpSpace.s3),
          ],
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.symmetric(
                horizontal: FpSpace.s4,
                vertical: FpSpace.s3,
              ),
              decoration: BoxDecoration(
                color: mine ? c.surfaceTint : c.surfaceRaised,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(FpRadius.lg),
                  topRight: const Radius.circular(FpRadius.lg),
                  bottomLeft: Radius.circular(mine ? FpRadius.lg : FpRadius.sm),
                  bottomRight: Radius.circular(
                    mine ? FpRadius.sm : FpRadius.lg,
                  ),
                ),
                border: mine
                    ? null
                    : Border.all(
                        color: c.borderSubtle,
                        width: FpStroke.hairline,
                      ),
              ),
              child: SelectableText(
                message.content,
                style: FpType.bodyMd.copyWith(color: c.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle();

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: c.surfaceTint, shape: BoxShape.circle),
      child: Center(
        child: PhosphorIcon(
          PhosphorIconsRegular.sparkle,
          size: FpIconSize.sm,
          color: c.textBrand,
        ),
      ),
    );
  }
}

class _Thinking extends StatelessWidget {
  const _Thinking();

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: FpSpace.s3),
      child: Row(
        children: <Widget>[
          const _Sparkle(),
          const SizedBox(width: FpSpace.s3),
          Text(
            'Reading the log…',
            style: FpType.bodySm.copyWith(color: c.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _FailureLine extends StatelessWidget {
  const _FailureLine({required this.failure, required this.onRetry});

  final AiFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final (title, body, retry) = switch (failure) {
      AiFailure.unavailable => (
        'Not available right now',
        'Asking questions is switched off on the server at the moment. '
            'Everything else works as usual.',
        false,
      ),
      AiFailure.rateLimited => (
        'That’s the 30 questions for today',
        'The limit resets over the next 24 hours.',
        false,
      ),
      AiFailure.other => (
        'No answer came back',
        'Check the connection and try the same question again.',
        true,
      ),
    };
    return Padding(
      padding: const EdgeInsets.only(top: FpSpace.s2),
      child: HardwareNotice(
        icon: PhosphorIconsRegular.warningCircle,
        title: title,
        body: body,
        action: retry
            ? LogTextAction(label: 'Try again', onTap: onRetry)
            : null,
      ),
    );
  }
}

// ─────────────────────────── the composer ───────────────────────────

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.enabled,
    required this.hint,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool enabled;
  final String hint;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s5,
        FpSpace.s3,
        FpSpace.s3,
        FpSpace.s3,
      ),
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        border: Border(
          top: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              maxLength: aiMaxMessageChars,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              style: FpType.bodyMd.copyWith(color: c.textPrimary),
              cursorColor: c.textBrand,
              decoration: InputDecoration(
                isDense: true,
                counterText: '',
                border: InputBorder.none,
                hintText: hint,
                hintStyle: FpType.bodyMd.copyWith(color: c.textTertiary),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: FpSpace.s3,
                ),
              ),
            ),
          ),
          const SizedBox(width: FpSpace.s2),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final ready = enabled && value.text.trim().isNotEmpty;
              return Semantics(
                button: true,
                label: 'Send',
                child: ExcludeSemantics(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: ready ? onSend : null,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ready
                            ? c.actionPrimaryBg
                            : c.actionPrimaryBgDisabled,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: PhosphorIcon(
                          PhosphorIconsBold.arrowUp,
                          size: FpIconSize.md,
                          color: ready
                              ? c.actionPrimaryFg
                              : c.actionPrimaryFgDisabled,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

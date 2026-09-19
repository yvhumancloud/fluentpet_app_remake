/// `AI_LOG_TEXT` — no RN original. PRD §12.5.
///
/// One sentence in, one draft out. *"Rex pressed outside then play, we went
/// to the park around 8"* goes to `POST /ai/log-text`; what comes back is
/// ids — Pusher, Buttons in press order, Contexts, a time, a note — and the
/// words the model heard that are not on the Board.
///
/// ## Why the draft is reviewed on `LOG_DETAILS`, not here
///
/// The PRD is explicit that nothing is written: *"the app shows it, the user
/// confirms, the app calls POST /interactions"*. `LOG_DETAILS` is already the
/// screen that shows a draft with every field editable and saves it, so
/// "confirm" is that screen with the draft seeded — the same path a tapped
/// Board takes. This screen shows the draft as it will appear, names the
/// unmatched words, and hands over. A second review form would be a second
/// place for the rules about Contexts and Teachers to drift.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/api/ai_client.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../hardware/hardware_ui.dart' show HardwareNotice;
import '../log/log_controls.dart';
import '../log/log_state.dart';

class AiLogTextScreen extends ConsumerStatefulWidget {
  const AiLogTextScreen({super.key});

  @override
  ConsumerState<AiLogTextScreen> createState() => _AiLogTextScreenState();
}

class _AiLogTextScreenState extends ConsumerState<AiLogTextScreen> {
  final TextEditingController _text = TextEditingController();
  bool _pending = false;
  AiDraft? _draft;
  Interaction? _preview;
  AiFailure? _failure;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _draftIt() async {
    final text = _text.text.trim();
    if (text.isEmpty || _pending) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _pending = true;
      _failure = null;
      _draft = null;
      _preview = null;
    });
    try {
      final draft = await ref.read(aiClientProvider).logText(text);
      if (!mounted) return;
      setState(() {
        _draft = draft;
        _preview = _resolve(draft);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _failure = AiFailure.of(e));
    } finally {
      if (mounted) setState(() => _pending = false);
    }
  }

  /// Ids → the domain objects the Log draft holds. A Pusher the model did
  /// not name is the first Learner, which is what `LOG` pre-selects too.
  Interaction? _resolve(AiDraft draft) {
    final pushers = ref.read(pushersProvider).value ?? const <Pusher>[];
    final board = ref.read(boardProvider).value?.buttons ?? const <Button>[];
    final contexts =
        ref.read(allContextsProvider).value ?? const <InteractionContext>[];
    final pusher =
        pushers.where((p) => p.id == draft.pusherId).firstOrNull ??
        pushers.where((p) => p.isLearner && !p.isHidden).firstOrNull;
    if (pusher == null) return null;
    return Interaction(
      id: 0,
      interactionId: 0,
      occurredAt: draft.occurredAt ?? DateTime.now(),
      pusher: pusher,
      buttons: <Button>[
        for (final id in draft.buttonIds)
          ?board.where((b) => b.id == id).firstOrNull,
      ],
      contexts: <InteractionContext>[
        for (final id in draft.contextIds)
          ?contexts.where((x) => x.id == id).firstOrNull,
      ],
      origin: InteractionOrigin.app,
      note: draft.note ?? '',
    );
  }

  /// Seeds the Log draft and opens `LOG_DETAILS`, where SAVE is the POST.
  void _review(Interaction preview) {
    ref.read(logDraftProvider.notifier)
      ..startFrom(preview)
      ..setNote(preview.note);
    context.pushReplacement(FpScreen.logDetails.path);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    // Loaded here so the draft resolves against them the moment it arrives.
    ref.watch(pushersProvider);
    ref.watch(boardProvider);
    ref.watch(allContextsProvider);
    final draft = _draft;
    final preview = _preview;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Describe a press',
              subtitle: 'IN YOUR OWN WORDS',
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
                  Text(
                    'Say who pressed what, and when. Words that are on the '
                    'Board become presses; the rest becomes the note.',
                    style: FpType.bodySm.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: FpSpace.s4),
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: LogMetrics.noteMinHeight,
                    ),
                    padding: const EdgeInsets.all(FpSpace.s4),
                    decoration: BoxDecoration(
                      color: c.surfaceSunken,
                      borderRadius: BorderRadius.circular(FpRadius.md),
                      border: Border.all(
                        color: c.borderSubtle,
                        width: FpStroke.hairline,
                      ),
                    ),
                    child: TextField(
                      controller: _text,
                      enabled: !_pending,
                      maxLines: null,
                      maxLength: aiMaxLogTextChars,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      style: FpType.bodyMd.copyWith(color: c.textPrimary),
                      cursorColor: c.textBrand,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText:
                            'Otis pressed outside then play, we went to '
                            'the park around 8',
                        hintStyle: FpType.bodyMd.copyWith(
                          color: c.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  if (_pending) ...<Widget>[
                    const SizedBox(height: FpSpace.s5),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: FpIconSize.sm,
                          height: FpIconSize.sm,
                          child: CircularProgressIndicator(
                            strokeWidth: FpStroke.thick,
                            color: c.textBrand,
                          ),
                        ),
                        const SizedBox(width: FpSpace.s3),
                        Text(
                          'Working out the presses…',
                          style: FpType.bodySm.copyWith(color: c.textTertiary),
                        ),
                      ],
                    ),
                  ],
                  if (_failure != null) ...<Widget>[
                    const SizedBox(height: FpSpace.s5),
                    _Failure(failure: _failure!),
                  ],
                  if (draft != null) ...<Widget>[
                    const SizedBox(height: FpSpace.s6),
                    _DraftCard(draft: draft, preview: preview),
                  ],
                ],
              ),
            ),
            LogActionBar(
              children: <Widget>[
                if (preview != null && preview.buttons.isNotEmpty) ...<Widget>[
                  LogActionButton(
                    label: 'REVIEW & SAVE',
                    onPressed: () => _review(preview),
                  ),
                  const SizedBox(height: FpSpace.s3),
                  LogActionButton(
                    label: 'TRY AGAIN',
                    tone: LogActionTone.secondary,
                    onPressed: _draftIt,
                  ),
                ] else
                  LogActionButton(
                    label: draft == null ? 'DRAFT IT' : 'TRY AGAIN',
                    onPressed: _text.text.trim().isEmpty || _pending
                        ? null
                        : _draftIt,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The draft as it will appear on the timeline, plus what the model could
/// not place.
class _DraftCard extends StatelessWidget {
  const _DraftCard({required this.draft, required this.preview});

  final AiDraft draft;
  final Interaction? preview;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final p = preview;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'As it will appear',
          style: FpType.labelMd.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: FpSpace.s3),
        if (p == null || p.buttons.isEmpty)
          HardwareNotice(
            icon: PhosphorIconsRegular.handTap,
            title: 'No presses in that',
            body: p == null
                ? 'There is no Learner in the Household to attribute a press '
                      'to yet.'
                : 'None of those words is a Button on the Board. Add the '
                      'Button first, or tap it in from the Board.',
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FpSpace.s3,
              vertical: FpSpace.s4,
            ),
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(FpRadius.lg),
              border: Border.all(
                color: c.borderSubtle,
                width: FpStroke.hairline,
              ),
            ),
            child: UtteranceRow.activity(p),
          ),
        if (draft.unmatchedWords.isNotEmpty) ...<Widget>[
          const SizedBox(height: FpSpace.s5),
          Text(
            'Not on the Board',
            style: FpType.labelMd.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: FpSpace.s2),
          Text(
            'These words sounded like Buttons but no Button says them. '
            'Create one and describe the press again.',
            style: FpType.bodySm.copyWith(color: c.textTertiary),
          ),
          const SizedBox(height: FpSpace.s3),
          Wrap(
            spacing: FpSpace.s2,
            runSpacing: FpSpace.s2,
            children: <Widget>[
              for (final word in draft.unmatchedWords)
                _UnmatchedChip(
                  word: word,
                  onCreate: () => context.push(
                    '${FpScreen.buttonAdd.path}'
                    '?prepopulatedName=${Uri.encodeComponent(word)}',
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _UnmatchedChip extends StatelessWidget {
  const _UnmatchedChip({required this.word, required this.onCreate});

  final String word;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Material(
      color: c.statusWarningBg,
      borderRadius: BorderRadius.circular(FpRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(FpRadius.md),
        onTap: onCreate,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FpSpace.s3,
            vertical: FpSpace.s2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FpRadius.md),
            border: Border.all(
              color: c.statusWarningBorder,
              width: FpStroke.hairline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                word,
                style: FpType.labelMd.copyWith(color: c.statusWarningFg),
              ),
              const SizedBox(width: FpSpace.s2),
              PhosphorIcon(
                PhosphorIconsRegular.plus,
                size: FpIconSize.sm,
                color: c.statusWarningFg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.failure});

  final AiFailure failure;

  @override
  Widget build(BuildContext context) {
    final (title, body) = switch (failure) {
      AiFailure.unavailable => (
        'Not available right now',
        'Describing a press is switched off on the server at the moment. '
            'Tapping it in from the Board works as usual.',
      ),
      AiFailure.rateLimited => (
        'That’s the 50 for today',
        'The limit resets over the next 24 hours.',
      ),
      AiFailure.other => (
        'Nothing came back',
        'Check the connection and try again.',
      ),
    };
    return HardwareNotice(
      icon: PhosphorIconsRegular.warningCircle,
      title: title,
      body: body,
    );
  }
}

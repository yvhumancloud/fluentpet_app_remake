/// `LOG_DETAILS` — annotate the entry, then save it.
///
/// ## What this screen actually is
///
/// Not the detail view of a saved Interaction. `LOG_DETAILS` is
/// `src/Home/LogDetails/LogDetailsNewScreen.tsx` (392 lines) and it **creates**
/// one: it is step two of the manual-logging flow, reached from `LOG`'s LOG
/// EVENT, from the Activity FAB's "Add Journal Entry", and from Duplicate on a
/// timeline row — which GETs the original and pre-fills everything, timestamp
/// included (`DashboardList.tsx:244-274`). Its actions are SAVE EVENT and SAVE
/// EVENT & LOG ANOTHER; it POSTs.
///
/// The screen that opens when you tap a row on the timeline is a **different**
/// one: `LOG_ENTRY_EDIT`, `src/Home/LogDetails/LogDetailsEditScreen.tsx`
/// (619 lines), registered in a different navigator, which GETs an existing
/// Interaction by id, tracks a dirty flag and PATCHes. It is out of scope for
/// this pass.
///
/// The two are easy to confuse because they share almost every child — the
/// avatar, the Contexts block, the Notes field, the date-and-time row — and
/// because one file is named `LogDetailsNewScreen` and the other
/// `LogDetailsEditScreen` while the *screens* are called `LOG_DETAILS` and
/// `LOG_ENTRY_EDIT`. The distinction that matters is create versus update, and
/// this file is create.
///
/// ## The one structural idea
///
/// The entry is previewed with the **same `UtteranceRow` the timeline uses**.
/// Job 1 is "check what my dog said today", and the surface that reads it and
/// the surface that writes it should not render the same facts twice in two
/// ways that can drift. `LogDraft.preview` hands over a real [Activity]; the
/// row does the rest, first-time underline, press boundaries, flag and all.
///
/// ## Fields, from the RN screen
///
/// * Pusher — avatar and name, tappable, **suppressed for the event-note
///   Pusher** (`:286`).
/// * The presses — editable, which in the RN screen they are only when
///   duplicating (`:89`, `:297`). See the note on `_EditPresses`.
/// * Contexts — a checklist keyed to the Pusher's type, with "Modeled"
///   auto-selected for a Teacher and removed again on the way back to a
///   Learner.
/// * "Choose learners involved" — Teachers only; the modelling attribution.
/// * Note — free text.
/// * Timestamp — date, time and a separate two-digit seconds field, never in
///   the future.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import 'log_controls.dart';
import 'log_state.dart';

class LogDetailsScreen extends ConsumerStatefulWidget {
  const LogDetailsScreen({super.key});

  @override
  ConsumerState<LogDetailsScreen> createState() => _LogDetailsScreenState();
}

class _LogDetailsScreenState extends ConsumerState<LogDetailsScreen> {
  late final TextEditingController _note;
  late final TextEditingController _seconds;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(logDraftProvider);
    _note = TextEditingController(text: draft.note);
    // Empty rather than "00" when the seconds are zero, which is what the RN
    // field does (`DateAndTime.tsx:36-40`): a placeholder reads as "not set",
    // and a press logged by hand rarely has a meaningful second. Anything else
    // is two digits — through `FpFormat.pad2`, which is the same padding the
    // clock strings use. This field used to interpolate the raw integer, which
    // put a bare "7" in a column measured for "07".
    _seconds = TextEditingController(
      text: draft.occurredAt.second == 0
          ? ''
          : FpFormat.pad2(draft.occurredAt.second),
    );
  }

  @override
  void dispose() {
    _note.dispose();
    _seconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final draft = ref.watch(logDraftProvider);
    final pushers = ref.watch(pushersProvider);
    final now = DateTime.now();

    final hasDraft = draft.pusher != null;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Log details',
              // The exact moment being logged, seconds included: this screen
              // is the one place a second can be set, so it is the one place
              // that has to show one. Everything that reads a timeline drops to
              // `FpFormat.timeOfDay`.
              subtitle: hasDraft
                  ? '${FpFormat.fullDate(draft.occurredAt, asOf: now)} · '
                      '${FpFormat.timeOfDayWithSeconds(draft.occurredAt)}'
                  : null,
              onBack: context.canPop() ? () => context.pop() : null,
              // The one trailing control, and the only place the unflagged
              // state of the marker is ever drawn: `FlagMarker.control` exists
              // for exactly this position.
              trailing: hasDraft
                  ? FlagMarker.control(
                      flagged: draft.isFlagged,
                      onTap: () =>
                          ref.read(logDraftProvider.notifier).toggleFlag(),
                    )
                  : null,
            ),
            Expanded(
              child: hasDraft
                  ? _Body(
                      draft: draft,
                      pushers: pushers.value ?? const <Pusher>[],
                      note: _note,
                      seconds: _seconds,
                    )
                  : const _NoDraft(),
            ),
            if (hasDraft)
              _Actions(
                draft: draft,
                onCleared: () {
                  _note.clear();
                  _seconds.clear();
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Reached with nothing to annotate — a cold deep link to
/// `/…/log_details_nav/event_add`, or a return after the draft was saved.
///
/// Its own sentence, not the timeline's "You don't have any logs yet". This is
/// the fourth of the five distinct empties across the two Log screens, and the
/// one the old app could not have had at all: the RN screen would have crashed
/// on the missing navigation param.
class _NoDraft extends StatelessWidget {
  const _NoDraft();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
      child: Align(
        alignment: Alignment.topLeft,
        child: LogEmptyState(
          icon: PhosphorIconsRegular.notePencil,
          title: 'Nothing to log yet',
          message: 'This screen annotates a press before it is saved. Start '
              'from Log and tap the Buttons that were pressed.',
          actionLabel: 'Go to Log',
          onAction: () => context.go(FpScreen.log.path),
        ),
      ),
    );
  }
}

// ─────────────────────────── body ───────────────────────────

class _Body extends ConsumerWidget {
  const _Body({
    required this.draft,
    required this.pushers,
    required this.note,
    required this.seconds,
  });

  final LogDraft draft;
  final List<Pusher> pushers;
  final TextEditingController note;
  final TextEditingController seconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learners = logLearners(pushers);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s0,
        FpSpace.s6,
        FpSpace.s8,
      ),
      children: <Widget>[
        _Preview(draft: draft),
        if (!draft.isJournal) ...<Widget>[
          const SizedBox(height: FpSpace.s2),
          const _EditPresses(),
        ],
        const SizedBox(height: FpSpace.s6),
        const LogHairline(),
        const SizedBox(height: FpSpace.s5),
        _PusherField(draft: draft),
        if (!draft.isJournal) ...<Widget>[
          const SizedBox(height: FpSpace.s5),
          _ContextsField(draft: draft),
        ],
        if (draft.isTeacher) ...<Widget>[
          const SizedBox(height: FpSpace.s5),
          _ModeledLearners(draft: draft, learners: learners),
        ],
        const SizedBox(height: FpSpace.s5),
        _NoteField(controller: note),
        const SizedBox(height: FpSpace.s5),
        _TimestampField(draft: draft, seconds: seconds),
      ],
    );
  }
}

/// The entry, drawn by the widget the timeline draws it with.
class _Preview extends StatelessWidget {
  const _Preview({required this.draft});

  final LogDraft draft;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final activity = draft.preview;
    if (activity == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'As it will appear',
          style: FpType.labelSm.copyWith(color: c.textTertiary),
        ),
        const SizedBox(height: FpSpace.s3),
        Container(
          padding: const EdgeInsets.all(FpSpace.s5),
          decoration: BoxDecoration(
            color: c.surfaceRaised,
            borderRadius: BorderRadius.circular(FpRadius.lg),
            border: Border.all(
              color: c.borderSubtle,
              width: FpStroke.hairline,
            ),
          ),
          child: UtteranceRow.activity(activity),
        ),
      ],
    );
  }
}

/// Go back and change what was pressed.
///
/// The RN screen passes `onButtonPress` to its chips **only when duplicating**
/// (`LogDetailsNewScreen.tsx:89`, `:297`), so arriving here from `LOG` with the
/// wrong Button leaves no way to fix it short of backing out. That is a defect,
/// not a capability, and it is not reproduced.
///
/// Where it goes depends on what is underneath. Coming from `LOG` — the normal
/// path — the composer is one pop away and already holds the draft, so it pops
/// to it rather than opening a second editor of the same thing. Arriving any
/// other way (a duplicate, a deep link) there is nothing below, and it pushes
/// `LOG_DETAILS_EDIT_BUTTONS`, the RN destination, which this pass does not
/// build and which resolves to the placeholder.
class _EditPresses extends StatelessWidget {
  const _EditPresses();

  @override
  Widget build(BuildContext context) {
    return LogTextAction(
      label: 'Edit the presses',
      icon: PhosphorIconsRegular.pencilSimple,
      onTap: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.push(FpScreen.logDetailsEditButtons.path);
        }
      },
    );
  }
}

/// Who it is attributed to.
///
/// Tapping opens `LOG_DETAILS_EDIT_PUSHER` — suppressed for the event-note
/// Pusher, which is not a member and cannot be reassigned (`:286`).
class _PusherField extends StatelessWidget {
  const _PusherField({required this.draft});

  final LogDraft draft;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final pusher = draft.pusher!;
    final journal = draft.isJournal;

    return LogSelectRow(
      label: journal ? 'Entry' : 'Pusher',
      onTap: journal
          ? null
          : () => context.push(FpScreen.logDetailsEditPusher.path),
      child: Row(
        children: <Widget>[
          PusherAvatar(pusher: pusher, size: PusherAvatarSize.lg),
          const SizedBox(width: FpSpace.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  // The RN screen shows the name only for a human or animal
                  // Pusher (`:288-292`); "event note" and "base" are wire
                  // sentinels, not something to put on screen. A duplicate of
                  // an unattributed press arrives here carrying the second of
                  // those, which is the whole reason this switches on the kind
                  // rather than asking whether the Pusher is a Learner.
                  switch (pusher.kind) {
                    PusherKind.eventNote => 'Journal entry',
                    PusherKind.base => 'Nobody attributed',
                    PusherKind.learner || PusherKind.teacher => pusher.name,
                  },
                  style: FpType.headingSm.copyWith(color: c.textPrimary),
                ),
                Text(
                  switch (pusher.kind) {
                    PusherKind.eventNote => 'A note with no press behind it',
                    PusherKind.base => 'Choose who pressed',
                    PusherKind.learner => 'Learner',
                    PusherKind.teacher => 'Teacher',
                  },
                  style: FpType.labelMd.copyWith(color: c.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The Contexts tagged on the entry, and the checklist that changes them.
///
/// Two departures from the RN screen, both recorded:
///
/// * The "Add Context" link is shown for a **Teacher** too. The RN screen hides
///   it (`showAddContext={!selectedPusher?.is_human}`, `:304`), which leaves a
///   Teacher's entry showing one auto-selected chip and no way to touch it. The
///   auto-selection is kept; the dead end is not.
/// * The checklist is an in-app sheet rather than a modal over a modal.
class _ContextsField extends ConsumerWidget {
  const _ContextsField({required this.draft});

  final LogDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = draft.isTeacher
        ? logContexts(ref.watch(logTeacherContextsProvider))
        : logContexts(ref.watch(logLearnerContextsProvider));

    return LogSection(
      title: 'Contexts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Empty renders nothing — no placeholder and no empty chip row. An
          // untagged Interaction is normal, not incomplete.
          ContextList.of(draft.contexts),
          LogTextAction(
            label: 'Add Context',
            icon: PhosphorIconsRegular.plus,
            onTap: () => _open(context, available),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, List<InteractionContext> available) {
    // Colour and shape come from `bottomSheetTheme`; see [showLogSheet].
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      // Scroll-controlled sheets may grow past half the viewport; without this
      // a long list runs under the status bar.
      useSafeArea: true,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Consumer(
          builder: (consumerContext, ref, _) {
            final selected = ref.watch(logDraftProvider).contexts;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FpSpace.s6,
                    FpSpace.s6,
                    FpSpace.s6,
                    FpSpace.s3,
                  ),
                  child: Text(
                    'What was going on?',
                    style: FpType.labelSm.copyWith(
                      color: sheetContext.fpColors.textTertiary,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      for (final ctx in available)
                        LogCheckRow(
                          label: ctx.text,
                          selected: selected.any((s) => s.id == ctx.id),
                          onTap: () => ref
                              .read(logDraftProvider.notifier)
                              .toggleContext(ctx),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: FpSpace.s4),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// "Choose learners involved" — the modelling attribution, Teachers only.
///
/// Multi-select, and drawn as one, because the Pusher strip's single-select
/// idiom (a rule under the chosen one) would be a lie here. Selection is the
/// same weight change the sheets use: `circle` → filled `check-circle`.
class _ModeledLearners extends ConsumerStatefulWidget {
  const _ModeledLearners({required this.draft, required this.learners});

  final LogDraft draft;
  final List<Pusher> learners;

  @override
  ConsumerState<_ModeledLearners> createState() => _ModeledLearnersState();
}

class _ModeledLearnersState extends ConsumerState<_ModeledLearners> {
  @override
  void initState() {
    super.initState();
    // A Household with exactly one Learner attributes the modelling to them
    // without being asked (`LogDetailsNewScreen.tsx:93-99`). Done once, after
    // the frame, so it never mutates a provider during a build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(logDraftProvider.notifier).adoptSoleLearner(widget.learners);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final selected = ref.watch(logDraftProvider).modeledPushers;

    if (widget.learners.isEmpty) {
      return LogSection(
        title: 'Learners involved',
        child: Text(
          'No Learners in this Household yet.',
          style: FpType.bodySm.copyWith(color: c.textTertiary),
        ),
      );
    }

    return LogSection(
      title: 'Learners involved',
      child: Column(
        children: <Widget>[
          for (final learner in widget.learners)
            _LearnerCheck(
              learner: learner,
              selected: selected.any((p) => p.id == learner.id),
              onTap: () => ref
                  .read(logDraftProvider.notifier)
                  .toggleModeledPusher(learner),
            ),
        ],
      ),
    );
  }
}

class _LearnerCheck extends StatelessWidget {
  const _LearnerCheck({
    required this.learner,
    required this.selected,
    required this.onTap,
  });

  final Pusher learner;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      label: learner.name,
      checked: selected,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: LogMetrics.tapTarget),
            child: Row(
              children: <Widget>[
                PusherAvatar(pusher: learner, size: PusherAvatarSize.md),
                const SizedBox(width: FpSpace.s4),
                Expanded(
                  child: Text(
                    learner.name,
                    style: FpType.bodyMd.copyWith(
                      color: selected ? c.textPrimary : c.textSecondary,
                    ),
                  ),
                ),
                PhosphorIcon(
                  selected
                      ? PhosphorIconsFill.checkCircle
                      : PhosphorIconsRegular.circle,
                  size: FpIconSize.md,
                  color: selected ? c.textBrand : c.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Free text on the entry.
///
/// A filled sunken box rather than the timeline's `NoteBlock`, which is a left
/// rule and is read-only. An input has to look like somewhere to type; 120 is
/// the RN field's minimum height and is four lines of body type, so it reads as
/// somewhere to write prose rather than a word.
class _NoteField extends ConsumerWidget {
  const _NoteField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    return LogSection(
      title: 'Note',
      child: Container(
        constraints: const BoxConstraints(minHeight: LogMetrics.noteMinHeight),
        padding: const EdgeInsets.all(FpSpace.s4),
        decoration: BoxDecoration(
          color: c.surfaceSunken,
          borderRadius: BorderRadius.circular(FpRadius.md),
          border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
        ),
        child: TextField(
          controller: controller,
          onChanged: (value) =>
              ref.read(logDraftProvider.notifier).setNote(value),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: FpType.bodyMd.copyWith(color: c.textPrimary),
          cursorColor: c.textBrand,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            hintText: 'Write a note',
            hintStyle: FpType.bodyMd.copyWith(color: c.textTertiary),
          ),
        ),
      ),
    );
  }
}

/// When the press happened.
///
/// Date, time and a separate two-digit seconds field, exactly as the RN row
/// splits them (`src/components/LogEntryEdit/DateAndTime.tsx`). The split is
/// kept because it is how a seconds value is entered at all — no platform time
/// picker offers them — and because it means every displayed string comes
/// straight from `FpFormat` with nothing new to write.
///
/// Nothing here can be set in the future. The date picker's `lastDate` stops
/// the calendar; the time picker cannot, so a time later than now on today's
/// date is refused with a sentence rather than silently snapped.
class _TimestampField extends ConsumerWidget {
  const _TimestampField({required this.draft, required this.seconds});

  final LogDraft draft;
  final TextEditingController seconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final now = DateTime.now();

    return LogSection(
      title: 'Timestamp',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LogSelectRow(
            label: 'Date',
            icon: PhosphorIconsRegular.calendarBlank,
            onTap: () => _pickDate(context, ref),
            child: Text(
              FpFormat.fullDate(draft.occurredAt, asOf: now),
              style: FpType.bodyMd.copyWith(color: c.textPrimary),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: LogSelectRow(
                  label: 'Time',
                  icon: PhosphorIconsRegular.clock,
                  onTap: () => _pickTime(context, ref),
                  child: Text(
                    FpFormat.timeOfDay(draft.occurredAt),
                    style: FpType.bodyMd.copyWith(color: c.textPrimary).tabular,
                  ),
                ),
              ),
              const SizedBox(width: FpSpace.s6),
              _SecondsField(controller: seconds),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: draft.occurredAt.isAfter(now) ? now : draft.occurredAt,
      firstDate: DateTime(now.year - _yearsBack),
      lastDate: now,
    );
    if (picked == null || !context.mounted) return;

    final at = DateTime(
      picked.year,
      picked.month,
      picked.day,
      draft.occurredAt.hour,
      draft.occurredAt.minute,
      draft.occurredAt.second,
    );
    _apply(context, ref, at);
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(draft.occurredAt),
      // 24-hour, because every time in the design system is drawn 24-hour and
      // `FpFormat.timeOfDay` produces nothing else. The RN app read the device
      // preference; phase 1 does not (see `fp_format.dart`).
      builder: (pickerContext, child) => MediaQuery(
        data: MediaQuery.of(pickerContext).copyWith(alwaysUse24HourFormat: true),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (picked == null || !context.mounted) return;

    final at = DateTime(
      draft.occurredAt.year,
      draft.occurredAt.month,
      draft.occurredAt.day,
      picked.hour,
      picked.minute,
      draft.occurredAt.second,
    );
    _apply(context, ref, at);
  }

  void _apply(BuildContext context, WidgetRef ref, DateTime at) {
    final accepted = ref
        .read(logDraftProvider.notifier)
        .setOccurredAt(at, now: DateTime.now());
    if (!accepted) {
      logSay(context, 'A press cannot be logged in the future.');
    }
  }

  /// How far back the date picker opens. Five years covers any Board's history
  /// and keeps the calendar from scrolling to 1970.
  static const int _yearsBack = 5;
}

class _SecondsField extends ConsumerWidget {
  const _SecondsField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;

    return SizedBox(
      width: LogMetrics.secondsFieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Seconds',
            style: FpType.labelSm.copyWith(color: c.textTertiary),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: LogMetrics.tapTarget),
            child: Center(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                onChanged: (value) => _onChanged(ref, value),
                style: FpType.bodyMd.copyWith(color: c.textPrimary).tabular,
                cursorColor: c.textBrand,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: '00',
                  hintStyle: FpType.bodyMd.copyWith(color: c.textTertiary),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: FpSpace.s3,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: c.borderDefault,
                      width: FpStroke.hairline,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: c.borderFocus,
                      width: FpStroke.thick,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Digits only and never above 59, which the RN field enforces by hand
  /// (`DateAndTime.tsx:43-55`). Empty means zero.
  void _onChanged(WidgetRef ref, String value) {
    final parsed = int.tryParse(value) ?? 0;
    if (parsed > _maxSeconds) {
      final clamped = FpFormat.pad2(_maxSeconds);
      controller.value = TextEditingValue(
        text: clamped,
        // The caret goes to the end of the text the field now holds, not to a
        // measured position.
        selection: TextSelection.collapsed(offset: clamped.length),
      );
    }
    ref.read(logDraftProvider.notifier).setSeconds(parsed);
  }

  /// The last second of a minute.
  static const int _maxSeconds = 59;
}

// ─────────────────────────── the action bar ───────────────────────────

class _Actions extends ConsumerWidget {
  const _Actions({required this.draft, required this.onCleared});

  final LogDraft draft;

  /// Called after SAVE EVENT & LOG ANOTHER empties the draft, so the note and
  /// seconds fields let go of text that no longer belongs to anything.
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The RN screen has no client-side validation at all: its only guard is a
    // missing-board check that logs to the console and returns, leaving the
    // user staring at a button that did nothing (`:159-164`). A press with no
    // Buttons and a journal entry with no words are both nothing to save, and
    // the control says so instead.
    final canSave = !draft.isEmpty;

    return LogActionBar(
      children: <Widget>[
        LogActionButton(
          label: 'Save event',
          onPressed: canSave ? () => _save(context, ref) : null,
        ),
        // Hidden for a journal entry, as in the RN screen: there is no "log
        // another" when the flow you would return to logs presses.
        if (!draft.isJournal)
          LogActionButton(
            label: 'Save event & log another',
            tone: LogActionTone.secondary,
            onPressed: canSave ? () => _saveAndLogAnother(context, ref) : null,
          ),
      ],
    );
  }

  /// SAVE EVENT → POST, then the Activity timeline (`:190-200`).
  ///
  /// Phase 1 has no POST. The inventory's instruction for every write is a
  /// no-op that returns success (§15), and the honest version of that says so
  /// rather than letting someone hunt the timeline for an entry that was never
  /// stored.
  void _save(BuildContext context, WidgetRef ref) {
    ref.read(logDraftProvider.notifier).reset();
    logSay(context, 'Saved. Phase 1 stores nothing, so it will not appear on '
        'the timeline.');
    context.go(FpScreen.dashboard.path);
  }

  /// SAVE EVENT & LOG ANOTHER → POST, clear the caller's selection, back to
  /// `LOG` (`:202-210`). That clearing is the `onReturn(true)` callback the RN
  /// app passes through navigation params; here it is a method on the notifier
  /// both screens already share.
  void _saveAndLogAnother(BuildContext context, WidgetRef ref) {
    final available = draft.isTeacher
        ? logContexts(ref.read(logTeacherContextsProvider))
        : logContexts(ref.read(logLearnerContextsProvider));
    ref
        .read(logDraftProvider.notifier)
        .clearComposition(availableContexts: available);
    onCleared();
    logSay(context, 'Saved. Log the next one.');
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(FpScreen.log.path);
    }
  }
}

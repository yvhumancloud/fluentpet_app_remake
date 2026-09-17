/// `LOG_ENTRY_EDIT` — correct an entry that already exists.
///
/// `src/Home/LogDetails/LogDetailsEditScreen.tsx` (619 lines), registered in
/// `LogEntryEditNavigator.tsx:49-56` as `Screen.LOG_ENTRY_EDIT`. This is the
/// screen a tap on any timeline row lands on
/// (`docs/design-system/screen-inventory.md:80`, `DashboardList.tsx:491`,
/// `:577`). It **updates**; it does not create.
///
/// The sibling `LOG_DETAILS` (`LogDetailsNewScreen.tsx`, `../log_details_
/// screen.dart`) is the create surface, and the RN filenames run the opposite
/// way round from the screen keys — `LogDetailsNewScreen` is `LOG_DETAILS`,
/// `LogDetailsEditScreen` is `LOG_ENTRY_EDIT`. Checked against both navigator
/// files before writing a line here; see `log_edit_state.dart` for the note in
/// full.
///
/// ## What is different from `LOG_DETAILS`, and why
///
/// * **The presses are always editable.** The RN create screen only wires
///   `onButtonPress` while duplicating (`LogDetailsNewScreen.tsx:297` —
///   `isDuplicatingEntry` gated); its own screen doc-comment in
///   `log_details_screen.dart` names that as a defect kept intentionally
///   ("arriving here from `LOG` with the wrong Button leaves no way to fix it
///   short of backing out"). *This* is the screen that fixes it: the edit
///   screen's `onButtonPress={onButtonPress}` is unconditional
///   (`LogDetailsEditScreen.tsx:474`), because correcting a wrong Button is
///   the whole reason a distinct edit surface exists.
/// * **Both members of [Activity] are handled**, per `domain.dart`'s note that
///   a free-standing [Note] is a wire "event note" Interaction under a
///   different name. A [Note] has no Buttons, Contexts or modelled Learners
///   to edit — the domain type has no fields for them — so
///   those sections are absent rather than shown empty, the same way they are
///   already hidden for the event-note pseudo-Pusher on the create screen.
/// * **A defect is not reproduced.** See `log_edit_state.dart`'s library note:
///   the RN screen's own "select Modeled" effect fires on page load too and
///   silently drops a saved Teacher entry's Contexts down to `["Modeled"]`
///   before anyone touches anything. This screen loads what was saved and
///   applies that rule only on an explicit re-assignment.
///
/// ## Fields kept from the RN screen
///
/// Star (flag) in the header trailing slot, Pusher avatar and name (tap to
/// re-assign, suppressed for the event-note Pusher), the presses, an
/// unassigned caption when nobody is attributed, Contexts, "Choose learners
/// involved" for a Teacher, Note, and
/// Timestamp with its separate seconds field.
///
/// ## What is out of scope, and why
///
/// PetCube — `renderPetcubeButton`, `:372-429` — is gated on a feature flag
/// this rewrite has no fixture for (`isPetCubeEnabled`, an access token that
/// does not exist in this domain) and reaches two screens
/// (`PETCUBE_VIDEOS_SCREEN`, `PETCUBE_SHOP_SCREEN`) that are not among the
/// five this pass builds. Reported, not invented.
///
/// ## The write path, deliberately absent
///
/// Phase 1 is fixtures, read-only (PLAN.md, `docs/second-pass-brief.md`).
/// SAVE is real UI with a real dirty check — [EditEntryDraftNotifier.isDirty]
/// mirrors the RN screen's own `_.isEqual(initialData, formData)`
/// (`LogDetailsEditScreen.tsx:157-168`) — but there is no PATCH behind it.
/// Tapping it says so and returns to Activity, the same honest no-op
/// `log_details_screen.dart`'s SAVE EVENT already uses for the create screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../data/providers.dart';
import '../../../domain/domain.dart';
import '../../../router/screens.g.dart';
import '../../../theme/fp_context.dart';
import '../../../theme/generated/fp_tokens.dart';
import '../../../widgets/widgets.dart';
import '../log_controls.dart';
import '../log_state.dart' show logLearners;
import 'log_edit_state.dart';

class LogEntryEditScreen extends ConsumerStatefulWidget {
  const LogEntryEditScreen({required this.activityId, super.key});

  /// From the route's `activityId` query parameter — the honest name for what
  /// a timeline row tap hands over. See `log_edit_state.dart`'s
  /// [logFindActivity] for why this is not called `interactionId`, the RN
  /// param name.
  final int? activityId;

  @override
  ConsumerState<LogEntryEditScreen> createState() => _LogEntryEditScreenState();
}

class _LogEntryEditScreenState extends ConsumerState<LogEntryEditScreen> {
  final TextEditingController _note = TextEditingController();
  final TextEditingController _seconds = TextEditingController();

  /// The activity id the controllers currently hold text for, so a keystroke
  /// rebuild does not overwrite what someone is typing.
  int? _controllersFor;

  @override
  void dispose() {
    _note.dispose();
    _seconds.dispose();
    super.dispose();
  }

  void _syncControllers(EditEntryDraft draft) {
    if (_controllersFor == draft.activityId) return;
    _controllersFor = draft.activityId;
    _note.text = draft.note;
    final at = draft.occurredAt;
    _seconds.text = (at == null || at.second == 0) ? '' : FpFormat.pad2(at.second);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(logEditDraftProvider);
    final id = widget.activityId;

    if (draft.isLoaded && (id == null || draft.activityId == id)) {
      _syncControllers(draft);
      return _loaded(context, draft);
    }

    if (id == null) {
      return _notFound(
        context,
        message: 'No entry was named. Open one from the timeline.',
      );
    }

    final activities = ref.watch(logEditableActivitiesProvider);
    return switch (activities) {
      AsyncError() => _notFound(context, message: 'Could not load this entry.'),
      AsyncData(value: final list) => _resolve(context, list, id),
      _ => _loading(context),
    };
  }

  Widget _resolve(BuildContext context, List<Activity> list, int id) {
    final found = logFindActivity(list, id);
    if (found == null) {
      return _notFound(
        context,
        message: 'That entry is not here any more. It may have been deleted, '
            'or the link that brought you here may be out of date.',
      );
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(logEditDraftProvider.notifier).loadFrom(found);
    });
    return _loading(context);
  }

  Widget _loading(BuildContext context) {
    final c = context.fpColors;
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Edit log entry',
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: FpStroke.thick,
                  color: c.textBrand,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notFound(BuildContext context, {required String message}) {
    final c = context.fpColors;
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Edit log entry',
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: LogEmptyState(
                    icon: PhosphorIconsRegular.magnifyingGlass,
                    title: 'That entry is not here any more',
                    message: message,
                    actionLabel: 'Go to Activity',
                    onAction: () => context.go(FpScreen.dashboard.path),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loaded(BuildContext context, EditEntryDraft draft) {
    final c = context.fpColors;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Edit log entry',
              subtitle: '${FpFormat.fullDate(draft.occurredAt!, asOf: now)} · '
                  '${FpFormat.timeOfDayWithSeconds(draft.occurredAt!)}',
              onBack: context.canPop() ? () => context.pop() : null,
              trailing: FlagMarker.control(
                flagged: draft.isFlagged,
                onTap: () => ref.read(logEditDraftProvider.notifier).toggleFlag(),
              ),
            ),
            Expanded(child: _Body(draft: draft, note: _note, seconds: _seconds)),
            _Actions(draft: draft),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── body ───────────────────────────

class _Body extends ConsumerWidget {
  const _Body({required this.draft, required this.note, required this.seconds});

  final EditEntryDraft draft;
  final TextEditingController note;
  final TextEditingController seconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pushers = ref.watch(pushersProvider).value ?? const <Pusher>[];
    final learners = logLearners(pushers);
    final preview = draft.preview;
    final activityId = draft.activityId!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(FpSpace.s6, FpSpace.s0, FpSpace.s6, FpSpace.s8),
      children: <Widget>[
        if (preview != null) _Preview(activity: preview),
        if (!draft.isJournal) ...<Widget>[
          const SizedBox(height: FpSpace.s2),
          _EditPresses(activityId: activityId),
        ],
        const SizedBox(height: FpSpace.s6),
        const LogHairline(),
        const SizedBox(height: FpSpace.s5),
        _PusherField(draft: draft, activityId: activityId),
        if (draft.pusher?.kind == PusherKind.base) ...<Widget>[
          const SizedBox(height: FpSpace.s3),
          const _UnassignedCaption(),
        ],
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

/// The entry, drawn by the same row the timeline draws it with — see the
/// library note on why this screen shares that idea with `LOG_DETAILS`.
class _Preview extends StatelessWidget {
  const _Preview({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('As it appears', style: FpType.labelSm.copyWith(color: c.textTertiary)),
        const SizedBox(height: FpSpace.s3),
        Container(
          padding: const EdgeInsets.all(FpSpace.s5),
          decoration: BoxDecoration(
            color: c.surfaceRaised,
            borderRadius: BorderRadius.circular(FpRadius.lg),
            border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
          ),
          child: UtteranceRow.activity(activity),
        ),
      ],
    );
  }
}

/// Always tappable — see the library note on why this differs from
/// `LOG_DETAILS`'s duplicate-only gate.
class _EditPresses extends StatelessWidget {
  const _EditPresses({required this.activityId});

  final int activityId;

  @override
  Widget build(BuildContext context) {
    return LogTextAction(
      label: 'Edit the presses',
      icon: PhosphorIconsRegular.pencilSimple,
      onTap: () => context.push(
        '${FpScreen.logEntryEditButtons.path}?activityId=$activityId',
      ),
    );
  }
}

class _PusherField extends StatelessWidget {
  const _PusherField({required this.draft, required this.activityId});

  final EditEntryDraft draft;
  final int activityId;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final pusher = draft.pusher!;
    final journal = draft.isJournal;

    return LogSelectRow(
      label: journal ? 'Entry' : 'Pusher',
      onTap: journal
          ? null
          : () => context.push(
                '${FpScreen.logEntryEditPusher.path}?activityId=$activityId',
              ),
      child: Row(
        children: <Widget>[
          PusherAvatar(pusher: pusher, size: PusherAvatarSize.lg),
          const SizedBox(width: FpSpace.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
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

/// `LogDetailsEditScreen.tsx:464-470`: shown whenever the entry has no real
/// Pusher, so re-assigning it is also how it leaves the RN app's Unassigned
/// tab. Not reachable with today's nine-entry fixture — nothing in it carries
/// the "nobody attributed" pseudo-Pusher — but the code is honest regardless
/// of which fixture rows happen to exercise it.
class _UnassignedCaption extends StatelessWidget {
  const _UnassignedCaption();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Assign a Teacher or Learner to clear this from Unassigned, and to add '
      'Context or modelled Learners.',
      textAlign: TextAlign.center,
      style: FpType.bodySm.copyWith(color: context.fpColors.textTertiary),
    );
  }
}

/// Two departures from the RN screen, both already made by `LOG_DETAILS` and
/// kept identical here: "Add Context" is offered for a Teacher too, and the
/// checklist is an in-app sheet rather than a modal over a modal.
class _ContextsField extends ConsumerWidget {
  const _ContextsField({required this.draft});

  final EditEntryDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = logEditContextsFor(ref, draft.pusher);

    return LogSection(
      title: 'Contexts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
            final selected = ref.watch(logEditDraftProvider).contexts;
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
                    style: FpType.labelSm.copyWith(color: sheetContext.fpColors.textTertiary),
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
                          onTap: () =>
                              ref.read(logEditDraftProvider.notifier).toggleContext(ctx),
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

/// "Choose learners involved" — Teachers only. No auto-adopt-the-sole-Learner
/// rule here: that is `LogDetailsNewScreen.tsx:93-99`'s rule for a fresh
/// composition, and the edit screen has no equivalent effect — an existing
/// entry's modelled set is what was saved, not a guess.
class _ModeledLearners extends ConsumerWidget {
  const _ModeledLearners({required this.draft, required this.learners});

  final EditEntryDraft draft;
  final List<Pusher> learners;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;

    if (learners.isEmpty) {
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
          for (final learner in learners)
            _LearnerCheck(
              learner: learner,
              selected: draft.modeledPushers.any((p) => p.id == learner.id),
              onTap: () =>
                  ref.read(logEditDraftProvider.notifier).toggleModeledPusher(learner),
            ),
        ],
      ),
    );
  }
}

class _LearnerCheck extends StatelessWidget {
  const _LearnerCheck({required this.learner, required this.selected, required this.onTap});

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
                  selected ? PhosphorIconsFill.checkCircle : PhosphorIconsRegular.circle,
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
          onChanged: (value) => ref.read(logEditDraftProvider.notifier).setNote(value),
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

class _TimestampField extends ConsumerWidget {
  const _TimestampField({required this.draft, required this.seconds});

  final EditEntryDraft draft;
  final TextEditingController seconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final now = DateTime.now();
    final at = draft.occurredAt!;

    return LogSection(
      title: 'Timestamp',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LogSelectRow(
            label: 'Date',
            icon: PhosphorIconsRegular.calendarBlank,
            onTap: () => _pickDate(context, ref, at),
            child: Text(
              FpFormat.fullDate(at, asOf: now),
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
                  onTap: () => _pickTime(context, ref, at),
                  child: Text(
                    FpFormat.timeOfDay(at),
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

  Future<void> _pickDate(BuildContext context, WidgetRef ref, DateTime at) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: at.isAfter(now) ? now : at,
      firstDate: DateTime(now.year - _yearsBack),
      lastDate: now,
    );
    if (picked == null || !context.mounted) return;
    final next = DateTime(picked.year, picked.month, picked.day, at.hour, at.minute, at.second);
    _apply(context, ref, next);
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref, DateTime at) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(at),
      builder: (pickerContext, child) => MediaQuery(
        data: MediaQuery.of(pickerContext).copyWith(alwaysUse24HourFormat: true),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (picked == null || !context.mounted) return;
    final next =
        DateTime(at.year, at.month, at.day, picked.hour, picked.minute, at.second);
    _apply(context, ref, next);
  }

  void _apply(BuildContext context, WidgetRef ref, DateTime at) {
    final accepted =
        ref.read(logEditDraftProvider.notifier).setOccurredAt(at, now: DateTime.now());
    if (!accepted) {
      logSay(context, 'A press cannot be logged in the future.');
    }
  }

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
          Text('Seconds', style: FpType.labelSm.copyWith(color: c.textTertiary)),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: FpSpace.s3),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: c.borderDefault, width: FpStroke.hairline),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: c.borderFocus, width: FpStroke.thick),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChanged(WidgetRef ref, String value) {
    final parsed = int.tryParse(value) ?? 0;
    if (parsed > _maxSeconds) {
      final clamped = FpFormat.pad2(_maxSeconds);
      controller.value = TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(offset: clamped.length),
      );
    }
    ref.read(logEditDraftProvider.notifier).setSeconds(parsed);
  }

  static const int _maxSeconds = 59;
}

// ─────────────────────────── the action bar ───────────────────────────

class _Actions extends ConsumerWidget {
  const _Actions({required this.draft});

  final EditEntryDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dirty = ref.read(logEditDraftProvider.notifier).isDirty;

    return LogActionBar(
      children: <Widget>[
        LogActionButton(
          label: 'Save',
          onPressed: dirty ? () => _save(context, ref) : null,
        ),
      ],
    );
  }

  /// The RN screen PATCHes, then navigates to Activity
  /// (`LogDetailsEditScreen.tsx:212-243`). Phase 1 has no PATCH — the
  /// inventory's instruction for every write is a no-op that returns success
  /// (§15) — so this says so and makes the same trip, rather than leaving
  /// someone on a screen that looks saved with no way to tell it was not.
  void _save(BuildContext context, WidgetRef ref) {
    ref.read(logEditDraftProvider.notifier).reset();
    logSay(context, 'Updated. Phase 1 stores nothing, so the change will not persist.');
    context.go(FpScreen.dashboard.path);
  }
}

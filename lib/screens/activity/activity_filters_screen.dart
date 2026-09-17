/// `DASHBOARD_FILTERS` — the filter sheet.
///
/// A modal, as it is in the RN app (`ModalNavigator.tsx:235-248`), and the only
/// screen in this area that owns a `Scaffold`: the four timeline screens live
/// inside the tab shell, and this one covers it.
///
/// ## The three closures are gone
///
/// The RN screen receives `onFiltersUpdated`, `onReset` and `onReturn` as
/// **navigation params** and calls them on SAVE. That does not survive
/// go_router (`docs/design-system/screen-inventory.md` §14.3). See
/// `data/activity_providers.dart` for what replaced them; the short version is
/// that SAVE is `dashboardFiltersProvider.set(draft)`, dismissing discards
/// because the draft is autoDispose, and pagination resets because the timeline
/// watches the committed filters rather than being told to.
///
/// ## Six sections, and what changed in each
///
/// 1. **Timeframe** — now seven relative presets *and* a custom range. The
///    presets exist in the RN codebase (`constants.ts:17-46`) and are imported
///    by nothing, which is why `filters.sinceDate` is never set and why the two
///    places that read it are dead code (§5). Restored; see [TimeframePreset]
///    for the argument.
/// 2. **Household Members** — unchanged, minus the Note pseudo-Pusher, which
///    has its own control in More Filters.
/// 3. **Buttons** — matched by meaning, not by id, as the model requires. The
///    `inaudible` Button goes first **when there is one**; the RN expression
///    `inaudibleButton && [inaudibleButton, ...rest]` renders **zero** tags on
///    a Board without one, which is very likely a real bug (§5), and a Board
///    with no Buttons at all throws in `useButtons.ts:24` (§3). Both are
///    handled here, the second with a real empty state. The Board is the one
///    Board, through `boardProvider`; this section used to read a second one
///    declared in the fixture because the shared Board had no `inaudible`
///    Button to draw the §5 case against.
/// 4. **Context** — unchanged.
/// 5. **Bases** — kept, and now real: `Interaction.baseId` says which Base
///    heard a press, so this section filters rather than decorating. It used to
///    go through a `baseIdOf()` stand-in beside the fixture data because the
///    domain had no such field.
/// 6. **More Filters** — search plus the four tri-state groups, unchanged.
///
/// ## What is new
///
/// A **live count** above SAVE. The RN sheet commits blind; this says how many
/// entries the draft would match while it is still a draft, which is the
/// cheapest possible cure for over-filtering.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import 'data/activity_providers.dart';
import 'data/filters_edit.dart';
import 'ui/activity_controls.dart';
import 'ui/activity_metrics.dart';

class ActivityFiltersScreen extends ConsumerWidget {
  const ActivityFiltersScreen({this.timeframeOnly = false, super.key});

  /// Opened from `DASHBOARD_PUSHER`, which passes `editTimeframeOnly: true` and
  /// hides everything but the first section (`DashboardFilters.tsx:278`).
  final bool timeframeOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final draft = ref.watch(filterDraftProvider);
    final committed = ref.watch(dashboardFiltersProvider);
    final changed = !filtersEqual(draft, committed);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _SheetHeader(timeframeOnly: timeframeOnly),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: FpSpace.s8),
                children: <Widget>[
                  const _TimeframeSection(),
                  if (!timeframeOnly) ...<Widget>[
                    const _PushersSection(),
                    const _ButtonsSection(),
                    const _ContextsSection(),
                    const _BasesSection(),
                    const _MoreFiltersSection(),
                  ],
                ],
              ),
            ),
            _SaveBar(enabled: changed),
          ],
        ),
      ),
    );
  }
}

/// Close, title, Reset — the modal's own chrome.
class _SheetHeader extends ConsumerWidget {
  const _SheetHeader({required this.timeframeOnly});

  final bool timeframeOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final draft = ref.watch(filterDraftProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s4,
        FpSpace.s2,
        FpSpace.s5,
        FpSpace.s3,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      child: Row(
        children: <Widget>[
          Semantics(
            button: true,
            label: 'Close without saving',
            child: ExcludeSemantics(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).maybePop(),
                child: SizedBox(
                  width: ActivityMetrics.touchTarget,
                  height: ActivityMetrics.touchTarget,
                  child: Center(
                    child: PhosphorIcon(
                      PhosphorIconsBold.x,
                      size: FpIconSize.md,
                      color: c.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              timeframeOnly ? 'TIMEFRAME' : 'ACTIVITY FILTERS',
              textAlign: TextAlign.center,
              style: FpType.labelSm.copyWith(color: c.textSecondary),
            ),
          ),
          // With nothing to reset the control is *gone*, not greyed. It used
          // to go `textDisabled` and stay tappable, which was wrong twice
          // over: `text.disabled` is the same primitive as `text.tertiary`, so
          // it did not read as unavailable, and the handler was still live, so
          // it was not unavailable either. A `GestureDetector` has no ripple to
          // withhold, so removing the affordance is the only structural signal
          // this control can carry — Components § Disabled states.
          //
          // `maintainSize` keeps the slot, so the centred title does not jump
          // sideways the moment the last filter is cleared.
          Visibility(
            visible: draft.activeCount > 0,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Semantics(
              button: true,
              enabled: draft.activeCount > 0,
              label: 'Reset filters',
              child: ExcludeSemantics(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // Local only: Reset sets the defaults in the draft and the
                  // user still presses SAVE. That is what the RN header does,
                  // and it is the safer of the two readings — a header button
                  // that silently rewrites the timeline behind the sheet would
                  // be a destructive action with no confirmation.
                  onTap: draft.activeCount == 0
                      ? null
                      : () => ref.read(filterDraftProvider.notifier).reset(),
                  child: Container(
                    height: ActivityMetrics.touchTarget,
                    alignment: Alignment.centerRight,
                    child: Text(
                      'RESET',
                      style: FpType.labelSm.copyWith(color: c.textBrand),
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
}

/// A collapsible block.
///
/// Starts open when it already has filters set and closed when it does not,
/// which is what `FiltersSection.tsx:28` does — and shows the dot in its header
/// either way, so a collapsed section still says it is doing something.
class _Section extends StatefulWidget {
  const _Section({
    required this.title,
    required this.active,
    required this.child,
  });

  final String title;
  final bool active;
  final Widget child;

  @override
  State<_Section> createState() => _SectionState();
}

class _SectionState extends State<_Section> {
  late bool _open = widget.active;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Semantics(
            button: true,
            expanded: _open,
            label: widget.title,
            child: ExcludeSemantics(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _open = !_open),
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: ActivityMetrics.touchTarget,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: FpSpace.s6,
                    vertical: FpSpace.s4,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        widget.title,
                        style:
                            FpType.headingSm.copyWith(color: c.textPrimary),
                      ),
                      if (widget.active) ...<Widget>[
                        const SizedBox(width: FpSpace.s3),
                        const ActiveDot(),
                      ],
                      const Spacer(),
                      PhosphorIcon(
                        // Weight, not a second glyph: the caret turns.
                        _open
                            ? PhosphorIconsBold.caretUp
                            : PhosphorIconsBold.caretDown,
                        size: FpIconSize.sm,
                        color: c.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                FpSpace.s6,
                FpSpace.s0,
                FpSpace.s6,
                FpSpace.s6,
              ),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}

/// Section 1 — when.
class _TimeframeSection extends ConsumerWidget {
  const _TimeframeSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final draft = ref.watch(filterDraftProvider);
    final asOf = ref.watch(activityAsOfProvider);
    final preset = draft.presetFor(asOf);
    final notifier = ref.read(filterDraftProvider.notifier);

    return _Section(
      title: 'Timeframe',
      active: draft.sinceDate != null ||
          draft.startDate != null ||
          draft.endDate != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: FpSpace.s2,
            runSpacing: FpSpace.s2,
            children: <Widget>[
              for (final option in TimeframePreset.values)
                ActivityTag(
                  label: option.label,
                  selected: preset == option,
                  onTap: () => notifier.set(draft.withPreset(option, asOf)),
                ),
            ],
          ),
          const SizedBox(height: FpSpace.s5),
          Text(
            'OR AN EXACT RANGE',
            style: FpType.labelSm.copyWith(color: c.textTertiary),
          ),
          const SizedBox(height: FpSpace.s3),
          Row(
            children: <Widget>[
              Expanded(
                child: _DateField(
                  label: 'Start',
                  value: draft.startDate,
                  asOf: asOf,
                  // Start is capped by End, and neither may exceed today
                  // (`DateFilter.tsx:44-48`).
                  last: draft.endDate ?? asOf,
                  onPicked: (date) =>
                      notifier.set(draft.withRange(
                    start: date,
                    end: draft.endDate,
                  )),
                ),
              ),
              const SizedBox(width: FpSpace.s3),
              Expanded(
                child: _DateField(
                  label: 'End',
                  value: draft.endDate,
                  asOf: asOf,
                  first: draft.startDate,
                  last: asOf,
                  onPicked: (date) => notifier.set(draft.withRange(
                    start: draft.startDate,
                    end: date,
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.asOf,
    required this.last,
    required this.onPicked,
    this.first,
  });

  final String label;
  final DateTime? value;
  final DateTime asOf;
  final DateTime? first;
  final DateTime last;
  final ValueChanged<DateTime?> onPicked;

  /// How far back the calendar goes. Nothing in the fixture predates it, and a
  /// picker that scrolls to 1970 is a picker nobody can use.
  static const int _yearsOfHistory = 5;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final current = value;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: current ?? last,
          firstDate: first ??
              DateTime(asOf.year - _yearsOfHistory, asOf.month, asOf.day),
          lastDate: last,
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FpSpace.s4,
          vertical: FpSpace.s3,
        ),
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          borderRadius: BorderRadius.circular(FpRadius.sm),
          border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label.toUpperCase(),
              style: FpType.labelSm.copyWith(color: c.textTertiary),
            ),
            const SizedBox(height: FpSpace.s1),
            Text(
              current == null
                  ? 'Any'
                  : FpFormat.dayAndMonth(current, asOf: asOf),
              style: FpType.bodyMd.copyWith(
                color: current == null ? c.textTertiary : c.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section 2 — who.
class _PushersSection extends ConsumerWidget {
  const _PushersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(filterDraftProvider);
    final pushers = ref.watch(filterPushersProvider);
    final notifier = ref.read(filterDraftProvider.notifier);

    return _Section(
      title: 'Household members',
      active: draft.pusherIds.isNotEmpty,
      child: Wrap(
        spacing: FpSpace.s2,
        runSpacing: FpSpace.s2,
        children: <Widget>[
          for (final pusher in pushers)
            ActivityTag(
              // A Pusher who has left still owns history, so they are still
              // filterable — and the tag says which they are.
              label: pusher.isHidden ? '${pusher.name} (past)' : pusher.name,
              selected: draft.pusherIds.contains(pusher.id),
              onTap: () => notifier.set(draft.togglePusher(pusher.id)),
            ),
        ],
      ),
    );
  }
}

/// Section 3 — which words.
class _ButtonsSection extends ConsumerWidget {
  const _ButtonsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final draft = ref.watch(filterDraftProvider);
    final async = ref.watch(filterBoardProvider);
    final notifier = ref.read(filterDraftProvider.notifier);

    final board = async.value;
    if (board == null) {
      return _Section(
        title: 'Buttons',
        active: draft.buttonMeanings.isNotEmpty,
        // "Still loading" and "this Board has no Buttons" are different
        // sentences, and the empty one must not be shown for the other's
        // reason — which is what the RN sheet does by leaving its queries out
        // of the loading array.
        child: Text(
          async.hasError
              ? 'The Board did not load.'
              : 'Loading Buttons…',
          style: FpType.bodyMd.copyWith(color: c.textTertiary),
        ),
      );
    }

    // The `inaudible` Button first when the Board has one, and simply the
    // Board when it does not. The RN expression drops **every** tag in the
    // second case; this one cannot.
    final active = board.activeButtons;
    final inaudible =
        active.where((b) => b.kind == ButtonKind.inaudible).toList();
    final rest = active.where((b) => b.kind != ButtonKind.inaudible).toList()
      ..sort((a, b) => a.text.toLowerCase().compareTo(b.text.toLowerCase()));
    final ordered = <Button>[...inaudible, ...rest];

    // Matched by meaning, so two Buttons saying the same word are one tag.
    final meanings = <String>[];
    for (final button in ordered) {
      if (!meanings.contains(button.text)) meanings.add(button.text);
    }

    return _Section(
      title: 'Buttons',
      active: draft.buttonMeanings.isNotEmpty,
      child: meanings.isEmpty
          // `useButtons.ts:24` throws on a Board with zero Buttons and three
          // screens depend on it. Nothing throws here; the section says what is
          // true and what would change it.
          ? Text(
              'This Board has no Buttons yet. Add one from the Log screen and '
              'it becomes filterable here.',
              style: FpType.bodyMd.copyWith(color: c.textTertiary),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SectionControls(
                  match: draft.searchType.buttons,
                  onMatch: (m) => notifier.set(draft.withButtonMatch(m)),
                  onSelectAll: () => notifier.set(
                    draft.copyWith(buttonMeanings: List<String>.of(meanings)),
                  ),
                  onClear: () => notifier
                      .set(draft.copyWith(buttonMeanings: const <String>[])),
                ),
                const SizedBox(height: FpSpace.s4),
                Wrap(
                  spacing: FpSpace.s2,
                  runSpacing: FpSpace.s2,
                  children: <Widget>[
                    for (final meaning in meanings)
                      ActivityTag(
                        label: meaning,
                        selected: draft.buttonMeanings.contains(meaning),
                        onTap: () => notifier.set(draft.toggleButton(meaning)),
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}

/// Section 4 — in what situation.
class _ContextsSection extends ConsumerWidget {
  const _ContextsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final draft = ref.watch(filterDraftProvider);
    final async = ref.watch(filterContextsProvider);
    final notifier = ref.read(filterDraftProvider.notifier);

    final contexts = async.value;
    if (contexts == null) {
      return _Section(
        title: 'Context',
        active: draft.contextIds.isNotEmpty,
        child: Text(
          async.hasError
              ? 'The Contexts did not load.'
              : 'Loading Contexts…',
          style: FpType.bodyMd.copyWith(color: c.textTertiary),
        ),
      );
    }

    return _Section(
      title: 'Context',
      active: draft.contextIds.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionControls(
            match: draft.searchType.contexts,
            onMatch: (m) => notifier.set(draft.withContextMatch(m)),
            onSelectAll: () => notifier.set(
              draft.copyWith(
                contextIds: contexts.map((ctx) => ctx.id).toList(),
              ),
            ),
            onClear: () =>
                notifier.set(draft.copyWith(contextIds: const <int>[])),
          ),
          const SizedBox(height: FpSpace.s4),
          Wrap(
            spacing: FpSpace.s2,
            runSpacing: FpSpace.s2,
            children: <Widget>[
              for (final ctx in contexts)
                ActivityTag(
                  label: ctx.text,
                  selected: draft.contextIds.contains(ctx.id),
                  onTap: () => notifier.set(draft.toggleContext(ctx.id)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section 5 — which Base heard it.
class _BasesSection extends ConsumerWidget {
  const _BasesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final draft = ref.watch(filterDraftProvider);
    final bases = ref.watch(basesProvider);
    final notifier = ref.read(filterDraftProvider.notifier);

    return _Section(
      title: 'Bases',
      active: draft.baseIds.isNotEmpty,
      // The RN sheet deliberately leaves the Bases query out of its loading
      // array (`DashboardFilters.tsx:45`), so the section renders empty while
      // it is still fetching and looks like a Household with no Bases. This
      // says which it is.
      child: bases.when(
        loading: () => Text(
          'Loading Bases…',
          style: FpType.bodyMd.copyWith(color: c.textTertiary),
        ),
        error: (error, stack) => Text(
          'The Bases did not load.',
          style: FpType.bodyMd.copyWith(color: c.textTertiary),
        ),
        data: (list) => list.isEmpty
            ? Text(
                'No Base is paired with this Household.',
                style: FpType.bodyMd.copyWith(color: c.textTertiary),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SectionControls(
                    match: draft.searchType.bases,
                    onMatch: (m) => notifier.set(draft.withBaseMatch(m)),
                    onSelectAll: () => notifier.set(
                      draft.copyWith(
                        baseIds: list.map((b) => b.id).toList(),
                      ),
                    ),
                    onClear: () =>
                        notifier.set(draft.copyWith(baseIds: const <int>[])),
                  ),
                  const SizedBox(height: FpSpace.s4),
                  Wrap(
                    spacing: FpSpace.s2,
                    runSpacing: FpSpace.s2,
                    children: <Widget>[
                      for (final base in list)
                        ActivityTag(
                          // `base.name` falling back to the serial, which is
                          // what `Base.displayName` already decides.
                          label: base.displayName,
                          selected: draft.baseIds.contains(base.id),
                          onTap: () => notifier.set(draft.toggleBase(base.id)),
                        ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

/// Select all / Clear / Any / All — the four setting tags every multi-value
/// section carries (`FilterTags.tsx:41-70`).
class _SectionControls extends StatelessWidget {
  const _SectionControls({
    required this.match,
    required this.onMatch,
    required this.onSelectAll,
    required this.onClear,
  });

  final SearchMatch match;
  final ValueChanged<SearchMatch> onMatch;
  final VoidCallback onSelectAll;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: FpSpace.s2,
      runSpacing: FpSpace.s2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        ActivityTag(
          label: 'Select all',
          selected: false,
          emphasis: TagEmphasis.quiet,
          onTap: onSelectAll,
        ),
        ActivityTag(
          label: 'Clear',
          selected: false,
          emphasis: TagEmphasis.quiet,
          onTap: onClear,
        ),
        // Any / All is a real semantic difference the API honours: "any of
        // these words" versus "all of them in one Interaction".
        ChoiceTags<SearchMatch>(
          options: SearchMatch.values,
          labels: searchMatchLabel,
          value: match,
          onChanged: onMatch,
          emphasis: TagEmphasis.quiet,
        ),
      ],
    );
  }
}

/// Section 6 — everything else.
class _MoreFiltersSection extends ConsumerWidget {
  const _MoreFiltersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(filterDraftProvider);
    final notifier = ref.read(filterDraftProvider.notifier);

    return _Section(
      title: 'More filters',
      active: draft.searchText != null ||
          draft.eventNotes != ShowHideOnly.show ||
          draft.entriesWithNotes != ShowHideOnly.show ||
          draft.flaggedEntries != ShowHideOnly.show ||
          draft.buttonPresses != ButtonPressesFilter.all,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SearchField(),
          const SizedBox(height: FpSpace.s6),
          _TriState(
            title: 'Journal entries',
            noun: 'journal entries',
            value: draft.eventNotes,
            // Setting this to "only" clears the Pusher selection, and
            // `DashboardFilters.copyWith` is where that rule lives — a Note has
            // no Pusher, so the two cannot both hold.
            onChanged: (v) => notifier.set(draft.copyWith(eventNotes: v)),
          ),
          _TriState(
            title: 'Entries with notes',
            noun: 'annotated entries',
            value: draft.entriesWithNotes,
            onChanged: (v) =>
                notifier.set(draft.copyWith(entriesWithNotes: v)),
          ),
          _TriState(
            title: 'Flagged entries',
            noun: 'flagged entries',
            value: draft.flaggedEntries,
            onChanged: (v) => notifier.set(draft.copyWith(flaggedEntries: v)),
          ),
          _Labelled(
            title: 'Button presses',
            child: ChoiceTags<ButtonPressesFilter>(
              options: ButtonPressesFilter.values,
              labels: buttonPressesLabel,
              value: draft.buttonPresses,
              onChanged: (v) =>
                  notifier.set(draft.copyWith(buttonPresses: v)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends ConsumerStatefulWidget {
  const _SearchField();

  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<_SearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(filterDraftProvider).searchText ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return TextField(
      controller: _controller,
      style: FpType.bodyMd.copyWith(color: c.textPrimary),
      cursorColor: c.textBrand,
      onChanged: (value) => ref
          .read(filterDraftProvider.notifier)
          .set(ref.read(filterDraftProvider).withSearchText(value)),
      decoration: InputDecoration(
        hintText: 'Search words, Contexts and notes',
        hintStyle: FpType.bodyMd.copyWith(color: c.textTertiary),
        filled: true,
        fillColor: c.surfaceRaised,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: FpSpace.s4, right: FpSpace.s3),
          child: PhosphorIcon(
            PhosphorIconsRegular.magnifyingGlass,
            size: FpIconSize.md,
            color: c.textTertiary,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FpSpace.s4,
          vertical: FpSpace.s4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FpRadius.sm),
          borderSide: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FpRadius.sm),
          borderSide: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FpRadius.sm),
          borderSide: BorderSide(color: c.borderFocus, width: FpStroke.thick),
        ),
      ),
    );
  }
}

class _TriState extends StatelessWidget {
  const _TriState({
    required this.title,
    required this.noun,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String noun;
  final ShowHideOnly value;
  final ValueChanged<ShowHideOnly> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Labelled(
      title: title,
      child: ChoiceTags<ShowHideOnly>(
        options: ShowHideOnly.values,
        labels: (v) => showHideOnlyLabel(v, noun),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _Labelled extends StatelessWidget {
  const _Labelled({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: FpSpace.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: FpType.labelSm.copyWith(color: c.textTertiary),
          ),
          const SizedBox(height: FpSpace.s3),
          child,
        ],
      ),
    );
  }
}

/// The live count, and SAVE.
class _SaveBar extends ConsumerWidget {
  const _SaveBar({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final preview = ref.watch(filterPreviewProvider);

    return Container(
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        border: Border(
          top: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s4,
        FpSpace.s6,
        FpSpace.s5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            switch (preview) {
              AsyncData<int>(:final value) =>
                '${FpFormat.countOf(value, 'entry', 'entries')} match',
              AsyncError<int>() => 'Could not count the matches',
              _ => 'Counting…',
            },
            textAlign: TextAlign.center,
            style: FpType.labelMd.copyWith(color: c.textTertiary).tabular,
          ),
          const SizedBox(height: FpSpace.s3),
          ActionButton(
            label: 'Save filters',
            onPressed: enabled
                ? () {
                    // The whole of `onReturn` + `onFiltersUpdated` + `pop`.
                    ref
                        .read(dashboardFiltersProvider.notifier)
                        .set(ref.read(filterDraftProvider));
                    Navigator.of(context).maybePop();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

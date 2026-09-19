/// The one timeline. Four screens configure it; none of them re-implements it.
///
/// ## Why this file exists
///
/// `docs/design-system/screen-inventory.md` §1 found that `DASHBOARD`,
/// `DASHBOARD_BUTTON`, `DASHBOARD_CONTEXT`, `DASHBOARD_MEANING` and
/// `DASHBOARD_PUSHER` are five route wrappers — 16, 16, 16, 50 and 119 lines —
/// around one 806-line widget that picks its header and its list mode from
/// whichever prop was set. (`DASHBOARD_MEANING` has since been dropped with
/// the meanings dictionary; four remain.) §14.2 draws the conclusion:
///
/// > **Six screens are one widget.** Building five separate Flutter screens
/// > will produce five divergent timelines. Build one with a mode.
///
/// So this widget owns everything that is the same on all five, and the five
/// screens own nothing but a [TimelineQuery] and a header. Concretely, this
/// owns:
///
/// * **Grouping into days**, and the day headers between them.
/// * **The elapsed rail** between consecutive entries, computed from the real
///   timestamps through `FpFormat.elapsedBetween`.
/// * **Pagination** — 45 rows a page, day-aligned, load-on-approach plus an
///   explicit button, and the end-of-list marker.
/// * **Every loading, error and empty state**, including telling the three
///   empty situations apart (see `timeline_empty.dart`).
/// * **Multi-select**, including the header swap the RN app performs on its
///   navigation bar.
/// * **The filter strip**, which is how a facet screen says it inherited the
///   filters rather than silently dropping them.
///
/// A screen that wants something else on the timeline adds it to this widget,
/// where all five get it.
///
/// ## Reading direction
///
/// Days run **newest first**; entries **within** a day run oldest first, which
/// is what `design-system/src/screens/ActivityScreen.astro` draws — 07:42 at
/// the top of the day, 20:12 at the bottom, with the elapsed rail measuring
/// forwards between them. Scrolling down therefore walks backwards through the
/// diary a day at a time, and each day reads the way it was lived.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../data/providers.dart';
import '../../../domain/domain.dart';
import '../../../router/screens.g.dart';
import '../../../theme/fp_context.dart';
import '../../../theme/generated/fp_tokens.dart';
import '../../../widgets/widgets.dart';
import '../../log/edit/log_edit_state.dart' show logEditDraftProvider;
import '../../log/log_controls.dart' show logWrite;
import '../../log/log_state.dart';
import '../data/activity_providers.dart';
import '../data/filters_edit.dart';
import '../data/timeline_query.dart';
import '../data/timeline_source.dart';
import '../ui/activity_controls.dart';
import '../ui/activity_metrics.dart';
import '../ui/activity_sheet.dart';
import 'timeline_empty.dart';

/// Builds a screen's header. Handed the current slice so a header can carry
/// counts without running a second query for them.
typedef TimelineHeaderBuilder = Widget Function(
  BuildContext context,
  TimelineSlice? slice,
);

/// The timeline, in one of its five modes.
class ActivityTimeline extends ConsumerStatefulWidget {
  const ActivityTimeline({
    required this.query,
    required this.header,
    this.pinned,
    this.banner,
    this.footer,
    this.firstDayHeaderHidden = false,
    super.key,
  });

  /// What this timeline is a timeline of. The whole of the difference between
  /// the five screens.
  final TimelineQuery query;

  /// The screen's own header block, fixed above the scrolling list.
  ///
  /// Replaced wholesale while rows are selected — see [_SelectionHeader]. That
  /// is the Flutter expression of *"the navigation-bar title becomes
  /// `N SELECTED` and the left header button becomes a close"*
  /// (`DashboardList.tsx:191-208`), and it is why the header is a builder the
  /// timeline calls rather than a widget the screen puts above the timeline.
  final TimelineHeaderBuilder header;

  /// A row pinned under the header. `DASHBOARD`'s settings row; nothing on the
  /// facet screens, which is what the RN app does too
  /// (`DashboardInfiniteScroll.tsx:329-332`).
  final Widget? pinned;

  /// Sits above the first day, inside the scroll. `DASHBOARD`'s unassigned
  /// banner.
  final Widget? banner;

  /// The last thing in the scroll, after the end-of-list marker.
  final TimelineHeaderBuilder? footer;

  /// True when the screen's own header already names the first day, so
  /// repeating it inside the list would say it twice. `DASHBOARD` does; the
  /// facet screens name the facet instead and need every day labelled.
  final bool firstDayHeaderHidden;

  @override
  ConsumerState<ActivityTimeline> createState() => _ActivityTimelineState();
}

class _ActivityTimelineState extends ConsumerState<ActivityTimeline> {
  final ScrollController _controller = ScrollController();

  /// Load the next page once the list is three-quarters scrolled. The RN app
  /// uses `onEndReached` at threshold 0.25, which is the same number said from
  /// the other end (`DashboardList.tsx:758-759`).
  static const double _loadMoreThreshold = 0.75;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_maybeLoadMore);
    _controller.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.maxScrollExtent <= 0) return;
    if (position.pixels < position.maxScrollExtent * _loadMoreThreshold) return;
    ref.read(timelineProvider(widget.query).notifier).loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final async = ref.watch(timelineProvider(widget.query));
    final filters = ref.watch(dashboardFiltersProvider);
    final selection = ref.watch(selectionProvider(widget.query));
    final asOf = ref.watch(activityAsOfProvider);
    final slice = async.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (selection.isEmpty)
          widget.header(context, slice)
        else
          _SelectionHeader(query: widget.query, count: selection.length),
        if (selection.isEmpty && filters.activeCount > 0)
          _FilterStrip(filters: filters, asOf: asOf, matched: slice?.matched),
        if (selection.isEmpty && widget.pinned != null) widget.pinned!,
        Expanded(
          child: async.when(
            loading: () =>
                _Centered(child: CircularProgressIndicator(color: c.textBrand)),
            error: (error, stack) => _TimelineError(query: widget.query),
            data: (slice) => RefreshIndicator(
              color: c.textBrand,
              backgroundColor: c.surfaceRaised,
              onRefresh: () =>
                  ref.read(timelineProvider(widget.query).notifier).refresh(),
              child: slice.isEmpty
                  ? _EmptyScroll(
                      child: TimelineEmpty(
                        query: widget.query,
                        filters: filters,
                        facetTotal: slice.facetTotal,
                        asOf: asOf,
                        onClearFilters: () =>
                            ref.read(dashboardFiltersProvider.notifier).clear(),
                        onEditFilters: () =>
                            context.push(FpScreen.dashboardFilters.path),
                        onLogPress: () => context.push(FpScreen.log.path),
                        onShowAll: _showAll,
                      ),
                    )
                  : _List(
                      controller: _controller,
                      query: widget.query,
                      slice: slice,
                      selection: selection,
                      asOf: asOf,
                      banner: widget.banner,
                      footer: widget.footer,
                      firstDayHeaderHidden: widget.firstDayHeaderHidden,
                    ),
            ),
          ),
        ),
        if (selection.isNotEmpty)
          _SelectionActions(
            query: widget.query,
            selection: selection,
            slice: slice,
          ),
      ],
    );
  }

  /// "Show all activity" from an empty facet or an empty Unassigned tab.
  void _showAll() {
    if (widget.query.facet == TimelineFacet.unassigned) {
      ref.read(dashboardTabProvider.notifier).select(DashboardTab.all);
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(FpScreen.dashboard.path);
    }
  }
}

// ───────────────────────────── the list ─────────────────────────────

/// One thing in the scroll: a day header, or a row with the gap that follows
/// it.
sealed class _Item {
  const _Item();
}

class _DayItem extends _Item {
  const _DayItem({required this.day, required this.count});

  final DateTime day;
  final int count;
}

class _RowItem extends _Item {
  const _RowItem({required this.activity, required this.gapAfter});

  final Activity activity;

  /// The elapsed label to the next entry of the same day, or null at the end of
  /// a day — where `ElapsedRail` renders nothing at all, padding included.
  final String? gapAfter;
}

class _List extends ConsumerWidget {
  const _List({
    required this.controller,
    required this.query,
    required this.slice,
    required this.selection,
    required this.asOf,
    required this.banner,
    required this.footer,
    required this.firstDayHeaderHidden,
  });

  final ScrollController controller;
  final TimelineQuery query;
  final TimelineSlice slice;
  final Set<int> selection;
  final DateTime asOf;
  final Widget? banner;
  final TimelineHeaderBuilder? footer;
  final bool firstDayHeaderHidden;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = _itemsOf(slice.rows, firstDayHeaderHidden);
    final tail = footer;

    return CustomScrollView(
      controller: controller,
      // Always scrollable, so pull-to-refresh works on a short day.
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        if (banner != null) SliverToBoxAdapter(child: banner),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
          sliver: SliverList.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => switch (items[index]) {
              _DayItem(:final day, :final count) => _DayHeader(
                day: day,
                count: count,
                asOf: asOf,
              ),
              _RowItem(:final activity, :final gapAfter) => _Row(
                query: query,
                activity: activity,
                gapAfter: gapAfter,
                selected: selection.contains(activity.id),
                selecting: selection.isNotEmpty,
              ),
            },
          ),
        ),
        SliverToBoxAdapter(
          child: _Tail(query: query, slice: slice),
        ),
        if (tail != null) SliverToBoxAdapter(child: tail(context, slice)),
        const SliverToBoxAdapter(child: SizedBox(height: FpSpace.s8)),
      ],
    );
  }

  /// Days newest first, entries within a day oldest first, gaps measured
  /// forwards. See the library note on reading direction.
  static List<_Item> _itemsOf(List<Activity> rows, bool hideFirstDayHeader) {
    final byDay = <DateTime, List<Activity>>{};
    final order = <DateTime>[];
    for (final activity in rows) {
      final local = activity.occurredAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      final bucket = byDay.putIfAbsent(day, () {
        order.add(day);
        return <Activity>[];
      });
      bucket.add(activity);
    }

    final items = <_Item>[];
    for (var d = 0; d < order.length; d++) {
      final day = order[d];
      final entries = byDay[day]!
        ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
      if (!(d == 0 && hideFirstDayHeader)) {
        items.add(_DayItem(day: day, count: entries.length));
      }
      for (var i = 0; i < entries.length; i++) {
        items.add(
          _RowItem(
            activity: entries[i],
            gapAfter: i == entries.length - 1
                ? null
                : FpFormat.elapsedBetween(
                    entries[i].occurredAt,
                    entries[i + 1].occurredAt,
                  ),
          ),
        );
      }
    }
    return items;
  }
}

/// The rule between days.
///
/// Invented — the designed screen shows one day and needs no separator. A
/// timeline that pages into history does: without it the 20:12 of one day sits
/// directly above the 07:42 of the day before, and the elapsed rail cannot
/// bridge them because a fourteen-hour overnight gap is not what the rail is
/// for.
class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.day,
    required this.count,
    required this.asOf,
  });

  final DateTime day;
  final int count;
  final DateTime asOf;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final subtitle = FpFormat.daySubtitle(day, asOf: asOf);

    return Padding(
      padding: const EdgeInsets.only(top: FpSpace.s7, bottom: FpSpace.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            FpFormat.dayTitle(day, asOf: asOf).toUpperCase(),
            style: FpType.labelSm.copyWith(color: c.textSecondary),
          ),
          if (subtitle.isNotEmpty) ...<Widget>[
            const SizedBox(width: FpSpace.s3),
            Text(
              subtitle,
              style: FpType.labelSm.copyWith(color: c.textTertiary),
            ),
          ],
          const SizedBox(width: FpSpace.s4),
          Expanded(
            child: Container(height: FpStroke.hairline, color: c.borderSubtle),
          ),
          const SizedBox(width: FpSpace.s4),
          Text(
            '$count',
            style: FpType.labelSm.copyWith(color: c.textTertiary).tabular,
          ),
        ],
      ),
    );
  }
}

/// One Activity, plus the rail to the next one.
class _Row extends ConsumerWidget {
  const _Row({
    required this.query,
    required this.activity,
    required this.gapAfter,
    required this.selected,
    required this.selecting,
  });

  final TimelineQuery query;
  final Activity activity;
  final String? gapAfter;
  final bool selected;
  final bool selecting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;

    // The row draws every `PusherKind` itself, the unattributed one included:
    // a question-mark avatar and its own "nobody attributed" line. This used to
    // hand it a fabricated display Pusher lettered "?" and print the
    // attribution underneath, because `UtteranceRow` read the question as
    // `!pusher.isLearner` and called an unattributed press "base modelled
    // this". The widget was fixed; the workaround is gone.
    final body = UtteranceRow.activity(
      activity,
      onTap: () => _onTap(context, ref),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _onLongPress(context, ref),
      child: Container(
        // Selection is a tint and a left rule, not a checkbox column: the row
        // is already dense and a column of controls would push the words in.
        decoration: BoxDecoration(
          color: selected ? c.surfaceTint : null,
          border: Border(
            left: BorderSide(
              color: selected ? c.surfaceBrand : c.surfaceCanvas,
              width: FpStroke.thick,
            ),
          ),
        ),
        padding: const EdgeInsets.only(left: FpSpace.s3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            body,
            ElapsedRail(gap: gapAfter),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref) {
    if (selecting) {
      ref.read(selectionProvider(query).notifier).toggle(activity.id);
      return;
    }
    // A tap opens the entry for **editing**, as it does in the RN app
    // (`DashboardList.tsx:488-496`). That is `LOG_ENTRY_EDIT` and not
    // `LOG_DETAILS`: the two are one letter apart in the RN filenames and
    // opposite in what they do — `LOG_DETAILS` creates an Interaction,
    // `LOG_ENTRY_EDIT` updates one.
    openEntryEdit(context, ref, activity);
  }

  void _onLongPress(BuildContext context, WidgetRef ref) {
    if (selecting) {
      ref.read(selectionProvider(query).notifier).toggle(activity.id);
      return;
    }
    showRowSheet(context, ref, query: query, activity: activity);
  }
}

/// The end of the loaded list: load more, or the marker that there is no more.
class _Tail extends ConsumerWidget {
  const _Tail({required this.query, required this.slice});

  final TimelineQuery query;
  final TimelineSlice slice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;

    if (!slice.isLastPage) {
      // The scroll listener loads the next page on approach; this button is
      // what makes that reachable without a scroll gesture — with a switch
      // control, or a screen reader, or a very tall phone.
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          FpSpace.s6,
          FpSpace.s6,
          FpSpace.s6,
          FpSpace.s3,
        ),
        child: ActionButton(
          label: 'Load older activity',
          tone: ButtonTone.ghost,
          onPressed: () =>
              ref.read(timelineProvider(query).notifier).loadMore(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: FpSpace.s7, bottom: FpSpace.s3),
      child: Center(
        child: Text(
          FpFormat.largeCountOf(slice.matched, 'entry', 'entries'),
          style: FpType.labelSm.copyWith(color: c.textTertiary).tabular,
        ),
      ),
    );
  }
}

// ───────────────────────────── the filter strip ─────────────────────────

/// What is narrowing this timeline, and how to stop it.
///
/// New. In the RN app the four facet screens suppress the settings row and
/// mount a fresh, unfiltered list, so drilling into a Button from a filtered
/// timeline silently shows that Button's whole history — the behaviour §13.3
/// asks the redesign to verify. Here the filters are one provider and every
/// timeline honours them, which is only safe if every timeline also *says* it
/// is doing so. This is that sentence.
class _FilterStrip extends ConsumerWidget {
  const _FilterStrip({
    required this.filters,
    required this.asOf,
    required this.matched,
  });

  final DashboardFilters filters;
  final DateTime asOf;
  final int? matched;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final described = filters.describe(asOf).join(' · ');

    return Container(
      decoration: BoxDecoration(
        color: c.accentSubtle,
        border: Border(
          top: BorderSide(color: c.accentBorder, width: FpStroke.hairline),
          bottom: BorderSide(color: c.accentBorder, width: FpStroke.hairline),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.s6,
        vertical: FpSpace.s3,
      ),
      child: Row(
        children: <Widget>[
          PhosphorIcon(
            PhosphorIconsFill.funnel,
            size: FpIconSize.sm,
            color: c.accentFg,
          ),
          const SizedBox(width: FpSpace.s3),
          Expanded(
            child: Text(
              described,
              style: FpType.labelMd.copyWith(color: c.accentFg),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: FpSpace.s4),
          GestureDetector(
            onTap: () => ref.read(dashboardFiltersProvider.notifier).clear(),
            behavior: HitTestBehavior.opaque,
            child: Semantics(
              button: true,
              label: 'Clear filters',
              child: ExcludeSemantics(
                child: Text(
                  'CLEAR',
                  style: FpType.labelSm.copyWith(color: c.accentFg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────── multi-select ─────────────────────────────

/// The header while rows are selected.
///
/// §14.1: *"The nav bar is not static on the Activity screens. Multi-select
/// rewrites the title to `N SELECTED` and swaps the left button. Any redesign
/// with a decorative or scroll-collapsing header must still express this."*
/// This is that expression: the screen's header is replaced, not decorated, and
/// the leading control is a close that clears the selection rather than a back
/// chevron that would leave the screen.
class _SelectionHeader extends ConsumerWidget {
  const _SelectionHeader({required this.query, required this.count});

  final TimelineQuery query;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    return Container(
      color: c.surfaceSunken,
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s5,
        FpSpace.s3,
        FpSpace.s6,
        FpSpace.s4,
      ),
      child: Row(
        children: <Widget>[
          Semantics(
            button: true,
            label: 'Clear selection',
            child: ExcludeSemantics(
              child: GestureDetector(
                onTap: () =>
                    ref.read(selectionProvider(query).notifier).clear(),
                behavior: HitTestBehavior.opaque,
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
          const SizedBox(width: FpSpace.s2),
          Expanded(
            child: Text(
              '$count SELECTED',
              style: FpType.labelSm.copyWith(color: c.textPrimary).tabular,
            ),
          ),
        ],
      ),
    );
  }
}

/// The actions available to the current selection.
///
/// Assembled dynamically, because the RN option lists are
/// (`getSingleItemActionSheetOptions.ts`, `getMultipleItemsActionSheetOptions.ts`)
/// and the conditions are real domain rules, not cosmetics: Merge needs two or
/// more and no Notes, Split needs a Base-origin Interaction with more than one
/// Button.
class _SelectionActions extends ConsumerWidget {
  const _SelectionActions({
    required this.query,
    required this.selection,
    required this.slice,
  });

  final TimelineQuery query;
  final Set<int> selection;
  final TimelineSlice? slice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final rows = (slice?.rows ?? const <Activity>[])
        .where((a) => selection.contains(a.id))
        .toList(growable: false);
    final hasNotes = rows.any((a) => a is Note);
    final interactions = rows.whereType<Interaction>().toList(growable: false);
    final repo = ref.read(activityRepositoryProvider);

    Future<void> done(Future<void> write) async {
      if (!await logWrite(context, () => write) || !context.mounted) return;
      ref.read(selectionProvider(query).notifier).clear();
      refreshTimelines(ref);
    }

    return Container(
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        border: Border(
          top: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s5,
        FpSpace.s4,
        FpSpace.s5,
        FpSpace.s4,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ActionButton(
              // Short enough to survive three buttons across 390px without
              // ellipsis; the sheet it opens says which Pusher it means.
              label: 'Assign',
              tone: ButtonTone.secondary,
              onPressed: hasNotes
                  ? null
                  : () => showPusherPicker(
                      context,
                      ref,
                      title:
                          'Attribute '
                          '${FpFormat.countOf(rows.length, 'entry', 'entries')} to',
                      onPicked: (pusher) =>
                          done(repo.assignMany(interactions, pusher)),
                    ),
            ),
          ),
          const SizedBox(width: FpSpace.s3),
          Expanded(
            child: ActionButton(
              label: 'Merge',
              tone: ButtonTone.secondary,
              onPressed: (rows.length < 2 || hasNotes)
                  ? null
                  : () => showActivityConfirm(
                      context,
                      title: 'Are you sure?',
                      body:
                          'The selected '
                          '${FpFormat.countOf(rows.length, 'item')} '
                          'will be merged.',
                      confirmLabel: 'Merge',
                      onConfirm: () => done(repo.merge(interactions)),
                    ),
            ),
          ),
          const SizedBox(width: FpSpace.s3),
          Expanded(
            child: ActionButton(
              label: 'Delete',
              tone: ButtonTone.danger,
              onPressed: rows.isEmpty
                  ? null
                  : () => showActivityConfirm(
                      context,
                      title: 'Are you sure?',
                      body:
                          'The selected '
                          '${FpFormat.countOf(rows.length, 'item')} '
                          'will be deleted.',
                      confirmLabel: 'Delete',
                      onConfirm: () => done(repo.deleteMany(rows)),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────── the row sheet ─────────────────────────────

/// Everything one row can do, in one sheet.
///
/// This replaces two mechanisms at once. The RN row carries an **ellipsis**
/// that opens an action sheet, and its Button, Context and
/// avatar are each separately tappable and each navigate to a facet screen
/// (§1.2). Neither survives as-is here: `UtteranceRow` is a ratified component
/// with one tap target and no per-badge callbacks, and it is not this area's
/// file to widen.
///
/// So a long press opens this, and it carries **both** — the facet
/// destinations and the item actions — plus "Select", which is how multi-select
/// is entered now that long press is spoken for. Nothing from §1.2 or §1.3 is
/// lost; it is reached one tap differently.
void showRowSheet(
  BuildContext context,
  WidgetRef ref, {
  required TimelineQuery query,
  required Activity activity,
}) {
  final interaction = activity is Interaction ? activity : null;
  final pusher = activity.pusher;
  final realPusher =
      pusher.kind != PusherKind.eventNote && pusher.kind != PusherKind.base;
  final repo = ref.read(activityRepositoryProvider);

  Future<void> write(Future<void> call) async {
    if (await logWrite(context, () => call) && context.mounted) {
      refreshTimelines(ref);
    }
  }

  showActivitySheet(
    context,
    title: interaction == null ? 'Note' : interaction.words.join(' · '),
    subtitle:
        '${FpFormat.timeOfDay(activity.occurredAt)} · '
        '${FpFormat.dayAndMonth(activity.occurredAt)}',
    options: <SheetOption>[
      SheetOption(
        label: 'Edit entry',
        icon: PhosphorIconsRegular.pencilSimple,
        onSelected: () => openEntryEdit(context, ref, activity),
      ),
      SheetOption(
        label: 'Select',
        icon: PhosphorIconsRegular.checkSquare,
        detail: 'Then pick more rows to act on together.',
        onSelected: () =>
            ref.read(selectionProvider(query).notifier).toggle(activity.id),
      ),
      if (interaction != null)
        for (final button in interaction.buttons)
          SheetOption(
            label: 'All presses of “${button.text}”',
            icon: PhosphorIconsRegular.arrowSquareOut,
            onSelected: () => context.push(
              '${FpScreen.dashboardButton.path}'
              '?buttonId=${button.id}&meaning=${Uri.encodeComponent(button.text)}',
            ),
          ),
      if (interaction != null)
        for (final ctx in interaction.contexts)
          SheetOption(
            label: 'Everything tagged “${ctx.text}”',
            icon: PhosphorIconsRegular.arrowSquareOut,
            onSelected: () => context.push(
              '${FpScreen.dashboardContext.path}'
              '?contextId=${ctx.id}&text=${Uri.encodeComponent(ctx.text)}',
            ),
          ),
      if (realPusher)
        SheetOption(
          label: 'All of ${pusher.name}’s activity',
          icon: PhosphorIconsRegular.arrowSquareOut,
          onSelected: () => context.push(
            '${FpScreen.dashboardPusher.path}'
            '?pusherId=${pusher.id}&name=${Uri.encodeComponent(pusher.name)}',
          ),
        ),
      if (interaction != null)
        SheetOption(
          label: 'Duplicate',
          icon: PhosphorIconsRegular.copy,
          detail: 'Opens a new entry pre-filled from this one.',
          // `LOG_DETAILS` is the Log area's **create** surface, and this is the
          // third way in, beside LOG EVENT and the FAB's journal entry
          // (`DashboardList.tsx:244-274`). It was drawn disabled while the
          // draft notifier had no way to be seeded from an existing
          // Interaction; `startFrom` is that entry point.
          onSelected: () {
            ref.read(logDraftProvider.notifier).startFrom(interaction);
            context.push(FpScreen.logDetails.path);
          },
        ),
      if (interaction != null &&
          interaction.isMultiPress &&
          interaction.canSplit)
        SheetOption(
          label: 'Split',
          icon: PhosphorIconsRegular.arrowsOutLineVertical,
          detail: 'One entry per press.',
          onSelected: () => showActivityConfirm(
            context,
            title: 'Split this entry?',
            body:
                'Each of the ${interaction.buttons.length} presses becomes '
                'its own entry.',
            confirmLabel: 'Split',
            onConfirm: () => write(repo.split(interaction)),
          ),
        ),
      SheetOption(
        label: 'Delete',
        icon: PhosphorIconsRegular.trash,
        destructive: true,
        onSelected: () => showActivityConfirm(
          context,
          title: 'Are you sure?',
          body: 'This entry will be deleted.',
          confirmLabel: 'Delete',
          onConfirm: () => write(repo.delete(activity)),
        ),
      ),
    ],
  );
}

/// Seeds the edit draft from the row in hand, then opens `LOG_ENTRY_EDIT`.
/// The screen finds its draft loaded and skips the lookup — which a Note
/// needs, having no single-row read on the wire.
void openEntryEdit(BuildContext context, WidgetRef ref, Activity activity) {
  ref.read(logEditDraftProvider.notifier)
    ..reset()
    ..loadFrom(activity);
  context.push('${FpScreen.logEntryEdit.path}?activityId=${activity.id}');
}

/// A sheet of the Household's Pushers, for "attribute this to".
Future<void> showPusherPicker(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required void Function(Pusher) onPicked,
}) {
  final pushers = (ref.read(pushersProvider).value ?? const <Pusher>[]).where(
    (p) => !p.isHidden,
  );
  return showActivitySheet(
    context,
    title: title,
    options: <SheetOption>[
      for (final p in pushers)
        SheetOption(
          label: p.name,
          icon: p.isTeacher
              ? PhosphorIconsRegular.user
              : PhosphorIconsRegular.pawPrint,
          onSelected: () => onPicked(p),
        ),
    ],
  );
}

// ───────────────────────────── small parts ─────────────────────────────

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(child: child);
}

/// The empty state has to be inside a scroll view, or pull-to-refresh has
/// nothing to attach to and an empty timeline cannot be retried.
class _EmptyScroll extends StatelessWidget {
  const _EmptyScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: child,
        ),
      ),
    );
  }
}

/// There is no error UI on the RN list at all — `onError` only unwinds the page
/// pointer (§1.7). A screen that can fail and says nothing is a screen that
/// looks broken, so this says it, and offers the one thing that helps.
class _TimelineError extends ConsumerWidget {
  const _TimelineError({required this.query});

  final TimelineQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FpSpace.s7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PhosphorIcon(
              PhosphorIconsRegular.warningCircle,
              size: ActivityMetrics.emptyGlyph,
              color: c.statusDangerFg,
            ),
            const SizedBox(height: FpSpace.s5),
            Text(
              'The timeline did not load',
              style: FpType.headingLg.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: FpSpace.s3),
            Text(
              'Nothing was lost. Try again, and if it keeps happening the '
              'entries are still on the Base.',
              style: FpType.bodyMd.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: FpSpace.s7),
            ActionButton(
              label: 'Try again',
              onPressed: () =>
                  ref.read(timelineProvider(query).notifier).refresh(),
            ),
          ],
        ),
      ),
    );
  }
}

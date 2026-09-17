/// `DASHBOARD` — the Activity tab root, and the most central screen in the
/// product.
///
/// The one screen in the map that has a full visual specification:
/// `design-system/src/screens/ActivityScreen.astro`. It is followed rather than
/// reinterpreted — screen header with the day and the device health pill, the
/// summary line beneath, the timeline, and the Base's sync line at the foot.
/// Everything this screen adds beyond that comes from
/// `docs/design-system/screen-inventory.md` §2, which lists what the RN screen
/// carries that the specification's single designed day did not need: the
/// All / Unassigned control, the snooze switch, the filters icon, the
/// unassigned-presses banner and the floating action button.
///
/// This file is a **thin wrapper**. Every line of timeline behaviour lives in
/// `timeline/activity_timeline.dart`, which four other screens also use.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../router/screens.g.dart';
import '../../router/tabs.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../log/log_state.dart';
import 'data/activity_providers.dart';
import 'data/filters_edit.dart';
import 'data/timeline_query.dart';
import 'data/timeline_source.dart';
import 'timeline/activity_timeline.dart';
import 'ui/activity_controls.dart';
import 'ui/activity_metrics.dart';
import 'ui/activity_sheet.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(dashboardTabProvider);
    final query = tab == DashboardTab.all
        ? const TimelineQuery.all()
        : const TimelineQuery.unassigned();

    return FpOsChrome(
      child: Stack(
        children: <Widget>[
          ActivityTimeline(
            // The mode is the whole difference between this screen and the
            // four facet screens.
            query: query,
            header: (context, slice) => _Header(slice: slice),
            pinned: const _SettingsRow(),
            banner: tab == DashboardTab.all ? const _UnassignedBanner() : null,
            footer: (context, slice) => _Footer(slice: slice),
            // The header already names the newest day in view.
            firstDayHeaderHidden: true,
          ),
          const Positioned(
            right: FpSpace.s6,
            bottom: FpSpace.s6,
            child: _Fab(),
          ),
        ],
      ),
    );
  }
}

/// Title, date, device health, and the day's counts — the specification's
/// header, unchanged.
class _Header extends ConsumerWidget {
  const _Header({required this.slice});

  final TimelineSlice? slice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asOf = ref.watch(activityAsOfProvider);
    final base = ref.watch(activityBaseProvider);

    // The newest day in view, not literally today: with a timeframe filter set,
    // the top of the list may be a fortnight ago and a header that still said
    // "Today" would be describing rows that are not there.
    final rows = slice?.rows ?? const <Activity>[];
    final day = rows.isEmpty ? asOf : rows.first.occurredAt;
    final onDay = rows
        .where((a) => _sameDay(a.occurredAt, day))
        .toList(growable: false);

    return ScreenHeader(
      title: FpFormat.dayTitle(day, asOf: asOf),
      subtitle: FpFormat.daySubtitle(day, asOf: asOf),
      trailing: DeviceHealthPill.forBase(
        base.value,
        syncing: base.isLoading,
        // The chevron means "this opens Hardware", and it does.
        onTap: () => context.go(FpTab.hardware.root.path),
      ),
      child: SummaryLine.of(
        ActivityDay(
          label: '',
          longLabel: '',
          asOf: asOf,
          activities: onDay,
        ).summary,
        // The quiet-day sentence says "yet" only while the day can still
        // change. With a timeframe filter set, `day` is whatever the top of
        // the list is — a fortnight ago is finished and gets no "yet".
        isToday: _sameDay(day, asOf),
      ),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) {
    final x = a.toLocal();
    final y = b.toLocal();
    return x.year == y.year && x.month == y.month && x.day == y.day;
  }
}

/// The sticky settings row: which rows, whether to be told about new ones, and
/// the way into the filters.
///
/// In the RN app this is a `FlashList` sticky header faked with a sentinel `{}`
/// list item and a special case at index 0 (§1.6, which says explicitly not to
/// port the mechanism). Here it sits above the scroll view, so it is pinned by
/// construction and there is no sentinel to go wrong.
class _SettingsRow extends ConsumerWidget {
  const _SettingsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final tab = ref.watch(dashboardTabProvider);
    // "Snooze" is `push_frequency == none`; the three-way lives in Settings.
    final snoozed = ref.watch(pushFrequencyProvider) == PushFrequency.none;
    final filters = ref.watch(dashboardFiltersProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
          bottom: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      padding: const EdgeInsets.only(left: FpSpace.s6, right: FpSpace.s4),
      child: Row(
        children: <Widget>[
          SegmentedControl<DashboardTab>(
            options: DashboardTab.values,
            labels: (t) => t == DashboardTab.all ? 'All' : 'Unassigned',
            value: tab,
            onChanged: (t) =>
                ref.read(dashboardTabProvider.notifier).select(t),
          ),
          const Spacer(),
          Text(
            'Snooze',
            style: FpType.labelMd.copyWith(color: c.textSecondary),
          ),
          const SizedBox(width: FpSpace.s2),
          SquareSwitch(
            value: snoozed,
            semanticLabel: 'Snooze press notifications',
            onChanged: (value) => ref
                .read(pushFrequencyProvider.notifier)
                .set(value ? PushFrequency.none : PushFrequency.all),
          ),
          const SizedBox(width: FpSpace.s2),
          const _SortButton(),
          _FiltersButton(active: filters.activeCount > 0),
        ],
      ),
    );
  }
}

/// The sort control — the one the RN app implemented and never mounted.
///
/// `ActivitySort.tsx` exists in the RN codebase and is imported by nothing, so
/// `activity_sort` is a preference the app reads, sends and cannot change
/// (§2, §14.10: *"Either wire it up in the redesign or drop the preference; do
/// not port dead code."*). This is wiring it up.
///
/// The glyph fills on anything other than the default, the same mechanism as
/// the funnel beside it: a control that is doing something says so by weight.
class _SortButton extends ConsumerWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final sort = ref.watch(activitySortProvider);
    final isDefault = sort == ActivitySortType.recentlyPressed;

    return Semantics(
      button: true,
      label: 'Sort, currently ${sort.label}',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showActivitySheet(
            context,
            title: 'Sort activity',
            options: <SheetOption>[
              for (final option in ActivitySortType.values)
                SheetOption(
                  label: option.label,
                  icon: option == sort
                      ? PhosphorIconsFill.check
                      : PhosphorIconsRegular.clockCounterClockwise,
                  detail: switch (option) {
                    ActivitySortType.recentlyPressed =>
                      'When the press happened.',
                    ActivitySortType.recentlyLogged =>
                      'When the entry was written — an old press logged this '
                          'morning comes first.',
                  },
                  onSelected: () =>
                      ref.read(activitySortProvider.notifier).select(option),
                ),
            ],
          ),
          child: SizedBox(
            width: ActivityMetrics.touchTarget,
            height: ActivityMetrics.touchTarget,
            child: Center(
              child: PhosphorIcon(
                isDefault
                    ? PhosphorIconsRegular.arrowsDownUp
                    : PhosphorIconsFill.arrowsDownUp,
                size: FpIconSize.md,
                color: isDefault ? c.textSecondary : c.textBrand,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The funnel, wearing the dot when anything is set.
///
/// The RN app compares the current filters to `DEFAULT_FILTERS` by deep
/// equality for the same dot (`DashboardInfiniteScroll.tsx:342`); here the
/// comparison is `activeCount`, which is the same question asked once.
class _FiltersButton extends StatelessWidget {
  const _FiltersButton({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      label: active ? 'Filters, active' : 'Filters',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.push(FpScreen.dashboardFilters.path),
          child: SizedBox(
            width: ActivityMetrics.touchTarget,
            height: ActivityMetrics.touchTarget,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                PhosphorIcon(
                  // Weight, never a second glyph: the funnel fills when the
                  // filters are doing something.
                  active
                      ? PhosphorIconsFill.funnel
                      : PhosphorIconsRegular.funnel,
                  size: FpIconSize.md,
                  color: active ? c.textBrand : c.textSecondary,
                ),
                if (active)
                  const Positioned(
                    top: FpSpace.s3,
                    right: FpSpace.s3,
                    child: ActiveDot(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "You have N unassigned presses."
///
/// Renders nothing at zero and nothing while the count is unknown, which is
/// what the RN banner does (`UnassignedPressesBanner.tsx:42-44`) and is right:
/// a banner that appears empty is worse than no banner.
class _UnassignedBanner extends ConsumerWidget {
  const _UnassignedBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final count = ref.watch(unassignedCountProvider).value ?? 0;
    if (count == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s5,
        FpSpace.s6,
        FpSpace.s0,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ref
            .read(dashboardTabProvider.notifier)
            .select(DashboardTab.unassigned),
        child: Container(
          padding: const EdgeInsets.all(FpSpace.s4),
          decoration: BoxDecoration(
            color: c.surfaceRaised,
            borderRadius: BorderRadius.circular(FpRadius.md),
            border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
          ),
          child: Row(
            children: <Widget>[
              PhosphorIcon(
                PhosphorIconsRegular.userCircleDashed,
                size: FpIconSize.md,
                color: c.textTertiary,
              ),
              const SizedBox(width: FpSpace.s4),
              Expanded(
                child: Text(
                  '${FpFormat.largeCountOf(count, 'press', 'presses')} with '
                  'nobody attributed',
                  style: FpType.bodySm.copyWith(color: c.textSecondary),
                ),
              ),
              PhosphorIcon(
                PhosphorIconsRegular.caretRight,
                size: FpMetrics.healthChevron,
                color: c.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The colophon: the two event totals, and when the Base last synced.
///
/// The specification ends the timeline with *"Kitchen Base synced 2 min ago"*.
/// The two figures beside it are the RN header's Communication and Modeling
/// Events (§2), moved here: they describe the **whole** filtered set, and the
/// header above describes **one day**, so putting them together would be two
/// different questions answered in one breath.
class _Footer extends ConsumerWidget {
  const _Footer({required this.slice});

  final TimelineSlice? slice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final asOf = ref.watch(activityAsOfProvider);
    final base = ref.watch(activityBaseProvider).value;
    final current = slice;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s3,
        FpSpace.s6,
        FpSpace.s5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (current != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StatFigure(
                  // `formatLargeNumber` in the RN app — every count in every
                  // header goes through it (§2, §13.2). A Household with 1,284
                  // presses reads "1.2k" rather than pushing the caption out of
                  // the figure's column.
                  value: FpFormat.largeNumber(current.communicationEvents),
                  caption: 'Communication events',
                ),
                StatFigure(
                  value: FpFormat.largeNumber(current.modelingEvents),
                  caption: 'Modelling events',
                ),
              ],
            ),
          const SizedBox(height: FpSpace.s6),
          Text(
            base == null
                ? 'No Base paired'
                : '${base.displayName} synced '
                    '${FpFormat.lastSeen(base.lastOnlineAt, asOf: asOf)}',
            textAlign: TextAlign.center,
            style: FpType.labelMd.copyWith(color: c.textTertiary),
          ),
        ],
      ),
    );
  }
}

/// The floating action button, and the two things it can start.
///
/// `Dashboard.tsx:48-78`: Log Button Press → `LOG`; Add Journal Entry →
/// `LOG_DETAILS` pre-set to the Household's event-note Pusher. Both
/// destinations are routed; both screens belong to another area.
class _Fab extends ConsumerWidget {
  const _Fab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    // No safe-area padding here: the tab bar already sits above the bottom
    // inset and this Stack is inside the shell's body, so the space is already
    // accounted for. Adding it again would float the button 34pt too high.
    return Semantics(
        button: true,
        label: 'Add an entry',
        child: ExcludeSemantics(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showActivitySheet(
              context,
              title: 'Add an entry',
              options: <SheetOption>[
                SheetOption(
                  label: 'Log a Button press',
                  icon: PhosphorIconsRegular.handTap,
                  detail: 'Pick who pressed, then the words.',
                  onSelected: () {
                    ref.read(logDraftProvider.notifier).reset();
                    context.push(FpScreen.log.path);
                  },
                ),
                SheetOption(
                  label: 'Add a journal entry',
                  icon: PhosphorIconsRegular.notePencil,
                  detail: 'A note on the timeline with no press behind it.',
                  // The Log area owns the draft and exposes `startJournal` for
                  // exactly this entry point — the RN FAB is where the journal
                  // flow begins (`Dashboard.tsx:48-78`), so the Activity screen
                  // starts it and the Log screens carry it.
                  onSelected: () {
                    ref.read(logDraftProvider.notifier).startJournal(
                          ref.read(logJournalPusherProvider),
                        );
                    context.push(FpScreen.logDetails.path);
                  },
                ),
              ],
            ),
            child: Container(
              width: ActivityMetrics.fabDiameter,
              height: ActivityMetrics.fabDiameter,
              decoration: BoxDecoration(
                color: c.actionPrimaryBg,
                shape: BoxShape.circle,
                boxShadow: context.fpElevation.e2,
              ),
              child: Center(
                child: PhosphorIcon(
                  PhosphorIconsBold.plus,
                  size: FpIconSize.lg,
                  color: c.actionPrimaryFg,
                ),
              ),
            ),
          ),
        ),
      );
  }
}

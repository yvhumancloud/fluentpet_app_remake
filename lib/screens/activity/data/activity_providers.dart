/// Every piece of state the six Activity screens share.
///
/// ## The thing this file exists to fix
///
/// In the RN app the filter sheet is handed **three closures as navigation
/// params** — `onFiltersUpdated`, `onReset`, `onReturn`
/// (`ModalNavigator.tsx:76-82`) — and calls them on SAVE. Flutter navigation
/// cannot carry a closure through a route, and go_router's routes are built
/// from a generated table, so there is nowhere to put one even if it could
/// (`docs/design-system/screen-inventory.md` §14.3).
///
/// The closures become two providers and one rule:
///
/// * [dashboardFiltersProvider] (in `lib/data/providers.dart`, and already
///   there before this screen existed) is the **committed** filter set. All
///   five timelines watch it.
/// * [filterDraftProvider] is the sheet's **working copy**. It is autoDispose,
///   so opening the sheet always starts from the committed filters and
///   dismissing it always discards — which is what "back without SAVE discards
///   everything" meant.
/// * SAVE is one line: `set(draft)`. Pagination reset is not a callback either;
///   [TimelineNotifier] watches the committed filters and rebuilds, which is
///   what `onReturn` was for.
///
/// The four facet screens read the same committed filters, so drilling into a
/// Button from a filtered timeline no longer silently shows that Button's
/// *unfiltered* history — the behaviour §13.3 asks the redesign to verify.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/fixtures/activity_extra_fixture.dart' as fixture;
import '../../../data/providers.dart';
import '../../../domain/domain.dart';
import 'timeline_query.dart';
import 'timeline_source.dart';

// ───────────────────────────── the source ─────────────────────────────

/// The swap point for the integration phase, mirroring the one in
/// `lib/data/providers.dart`.
final Provider<ActivityTimelineSource> activityTimelineSourceProvider =
    Provider<ActivityTimelineSource>((ref) => const ActivityTimelineSource());

/// The clock the Activity screens render against.
final Provider<DateTime> activityAsOfProvider =
    Provider<DateTime>((ref) => ref.watch(activityTimelineSourceProvider).asOf);

// ───────────────────────────── the timeline ─────────────────────────────

/// One timeline per [TimelineQuery], paged.
///
/// Not autoDispose: switching to the Hardware tab and back must not throw away
/// four loaded pages and drop the user at the top of the list again.
// The type is inferred rather than written out: riverpod 3 keeps the
// `*ProviderFamily` classes in `package:riverpod/misc.dart`, which
// `flutter_riverpod.dart` does not export, so naming the type would mean an
// import for no gain.
final timelineProvider = AsyncNotifierProvider.family<TimelineNotifier,
    TimelineSlice, TimelineQuery>(TimelineNotifier.new);

class TimelineNotifier extends AsyncNotifier<TimelineSlice> {
  TimelineNotifier(this.query);

  final TimelineQuery query;

  /// True while [loadMore] is in flight, so the footer can say so without the
  /// whole list flipping back to a loading state.
  bool get isLoadingMore => _loadingMore;
  bool _loadingMore = false;

  @override
  Future<TimelineSlice> build() {
    // Watching the committed filters is what used to be `onReturn` — any
    // change resets to page 0 and refetches (§1.5). The sort is watched for the
    // same reason and with the same effect: "any change to tab, sort or filters
    // resets to page 0 and flushes" (§1.5).
    final filters = ref.watch(dashboardFiltersProvider);
    final sort = ref.watch(activitySortProvider);
    return ref
        .read(activityTimelineSourceProvider)
        .load(query: query, filters: filters, sort: sort);
  }

  /// The next page. A no-op at the end of the list, or while one is in flight.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLastPage || _loadingMore) return;
    _loadingMore = true;
    try {
      final next = await ref.read(activityTimelineSourceProvider).load(
            query: query,
            filters: ref.read(dashboardFiltersProvider),
            sort: ref.read(activitySortProvider),
            page: current.pageNumber + 1,
          );
      state = AsyncData<TimelineSlice>(next);
    } finally {
      _loadingMore = false;
    }
  }

  /// Pull to refresh: back to page 0, flushing everything loaded.
  Future<void> refresh() async {
    state = const AsyncLoading<TimelineSlice>();
    state = await AsyncValue.guard(
      () => ref.read(activityTimelineSourceProvider).load(
            query: query,
            filters: ref.read(dashboardFiltersProvider),
            sort: ref.read(activitySortProvider),
          ),
    );
  }
}

// ───────────────────────────── the sort ─────────────────────────────

/// The committed sort. Held in memory for the session: on the wire it is a user
/// preference and a PATCH per change, and phase 1 writes nothing (§15).
final NotifierProvider<ActivitySortNotifier, ActivitySortType>
    activitySortProvider =
    NotifierProvider<ActivitySortNotifier, ActivitySortType>(
        ActivitySortNotifier.new);

class ActivitySortNotifier extends Notifier<ActivitySortType> {
  @override
  ActivitySortType build() => ActivitySortType.recentlyPressed;

  void select(ActivitySortType sort) => state = sort;
}

// ───────────────────────────── the All / Unassigned tab ─────────────────

/// The two-way control on `DASHBOARD` (`DashboardHeader/DashboardFilter.tsx`).
enum DashboardTab { all, unassigned }

final NotifierProvider<DashboardTabNotifier, DashboardTab>
    dashboardTabProvider =
    NotifierProvider<DashboardTabNotifier, DashboardTab>(
        DashboardTabNotifier.new);

class DashboardTabNotifier extends Notifier<DashboardTab> {
  @override
  DashboardTab build() => DashboardTab.all;

  void select(DashboardTab tab) => state = tab;
}

/// How many presses the Base recorded that nobody has attributed.
///
/// Renders nothing at zero, like the RN banner it replaces.
final FutureProvider<int> unassignedCountProvider = FutureProvider<int>(
  (ref) => ref.watch(activityTimelineSourceProvider).unassignedCount(),
);

// ───────────────────────────── multi-select ─────────────────────────────

/// The rows selected on one timeline, by [Activity.id].
///
/// autoDispose is the whole of *"selection is cleared automatically when the
/// screen loses focus"* (`DashboardList.tsx:185-189`): leaving the screen
/// disposes the provider, and coming back builds an empty set.
final selectionProvider = NotifierProvider.autoDispose
    .family<SelectionNotifier, Set<int>, TimelineQuery>(SelectionNotifier.new);

class SelectionNotifier extends Notifier<Set<int>> {
  SelectionNotifier(this.query);

  final TimelineQuery query;

  @override
  Set<int> build() => const <int>{};

  void toggle(int id) {
    final next = state.toSet();
    if (!next.remove(id)) next.add(id);
    state = Set<int>.unmodifiable(next);
  }

  void clear() => state = const <int>{};

  bool contains(int id) => state.contains(id);
}

// ───────────────────────────── the filter sheet ─────────────────────────

/// The sheet's working copy of the filters.
///
/// autoDispose: every open starts from the committed set, every dismiss
/// discards. That is the behaviour the three closures used to carry.
final NotifierProvider<FilterDraftNotifier, DashboardFilters>
    filterDraftProvider = NotifierProvider.autoDispose<FilterDraftNotifier,
        DashboardFilters>(FilterDraftNotifier.new);

class FilterDraftNotifier extends Notifier<DashboardFilters> {
  @override
  DashboardFilters build() => ref.read(dashboardFiltersProvider);

  void set(DashboardFilters filters) => state = filters;

  /// The header's Reset. Local only — the user still has to press SAVE, which
  /// is how the RN sheet behaved and is the safer of the two readings.
  void reset() => state = DashboardFilters.none;
}

/// How many Activities the **draft** filters would match.
///
/// New. The RN sheet commits blind: you set six tags, press SAVE, and find out.
/// The count is one line here because the matcher is already in memory, and it
/// turns "did I over-filter" from a thing you discover afterwards into a thing
/// you can see while you are doing it.
final FutureProvider<int> filterPreviewProvider =
    FutureProvider.autoDispose<int>((ref) async {
  final draft = ref.watch(filterDraftProvider);
  final slice = await ref.read(activityTimelineSourceProvider).load(
        query: const TimelineQuery.all(),
        filters: draft,
      );
  return slice.matched;
});

/// The Board whose Buttons the filter sheet offers as tags.
///
/// [boardProvider], and there is no other Board to reach for. It used to be a
/// second one declared in the Activity fixture, because the shared Board had no
/// `inaudible` Button and the §5 failure mode needs one — the Buttons section
/// is built as `inaudible && [inaudible, ...rest]` in the RN app and renders
/// **zero** tags without it. The shared Board has one now, so the section reads
/// the same Board every other screen does.
///
/// The section still renders correctly for a Board with no Buttons at all,
/// which `useButtons.ts:24` throws on; that state is reachable by emptying the
/// fixture, not by pointing at a different Board.
final Provider<AsyncValue<Board>> filterBoardProvider =
    Provider<AsyncValue<Board>>((ref) => ref.watch(boardProvider));

/// Every Context a filter tag can name — the one catalogue, through the
/// repository. Filtering matches Contexts by id, so this and the list the Log
/// screens tag with have to be the same objects.
final Provider<AsyncValue<List<InteractionContext>>> filterContextsProvider =
    Provider<AsyncValue<List<InteractionContext>>>(
  (ref) => ref.watch(allContextsProvider),
);

/// Household Pushers, hidden ones included, pseudo-Pushers excluded.
final Provider<List<Pusher>> filterPushersProvider =
    Provider<List<Pusher>>((ref) => fixture.filterablePushers);

// ───────────────────────────── Pusher statistics ────────────────────────

/// The Stats tab of `DASHBOARD_PUSHER`, computed from the same rows the Feed
/// tab shows.
final pusherStatsProvider = FutureProvider.family<PusherStatistics, int>(
  (ref, pusherId) => ref.watch(activityTimelineSourceProvider).statsFor(
        pusherId: pusherId,
        filters: ref.watch(dashboardFiltersProvider),
      ),
);

/// Every Pusher the screens can be asked to render, pseudo-Pushers included —
/// a `DASHBOARD_PUSHER` deep link carries an id and nothing else.
final Provider<List<Pusher>> allPushersProvider =
    Provider<List<Pusher>>((ref) => fixture.allPushers);

/// The Base the Activity header's health pill describes: the first one the
/// Household has, or null when it has none.
final Provider<AsyncValue<Base?>> activityBaseProvider =
    Provider<AsyncValue<Base?>>(
  (ref) => ref
      .watch(basesProvider)
      .whenData((bases) => bases.isEmpty ? null : bases.first),
);

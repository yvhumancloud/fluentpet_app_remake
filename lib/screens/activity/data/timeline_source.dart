/// The one place that turns a [TimelineQuery] plus a [DashboardFilters] into a
/// page of rows.
///
/// ## Why this is not `ActivityRepository`
///
/// `lib/data/repositories.dart` offers `today()` and `dashboard(filters)`:
/// one day, and one unpaged filtered list. The five Activity screens need
/// neither — they need a *paged* list, narrowed by a facet the repository has
/// no vocabulary for, plus the Pusher statistics block. Widening the shared
/// interface is not this agent's file to widen, so the extra shape lives here,
/// against the same fixtures, behind the same kind of seam.
///
/// When the integration phase lands, [ActivityTimelineSource] is what turns
/// into `GET /api/v2/interactions` — the arguments already match the query
/// parameters the RN app sends (`page`, `per_page`, `filters`, `button_id`,
/// `context_id`, `pusher_id`, `tab`). Nothing above it changes.
///
/// ## Where filtering happens
///
/// **All filtering is server-side in the real app**
/// (`docs/design-system/screen-inventory.md` §13.3). It is evaluated here
/// because there is no server; the rules reproduced are the ones the model can
/// express, and each departure is marked at the line that makes it.
library;

import '../../../data/fixtures/activity_extra_fixture.dart' as fixture;
import '../../../domain/domain.dart';
import 'timeline_query.dart';

/// One page of a timeline, plus the counts the headers need.
///
/// The counts describe **every** matching row, not the page — a header that
/// said "45 presses" because 45 had loaded would be a lie that grows as you
/// scroll.
class TimelineSlice {
  const TimelineSlice({
    required this.rows,
    required this.pageNumber,
    required this.isLastPage,
    required this.matched,
    required this.facetTotal,
    required this.summary,
    required this.communicationEvents,
    required this.modelingEvents,
  });

  /// The rows loaded so far, newest first.
  final List<Activity> rows;

  /// The last page fetched, zero-based.
  final int pageNumber;

  /// True once a page came back short of [ActivityTimelineSource.pageSize].
  /// There is no total-count-based termination in the RN app and there is none
  /// here (`docs/design-system/screen-inventory.md` §1.5).
  final bool isLastPage;

  /// How many Activities match the query **and** the filters.
  final int matched;

  /// How many match the query **ignoring** the filters.
  ///
  /// This is what makes the third empty state possible: a facet screen reached
  /// by tapping a badge that plainly exists can say *"this Button has 214
  /// presses; your filters are hiding all of them"* rather than the RN app's
  /// undifferentiated "You don't have any logs yet" (§14.4).
  final int facetTotal;

  /// Learner counts for the matched set, as the Summary line shows them.
  final DashboardSummary summary;

  /// The two figures the `DASHBOARD` header carries: Learner Interactions and
  /// Teacher Interactions (`DashboardHeader.tsx:24-33`).
  final int communicationEvents;
  final int modelingEvents;

  bool get isEmpty => rows.isEmpty;

  /// True when the filters, not the facet, are what emptied the timeline.
  bool get emptiedByFilters => matched == 0 && facetTotal > 0;
}

/// Reads Activities out of the fixtures, faceted, filtered and paged.
class ActivityTimelineSource {
  const ActivityTimelineSource();

  /// 45, the RN app's `per_page` (`DashboardInfiniteScroll.tsx:50`). Kept
  /// because the fixture is sized against it: 120-odd rows page three times and
  /// the last page comes up short, which is the only thing that sets
  /// [TimelineSlice.isLastPage].
  static const int pageSize = 45;

  /// The clock the screens render against. A field of the fixture rather than
  /// `DateTime.now()`, so a screen opened twice looks the same twice.
  DateTime get asOf => fixture.asOf;

  /// Everything, newest first, before any filter or facet.
  List<Activity> get _all => fixture.newestFirst;

  /// Pages 0..[page] of the timeline for [query] under [filters].
  ///
  /// Returns the whole accumulated list rather than one page, because that is
  /// what the screen renders. The RN app holds pages in a map keyed by page
  /// number and flattens them in ascending order so a single page can be
  /// refetched in place after an edit (§1.5); with no writes in phase 1 there
  /// is nothing to refetch, so the simpler accumulation is honest here and the
  /// map arrives with the mutations.
  Future<TimelineSlice> load({
    required TimelineQuery query,
    required DashboardFilters filters,
    ActivitySortType sort = ActivitySortType.recentlyPressed,
    int page = 0,
  }) async {
    final faceted = _all.where((a) => _matchesFacet(a, query)).toList();
    final matched = faceted.where((a) => _matchesFilters(a, filters)).toList()
      ..sort(_comparator(sort));

    // Pages are day-aligned. A page boundary that fell inside a day would put
    // half of Tuesday on screen, and — because the timeline reads *up* within a
    // day, oldest first, as the designed screen does — the next page would
    // insert its rows in the middle of the list rather than at the end. Nudging
    // the boundary out to the end of the day it landed in costs a handful of
    // rows and removes the jump entirely.
    var end = (page + 1) * pageSize;
    if (end < matched.length) {
      final lastDay = _startOfDay(matched[end - 1].occurredAt);
      while (end < matched.length &&
          _startOfDay(matched[end].occurredAt) == lastDay) {
        end++;
      }
    }

    final rows = matched.take(end).toList(growable: false);
    final interactions = matched.whereType<Interaction>();

    return TimelineSlice(
      rows: rows,
      pageNumber: page,
      isLastPage: matched.length <= end,
      matched: matched.length,
      facetTotal: faceted.length,
      summary: _summaryOf(matched),
      communicationEvents:
          interactions.where((i) => i.pusher.isLearner).length,
      modelingEvents: interactions.where((i) => i.pusher.isTeacher).length,
    );
  }

  /// Newest first, by whichever timestamp [sort] names.
  ///
  /// `sort_type` is a query parameter on `GET /api/v2/interactions` in the real
  /// app and the ordering is the server's; it is evaluated here for the same
  /// reason every filter is. "Recently logged" reads [Interaction.loggedAt],
  /// which falls back to the press time — a [Note] has no written-at timestamp
  /// of its own, so the two orders agree about Notes and differ about presses
  /// somebody typed in late, which is the distinction the sort exists for.
  int Function(Activity, Activity) _comparator(ActivitySortType sort) {
    switch (sort) {
      case ActivitySortType.recentlyPressed:
        return (a, b) => b.occurredAt.compareTo(a.occurredAt);
      case ActivitySortType.recentlyLogged:
        return (a, b) => _loggedAt(b).compareTo(_loggedAt(a));
    }
  }

  static DateTime _loggedAt(Activity a) =>
      a is Interaction ? a.loggedAt : a.occurredAt;

  /// How many unattributed presses are waiting, for the banner on `DASHBOARD`.
  ///
  /// The RN banner runs its own query purely to read `.total` and renders
  /// nothing at zero (`UnassignedPressesBanner.tsx:42-44`). Same rule.
  Future<int> unassignedCount() async => _all
      .where((a) => a.pusher.kind == PusherKind.base)
      .length;

  /// The statistics block behind `DASHBOARD_PUSHER`'s Stats tab.
  ///
  /// Unsorted: statistics are counts, and a count does not depend on the order
  /// the rows arrived in.
  Future<PusherStatistics> statsFor({
    required int pusherId,
    required DashboardFilters filters,
  }) async {
    final mine = _all
        .where((a) => a.pusher.id == pusherId)
        .where((a) => _matchesFilters(a, filters))
        .toList(growable: false);
    return PusherStatistics.from(mine, asOf: asOf, filters: filters);
  }

  /// Every Activity for a Pusher, ignoring filters — used for the "days" figure
  /// when no timeframe is set.
  Future<int> lifetimeCountFor(int pusherId) async =>
      _all.where((a) => a.pusher.id == pusherId).length;

  DashboardSummary _summaryOf(List<Activity> activities) {
    final learner = activities
        .whereType<Interaction>()
        .where((i) => i.pusher.isLearner)
        .toList(growable: false);
    return DashboardSummary(
      utterances: learner.length,
      multiWord: learner.where((i) => i.isMultiPress).length,
      firstTimes: activities
          .whereType<Interaction>()
          .where((i) => i.firstTimeWord != null)
          .length,
    );
  }

  // ─────────────────────────── the facet ───────────────────────────

  bool _matchesFacet(Activity a, TimelineQuery q) {
    switch (q.facet) {
      case TimelineFacet.all:
        return true;
      case TimelineFacet.unassigned:
        return a.pusher.kind == PusherKind.base;
      case TimelineFacet.button:
        return a is Interaction && a.buttons.any((b) => b.id == q.id);
      case TimelineFacet.context:
        return a is Interaction && a.contexts.any((c) => c.id == q.id);
      case TimelineFacet.pusher:
        return a.pusher.id == q.id;
    }
  }

  // ─────────────────────────── the filters ───────────────────────────

  /// All thirteen fields of `DashboardFilters`, in the order the model declares
  /// them. Two are noted where they depart from the RN app.
  bool _matchesFilters(Activity a, DashboardFilters f) {
    // Timeframe. `sinceDate` is a rolling window and is mutually exclusive with
    // the explicit pair — the filter sheet enforces that, and this evaluates
    // whichever is set.
    final since = f.sinceDate;
    if (since != null && a.occurredAt.isBefore(since)) return false;

    final start = f.startDate;
    if (start != null && a.occurredAt.isBefore(_startOfDay(start))) return false;

    final end = f.endDate;
    if (end != null && a.occurredAt.isAfter(_endOfDay(end))) return false;

    // Notes, in three states. "Show only Notes" and "these Pushers" cannot both
    // hold; `DashboardFilters.copyWith` already clears the Pushers, so this
    // only has to evaluate.
    switch (f.eventNotes) {
      case ShowHideOnly.showOnly:
        if (a is! Note) return false;
      case ShowHideOnly.hide:
        if (a is Note) return false;
      case ShowHideOnly.show:
        break;
    }

    switch (f.entriesWithNotes) {
      case ShowHideOnly.showOnly:
        if (a.note.isEmpty) return false;
      case ShowHideOnly.hide:
        // A free-standing Note *is* its note; hiding "entries with notes"
        // cannot mean hiding the Note kind, which has its own control.
        if (a is! Note && a.note.isNotEmpty) return false;
      case ShowHideOnly.show:
        break;
    }

    switch (f.flaggedEntries) {
      case ShowHideOnly.showOnly:
        if (!a.isFlagged) return false;
      case ShowHideOnly.hide:
        if (a.isFlagged) return false;
      case ShowHideOnly.show:
        break;
    }

    if (f.pusherIds.isNotEmpty && !f.pusherIds.contains(a.pusher.id)) {
      return false;
    }

    // Which Base heard it. A real field on `Interaction` now: it was a
    // `baseIdOf()` stand-in beside the fixture data, which made this facet the
    // one filter in the sheet that could not be evaluated from the domain.
    // A free-standing Note came from no Base and is excluded by any Base filter.
    if (f.baseIds.isNotEmpty) {
      final base = a is Interaction ? a.baseId : null;
      if (base == null || !f.baseIds.contains(base)) return false;
    }

    if (a is Interaction) {
      switch (f.buttonPresses) {
        case ButtonPressesFilter.singlePress:
          if (a.isMultiPress) return false;
        case ButtonPressesFilter.multiPress:
          if (!a.isMultiPress) return false;
        case ButtonPressesFilter.all:
          break;
      }

      // Buttons match by **meaning**, not by id: two physical Buttons saying
      // "outside" are one word.
      if (f.buttonMeanings.isNotEmpty) {
        final words = a.words.toSet();
        final ok = f.searchType.buttons == SearchMatch.all
            ? f.buttonMeanings.every(words.contains)
            : f.buttonMeanings.any(words.contains);
        if (!ok) return false;
      }

      if (f.contextIds.isNotEmpty) {
        final ids = a.contexts.map((c) => c.id).toSet();
        final ok = f.searchType.contexts == SearchMatch.all
            ? f.contextIds.every(ids.contains)
            : f.contextIds.any(ids.contains);
        if (!ok) return false;
      }
    } else if (f.buttonMeanings.isNotEmpty ||
        f.contextIds.isNotEmpty ||
        f.buttonPresses != ButtonPressesFilter.all) {
      // A Note has no Buttons and no Contexts, so any Button- or
      // Context-shaped filter excludes it rather than matching vacuously.
      return false;
    }

    final search = f.searchText?.trim().toLowerCase();
    if (search != null && search.isNotEmpty) {
      if (!_haystack(a).contains(search)) return false;
    }

    return true;
  }

  String _haystack(Activity a) => <String>[
        a.note,
        a.pusher.name,
        if (a is Interaction) ...<String>[
          ...a.words,
          ...a.contexts.map((c) => c.text),
        ],
      ].join(' ').toLowerCase();

  static DateTime _startOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);
}

/// One row of a "most pressed" / "least pressed" list.
class ButtonPressCount {
  const ButtonPressCount({required this.text, required this.count});

  final String text;
  final int count;
}

/// The `DASHBOARD_PUSHER` Stats tab, computed rather than served.
///
/// The RN app receives this as `pusher_stats` on the interactions response
/// (`src/model/interaction.ts:121-131`) and §15 says a fixture may serve
/// "static numbers". Computing it from the same rows the Feed tab shows is
/// cheap and removes a whole class of fixture drift — the Feed and the Stats
/// cannot disagree about how many presses there were.
class PusherStatistics {
  const PusherStatistics({
    required this.days,
    required this.activeButtons,
    required this.distinctButtons,
    required this.pressCount,
    required this.mostPressed,
    required this.leastPressed,
    required this.mostModeled,
    required this.leastModeled,
    required this.commonContexts,
    required this.mostFrequentCombination,
  });

  /// Days of history behind these numbers.
  ///
  /// `PusherHeader.tsx:48-52` prefers `ceil(now − sinceDate)` when a relative
  /// timeframe is set and falls back to `days_since_oldest_entry`. That first
  /// branch is dead in the RN app because nothing ever sets `sinceDate` (§5).
  /// The filter sheet in this rewrite does set it, so the branch is live.
  final int days;

  final int activeButtons;
  final int distinctButtons;
  final int pressCount;

  final List<ButtonPressCount> mostPressed;
  final List<ButtonPressCount> leastPressed;

  /// Learner Pushers only: what Teachers modelled *at* them. Empty for a
  /// Teacher or a Note (`PusherStats.tsx:43`, `:79`).
  final List<ButtonPressCount> mostModeled;
  final List<ButtonPressCount> leastModeled;

  /// Up to ten Contexts by frequency (`UsageTypes.tsx`).
  final List<ButtonPressCount> commonContexts;

  /// The multi-press combination this Pusher uses most, and how often. Empty
  /// when they have never pressed two Buttons together.
  final List<String> mostFrequentCombination;

  /// `floor(presses / days)`, with the RN app's two special cases:
  /// `"0"` when either input is zero, and the literal `"<1"` when the quotient
  /// floors to zero (`helpers/getAverageDailyPresses.ts` — it has a unit test,
  /// so the behaviour is deliberate).
  String get averageDailyPresses {
    if (days == 0 || pressCount == 0) return '0';
    final average = pressCount ~/ days;
    return average == 0 ? '<1' : '$average';
  }

  static const int _listLength = 5;
  static const int _contextListLength = 10;

  /// Everything above, derived from one Pusher's Activities.
  factory PusherStatistics.from(
    List<Activity> activities, {
    required DateTime asOf,
    required DashboardFilters filters,
  }) {
    final interactions = activities.whereType<Interaction>().toList();

    final pressed = <String, int>{};
    final contexts = <String, int>{};
    final combinations = <String, int>{};
    final modeled = <String, int>{};

    for (final i in interactions) {
      for (final b in i.buttons) {
        pressed[b.text] = (pressed[b.text] ?? 0) + 1;
      }
      for (final c in i.contexts) {
        contexts[c.text] = (contexts[c.text] ?? 0) + 1;
      }
      if (i.isMultiPress) {
        final key = i.words.join(' · ');
        combinations[key] = (combinations[key] ?? 0) + 1;
      }
      // Words a Teacher modelled while this Learner was the subject.
      if (i.pusher.isTeacher) {
        for (final b in i.buttons) {
          modeled[b.text] = (modeled[b.text] ?? 0) + 1;
        }
      }
    }

    final oldest = activities.isEmpty
        ? asOf
        : activities
            .map((a) => a.occurredAt)
            .reduce((a, b) => a.isBefore(b) ? a : b);

    final since = filters.sinceDate ?? filters.startDate;
    final days = since != null
        ? _ceilDays(asOf.difference(since))
        : _ceilDays(asOf.difference(oldest));

    final ranked = _rank(pressed);
    final rankedModeled = _rank(modeled);
    final topCombination = _rank(combinations);

    return PusherStatistics(
      days: days,
      activeButtons: pressed.length,
      distinctButtons: pressed.length,
      pressCount: pressed.values.fold(0, (a, b) => a + b),
      mostPressed: ranked.take(_listLength).toList(growable: false),
      leastPressed:
          ranked.reversed.take(_listLength).toList(growable: false),
      mostModeled: rankedModeled.take(_listLength).toList(growable: false),
      leastModeled:
          rankedModeled.reversed.take(_listLength).toList(growable: false),
      commonContexts:
          _rank(contexts).take(_contextListLength).toList(growable: false),
      mostFrequentCombination: topCombination.isEmpty
          ? const <String>[]
          : topCombination.first.text.split(' · '),
    );
  }

  static List<ButtonPressCount> _rank(Map<String, int> counts) {
    final entries = counts.entries.toList()
      // Count descending, then alphabetically, so the order is stable rather
      // than whatever the map iteration happened to give.
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : a.key.compareTo(b.key);
      });
    return entries
        .map((e) => ButtonPressCount(text: e.key, count: e.value))
        .toList(growable: false);
  }

  static int _ceilDays(Duration d) {
    if (d.inSeconds <= 0) return 1;
    final whole = d.inDays;
    return d.inSeconds % Duration.secondsPerDay == 0 ? whole : whole + 1;
  }
}

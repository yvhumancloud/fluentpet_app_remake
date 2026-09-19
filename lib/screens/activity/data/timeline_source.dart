/// The one place that turns a [TimelineQuery] plus a [DashboardFilters] into a
/// page of rows: `POST /interactions/search`.
///
/// ## Why this is not `ActivityRepository`
///
/// The five Activity screens need a *paged* list narrowed by a facet, plus
/// the Pusher statistics block, and nothing else in the app does. The shared
/// repository carries the writes; the shape only this area reads lives here.
///
/// ## What the server does and what this does
///
/// All filtering, faceting, sorting and paging is the server's. Two things
/// the domain says that the wire does not are translated on the way in:
/// Buttons filter by **meaning** here and by id there, so meanings become
/// every Button id on the Board with that text; and a facet is the same
/// filter with one id. One thing is computed on the way out: the summary
/// line (utterances, multi-word, first words) is counted over the rows on
/// screen, because the wire counts interactions and presses, not those.
library;

import 'package:fluentpet_api/fluentpet_api.dart';

import '../../../data/api/mappers.dart';
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

  final bool isLastPage;

  /// How many Activities match the query **and** the filters.
  final int matched;

  /// How many match the query **ignoring** the filters.
  ///
  /// This is what makes the third empty state possible: a facet screen reached
  /// by tapping a badge that plainly exists can say *"this Button has 214
  /// presses; your filters are hiding all of them"* rather than an
  /// undifferentiated "nothing here".
  final int facetTotal;

  /// Learner counts for the loaded rows, as the Summary line shows them.
  final DashboardSummary summary;

  /// The two figures the `DASHBOARD` header carries: Learner Interactions and
  /// Teacher Interactions, over every matching row.
  final int communicationEvents;
  final int modelingEvents;

  bool get isEmpty => rows.isEmpty;

  /// True when the filters, not the facet, are what emptied the timeline.
  bool get emptiedByFilters => matched == 0 && facetTotal > 0;
}

class ActivityTimelineSource {
  ActivityTimelineSource(this._api, this._board);

  final FluentpetApi _api;

  /// The Board, for meaning → id and for the Button behind each press.
  final Future<Board> Function() _board;

  /// 45, the PRD's default `per_page`.
  static const int pageSize = 45;

  /// Page [page] of the timeline for [query] under [filters], appended to
  /// [previous] so the caller always holds the whole list it renders.
  Future<TimelineSlice> load({
    required TimelineQuery query,
    required DashboardFilters filters,
    ActivitySortType sort = ActivitySortType.recentlyPressed,
    int page = 0,
    TimelineSlice? previous,
  }) async {
    final board = await _board();
    final byId = <int, Button>{for (final b in board.buttons) b.id: b};
    final out = await _search(
      query: query,
      filters: filters,
      board: board,
      page: page + 1,
      perPage: pageSize,
      sort: sort,
    );
    final rows = <Activity>[
      ...?previous?.rows,
      for (final item in out.items) ?searchItemToDomain(item, buttons: byId),
    ];
    // Only a facet can be emptied by filters, and only then is the
    // unfiltered total worth a second round trip.
    final facetTotal = out.total == 0 && !query.isRoot && !filters.isEmpty
        ? (await _search(
            query: query,
            filters: DashboardFilters.none,
            board: board,
            page: 1,
            perPage: 1,
          )).total
        : out.total;
    return TimelineSlice(
      rows: rows,
      pageNumber: page,
      isLastPage: out.page * out.perPage >= out.total,
      matched: out.total,
      facetTotal: facetTotal,
      summary: _summaryOf(rows),
      communicationEvents: out.counts.communication,
      modelingEvents: out.counts.modeling,
    );
  }

  /// How many rows [query] under [filters] would show. The filter sheet's
  /// live preview and the unassigned banner.
  Future<int> count({
    required TimelineQuery query,
    required DashboardFilters filters,
  }) async {
    final out = await _search(
      query: query,
      filters: filters,
      board: await _board(),
      page: 1,
      perPage: 1,
    );
    return out.total;
  }

  /// The statistics block behind `DASHBOARD_PUSHER`'s Stats tab, from
  /// `GET /pushers/{id}/stats` and `GET /stats/summary`.
  Future<PusherStatistics> statsFor({
    required int pusherId,
    required DashboardFilters filters,
    required DateTime asOf,
  }) async {
    final stats = _api.getStatsApi();
    final since = filters.sinceDate ?? filters.startDate;
    final to = filters.endDate ?? asOf;
    // The server caps a summary range at 183 days.
    final from = since != null && to.difference(since).inDays <= 183
        ? since
        : to.subtract(const Duration(days: 183));
    final own = await stats.pusherStats(pusherId: pusherId);
    final summary = await stats.summary(
      pusherId: pusherId,
      from: dateOf(from),
      to: dateOf(to),
    );
    final s = own.data!;
    final totals = summary.data!.totals;
    final days = since != null
        ? _ceilDays(asOf.difference(since))
        : (summary.data!.daysSinceFirstInteraction ?? 0).clamp(1, 1 << 31);
    return PusherStatistics(
      days: days,
      distinctButtons: totals.distinctButtons,
      pressCount: totals.presses,
      mostPressed: _counts(s.mostPressed),
      leastPressed: _counts(s.leastPressed),
      commonContexts: _counts(s.topContexts),
      mostFrequentCombination:
          s.mostFrequentCombination?.buttons
              .map((b) => b.text)
              .toList(growable: false) ??
          const <String>[],
    );
  }

  Future<SearchOut> _search({
    required TimelineQuery query,
    required DashboardFilters filters,
    required Board board,
    required int page,
    required int perPage,
    ActivitySortType sort = ActivitySortType.recentlyPressed,
  }) async {
    final f = filters;
    // Buttons filter by meaning in the domain and by id on the wire.
    final meaningIds = <int>[
      for (final b in board.buttons)
        if (f.buttonMeanings.contains(b.text)) b.id,
    ];
    final r = await _api.getInteractionsApi().search(
      searchIn: SearchIn(
        (b) => b
          ..page = page
          ..perPage = perPage
          ..sort = sort == ActivitySortType.recentlyLogged
              ? SearchInSortEnum.createdAtDesc
              : SearchInSortEnum.occurredAtDesc
          ..tab = query.facet == TimelineFacet.unassigned
              ? SearchInTabEnum.unassigned
              : SearchInTabEnum.all
          ..filters.replace(
            SearchFilters(
              (sf) => sf
                ..pusherIds.replace(<int>[
                  ...f.pusherIds,
                  if (query.facet == TimelineFacet.pusher) query.id!,
                ])
                ..contextIds.replace(<int>[
                  ...f.contextIds,
                  if (query.facet == TimelineFacet.context) query.id!,
                ])
                ..buttonIds.replace(<int>[
                  ...meaningIds,
                  if (query.facet == TimelineFacet.button) query.id!,
                ])
                ..baseIds.replace(f.baseIds)
                // One `match` on the wire for what the domain lets differ
                // per facet; Buttons' is the one the sheet exposes.
                ..match = f.searchType.buttons == SearchMatch.all
                    ? SearchFiltersMatchEnum.all
                    : SearchFiltersMatchEnum.any
                ..text = f.searchText?.trim().isEmpty ?? true
                    ? null
                    : f.searchText!.trim()
                ..from = (f.sinceDate ?? f.startDate)?.toUtc()
                ..to = f.endDate == null
                    ? null
                    : DateTime(
                        f.endDate!.year,
                        f.endDate!.month,
                        f.endDate!.day,
                        23,
                        59,
                        59,
                      ).toUtc()
                ..notes = _notes(f.eventNotes)
                ..withNote = _withNote(f.entriesWithNotes)
                ..favourites = _favourites(f.flaggedEntries)
                ..presses = switch (f.buttonPresses) {
                  ButtonPressesFilter.all => SearchFiltersPressesEnum.all,
                  ButtonPressesFilter.singlePress =>
                    SearchFiltersPressesEnum.single,
                  ButtonPressesFilter.multiPress =>
                    SearchFiltersPressesEnum.multiple,
                },
            ),
          ),
      ),
    );
    return r.data!;
  }

  static SearchFiltersNotesEnum _notes(ShowHideOnly v) => switch (v) {
    ShowHideOnly.show => SearchFiltersNotesEnum.include,
    ShowHideOnly.hide => SearchFiltersNotesEnum.exclude,
    ShowHideOnly.showOnly => SearchFiltersNotesEnum.only,
  };

  static SearchFiltersWithNoteEnum _withNote(ShowHideOnly v) => switch (v) {
    ShowHideOnly.show => SearchFiltersWithNoteEnum.include,
    ShowHideOnly.hide => SearchFiltersWithNoteEnum.exclude,
    ShowHideOnly.showOnly => SearchFiltersWithNoteEnum.only,
  };

  static SearchFiltersFavouritesEnum _favourites(ShowHideOnly v) => switch (v) {
    ShowHideOnly.show => SearchFiltersFavouritesEnum.include,
    ShowHideOnly.hide => SearchFiltersFavouritesEnum.exclude,
    ShowHideOnly.showOnly => SearchFiltersFavouritesEnum.only,
  };

  static List<ButtonPressCount> _counts(Iterable<TextCount> rows) => rows
      .map((r) => ButtonPressCount(text: r.text, count: r.count))
      .toList(growable: false);

  static DashboardSummary _summaryOf(List<Activity> activities) {
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

  static int _ceilDays(Duration d) {
    if (d.inSeconds <= 0) return 1;
    final whole = d.inDays;
    return d.inSeconds % Duration.secondsPerDay == 0 ? whole : whole + 1;
  }
}

/// One row of a "most pressed" / "least pressed" list.
class ButtonPressCount {
  const ButtonPressCount({required this.text, required this.count});

  final String text;
  final int count;
}

/// The `DASHBOARD_PUSHER` Stats tab.
///
/// "Most modelled" is not served by the PRD's stats endpoints and is not
/// drawn: the Learner-only block on the screen shows Contexts alone.
class PusherStatistics {
  const PusherStatistics({
    required this.days,
    required this.distinctButtons,
    required this.pressCount,
    required this.mostPressed,
    required this.leastPressed,
    required this.commonContexts,
    required this.mostFrequentCombination,
  });

  /// Days of history behind these numbers: the filter window when one is
  /// set, otherwise since the first entry.
  final int days;

  final int distinctButtons;
  final int pressCount;

  final List<ButtonPressCount> mostPressed;
  final List<ButtonPressCount> leastPressed;

  /// Up to ten Contexts by frequency.
  final List<ButtonPressCount> commonContexts;

  /// The multi-press combination this Pusher uses most. Empty when they have
  /// never pressed two Buttons together.
  final List<String> mostFrequentCombination;

  /// `floor(presses / days)`, with the RN app's two special cases:
  /// `"0"` when either input is zero, and the literal `"<1"` when the quotient
  /// floors to zero.
  String get averageDailyPresses {
    if (days == 0 || pressCount == 0) return '0';
    final average = pressCount ~/ days;
    return average == 0 ? '<1' : '$average';
  }
}

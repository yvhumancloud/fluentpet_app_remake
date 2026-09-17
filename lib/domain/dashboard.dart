import 'activity.dart';

/// A three-state filter: leave them in, take them out, or show nothing else.
enum ShowHideOnly { show, hide, showOnly }

/// Single- versus multi-press.
enum ButtonPressesFilter { all, singlePress, multiPress }

/// Whether a multi-value filter means "any of these" or "all of these".
enum SearchMatch { any, all }

/// [SearchMatch] per multi-value filter. The API lets them differ.
class SearchTypeFilter {
  const SearchTypeFilter({
    this.buttons = SearchMatch.any,
    this.contexts = SearchMatch.any,
    this.bases = SearchMatch.any,
  });

  final SearchMatch buttons;
  final SearchMatch contexts;
  final SearchMatch bases;
}

/// The filter set behind the Dashboard.
///
/// One asymmetry is real and load-bearing: Pushers, Contexts and Bases filter
/// by **id**, but Buttons filter by **meaning** — the text — because two
/// physical Buttons saying "outside" should match as one word.
///
/// A semantic rule from the RN app, worth carrying: setting [eventNotes] to
/// [ShowHideOnly.showOnly] clears [pusherIds], since notes have no Pusher.
class DashboardFilters {
  const DashboardFilters({
    this.searchText,
    this.startDate,
    this.endDate,
    this.sinceDate,
    this.pusherIds = const <int>[],
    this.buttonMeanings = const <String>[],
    this.contextIds = const <int>[],
    this.baseIds = const <int>[],
    this.eventNotes = ShowHideOnly.show,
    this.entriesWithNotes = ShowHideOnly.show,
    this.flaggedEntries = ShowHideOnly.show,
    this.buttonPresses = ButtonPressesFilter.all,
    this.searchType = const SearchTypeFilter(),
  });

  /// What the Dashboard shows before anyone touches a filter.
  static const DashboardFilters none = DashboardFilters();

  final String? searchText;
  final DateTime? startDate;
  final DateTime? endDate;

  /// A rolling window ("last 7 days"), mutually exclusive with the explicit
  /// start/end pair in the UI.
  final DateTime? sinceDate;

  final List<int> pusherIds;

  /// Matched by meaning, not by id. See the class note.
  final List<String> buttonMeanings;

  final List<int> contextIds;
  final List<int> baseIds;
  final ShowHideOnly eventNotes;
  final ShowHideOnly entriesWithNotes;
  final ShowHideOnly flaggedEntries;
  final ButtonPressesFilter buttonPresses;
  final SearchTypeFilter searchType;

  bool get isEmpty =>
      searchText == null &&
      startDate == null &&
      endDate == null &&
      sinceDate == null &&
      pusherIds.isEmpty &&
      buttonMeanings.isEmpty &&
      contextIds.isEmpty &&
      baseIds.isEmpty &&
      eventNotes == ShowHideOnly.show &&
      entriesWithNotes == ShowHideOnly.show &&
      flaggedEntries == ShowHideOnly.show &&
      buttonPresses == ButtonPressesFilter.all;

  DashboardFilters copyWith({
    String? searchText,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? sinceDate,
    List<int>? pusherIds,
    List<String>? buttonMeanings,
    List<int>? contextIds,
    List<int>? baseIds,
    ShowHideOnly? eventNotes,
    ShowHideOnly? entriesWithNotes,
    ShowHideOnly? flaggedEntries,
    ButtonPressesFilter? buttonPresses,
    SearchTypeFilter? searchType,
  }) {
    final notes = eventNotes ?? this.eventNotes;
    return DashboardFilters(
      searchText: searchText ?? this.searchText,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sinceDate: sinceDate ?? this.sinceDate,
      // "Notes only" and "these Pushers" cannot both hold; the RN app clears
      // the Pushers, and a screen that forgets to would show an empty list.
      pusherIds: notes == ShowHideOnly.showOnly
          ? const <int>[]
          : pusherIds ?? this.pusherIds,
      buttonMeanings: buttonMeanings ?? this.buttonMeanings,
      contextIds: contextIds ?? this.contextIds,
      baseIds: baseIds ?? this.baseIds,
      eventNotes: notes,
      entriesWithNotes: entriesWithNotes ?? this.entriesWithNotes,
      flaggedEntries: flaggedEntries ?? this.flaggedEntries,
      buttonPresses: buttonPresses ?? this.buttonPresses,
      searchType: searchType ?? this.searchType,
    );
  }
}

/// The counts under the Activity header. The design calls this the summary
/// line, and its numerals are tabular so it does not twitch as the day fills.
class DashboardSummary {
  const DashboardSummary({
    required this.utterances,
    required this.multiWord,
    required this.firstTimes,
  });

  /// Learner utterances. Teacher modelling is not counted.
  final int utterances;

  final int multiWord;
  final int firstTimes;
}

/// The filtered view over Activities.
///
/// Surfaced to users as "Activity"; the underlying screens are named "Log".
/// All three names are kept — see CONTEXT.md.
class Dashboard {
  const Dashboard({
    required this.filters,
    required this.activities,
    required this.summary,
  });

  final DashboardFilters filters;
  final List<Activity> activities;
  final DashboardSummary summary;
}

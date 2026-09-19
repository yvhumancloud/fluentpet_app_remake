/// Editing, comparing and describing a [DashboardFilters].
///
/// `DashboardFilters` is immutable and its `copyWith` deliberately cannot set a
/// field back to null — which is right for a value type and wrong for a filter
/// sheet, where "clear the end date" is a thing a user does. The three
/// timeframe fields are therefore rebuilt explicitly here, in one place, and
/// everything else goes through `copyWith`.
///
/// It also holds the two questions every Activity screen asks and no screen
/// should answer twice: *are any filters set*, and *what would I tell the user
/// they are*. The second is what makes the over-filtered empty state
/// differentiable from the empty-account one.
library;

import '../../../domain/domain.dart';
import '../../../widgets/widgets.dart';

/// The seven relative presets from `DashboardFilters/constants.ts:17-46`.
///
/// **These are restored, not carried over.** In the RN app `TIMEFRAME_FILTER_TAGS`
/// is imported by nothing, so `filters.sinceDate` is never written — while
/// `PusherHeader` and `PusherStats` both branch on it, making that branch dead
/// code (`docs/design-system/screen-inventory.md` §5, §14.5). The inventory
/// asks for a decision either way. The decision is to restore them: "the last
/// week" is how a person thinks about a talking dog's progress, two taps on a
/// calendar is not, and the reading half of the feature was already built and
/// working.
enum TimeframePreset {
  allTime('All time', null),
  today('Today', 0),
  twoDays('Last 2 days', 2),
  threeDays('Last 3 days', 3),
  sevenDays('Last 7 days', 7),
  twoWeeks('Last 2 weeks', 14),
  thirtyDays('Last 30 days', 30);

  const TimeframePreset(this.label, this.days);

  final String label;

  /// How many days back the window starts. Null is unbounded; 0 is today only.
  final int? days;

  /// The instant this preset starts at, relative to [asOf].
  ///
  /// Start of day with the **local** offset, deliberately not UTC — the RN
  /// helper does the same and says so (`helpers/createSinceDateTimestamp.ts`).
  DateTime? since(DateTime asOf) {
    final back = days;
    if (back == null) return null;
    final day = asOf.subtract(Duration(days: back));
    return DateTime(day.year, day.month, day.day);
  }
}

/// True when [a] and [b] would produce the same timeline.
///
/// `DashboardFilters` has no value equality, and the SAVE button is disabled by
/// deep equality against the filters as received (`DashboardFilters.tsx:362`),
/// so the comparison has to live somewhere. Here, once, rather than in the
/// sheet and again in the header's red dot.
bool filtersEqual(DashboardFilters a, DashboardFilters b) =>
    a.searchText == b.searchText &&
    a.startDate == b.startDate &&
    a.endDate == b.endDate &&
    a.sinceDate == b.sinceDate &&
    _sameInts(a.pusherIds, b.pusherIds) &&
    _sameStrings(a.buttonMeanings, b.buttonMeanings) &&
    _sameInts(a.contextIds, b.contextIds) &&
    _sameInts(a.baseIds, b.baseIds) &&
    a.eventNotes == b.eventNotes &&
    a.entriesWithNotes == b.entriesWithNotes &&
    a.flaggedEntries == b.flaggedEntries &&
    a.buttonPresses == b.buttonPresses &&
    a.searchType.buttons == b.searchType.buttons &&
    a.searchType.contexts == b.searchType.contexts &&
    a.searchType.bases == b.searchType.bases;

bool _sameInts(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  final left = a.toSet();
  return b.every(left.contains);
}

bool _sameStrings(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  final left = a.toSet();
  return b.every(left.contains);
}

/// Rebuilds the three timeframe fields, which `copyWith` cannot clear.
DashboardFilters _withTimeframe(
  DashboardFilters f, {
  required DateTime? sinceDate,
  required DateTime? startDate,
  required DateTime? endDate,
  String? searchText,
  bool clearSearchText = false,
}) => DashboardFilters(
  searchText: clearSearchText ? null : (searchText ?? f.searchText),
  startDate: startDate,
  endDate: endDate,
  sinceDate: sinceDate,
  pusherIds: f.pusherIds,
  buttonMeanings: f.buttonMeanings,
  contextIds: f.contextIds,
  baseIds: f.baseIds,
  eventNotes: f.eventNotes,
  entriesWithNotes: f.entriesWithNotes,
  flaggedEntries: f.flaggedEntries,
  buttonPresses: f.buttonPresses,
  searchType: f.searchType,
);

/// The edits the filter sheet makes.
extension FiltersEdit on DashboardFilters {
  /// A relative window. Clears the explicit range: the domain calls the two
  /// *"mutually exclusive in the UI"* and this is the line that makes it true.
  DashboardFilters withPreset(TimeframePreset preset, DateTime asOf) =>
      _withTimeframe(
        this,
        sinceDate: preset.since(asOf),
        startDate: null,
        endDate: null,
      );

  /// An explicit range. Clears the relative window, for the same reason.
  DashboardFilters withRange({DateTime? start, DateTime? end}) =>
      _withTimeframe(this, sinceDate: null, startDate: start, endDate: end);

  /// The free-text search in More Filters. Empty clears it rather than storing
  /// an empty string, so `isEmpty` stays honest.
  DashboardFilters withSearchText(String text) {
    final trimmed = text.trim();
    return _withTimeframe(
      this,
      sinceDate: sinceDate,
      startDate: startDate,
      endDate: endDate,
      searchText: trimmed.isEmpty ? null : trimmed,
      clearSearchText: trimmed.isEmpty,
    );
  }

  /// Which preset [sinceDate] currently expresses, or null for a custom or
  /// absent window.
  TimeframePreset? presetFor(DateTime asOf) {
    if (startDate != null || endDate != null) return null;
    final since = sinceDate;
    if (since == null) return TimeframePreset.allTime;
    for (final preset in TimeframePreset.values) {
      if (preset.days != null && preset.since(asOf) == since) return preset;
    }
    return null;
  }

  DashboardFilters togglePusher(int id) =>
      copyWith(pusherIds: _toggleInt(pusherIds, id));

  DashboardFilters toggleButton(String meaning) =>
      copyWith(buttonMeanings: _toggleString(buttonMeanings, meaning));

  DashboardFilters toggleContext(int id) =>
      copyWith(contextIds: _toggleInt(contextIds, id));

  DashboardFilters toggleBase(int id) =>
      copyWith(baseIds: _toggleInt(baseIds, id));

  DashboardFilters withButtonMatch(SearchMatch match) => copyWith(
    searchType: SearchTypeFilter(
      buttons: match,
      contexts: searchType.contexts,
      bases: searchType.bases,
    ),
  );

  DashboardFilters withContextMatch(SearchMatch match) => copyWith(
    searchType: SearchTypeFilter(
      buttons: searchType.buttons,
      contexts: match,
      bases: searchType.bases,
    ),
  );

  DashboardFilters withBaseMatch(SearchMatch match) => copyWith(
    searchType: SearchTypeFilter(
      buttons: searchType.buttons,
      contexts: searchType.contexts,
      bases: match,
    ),
  );

  /// How many facets are narrowing the timeline.
  ///
  /// Counted by facet, not by tag: three Pushers selected is one filter, not
  /// three, because it is one sentence in the empty state.
  int get activeCount {
    var n = 0;
    if (searchText != null) n++;
    if (sinceDate != null || startDate != null || endDate != null) n++;
    if (pusherIds.isNotEmpty) n++;
    if (buttonMeanings.isNotEmpty) n++;
    if (contextIds.isNotEmpty) n++;
    if (baseIds.isNotEmpty) n++;
    if (eventNotes != ShowHideOnly.show) n++;
    if (entriesWithNotes != ShowHideOnly.show) n++;
    if (flaggedEntries != ShowHideOnly.show) n++;
    if (buttonPresses != ButtonPressesFilter.all) n++;
    return n;
  }

  /// What the active filters are, in words, shortest first.
  ///
  /// This is the sentence the over-filtered empty state needs. "You don't have
  /// any logs yet" is what the RN app says in that situation
  /// (§14.4); it is wrong, and the reason it is wrong is that the app knows
  /// perfectly well what it is hiding and does not say.
  List<String> describe(DateTime asOf) {
    final out = <String>[];

    final preset = presetFor(asOf);
    if (preset != null && preset != TimeframePreset.allTime) {
      out.add(preset.label.toLowerCase());
    } else if (startDate != null || endDate != null) {
      final from = startDate;
      final to = endDate;
      if (from != null && to != null) {
        out.add(
          '${FpFormat.dayAndMonth(from, asOf: asOf)} to '
          '${FpFormat.dayAndMonth(to, asOf: asOf)}',
        );
      } else if (from != null) {
        out.add('from ${FpFormat.dayAndMonth(from, asOf: asOf)}');
      } else if (to != null) {
        out.add('up to ${FpFormat.dayAndMonth(to, asOf: asOf)}');
      }
    }

    if (pusherIds.isNotEmpty) {
      out.add(FpFormat.countOf(pusherIds.length, 'Pusher'));
    }
    if (buttonMeanings.isNotEmpty) {
      out.add(FpFormat.countOf(buttonMeanings.length, 'Button'));
    }
    if (contextIds.isNotEmpty) {
      out.add(FpFormat.countOf(contextIds.length, 'Context'));
    }
    if (baseIds.isNotEmpty) {
      out.add(FpFormat.countOf(baseIds.length, 'Base'));
    }
    if (eventNotes == ShowHideOnly.showOnly) out.add('Notes only');
    if (eventNotes == ShowHideOnly.hide) out.add('Notes hidden');
    if (entriesWithNotes == ShowHideOnly.showOnly) out.add('annotated only');
    if (entriesWithNotes == ShowHideOnly.hide) out.add('annotated hidden');
    if (flaggedEntries == ShowHideOnly.showOnly) out.add('flagged only');
    if (flaggedEntries == ShowHideOnly.hide) out.add('flagged hidden');
    if (buttonPresses == ButtonPressesFilter.singlePress) {
      out.add('single presses');
    }
    if (buttonPresses == ButtonPressesFilter.multiPress) {
      out.add('multi-presses');
    }

    final search = searchText;
    if (search != null) out.add('“$search”');
    return out;
  }
}

List<int> _toggleInt(List<int> ids, int id) {
  final next = ids.toList();
  if (!next.remove(id)) next.add(id);
  return List<int>.unmodifiable(next);
}

List<String> _toggleString(List<String> values, String value) {
  final next = values.toList();
  if (!next.remove(value)) next.add(value);
  return List<String>.unmodifiable(next);
}

/// Labels for the tri-state controls, so the sheet and the description agree.
String showHideOnlyLabel(ShowHideOnly value, String noun) => switch (value) {
  ShowHideOnly.show => 'Show',
  ShowHideOnly.hide => 'Hide',
  ShowHideOnly.showOnly => 'Only $noun',
};

String buttonPressesLabel(ButtonPressesFilter value) => switch (value) {
  ButtonPressesFilter.all => 'All',
  ButtonPressesFilter.singlePress => 'Single',
  ButtonPressesFilter.multiPress => 'Multi',
};

String searchMatchLabel(SearchMatch value) =>
    value == SearchMatch.any ? 'Any' : 'All';

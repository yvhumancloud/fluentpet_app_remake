/// The phase-1 repository implementations: mock data, no network.
///
/// PLAN.md is explicit that phase 1 is screens against fixtures — no
/// Bluetooth, no auth, no device shadow, no HTTP. These classes are the whole
/// data layer until the integration phase, and they are the only place in the
/// app that knows fixtures exist.
///
/// Each returns a `Future` even though the answer is already in memory. That is
/// on purpose: a screen written against a synchronous repository will not
/// survive its first real network call, and the loading state is cheaper to
/// design now than to retrofit.
library;

import '../../domain/domain.dart';
import '../repositories.dart';
import 'activity_fixture.dart' as activity;
import 'hardware_fixture.dart' as hardware;
import 'household_fixture.dart' as households;

class FixtureActivityRepository implements ActivityRepository {
  const FixtureActivityRepository();

  @override
  Future<ActivityDay> today() async => activity.today;

  @override
  Future<List<InteractionContext>> contexts({required bool forTeacher}) async =>
      forTeacher ? activity.teacherContexts : activity.learnerContexts;

  @override
  Future<Dashboard> dashboard(DashboardFilters filters) async {
    final day = activity.today;
    final all = filters.eventNotes == ShowHideOnly.hide
        ? day.activities
        : activity.activitiesWithNote;
    final matched = all.where((a) => _matches(a, filters)).toList(growable: false);
    return Dashboard(
      filters: filters,
      activities: matched,
      summary: ActivityDay(
        label: day.label,
        longLabel: day.longLabel,
        asOf: day.asOf,
        activities: matched,
      ).summary,
    );
  }

  /// Enough filtering to make the Dashboard screens honest, not a
  /// reimplementation of the server. Date windows and search-type any/all are
  /// left to the API; a fixture that guessed at them would teach the screens
  /// the wrong behaviour.
  bool _matches(Activity a, DashboardFilters f) {
    if (f.eventNotes == ShowHideOnly.showOnly && a is! Note) return false;
    if (f.flaggedEntries == ShowHideOnly.showOnly && !a.isFlagged) return false;
    if (f.flaggedEntries == ShowHideOnly.hide && a.isFlagged) return false;
    if (f.entriesWithNotes == ShowHideOnly.showOnly && a.note.isEmpty) return false;
    if (f.entriesWithNotes == ShowHideOnly.hide && a.note.isNotEmpty) return false;
    if (f.pusherIds.isNotEmpty && !f.pusherIds.contains(a.pusher.id)) return false;

    if (a is Interaction) {
      // Which Base heard it. Real since `Interaction.baseId` landed; before
      // that this facet was unevaluable and the section was a control that
      // provably did nothing.
      if (f.baseIds.isNotEmpty &&
          (a.baseId == null || !f.baseIds.contains(a.baseId))) {
        return false;
      }
      switch (f.buttonPresses) {
        case ButtonPressesFilter.singlePress:
          if (a.isMultiPress) return false;
        case ButtonPressesFilter.multiPress:
          if (!a.isMultiPress) return false;
        case ButtonPressesFilter.all:
          break;
      }
      if (f.buttonMeanings.isNotEmpty &&
          !a.words.any((w) => f.buttonMeanings.contains(w))) {
        return false;
      }
      if (f.contextIds.isNotEmpty &&
          !a.contexts.any((c) => f.contextIds.contains(c.id))) {
        return false;
      }
    }

    final search = f.searchText?.trim().toLowerCase();
    if (search != null && search.isNotEmpty) {
      final haystack = <String>[
        a.note,
        a.pusher.name,
        if (a is Interaction) ...a.words,
        if (a is Interaction) ...a.contexts.map((c) => c.text),
      ].join(' ').toLowerCase();
      if (!haystack.contains(search)) return false;
    }
    return true;
  }
}

class FixtureHouseholdRepository implements HouseholdRepository {
  const FixtureHouseholdRepository();

  @override
  Future<Household> household() async => households.household;

  @override
  Future<HouseholdMember> me() async => households.me;

  @override
  Future<List<Pusher>> pushers() async => households.pushers;
}

class FixtureHardwareRepository implements HardwareRepository {
  const FixtureHardwareRepository();

  @override
  Future<List<Base>> bases() async => hardware.bases;

  @override
  Future<Board> board() async => hardware.board;
}

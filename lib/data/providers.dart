/// The provider surface every screen reads from.
///
/// Screens watch these. They never construct a repository and never touch
/// `fixtures/`. When the integration phase lands, the three
/// `*RepositoryProvider` lines below change to the real implementations and
/// nothing else in the app does.
///
/// This file is the one place that names a fixture directly, and only for three
/// values that are not repository reads: the app's clock, the literal Context
/// name three Log rules key off, and the event-note pseudo-Pusher. All three
/// become API or platform values at integration and all three change here.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/domain.dart';
import 'fixtures/activity_fixture.dart' as fixture;
import 'fixtures/fixture_repositories.dart';
import 'repositories.dart';

// --- the swap point ---------------------------------------------------------

final Provider<ActivityRepository> activityRepositoryProvider =
    Provider<ActivityRepository>((ref) => const FixtureActivityRepository());

final Provider<HouseholdRepository> householdRepositoryProvider =
    Provider<HouseholdRepository>((ref) => const FixtureHouseholdRepository());

final Provider<HardwareRepository> hardwareRepositoryProvider =
    Provider<HardwareRepository>((ref) => const FixtureHardwareRepository());

/// "Now", for every relative time in the app.
///
/// The fixture's own instant — 2026-08-19 20:16 — rather than `DateTime.now()`,
/// so "2 min ago" in the Activity header and "synced 2 min ago" on the Hardware
/// tab describe the same moment and a screen opened twice looks the same twice.
/// A wall clock would drag every relative string away from the fixture within a
/// day. Integration replaces the body with `DateTime.now()`, here, once.
///
/// It is on the shared surface rather than per area because three areas were
/// each deriving it from a different file and a clock that disagrees with
/// itself is worse than one that is wrong.
final Provider<DateTime> nowProvider = Provider<DateTime>((ref) => fixture.asOf);

// --- what screens watch -----------------------------------------------------

/// The day the Activity screen opens on.
final FutureProvider<ActivityDay> activityDayProvider =
    FutureProvider<ActivityDay>(
  (ref) => ref.watch(activityRepositoryProvider).today(),
);

/// The current Dashboard filter set. Held here rather than passed to a family
/// provider, because [DashboardFilters] has no value equality and a family
/// keyed on it would accumulate a provider per keystroke.
final NotifierProvider<DashboardFiltersNotifier, DashboardFilters>
    dashboardFiltersProvider =
    NotifierProvider<DashboardFiltersNotifier, DashboardFilters>(
  DashboardFiltersNotifier.new,
);

class DashboardFiltersNotifier extends Notifier<DashboardFilters> {
  @override
  DashboardFilters build() => DashboardFilters.none;

  void set(DashboardFilters filters) => state = filters;

  void clear() => state = DashboardFilters.none;
}

/// Activities matching [dashboardFiltersProvider], with their summary counts.
final FutureProvider<Dashboard> dashboardProvider = FutureProvider<Dashboard>(
  (ref) => ref
      .watch(activityRepositoryProvider)
      .dashboard(ref.watch(dashboardFiltersProvider)),
);

final FutureProvider<Household> householdProvider = FutureProvider<Household>(
  (ref) => ref.watch(householdRepositoryProvider).household(),
);

/// The signed-in user. `GET /me` on the wire.
final FutureProvider<HouseholdMember> meProvider =
    FutureProvider<HouseholdMember>(
  (ref) => ref.watch(householdRepositoryProvider).me(),
);

final FutureProvider<List<Pusher>> pushersProvider =
    FutureProvider<List<Pusher>>(
  (ref) => ref.watch(householdRepositoryProvider).pushers(),
);

final FutureProvider<List<Base>> basesProvider = FutureProvider<List<Base>>(
  (ref) => ref.watch(hardwareRepositoryProvider).bases(),
);

/// The one Board. Every screen that lists Buttons watches this — the Log
/// screen's board, the filter sheet's tags, `CLASSIC_BUTTONS`, and the
/// linked-Button join on `BASE_EDIT`. Nothing merges anything onto it
/// afterwards; a provider that did would be a second Board.
final FutureProvider<Board> boardProvider = FutureProvider<Board>(
  (ref) => ref.watch(hardwareRepositoryProvider).board(),
);

/// The Contexts offered for a Learner's press, and for a Teacher's.
///
/// Two providers rather than one family, because there are exactly two lists
/// and a family keyed on a bool reads worse than saying which one you want.
/// The Teacher list contains the `Modeled` Context that three rules key off by
/// name — see [fixture.modeledContextText], re-exposed as [modeledContextText].
final FutureProvider<List<InteractionContext>> learnerContextsProvider =
    FutureProvider<List<InteractionContext>>(
  (ref) => ref.watch(activityRepositoryProvider).contexts(forTeacher: false),
);

final FutureProvider<List<InteractionContext>> teacherContextsProvider =
    FutureProvider<List<InteractionContext>>(
  (ref) => ref.watch(activityRepositoryProvider).contexts(forTeacher: true),
);

/// Every Context, both lists, as the filter sheet offers them.
final FutureProvider<List<InteractionContext>> allContextsProvider =
    FutureProvider<List<InteractionContext>>((ref) async {
  final learner = await ref.watch(learnerContextsProvider.future);
  final teacher = await ref.watch(teacherContextsProvider.future);
  return List<InteractionContext>.unmodifiable(<InteractionContext>[
    ...learner,
    ...teacher,
  ]);
});

/// The literal Context name the Teacher rules turn on.
///
/// A fixture value in phase 1 and an API value afterwards, which is why it is
/// re-exposed here rather than spelled a second time in a screen.
const String modeledContextText = fixture.modeledContextText;

/// The event-note pseudo-Pusher a free-standing Note is attributed to.
///
/// Id -1 is the API's sentinel. The journal entry the Activity FAB starts is
/// discriminated by it, so both areas have to mean the same Pusher by it.
final Provider<Pusher> journalPusherProvider =
    Provider<Pusher>((ref) => fixture.eventNotePusher);

// --- preferences ------------------------------------------------------------
//
// `PUT /preferences/{key}` on the wire. Session-only here: phase 1 has no
// preference writes and no persistence, so both reset on relaunch. They live
// in this file rather than beside one screen because two screens read each:
// the Activity tab's Snooze switch and Settings both drive `push_frequency`.

/// The `push_frequency` preference: which Base presses send a push.
enum PushFrequency {
  /// Every press.
  all,

  /// Only the first press of each Interaction.
  onInteraction,

  /// Nothing. What the Activity tab's "Snooze" switch sets.
  none,
}

final NotifierProvider<PushFrequencyNotifier, PushFrequency>
    pushFrequencyProvider =
    NotifierProvider<PushFrequencyNotifier, PushFrequency>(
  PushFrequencyNotifier.new,
);

class PushFrequencyNotifier extends Notifier<PushFrequency> {
  @override
  PushFrequency build() => PushFrequency.all;

  void set(PushFrequency value) => state = value;
}

/// The `default_pusher_id` preference: who a Base press is attributed to when
/// the Base has no default of its own. Null means unassigned.
final NotifierProvider<DefaultPusherNotifier, int?> defaultPusherIdProvider =
    NotifierProvider<DefaultPusherNotifier, int?>(DefaultPusherNotifier.new);

class DefaultPusherNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void set(int? value) => state = value;
}

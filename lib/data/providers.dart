/// The provider surface every screen reads from.
///
/// Screens watch these. They never construct a repository and never touch
/// the generated client; the three `*RepositoryProvider`s hand out the API
/// implementations built on `apiProvider`'s authenticated client.
///
/// Everything here is Household-wide. After a write, a screen invalidates the
/// provider it changed and the next watcher refetches.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/domain.dart';
import 'api/api_client.dart';
import 'api/api_repositories.dart';
import 'api/mappers.dart' show journalPusher;
import 'repositories.dart';

final Provider<ActivityRepository> activityRepositoryProvider =
    Provider<ActivityRepository>(
      (ref) => ApiActivityRepository(ref.watch(apiProvider)),
    );

final Provider<HouseholdRepository> householdRepositoryProvider =
    Provider<HouseholdRepository>(
      (ref) => ApiHouseholdRepository(ref.watch(apiProvider)),
    );

final Provider<HardwareRepository> hardwareRepositoryProvider =
    Provider<HardwareRepository>(
      (ref) => ApiHardwareRepository(ref.watch(apiProvider)),
    );

/// "Now", for every relative time in the app.
///
/// Re-reads the clock once a minute, so "2 min ago" becomes "3 min ago"
/// without the screen being rebuilt for another reason. One provider rather
/// than `DateTime.now()` per screen so the Activity header and the Hardware
/// tab describe the same moment.
final Provider<DateTime> nowProvider = Provider<DateTime>((ref) {
  final tick = Timer(const Duration(minutes: 1), ref.invalidateSelf);
  ref.onDispose(tick.cancel);
  return DateTime.now();
});

// --- what screens watch -----------------------------------------------------

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

/// `GET /learner-types`, id → name ("Dog"): what the Species picker offers.
final FutureProvider<Map<int, String>> learnerTypesProvider =
    FutureProvider<Map<int, String>>(
      (ref) => ref.watch(householdRepositoryProvider).learnerTypes(),
    );

/// `GET /button-concepts`, id → concept: what the Meaning picker offers.
final FutureProvider<Map<int, String>> buttonConceptsProvider =
    FutureProvider<Map<int, String>>(
      (ref) => ref.watch(hardwareRepositoryProvider).buttonConcepts(),
    );

/// The Contexts offered for a Learner's press, and for a Teacher's.
///
/// Two providers rather than one family, because there are exactly two lists
/// and a family keyed on a bool reads worse than saying which one you want.
/// The Teacher list contains the `Modeled` Context that three rules key off by
/// name — see [fixture.modeledContextText], re-exposed as [modeledContextText].
final FutureProvider<List<InteractionContext>> learnerContextsProvider =
    FutureProvider<List<InteractionContext>>(
      (ref) =>
          ref.watch(activityRepositoryProvider).contexts(forTeacher: false),
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

/// The literal Context name the Teacher rules turn on — the PRD's seeded
/// global `Modeled` (human only).
const String modeledContextText = 'Modeled';

/// The event-note pseudo-Pusher a free-standing Note is attributed to.
///
/// Id -1 is the API's sentinel. The journal entry the Activity FAB starts is
/// discriminated by it, so both areas have to mean the same Pusher by it.
final Provider<Pusher> journalPusherProvider = Provider<Pusher>(
  (ref) => journalPusher,
);

// --- preferences ------------------------------------------------------------
//
// `GET /preferences` once, then `PUT /preferences/{key}` per change, with the
// local state set first so the switch does not lag the network. They live
// here rather than beside one screen because two screens read each: the
// Activity tab's Snooze switch and Settings both drive `push_frequency`.

/// Every preference the server holds for this user, as it stores them.
final FutureProvider<Map<PreferenceKey, Object?>> preferencesProvider =
    FutureProvider<Map<PreferenceKey, Object?>>(
      (ref) => ref.watch(householdRepositoryProvider).preferences(),
    );

/// The `push_frequency` preference: which Base presses send a push.
enum PushFrequency {
  /// Every press.
  all('all'),

  /// Only the first press of each Interaction.
  onInteraction('on_interaction'),

  /// Nothing. What the Activity tab's "Snooze" switch sets.
  none('none');

  const PushFrequency(this.wire);

  final String wire;

  static PushFrequency fromWire(Object? value) =>
      values.where((v) => v.wire == value).firstOrNull ?? PushFrequency.all;
}

final NotifierProvider<PushFrequencyNotifier, PushFrequency>
pushFrequencyProvider = NotifierProvider<PushFrequencyNotifier, PushFrequency>(
  PushFrequencyNotifier.new,
);

class PushFrequencyNotifier extends Notifier<PushFrequency> {
  @override
  PushFrequency build() => PushFrequency.fromWire(
    ref.watch(preferencesProvider).value?[PreferenceKey.pushFrequency],
  );

  void set(PushFrequency value) {
    state = value;
    ref
        .read(householdRepositoryProvider)
        .setPreference(PreferenceKey.pushFrequency, value.wire);
  }
}

/// The `default_pusher_id` preference: who a Base press is attributed to when
/// the Base has no default of its own. Null means unassigned.
final NotifierProvider<DefaultPusherNotifier, int?> defaultPusherIdProvider =
    NotifierProvider<DefaultPusherNotifier, int?>(DefaultPusherNotifier.new);

class DefaultPusherNotifier extends Notifier<int?> {
  @override
  int? build() {
    final raw = ref
        .watch(preferencesProvider)
        .value?[PreferenceKey.defaultPusherId];
    return raw is num ? raw.toInt() : null;
  }

  void set(int? value) {
    state = value;
    ref
        .read(householdRepositoryProvider)
        .setPreference(PreferenceKey.defaultPusherId, value);
  }
}

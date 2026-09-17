/// What the screens are allowed to ask for.
///
/// Every method is async and returns domain types only. No screen ever sees a
/// fixture, a JSON map, an HTTP client or a BLE handle. The integration phase
/// replaces the implementations in `fixtures/` with ones that talk to the API
/// and swaps them at the provider in `providers.dart` — one edit, no screen
/// touched. That is the entire point of this file existing.
///
/// Interfaces are deliberately thin. Phase 1 reads; nothing writes. Mutations
/// arrive with the integration phase, when there is something real to write to.
library;

import '../domain/domain.dart';

/// The timeline and the filtered view over it.
abstract interface class ActivityRepository {
  /// The day the Activity screen opens on.
  Future<ActivityDay> today();

  /// Activities matching [filters], with the summary counts for them.
  Future<Dashboard> dashboard(DashboardFilters filters);

  /// The Contexts a press can be tagged with.
  ///
  /// `GET /api/v1/contexts?filter=learner|teacher` on the wire — the list
  /// changes with the Pusher's type, which is why the argument is here rather
  /// than a filter the caller applies afterwards
  /// (`LogDetailsNewScreen.tsx:74-76`).
  ///
  /// It is on this interface because a Context is a property of an Interaction
  /// and nothing else in the domain has one. Its absence was why the Log area
  /// had to reach into `data/fixtures/` directly: there was no method to call,
  /// so the screens grew their own copy of the data, with ids that collided
  /// with the Activity area's copy.
  Future<List<InteractionContext>> contexts({required bool forTeacher});
}

/// The people and pets who share the Bases.
abstract interface class HouseholdRepository {
  Future<Household> household();

  /// The signed-in user, as `GET /me` returns them. Needed wherever a screen
  /// draws differently for the admin or marks a row as "you".
  Future<HouseholdMember> me();

  /// Every Pusher in the Household, Learners and Teachers together.
  Future<List<Pusher>> pushers();
}

/// Bases and Buttons.
abstract interface class HardwareRepository {
  Future<List<Base>> bases();

  /// The default Board — the full historical set of Buttons.
  Future<Board> board();
}

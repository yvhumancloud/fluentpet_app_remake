/// What the screens are allowed to ask for.
///
/// Every method is async and speaks domain types only. No screen ever sees a
/// generated wire model, a JSON map or an HTTP client; the one implementation
/// of each interface lives in `api/api_repositories.dart` and is handed out by
/// `providers.dart`.
///
/// Writes take the domain object the screen already holds — the Log drafts
/// build an [Activity] for their preview, the forms build a [Pusher] or a
/// [Button] — so a save is "send this", not a second parameter list that can
/// drift from the model.
library;

import '../domain/domain.dart';

/// Preference keys the backend accepts (`PUT /preferences/{key}`).
enum PreferenceKey { activitySort, buttonSort, defaultPusherId, pushFrequency }

/// The timeline and the writes against it.
abstract interface class ActivityRepository {
  /// The Contexts a press can be tagged with: the global ones for the
  /// Pusher's kind plus the Household's own. The list changes with the
  /// Pusher's type, which is why the argument is here rather than a filter
  /// the caller applies afterwards.
  Future<List<InteractionContext>> contexts({required bool forTeacher});

  /// One Interaction by wire id, or null when it is gone. Notes have no
  /// single-row read on the wire; a Note reaches the edit screen from the
  /// timeline row that was tapped.
  Future<Interaction?> interaction(int id);

  /// `POST /interactions` or `POST /notes`, by the runtime type.
  Future<Activity> create(Activity activity);

  /// `PATCH` of every field the edit screen can change.
  Future<void> update(Activity activity);

  Future<void> setFlag(Activity activity, bool flagged);

  Future<void> delete(Activity activity);

  /// Bulk on interaction ids. Notes in a selection are deleted one by one.
  Future<void> deleteMany(Iterable<Activity> activities);

  Future<void> assignMany(Iterable<Interaction> interactions, Pusher pusher);

  /// Merges into the earliest; the rest are soft-deleted.
  Future<void> merge(Iterable<Interaction> interactions);

  /// One Interaction per press. Base presses only — the server rejects a
  /// press without a device timestamp.
  Future<void> split(Interaction interaction);
}

/// The people and pets who share the Bases.
abstract interface class HouseholdRepository {
  Future<Household> household();

  /// The signed-in user, as `GET /me` returns them.
  Future<HouseholdMember> me();

  Future<void> updateMyName(String fullName);

  /// `DELETE /me`. Fails for the admin of a Household with other members.
  Future<void> deleteAccount();

  /// Every Pusher in the Household, hidden ones included, with the detail
  /// fields the forms edit.
  Future<List<Pusher>> pushers();

  /// `GET /learner-types`, id → name.
  Future<Map<int, String>> learnerTypes();

  Future<Pusher> createPusher(Pusher pusher);

  Future<void> updatePusher(Pusher pusher);

  Future<void> setPusherHidden(Pusher pusher, bool hidden);

  Future<void> invite(String email);

  Future<void> withdrawInvitation(HouseholdInvitation invitation);

  Future<void> acceptInvitation(HouseholdInvitation invitation);

  Future<void> rejectInvitation(HouseholdInvitation invitation);

  Future<void> removeMember(HouseholdMember member);

  Future<void> leaveHousehold();

  Future<Map<PreferenceKey, Object?>> preferences();

  Future<void> setPreference(PreferenceKey key, Object? value);
}

/// Bases and Buttons.
abstract interface class HardwareRepository {
  Future<List<Base>> bases();

  /// The Board — every Button, hidden ones included.
  Future<Board> board();

  /// `GET /button-concepts`, id → concept. The Meaning picker's options.
  Future<Map<int, String>> buttonConcepts();

  Future<void> registerBase({
    required String serialNumber,
    required String name,
  });

  Future<void> updateBase(Base base);

  Future<void> deleteBase(Base base);

  Future<Button> createButton(Button button);

  Future<void> updateButton(Button button);

  Future<void> setButtonHidden(Button button, bool hidden);

  Future<void> unlinkButton(Button button);

  /// Presses, Base link and sound move to [target]; [source] is deleted.
  Future<void> mergeButtons({required Button source, required Button target});
}

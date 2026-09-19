/// The repositories, on the wire.
///
/// Reads go through the generated client and `mappers.dart`. Two things are
/// done by hand and it is worth knowing why:
///
/// * **PATCH bodies are raw maps.** The generated models are built_value, and
///   built_value's serializer drops null fields — so `BasePatch(defaultPusherId:
///   null)` sends `{}` and "no default Pusher" is unsayable. A PATCH here is
///   `dio.patch(path, data: {...})` on the same authenticated `Dio`, with the
///   nulls the screen meant.
/// * **Lists are fetched whole.** `GET /pushers`, `GET /buttons` and
///   `GET /bases` are Household-sized, and every screen that lists one wants
///   the whole thing.
library;

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:fluentpet_api/fluentpet_api.dart';

import '../../domain/domain.dart';
import '../repositories.dart';
import 'api_client.dart' show deviceTimezone;
import 'mappers.dart';

const String _v1 = '/api/v1';

/// ISO 8601 with offset, which the PRD asks for. `toIso8601String` on a
/// local `DateTime` has no offset, so it goes up as UTC.
String _stamp(DateTime d) => d.toUtc().toIso8601String();

String _date(DateTime d) => dateOf(d).toString();

class ApiActivityRepository implements ActivityRepository {
  ApiActivityRepository(this._api);

  final FluentpetApi _api;

  InteractionsApi get _interactions => _api.getInteractionsApi();

  @override
  Future<List<InteractionContext>> contexts({required bool forTeacher}) async {
    final contexts = _api.getContextsApi();
    final lists = await Future.wait(<Future<Response<BuiltList<ContextOut>>>>[
      contexts.listContexts(kind: forTeacher ? 'teacher' : 'learner'),
      contexts.listContexts(kind: 'custom'),
    ]);
    return <InteractionContext>[
      for (final r in lists)
        for (final c in r.data!) c.toDomain(),
    ];
  }

  @override
  Future<Interaction?> interaction(int id) async {
    try {
      final r = await _interactions.showInteraction(interactionId: id);
      return r.data!.toDomain(buttons: const <int, Button>{});
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<Activity> create(Activity activity) async {
    final tz = await deviceTimezone;
    switch (activity) {
      case Note():
        final r = await _api.getNotesApi().createNote(
          noteIn: NoteIn(
            (b) => b
              ..text = activity.body
              ..occurredAt = activity.occurredAt.toUtc()
              ..deviceTimezone = tz
              ..isFavourite = activity.isFlagged,
          ),
        );
        return r.data!.toDomain();
      case Interaction():
        final r = await _interactions.createInteraction(
          interactionIn: InteractionIn(
            (b) => b
              ..pusherId = _pusherId(activity.pusher)
              ..note = activity.note.isEmpty ? null : activity.note
              ..occurredAt = activity.occurredAt.toUtc()
              ..deviceTimezone = tz
              ..isFavourite = activity.isFlagged
              ..buttonIds.replace(activity.buttons.map((x) => x.id))
              ..contextIds.replace(activity.contexts.map((x) => x.id))
              ..modeledPusherIds.replace(
                activity.modeledPushers.map((x) => x.id),
              ),
          ),
        );
        return r.data!.toDomain(buttons: const <int, Button>{});
    }
  }

  @override
  Future<void> update(Activity activity) => switch (activity) {
    Note() => _api.dio.patch<void>(
      '$_v1/notes/${-activity.id}',
      data: {
        'text': activity.body,
        'occurred_at': _stamp(activity.occurredAt),
        'is_favourite': activity.isFlagged,
      },
    ),
    Interaction() => _api.dio.patch<void>(
      '$_v1/interactions/${activity.interactionId}',
      data: {
        'pusher_id': _pusherId(activity.pusher),
        'note': activity.note.isEmpty ? null : activity.note,
        'occurred_at': _stamp(activity.occurredAt),
        'is_favourite': activity.isFlagged,
        'button_ids': activity.buttons.map((x) => x.id).toList(),
        'context_ids': activity.contexts.map((x) => x.id).toList(),
        'modeled_pusher_ids': activity.modeledPushers.map((x) => x.id).toList(),
      },
    ),
  };

  @override
  Future<void> setFlag(Activity activity, bool flagged) =>
      _api.dio.patch<void>(_path(activity), data: {'is_favourite': flagged});

  @override
  Future<void> delete(Activity activity) =>
      _api.dio.delete<void>(_path(activity));

  @override
  Future<void> deleteMany(Iterable<Activity> activities) async {
    final interactions = activities.whereType<Interaction>().toList();
    if (interactions.isNotEmpty) {
      await _interactions.bulk(
        bulkIn: BulkIn(
          (b) => b
            ..operation = BulkInOperationEnum.delete
            ..ids.replace(interactions.map((i) => i.interactionId)),
        ),
      );
    }
    for (final note in activities.whereType<Note>()) {
      await delete(note);
    }
  }

  @override
  Future<void> assignMany(Iterable<Interaction> interactions, Pusher pusher) =>
      _interactions.bulk(
        bulkIn: BulkIn(
          (b) => b
            ..operation = BulkInOperationEnum.assign
            ..ids.replace(interactions.map((i) => i.interactionId))
            ..pusherId = pusher.id,
        ),
      );

  @override
  Future<void> merge(Iterable<Interaction> interactions) {
    final sorted = interactions.toList()
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    return _interactions.mergeInteractions(
      interactionId: sorted.first.interactionId,
      interactionMerge: InteractionMerge(
        (b) => b
          ..interactionIds.replace(sorted.skip(1).map((i) => i.interactionId)),
      ),
    );
  }

  @override
  Future<void> split(Interaction interaction) =>
      _interactions.splitInteraction(interactionId: interaction.interactionId);

  /// The pseudo-Pushers never go on the wire: unassigned is `null`.
  static int? _pusherId(Pusher p) => p.id < 0 ? null : p.id;

  static String _path(Activity a) => switch (a) {
    Note() => '$_v1/notes/${-a.id}',
    Interaction() => '$_v1/interactions/${a.interactionId}',
  };
}

class ApiHouseholdRepository implements HouseholdRepository {
  ApiHouseholdRepository(this._api);

  final FluentpetApi _api;

  HouseholdApi get _household => _api.getHouseholdApi();
  PushersApi get _pushers => _api.getPushersApi();

  @override
  Future<Household> household() async {
    final detail = await _household.getHousehold();
    final invitations = await _household.listInvitations();
    final h = detail.data!;
    final inv = invitations.data!;
    return Household(
      id: h.id,
      name: h.name,
      members: h.members.map((m) => m.toDomain()).toList(growable: false),
      invitations: <HouseholdInvitation>[
        for (final i in inv.sent)
          i.toDomain(HouseholdInvitationDirection.toCurrentHousehold),
        for (final i in inv.received)
          i.toDomain(HouseholdInvitationDirection.fromOtherHousehold),
      ],
    );
  }

  @override
  Future<HouseholdMember> me() async =>
      (await _api.getMeApi().getMe()).data!.toDomain();

  @override
  Future<void> updateMyName(String fullName) =>
      _api.getMeApi().patchMe(mePatch: MePatch((b) => b..fullName = fullName));

  @override
  Future<void> deleteAccount() => _api.getMeApi().deleteMe();

  @override
  Future<List<Pusher>> pushers() async {
    final types = await learnerTypes();
    final r = await _pushers.listPushers(includeHidden: true);
    return r.data!
        .map((p) => p.toDomain(learnerTypes: types))
        .toList(growable: false);
  }

  /// Seeded lowercase ("dog"); shown capitalised, once, here.
  @override
  Future<Map<int, String>> learnerTypes() async {
    final r = await _pushers.learnerTypes();
    return <int, String>{
      for (final t in r.data!)
        t.id: t.name.isEmpty
            ? t.name
            : t.name[0].toUpperCase() + t.name.substring(1),
    };
  }

  @override
  Future<Pusher> createPusher(Pusher pusher) async {
    final r = await _pushers.createPusher(
      pusherIn: PusherIn(
        (b) => b
          ..name = pusher.name
          ..isHuman = pusher.isHuman
          ..learnerTypeId = pusher.learnerTypeId
          ..subType = pusher.subType
          ..country = pusher.country
          ..language = pusher.language
          ..birthDate = pusher.birthDate == null
              ? null
              : dateOf(pusher.birthDate!)
          ..trainingStartedAt = pusher.trainingStartedAt == null
              ? null
              : dateOf(pusher.trainingStartedAt!),
      ),
    );
    return r.data!.toDomain();
  }

  @override
  Future<void> updatePusher(Pusher pusher) => _api.dio.patch<void>(
    '$_v1/pushers/${pusher.id}',
    data: {
      'name': pusher.name,
      'is_human': pusher.isHuman,
      'learner_type_id': pusher.learnerTypeId,
      'sub_type': pusher.subType,
      'country': pusher.country,
      'language': pusher.language,
      'birth_date': pusher.birthDate == null ? null : _date(pusher.birthDate!),
      'training_started_at': pusher.trainingStartedAt == null
          ? null
          : _date(pusher.trainingStartedAt!),
    },
  );

  @override
  Future<void> setPusherHidden(Pusher pusher, bool hidden) => _api.dio
      .patch<void>('$_v1/pushers/${pusher.id}', data: {'is_hidden': hidden});

  @override
  Future<void> invite(String email) => _household.createInvitation(
    invitationCreate: InvitationCreate((b) => b..email = email),
  );

  @override
  Future<void> withdrawInvitation(HouseholdInvitation invitation) =>
      _household.deleteInvitation(invitationId: invitation.id);

  @override
  Future<void> acceptInvitation(HouseholdInvitation invitation) =>
      _household.acceptInvitation(invitationId: invitation.id);

  @override
  Future<void> rejectInvitation(HouseholdInvitation invitation) =>
      _household.rejectInvitation(invitationId: invitation.id);

  @override
  Future<void> removeMember(HouseholdMember member) =>
      _household.removeMember(userId: member.id);

  @override
  Future<void> leaveHousehold() => _household.leaveHousehold();

  @override
  Future<Map<PreferenceKey, Object?>> preferences() async {
    final r = await _api.getPreferencesApi().getPreferences();
    return <PreferenceKey, Object?>{
      for (final key in PreferenceKey.values)
        if (r.data!.containsKey(key.wire)) key: r.data![key.wire]?.value,
    };
  }

  @override
  Future<void> setPreference(PreferenceKey key, Object? value) => _api.dio
      .put<void>('$_v1/preferences/${key.wire}', data: {'value': value});
}

class ApiHardwareRepository implements HardwareRepository {
  ApiHardwareRepository(this._api);

  final FluentpetApi _api;

  BasesApi get _bases => _api.getBasesApi();
  ButtonsApi get _buttons => _api.getButtonsApi();

  @override
  Future<List<Base>> bases() async {
    final bases = await _bases.listBases();
    final pushers = await _api.getPushersApi().listPushers(includeHidden: true);
    final byId = <int, Pusher>{
      for (final p in pushers.data!) p.id: p.toDomain(),
    };
    final now = DateTime.now();
    return bases.data!
        .map((b) => b.toDomain(pushers: byId, now: now))
        .toList(growable: false);
  }

  @override
  Future<Board> board() async {
    final r = await _buttons.listButtons(includeHidden: true);
    return Board(
      id: 0,
      userId: 0,
      buttons: r.data!.map((b) => b.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Map<int, String>> buttonConcepts() async {
    final r = await _buttons.buttonConcepts();
    return <int, String>{for (final c in r.data!) c.id: c.concept};
  }

  @override
  Future<void> registerBase({
    required String serialNumber,
    required String name,
  }) => _bases.registerBase(
    baseCreate: BaseCreate(
      (b) => b
        ..serialNumber = serialNumber
        ..name = name,
    ),
  );

  @override
  Future<void> updateBase(Base base) => _api.dio.patch<void>(
    '$_v1/bases/${base.serialNumber}',
    data: {
      'name': base.name,
      'default_pusher_id': base.defaultPusher?.id,
      'group_window_seconds': base.groupInteractionsWithinSeconds,
    },
  );

  @override
  Future<void> deleteBase(Base base) =>
      _bases.deleteBase(serial: base.serialNumber);

  @override
  Future<Button> createButton(Button button) async {
    final r = await _buttons.createButton(
      buttonCreate: ButtonCreate(
        (b) => b
          ..text = button.text
          ..note = button.note.isEmpty ? null : button.note
          ..introducedAt = button.introducedAt == null
              ? null
              : dateOf(button.introducedAt!)
          ..buttonConceptId = button.conceptId,
      ),
    );
    // `webhook_url` is not on the create body.
    if (button.webhookUrl != null) {
      await _api.dio.patch<void>(
        '$_v1/buttons/${r.data!.id}',
        data: {'webhook_url': button.webhookUrl},
      );
    }
    return r.data!.toDomain();
  }

  @override
  Future<void> updateButton(Button button) => _api.dio.patch<void>(
    '$_v1/buttons/${button.id}',
    data: {
      'text': button.text,
      'note': button.note.isEmpty ? null : button.note,
      'introduced_at': button.introducedAt == null
          ? null
          : _date(button.introducedAt!),
      'button_concept_id': button.conceptId,
      'audio_id': button.audioId,
      'webhook_url': button.webhookUrl,
    },
  );

  @override
  Future<void> setButtonHidden(Button button, bool hidden) => _api.dio
      .patch<void>('$_v1/buttons/${button.id}', data: {'is_hidden': hidden});

  @override
  Future<void> unlinkButton(Button button) =>
      _buttons.unlinkButton(buttonId: button.id);

  @override
  Future<void> mergeButtons({required Button source, required Button target}) =>
      _buttons.mergeButtons(
        buttonMerge: ButtonMerge(
          (b) => b
            ..sourceId = source.id
            ..targetId = target.id,
        ),
      );
}

extension on PreferenceKey {
  String get wire => switch (this) {
    PreferenceKey.activitySort => 'activity_sort',
    PreferenceKey.buttonSort => 'button_sort',
    PreferenceKey.defaultPusherId => 'default_pusher_id',
    PreferenceKey.pushFrequency => 'push_frequency',
  };
}

/// Wire → domain. One extension per generated model, nothing else.
///
/// The generated package (`packages/fluentpet_api`) is built_value classes
/// with `BuiltList`s and snake-case names mapped to camelCase; the screens
/// read the plain domain types in `lib/domain/`. Every conversion the app
/// makes is here, so a wire change is one file.
///
/// Two conventions worth knowing:
///
/// * A [Note]'s [Activity.id] is the **negative** of its wire id. The domain
///   keys a timeline row, a selection and an edit route by one `Activity.id`,
///   and the API keeps interactions and notes in separate id spaces, so
///   without this an interaction and a note could share an id and a bulk
///   delete would take both. `Interaction.interactionId` is always the wire
///   id; `-note.id` recovers a note's.
/// * An unattributed press (`pusher_id` null) is attributed to
///   [unassignedPusher], the pseudo-Pusher the domain already had for it.
library;

import 'package:fluentpet_api/fluentpet_api.dart';

import '../../domain/domain.dart';

/// `pusher_id` null on the wire. `PusherKind.fromWire` reads the name.
const Pusher unassignedPusher = Pusher(id: -2, name: 'base', isHuman: false);

/// What a free-standing Note is attributed to. Id -1 is the sentinel the
/// Log area discriminates a journal entry by.
const Pusher journalPusher = Pusher(
  id: Pusher.journalPusherId,
  name: 'event note',
  isHuman: false,
);

/// `last_online_at` older than this is drawn as offline. The PRD's
/// `base_offline` push fires at 36 h; the pill is stricter because a Base
/// that has not spoken in a day is, for the person looking at it, not online.
const Duration baseOnlineWindow = Duration(hours: 24);

/// A Button below this is "low", matching the PRD's `base_battery_low`.
const int lowBatteryPercent = 20;

extension PusherOutX on PusherOut {
  Pusher toDomain() => Pusher(
    id: id,
    name: name,
    isHuman: isHuman,
    isHidden: isHidden,
    avatarUri: avatarUrl,
  );
}

extension PusherDetailOutX on PusherDetailOut {
  Pusher toDomain({Map<int, String> learnerTypes = const <int, String>{}}) =>
      Pusher(
        id: id,
        name: name,
        isHuman: isHuman,
        isHidden: isHidden,
        avatarUri: avatarUrl,
        interactionsCount: interactionsCount,
        learnerTypeId: learnerTypeId,
        learnerType: learnerTypes[learnerTypeId],
        trainingStartedAt: trainingStartedAt?.toDateTime(),
        birthDate: birthDate?.toDateTime(),
        subType: subType,
        country: country,
        language: language,
      );
}

extension ContextOutX on ContextOut {
  InteractionContext toDomain() => InteractionContext(id: id, text: text);
}

extension ButtonOutX on ButtonOut {
  Button toDomain() => Button(
    id: id,
    boardId: 0,
    text: text,
    kind: ButtonKind.fromWire(
      type: baseButton == null ? null : ButtonKind.connect.wire,
      text: text,
    ),
    normalizedWord: normalizedWord,
    buttonPresses: pressCount,
    introducedAt: introducedAt?.toDateTime(),
    isHidden: isHidden,
    note: note ?? '',
    serialNumber: baseButton?.buttonSerialNumber,
    batteryLevel: baseButton?.batteryLevel,
    conceptId: buttonConceptId,
    audioId: audioId,
    webhookUrl: webhookUrl,
  );
}

extension BaseOutX on BaseOut {
  Base toDomain({required Map<int, Pusher> pushers, required DateTime now}) {
    final seen = lastOnlineAt?.toLocal();
    return Base(
      id: id,
      serialNumber: serialNumber,
      name: name,
      // Unknown (never reported) is -1 on `FpFormat.batteryLevel`'s scale,
      // not 0, which would read as a flat battery.
      batteryLevel: batteryLevel ?? -1,
      lastOnlineAt: seen,
      firmwareVersion: fwVersion ?? '',
      groupInteractionsWithinSeconds: groupWindowSeconds,
      defaultPusher: pushers[defaultPusherId],
      online: seen != null && now.difference(seen) < baseOnlineWindow,
      lowBatteryButtons: buttons
          .where(
            (b) =>
                b.batteryLevel != null && b.batteryLevel! <= lowBatteryPercent,
          )
          .length,
      pairedButtons: <PairedButton>[
        for (final b in buttons)
          // The PRD carries no per-Button firmware; the table in
          // `hardware_providers.dart` maps '' to "unknown".
          PairedButton(serialNumber: b.buttonSerialNumber, firmwareVersion: ''),
      ],
    );
  }
}

extension InteractionOutX on InteractionOut {
  /// [buttons] is the Board by id, so a press resolves to the full Button
  /// (kind, serial, introduced date) rather than the id-and-text the wire
  /// carries. A press whose Button is not on the Board — deleted since —
  /// still renders as its text.
  Interaction toDomain({required Map<int, Button> buttons}) {
    final ordered = presses.toList()
      ..sort((a, b) => a.pressOrder.compareTo(b.pressOrder));
    final at = occurredAt.toLocal();
    final pressed = <Button>[
      for (final p in ordered)
        buttons[p.buttonId] ??
            Button(
              id: p.buttonId,
              boardId: 0,
              text: p.text,
              kind: ButtonKind.classic,
            ),
    ];
    return Interaction(
      id: id,
      interactionId: id,
      occurredAt: at,
      pusher: pusher?.toDomain() ?? unassignedPusher,
      buttons: pressed,
      contexts: contexts.map((c) => c.toDomain()).toList(growable: false),
      origin: InteractionOrigin.fromWire(origin),
      baseId: createdByBaseId,
      createdAt: createdAt.toLocal(),
      deviceTimezone: deviceTimezone ?? '',
      modeledPushers: modeledPushers
          .map((p) => p.toDomain())
          .toList(growable: false),
      // A word whose Button entered the Board the day it was pressed.
      firstTimeWord: pressed
          .where((b) => b.introducedAt != null && _sameDay(b.introducedAt!, at))
          .map((b) => b.text)
          .firstOrNull,
      isFlagged: isFavourite,
      note: note ?? '',
    );
  }
}

extension NoteOutX on NoteOut {
  Note toDomain() => Note(
    id: -id,
    occurredAt: occurredAt.toLocal(),
    pusher: journalPusher,
    body: text,
    isFlagged: isFavourite,
  );
}

/// One row of `POST /interactions/search`, whichever kind it is.
///
/// The generator models `items` as an `anyOf`; the deserializer keeps every
/// type the payload parsed as, and the two schemas have disjoint required
/// fields, so exactly one is present.
Activity? searchItemToDomain(
  ItemsInner item, {
  required Map<int, Button> buttons,
}) {
  final parsed = item.anyOf.values.values;
  final interaction = parsed.whereType<InteractionOut>().firstOrNull;
  if (interaction != null) return interaction.toDomain(buttons: buttons);
  return parsed.whereType<NoteOut>().firstOrNull?.toDomain();
}

extension UserOutX on UserOut {
  HouseholdMember toDomain() => HouseholdMember(
    id: id,
    fullname: fullName ?? email,
    email: email,
    isAdmin: isHouseholdAdmin,
  );
}

extension MeOutX on MeOut {
  HouseholdMember toDomain() => HouseholdMember(
    id: id,
    fullname: fullName ?? email,
    email: email,
    isAdmin: isHouseholdAdmin,
  );
}

extension InvitationOutX on InvitationOut {
  /// Sent by my Household: the row is the invitee. Received: the row is the
  /// inviter, which is who the invitee needs to recognise.
  HouseholdInvitation toDomain(HouseholdInvitationDirection direction) =>
      HouseholdInvitation(
        id: id,
        fullname: direction == HouseholdInvitationDirection.toCurrentHousehold
            ? email
            : '$invitedBy · $householdName',
        email: email,
        direction: direction,
      );
}

/// The `Date` the generator uses for `format: date` fields, as a local
/// midnight — what the date pickers hand back and compare against.
extension DateX on Date {
  DateTime toDateTime() => DateTime(year, month, day);
}

Date dateOf(DateTime d) => Date(d.year, d.month, d.day);

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

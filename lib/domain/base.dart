import 'pusher.dart';

/// The FluentPet Connect hub device.
///
/// Groups presses that happen close together into a single Interaction, using
/// [groupInteractionsWithinSeconds].
///
/// Two wire notes worth keeping: `battery_level` arrives as a *string* and is
/// parsed to an int here; and the update endpoint addresses a Base by
/// [serialNumber], not by [id], even though it carries both.
class Base {
  const Base({
    required this.id,
    required this.serialNumber,
    required this.batteryLevel,
    required this.lastOnlineAt,
    this.pairedButtons = const <PairedButton>[],
    this.name,
    this.firmwareVersion = '',
    this.groupInteractionsWithinSeconds = 30,
    this.defaultPusher,
    this.online = true,
    this.lowBatteryButtons = 0,
  });

  final int id;
  final String serialNumber;

  /// The friendly name, e.g. "Kitchen Base". Optional on the wire.
  final String? name;

  /// 0..100.
  final int batteryLevel;

  final String firmwareVersion;

  /// When the Base last reported in, or **null when it never has**.
  ///
  /// Nullable because "never seen" and "seen a long time ago" are different
  /// facts about a device and only one of them can be a date.
  /// [FpFormat.lastSeen] has always had a rung for null; until this field
  /// admitted one, that rung was unreachable and a Base out of its box had no
  /// representation.
  final DateTime? lastOnlineAt;

  /// The Interaction grouping window, configurable per Base.
  final int groupInteractionsWithinSeconds;

  final Pusher? defaultPusher;

  /// Derived on the wire from the device shadow. Kept explicit because the
  /// second of the two jobs the design serves is answering it at a glance.
  final bool online;

  /// How many of this Base's paired Buttons report a low battery.
  final int lowBatteryButtons;

  /// The Buttons this Base's device shadow reports as paired to it.
  ///
  /// The link between a Base and a Button lives nowhere else: [Button] carries
  /// no Base reference, and on the wire the relationship is the Base's AWS IoT
  /// shadow — `state.reported.paired_children`, keyed by the physical Button's
  /// serial number (`docs/design-system/screen-inventory.md` §15).
  final List<PairedButton> pairedButtons;

  String get displayName => name ?? serialNumber;

  /// True of a Base that has never reported in at all.
  bool get everSeen => lastOnlineAt != null;
}

/// One Button a Base's device shadow reports as paired to it.
///
/// A serial number and the firmware that Button is running. The serial may
/// match no [Button] in the Board at all: paired to the hardware, absent from
/// the database, which the RN app draws as the literal word "unavailable"
/// (`BaseButton.tsx:33-39`). That is a real state, and dropping the row would
/// make the count disagree with the hardware.
///
/// [firmwareVersion] is the raw wire value — `1.3.20240308` and friends. The
/// mapping to a human version is a display concern and lives with the screens
/// that show it, so the table stays one thing.
class PairedButton {
  const PairedButton({
    required this.serialNumber,
    required this.firmwareVersion,
  });

  final String serialNumber;
  final String firmwareVersion;
}

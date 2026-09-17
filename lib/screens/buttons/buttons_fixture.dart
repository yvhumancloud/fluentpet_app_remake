/// Fixture data these five screens need that the shared Board does not carry.
///
/// `docs/second-pass-brief.md` reserves Buttons `1300`–`1399` and Sounds
/// `1400`–`1499` for this group. Everything in this file stays inside those
/// two blocks; nothing here is written to `lib/data/fixtures/**`, which
/// Foundation owns.
///
/// Two entities live here and neither is in `lib/domain/`:
///
/// * [ButtonSound] — Phase 1 has no audio capture and no playback (PLAN.md),
///   so "a Button has a recorded sound" has to be a fact to display rather
///   than a file to play. It is not promoted to `lib/domain/button.dart`
///   because nothing outside this group's screens reads it.
/// * The Meaning list — the RN screens source `ButtonConcept` from
///   `GET /api/v1/button_concepts`, which `screen-inventory.md` §15 does not
///   trace (the exact set is unknown from the client). [buttonMeanings] is
///   invented from the product's own vocabulary rather than left empty; a
///   Meaning picker with nothing in it is not a state the RN form reaches.
///
/// Both are display-only. Fixtures only, no persistence (PLAN.md): picking a
/// Meaning or attaching a Sound in these screens never writes back here.
library;

import '../../domain/domain.dart';

// ─────────────────────────── Buttons (1300–1399) ───────────────────────────

/// The Board id every fixture [Button] in this file declares.
///
/// Matches the shared Board's id (`lib/data/fixtures/activity_fixture.dart`'s
/// private `_boardId`, which is `3`). Duplicated as a literal because that
/// constant is private to its file. [justPairedButton] never enters the
/// shared Board — it is reached only through this group's own pairing flow —
/// so the two ids never have to agree on anything but what they display.
const int fixtureBoardId = 3;

/// The Connect Button `BUTTON_PAIRING` simulates having just linked.
///
/// Phase 1 has no BLE (PLAN.md): nothing on `BUTTON_PAIRING` scans for real
/// hardware, so there is no wire event that could ever produce a "just
/// paired" Button. This is the one stand-in, reachable only by that screen's
/// own `justPaired` flag and by the `BUTTON_CONVERSION` → `BUTTON_EDIT` →
/// `DOWNLOAD_SOUND` chain it feeds — never by an id another screen already
/// knows, which is why it is not folded into the shared Board fixture.
const Button justPairedButton = Button(
  id: 1300,
  boardId: fixtureBoardId,
  text: 'bell',
  kind: ButtonKind.connect,
  normalizedWord: 'bell',
  buttonPresses: 0,
  serialNumber: 'FPB-0A5D',
  batteryLevel: 96,
);

/// Every Button these screens can be asked to open, by id.
///
/// The shared Board (ids 101–128, per `docs/second-pass-brief.md`) plus
/// [justPairedButton]. `BUTTON_EDIT` and `BUTTON_CONVERSION` are reached both
/// from outside this group (`CLASSIC_BUTTONS`, `BASE_EDIT`, always with a
/// shared-Board id) and from `BUTTON_PAIRING`'s own success state (always
/// with `1300`), so the lookup has to cover both without either screen
/// caring which one it got.
Button? findButton(List<Button> boardButtons, int? id) {
  if (id == null) return null;
  for (final button in boardButtons) {
    if (button.id == id) return button;
  }
  if (id == justPairedButton.id) return justPairedButton;
  return null;
}

/// The Base a Connect [Button] is paired to, or null.
///
/// [Button] carries no Base reference on the wire — the link lives in the
/// Base's device shadow, `Base.pairedButtons`, keyed by the physical Button's
/// serial (see `lib/domain/base.dart`). This is the same join
/// `linkedButtonsProvider` in `lib/screens/hardware/hardware_providers.dart`
/// performs from the other direction; it is small enough, and specific enough
/// to what `BUTTON_EDIT`'s two read-only fields need, that duplicating the
/// join here beats importing a Hardware-owned provider for it.
Base? baseForButton(List<Base> bases, Button button) {
  final serial = button.serialNumber;
  if (serial == null) return null;
  for (final base in bases) {
    for (final paired in base.pairedButtons) {
      if (paired.serialNumber == serial) return base;
    }
  }
  return null;
}

// ─────────────────────────── Sounds (1400–1499) ───────────────────────────

/// A recorded sound already sitting on a Connect Button.
///
/// Stands in for what `ButtonAudio` (`src/components/ButtonAudio.tsx`)
/// records, plays back and deletes in the RN app. Phase 1 has neither a
/// microphone nor a player (PLAN.md), so this is a fact — a label and a
/// duration — rather than a file.
class ButtonSound {
  const ButtonSound({
    required this.id,
    required this.buttonId,
    required this.label,
    required this.durationSeconds,
  });

  final int id;
  final int buttonId;
  final String label;
  final double durationSeconds;
}

/// Sounds already attached to a couple of the shared Board's Connect
/// Buttons, keyed by Button id.
///
/// Everything else — [justPairedButton] included — has none, which is the
/// ordinary state for a Connect Button nobody has recorded a custom sound
/// for yet. Two is enough to design both states of `BUTTON_EDIT`'s audio
/// section without every Connect Button on the board needing one.
final Map<int, ButtonSound> buttonSounds = <int, ButtonSound>{
  121: const ButtonSound(
    id: 1400,
    buttonId: 121,
    label: 'Custom sound',
    durationSeconds: 1.8,
  ),
  125: const ButtonSound(
    id: 1401,
    buttonId: 125,
    label: 'Custom sound',
    durationSeconds: 2.4,
  ),
};

/// The id `DOWNLOAD_SOUND` is handed when `BUTTON_EDIT` simulates attaching a
/// freshly recorded sound to a Connect Button.
///
/// The RN screen gets this id back from `POST /api/v1/audio` after a real
/// upload (`ButtonEdit.tsx:168-174`). Phase 1 has no upload, so this single
/// constant always means "a sound was just attached this session" — it is
/// deliberately not a row in [buttonSounds], because it never was recorded.
const int simulatedNewSoundId = 1450;

// ─────────────────────────── Meanings ───────────────────────────

/// What a Button can mean, offered on `BUTTON_ADD` and `BUTTON_EDIT`'s
/// Meaning picker. See the library note for why this is invented rather than
/// read from a traced endpoint.
const List<String> buttonMeanings = <String>[
  'Request',
  'Feeling',
  'Person',
  'Place',
  'Action',
  'Descriptive',
  'Question',
  'Social',
];

/// The Meaning already recorded against a couple of the shared Board's
/// Buttons, keyed by Button id. Display-only fixture — [BUTTON_EDIT] reads
/// it to pre-select a Meaning; nothing writes it back.
final Map<int, String> buttonMeaningById = <int, String>{
  103: 'Request',
  121: 'Request',
  125: 'Feeling',
};

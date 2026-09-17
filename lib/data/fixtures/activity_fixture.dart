/// The Activity screen's data, ported from
/// `design-system/src/screens/activity-data.ts`.
///
/// This is the fixture the one fully designed screen was designed against, so
/// it is ported faithfully rather than re-invented: same Pushers, same eight
/// entries, same times, same Contexts, same notes, same flags. If the Activity
/// screen does not render identically to the specification, suspect the screen,
/// not this file.
///
/// Two things the TypeScript fixture leaves implicit are made explicit here:
///
/// * The times are "HH:MM" strings there. They become real timestamps on
///   2026-08-19, so the elapsed rail can derive its gaps from actual
///   [DateTime] arithmetic rather than from string maths.
/// * The day is labelled "Wednesday 19 August". The design fixture said
///   "Thursday" and was simply wrong: 2026-08-19 is a Wednesday, the date is
///   what every other fixture keys off, and only the day name was mistaken.
///   Corrected at the source — `design-system/src/screens/activity-data.ts` —
///   and carried across from there, so the two still agree.
///
/// ## What lives here that the design fixture does not have
///
/// The design fixture is one day of one screen. Four things beyond it are
/// declared here because they are facts about the **same** Pushers, Buttons and
/// Bases and a second file holding them is how two screens end up disagreeing
/// about one Household:
///
/// * **The Context catalogue.** Every Context any screen offers, with a stable
///   id each. Dashboard filtering matches Contexts by **id**, so a second
///   `InteractionContext` also called "evening" with a different id would
///   silently split the facet in two — which is exactly what happened while the
///   Activity and Log areas each declared their own list.
/// * **The Bases**, including the ones only the Hardware tab reaches, and the
///   Buttons each Base's device shadow reports as paired to it.
/// * **`introducedAt` on every Button**, so "sort by introduction date" is a
///   control that does something on all three screens that offer it.
/// * **`baseId` and `createdAt` on every Interaction**, which the Base filter
///   and the activity sort respectively cannot be evaluated without.
///
/// The **Board** is not here: it is the whole set of Buttons, ten of which are
/// the designed day's, and it is assembled once in `hardware_fixture.dart`.
library;

import '../../domain/domain.dart';
import '../../format/fp_format.dart';

/// The day every timestamp below sits on.
final DateTime _day = DateTime(2026, 8, 19);

DateTime _at(int hour, int minute) =>
    DateTime(_day.year, _day.month, _day.day, hour, minute);

/// Otis, the pet.
const Pusher learner = Pusher(
  id: 11,
  name: 'Otis',
  isHuman: false,
  learnerType: 'Dog',
  interactionsCount: 1284,
);

/// Sam, a human who models words.
const Pusher teacher = Pusher(
  id: 12,
  name: 'Sam',
  isHuman: true,
  interactionsCount: 96,
);

/// The pseudo-Pusher a free-standing Note is attributed to. Id -1 is the
/// API's sentinel, not a made-up value.
const Pusher eventNotePusher = Pusher(
  id: Pusher.journalPusherId,
  name: 'event note',
  isHuman: false,
);

/// The pseudo-Pusher a press with no attribution carries.
///
/// `PusherKind.fromWire` matches the literal lower-case name "base", so this is
/// the domain's [PusherKind.base] and not a Teacher. The id is invented: the
/// API's own id for it is not visible from the client, and -1 is already taken
/// by the event-note Pusher ([Pusher.journalPusherId]).
///
/// Beside [eventNotePusher] rather than in an area's fixture, because both are
/// wire sentinels the whole app has to agree about — the timeline draws one, the
/// Log screens exclude both from the Pusher strip, and the filter list excludes
/// both from its tags.
const Pusher basePusher = Pusher(id: -2, name: 'base', isHuman: false);

const int _boardId = 3;

// ─────────────────────────── Contexts ───────────────────────────

/// Every Context the Household has, Learner list then Teacher list.
///
/// One catalogue, one id per text, reached by every screen that offers a
/// Context: the Log screens' checklist, the filter sheet's tags, and the
/// generated history in `activity_extra_fixture.dart`. It was three lists in
/// three files, with three different ids for "morning", until they were merged.
///
/// Ids are explicit rather than minted in iteration order, because a filter
/// saved against id 505 has to keep meaning "living room" after somebody adds a
/// word to the list above it.
const List<InteractionContext> learnerContexts = <InteractionContext>[
  InteractionContext(id: 501, text: 'morning'),
  InteractionContext(id: 502, text: 'by the door'),
  InteractionContext(id: 503, text: 'kitchen'),
  InteractionContext(id: 504, text: 'after breakfast'),
  InteractionContext(id: 505, text: 'living room'),
  InteractionContext(id: 506, text: 'evening'),
  InteractionContext(id: 507, text: 'sofa'),
  InteractionContext(id: 508, text: 'before the walk'),
  InteractionContext(id: 509, text: 'raining'),
  InteractionContext(id: 510, text: 'unprompted'),
  InteractionContext(id: 511, text: 'bedtime'),
  InteractionContext(id: 512, text: 'visitor at the door'),
  // Deliberately long: Contexts wrap, and a list of short tags would never
  // prove it.
  InteractionContext(id: 513, text: 'just after the second walk of the afternoon'),
];

/// The Contexts offered when the Pusher is a Teacher — a human modelling.
///
/// **"Modeled" is load-bearing and is spelled exactly this way.** Three code
/// paths in the RN app key off the literal string — the auto-select on choosing
/// a Teacher, the removal on switching back to a Learner, and the Teacher list
/// itself (`docs/design-system/screen-inventory.md` §15). The spelling is the
/// API's, one "l", and it is not corrected here. It is first because the Log
/// screen selects the first thing this list contains.
const List<InteractionContext> teacherContexts = <InteractionContext>[
  InteractionContext(id: 551, text: modeledContextText),
  InteractionContext(id: 552, text: 'modelling'),
  InteractionContext(id: 553, text: 'training session'),
  InteractionContext(id: 554, text: 'repetition'),
  InteractionContext(id: 555, text: 'prompted'),
  InteractionContext(id: 556, text: 'shaping a new word'),
];

/// The literal Context name three rules turn on. See [teacherContexts].
const String modeledContextText = 'Modeled';

/// Both lists, in the order a filter sheet offers them.
final List<InteractionContext> allContexts =
    List<InteractionContext>.unmodifiable(<InteractionContext>[
  ...learnerContexts,
  ...teacherContexts,
]);

/// The catalogue by text, so a Context is always the *same instance* rather
/// than an equal-looking one with a different id.
final Map<String, InteractionContext> contextsByText =
    Map<String, InteractionContext>.unmodifiable(<String, InteractionContext>{
  for (final InteractionContext c in allContexts) c.text: c,
});

/// The Contexts named by [texts], from the one catalogue.
///
/// Throws on an unknown text rather than minting a new Context, because a typo
/// that quietly created id 999 is the drift this catalogue exists to stop.
List<InteractionContext> contexts(List<String> texts) => texts
    .map((t) => contextsByText[t] ?? (throw ArgumentError('No Context "$t"')))
    .toList(growable: false);

// ─────────────────────────── Buttons ───────────────────────────

/// The Buttons behind the words in the fixture. The design fixture carries bare
/// strings; the domain carries Buttons, so the words are backed by real ones.
///
/// `introducedAt` is invented — the design fixture has no such field and the
/// API's is `introduced_at` on the Button. Without it, "sort by introduction
/// date" on `LOG`, `CLASSIC_BUTTONS` and the linked-Button list is a control
/// that visibly does nothing. The dates are ordered so the sort is legible:
/// "outside" and "food" are the oldest words and "Sam" is the newest, which is
/// the word the designed day marks as a first-time press.
final Map<String, Button> buttonsByWord = Map<String, Button>.unmodifiable(
    <String, Button>{
  'outside': Button(id: 101, boardId: _boardId, text: 'outside', kind: ButtonKind.connect, normalizedWord: 'outside', buttonPresses: 214, serialNumber: 'FPB-0A31', batteryLevel: 84, introducedAt: DateTime(2024, 11, 3)),
  'now': Button(id: 102, boardId: _boardId, text: 'now', kind: ButtonKind.connect, normalizedWord: 'now', buttonPresses: 97, serialNumber: 'FPB-0A32', batteryLevel: 61, introducedAt: DateTime(2025, 1, 24)),
  'food': Button(id: 103, boardId: _boardId, text: 'food', kind: ButtonKind.connect, normalizedWord: 'food', buttonPresses: 331, serialNumber: 'FPB-0A33', batteryLevel: 12, introducedAt: DateTime(2024, 11, 3)),
  'play': Button(id: 104, boardId: _boardId, text: 'play', kind: ButtonKind.connect, normalizedWord: 'play', buttonPresses: 152, serialNumber: 'FPB-0A34', batteryLevel: 77, introducedAt: DateTime(2025, 4, 12)),
  'water': Button(id: 105, boardId: _boardId, text: 'water', kind: ButtonKind.connect, normalizedWord: 'water', buttonPresses: 64, serialNumber: 'FPB-0A35', batteryLevel: 90, introducedAt: DateTime(2024, 12, 19)),
  'Sam': Button(id: 106, boardId: _boardId, text: 'Sam', kind: ButtonKind.connect, normalizedWord: 'sam', buttonPresses: 1, serialNumber: 'FPB-0A36', batteryLevel: 100, introducedAt: DateTime(2026, 8, 19)),
  'come': Button(id: 107, boardId: _boardId, text: 'come', kind: ButtonKind.connect, normalizedWord: 'come', buttonPresses: 43, serialNumber: 'FPB-0A37', batteryLevel: 88, introducedAt: DateTime(2026, 5, 17)),
  'love': Button(id: 108, boardId: _boardId, text: 'love', kind: ButtonKind.classic, normalizedWord: 'love', buttonPresses: 12, introducedAt: DateTime(2025, 9, 30)),
  'you': Button(id: 109, boardId: _boardId, text: 'you', kind: ButtonKind.classic, normalizedWord: 'you', buttonPresses: 18, introducedAt: DateTime(2025, 9, 30)),
  'bed': Button(id: 110, boardId: _boardId, text: 'bed', kind: ButtonKind.connect, normalizedWord: 'bed', buttonPresses: 88, serialNumber: 'FPB-0A38', batteryLevel: 55, introducedAt: DateTime(2025, 2, 8)),
});

/// The board every Button in this fixture belongs to.
const int boardId = _boardId;

List<Button> _words(List<String> words) =>
    words.map((w) => buttonsByWord[w]!).toList(growable: false);

// ─────────────────────────── Bases ───────────────────────────

/// "Kitchen Base" — online, 87 percent, one Button low, synced two minutes ago.
///
/// Its shadow reports seven paired Buttons, six of which are in the Board. The
/// seventh, `FPB-0AFF`, deliberately is not: paired to the hardware, absent
/// from the database, which the RN app draws as the literal word "unavailable"
/// (`BaseButton.tsx:33-39`). It is the one edge case that list has.
final Base kitchenBase = Base(
  id: 7,
  serialNumber: 'FPC-1187-KTCH',
  name: 'Kitchen Base',
  batteryLevel: 87,
  firmwareVersion: '2.4.1',
  lastOnlineAt: _at(20, 14),
  groupInteractionsWithinSeconds: 30,
  defaultPusher: learner,
  lowBatteryButtons: 1,
  pairedButtons: const <PairedButton>[
    // Two of the six wire versions the firmware table calls "latest".
    PairedButton(serialNumber: 'FPB-0A31', firmwareVersion: '1.3.20240308'),
    PairedButton(serialNumber: 'FPB-0A32', firmwareVersion: '1.3.20230428'),
    // Mapped, but not latest — the "outdated, try re-linking" path.
    PairedButton(serialNumber: 'FPB-0A33', firmwareVersion: '1.3.20230221'),
    PairedButton(serialNumber: 'FPB-0A34', firmwareVersion: '1.3.20240308'),
    // Not in the table at all: the version reads as unknown, not as outdated.
    PairedButton(serialNumber: 'FPB-0A35', firmwareVersion: '1.3.20250114'),
    PairedButton(serialNumber: 'FPB-0A36', firmwareVersion: '1.3.20240308'),
    // In the shadow, not in the database.
    PairedButton(serialNumber: 'FPB-0AFF', firmwareVersion: '1.3.20221018'),
  ],
);

/// A second Base, offline, so the Hardware screens have a failure to draw. Not
/// in the design fixture — invented, and only reachable from the Hardware tab.
final Base porchBase = Base(
  id: 8,
  serialNumber: 'FPC-2043-PRCH',
  name: 'Porch Base',
  batteryLevel: 31,
  firmwareVersion: '2.3.9',
  lastOnlineAt: _at(9, 2),
  groupInteractionsWithinSeconds: 45,
  defaultPusher: learner,
  online: false,
  pairedButtons: const <PairedButton>[
    PairedButton(serialNumber: 'FPB-0A37', firmwareVersion: '1.3.20221018'),
    PairedButton(serialNumber: 'FPB-0A38', firmwareVersion: '1.3.20240308'),
  ],
);

/// The unnamed, unreadable, long-offline Base.
///
/// §15 asks for "2–3 Bases: one named, one unnamed (so the name fallback
/// shows), one with `battery_level` absent but a shadow, one with neither,
/// varied `last_online_at` including several days ago". This is the third:
///
/// * **No name.** `Base.displayName` falls back to the serial number. The RN
///   app falls back to the literal word "Base" (`helpers/baseName.ts`), which
///   is useless the moment a Household owns two of them.
/// * **Battery [FpFormat.chargingWireSentinel].** `-1` is the wire's charging
///   sentinel and `FpFormat.batteryLevel` reports it as unknown. What this Base
///   exercises is the health pill with no percent to show.
/// * **Nine days offline.** Past a week the last-seen ladder stops counting
///   days and gives the date — the rung nothing else here reaches.
final Base spareBase = Base(
  id: 9,
  serialNumber: 'FPC-3310-SPRE',
  batteryLevel: FpFormat.chargingWireSentinel,
  lastOnlineAt: _at(20, 16).subtract(const Duration(days: 9, hours: 3)),
  groupInteractionsWithinSeconds: 120,
  online: false,
);

/// A Base that has never reported in at all — §15's "one with neither".
///
/// `lastOnlineAt` is null, which is the only way `FpFormat.lastSeen`'s "Never
/// seen" rung is reachable. Until [Base.lastOnlineAt] became nullable there was
/// no way to express a Base straight out of its box, and that rung was
/// unreachable code.
const Base neverSeenBase = Base(
  id: 10,
  serialNumber: 'FPC-4102-STDO',
  name: 'Studio Base',
  batteryLevel: FpFormat.chargingWireSentinel,
  lastOnlineAt: null,
  online: false,
);

// ─────────────────────────── the designed day ───────────────────────────

/// How long after a press the Base gets the row to the server.
///
/// Small and constant: an entry a Base recorded is logged as it happens, and
/// the difference between `occurred_at` and `created_at` only becomes
/// interesting for something a person typed in afterwards — see
/// `activity_extra_fixture.dart`, where app-origin entries are logged hours
/// late on purpose.
const Duration _uploadDelay = Duration(seconds: 2);

/// The eight entries of the designed day, in the design's order.
final List<Activity> activities = <Activity>[
  Interaction(
    id: 9001, interactionId: 1, occurredAt: _at(7, 42), pusher: learner,
    buttons: _words(<String>['outside', 'now']),
    contexts: contexts(<String>['morning', 'by the door']),
    boardId: _boardId, deviceTimezone: 'Europe/London',
    baseId: 7, createdAt: _at(7, 42).add(_uploadDelay),
  ),
  Interaction(
    id: 9002, interactionId: 2, occurredAt: _at(8, 4), pusher: learner,
    buttons: _words(<String>['food']),
    contexts: contexts(<String>['kitchen']),
    boardId: _boardId, deviceTimezone: 'Europe/London',
    baseId: 7, createdAt: _at(8, 4).add(_uploadDelay),
  ),
  Interaction(
    id: 9003, interactionId: 3, occurredAt: _at(9, 16), pusher: learner,
    buttons: _words(<String>['play', 'outside', 'now']),
    contexts: contexts(<String>['after breakfast']),
    note: 'Brought the rope toy over first, then pressed all three.',
    isFlagged: true,
    boardId: _boardId, deviceTimezone: 'Europe/London',
    baseId: 7, createdAt: _at(9, 16).add(_uploadDelay),
  ),
  Interaction(
    id: 9004, interactionId: 4, occurredAt: _at(11, 30), pusher: teacher,
    buttons: _words(<String>['water']),
    contexts: contexts(<String>['modelling']),
    boardId: _boardId, deviceTimezone: 'Europe/London',
    baseId: 7, createdAt: _at(11, 30).add(_uploadDelay),
  ),
  Interaction(
    id: 9005, interactionId: 5, occurredAt: _at(13, 58), pusher: learner,
    buttons: _words(<String>['Sam', 'come']),
    contexts: contexts(<String>['living room']),
    firstTimeWord: 'Sam',
    modeledPushers: const <Pusher>[teacher],
    boardId: _boardId, deviceTimezone: 'Europe/London',
    baseId: 7, createdAt: _at(13, 58).add(_uploadDelay),
  ),
  Interaction(
    id: 9006, interactionId: 6, occurredAt: _at(15, 20), pusher: learner,
    buttons: _words(<String>['outside']),
    boardId: _boardId, deviceTimezone: 'Europe/London',
    baseId: 7, createdAt: _at(15, 20).add(_uploadDelay),
  ),
  Interaction(
    id: 9007, interactionId: 7, occurredAt: _at(18, 47), pusher: learner,
    buttons: _words(<String>['love', 'you']),
    contexts: contexts(<String>['evening', 'sofa']),
    note: 'Unprompted. Second time this week.',
    isFlagged: true,
    boardId: _boardId, deviceTimezone: 'Europe/London',
    baseId: 7, createdAt: _at(18, 47).add(_uploadDelay),
  ),
  Interaction(
    id: 9008, interactionId: 8, occurredAt: _at(20, 12), pusher: learner,
    buttons: _words(<String>['bed']),
    contexts: contexts(<String>['evening']),
    boardId: _boardId, deviceTimezone: 'Europe/London',
    baseId: 7, createdAt: _at(20, 12).add(_uploadDelay),
  ),
];

/// A free-standing Note, so the timeline's second Activity kind has data.
///
/// Not in the design fixture. The design system draws this state on its
/// components page and marks it invented there; the same is true here. It is
/// kept out of [activities] so the Activity screen still matches the spec, and
/// is reachable through [activitiesWithNote].
final Note standaloneNote = Note(
  id: 9009,
  occurredAt: _at(12, 5),
  pusher: eventNotePusher,
  body: 'Vet said the limp is nothing. Back to normal walks from tomorrow.',
);

/// The designed day plus the free-standing Note, in time order.
List<Activity> get activitiesWithNote {
  final all = <Activity>[...activities, standaloneNote]
    ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
  return List<Activity>.unmodifiable(all);
}

/// The day the Activity screen renders.
final ActivityDay today = ActivityDay(
  label: 'Today',
  longLabel: 'Wednesday 19 August',
  asOf: _at(20, 16),
  activities: List<Activity>.unmodifiable(activities),
);

/// The moment every screen renders "now" as.
///
/// The designed day's own `asOf` — 2026-08-19 20:16 — so "2 min ago" on the
/// Hardware tab and the timeline's last row describe the same moment. A wall
/// clock would drag every relative time away from the fixture within a day and
/// turn the designed states into whatever today happens to be. This becomes
/// `DateTime.now()` in the integration phase, in one place.
DateTime get asOf => today.asOf;

/// Hardware fixtures: the Bases and **the** Board.
///
/// There is one Board in this app and it is assembled here. That sentence is
/// the whole point of this file: for a while there were two — the Activity tab
/// filtered against a Board with an `inaudible` Button and thirteen extras, and
/// the Hardware tab merged a different pair of extras onto the shared ten in a
/// provider, so `CLASSIC_BUTTONS` listed Buttons the Log screen's Board did not
/// have and both were "the Board". Every Button any screen can show is in
/// [board], and every screen reaches it through `HardwareRepository.board()`.
///
/// The Bases come from `activity_fixture.dart`, where the designed day's own
/// Base lives, so the device health pill in the Activity header and the
/// Hardware tab cannot disagree about the same device.
///
/// ## What the Board owes, and where each debt comes from
///
/// `docs/design-system/screen-inventory.md` §15 asks the fixture for a Board
/// that reaches the states the screens draw. The designed day's ten Buttons
/// reach none of the following, so [extraButtons] supplies them:
///
/// * **An `inaudible` Button.** It is pinned last on every Button board
///   (`ButtonsBoard.tsx:121-129`) and the filter sheet's tag list is built as
///   `inaudibleButton && [inaudibleButton, ...rest]`, which renders **zero**
///   tags on a Board without one (§5, very likely a real bug). Neither
///   behaviour had data to run against.
/// * **An archived Button.** `Board.activeButtons` drops hidden Buttons, and
///   without one that is a filter with nothing to filter — archiving a Button
///   would have no observable before and after.
/// * **A vocabulary bigger than ten words**, including a meaning that is a
///   whole phrase, so the timeline's "the row never truncates" rule is exercised
///   by data rather than only by the component gallery.
library;

import '../../domain/domain.dart';
import 'activity_fixture.dart' as activity;

/// Every Base the Household owns.
///
/// Kitchen first, because it is the one the designed screen shows. The other
/// three are §15's list: an unnamed one so the name fallback shows, one with no
/// usable battery reading, and one that has never reported at all.
final List<Base> bases = List<Base>.unmodifiable(<Base>[
  activity.kitchenBase,
  activity.porchBase,
  activity.spareBase,
  activity.neverSeenBase,
]);

/// The Buttons the designed day never needed. See the library note for what
/// each is here to make reachable.
///
/// `inaudible` is never the wire value of `Button.type` — the app finds it by
/// matching the *text*, which [ButtonKind.fromWire] reproduces. Constructing it
/// with [ButtonKind.inaudible] directly says the same thing without repeating
/// the string match.
///
/// "car" is hidden, which is what archived means: absent from
/// [Board.activeButtons] and from every count on every screen.
final List<Button> extraButtons = List<Button>.unmodifiable(<Button>[
  Button(id: 120, boardId: activity.boardId, text: 'inaudible', kind: ButtonKind.inaudible, normalizedWord: 'inaudible', buttonPresses: 37, introducedAt: DateTime(2024, 11, 3)),
  Button(id: 121, boardId: activity.boardId, text: 'walk', kind: ButtonKind.connect, normalizedWord: 'walk', buttonPresses: 176, serialNumber: 'FPB-0A39', batteryLevel: 43, introducedAt: DateTime(2024, 12, 1)),
  Button(id: 122, boardId: activity.boardId, text: 'treat', kind: ButtonKind.connect, normalizedWord: 'treat', buttonPresses: 208, serialNumber: 'FPB-0A3A', batteryLevel: 18, introducedAt: DateTime(2025, 1, 6)),
  Button(id: 123, boardId: activity.boardId, text: 'later', kind: ButtonKind.classic, normalizedWord: 'later', buttonPresses: 22, introducedAt: DateTime(2025, 5, 2)),
  Button(id: 124, boardId: activity.boardId, text: 'please', kind: ButtonKind.classic, normalizedWord: 'please', buttonPresses: 31, introducedAt: DateTime(2025, 6, 14)),
  Button(id: 125, boardId: activity.boardId, text: 'scritches', kind: ButtonKind.connect, normalizedWord: 'scritches', buttonPresses: 58, serialNumber: 'FPB-0A3B', batteryLevel: 72, introducedAt: DateTime(2025, 11, 9)),
  Button(id: 126, boardId: activity.boardId, text: 'mad', kind: ButtonKind.classic, normalizedWord: 'mad', buttonPresses: 6, introducedAt: DateTime(2026, 2, 21)),
  // A meaning can be a whole phrase, and the timeline must wrap it rather than
  // truncate it. Components page, Utterance row: "The row never truncates the
  // words."
  Button(id: 127, boardId: activity.boardId, text: 'I want to go outside right now please', kind: ButtonKind.classic, normalizedWord: 'i want to go outside right now please', buttonPresses: 3, introducedAt: DateTime(2026, 6, 30)),
  // Archived. It was on the board for a fortnight in 2025 and came off again.
  Button(id: 128, boardId: activity.boardId, text: 'car', kind: ButtonKind.classic, normalizedWord: 'car', buttonPresses: 26, isHidden: true, introducedAt: DateTime(2025, 3, 17)),
]);

/// The one Board: the designed day's ten Buttons and the nine beyond them.
///
/// `Board.activeButtons` drops the archived one, so the Board has 19 Buttons
/// and 18 active. Nothing merges anything onto this afterwards — a provider
/// that added a Button here would be the second Board again.
final Board board = Board(
  id: activity.boardId,
  userId: 1,
  buttons: List<Button>.unmodifiable(<Button>[
    ...activity.buttonsByWord.values,
    ...extraButtons,
  ]),
);

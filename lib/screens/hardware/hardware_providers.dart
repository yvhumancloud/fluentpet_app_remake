/// What the four Hardware screens read, and the joins none of them should do
/// twice.
///
/// These are area-local on purpose. `lib/data/providers.dart` is the shared
/// surface every area watches; anything only Hardware needs — the Base/Button
/// link, the Button sort, the firmware table — belongs beside the screens that
/// need it, not in a file three areas import.
///
/// ## The Linked Buttons count, and why it is a provider
///
/// The RN app's count is wrong in a way that is invisible until you look for
/// it. `BaseItem` asks `useBaseButtonMetadata(base)` with no sort argument
/// (`BaseItem.tsx:29`); inside, that becomes `useBoard(undefined, { enabled:
/// !!undefined })` — a **disabled** query (`useBaseButtonMetadata.ts:16-18`).
/// It then reports `isFetched: board !== undefined`, which is only ever true
/// because a stray `useBoard()` on the Activity tab populated the same React
/// Query cache key and `console.log`ged the result (`Dashboard.tsx:28-29`). So
/// the Hardware tab's count is correct if — and only if — the user visited
/// Activity first, and spins forever otherwise
/// (`docs/design-system/screen-inventory.md` §9, §14.9).
///
/// The fix is structural, not a patch: [linkedButtonsProvider] derives the
/// count from [hardwareBoardProvider], which the Hardware area fetches itself.
/// There is no cache key shared with another tab and no other screen that has
/// to have run. The loading state belongs to this provider and resolves; the
/// zero state is a real zero rather than a spinner that never stops.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';

// ─────────────────────────── the clock ───────────────────────────

/// "Now", for every relative time on these screens.
///
/// The app's one clock, [nowProvider], under this area's own name — so a screen
/// here reads a time from a provider rather than from `DateTime.now()`, and so
/// the Hardware tab's "2 min ago" and the Activity header's are the same two
/// minutes. It used to read a second `asOf` declared in a Hardware-only
/// fixture, which was the same instant only by agreement.
final Provider<DateTime> hardwareNowProvider =
    Provider<DateTime>((ref) => ref.watch(nowProvider));

// ─────────────────────── Bases and the Board ───────────────────────

/// Every Base the Hardware tab lists, and the one Board.
///
/// Both are straight forwards of the shared providers, and that is the point.
/// They used to merge a Hardware-only fixture on top — a third Base and two
/// extra Buttons — which meant `CLASSIC_BUTTONS` listed Buttons the Log
/// screen's Board did not have. The extras are in the shared fixture now, so
/// there is one Board and these are its name inside this area.
final FutureProvider<List<Base>> hardwareBasesProvider =
    FutureProvider<List<Base>>((ref) => ref.watch(basesProvider.future));

final FutureProvider<Board> hardwareBoardProvider =
    FutureProvider<Board>((ref) => ref.watch(boardProvider.future));

/// One Base by serial number, or null.
///
/// `BASE_EDIT` is reached by serial — that is what the RN route carries and
/// what the update endpoint addresses — and the RN screen finds its Base by
/// searching the cached list (`BaseEditScreen.tsx:104`). There is no
/// fetch-by-id on the wire, so this searches too; what it does differently is
/// return null honestly instead of rendering an empty form under a live SAVE
/// bar.
// The family's own class is not exported by flutter_riverpod, so this one
// declaration takes its type from the builder rather than naming it.
final baseBySerialProvider =
    Provider.family<AsyncValue<Base?>, String>((ref, serialNumber) {
  return ref.watch(hardwareBasesProvider).whenData((bases) {
    for (final base in bases) {
      if (base.serialNumber == serialNumber) return base;
    }
    return null;
  });
});

// ─────────────────────── linked Buttons ───────────────────────

/// One row of a Base's linked-Button list.
///
/// [button] is null for a serial the Base's shadow reports but the database
/// does not know. The RN app draws that as a disabled badge reading the
/// literal `"unavailable"` (`BaseButton.tsx:33-39`); it is a real state, not a
/// loading state, and it keeps its row because a Button the Base thinks it has
/// is exactly the thing a person came here to find.
class LinkedButton {
  const LinkedButton({
    required this.serialNumber,
    required this.firmwareVersion,
    this.button,
  });

  final String serialNumber;

  /// The raw wire firmware string, e.g. `1.3.20240308`. Mapped for display by
  /// [ButtonFirmware.of].
  final String firmwareVersion;

  final Button? button;

  /// Present in the database, so it can be opened, merged or unlinked.
  bool get isKnown => button != null;

  /// The meaning this Button speaks, or the word the RN app uses for a Button
  /// it cannot resolve.
  String get label => button?.text ?? 'unavailable';

  /// The last four characters of the serial — the only part the RN row shows
  /// (`BaseButton.tsx:43`), because that is what is printed on the hardware.
  String get shortSerial => serialNumber.length <= _shortSerialLength
      ? serialNumber
      : serialNumber.substring(serialNumber.length - _shortSerialLength);

  static const int _shortSerialLength = 4;
}

/// Base serial number → its linked Buttons, joined from the Board.
///
/// The join is [Base.pairedButtons] — the device shadow's `paired_children` —
/// on one side and the Board on the other, which is what
/// `useBaseButtonMetadata` was trying to do before its query was disabled. A
/// serial with no Button behind it stays in the list as an unavailable row
/// rather than being dropped, because dropping it would make the count
/// disagree with the hardware.
final FutureProvider<Map<String, List<LinkedButton>>> linkedButtonsProvider =
    FutureProvider<Map<String, List<LinkedButton>>>((ref) async {
  final board = await ref.watch(hardwareBoardProvider.future);
  final bases = await ref.watch(hardwareBasesProvider.future);
  final bySerial = <String, Button>{
    for (final button in board.buttons)
      if (button.serialNumber != null) button.serialNumber!: button,
  };

  return Map<String, List<LinkedButton>>.unmodifiable(
    <String, List<LinkedButton>>{
      for (final base in bases)
        base.serialNumber: List<LinkedButton>.unmodifiable(<LinkedButton>[
          for (final paired in base.pairedButtons)
            LinkedButton(
              serialNumber: paired.serialNumber,
              firmwareVersion: paired.firmwareVersion,
              button: bySerial[paired.serialNumber],
            ),
        ]),
    },
  );
});

// ─────────────────────── Button firmware ───────────────────────

/// The wire firmware string a Connect Button reports, translated.
///
/// Six values map to a human version and everything else does not. The table
/// is the RN app's, verbatim (`src/Home/Base/helpers/contants.ts` — the
/// filename typo is in the repo), and "latest" is its two newest entries
/// (`isLatestVersion`). Reproduced rather than re-derived: the values come off
/// physical hardware in the field and inventing a rule here would only be
/// wrong differently.
enum ButtonFirmware {
  /// Mapped, and one of the two the app calls current.
  latest,

  /// Mapped, but behind. The RN alert tells the user to re-link.
  outdated,

  /// Not in the table. Unknown is not the same as outdated and must not be
  /// drawn as though it were.
  unknown;

  static const Map<String, String> _versions = <String, String>{
    '1.3.20240308': '1.0.7',
    '1.3.20230428': '1.0.3',
    '1.3.20230221': '1.0.1',
    '1.3.20230117': '0.1.1',
    '1.3.20221214': '0.1.0',
    '1.3.20221018': '0.0.1',
  };

  static const Set<String> _latest = <String>{'1.3.20230428', '1.3.20240308'};

  static ButtonFirmware of(String wireVersion) {
    if (!_versions.containsKey(wireVersion)) return ButtonFirmware.unknown;
    return _latest.contains(wireVersion)
        ? ButtonFirmware.latest
        : ButtonFirmware.outdated;
  }

  /// The human version, or null when the wire value is not in the table.
  static String? label(String wireVersion) => _versions[wireVersion];
}

// ─────────────────────── Button sort ───────────────────────

/// The three ways a Button board can be ordered.
///
/// The same three the RN app offers on `LOG`, `CLASSIC_BUTTONS` and the
/// linked-Button list, with its own labels (`ButtonSort.tsx`). One enum, one
/// notifier: those three surfaces share a single `button_sort` preference on
/// the wire, so they must not drift into three local orders here.
enum ButtonSort {
  alphabetical('A–Z'),
  introduced('Introduced'),
  mostUsed('Most used');

  const ButtonSort(this.label);

  final String label;

  ButtonSort get next => ButtonSort.values[(index + 1) % ButtonSort.values.length];
}

/// The Button sort, shared by `CLASSIC_BUTTONS` and the linked-Button list.
///
/// Held in memory. On the wire this is the `button_sort` user preference and a
/// PATCH per change; phase 1 writes nothing (§15), so the choice survives a tab
/// switch and not a restart, and that limitation is the fixture's rather than
/// the screen's.
final NotifierProvider<ButtonSortNotifier, ButtonSort> buttonSortProvider =
    NotifierProvider<ButtonSortNotifier, ButtonSort>(ButtonSortNotifier.new);

class ButtonSortNotifier extends Notifier<ButtonSort> {
  @override
  ButtonSort build() => ButtonSort.alphabetical;

  void set(ButtonSort sort) => state = sort;

  void cycle() => state = state.next;
}

/// [buttons] in [sort] order.
///
/// Introduction date falls back to the Button id where `introducedAt` is null.
/// The shared fixture now carries a real date on every Button, so the fallback
/// is defensive rather than the normal case — it used to be every Button, which
/// made "Introduced" a control that visibly did nothing.
List<Button> sortButtons(Iterable<Button> buttons, ButtonSort sort) {
  final list = buttons.toList();
  switch (sort) {
    case ButtonSort.alphabetical:
      list.sort((a, b) => a.text.toLowerCase().compareTo(b.text.toLowerCase()));
    case ButtonSort.introduced:
      list.sort((a, b) {
        final at = a.introducedAt;
        final bt = b.introducedAt;
        if (at != null && bt != null) return at.compareTo(bt);
        if (at != null) return -1;
        if (bt != null) return 1;
        return a.id.compareTo(b.id);
      });
    case ButtonSort.mostUsed:
      list.sort((a, b) => b.buttonPresses.compareTo(a.buttonPresses));
  }
  return list;
}

/// Prefix match, case-insensitive — the rule every Button search in the RN app
/// uses (`ButtonsBoard.tsx:73-83`, `BaseButtonList.tsx:82-92`). Prefix rather
/// than contains, kept as-is: a board of short words matches far too much on a
/// substring.
bool buttonMatches(String text, String query) {
  final q = query.trim().toLowerCase();
  return q.isEmpty || text.toLowerCase().startsWith(q);
}

// ─────────────────────── flags and stand-ins ───────────────────────

/// The admin-only debugging flag, as a switch rather than a user model.
///
/// `appDebuggingEnabled` gates two things on `BASE_EDIT`: the Base's firmware
/// line and the raw device-shadow dump (`useFeatureFlags.ts:33`, §13.4). Phase
/// 1 has no authentication and therefore no admin, so the flag defaults to
/// **false** — what a normal user sees — and is toggled from the screen's own
/// diagnostics row. Keeping it a real flag rather than deleting the gated
/// fields means the admin surface is designed and reviewable; keeping it false
/// by default means the default screen is the one almost everybody gets.
final NotifierProvider<AppDebuggingNotifier, bool> appDebuggingEnabledProvider =
    NotifierProvider<AppDebuggingNotifier, bool>(AppDebuggingNotifier.new);

class AppDebuggingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

/// Refetch everything the Hardware screens read.
///
/// The RN screens invalidate `BASES`, `BOARD` and `BUTTONS` together on every
/// pull-to-refresh, on all four screens. One function so the three cannot be
/// invalidated in two different combinations on two screens.
void refreshHardware(WidgetRef ref) {
  ref.invalidate(basesProvider);
  ref.invalidate(boardProvider);
}

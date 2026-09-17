/// The three kinds of Button.
///
/// A caution carried over from the RN app: on the wire, `Button.type` only ever
/// holds `"connect"` or `"classic"`. `ButtonType.INAUDIBLE` exists in the enum
/// but is never a value of `type` — the app finds inaudible buttons by matching
/// the *text* `"inaudible"` (`src/components/ButtonsBoard.tsx`,
/// `src/Home/Base/components/ClassicButtonsList.tsx`). [ButtonKind.fromWire]
/// reproduces that, so the oddity lives in one place instead of three.
enum ButtonKind {
  /// Smart, pairs to a Base.
  connect('connect'),

  /// Unconnected, logged manually.
  classic('classic'),

  /// Not a value of `type` on the wire. See the note above.
  inaudible('inaudible');

  const ButtonKind(this.wire);

  final String wire;

  static ButtonKind fromWire({required String? type, required String text}) {
    if (text.toLowerCase() == ButtonKind.inaudible.wire) return ButtonKind.inaudible;
    return type == ButtonKind.connect.wire ? ButtonKind.connect : ButtonKind.classic;
  }
}

/// A soundboard button a pet presses to speak a word.
///
/// The meaning is the word or phrase it speaks: [text] as authored,
/// [normalizedWord] as matched against. Dashboard filtering matches Buttons by
/// meaning rather than by id, which is why the filter model carries strings.
class Button {
  const Button({
    required this.id,
    required this.boardId,
    required this.text,
    required this.kind,
    this.normalizedWord = '',
    this.buttonPresses = 0,
    this.introducedAt,
    this.isHidden = false,
    this.note = '',
    this.serialNumber,
    this.batteryLevel,
  });

  final int id;
  final int boardId;

  /// The meaning — the word or phrase this Button speaks.
  final String text;

  final ButtonKind kind;
  final String normalizedWord;
  final int buttonPresses;

  /// When this Button entered the Board. A word pressed for the first time is
  /// worked out from this, not from a flag on the Interaction.
  final DateTime? introducedAt;

  final bool isHidden;
  final String note;

  /// Connect buttons only: the physical button's serial, and its own battery.
  final String? serialNumber;
  final int? batteryLevel;

  bool get isConnect => kind == ButtonKind.connect;
}

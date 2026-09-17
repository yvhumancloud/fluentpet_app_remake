import 'button.dart';

/// The full set of Buttons belonging to a user.
///
/// [buttons] is the complete historical set; [activeButtons] is what is on the
/// board now. The API sometimes omits `active_buttons`, and the RN app
/// back-fills it as "everything not hidden" (`src/api/hooks/useBoard.ts`), so
/// it is derived here rather than stored — one definition, always consistent.
class Board {
  const Board({
    required this.id,
    required this.userId,
    required this.buttons,
  });

  final int id;
  final int userId;
  final List<Button> buttons;

  List<Button> get activeButtons =>
      buttons.where((b) => !b.isHidden).toList(growable: false);

  Iterable<Button> ofKind(ButtonKind kind) => buttons.where((b) => b.kind == kind);
}

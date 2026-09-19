/// `CLASSIC_BUTTONS` — the Board, on the Hardware tab.
///
/// ## The breadth question, decided
///
/// The inventory records that this screen "is not about Classic Buttons": it
/// renders every **active** Button, Connect and Classic alike, because nothing
/// in `ButtonsBoard` filters on `type === "classic"` (§12, §14.12), and the
/// `BASES` tile that opens it counts them all too (§9).
///
/// **That breadth is kept, and it is treated as intended rather than as a bug.**
/// Four things argue for it and none against:
///
/// 1. The screen's own header already says `BUTTONS`, and the tile that opens
///    it says "Total Buttons". `ClassicButtons` is the route identifier, and
///    the redesign does not rename routes (CONTEXT.md, PLAN.md).
/// 2. It is the only screen in the product that lists the Board. Filtering it
///    to Classic would leave Connect Buttons reachable only through the Base
///    they are paired to — and a Connect Button whose Base was deleted, or
///    whose pairing is what the user is trying to debug, would be reachable
///    from nowhere at all.
/// 3. The RN action sheet already knows Connect Buttons are here: Archive is
///    suppressed for `type === "connect"` (`ClassicButtonsScreen.tsx`). Code
///    written for a Classic-only screen would not need that branch.
/// 4. CONTEXT.md defines a Board as "the full set of Buttons belonging to a
///    user", not as the Classic ones. This screen is the Board.
///
/// What was actually wrong is that the breadth was **invisible**: an
/// undifferentiated grid under the word "Buttons", on a screen whose route says
/// Classic. So the fix is legibility, not filtering — every chip states its
/// kind (fill plus a leading dot for Connect, outline for Classic), and the
/// subtitle counts the kinds separately. Nothing is hidden and nothing is
/// mislabelled.
///
/// ## What is kept
///
/// Search (prefix, case-insensitive), the three-way sort, the `+` badge with
/// its pre-filled name, `inaudible` pinned last, tap and long-press both
/// opening the action sheet, Archive suppressed for Connect Buttons, and pull
/// to refresh. The empty states are new — §12 records that the RN screen has
/// none at all.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../log/log_controls.dart' show logWrite;
import 'hardware_metrics.dart';
import 'hardware_providers.dart';
import 'hardware_ui.dart';

class ClassicButtonsScreen extends ConsumerStatefulWidget {
  const ClassicButtonsScreen({super.key});

  @override
  ConsumerState<ClassicButtonsScreen> createState() =>
      _ClassicButtonsScreenState();
}

class _ClassicButtonsScreenState extends ConsumerState<ClassicButtonsScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final board = ref.watch(hardwareBoardProvider);
    final sort = ref.watch(buttonSortProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Buttons',
              subtitle: board.maybeWhen(data: _breadthLine, orElse: () => null),
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                FpSpace.s6,
                FpSpace.s0,
                FpSpace.s6,
                FpSpace.s4,
              ),
              child: ButtonSearchAndSort(
                controller: _search,
                sort: sort,
                onSortChanged: (next) =>
                    ref.read(buttonSortProvider.notifier).set(next),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: c.textBrand,
                backgroundColor: c.surfaceRaised,
                onRefresh: () async => refreshHardware(ref),
                child: switch (board) {
                  AsyncData<Board>(:final value) => _Board(
                    board: value,
                    sort: sort,
                    query: _query,
                    onAdd: _addButton,
                    onButton: _openActions,
                  ),
                  AsyncError<Board>() => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const <Widget>[
                      HardwareNotice(
                        icon: PhosphorIconsRegular.warningOctagon,
                        title: 'Could not load your Board',
                        body: 'Pull down to try again.',
                        tone: HardwareNoticeTone.danger,
                      ),
                    ],
                  ),
                  _ => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const <Widget>[HardwareLoading()],
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The subtitle that makes the breadth visible.
  ///
  /// `inaudible` is counted apart from both kinds rather than folded into
  /// either: it is on the Board and it is not a word, and the RN tile's own
  /// total excludes it.
  static String _breadthLine(Board board) {
    final active = board.activeButtons;
    final connect = active.where((b) => b.kind == ButtonKind.connect).length;
    final classic = active.where((b) => b.kind == ButtonKind.classic).length;
    final inaudible = active
        .where((b) => b.kind == ButtonKind.inaudible)
        .length;

    final parts = <String>[
      FpFormat.countOf(connect + classic, 'Button'),
      '$connect Connect',
      '$classic Classic',
      if (inaudible > 0) 'inaudible',
    ];
    return parts.join(' · ');
  }

  /// The `+` badge. The RN screen pre-fills the new Button's name from the
  /// search text when nothing matched, which is the one moment the user has
  /// already typed the word they want — kept.
  void _addButton({String? prefilledName}) {
    final board = ref.read(hardwareBoardProvider).value;
    if (board == null) return;
    final query = <String>[
      'boardId=${board.id}',
      if (prefilledName != null && prefilledName.trim().isNotEmpty)
        'prepopulatedName=${Uri.encodeComponent(prefilledName.trim())}',
    ].join('&');
    context.push('${FpScreen.buttonAdd.path}?$query');
  }

  /// Tap and long-press both open this, as they do in the RN screen — where
  /// `onButtonPress` is wired to `handleLongPress` (`:126`). On `LOG` a tap
  /// selects a Button for a manual entry; here there is nothing to select, so
  /// one gesture and one outcome is the honest arrangement rather than an
  /// accident to reproduce carefully.
  Future<void> _openActions(Button button) async {
    final choice = await showHardwareActions<_ButtonAction>(
      context: context,
      title: button.text,
      message: switch (button.kind) {
        ButtonKind.connect =>
          'Connect Button · '
              '${FpFormat.largeCountOf(button.buttonPresses, 'press', 'presses')}',
        ButtonKind.classic =>
          'Classic Button · '
              '${FpFormat.largeCountOf(button.buttonPresses, 'press', 'presses')}',
        ButtonKind.inaudible => 'Records a press with no word',
      },
      options: <HardwareAction<_ButtonAction>>[
        const HardwareAction<_ButtonAction>(
          label: 'Edit',
          value: _ButtonAction.edit,
          icon: PhosphorIconsRegular.pencilSimple,
        ),
        // Archive is suppressed for Connect Buttons: a Connect Button is
        // physically paired to a Base, and hiding it from the Board would not
        // unpair it. Unlinking lives on BASE_EDIT, which is where the pairing
        // is.
        if (button.kind != ButtonKind.connect)
          const HardwareAction<_ButtonAction>(
            label: 'Archive',
            value: _ButtonAction.archive,
            description: 'Removes it from the Board. Its history is kept.',
            icon: PhosphorIconsRegular.archive,
            destructive: true,
          ),
      ],
    );
    if (!mounted || choice == null) return;

    switch (choice) {
      case _ButtonAction.edit:
        final query = <String>[
          'buttonId=${button.id}',
          if (button.batteryLevel != null)
            'batteryLevel=${button.batteryLevel}',
        ].join('&');
        context.push('${FpScreen.buttonEdit.path}?$query');
      case _ButtonAction.archive:
        final confirmed = await confirmDestructive(
          context: context,
          title: 'Are you sure?',
          message:
              'Archive “${button.text}”? It comes off the Board, and the '
              'presses it recorded stay on the timeline.',
          confirmLabel: 'Archive',
        );
        if (!mounted || !confirmed) return;
        final ok = await logWrite(
          context,
          () => ref
              .read(hardwareRepositoryProvider)
              .setButtonHidden(button, true),
          failed: 'Could not archive the Button. Try again.',
        );
        if (ok) refreshHardware(ref);
    }
  }
}

enum _ButtonAction { edit, archive }

class _Board extends StatelessWidget {
  const _Board({
    required this.board,
    required this.sort,
    required this.query,
    required this.onAdd,
    required this.onButton,
  });

  final Board board;
  final ButtonSort sort;
  final String query;
  final void Function({String? prefilledName}) onAdd;
  final ValueChanged<Button> onButton;

  @override
  Widget build(BuildContext context) {
    final active = board.activeButtons;

    // `inaudible` is pinned last on every Button board in the app
    // (`ButtonsBoard.tsx:121-129`). It is separated *before* sorting so no
    // sort order can float it back into the middle of the words.
    final words = active.where((b) => b.kind != ButtonKind.inaudible);
    final inaudible = active.where((b) => b.kind == ButtonKind.inaudible);

    final matched = sortButtons(
      words.where((b) => buttonMatches(b.text, query)),
      sort,
    );
    final matchedInaudible = inaudible
        .where((b) => buttonMatches(b.text, query))
        .toList();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s0,
        FpSpace.s6,
        FpSpace.s8,
      ),
      children: <Widget>[
        if (active.isEmpty)
          // A genuinely empty Board. §14.4: three different empty states
          // existed in the RN app under one string; each gets its own here.
          HardwareNotice(
            icon: PhosphorIconsRegular.circlesThree,
            title: 'No Buttons on this Board',
            body:
                'Add the words your pet has learned, or pair a Connect '
                'Button to a Base.',
            action: HardwarePrimaryButton(
              label: 'ADD A BUTTON',
              icon: PhosphorIconsRegular.plus,
              onPressed: onAdd,
            ),
          )
        else if (matched.isEmpty && matchedInaudible.isEmpty)
          // Searched, and nothing starts with it. Offering to create the word
          // the user just typed is the RN screen's own behaviour, surfaced
          // here rather than hidden behind a `+` in the corner.
          HardwareNotice(
            icon: PhosphorIconsRegular.magnifyingGlass,
            title: 'No Button starts with “${query.trim()}”',
            body: 'Search matches the start of a word, not the middle of one.',
            action: HardwarePrimaryButton(
              label: 'ADD “${query.trim().toUpperCase()}”',
              icon: PhosphorIconsRegular.plus,
              onPressed: () => onAdd(prefilledName: query),
            ),
          )
        else
          Wrap(
            spacing: FpSpace.s3,
            runSpacing: FpSpace.s3,
            children: <Widget>[
              _AddChip(onTap: () => onAdd(prefilledName: query)),
              for (final button in matched)
                ButtonChip.of(
                  button,
                  onTap: () => onButton(button),
                  onLongPress: () => onButton(button),
                ),
              for (final button in matchedInaudible)
                ButtonChip.of(
                  button,
                  onTap: () => onButton(button),
                  onLongPress: () => onButton(button),
                ),
            ],
          ),
      ],
    );
  }
}

/// The `+` badge, as the first chip on the board.
///
/// It leads the grid rather than floating over it: the RN board puts it first
/// too, and a chip-shaped control among chips reads as "one more of these",
/// which is exactly what adding a Button is.
class _AddChip extends StatelessWidget {
  const _AddChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      label: 'Add a Button',
      button: true,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: HardwareMetrics.touchTarget,
              minWidth: HardwareMetrics.touchTarget,
            ),
            decoration: BoxDecoration(
              color: c.actionPrimaryBg,
              borderRadius: BorderRadius.circular(FpRadius.md),
            ),
            // Not `alignment:` on the Container. One makes it expand to the
            // widest width its parent offers, and this chip's parent is the
            // board's `Wrap` — the badge would have taken a full-width run of
            // its own. `Center` with both factors pinned shrink-wraps, and the
            // constraints above still hold the touch target.
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: PhosphorIcon(
                PhosphorIconsRegular.plus,
                size: FpIconSize.md,
                color: c.actionPrimaryFg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

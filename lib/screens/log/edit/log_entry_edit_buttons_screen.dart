/// `LOG_ENTRY_EDIT_BUTTONS` — correct what was pressed, on an entry that
/// already exists.
///
/// `src/Home/LogEntryEditButtons/LogEntryEditButtons.tsx`, registered twice:
/// once in `LogEntryEditNavigator.tsx` under this key, for `LOG_ENTRY_EDIT`,
/// and once in `LogDetailsNavigator.tsx` as `LOG_DETAILS_EDIT_BUTTONS`, for the
/// create screen's `LOG_DETAILS`. One RN component, two destinations: the
/// picker body below, [EditButtonsPickerBody], is shared; only what it reads
/// from and writes back to differs. See `log_details_edit_buttons_screen.dart`
/// for the create-flow sibling, which passes it [LogDraft]'s buttons instead
/// of [EditEntryDraft]'s.
///
/// UPDATE always taps; an empty selection says why it did nothing rather than
/// disabling the button (`LogEntryEditButtons.tsx:38-45`, `Alert.alert`).
///
/// The Board's search and sort are **not** [logBoardViewProvider] here. That
/// provider is `LOG`'s own — shared across the whole area — and this screen
/// searching "outside" would leave `LOG`'s board silently pre-filtered the
/// next time someone opened it, with its own search field showing empty text
/// while the board underneath disagreed. [EditButtonsPickerBody] keeps its own
/// [LogBoardView] value instead, reusing the type and the pure
/// [logVisibleButtons] / [logInaudibleButton] functions without the shared
/// state.
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../data/providers.dart';
import '../../../domain/domain.dart';
import '../../../router/screens.g.dart';
import '../../../theme/fp_context.dart';
import '../../../theme/generated/fp_tokens.dart';
import '../../../widgets/widgets.dart';
import '../log_controls.dart';
import '../log_state.dart';
import 'log_edit_state.dart';

class LogEntryEditButtonsScreen extends ConsumerWidget {
  const LogEntryEditButtonsScreen({required this.activityId, super.key});

  /// Carried so a cold deep link straight to this screen — skipping
  /// `LOG_ENTRY_EDIT` — can still resolve: the entry is (re)loaded here the
  /// same way the parent screen loads it. Absent, with nothing already loaded,
  /// is the honest not-found case below.
  final int? activityId;

  static const String _title = 'Edit buttons pressed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(logEditDraftProvider);
    final id = activityId;

    if (draft.isLoaded && (id == null || draft.activityId == id)) {
      return _Body(draft: draft);
    }

    if (id == null) {
      return _NothingToEdit(
        title: _title,
        onGo: () => context.go(FpScreen.dashboard.path),
      );
    }

    final activity = ref.watch(logActivityProvider(id));
    return switch (activity) {
      AsyncError() => _NothingToEdit(
        title: _title,
        onGo: () => context.go(FpScreen.dashboard.path),
        message: 'Could not load this entry.',
      ),
      AsyncData(value: final found) => _resolve(context, ref, found),
      _ => _Loading(title: _title),
    };
  }

  Widget _resolve(BuildContext context, WidgetRef ref, Activity? found) {
    if (found == null) {
      return _NothingToEdit(
        title: _title,
        onGo: () => context.go(FpScreen.dashboard.path),
      );
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      ref.read(logEditDraftProvider.notifier).loadFrom(found);
    });
    return _Loading(title: _title);
  }
}

class _Loading extends StatelessWidget {
  const _Loading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(title: title),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: FpStroke.thick,
                  color: c.textBrand,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NothingToEdit extends StatelessWidget {
  const _NothingToEdit({required this.title, required this.onGo, this.message});

  final String title;
  final VoidCallback onGo;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.fpColors.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: title,
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: LogEmptyState(
                    icon: PhosphorIconsRegular.pencilSimpleSlash,
                    title: 'Nothing to edit',
                    message:
                        message ??
                        'This screen corrects the Buttons on an entry that '
                            'already exists. Open one from the timeline first.',
                    actionLabel: 'Go to Activity',
                    onAction: onGo,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.draft});

  final EditEntryDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Edit buttons pressed',
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: EditButtonsPickerBody(
                initialButtons: draft.buttons,
                onUpdate: (buttons) =>
                    ref.read(logEditDraftProvider.notifier).setButtons(buttons),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── the shared picker body ───────────────────────────

/// The Board, with the current selection above it as removable words — shared
/// by both `*_EDIT_BUTTONS` screens. `SelectedButtonsDragAndDrop.tsx` despite
/// its name has no drag and drop (screen-inventory §3); this is the same
/// removable-chip idiom `LOG`'s own composer already uses, via [LogWordToken].
class EditButtonsPickerBody extends ConsumerStatefulWidget {
  const EditButtonsPickerBody({
    required this.initialButtons,
    required this.onUpdate,
    super.key,
  });

  final List<Button> initialButtons;

  /// Called once, on UPDATE, with the whole new selection — what the RN app's
  /// `updateSelectedButtons` closure receives. A return value here rather than
  /// a closure carried through navigation, for the reason `log_state.dart`
  /// gives for [LogDraft] existing at all.
  final ValueChanged<List<Button>> onUpdate;

  @override
  ConsumerState<EditButtonsPickerBody> createState() =>
      _EditButtonsPickerBodyState();
}

class _EditButtonsPickerBodyState extends ConsumerState<EditButtonsPickerBody> {
  late List<Button> _selected;
  LogBoardView _view = const LogBoardView();
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = List<Button>.of(widget.initialButtons);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final board = ref.watch(boardProvider);

    return switch (board) {
      AsyncError(:final error) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
        child: Align(
          alignment: Alignment.topLeft,
          child: LogEmptyState(
            icon: PhosphorIconsRegular.warningCircle,
            title: 'Could not load the Board',
            message: '$error',
          ),
        ),
      ),
      AsyncData(value: final b) => _loaded(context, b),
      _ => Center(
        child: CircularProgressIndicator(
          strokeWidth: FpStroke.thick,
          color: context.fpColors.textBrand,
        ),
      ),
    };
  }

  Widget _loaded(BuildContext context, Board board) {
    final c = context.fpColors;
    final visible = logVisibleButtons(board, _view);
    final inaudible = logInaudibleButton(board, _view);
    final hasAnyButton = board.activeButtons.isNotEmpty;

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              FpSpace.s6,
              FpSpace.s2,
              FpSpace.s6,
              FpSpace.s8,
            ),
            children: <Widget>[
              LogSection(
                title: 'Selected presses',
                child: _selected.isEmpty
                    ? Text(
                        'Nothing selected yet.',
                        style: FpType.bodySm.copyWith(color: c.textTertiary),
                      )
                    : Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: FpSpace.s3,
                        children: <Widget>[
                          for (
                            var i = 0;
                            i < _selected.length;
                            i++
                          ) ...<Widget>[
                            if (i > 0) const LogPressBoundary(),
                            LogWordToken(
                              word: _selected[i].text,
                              onRemove: () =>
                                  setState(() => _selected.removeAt(i)),
                            ),
                          ],
                        ],
                      ),
              ),
              const SizedBox(height: FpSpace.s6),
              const LogHairline(),
              const SizedBox(height: FpSpace.s6),
              LogSection(
                title: 'Board',
                trailing: LogTextAction(
                  label: _view.sort.label,
                  icon: PhosphorIconsRegular.arrowsDownUp,
                  onTap: _openSortSheet,
                ),
                child: _SearchField(
                  controller: _search,
                  value: _view.search,
                  onChanged: (value) =>
                      setState(() => _view = _view.copyWith(search: value)),
                  onClear: () {
                    _search.clear();
                    setState(() => _view = _view.copyWith(search: ''));
                  },
                ),
              ),
              const SizedBox(height: FpSpace.s4),
              if (!hasAnyButton)
                LogEmptyState(
                  icon: PhosphorIconsRegular.squaresFour,
                  title: 'No Buttons on this Board',
                  message:
                      'Add the first word your pet can say, and it will '
                      'appear here to press.',
                  actionLabel: 'Add the first Button',
                  onAction: () => _addButton(null),
                )
              else if (visible.isEmpty && inaudible == null)
                LogEmptyState(
                  icon: PhosphorIconsRegular.magnifyingGlass,
                  title: 'No Button starts with "${_view.search.trim()}"',
                  message: 'The Board is searched from the start of the word.',
                  actionLabel: 'Add "${_view.search.trim()}" as a Button',
                  onAction: () => _addButton(_view.search.trim()),
                )
              else
                Wrap(
                  spacing: FpSpace.s3,
                  runSpacing: FpSpace.s3,
                  children: <Widget>[
                    LogButtonChip(
                      kind: LogChipKind.add,
                      onTap: () => _addButton(
                        visible.isEmpty ? _view.search.trim() : null,
                      ),
                    ),
                    for (final button in visible)
                      LogButtonChip(
                        kind: button.isConnect
                            ? LogChipKind.connect
                            : LogChipKind.classic,
                        label: button.text,
                        onTap: () => _press(button),
                      ),
                    if (inaudible != null)
                      LogButtonChip(
                        kind: LogChipKind.inaudible,
                        label: inaudible.text,
                        onTap: () => _press(inaudible),
                      ),
                  ],
                ),
            ],
          ),
        ),
        LogActionBar(
          children: <Widget>[
            LogActionButton(label: 'Update', onPressed: _submit),
          ],
        ),
      ],
    );
  }

  void _press(Button button) {
    setState(() {
      _selected = <Button>[..._selected, button];
      _view = _view.copyWith(search: '');
    });
    _search.clear();
  }

  void _submit() {
    if (_selected.isEmpty) {
      logSay(context, 'Tap at least one Button to save your changes.');
      return;
    }
    widget.onUpdate(_selected);
    if (context.canPop()) context.pop();
  }

  void _addButton(String? prepopulatedName) {
    final name = prepopulatedName?.trim() ?? '';
    context.push(
      name.isEmpty
          ? FpScreen.buttonAdd.path
          : '${FpScreen.buttonAdd.path}?prepopulatedName=${Uri.encodeComponent(name)}',
    );
  }

  void _openSortSheet() {
    showLogSheet(
      context,
      title: 'Sort the Board',
      options: <LogSheetOption>[
        for (final sort in LogButtonSort.values)
          LogSheetOption(
            label: sort.label,
            selected: sort == _view.sort,
            onSelected: () =>
                setState(() => _view = _view.copyWith(sort: sort)),
          ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.value,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colours = context.fpColors;

    OutlineInputBorder border(Color colour, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(FpRadius.sm),
      borderSide: BorderSide(color: colour, width: width),
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      style: FpType.bodyMd.copyWith(color: colours.textPrimary),
      cursorColor: colours.textBrand,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: colours.surfaceRaised,
        hintText: 'Search for a Button',
        hintStyle: FpType.bodyMd.copyWith(color: colours.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FpSpace.s4,
          vertical: FpSpace.s4,
        ),
        prefixIconConstraints: const BoxConstraints(),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: FpSpace.s4, right: FpSpace.s3),
          child: PhosphorIcon(
            PhosphorIconsRegular.magnifyingGlass,
            size: FpIconSize.sm,
            color: colours.textTertiary,
          ),
        ),
        suffixIconConstraints: const BoxConstraints(),
        suffixIcon: value.isEmpty
            ? null
            : GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: FpSpace.s4),
                  child: PhosphorIcon(
                    PhosphorIconsRegular.x,
                    size: FpIconSize.sm,
                    color: colours.textTertiary,
                  ),
                ),
              ),
        border: border(colours.borderDefault, FpStroke.hairline),
        enabledBorder: border(colours.borderDefault, FpStroke.hairline),
        focusedBorder: border(colours.borderFocus, FpStroke.thick),
      ),
    );
  }
}

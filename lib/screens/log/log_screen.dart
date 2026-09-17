/// `LOG` — record a Button press by hand.
///
/// Job 1's write side: the screen you reach from the Activity FAB, or from the
/// timeline's empty state, when a press happened that no Base recorded — a
/// Classic Button, a press the Base missed, a word modelled by a human.
///
/// A **modal**, as the RN app registered it (`ModalNavigator.tsx:135-139`) and
/// as `screens.g.dart` still records it. That is why the one control in the
/// header is a close, not a back chevron: this covers the tab bar and dismisses
/// downwards, and a chevron would describe a push it is not.
///
/// ## What it carries, from `src/Home/Log/LogScreen.tsx` (288 lines)
///
/// * The Pusher strip — every active Household member, Learners first, first
///   one pre-selected, with an ADD circle when the Household is short of a
///   Learner or a Teacher.
/// * The presses composed so far, each removable.
/// * The Buttons Board — search, sort, a `+`, one chip per active Button, and
///   the `inaudible` Button pinned last.
/// * Long-press a chip for Edit and Archive.
/// * LOG EVENT, pinned to the bottom safe area, disabled until there is
///   something to log.
///
/// ## What is deliberately different
///
/// **The composer shows the utterance, not a chip row.** The RN screen renders
/// what you have pressed as small blue badges
/// (`src/components/Board/SelectedButtonsDragAndDrop.tsx` — which, despite the
/// name, has no drag and drop). Here the words are display type with the same
/// press-boundary middots the timeline draws, because they are the same words
/// and this app is about them. Each carries an ✕ that removes that one press.
///
/// **The disabled reason is stated before the fact.** The RN screen lets you
/// tap a Pusher with nothing selected and then raises an alert — *"To log an
/// event, tap Buttons, then tap a Learner."* (`:159-161`). The precondition is
/// on screen instead, under a disabled LOG EVENT, so nothing has to be
/// undone to learn it.
///
/// **No platform branch on the keyboard.** Android hides LOG EVENT while the
/// keyboard is up (`:74`) because the RN layout could not lift it. Flutter's
/// `resizeToAvoidBottomInset` lifts the bar over the keyboard on both
/// platforms, so the control stays where it is and the branch disappears.
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
import 'log_controls.dart';
import 'log_state.dart';

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final pushers = ref.watch(pushersProvider);
    final board = ref.watch(boardProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Log a press',
              subtitle: FpFormat.fullDate(DateTime.now()),
              trailing: LogHeaderIconButton(
                icon: PhosphorIconsRegular.x,
                semanticLabel: 'Close',
                onTap: _close,
              ),
            ),
            Expanded(
              child: switch ((pushers, board)) {
                (AsyncError(:final error), _) => _Failed(error: error),
                (_, AsyncError(:final error)) => _Failed(error: error),
                (AsyncData(value: final members), AsyncData(value: final b)) =>
                  _Body(members: logMembers(members), board: b, search: _search),
                _ => const _Loading(),
              },
            ),
            if (pushers.hasValue && board.hasValue)
              _Actions(
                members: logMembers(pushers.requireValue),
                board: board.requireValue,
              ),
          ],
        ),
      ),
    );
  }

  /// Dismiss the modal, discarding the draft.
  ///
  /// The RN screen clears the selected Buttons whenever it loses focus
  /// (`LogScreen.tsx:96-105`), so a half-composed press does not survive
  /// leaving. Closing is the same intent, stated once.
  void _close() {
    ref.read(logDraftProvider.notifier).reset();
    ref.read(logBoardViewProvider.notifier).clearSearch();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(FpScreen.dashboard.path);
    }
  }
}

// ─────────────────────────── states ───────────────────────────

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: FpStroke.thick,
        color: context.fpColors.textBrand,
      ),
    );
  }
}

/// The Board or the Household could not be read.
///
/// The RN app has no error UI on these screens at all — failures surface as a
/// flash message from the mutation hook and the list simply stays empty (§1.7).
/// An empty Board that is actually a failed request is the worst of both, so it
/// is named here.
class _Failed extends StatelessWidget {
  const _Failed({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
      child: Align(
        alignment: Alignment.topLeft,
        child: LogEmptyState(
          icon: PhosphorIconsRegular.warningCircle,
          title: 'Could not load the Board',
          message: '$error',
        ),
      ),
    );
  }
}

// ─────────────────────────── body ───────────────────────────

class _Body extends ConsumerWidget {
  const _Body({
    required this.members,
    required this.board,
    required this.search,
  });

  final List<Pusher> members;
  final Board board;
  final TextEditingController search;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colours = context.fpColors;
    return ListView(
      padding: const EdgeInsets.only(bottom: FpSpace.s8),
      children: <Widget>[
        _Inset(
          child: Text(
            'Who pressed',
            style: FpType.labelSm.copyWith(color: colours.textTertiary),
          ),
        ),
        const SizedBox(height: FpSpace.s3),
        _PusherStrip(members: members),
        const SizedBox(height: FpSpace.s6),
        const _Inset(child: LogHairline()),
        const SizedBox(height: FpSpace.s6),
        const _Inset(child: _Composer()),
        const SizedBox(height: FpSpace.s6),
        const _Inset(child: LogHairline()),
        const SizedBox(height: FpSpace.s6),
        _Inset(child: _BoardSection(board: board, search: search)),
      ],
    );
  }
}

/// The screen's horizontal margin. Everything is inset by it except the Pusher
/// strip, which scrolls off both edges so it reads as continuing.
class _Inset extends StatelessWidget {
  const _Inset({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
      child: child,
    );
  }
}

// ─────────────────────────── the Pusher strip ───────────────────────────

class _PusherStrip extends ConsumerWidget {
  const _PusherStrip({required this.members});

  final List<Pusher> members;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(logDraftProvider);

    if (members.isEmpty) {
      // Empty state one of five, and its own sentence: an account with a Board
      // but nobody to attribute a press to.
      return _Inset(
        child: LogEmptyState(
          icon: PhosphorIconsRegular.usersThree,
          title: 'No members yet',
          message: 'A press is attributed to someone. Add the pet, or the '
              'people who model words for them.',
          actionLabel: 'Add a member',
          onAction: () => context.push(FpScreen.householdAdd.path),
        ),
      );
    }

    // Pre-selected for display only. Nothing is written to the draft until the
    // user taps, or presses LOG EVENT — a provider must not be mutated during
    // a build.
    //
    // A draft may hold a Pusher this strip does not offer: the journal
    // pseudo-Pusher, or a member archived since. Falling back to the first
    // member keeps the strip's selection honest rather than showing none.
    final chosen = draft.pusher;
    final selected = chosen != null && members.any((m) => m.id == chosen.id)
        ? chosen
        : members.first;

    return SizedBox(
      height: LogMetrics.pusherStripHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
        children: <Widget>[
          if (logIsMissingLearnerOrTeacher(members))
            _AddMemberOption(
              onTap: () => context.push(FpScreen.householdAdd.path),
            ),
          for (final pusher in members)
            _PusherOption(
              pusher: pusher,
              selected: pusher.id == selected.id,
              onTap: () => ref.read(logDraftProvider.notifier).selectPusher(
                    pusher,
                    availableContexts: _contextsFor(ref, pusher),
                  ),
            ),
        ],
      ),
    );
  }
}

/// Which Context vocabulary a Pusher gets.
///
/// `useContexts(teacher|learner)` in the RN app — the filter changes with
/// `selectedPusher.is_human` (`LogDetailsNewScreen.tsx:74-76`). One helper, two
/// callers.
List<InteractionContext> _contextsFor(WidgetRef ref, Pusher? pusher) {
  return (pusher?.isTeacher ?? false)
      ? logContexts(ref.read(logTeacherContextsProvider))
      : logContexts(ref.read(logLearnerContextsProvider));
}

/// One Pusher in the strip.
///
/// Selection is a rule under the avatar in `text.brand` plus the name stepping
/// from tertiary to primary. Not a filled pill and not a ring: `PusherAvatar`
/// already spends fill on Learner-versus-Teacher, and a second fill on top
/// would make the two distinctions fight.
class _PusherOption extends StatelessWidget {
  const _PusherOption({
    required this.pusher,
    required this.selected,
    required this.onTap,
  });

  final Pusher pusher;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      selected: selected,
      label: '${pusher.name}, ${pusher.isLearner ? 'Learner' : 'Teacher'}',
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: LogMetrics.pusherOptionWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                PusherAvatar(pusher: pusher, size: PusherAvatarSize.md),
                const SizedBox(height: FpSpace.s2),
                Text(
                  pusher.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FpType.labelMd.copyWith(
                    color: selected ? c.textPrimary : c.textTertiary,
                  ),
                ),
                const SizedBox(height: FpSpace.s2),
                Container(
                  width: LogMetrics.pusherSelectionRule,
                  height: FpStroke.thick,
                  color: selected ? c.textBrand : c.surfaceCanvas,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The ADD circle at the head of the strip.
///
/// Shown only when the Household is short of a Learner or a Teacher — the
/// condition the RN helper computes under a name that says the opposite. See
/// `logIsMissingLearnerOrTeacher`.
class _AddMemberOption extends StatelessWidget {
  const _AddMemberOption({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      label: 'Add a member',
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: LogMetrics.pusherOptionWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: FpMetrics.avatarMd,
                  height: FpMetrics.avatarMd,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: c.borderStrong,
                      width: FpStroke.hairline,
                    ),
                  ),
                  child: PhosphorIcon(
                    PhosphorIconsRegular.userPlus,
                    size: FpIconSize.sm,
                    color: c.textBrand,
                  ),
                ),
                const SizedBox(height: FpSpace.s2),
                Text(
                  'Add',
                  style: FpType.labelMd.copyWith(color: c.textTertiary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── the composer ───────────────────────────

/// What was pressed, as the utterance it will become.
class _Composer extends ConsumerWidget {
  const _Composer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(logDraftProvider);
    final words = draft.words;

    return LogSection(
      title: 'What was pressed',
      child: words.isEmpty
          ? LogEmptyState(
              icon: PhosphorIconsRegular.handTap,
              title: 'Nothing pressed yet',
              message: 'Tap Buttons below, in the order they were pressed. '
                  'The same Button twice is two presses.',
              // The journal entry — an Activity with no press behind it — is
              // reached from the Activity FAB in the RN app. That FAB is on
              // another screen; offering it here as well is the only way the
              // variant is reachable in phase 1, and it belongs beside the
              // sentence that says Buttons are required.
              actionLabel: 'Write a note with no Buttons',
              onAction: () => _startJournal(context, ref),
            )
          : Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: FpSpace.s3,
              children: <Widget>[
                for (var i = 0; i < words.length; i++) ...<Widget>[
                  if (i > 0) const LogPressBoundary(),
                  LogWordToken(
                    word: words[i],
                    onRemove: () =>
                        ref.read(logDraftProvider.notifier).removeButtonAt(i),
                  ),
                ],
              ],
            ),
    );
  }

  void _startJournal(BuildContext context, WidgetRef ref) {
    ref
        .read(logDraftProvider.notifier)
        .startJournal(ref.read(logJournalPusherProvider));
    context.push(FpScreen.logDetails.path);
  }
}

// ─────────────────────────── the Board ───────────────────────────

class _BoardSection extends ConsumerWidget {
  const _BoardSection({required this.board, required this.search});

  final Board board;
  final TextEditingController search;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colours = context.fpColors;
    final view = ref.watch(logBoardViewProvider);
    final visible = logVisibleButtons(board, view);
    final inaudible = logInaudibleButton(board, view);
    final hasAnyButton = board.activeButtons
        .any((b) => !view.archivedButtonIds.contains(b.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LogSection(
          title: 'Board',
          trailing: LogTextAction(
            label: view.sort.label,
            icon: PhosphorIconsRegular.arrowsDownUp,
            onTap: () => _openSortSheet(context, ref, view.sort),
          ),
          child: _SearchField(controller: search),
        ),
        const SizedBox(height: FpSpace.s4),
        if (!hasAnyButton)
          // Empty state two: a Board with no Buttons at all. The RN app has
          // none — `useButtons` reads `res.data[0].board_id` and throws on a
          // Board with zero Buttons (§3), so this case has never been drawn.
          LogEmptyState(
            icon: PhosphorIconsRegular.squaresFour,
            title: 'No Buttons on this Board',
            message: 'Add the first word your pet can say, and it will appear '
                'here to press.',
            actionLabel: 'Add the first Button',
            onAction: () => _addButton(context, null),
          )
        else if (visible.isEmpty && inaudible == null)
          // Empty state three: the search matched nothing. Different from an
          // empty Board, and it says what it was looking for.
          LogEmptyState(
            icon: PhosphorIconsRegular.magnifyingGlass,
            title: 'No Button starts with “${view.search.trim()}”',
            message: 'The Board is searched from the start of the word.',
            actionLabel: 'Add “${view.search.trim()}” as a Button',
            onAction: () => _addButton(context, view.search.trim()),
          )
        else ...<Widget>[
          Text(
            'Filled · Connect     Outlined · Classic',
            style: FpType.labelSm.copyWith(color: colours.textTertiary),
          ),
          const SizedBox(height: FpSpace.s3),
          Wrap(
            spacing: FpSpace.s3,
            runSpacing: FpSpace.s3,
            children: <Widget>[
              LogButtonChip(
                kind: LogChipKind.add,
                onTap: () => _addButton(
                  context,
                  // The RN board pre-fills the new Button's name with the
                  // search text, but only when the search matched nothing
                  // (`ButtonsBoard.tsx:209-214`).
                  visible.isEmpty ? view.search.trim() : null,
                ),
              ),
              for (final button in visible)
                LogButtonChip(
                  kind: button.isConnect
                      ? LogChipKind.connect
                      : LogChipKind.classic,
                  label: button.text,
                  onTap: () => _press(ref, button),
                  onLongPress: () => _openButtonSheet(context, ref, button),
                ),
              // Pinned last, as its own kind of thing.
              if (inaudible != null)
                LogButtonChip(
                  kind: LogChipKind.inaudible,
                  label: inaudible.text,
                  onTap: () => _press(ref, inaudible),
                  onLongPress: () => _openButtonSheet(context, ref, inaudible),
                ),
            ],
          ),
        ],
      ],
    );
  }

  /// Append a press and clear the search, which is what the RN board does on
  /// every badge tap (`ButtonsBoard.tsx:148-151`) — you have found the word,
  /// so the filter has done its job.
  void _press(WidgetRef ref, Button button) {
    ref.read(logDraftProvider.notifier).addButton(button);
    ref.read(logBoardViewProvider.notifier).clearSearch();
    search.clear();
  }

  void _addButton(BuildContext context, String? prepopulatedName) {
    // The destination is one of the screens this pass does not build. The route
    // exists and resolves to the placeholder, and the pre-fill rides as a query
    // parameter rather than as `state.extra`: `extra` survives a push and
    // evaporates on a deep link or a restore, which is the one case anybody
    // would test it in. `CLASSIC_BUTTONS` opens the same screen the same way.
    final name = prepopulatedName?.trim() ?? '';
    context.push(
      name.isEmpty
          ? FpScreen.buttonAdd.path
          : '${FpScreen.buttonAdd.path}'
              '?prepopulatedName=${Uri.encodeComponent(name)}',
    );
  }

  void _openSortSheet(BuildContext context, WidgetRef ref, LogButtonSort current) {
    showLogSheet(
      context,
      title: 'Sort the Board',
      options: <LogSheetOption>[
        for (final sort in LogButtonSort.values)
          LogSheetOption(
            label: sort.label,
            selected: sort == current,
            onSelected: () =>
                ref.read(logBoardViewProvider.notifier).setSort(sort),
          ),
      ],
    );
  }

  /// Long-press a chip: Edit, and Archive for anything that is not a Connect
  /// Button (`LogScreen.tsx:109-154` — Archive is suppressed for
  /// `type === "connect"`, because a paired Button is unlinked from its Base
  /// rather than archived).
  void _openButtonSheet(BuildContext context, WidgetRef ref, Button button) {
    showLogSheet(
      context,
      title: button.text,
      options: <LogSheetOption>[
        LogSheetOption(
          label: 'Edit',
          icon: PhosphorIconsRegular.pencilSimple,
          // A query parameter, not `state.extra`, for the same reason as
          // `_addButton` above: the path stays deep-linkable.
          onSelected: () => context.push(
            '${FpScreen.buttonEdit.path}?buttonId=${button.id}',
          ),
        ),
        if (!button.isConnect)
          LogSheetOption(
            label: 'Archive',
            icon: PhosphorIconsRegular.archive,
            destructive: true,
            onSelected: () => _archive(context, ref, button),
          ),
      ],
    );
  }

  Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    Button button,
  ) async {
    final confirmed = await logConfirm(
      context,
      title: 'Archive “${button.text}”?',
      message: 'It leaves the Board. Presses already logged against it keep '
          'the word.',
      confirmLabel: 'Archive',
    );
    if (!confirmed || !context.mounted) return;
    ref.read(logBoardViewProvider.notifier).archive(button);
    logSay(context, '“${button.text}” archived for this session only.');
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colours = context.fpColors;
    final view = ref.watch(logBoardViewProvider);

    OutlineInputBorder border(Color colour, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(FpRadius.sm),
          borderSide: BorderSide(color: colour, width: width),
        );

    return TextField(
      controller: controller,
      onChanged: (value) =>
          ref.read(logBoardViewProvider.notifier).setSearch(value),
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
        suffixIcon: view.search.isEmpty
            ? null
            : GestureDetector(
                onTap: () {
                  controller.clear();
                  ref.read(logBoardViewProvider.notifier).clearSearch();
                },
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

// ─────────────────────────── the action bar ───────────────────────────

class _Actions extends ConsumerWidget {
  const _Actions({required this.members, required this.board});

  final List<Pusher> members;
  final Board board;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(logDraftProvider);

    // The RN condition, verbatim: no active Pushers, or nothing selected
    // (`LogScreen.tsx:72-73`).
    final enabled = members.isNotEmpty && draft.buttons.isNotEmpty;

    return LogActionBar(
      children: <Widget>[
        LogActionButton(
          label: 'Log event',
          onPressed: enabled ? () => _next(context, ref) : null,
        ),
      ],
    );
  }

  void _next(BuildContext context, WidgetRef ref) {
    final selected = ref.read(logDraftProvider).pusher ?? members.first;
    ref.read(logDraftProvider.notifier)
      // Committing the pre-selection here, rather than during a build, is
      // also what applies the Pusher-type Context rules to it: a Household
      // whose first member is a Teacher gets "Modeled" selected exactly as a
      // deliberate tap would.
      ..selectPusher(selected, availableContexts: _contextsFor(ref, selected))
      ..setBoardId(board.id);
    context.push(FpScreen.logDetails.path);
  }
}

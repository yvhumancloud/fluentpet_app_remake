/// `LOG_ENTRY_EDIT_PUSHER` — re-assign an existing entry to a different
/// Household member.
///
/// `src/Home/LogEntryEditPusher/LogEntryEditPusher.tsx`, registered twice —
/// once here, for `LOG_ENTRY_EDIT`, and once as `LOG_DETAILS_EDIT_PUSHER`, for
/// the create screen's `LOG_DETAILS`. [EditPusherPickerBody] is the shared
/// grid; see `log_details_edit_pusher_screen.dart` for the create-flow
/// sibling.
///
/// Tapping a tile selects **and immediately returns** — `navigation.goBack();
/// updatePusher(pusher);` (`LogEntryEditPusher.tsx:18-21`). There is no
/// confirm step and no UPDATE button, unlike the Buttons picker.
///
/// One RN affordance is not reproduced: tapping the *already-selected* tile a
/// second time unassigns the entry back to "nobody attributed"
/// (`LogDetailsEditScreen.tsx:246-252`, `updatePusher(undefined)` /
/// `pusher.id === formData.pusherId`). That pseudo-Pusher — `PusherKind.base`,
/// wire name `"base"` — has no repository-exposed provider the way the
/// event-note pseudo-Pusher does (`journalPusherProvider`); it exists only as
/// `basePusher` inside `activity_fixture.dart`, which this area does not
/// import directly (`repositories.dart`'s whole point, and this pass's fixture
/// rule: reach data through the repository or not at all). Reconstructing it
/// locally with a guessed id would risk exactly the id collision the same rule
/// exists to prevent. **Reported, not invented**: if this affordance is wanted,
/// Foundation adding a `basePusherProvider` beside `journalPusherProvider`
/// would close the gap cleanly.
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
import 'log_edit_state.dart';

class LogEntryEditPusherScreen extends ConsumerWidget {
  const LogEntryEditPusherScreen({required this.activityId, super.key});

  /// Same self-healing purpose as on `LogEntryEditButtonsScreen`: a cold deep
  /// link straight to this screen still resolves the entry it is re-assigning.
  final int? activityId;

  static const String _title = 'Edit member';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(logEditDraftProvider);
    final id = activityId;

    if (draft.isLoaded && (id == null || draft.activityId == id)) {
      return _Body(draft: draft);
    }

    if (id == null) {
      return _NothingToEdit(onGo: () => context.go(FpScreen.dashboard.path));
    }

    final activities = ref.watch(logEditableActivitiesProvider);
    return switch (activities) {
      AsyncError() => _NothingToEdit(
          onGo: () => context.go(FpScreen.dashboard.path),
          message: 'Could not load this entry.',
        ),
      AsyncData(value: final list) => _resolve(context, ref, list, id),
      _ => const _Loading(),
    };
  }

  Widget _resolve(BuildContext context, WidgetRef ref, List<Activity> list, int id) {
    final found = logFindActivity(list, id);
    if (found == null) {
      return _NothingToEdit(onGo: () => context.go(FpScreen.dashboard.path));
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      ref.read(logEditDraftProvider.notifier).loadFrom(found);
    });
    return const _Loading();
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            const ScreenHeader(title: LogEntryEditPusherScreen._title),
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
  const _NothingToEdit({required this.onGo, this.message});

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
              title: LogEntryEditPusherScreen._title,
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: LogEmptyState(
                    icon: PhosphorIconsRegular.userSwitch,
                    title: 'Nothing to edit',
                    message: message ??
                        'This screen re-assigns an entry that already exists. '
                            'Open one from the timeline first.',
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
    final household = ref.watch(pushersProvider);
    final journal = ref.watch(journalPusherProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: LogEntryEditPusherScreen._title,
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: switch (household) {
                AsyncError(:final error) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: LogEmptyState(
                        icon: PhosphorIconsRegular.warningCircle,
                        title: 'Could not load the Household',
                        message: '$error',
                      ),
                    ),
                  ),
                AsyncData(value: final all) => EditPusherPickerBody(
                    pushers: logEditEligiblePushers(
                      all,
                      hasButtons: draft.buttons.isNotEmpty,
                      journalPusher: journal,
                    ),
                    selectedId: draft.pusher?.id,
                    onSelected: (pusher) => _select(context, ref, pusher),
                  ),
                _ => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: FpStroke.thick,
                      color: c.textBrand,
                    ),
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }

  void _select(BuildContext context, WidgetRef ref, Pusher pusher) {
    ref.read(logEditDraftProvider.notifier).selectPusher(
          pusher,
          availableContexts: logEditContextsFor(ref, pusher),
        );
    if (context.canPop()) context.pop();
  }
}

// ─────────────────────────── the shared picker body ───────────────────────────

/// The Pusher grid — shared by both `*_EDIT_PUSHER` screens. RN's
/// `PushersGrid`: rows of avatar-and-name tiles rather than the horizontal
/// strip `LOG` itself uses, because this screen has nothing else on it.
class EditPusherPickerBody extends StatelessWidget {
  const EditPusherPickerBody({
    required this.pushers,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final List<Pusher> pushers;
  final int? selectedId;
  final ValueChanged<Pusher> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;

    if (pushers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: FpSpace.s6),
        child: Align(
          alignment: Alignment.topLeft,
          child: LogEmptyState(
            icon: PhosphorIconsRegular.usersThree,
            title: 'No one to re-assign to',
            message: 'Add the pet, or the people who model words for them.',
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(FpSpace.s6, FpSpace.s2, FpSpace.s6, FpSpace.s8),
      children: <Widget>[
        Text(
          'Re-assign log entry to a different member',
          style: FpType.headingSm.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: FpSpace.s6),
        Wrap(
          spacing: FpSpace.s5,
          runSpacing: FpSpace.s5,
          children: <Widget>[
            for (final pusher in pushers)
              _PusherTile(
                pusher: pusher,
                selected: pusher.id == selectedId,
                onTap: () => onSelected(pusher),
              ),
          ],
        ),
      ],
    );
  }
}

class _PusherTile extends StatelessWidget {
  const _PusherTile({required this.pusher, required this.selected, required this.onTap});

  final Pusher pusher;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      selected: selected,
      label: switch (pusher.kind) {
        PusherKind.learner => '${pusher.name}, Learner',
        PusherKind.teacher => '${pusher.name}, Teacher',
        PusherKind.eventNote => 'Journal entry, no Pusher',
        PusherKind.base => 'Nobody attributed',
      },
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: LogMetrics.pusherOptionWidth,
            child: Column(
              children: <Widget>[
                PusherAvatar(pusher: pusher, size: PusherAvatarSize.md),
                const SizedBox(height: FpSpace.s2),
                Text(
                  switch (pusher.kind) {
                    PusherKind.eventNote => 'Journal entry',
                    PusherKind.base => 'Unassigned',
                    PusherKind.learner || PusherKind.teacher => pusher.name,
                  },
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
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

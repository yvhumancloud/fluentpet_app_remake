/// `LOG_DETAILS_EDIT_PUSHER` — choose who pressed, while composing a new
/// entry.
///
/// The same RN component as `LOG_ENTRY_EDIT_PUSHER`
/// (`src/Home/LogEntryEditPusher/LogEntryEditPusher.tsx`), registered a second
/// time in `LogDetailsNavigator.tsx` for `LOG_DETAILS`, the create screen.
/// [EditPusherPickerBody] is the shared grid; this file says what it reads
/// from and writes to: [LogDraft], via [LogDraftNotifier.selectPusher] — the
/// same method `LOG`'s own Pusher strip already calls, so the Learner/Teacher
/// Context rules apply identically whichever screen re-assigns.
///
/// No query parameter, matching how `LOG_DETAILS` (`log_details_screen.dart`)
/// already reaches this route bare — `context.push(FpScreen.
/// logDetailsEditPusher.path)`.
///
/// The list excludes the event-note pseudo-Pusher unconditionally
/// (`LogDetailsNewScreen.tsx:238-243`, `pusher.id !== PusherTypes.JOURNAL`,
/// with no button-count exception the way the edit screen's list has).
/// `logMembers` already excludes every pseudo-Pusher and every hidden one, so
/// it is this list outright rather than a bespoke filter.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../data/providers.dart';
import '../../../domain/domain.dart';
import '../../../theme/fp_context.dart';
import '../../../theme/generated/fp_tokens.dart';
import '../../../widgets/widgets.dart';
import '../log_controls.dart';
import '../log_state.dart';
import 'log_entry_edit_pusher_screen.dart' show EditPusherPickerBody;

class LogDetailsEditPusherScreen extends ConsumerWidget {
  const LogDetailsEditPusherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final draft = ref.watch(logDraftProvider);
    final household = ref.watch(pushersProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Edit member',
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
                  pushers: logMembers(all),
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
    final contexts = pusher.isTeacher
        ? logContexts(ref.read(logTeacherContextsProvider))
        : logContexts(ref.read(logLearnerContextsProvider));
    ref
        .read(logDraftProvider.notifier)
        .selectPusher(pusher, availableContexts: contexts);
    if (context.canPop()) context.pop();
  }
}

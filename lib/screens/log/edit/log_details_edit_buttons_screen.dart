/// `LOG_DETAILS_EDIT_BUTTONS` — correct what was pressed while composing a
/// new entry.
///
/// The same RN component as `LOG_ENTRY_EDIT_BUTTONS`
/// (`src/Home/LogEntryEditButtons/LogEntryEditButtons.tsx`), registered a
/// second time in `LogDetailsNavigator.tsx` for `LOG_DETAILS`, the **create**
/// screen — not `LOG_ENTRY_EDIT`, the update screen `log_entry_edit_buttons_
/// screen.dart` builds. [EditButtonsPickerBody] is the one piece of UI; this
/// file only says what it reads from and writes back to: [LogDraft], the
/// composition state `LOG` and `LOG_DETAILS` already share (`log_state.dart`).
///
/// No query parameter, matching how the already-built `LOG_DETAILS`
/// (`log_details_screen.dart`) already reaches this route —
/// `context.push(FpScreen.logDetailsEditButtons.path)`, bare. There is no id
/// to carry: nothing is saved yet, so there is nothing to look up. A cold deep
/// link here finds whatever `logDraftProvider` currently holds, empty or not —
/// which is a legitimate starting point to pick Buttons from, not an error
/// state, the same way opening `LOG_DETAILS` cold is not.
///
/// The RN nav param carries one more thing this component never reads:
/// `isEventNote?: boolean` (`LogDetailsNavigator.tsx:30`). Confirmed by
/// grepping the RN source for the identifier — `LogEntryEditButtons.tsx`
/// destructures `selectedButtons` and `updateSelectedButtons` only, never
/// `isEventNote`. Dead on arrival in the app it was written for; not given
/// behaviour here either.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/domain.dart';
import '../../../theme/fp_context.dart';
import '../../../widgets/widgets.dart';
import '../log_state.dart';
import 'log_entry_edit_buttons_screen.dart' show EditButtonsPickerBody;

class LogDetailsEditButtonsScreen extends ConsumerWidget {
  const LogDetailsEditButtonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final draft = ref.watch(logDraftProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Edit button',
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: EditButtonsPickerBody(
                initialButtons: draft.buttons,
                onUpdate: (buttons) => _replaceButtons(ref, buttons),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// `LogDraftNotifier` has `addButton` / `removeButtonAt` only — the
  /// one-at-a-time shape `LOG`'s own composer needs, and `state` is a
  /// protected member of `Notifier` in this Riverpod version, not writable
  /// from outside the class. This picker hands back a whole new selection —
  /// the RN app's `updateSelectedButtons(selectedButtons)` replaces it
  /// outright — so the replacement is expressed through the public API
  /// instead: clear by removing from the end, then add the new selection in
  /// order. `LOG` re-reading the draft afterwards cannot tell the difference.
  void _replaceButtons(WidgetRef ref, List<Button> buttons) {
    final notifier = ref.read(logDraftProvider.notifier);
    var remaining = ref.read(logDraftProvider).buttons.length;
    while (remaining > 0) {
      remaining--;
      notifier.removeButtonAt(remaining);
    }
    for (final button in buttons) {
      notifier.addButton(button);
    }
  }
}

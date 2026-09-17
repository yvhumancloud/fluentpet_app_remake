/// The Log-edit area's five entries for the route table.
///
/// Follows `lib/screens/hardware/hardware_routes.dart` exactly: this file
/// exports a builder map, `app_router.dart` folds it into `screenBuilders`,
/// and nothing here registers a route, invents a path or touches
/// `screens.g.dart`'s enum.
///
/// ## Two navigators, five screens, three of them argued for a query
/// parameter and two of them argued out of one
///
/// `LOG_ENTRY_EDIT` **updates** an existing [Activity] found by
/// [Activity.id] — the RN screen's `interactionId` nav param
/// (`LogEntryEditNavigator.tsx:22`), renamed here because a [Note] has no
/// `interactionId` to carry and this screen has to open one too (`domain.dart`
/// note, `../edit/log_edit_state.dart`). Its two picker children,
/// `LOG_ENTRY_EDIT_BUTTONS` and `LOG_ENTRY_EDIT_PUSHER`, carry the same
/// `activityId` so a deep link straight to either of them — skipping the
/// parent screen — still resolves the entry it is correcting, rather than
/// depending on a shared draft that was never populated.
///
/// `LOG_DETAILS_EDIT_BUTTONS` and `LOG_DETAILS_EDIT_PUSHER` pick values for
/// `LOG_DETAILS` — the **create** flow — while it is being composed. There is
/// nothing saved yet, so there is no id to carry; both read and write
/// `logDraftProvider`, the state `LOG` and `LOG_DETAILS` already share, the
/// same way `log_details_screen.dart` already reaches them —
/// `context.push(FpScreen.logDetailsEditButtons.path)`, bare, with no query
/// string. Every screen still renders an honest state with nothing behind it:
/// `LOG_DETAILS_EDIT_BUTTONS`/`_PUSHER` fall back to whatever `logDraftProvider`
/// currently holds, which — empty or not — is a legitimate starting point to
/// pick from, the same way a cold `LOG_DETAILS` is (`log_details_screen.dart`'s
/// `_NoDraft`). The RN nav params both screens carry beyond this — closures,
/// and one dead boolean (`isEventNote`, verified unused by grepping
/// `LogEntryEditButtons.tsx` for the identifier) — do not translate; see
/// `log_details_edit_buttons_screen.dart`'s note on it.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../router/screens.g.dart';
import 'log_details_edit_buttons_screen.dart';
import 'log_details_edit_pusher_screen.dart';
import 'log_entry_edit_buttons_screen.dart';
import 'log_entry_edit_pusher_screen.dart';
import 'log_entry_edit_screen.dart';

/// The Log-edit area's screens, keyed the way [FpScreen] keys everything else.
final Map<FpScreen, Widget Function(BuildContext, GoRouterState)> logEditRoutes =
    <FpScreen, Widget Function(BuildContext, GoRouterState)>{
  FpScreen.logEntryEdit: (context, state) => LogEntryEditScreen(
        activityId: int.tryParse(state.uri.queryParameters['activityId'] ?? ''),
      ),
  FpScreen.logEntryEditButtons: (context, state) => LogEntryEditButtonsScreen(
        activityId: int.tryParse(state.uri.queryParameters['activityId'] ?? ''),
      ),
  FpScreen.logEntryEditPusher: (context, state) => LogEntryEditPusherScreen(
        activityId: int.tryParse(state.uri.queryParameters['activityId'] ?? ''),
      ),
  FpScreen.logDetailsEditButtons: (context, state) =>
      const LogDetailsEditButtonsScreen(),
  FpScreen.logDetailsEditPusher: (context, state) =>
      const LogDetailsEditPusherScreen(),
};

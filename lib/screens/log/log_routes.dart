/// The Log area's entries for the route table.
///
/// `app_router.dart` owns `screenBuilders`: three areas were built at once and
/// three agents editing one map is three conflicts, so each area exports its own
/// map and the router merges them. The merge is a loop with an assertion rather
/// than a spread of three maps, because a spread lets the last one win silently
/// if two areas ever claim the same screen.
///
/// The builder signature is `app_router.dart`'s, verbatim. Neither screen reads
/// [GoRouterState]: what would have been navigation params is held in
/// `logDraftProvider` above both screens, because React Navigation's
/// `onReturn` closure has no Flutter equivalent (see `log_state.dart`).
///
/// Presentation is already decided and is not restated here. `LOG` is a modal
/// in `screens.g.dart`, so the router gives it a `fullscreenDialog` page on the
/// root navigator; `LOG_DETAILS` is a stack route. Both come from the RN
/// navigators through the generated screen map, and a builder cannot and should
/// not override them.
///
/// The five editing screens — `LOG_ENTRY_EDIT`, `LOG_ENTRY_EDIT_BUTTONS`,
/// `LOG_ENTRY_EDIT_PUSHER`, `LOG_DETAILS_EDIT_BUTTONS`,
/// `LOG_DETAILS_EDIT_PUSHER` — are deliberately absent. They are out of scope
/// for this pass and resolve to the placeholder, which is where the affordances
/// on these two screens that lead to them land. Each is a real key in
/// [FpScreen] with a real route, so the navigation is exercised end to end and
/// the placeholder names the key it landed on.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import 'log_details_screen.dart';
import 'log_screen.dart';

final Map<FpScreen, Widget Function(BuildContext, GoRouterState)> logRoutes =
    <FpScreen, Widget Function(BuildContext, GoRouterState)>{
  FpScreen.log: (context, state) => const LogScreen(),
  FpScreen.logDetails: (context, state) => const LogDetailsScreen(),
};

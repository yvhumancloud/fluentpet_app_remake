/// The Buttons group's three builders, for `app_router.dart` to fold in.
///
/// The router is owned elsewhere; each area exports its own builders and
/// `app_router.dart` merges the maps into `screenBuilders`. Nothing here
/// registers a route, invents a path or touches the enum — see
/// `lib/screens/hardware/hardware_routes.dart`, which this file matches
/// structurally.
///
/// ## Parameters, and why they are query parameters
///
/// None of `BUTTON_ADD`, `BUTTON_EDIT` or `BUTTON_CONVERSION` has a path
/// segment for its arguments in the RN app's own deep links (`screens.g.dart`'s
/// `path` values are the RN links verbatim), so every argument rides as a
/// query parameter on the exact path already generated. `BUTTON_EDIT` and
/// `BUTTON_CONVERSION` with no resolvable `buttonId` resolve to their own
/// not-found state rather than a blank form or a crash.
///
/// `lib/screens/hardware/classic_buttons_screen.dart` and
/// `lib/screens/hardware/base_edit_screen.dart` push these with query keys of
/// their own choosing (`boardId`, `prepopulatedName`, `buttonId`,
/// `batteryLevel`). Those exact names are read here, unchanged.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import 'button_add_screen.dart';
import 'button_conversion_screen.dart';
import 'button_edit_screen.dart';

/// The Buttons group's screens, keyed the way [FpScreen] keys everything else.
final Map<FpScreen, Widget Function(BuildContext, GoRouterState)>
    buttonsRoutes = <FpScreen, Widget Function(BuildContext, GoRouterState)>{
  FpScreen.buttonAdd: (context, state) => ButtonAddScreen(
        boardId: int.tryParse(state.uri.queryParameters['boardId'] ?? ''),
        prepopulatedName: state.uri.queryParameters['prepopulatedName'],
      ),
  FpScreen.buttonEdit: (context, state) => ButtonEditScreen(
        buttonId: int.tryParse(state.uri.queryParameters['buttonId'] ?? ''),
        batteryLevel:
            int.tryParse(state.uri.queryParameters['batteryLevel'] ?? ''),
      ),
  FpScreen.buttonConversion: (context, state) => ButtonConversionScreen(
        buttonId: int.tryParse(state.uri.queryParameters['buttonId'] ?? ''),
      ),
};

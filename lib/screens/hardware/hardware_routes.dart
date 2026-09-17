/// The Hardware area's four builders, for `app_router.dart` to fold in.
///
/// The router is owned elsewhere and is generated from the design system's
/// screen map; three areas were built at once and three areas editing one map is
/// how a merge conflict becomes a missing screen. So each area exports its own
/// builders and `app_router.dart` merges the three maps into `screenBuilders`.
/// Nothing here registers a route, invents a path or touches the enum.
///
/// ## Parameters, and why they are query parameters
///
/// Two of these screens need an argument and neither of their RN routes has a
/// path segment for it: `BASE_EDIT` takes `serialNumber` and reads it through
/// `decodeParams` so it survives a deep link (`BaseEditScreen.tsx:70`), and
/// `BASE_EDIT_INTERACTION_TIMING` takes nothing at all in the RN app. The
/// generated paths are the RN deep links verbatim and are not this file's to
/// change, so the arguments ride as query parameters on those exact paths.
///
/// That keeps every path deep-linkable and keeps every screen able to render
/// something honest when the parameter is absent: `BASE_EDIT` with no serial
/// resolves to its not-found state, and the timing page with no window
/// explains the setting generically.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import 'base_edit_interaction_timing_screen.dart';
import 'base_edit_screen.dart';
import 'bases_screen.dart';
import 'classic_buttons_screen.dart';

/// The Hardware tab's screens, keyed the way [FpScreen] keys everything else.
final Map<FpScreen, Widget Function(BuildContext, GoRouterState)>
    hardwareRoutes = <FpScreen, Widget Function(BuildContext, GoRouterState)>{
  FpScreen.bases: (context, state) => const BasesScreen(),
  FpScreen.baseEdit: (context, state) => BaseEditScreen(
        // Empty rather than null: the screen's not-found state already says
        // everything a null check here could, and it says it on screen instead
        // of in a crash.
        serialNumber: state.uri.queryParameters['serialNumber'] ?? '',
      ),
  FpScreen.baseEditInteractionTiming: (context, state) =>
      BaseEditInteractionTimingScreen(
        windowSeconds: int.tryParse(state.uri.queryParameters['seconds'] ?? ''),
        baseName: state.uri.queryParameters['name'],
      ),
  FpScreen.classicButtons: (context, state) => const ClassicButtonsScreen(),
};

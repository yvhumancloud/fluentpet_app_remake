/// The Settings area's two builders, for `app_router.dart` to fold in.
///
/// Same shape as `lib/screens/hardware/hardware_routes.dart`: this file
/// exports a `Map<FpScreen, ScreenBuilder>` and registers nothing itself.
///
/// `UNKNOWN` takes no query parameter — it reads the *path* GoRouter actually
/// resolved to (`state.uri`), which is the thing worth showing back when a
/// link turns out to be wrong. `SETTINGS` takes no arguments at all.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import 'settings_screen.dart';
import 'unknown_screen.dart';

/// The Settings area's screens, keyed the way [FpScreen] keys everything else.
final Map<FpScreen, Widget Function(BuildContext, GoRouterState)>
    settingsRoutes = <FpScreen, Widget Function(BuildContext, GoRouterState)>{
  FpScreen.settings: (context, state) => const SettingsScreen(),
  FpScreen.unknown: (context, state) => UnknownScreen(
        attemptedPath: state.uri.toString(),
      ),
};

/// The setup area's two builders, for `app_router.dart` to fold in.
///
/// Mirrors `lib/screens/hardware/hardware_routes.dart` exactly: this file
/// registers nothing itself. It exports [setupRoutes], keyed by [FpScreen],
/// for the router (owned elsewhere) to merge alongside the other areas'
/// maps. Neither screen takes an argument.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import 'base_registration_screen.dart';
import 'welcome_screen.dart';

/// The setup flow's screens, keyed the way [FpScreen] keys everything else.
final Map<FpScreen, Widget Function(BuildContext, GoRouterState)>
    setupRoutes = <FpScreen, Widget Function(BuildContext, GoRouterState)>{
  FpScreen.welcome: (context, state) => const WelcomeScreen(),
  FpScreen.baseRegistration: (context, state) =>
      const BaseRegistrationScreen(),
};

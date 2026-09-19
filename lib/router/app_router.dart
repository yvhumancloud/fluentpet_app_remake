/// The route table.
///
/// ## Adding a screen — the one place to edit
///
/// Add an entry to [screenBuilders], keyed by its [FpScreen] value:
///
/// ```dart
/// FpScreen.dashboard: (context, state) => const ActivityScreen(),
/// ```
///
/// That is the whole change. The route itself already exists: all thirty-two
/// screens are routed — the twenty-six kept from the RN app at the deep-link
/// paths it used and with the presentation it registered, plus the six this
/// product adds that it has no original for. All thirty-two have builders
/// today and [_merge] asserts it; anything that lost one would resolve to
/// [PlaceholderScreen] rather than to a blank page.
///
/// Do not add a `GoRoute` by hand. Routes are derived from `screens.g.dart`,
/// which is the hand-maintained screen enum. A new screen is a new enum value
/// there and a builder here, in that order.
///
/// ## Shape
///
/// * A [StatefulShellRoute.indexedStack] holds the three tabs, so each keeps
///   its own stack across switches. Membership is by the RN navigator each
///   screen was registered in — see [FpTab].
/// * Screens the RN app presented modally get a page with
///   `fullscreenDialog: true`, on the root navigator, so they cover the tab bar
///   and dismiss downwards. They are not pushes, and turning them into pushes
///   would change what the back gesture means.
/// * Everything else is a stack route on the root navigator: the seven
///   `AUTHENTICATION` screens, the Connect setup sequence, the two log-editing
///   sequences, and Tools.
///
/// ## Deep links versus pushes
///
/// The extracted paths are the RN app's, verbatim, so `/home/home_nav/modal_nav/tab_nav/
/// activity_tab/activity_button` is a *sibling* of the Activity path, not a
/// child of it. Sibling routes in a branch do not nest, so use
/// `context.push(...)` when a screen should sit on top of the one below it, and
/// `context.go(...)` when it should replace it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../auth/auth_service.dart';
import '../screens/activity/activity_routes.dart';
import '../screens/auth/auth_routes.dart';
import '../screens/buttons/buttons_routes.dart';
import '../screens/hardware/hardware_routes.dart';
import '../screens/household/household_routes.dart';
import '../screens/log/edit/log_edit_routes.dart';
import '../screens/log/log_routes.dart';
import '../screens/settings/settings_routes.dart';
import '../screens/setup/setup_routes.dart';
import 'app_shell.dart';
import 'placeholder_screen.dart';
import 'screens.g.dart';
import 'tabs.dart';

/// Real screens.
///
/// All thirty-two [FpScreen] values have a builder. [PlaceholderScreen] is
/// kept, and [_merge] asserts the map is total, because "every screen is built"
/// is a statement about *today*: a screen added to the design system's map
/// regenerates [FpScreen] without regenerating this list, and a route that
/// silently rendered nothing would look like a working app with a broken screen
/// rather than a screen nobody has written yet. That assertion is what caught
/// the six auth screens the moment they entered the enum, which is what it is
/// for.
///
/// The nine areas were built in parallel and each exports its own map rather
/// than editing this one, because nine agents editing one map is nine merge
/// conflicts and a missing screen. [_merge] is where they meet, and it asserts
/// that no two areas claim the same [FpScreen] — a spread of nine maps would
/// silently let the last one win, and "the Hardware build of BASES" quietly
/// replacing "the Activity build of BASES" is exactly the failure that would
/// not show up until somebody opened the tab.
///
/// Presentation is not decided here or in any area map. It comes from
/// `screens.g.dart`, through [buildRouter] — from the RN navigator that
/// registered the screen, or, for the six invented ones, from the navigator the
/// design system's `invented-screens.json` places them in. A builder cannot
/// override it and must not try.
final Map<FpScreen, Widget Function(BuildContext, GoRouterState)>
screenBuilders = _merge(<Map<FpScreen, ScreenBuilder>>[
  activityRoutes,
  authRoutes,
  logRoutes,
  logEditRoutes,
  hardwareRoutes,
  setupRoutes,
  buttonsRoutes,
  householdRoutes,
  settingsRoutes,
]);

/// What a screen's builder looks like. The signature this file owns and the
/// nine area maps are written against.
typedef ScreenBuilder = Widget Function(BuildContext, GoRouterState);

Map<FpScreen, ScreenBuilder> _merge(List<Map<FpScreen, ScreenBuilder>> maps) {
  final merged = <FpScreen, ScreenBuilder>{};
  for (final map in maps) {
    for (final entry in map.entries) {
      assert(
        !merged.containsKey(entry.key),
        'Two areas both build ${entry.key.key}. One of them would be dropped '
        'silently; decide which screen is the screen.',
      );
      merged[entry.key] = entry.value;
    }
  }
  assert(() {
    final missing = FpScreen.values
        .where((s) => !merged.containsKey(s))
        .map((s) => s.key);
    if (missing.isEmpty) return true;
    throw AssertionError(
      'No builder for ${missing.join(', ')}. These resolve to '
      'PlaceholderScreen; add them to their area\'s route map.',
    );
  }());
  return Map<FpScreen, ScreenBuilder>.unmodifiable(merged);
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final Provider<GoRouter> routerProvider = Provider<GoRouter>((ref) {
  // Bumped on every auth change so GoRouter re-runs `redirect` — sign-out
  // from Settings lands on WELCOME without any screen navigating there.
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, __) => refresh.value++);
  final auth = ref.read(authServiceProvider);
  final router = buildRouter(
    refreshListenable: refresh,
    redirect: (context, state) => authRedirect(auth.current, state.uri.path),
  );
  ref.onDispose(router.dispose);
  ref.onDispose(refresh.dispose);
  return router;
});

GoRouter buildRouter({
  String? initialLocation,
  Listenable? refreshListenable,
  GoRouterRedirect? redirect,
}) {
  final tabbed = <FpScreen>{for (final tab in FpTab.values) ...tab.screens};

  final modal = FpScreen.values
      .where((s) => !tabbed.contains(s))
      .where((s) => s.presentation == FpPresentation.modal);

  final stacked = FpScreen.values
      .where((s) => !tabbed.contains(s))
      .where((s) => s.presentation != FpPresentation.modal);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation ?? FpTab.activity.root.path,
    refreshListenable: refreshListenable,
    redirect: redirect,
    // Screen names as breadcrumbs on every Sentry event. Root navigator only,
    // so tab-branch pushes are not seen; the route that was current when an
    // error hit still is.
    observers: <NavigatorObserver>[SentryNavigatorObserver()],
    debugLogDiagnostics: false,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          for (final tab in FpTab.values)
            StatefulShellBranch(
              initialLocation: tab.root.path,
              routes: <RouteBase>[
                for (final screen in tab.orderedScreens) _stackRoute(screen),
              ],
            ),
        ],
      ),
      for (final screen in stacked)
        _stackRoute(screen, parentNavigatorKey: rootNavigatorKey),
      for (final screen in modal) _modalRoute(screen),
    ],
    // A path that resolves to nothing goes through the same builder as the
    // `UNKNOWN` route itself, so the "this link does not exist" screen is one
    // screen with one behaviour rather than two that drift. Before `UNKNOWN`
    // was built this fell back to [PlaceholderScreen]; that would now show
    // "NOT BUILT YET" for a stale deep link, which is a different and wrong
    // statement.
    errorBuilder: (context, state) => _screen(FpScreen.unknown, context, state),
  );
}

Widget _screen(FpScreen screen, BuildContext context, GoRouterState state) =>
    screenBuilders[screen]?.call(context, state) ??
    PlaceholderScreen(screen: screen);

GoRoute _stackRoute(
  FpScreen screen, {
  GlobalKey<NavigatorState>? parentNavigatorKey,
}) {
  return GoRoute(
    path: screen.path,
    name: screen.key,
    parentNavigatorKey: parentNavigatorKey,
    builder: (context, state) => _screen(screen, context, state),
  );
}

GoRoute _modalRoute(FpScreen screen) {
  return GoRoute(
    path: screen.path,
    name: screen.key,
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      // The one thing that must not be lost in translation: these were modals
      // in the RN app and they stay modals. fullscreenDialog gives the
      // bottom-up presentation and the close affordance on both platforms.
      fullscreenDialog: true,
      child: _screen(screen, context, state),
    ),
  );
}

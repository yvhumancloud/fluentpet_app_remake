/// The Activity area's five builders, merged into `screenBuilders`.
///
/// `app_router.dart` folds this map, the Log area's and the Hardware area's into
/// one and asserts that no two of them claim the same screen. Nothing here
/// registers a route: the route table is generated from the design system's
/// screen map and every one of these paths already exists.
///
/// ## Parameters, and why they are query parameters
///
/// Three of these five screens take an argument — a Button, a Context, a
/// Pusher. In the RN app those arrive as navigation params, whole objects
/// passed by reference (`docs/design-system/screen-inventory.md` §6, §7).
///
/// Three things rule that out here. The generated paths carry no path segment
/// to put an id in and are not this area's to change. `GoRouterState.extra`
/// would work for a push and evaporate on a deep link or a restore, and these
/// screens *are* deep-linkable — the RN app links them at
/// `…/activity_tab/activity_button` and friends. And passing a whole domain
/// object through navigation is the same mistake as passing a closure: it
/// survives only in the one case somebody tested.
///
/// So the id — and the label, so the header has something to draw before the
/// data resolves — travel as query parameters on the existing path:
///
/// ```
/// …/activity_button?buttonId=101&meaning=outside
/// …/activity_context?contextId=505&text=living%20room
/// …/activity_pusher?pusherId=11&name=Otis
/// …/activity_filters?timeframeOnly=1
/// ```
///
/// A link that arrives without them is not an error: [_int] returns null and
/// the screen falls back to a state that says what is missing rather than
/// throwing.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import 'activity_filters_screen.dart';
import 'activity_screen.dart';
import 'facet_screens.dart';
import 'pusher_activity_screen.dart';

/// The Activity area's contribution to `screenBuilders`.
final Map<FpScreen, Widget Function(BuildContext, GoRouterState)>
activityRoutes = <FpScreen, Widget Function(BuildContext, GoRouterState)>{
  FpScreen.dashboard: (context, state) => const ActivityScreen(),
  FpScreen.dashboardFilters: (context, state) => ActivityFiltersScreen(
    // `editTimeframeOnly` in the RN params. Opened this way from
    // `DASHBOARD_PUSHER` (`DashboardInfiniteScroll.tsx:324`).
    timeframeOnly: state.uri.queryParameters['timeframeOnly'] == '1',
  ),
  FpScreen.dashboardButton: (context, state) => ButtonActivityScreen(
    buttonId: _int(state, 'buttonId') ?? _noId,
    meaning: _string(state, 'meaning', fallback: 'This Button'),
  ),
  FpScreen.dashboardContext: (context, state) => ContextActivityScreen(
    contextId: _int(state, 'contextId') ?? _noId,
    text: _string(state, 'text', fallback: 'This Context'),
  ),
  FpScreen.dashboardPusher: (context, state) => PusherActivityScreen(
    pusherId: _int(state, 'pusherId') ?? _noId,
    name: _string(state, 'name', fallback: 'Pusher'),
  ),
};

/// The id a link without one gets: matches nothing, so the screen lands in its
/// "this facet has nothing in it" state instead of throwing or showing the
/// whole timeline under a facet's title. Negative because every real id is
/// positive and the two pseudo-Pusher sentinels are -1 and -2.
const int _noId = -9999;

int? _int(GoRouterState state, String key) {
  final raw = state.uri.queryParameters[key];
  return raw == null ? null : int.tryParse(raw);
}

String _string(GoRouterState state, String key, {required String fallback}) {
  final raw = state.uri.queryParameters[key];
  return raw == null || raw.isEmpty ? fallback : raw;
}

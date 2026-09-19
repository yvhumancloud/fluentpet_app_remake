/// The Household area's four builders, for `app_router.dart` to fold in.
///
/// Same shape as `lib/screens/hardware/hardware_routes.dart`, deliberately:
/// three areas were built at once and three agents editing one map is how a
/// merge conflict becomes a missing screen, so each area exports its own
/// builders and `app_router.dart` merges the three maps into `screenBuilders`.
/// Nothing here registers a route, invents a path, or touches
/// [FpScreen] — `HOUSEHOLD` is also a root tab, and `lib/router/tabs.dart`
/// (not this file) is what makes it one.
///
/// ## The one argument, and why it is a query parameter
///
/// `HOUSEHOLD_EDIT` needs a Pusher id and its RN route carries it as a bare
/// navigation param (`Household.tsx:135`, `:145`: `{ id: pusher.id }`), not as
/// a path segment — the generated path
/// (`/home/home_nav/modal_nav/household_edit`) has nowhere to put one and is
/// not this file's to change. So it rides as `?id=`, exactly the choice
/// `hardware_routes.dart` makes for `BASE_EDIT`'s `serialNumber`, which keeps
/// the path deep-linkable and keeps the screen able to render something honest
/// when the parameter is absent: a missing or unparsable `id` resolves to
/// `HouseholdEditScreen`'s not-found state instead of a crash — see that
/// screen's own header note for the full state list. `HOUSEHOLD_ADD` and
/// `HOUSEHOLD_MEMBERS` take no argument (`household_add_screen.dart`'s header
/// note explains why the RN screen's `addPusherGuide` argument is not
/// reproduced).
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import 'household_add_screen.dart';
import 'household_edit_screen.dart';
import 'household_members_screen.dart';
import 'household_screen.dart';

/// The Household area's contribution to `screenBuilders`.
final Map<FpScreen, Widget Function(BuildContext, GoRouterState)>
householdRoutes = <FpScreen, Widget Function(BuildContext, GoRouterState)>{
  FpScreen.household: (context, state) => const HouseholdScreen(),
  FpScreen.householdAdd: (context, state) => const HouseholdAddScreen(),
  FpScreen.householdEdit: (context, state) => HouseholdEditScreen(
    pusherId: int.tryParse(state.uri.queryParameters['id'] ?? ''),
  ),
  FpScreen.householdMembers: (context, state) => const HouseholdMembersScreen(),
};

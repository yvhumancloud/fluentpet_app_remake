// Originally generated from the design system's screen map by tool/gen_screens.dart.
// Both the generator and that upstream are gone: this file is now the source of
// truth and is maintained by hand. The map it was built from, including the
// 36 in-scope / 11 retired / 6 invented arithmetic the generator enforced, is
// vendored at docs/design-system/data/screen-map.json.

/// How a screen arrives on top of what is already there.
///
/// Carried across from the RN navigator that registered it. `modal` must stay
/// modal: presenting a modal as a push changes what the back gesture means and
/// is the kind of drift a rewrite makes without noticing.
enum FpPresentation { stack, modal, drawer, tabs, none }

/// Every screen the FluentPet app routes.
///
/// 32 values. 26 are read out of the React Native app; 6 are screens this
/// product adds that the RN app has no original for. The 11 screens retired
/// with the learning product are absent by construction, and a further 11 were
/// dropped on 2026-09-17 when `../backend/PRD.md` scoped the product down: the
/// base onboarding sequence (`BASE_SETUP_PERMISSIONS`, `BASE_FIRMWARE_UPDATE`,
/// `SYSTEM_SELECTION`, `RESYNC_BASE`, `BUTTON_PAIRING`, `DOWNLOAD_SOUND`),
/// Petcube (`PETCUBE_VIDEOS_SCREEN`, `PETCUBE_SHOP_SCREEN`), the interaction
/// meanings dictionary (`DASHBOARD_MEANING`), `BUG_REPORT` (no endpoint) and
/// `SET_NEW_PASSWORD` (Firebase hosts the reset page).
///
/// The added ones carry `invented: true`: five native auth screens — the RN
/// app has no login or signup screen at all, sign-in there is Auth0 Universal
/// Login in a system browser — and `HOUSEHOLD_MEMBERS`, which the RN app kept
/// inside `SETTINGS` and the PRD makes a first-class flow (in-app invitations).
enum FpScreen {
  /// `src/Authentication/Welcome/Welcome.tsx`
  welcome(
    key: 'WELCOME',
    route: 'Welcome',
    title: 'Welcome',
    path: '/welcome',
    presentation: FpPresentation.stack,
    navigator: 'AUTHENTICATION',
    invented: false,
  ),
  /// `src/Home/BaseRegistration/BaseRegistration.tsx`
  baseRegistration(
    key: 'BASE_REGISTRATION',
    route: 'BaseRegistration',
    title: 'CONNECT SETUP',
    path: '/home/home_nav/modal_nav/base_registration_nav/base_registration',
    presentation: FpPresentation.stack,
    navigator: 'BASE_REGISTRATION',
    invented: false,
  ),
  /// `src/Home/Base/BaseEditScreen.tsx`
  baseEdit(
    key: 'BASE_EDIT',
    route: 'BaseEdit',
    title: 'EDIT BASE',
    path: '/home/home_nav/modal_nav/tab_nav/bases_nav/base_edit',
    presentation: FpPresentation.stack,
    navigator: 'BASE',
    invented: false,
  ),
  /// `src/Home/Base/ClassicButtonsScreen.tsx`
  classicButtons(
    key: 'CLASSIC_BUTTONS',
    route: 'ClassicButtons',
    title: 'BUTTONS',
    path: '/home/home_nav/modal_nav/tab_nav/bases_nav/classic_buttons',
    presentation: FpPresentation.stack,
    navigator: 'BASE',
    invented: false,
  ),
  /// `src/Home/Base/BaseEditInteractionTimingScreen.tsx`
  baseEditInteractionTiming(
    key: 'BASE_EDIT_INTERACTION_TIMING',
    route: 'INTERACTION TIMING',
    title: 'INTERACTION TIMING',
    path: '/home/home_nav/modal_nav/tab_nav/bases_nav/base_edit_interaction_timing',
    presentation: FpPresentation.stack,
    navigator: 'BASE',
    invented: false,
  ),
  /// `src/Home/Base/BasesScreen.tsx`
  bases(
    key: 'BASES',
    route: 'Bases',
    title: 'HARDWARE',
    path: '/home/home_nav/modal_nav/tab_nav/bases_nav/bases',
    presentation: FpPresentation.stack,
    navigator: 'BASE',
    invented: false,
  ),
  /// `src/Home/ButtonAdd/ButtonAdd.tsx`
  buttonAdd(
    key: 'BUTTON_ADD',
    route: 'ButtonAdd',
    title: 'ADD BUTTON',
    path: '/home/home_nav/modal_nav/button_add',
    presentation: FpPresentation.modal,
    navigator: 'MODAL',
    invented: false,
  ),
  /// `src/Home/ButtonConversion/ButtonConversionScreen.tsx`
  buttonConversion(
    key: 'BUTTON_CONVERSION',
    route: 'ButtonConversion',
    title: 'MERGE BUTTONS',
    path: '/home/home_nav/modal_nav/button_conversion',
    presentation: FpPresentation.modal,
    navigator: 'MODAL',
    invented: false,
  ),
  /// `src/Home/ButtonEdit/ButtonEdit.tsx`
  buttonEdit(
    key: 'BUTTON_EDIT',
    route: 'ButtonEdit',
    title: 'EDIT BUTTON',
    path: '/home/home_nav/modal_nav/button_edit',
    presentation: FpPresentation.modal,
    navigator: 'MODAL',
    invented: false,
  ),
  /// `src/Home/Dashboard/Dashboard.tsx`
  dashboard(
    key: 'DASHBOARD',
    route: 'Dashboard',
    title: 'ACTIVITY FEED',
    path: '/home/home_nav/modal_nav/tab_nav/activity_tab/activity',
    presentation: FpPresentation.stack,
    navigator: 'ACTIVITY',
    invented: false,
  ),
  /// `src/Home/Dashboard/DashboardButton.tsx`
  dashboardButton(
    key: 'DASHBOARD_BUTTON',
    route: 'DashboardButton',
    title: 'BUTTON ACTIVITY',
    path: '/home/home_nav/modal_nav/tab_nav/activity_tab/activity_button',
    presentation: FpPresentation.stack,
    navigator: 'ACTIVITY',
    invented: false,
  ),
  /// `src/Home/Dashboard/DashboardContext.tsx`
  dashboardContext(
    key: 'DASHBOARD_CONTEXT',
    route: 'DashboardContext',
    title: 'CONTEXT ACTIVITY',
    path: '/home/home_nav/modal_nav/tab_nav/activity_tab/activity_context',
    presentation: FpPresentation.stack,
    navigator: 'ACTIVITY',
    invented: false,
  ),
  /// `src/Home/DashboardFilters/DashboardFilters.tsx`
  dashboardFilters(
    key: 'DASHBOARD_FILTERS',
    route: 'DashboardFilters',
    title: 'ACTIVITY FILTERS',
    path: '/home/home_nav/modal_nav/activity_filters',
    presentation: FpPresentation.modal,
    navigator: 'MODAL',
    invented: false,
  ),
  /// `src/Home/Dashboard/DashboardPusher.tsx`
  dashboardPusher(
    key: 'DASHBOARD_PUSHER',
    route: 'DashboardPusher',
    title: 'ACTIVITY',
    path: '/home/home_nav/modal_nav/tab_nav/activity_tab/activity_pusher',
    presentation: FpPresentation.stack,
    navigator: 'ACTIVITY',
    invented: false,
  ),
  /// `src/Home/Household/Household.tsx`
  household(
    key: 'HOUSEHOLD',
    route: 'Household',
    title: 'HOUSEHOLD',
    path: '/home/home_nav/modal_nav/tab_nav/household_tab/household',
    presentation: FpPresentation.stack,
    navigator: 'HOUSEHOLD',
    invented: false,
  ),
  /// `src/Home/HouseholdAdd/HouseholdAdd.tsx`
  householdAdd(
    key: 'HOUSEHOLD_ADD',
    route: 'HouseholdAdd',
    title: 'ADD MEMBER',
    path: '/home/home_nav/modal_nav/household_add',
    presentation: FpPresentation.modal,
    navigator: 'MODAL',
    invented: false,
  ),
  /// `src/Home/HouseholdEdit/HouseholdEdit.tsx`
  householdEdit(
    key: 'HOUSEHOLD_EDIT',
    route: 'HouseholdEdit',
    title: 'EDIT MEMBER',
    path: '/home/home_nav/modal_nav/household_edit',
    presentation: FpPresentation.modal,
    navigator: 'MODAL',
    invented: false,
  ),
  /// `no RN original — SharedHouseholdSettings.tsx lived inside SETTINGS`
  householdMembers(
    key: 'HOUSEHOLD_MEMBERS',
    route: 'HouseholdMembers',
    title: 'HOUSEHOLD MEMBERS',
    path: '/home/home_nav/household_members',
    presentation: FpPresentation.stack,
    navigator: 'HOME_NAV',
    invented: true,
  ),
  /// `src/Home/Log/LogScreen.tsx`
  log(
    key: 'LOG',
    route: 'Log',
    title: 'LOG',
    path: '/home/home_nav/modal_nav/log',
    presentation: FpPresentation.modal,
    navigator: 'MODAL',
    invented: false,
  ),
  /// `src/Home/LogDetails/LogDetailsNewScreen.tsx`
  logDetails(
    key: 'LOG_DETAILS',
    route: 'LogDetails',
    title: 'LOG DETAILS',
    path: '/home/home_nav/modal_nav/log_details_nav/event_add',
    presentation: FpPresentation.stack,
    navigator: 'LOG_DETAILS',
    invented: false,
  ),
  /// `src/Home/LogEntryEditButtons/LogEntryEditButtons.tsx`
  logDetailsEditButtons(
    key: 'LOG_DETAILS_EDIT_BUTTONS',
    route: 'LogDetailsEditButtons',
    title: 'EDIT BUTTON',
    path: '/home/home_nav/modal_nav/log_details_nav/edit_buttons',
    presentation: FpPresentation.stack,
    navigator: 'LOG_DETAILS',
    invented: false,
  ),
  /// `src/Home/LogEntryEditPusher/LogEntryEditPusher.tsx`
  logDetailsEditPusher(
    key: 'LOG_DETAILS_EDIT_PUSHER',
    route: 'LogDetailsEdit',
    title: 'EDIT MEMBER',
    path: '/home/home_nav/modal_nav/log_details_nav/edit_pusher',
    presentation: FpPresentation.stack,
    navigator: 'LOG_DETAILS',
    invented: false,
  ),
  /// `src/Home/LogDetails/LogDetailsEditScreen.tsx`
  logEntryEdit(
    key: 'LOG_ENTRY_EDIT',
    route: 'LogEntryEdit',
    title: 'EDIT LOG ENTRY',
    path: '/home/home_nav/modal_nav/log_edit_nav/event_edit',
    presentation: FpPresentation.stack,
    navigator: 'LOG_ENTRY_EDIT',
    invented: false,
  ),
  /// `src/Home/LogEntryEditButtons/LogEntryEditButtons.tsx`
  logEntryEditButtons(
    key: 'LOG_ENTRY_EDIT_BUTTONS',
    route: 'LogEntryEditButtons',
    title: 'EDIT BUTTONS PRESSED',
    path: '/home/home_nav/modal_nav/log_edit_nav/edit_buttons',
    presentation: FpPresentation.stack,
    navigator: 'LOG_ENTRY_EDIT',
    invented: false,
  ),
  /// `src/Home/LogEntryEditPusher/LogEntryEditPusher.tsx`
  logEntryEditPusher(
    key: 'LOG_ENTRY_EDIT_PUSHER',
    route: 'LogEntryEditPusher',
    title: 'EDIT MEMBER',
    path: '/home/home_nav/modal_nav/log_edit_nav/edit_pusher',
    presentation: FpPresentation.stack,
    navigator: 'LOG_ENTRY_EDIT',
    invented: false,
  ),
  /// `src/Home/Settings/Settings.tsx`
  settings(
    key: 'SETTINGS',
    route: 'Tools',
    title: 'SETTINGS',
    path: '/home/home_nav/tools',
    presentation: FpPresentation.drawer,
    navigator: 'HOME_NAV',
    invented: false,
  ),
  /// `unimplemented in the RN app`
  unknown(
    key: 'UNKNOWN',
    route: 'Unknown',
    title: 'UNKNOWN',
    path: '/unknown',
    presentation: FpPresentation.none,
    navigator: null,
    invented: true,
  ),
  /// `no RN original — designed for this app`
  signIn(
    key: 'SIGN_IN',
    route: 'SignIn',
    title: 'SIGN IN',
    path: '/sign_in',
    presentation: FpPresentation.stack,
    navigator: 'AUTHENTICATION',
    invented: true,
  ),
  /// `no RN original — designed for this app`
  signUp(
    key: 'SIGN_UP',
    route: 'SignUp',
    title: 'CREATE ACCOUNT',
    path: '/sign_up',
    presentation: FpPresentation.stack,
    navigator: 'AUTHENTICATION',
    invented: true,
  ),
  /// `no RN original — designed for this app`
  forgotPassword(
    key: 'FORGOT_PASSWORD',
    route: 'ForgotPassword',
    title: 'RESET PASSWORD',
    path: '/forgot_password',
    presentation: FpPresentation.stack,
    navigator: 'AUTHENTICATION',
    invented: true,
  ),
  /// `no RN original — designed for this app`
  checkYourEmail(
    key: 'CHECK_YOUR_EMAIL',
    route: 'CheckYourEmail',
    title: 'CHECK YOUR EMAIL',
    path: '/check_your_email',
    presentation: FpPresentation.stack,
    navigator: 'AUTHENTICATION',
    invented: true,
  ),
  /// `no RN original — designed for this app`
  verifyEmail(
    key: 'VERIFY_EMAIL',
    route: 'VerifyEmail',
    title: 'VERIFY EMAIL',
    path: '/verify_email',
    presentation: FpPresentation.stack,
    navigator: 'AUTHENTICATION',
    invented: true,
  ),
  ;

  const FpScreen({
    required this.key,
    required this.route,
    required this.title,
    required this.path,
    required this.presentation,
    required this.navigator,
    required this.invented,
  });

  /// The `Screen` enum name in the RN app, e.g. `DASHBOARD`.
  final String key;

  /// The route value the RN navigator registered. Several of these are display
  /// strings rather than identifiers; that is recorded, not corrected.
  final String route;

  /// The header title, upper-cased as the RN app sets it. Null where none.
  final String? title;

  /// The go_router location. Equal to the RN deep link except where `invented`.
  final String path;

  final FpPresentation presentation;

  /// The RN navigator this screen was registered in, e.g. `ACTIVITY`. An
  /// invented screen names the navigator it belongs *with* rather than one that
  /// registered it, because nothing in the RN app registers it.
  final String? navigator;

  /// True where the RN app has no original.
  ///
  /// Two cases, and they are worth telling apart when reading this file:
  ///
  /// * The whole screen is new — the six auth screens. `impl` is null, no
  ///   navigator registers them, and their doc line says so.
  /// * Only the *path* is new — `UNKNOWN`, which is a member of the RN
  ///   `Screen` enum that no navigator registers and no deep link reaches.
  ///
  /// What they have in common, and the reason for one flag rather than two, is
  /// the only thing the router cares about: this path was not taken from the RN
  /// app, so nothing upstream guarantees it.
  final bool invented;

  static FpScreen? byPath(String path) {
    for (final s in FpScreen.values) {
      if (s.path == path) return s;
    }
    return null;
  }
}

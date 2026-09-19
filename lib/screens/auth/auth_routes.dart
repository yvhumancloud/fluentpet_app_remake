/// The auth area's five builders, for `app_router.dart` to fold in.
///
/// Mirrors `lib/screens/hardware/hardware_routes.dart` exactly: this file
/// registers nothing itself. It exports [authRoutes], keyed by [FpScreen], for
/// the router — owned elsewhere — to merge alongside the other areas' maps.
///
/// Unlike the other areas, these five [FpScreen] values did not come out
/// of the React Native app. They come from
/// `docs/design-system/data/invented-screens.json`, are merged into the screen
/// map by `scripts/build-screen-map.mjs`, and carry `invented: true` all the
/// way through to the enum. **This file still invents nothing**: the paths and
/// the enum values arrive here already decided, exactly as they do for the
/// thirty-six extracted ones, and the fix for a wrong path is upstream.
///
/// ## Arguments, and why they are query parameters
///
/// Two of the five take one, and both ride as query parameters on the
/// generated path rather than as `state.extra` — the README's rule, because
/// `extra` survives a push and evaporates on a deep link or a restore, which is
/// the one case anybody tests it in.
///
/// Both are missable, and both screens have a designed state for being opened
/// without it — the drawer's route index reaches all five with no query string
/// at all, and none of them renders a blank.
///
/// | screen | parameters | absent |
/// |---|---|---|
/// | `CHECK_YOUR_EMAIL` | `email` | says the screen needs one, offers the form that supplies it |
/// | `VERIFY_EMAIL` | `email` | the session's own address; without one, the same notice |
///
/// There is no `SET_NEW_PASSWORD`: Firebase Auth hosts the password-reset page
/// the email links to, so the app's part ends at `CHECK_YOUR_EMAIL`. And there
/// is no verified state: the router moves a verified session on by itself.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import 'check_your_email_screen.dart';
import 'forgot_password_screen.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'verify_email_screen.dart';

/// The five auth screens, keyed the way [FpScreen] keys everything else.
final Map<FpScreen, Widget Function(BuildContext, GoRouterState)> authRoutes =
    <FpScreen, Widget Function(BuildContext, GoRouterState)>{
      FpScreen.signIn: (context, state) => const SignInScreen(),
      FpScreen.signUp: (context, state) => const SignUpScreen(),
      FpScreen.forgotPassword: (context, state) => const ForgotPasswordScreen(),
      FpScreen.checkYourEmail: (context, state) => CheckYourEmailScreen(
        // Empty rather than null: the screen's own no-address state says
        // everything a null check here could, and it says it on screen rather
        // than in a crash. Same call the Hardware area makes for `BASE_EDIT`.
        email: state.uri.queryParameters['email'] ?? '',
      ),
      FpScreen.verifyEmail: (context, state) =>
          VerifyEmailScreen(email: state.uri.queryParameters['email'] ?? ''),
    };

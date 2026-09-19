/// Firebase Cloud Messaging, behind one class.
///
/// The backend (`services/push.py`) sends a notification with a `data.key` in
/// `base_registered`, `base_removed`, `base_battery_low`, `base_fully_charged`,
/// `base_offline`, `button_linked`, `button_unlinked`, `button_pressed`. The
/// app's part is small: ask for permission once a session exists, hand every
/// token to `PUT /push-tokens`, take it back with `DELETE /push-tokens/{token}`
/// on sign-out, and turn a tap on a notification into the tab that answers it.
///
/// Foreground messages are not surfaced as a banner. Android shows nothing for
/// an FCM notification while the app is open, and drawing one needs a second
/// package; the presses it would announce are on the Activity tab already.
library;

import 'package:dio/dio.dart' show DioException;
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentpet_api/fluentpet_api.dart' show PushTokenIn;
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart' show Sentry;

import '../data/api/api_client.dart';
import '../router/app_router.dart';
import '../router/tabs.dart';
import 'auth_service.dart';

class PushService {
  PushService(this._messaging);

  final FirebaseMessaging _messaging;

  /// Android 13+ prompts; earlier versions grant silently. Called after
  /// sign-in rather than at launch, so the first thing a new user sees is
  /// not a permission sheet.
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// The current registration token, then every rotation. What
  /// `PUT /push-tokens` consumes.
  Stream<String> get tokens async* {
    final first = await _messaging.getToken();
    if (first != null) yield first;
    yield* _messaging.onTokenRefresh;
  }

  /// A tap on a notification: the one that opened the app from cold, then
  /// every one while it is in the background.
  Stream<RemoteMessage> get opened async* {
    final initial = await _messaging.getInitialMessage();
    if (initial != null) yield initial;
    yield* FirebaseMessaging.onMessageOpenedApp;
  }

  /// Which tab a notification is about. Everything hardware lands on
  /// Hardware; a press, and the weekly digest (PRD §12.6, a note in the
  /// feed), land on Activity.
  static FpTab tabFor(RemoteMessage message) =>
      const <String>{
        'button_pressed',
        'weekly_digest',
      }.contains(message.data['key'])
      ? FpTab.activity
      : FpTab.hardware;
}

final Provider<PushService> pushServiceProvider = Provider<PushService>(
  (ref) => PushService(FirebaseMessaging.instance),
);

/// The registration token, live. [pushBootstrapProvider] uploads every value.
final StreamProvider<String> pushTokenProvider = StreamProvider<String>(
  (ref) => ref.watch(pushServiceProvider).tokens,
);

/// Keeps FCM in step with the session. Watched once, from the app root.
///
/// Asks for permission the first time a session is usable — signed in and
/// verified — so the sheet appears over the app, not over the welcome or
/// verify screens. Registers the token with the backend whenever either side
/// changes: a new token, or a new session. And routes a tapped notification
/// to its tab.
final Provider<void> pushBootstrapProvider = Provider<void>((ref) {
  final push = ref.read(pushServiceProvider);

  Future<void> register() async {
    final token = ref.read(pushTokenProvider).value;
    if (token == null || !_usable(ref.read(authStateProvider).value)) return;
    try {
      await ref
          .read(apiProvider)
          .getPushApi()
          .registerPushToken(
            pushTokenIn: PushTokenIn(
              (b) => b
                ..token = token
                ..platform = 'android',
            ),
          );
    } on DioException catch (e, st) {
      // Not fatal to the session, but a user who silently never gets a push
      // is a bug nobody reports — so Sentry hears about it.
      await Sentry.captureException(e, stackTrace: st);
    }
  }

  ref.listen(authStateProvider, (previous, next) {
    if (_usable(next.value) && !_usable(previous?.value)) {
      push.requestPermission();
      register();
    }
  }, fireImmediately: true);
  ref.listen(pushTokenProvider, (_, next) {
    // Debug builds print the token so a test push can be sent from the
    // Firebase console (Messaging → New campaign → Send test message).
    if (kDebugMode) debugPrint('FCM token: ${next.value}');
    register();
  }, fireImmediately: true);
  final opened = push.opened.listen(
    (message) =>
        ref.read(routerProvider).go(PushService.tabFor(message).root.path),
  );
  ref.onDispose(opened.cancel);
});

bool _usable(User? u) => u != null && !needsVerification(u);

/// How the app signs out. Tells the backend to forget this device first —
/// after `signOut` there is no token to authorise the call with, and a
/// forgotten device keeps receiving the household's presses.
final Provider<Future<void> Function()> signOutProvider =
    Provider<Future<void> Function()>(
      (ref) => () async {
        final token = ref.read(pushTokenProvider).value;
        if (token != null && _usable(ref.read(authStateProvider).value)) {
          try {
            await ref
                .read(apiProvider)
                .getPushApi()
                .deletePushToken(token: token);
          } on DioException {
            // Offline. Sign out anyway; the backend drops the token on its
            // next failed delivery.
          }
        }
        await ref.read(authServiceProvider).signOut();
      },
    );

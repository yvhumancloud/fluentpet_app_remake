import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'env.dart';

Future<void> main() async {
  // Sentry wraps the whole run so uncaught errors anywhere — Flutter, Dart
  // zones, the platform side — are reported. With no DSN it is a no-op.
  await SentryFlutter.init((options) {
    options.dsn = sentryDsn;
    options.environment = env;
    // Errors always; performance traces are sampled so the free plan is
    // not spent on a trace per screen.
    options.tracesSampleRate = isDev ? 1.0 : 0.1;
    options.sendDefaultPii = false;
  }, appRunner: _run);
}

Future<void> _run() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Android reads its config from android/app/google-services.json, so there
  // is no `options:` here. Add `firebase_options.dart` (flutterfire configure)
  // when iOS or web join.
  await Firebase.initializeApp();
  // The persisted session is restored asynchronously; waiting for the first
  // event means the router's redirect sees the real user on its first run
  // rather than a null that flashes WELCOME at a signed-in user.
  await FirebaseAuth.instance.authStateChanges().first;
  runApp(const ProviderScope(child: FluentPetApp()));
}

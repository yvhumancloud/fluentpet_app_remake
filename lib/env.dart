/// Which backend environment this build talks to — the PRD's `dev` or `prod`.
///
/// Set at build time: `flutter run --dart-define=ENV=prod`. Unset, a debug
/// build is `dev` and a release build is `prod`, so a Play Store build that
/// forgot the flag still points at production and carries no dev shortcuts.
///
/// Everything environment-specific reads this one value: the API base URL
/// (API phase), the dev-only verification bypass in `auth_service.dart`, and
/// the `environment` tag on every Sentry event.
library;

import 'package:flutter/foundation.dart' show kDebugMode;

const String env = String.fromEnvironment(
  'ENV',
  defaultValue: kDebugMode ? 'dev' : 'prod',
);

const bool isDev = env == 'dev';

/// Where `/api/v1` lives. `10.0.2.2` is the Android emulator's name for the
/// host machine, so the dev default reaches a backend on `localhost:8080`.
/// A device on Wi-Fi or a deployed dev backend: `--dart-define=API_URL=…`.
/// Prod has no default on purpose — a release build must say where it points.
const String apiBaseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: isDev ? 'http://10.0.2.2:8080' : '',
);

/// The Sentry DSN for the app's Flutter project. Not a secret — it ships in
/// the APK — but per project, so the backend's DSN is not this one. Baked in
/// so a store build cannot forget it; `--dart-define=SENTRY_DSN=` (empty)
/// silences a local run.
const String sentryDsn = String.fromEnvironment(
  'SENTRY_DSN',
  defaultValue: 'https://ed007cca49a37ff380ade2a3fb905077@o4510147887169536.ingest.us.sentry.io/4512100842930176',
);

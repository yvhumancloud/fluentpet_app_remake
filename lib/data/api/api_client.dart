/// The one `FluentpetApi` instance, carrying the Firebase ID token.
///
/// `packages/fluentpet_api` is generated from the backend's OpenAPI spec
/// (`tool/gen_api.sh`) and knows nothing about Firebase. This is where the
/// two meet: every request asks [AuthService.idToken] for the current token
/// — Firebase refreshes it hourly, so it is read per request, not cached —
/// and sends it as `Authorization: Bearer`. Repositories take the client from
/// [apiProvider]; nothing else constructs one.
library;

import 'package:dio/dio.dart';
import 'package:fluentpet_api/fluentpet_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_service.dart';
import '../../env.dart';

/// `X-Login-As`: the admin impersonation the PRD describes. Null for
/// everyone. Set from Settings; [apiProvider] watches it, so a change rebuilds
/// the client and every repository read behind it.
final NotifierProvider<LoginAsNotifier, String?> loginAsProvider =
    NotifierProvider<LoginAsNotifier, String?>(LoginAsNotifier.new);

class LoginAsNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? email) => state = email;
}

final Provider<FluentpetApi> apiProvider = Provider<FluentpetApi>((ref) {
  final auth = ref.watch(authServiceProvider);
  final loginAs = ref.watch(loginAsProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      // Cloud Run cold starts are slower than the generator's 3s default.
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  return FluentpetApi(
    dio: dio,
    interceptors: <Interceptor>[
      // Queued: the token read is async, and requests must not overtake it.
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await auth.idToken();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          if (loginAs != null) options.headers['X-Login-As'] = loginAs;
          // The model reads the log before answering; measured 35–140s.
          if (options.path.startsWith('/api/v1/ai/')) {
            options.receiveTimeout = const Duration(minutes: 3);
          }
          handler.next(options);
        },
      ),
    ],
  );
});

/// What to tell the user when a call failed.
///
/// The backend's errors are `{ "error": { "code", "message" } }` and the
/// message is written for people ("range must be 0–183 days"), so it is
/// shown when there is one; a network failure or a 5xx gets [fallback].
String apiErrorMessage(Object error, String fallback) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['error'] is Map) {
      final message = (data['error'] as Map)['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return 'No connection. $fallback';
    }
  }
  return fallback;
}

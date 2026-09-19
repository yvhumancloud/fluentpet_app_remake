/// The AI calls in `../backend/PRD.md` §12: the generated [AiApi] plus the
/// two things the generator cannot know — the PRD's caps and what a failure
/// means to a screen.
///
/// The PRD's one rule for the app: it must work fully without AI. A blank
/// key on the server is 503 `ai_unavailable`; an undeployed route is 404;
/// both are [AiFailure.unavailable] here, and every screen has a state for
/// it.
library;

import 'package:dio/dio.dart';
import 'package:fluentpet_api/fluentpet_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

export 'package:fluentpet_api/fluentpet_api.dart'
    show ChatIn, ChatMessage, ChatMessageRoleEnum, LogTextIn, LogTextOut;

/// PRD §12.3 caps: turns kept per thread, characters per message and per
/// log-by-text request. Enforced here so the server never sees a 422 for
/// something the composer could have stopped.
const int aiMaxThread = 20;
const int aiMaxMessageChars = 2000;
const int aiMaxLogTextChars = 1000;

/// Why an AI call did not answer, in the vocabulary the screens draw.
enum AiFailure {
  /// 503 `ai_unavailable`, or the route is not deployed (404).
  unavailable,

  /// 429: the per-user daily cap (PRD §12.3).
  rateLimited,

  /// Network, timeout, anything else.
  other;

  static AiFailure of(Object error) {
    if (error is! DioException) return AiFailure.other;
    return switch (error.response?.statusCode) {
      503 || 404 => AiFailure.unavailable,
      429 => AiFailure.rateLimited,
      _ => AiFailure.other,
    };
  }
}

final Provider<AiApi> aiApiProvider = Provider<AiApi>(
  (ref) => ref.watch(apiProvider).getAiApi(),
);

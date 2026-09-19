/// The three AI calls in `../backend/PRD.md` §12, on the wire.
///
/// Hand-written against the PRD's contract rather than generated: the
/// endpoints are milestone 7–8 on the backend and are not in its OpenAPI yet.
/// When they land, `tool/gen_api.sh` will add them to the package and this
/// file can be swapped for the generated calls with the same shapes.
///
/// The PRD's one rule for the app: it must work fully without AI. A blank
/// key on the server is 503 `ai_unavailable`; an undeployed route is 404;
/// both are [AiFailure.unavailable] here, and every screen has a state for
/// it.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

const String _ai = '/api/v1/ai';

/// PRD §12.3 caps: turns kept per thread, characters per message and per
/// log-by-text request. Enforced here so the server never sees a 422 for
/// something the composer could have stopped.
const int aiMaxThread = 20;
const int aiMaxMessageChars = 2000;
const int aiMaxLogTextChars = 1000;

enum AiRole { user, assistant }

class AiMessage {
  const AiMessage({required this.role, required this.content});

  final AiRole role;
  final String content;

  Map<String, String> toJson() => {'role': role.name, 'content': content};
}

/// `POST /ai/chat`.
class AiReply {
  const AiReply({required this.reply, required this.remainingToday});

  final String reply;
  final int remainingToday;
}

/// `POST /ai/log-text`: ids only, as the server sends them. The screen
/// resolves them against the Board, the Pushers and the Contexts.
class AiDraft {
  const AiDraft({
    required this.pusherId,
    required this.buttonIds,
    required this.contextIds,
    required this.occurredAt,
    required this.note,
    required this.unmatchedWords,
  });

  final int? pusherId;
  final List<int> buttonIds;
  final List<int> contextIds;

  /// Null means now.
  final DateTime? occurredAt;
  final String? note;

  /// Words the model heard that are not on the Board; the app offers
  /// "create Button" for each.
  final List<String> unmatchedWords;

  bool get isEmpty => buttonIds.isEmpty && (note ?? '').isEmpty;
}

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

class AiClient {
  AiClient(this._dio);

  final Dio _dio;

  Future<AiReply> chat(List<AiMessage> thread) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '$_ai/chat',
      data: {'messages': thread.map((m) => m.toJson()).toList()},
    );
    final data = r.data!;
    return AiReply(
      reply: data['reply'] as String,
      remainingToday: (data['remaining_today'] as num).toInt(),
    );
  }

  Future<AiDraft> logText(String text) async {
    final r = await _dio.post<Map<String, dynamic>>(
      '$_ai/log-text',
      data: {'text': text},
    );
    final data = r.data!;
    final draft = data['draft'] as Map<String, dynamic>;
    final at = draft['occurred_at'] as String?;
    return AiDraft(
      pusherId: (draft['pusher_id'] as num?)?.toInt(),
      buttonIds: _ints(draft['button_ids']),
      contextIds: _ints(draft['context_ids']),
      occurredAt: at == null ? null : DateTime.parse(at).toLocal(),
      note: draft['note'] as String?,
      unmatchedWords: [
        for (final w in (data['unmatched_words'] as List<dynamic>? ?? const []))
          w as String,
      ],
    );
  }

  static List<int> _ints(Object? v) => [
    for (final x in (v as List<dynamic>? ?? const [])) (x as num).toInt(),
  ];
}

final Provider<AiClient> aiClientProvider = Provider<AiClient>(
  (ref) => AiClient(ref.watch(apiProvider).dio),
);

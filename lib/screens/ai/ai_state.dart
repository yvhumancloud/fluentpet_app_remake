/// State the three AI screens share: the one-time consent, the chat thread,
/// and the gate every AI entry point goes through.
///
/// PRD §12.8: *"The app shows a one-time consent screen before the first AI
/// call and records it client-side."* The record is a bool in
/// `SharedPreferences`; nothing about it goes to the server.
///
/// The chat thread lives in memory for the session and is sent whole on
/// every turn — the Messages API is stateless and the PRD keeps no history
/// table. Leaving the screen keeps the thread; relaunching the app drops it.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api/ai_client.dart';
import '../../router/screens.g.dart';

// ─────────────────────────── consent ───────────────────────────

final AsyncNotifierProvider<AiConsentNotifier, bool> aiConsentProvider =
    AsyncNotifierProvider<AiConsentNotifier, bool>(AiConsentNotifier.new);

class AiConsentNotifier extends AsyncNotifier<bool> {
  static const String _key = 'ai_consent_v1';

  @override
  Future<bool> build() async =>
      (await SharedPreferences.getInstance()).getBool(_key) ?? false;

  Future<void> grant() async {
    state = const AsyncData<bool>(true);
    await (await SharedPreferences.getInstance()).setBool(_key, true);
  }
}

/// Opens [target] — `AI_CHAT` or `AI_LOG_TEXT` — through the consent screen
/// the first time. Every AI entry point calls this and nothing pushes an AI
/// screen directly, so the consent cannot be skipped by a second door.
Future<void> openAi(
  BuildContext context,
  WidgetRef ref,
  FpScreen target,
) async {
  final consented = await ref.read(aiConsentProvider.future);
  if (!context.mounted) return;
  context.push(
    consented
        ? target.path
        : '${FpScreen.aiConsent.path}?next=${Uri.encodeComponent(target.path)}',
  );
}

// ─────────────────────────── chat ───────────────────────────

class AiChatState {
  const AiChatState({
    this.messages = const <AiMessage>[],
    this.pending = false,
    this.remainingToday,
    this.failure,
  });

  final List<AiMessage> messages;

  /// A reply is on its way.
  final bool pending;

  /// Turns left today, from the last reply. Null until the first one.
  final int? remainingToday;

  /// Why the last turn got no reply. Cleared by the next send.
  final AiFailure? failure;

  AiChatState copyWith({
    List<AiMessage>? messages,
    bool? pending,
    int? remainingToday,
    AiFailure? failure,
    bool clearFailure = false,
  }) => AiChatState(
    messages: messages ?? this.messages,
    pending: pending ?? this.pending,
    remainingToday: remainingToday ?? this.remainingToday,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}

final NotifierProvider<AiChatNotifier, AiChatState> aiChatProvider =
    NotifierProvider<AiChatNotifier, AiChatState>(AiChatNotifier.new);

class AiChatNotifier extends Notifier<AiChatState> {
  @override
  AiChatState build() => const AiChatState();

  /// Sends [text] as the next turn. The failed turn's question stays in the
  /// thread so [retry] can resend it without retyping.
  Future<void> send(String text) async {
    final content = text.trim();
    if (content.isEmpty || state.pending) return;
    state = state.copyWith(
      messages: <AiMessage>[
        ...state.messages,
        AiMessage(role: AiRole.user, content: content),
      ],
      pending: true,
      clearFailure: true,
    );
    await _ask();
  }

  Future<void> retry() async {
    if (state.pending || state.messages.isEmpty) return;
    state = state.copyWith(pending: true, clearFailure: true);
    await _ask();
  }

  void clear() => state = const AiChatState();

  Future<void> _ask() async {
    // The PRD caps a thread at 20 messages, last one `user`; older turns
    // drop off the top and the model loses them, which is the honest
    // version of "no stored threads".
    final thread = state.messages.length > aiMaxThread
        ? state.messages.sublist(state.messages.length - aiMaxThread)
        : state.messages;
    try {
      final reply = await ref.read(aiClientProvider).chat(thread);
      state = state.copyWith(
        messages: <AiMessage>[
          ...state.messages,
          AiMessage(role: AiRole.assistant, content: reply.reply),
        ],
        pending: false,
        remainingToday: reply.remainingToday,
      );
    } catch (e) {
      state = state.copyWith(pending: false, failure: AiFailure.of(e));
    }
  }
}

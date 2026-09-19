/// The AI group's three builders, for `app_router.dart` to fold in.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../router/screens.g.dart';
import 'ai_chat_screen.dart';
import 'ai_consent_screen.dart';
import 'ai_log_text_screen.dart';

final Map<FpScreen, Widget Function(BuildContext, GoRouterState)> aiRoutes =
    <FpScreen, Widget Function(BuildContext, GoRouterState)>{
      FpScreen.aiConsent: (context, state) => AiConsentScreen(
        next: aiConsentNext(state.uri.queryParameters['next']),
      ),
      FpScreen.aiChat: (context, state) => const AiChatScreen(),
      FpScreen.aiLogText: (context, state) => const AiLogTextScreen(),
    };

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/fp_theme.dart';
import 'theme/theme_mode.dart';

/// The app.
///
/// Follows the system scheme by default and can be forced to either — see
/// [themeModeProvider]. Forcing exists because the two palettes have to be
/// compared side by side to be checked, and because a screenshot pass needs to
/// pick a scheme rather than ask the OS for one.
class FluentPetApp extends ConsumerWidget {
  const FluentPetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'FluentPet',
      debugShowCheckedModeBanner: false,
      theme: FpTheme.light,
      darkTheme: FpTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

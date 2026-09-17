import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which scheme the app is in.
///
/// Defaults to [ThemeMode.system], so the app follows the device. It is
/// overridable because the light and dark palettes have to be *looked at* side
/// by side to be checked, and waiting for the OS to change is not a workflow.
/// Nothing in a screen should read this; screens read colour from
/// `context.fpColors`, which is already correct for whichever scheme is active.
final NotifierProvider<AppThemeMode, ThemeMode> themeModeProvider =
    NotifierProvider<AppThemeMode, ThemeMode>(AppThemeMode.new);

class AppThemeMode extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;

  /// system -> light -> dark -> system.
  void cycle() => state = switch (state) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      };

  String get label => switch (state) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };
}

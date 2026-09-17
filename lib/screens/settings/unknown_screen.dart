/// `UNKNOWN` — invented (`screens.g.dart`: `invented: true`, `navigator:
/// null`). There is no RN screen behind this key; it is what `app_router.dart`
/// falls back to when a path does not resolve to any of the thirty-six
/// screens the map knows — a stale deep link, a typo, a link built against a
/// future version of the app.
///
/// ## The two things it must not be
///
/// * **Not a crash.** A route that fails to resolve is routine — deep links go
///   stale, marketing sends the wrong URL — and the screen says so calmly:
///   what happened, in one sentence, not a stack trace or a red screen.
/// * **Not a real screen.** No [ScreenHeader], no back chevron implying a
///   specific place the user came from (there may not be one — this can be
///   the very first screen a stale link opens), and no tab-bar styling that
///   could let it pass for a page that actually exists. It gets its own
///   quieter chrome so landing here reads as "the app caught this" rather
///   than "this is Settings" or "this is Hardware".
///
/// ## Escape, not diagnosis
///
/// The brief asks for "a way back to a root tab" — singular, deliberate:
/// Activity, this app's landing tab (`FpTab.activity`, `PLAN.md`), rather than
/// a menu of all three. One calm exit beats a decision tree on a screen whose
/// entire job is to stop feeling stuck.
///
/// [attemptedPath] is shown in mono, the way `PlaceholderScreen` shows its own
/// facts — not because a user wants to read a path, but because it is the
/// first thing worth pasting into a bug report when a link turns out to be
/// wrong, and this screen is more likely than any other to be screenshotted.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../router/tabs.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../log/log_controls.dart' show LogActionButton;

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({this.attemptedPath, super.key});

  final String? attemptedPath;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final path = attemptedPath;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(FpSpace.s7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PhosphorIcon(
                  PhosphorIconsRegular.compass,
                  size: FpIconSize.xl,
                  color: c.textTertiary,
                ),
                const SizedBox(height: FpSpace.s5),
                Text(
                  "We couldn't find that screen",
                  textAlign: TextAlign.center,
                  style: FpType.headingMd.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: FpSpace.s3),
                Text(
                  'The link that brought you here may be out of date.',
                  textAlign: TextAlign.center,
                  style: FpType.bodyMd.copyWith(color: c.textSecondary),
                ),
                if (path != null && path.isNotEmpty) ...<Widget>[
                  const SizedBox(height: FpSpace.s4),
                  Text(
                    path,
                    textAlign: TextAlign.center,
                    style: FpType.monoSm.copyWith(color: c.textTertiary),
                  ),
                ],
                const SizedBox(height: FpSpace.s7),
                SizedBox(
                  width: double.infinity,
                  child: LogActionButton(
                    label: 'GO TO ACTIVITY',
                    onPressed: () => context.go(FpTab.activity.root.path),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

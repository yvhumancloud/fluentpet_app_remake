/// The two components the design system specifies that Flutter must **not**
/// build: the iOS status bar and the home indicator.
///
/// Both are specified on the components page, and both say so themselves. The
/// status bar's third rule is the whole answer: *"This is the OS's chrome.
/// Flutter gets it from SafeArea; nothing here is a widget to build."* The
/// home indicator exists in Astro only so a browser draws the 34pt band that a
/// phone reserves anyway.
///
/// Drawing either of them in the app would put a fake clock and a fake home bar
/// on a device that already has real ones. So there is no `StatusBar` widget
/// and no `HomeIndicator` widget here, on purpose, and this file holds the two
/// genuinely-needed pieces instead:
///
/// * [FpOsChrome], which honours the top inset and tells the OS which way to
///   paint its own glyphs.
/// * The bottom inset, which is not here at all — [FpTabBar] adds it below its
///   own row, which is the same rule as *"the tab bar sits above this inset,
///   never inside it"*.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/fp_context.dart';

/// Screen-level OS chrome handling: the top safe-area inset, plus the
/// system overlay style.
///
/// The status bar spec's second rule — *"the glyphs inherit text.primary, so a
/// screen may not put a dark header behind the status bar without inverting the
/// scheme for that subtree"* — is a real constraint on a device, where the app
/// cannot colour those glyphs but can choose light or dark ones. That choice is
/// made here from the active scheme, so it is right in both without any screen
/// thinking about it.
///
/// [bottom] is false by default: the tab bar handles the bottom inset itself,
/// and a screen that also consumed it would double the padding. Pass true on a
/// screen with no tab bar under it.
class FpOsChrome extends StatelessWidget {
  const FpOsChrome({required this.child, this.bottom = false, super.key});

  final Widget child;
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark
          ? SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: context.fpColors.surfaceRaised,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: context.fpColors.surfaceRaised,
            ),
      child: SafeArea(bottom: bottom, child: child),
    );
  }
}

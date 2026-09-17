import 'package:flutter/widgets.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'screens.g.dart';

/// The three roots of the app.
///
/// ## Order — read this before changing it
///
/// **Household, Activity, Hardware**, and Activity is the default landing tab
/// because it answers the first job. Those are two different statements and
/// both matter: Activity lands first without being first.
///
/// This is the order the specification gives — `design-system/src/components/
/// ui/TabBar.astro` and the RN app's `TabNavigator.tsx` agree on it — and it is
/// stated here and nowhere else. `StatefulNavigationShell.goBranch` takes an
/// index, so a tab bar that ordered its items independently would send people
/// to the wrong tab. [FpTabBar] therefore reads this enum rather than carrying
/// its own list, and the router builds its branches from it in the same order.
///
/// An earlier revision of this file ordered them Activity, Household,
/// Hardware. That was wrong, and the router's landing screen is expressed as
/// `FpTab.activity.root.path` rather than as branch 0 so that fixing it here
/// was the whole fix.
enum FpTab {
  household(
    root: FpScreen.household,
    navigator: 'HOUSEHOLD',
    label: 'Household',
    icon: PhosphorIconsRegular.houseLine,
    selectedIcon: PhosphorIconsFill.houseLine,
  ),
  activity(
    root: FpScreen.dashboard,
    navigator: 'ACTIVITY',
    label: 'Activity',
    icon: PhosphorIconsRegular.chatTeardropDots,
    selectedIcon: PhosphorIconsFill.chatTeardropDots,
  ),
  hardware(
    root: FpScreen.bases,
    navigator: 'BASE',
    label: 'Hardware',
    icon: PhosphorIconsRegular.broadcast,
    selectedIcon: PhosphorIconsFill.broadcast,
  );

  const FpTab({
    required this.root,
    required this.navigator,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  /// The screen the branch opens on.
  final FpScreen root;

  /// The RN navigator whose screens belong to this branch. Membership is
  /// derived from the screen map rather than listed, so a screen added to
  /// `ActivityNavigator.tsx` upstream lands in the right branch by itself.
  final String navigator;

  final String label;

  /// Phosphor, one set, two weights of the same glyph.
  ///
  /// Selection is a weight change — regular to fill — never a second icon and
  /// never a background pill. These are a pair of the *same* icon on purpose;
  /// swapping one for a different glyph would break the mechanism the whole
  /// icon set was chosen for.
  final IconData icon;
  final IconData selectedIcon;

  /// Screens that live inside this branch's navigator.
  Iterable<FpScreen> get screens =>
      FpScreen.values.where((s) => s.navigator == navigator);

  /// Branch-first ordering: the root, then everything else it can push.
  List<FpScreen> get orderedScreens => <FpScreen>[
        root,
        ...screens.where((s) => s != root),
      ];

  /// The tab a screen belongs to, or null if it is not inside the tab bar.
  static FpTab? rootOf(FpScreen screen) {
    for (final tab in FpTab.values) {
      if (screen.navigator == tab.navigator) return tab;
    }
    return null;
  }
}

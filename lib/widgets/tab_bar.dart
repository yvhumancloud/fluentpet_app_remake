import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../router/tabs.dart';
import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import 'fp_metrics.dart';

/// The three roots of the app: Household, Activity, Hardware.
///
/// ## Why the `Fp` prefix
///
/// The design system calls this component "Tab bar". `package:flutter/
/// material.dart` already exports a `TabBar`, and every screen imports
/// material, so a widget named `TabBar` here would make the name ambiguous in
/// each of them. The prefix is the whole of the difference; this is the tab bar
/// the specification describes.
///
/// ## Rules it owes
///
/// * Selection is expressed **twice**: Phosphor weight regular → fill, and
///   colour tertiary → brand. Weight alone is too quiet at 22px; colour alone
///   fails for anyone who cannot separate teal from grey.
/// * Brand here is `text.brand`, a different step per scheme. Never a fixed
///   teal (ADR 0002).
/// * Three tabs, in the order [FpTab] declares. The order lives there, not
///   here, because `goBranch` takes an index and two lists would drift.
/// * The label stays label-sm at all times. Selection changes the weight of
///   the icon and the colour of both, and nothing else.
/// * The attention dot is a count-free status, not a badge. It says "go look",
///   not "you have 3".
///
/// The bar sits *above* the bottom safe-area inset, never inside it — the OS
/// owns that band, so the inset is added below the row rather than eaten by it.
class FpTabBar extends StatelessWidget {
  const FpTabBar({
    required this.currentIndex,
    required this.onSelected,
    this.alert,
    super.key,
  });

  /// Index into [FpTab.values], which is also the branch index.
  final int currentIndex;

  final ValueChanged<int> onSelected;

  /// The one tab wearing an attention dot, if any.
  final FpTab? alert;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        border: Border(
          top: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            for (final tab in FpTab.values)
              Expanded(
                child: _Tab(
                  tab: tab,
                  selected: tab.index == currentIndex,
                  alert: alert == tab,
                  onTap: () => onSelected(tab.index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.tab,
    required this.selected,
    required this.alert,
    required this.onTap,
  });

  final FpTab tab;
  final bool selected;
  final bool alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final tint = selected ? c.textBrand : c.textTertiary;

    return Semantics(
      label: tab.label,
      button: true,
      selected: selected,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: FpSpace.s3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    PhosphorIcon(
                      selected ? tab.selectedIcon : tab.icon,
                      size: FpMetrics.tabIcon,
                      color: tint,
                    ),
                    if (alert)
                      Positioned(
                        top: FpSpace.s0,
                        right: -FpSpace.px,
                        child: Container(
                          width: FpMetrics.attentionDot,
                          height: FpMetrics.attentionDot,
                          decoration: BoxDecoration(
                            color: c.statusDangerSolid,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: c.surfaceRaised,
                              width: FpStroke.thick,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: FpSpace.s1),
                Text(tab.label, style: FpType.labelSm.copyWith(color: tint)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

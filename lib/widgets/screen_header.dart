import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import 'fp_metrics.dart';

/// The title block at the top of a screen: what you are looking at, when, and
/// the one control that belongs with it.
///
/// Rules it owes:
///
/// * **One** trailing control, not a toolbar. The moment a second appears the
///   title stops being the thing you read first — so [trailing] is a single
///   widget and there is no list form.
/// * The title is Fraunces at display-sm, the only display-type element on a
///   screen apart from the utterances themselves.
/// * The title truncates; the trailing control never shrinks. Health
///   information must not be pushed off the edge by a long name.
/// * A root tab has no back chevron. [onBack] is for pushed screens only, and
///   the chevron exists exactly when there is somewhere to go back to.
/// * The subtitle is the full date in words. "Today" alone stops being true
///   once the user scrolls into history.
///
/// [child] is what hangs below the title row — on Activity, the Summary line.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
    this.child,
    super.key,
  });

  final String title;
  final String? subtitle;

  /// Non-null draws the back chevron. Null is a root tab.
  final VoidCallback? onBack;

  /// The one control. Typically a [DeviceHealthPill].
  final Widget? trailing;

  /// Hangs under the title row.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final sub = subtitle;
    final back = onBack;
    final control = trailing;
    final below = child;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s3,
        FpSpace.s6,
        FpSpace.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (back != null) ...<Widget>[
                _BackChevron(onTap: back),
                const SizedBox(width: FpSpace.s2),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: FpType.displaySm.copyWith(color: c.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (sub != null) ...<Widget>[
                      const SizedBox(height: FpSpace.s1),
                      Text(
                        sub,
                        style: FpType.labelMd.copyWith(color: c.textTertiary),
                      ),
                    ],
                  ],
                ),
              ),
              if (control != null) ...<Widget>[
                const SizedBox(width: FpSpace.s4),
                control,
              ],
            ],
          ),
          if (below != null) ...<Widget>[
            const SizedBox(height: FpSpace.s3),
            below,
          ],
        ],
      ),
    );
  }
}

/// Invented: the components page has no ratified back affordance, but every
/// pushed screen in the map needs one. A 32px hit circle around an 18px bold
/// caret, in secondary — quiet enough not to compete with the title.
class _BackChevron extends StatelessWidget {
  const _BackChevron({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      label: 'Back',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: FpMetrics.headerBackHit,
          height: FpMetrics.headerBackHit,
          child: Center(
            child: PhosphorIcon(
              PhosphorIconsBold.caretLeft,
              size: FpMetrics.headerChevron,
              color: c.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

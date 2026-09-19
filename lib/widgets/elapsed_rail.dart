import 'package:flutter/material.dart';

import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import 'fp_metrics.dart';

/// The measured gap between two consecutive Interactions, sitting in the
/// timeline's rail column.
///
/// The label is computed from the two timestamps upstream — see
/// `ActivityDay.elapsedAfter` — and is never a fixed spacer or an index-based
/// decoration.
///
/// The rule is a **fixed 24px**. Its height is deliberately not proportional to
/// the gap: a seven-hour overnight would push the next Interaction off screen.
/// Duration is carried by the label, which is why short and long look alike
/// apart from the words. That is the stated limit, not an omission.
///
/// A null [gap] renders nothing at all, **including no padding**. The last row
/// of a day must not sit above a dangling stub.
class ElapsedRail extends StatelessWidget {
  const ElapsedRail({required this.gap, super.key});

  /// Pre-formatted duration, e.g. "22 min" or "3 h 27 min". Null renders
  /// nothing.
  final String? gap;

  @override
  Widget build(BuildContext context) {
    final label = gap;
    if (label == null) return const SizedBox.shrink();

    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FpSpace.s2),
      child: Row(
        children: <Widget>[
          // The rule centres on the avatar above it: 44px column, 11px right
          // padding, 1px rule.
          const SizedBox(
            width: FpMetrics.timeRailWidth,
            child: Padding(
              padding: EdgeInsets.only(right: FpMetrics.elapsedRulePadRight),
              child: Align(alignment: Alignment.centerRight, child: _Rule()),
            ),
          ),
          const SizedBox(width: FpSpace.s4),
          Text(
            label,
            style: FpType.labelSm.copyWith(color: c.textTertiary).tabular,
          ),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: FpStroke.hairline,
      height: FpMetrics.elapsedRuleHeight,
      color: context.fpColors.borderDefault,
    );
  }
}

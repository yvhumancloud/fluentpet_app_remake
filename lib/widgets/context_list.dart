import 'package:flutter/material.dart';

import '../domain/domain.dart';
import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import 'fp_metrics.dart';

/// The Contexts tagged on an Interaction — the situation around a press, and
/// how a user later interprets what the pet meant.
///
/// Empty renders **nothing**: no placeholder, no "No contexts", no empty chip
/// row. An untagged Interaction is normal, not incomplete.
///
/// One quiet dot-separated line at label-md/tertiary, not chips — a row of
/// pills outweighs the utterance above it, and the utterance must win.
///
/// Contexts are free text the user typed, so any length is assumed and the
/// line wraps. It is never truncated to a fixed count with a "+2 more".
class ContextList extends StatelessWidget {
  const ContextList({required this.contexts, super.key});

  /// The same list, taken straight off an [Interaction].
  ContextList.of(Iterable<InteractionContext> contexts, {super.key})
    : contexts = contexts.map((ctx) => ctx.text).toList(growable: false);

  final List<String> contexts;

  @override
  Widget build(BuildContext context) {
    if (contexts.isEmpty) return const SizedBox.shrink();

    final c = context.fpColors;
    final style = FpType.labelMd.copyWith(color: c.textTertiary);

    // The separator is punctuation and is hidden from assistive technology;
    // a screen reader is handed the plain list instead.
    return Semantics(
      label: contexts.join(', '),
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              for (var i = 0; i < contexts.length; i++) ...<InlineSpan>[
                if (i > 0)
                  TextSpan(
                    text: ' · ',
                    style: style.copyWith(
                      color: c.textTertiary.withValues(
                        alpha: FpMetrics.separatorOpacity,
                      ),
                    ),
                  ),
                TextSpan(text: contexts[i]),
              ],
            ],
            style: style,
          ),
        ),
      ),
    );
  }
}

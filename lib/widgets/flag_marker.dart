import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import 'fp_metrics.dart';

/// Marks an Activity for follow-up. Read-only on the timeline; a control on a
/// detail screen.
///
/// Flagged versus not is a **Phosphor weight change** — regular to fill —
/// never a second icon and never a background pill. The whole icon set was
/// chosen so this works.
///
/// Unflagged renders nothing in a list. Reserving space for an absent flag
/// puts a grey ghost on every row, so [showUnflagged] is set only where the
/// marker is a control you can press.
///
/// The colour is `accent.fg`, the amber that carries text, not `accent.bg`,
/// which is the fill. On the timeline the flag sits beside display type and
/// has to hold its own. A flag is not a status: it never takes the danger or
/// warning ramp.
class FlagMarker extends StatelessWidget {
  const FlagMarker({
    this.flagged = false,
    this.showUnflagged = false,
    this.size = FpMetrics.flagInline,
    this.showLabel = false,
    this.onTap,
    super.key,
  });

  /// The marker as it appears on a detail screen: 16px, labelled, and
  /// tappable, drawing the outlined state when the Activity is not flagged.
  const FlagMarker.control({
    required bool flagged,
    VoidCallback? onTap,
    Key? key,
  }) : this(
         flagged: flagged,
         showUnflagged: true,
         size: FpIconSize.sm,
         showLabel: true,
         onTap: onTap,
         key: key,
       );

  final bool flagged;

  /// Draw the outlined "not flagged" state. Only ever true where the marker is
  /// tappable.
  final bool showUnflagged;

  /// [FpMetrics.flagInline] on the timeline, [FpIconSize.sm] in a control.
  final double size;

  final bool showLabel;
  final VoidCallback? onTap;

  /// The glue that pins an inline marker to the word in front of it.
  ///
  /// **U+2060 WORD JOINER.** Decision 5 says the flag never sits alone on a
  /// line. The first attempt at that was U+00A0 in front of a [WidgetSpan],
  /// reasoning from UAX #14 that a GL-class character forbids a break on either
  /// side of itself.
  ///
  /// That reasoning was right. What was wrong was the [WidgetSpan]. Skia lays a
  /// placeholder out as a U+FFFC object-replacement character and offers a break
  /// opportunity there **unconditionally**, whatever precedes it — so the glue
  /// never got a chance to apply. `test/flag_pin_test.dart` measures it: against
  /// a fixture with a real alternative break available, a `WidgetSpan` marker is
  /// orphaned at dozens of the swept widths behind U+00A0, behind U+2060, and
  /// behind a plain space alike. No character in front of a placeholder holds
  /// it.
  ///
  /// So [inlineSpans] draws the flag as the glyph it already is — Phosphor is a
  /// font, and the marker was only ever a widget by habit. Once it is text, the
  /// glue works exactly as UAX #14 says: the same test fails with U+0020 and
  /// passes with U+00A0.
  ///
  /// U+2060 rather than U+00A0 for two reasons, neither of them correctness.
  /// It is class WJ, whose LB11 outranks GL's LB12a, so it cannot be undone by
  /// a rule about what sits to its left. And it is zero-width, which lets the
  /// gap be [TextStyle.letterSpacing] — a number from the token scale, the same
  /// on a Learner's Fraunces row and a Note's Inter row. U+00A0's width is
  /// whatever the current font says it is, and those two rows are different
  /// fonts.
  static const String glue = '\u2060';

  /// The inline marker, as a pair of spans rather than a widget.
  ///
  /// For use inside a [TextSpan] tree only — a marker in running text must be
  /// text, or it cannot be kept on the same line as the word it belongs to. The
  /// widget form above is for everywhere else.
  ///
  /// Carries no semantics of its own: it renders a private-use code point that
  /// a screen reader must not read out. Every caller is responsible for saying
  /// "flagged" in the surrounding [Semantics] or [Text.semanticsLabel] — both
  /// callers in `utterance_row.dart` do.
  static List<InlineSpan> inlineSpans({
    required Color color,
    double size = FpMetrics.flagInline,
    double gap = FpSpace.s2,
  }) {
    const IconData icon = PhosphorIconsFill.flag;
    return <InlineSpan>[
      TextSpan(
        text: glue,
        style: TextStyle(letterSpacing: gap),
      ),
      TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          fontSize: size,
          // The glyph is its own line box; without this it inherits the
          // display-type leading and pushes the line height up.
          height: 1.0,
          color: color,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (!flagged && !showUnflagged) return const SizedBox.shrink();

    final c = context.fpColors;
    final colour = flagged ? c.accentFg : c.textTertiary;

    final Widget icon = PhosphorIcon(
      flagged ? PhosphorIconsFill.flag : PhosphorIconsRegular.flag,
      size: size,
      color: colour,
    );

    Widget marker = showLabel
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon,
              const SizedBox(width: FpSpace.s2),
              Text(
                flagged ? 'Flagged' : 'Flag',
                style: FpType.labelMd.copyWith(color: colour),
              ),
            ],
          )
        : icon;

    marker = Semantics(
      label: flagged ? 'Flagged' : 'Not flagged',
      button: onTap != null,
      child: ExcludeSemantics(child: marker),
    );

    if (onTap == null) return marker;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: marker,
    );
  }
}

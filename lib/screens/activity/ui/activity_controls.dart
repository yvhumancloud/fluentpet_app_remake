/// The controls the Activity area needs and the twelve components do not
/// provide.
///
/// The design system ratified twelve components, all of them derived from the
/// Activity screen. Nothing in that set is a tag, a segmented control, a
/// switch, a button or a statistic — because the Activity screen has none.
/// The filter sheet and the four facet screens do, and they have no visual
/// specification at all, so these are **designed here**, inside the stated
/// direction: warm editorial, warmth from typography and a warm accent rather
/// than from rounded shapes and pastels.
///
/// What that means in practice, and the rules these keep:
///
/// * **Corners are `FpRadius.sm`, not `full`.** The pill is the shape every
///   soft-friendly pet app reaches for. The one stadium shape in the app is
///   `DeviceHealthPill`, which the specification draws that way.
/// * **Selection is a fill plus a text colour, never an added glyph.** Rule
///   from the icon set: a selected state is a Phosphor weight change, never a
///   second icon and never a background pill bolted onto an unselected one.
/// * **Nothing here owns a colour.** Every value comes from
///   `context.fpColors`, so both schemes are correct by construction.
library;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../theme/fp_context.dart';
import '../../../theme/generated/fp_tokens.dart';
import 'activity_metrics.dart';

/// A selectable filter tag.
///
/// One tag per Pusher, Button meaning, Context or Base in the filter sheet, and
/// the same shape for the tri-state groups and the Select-all / Clear
/// affordances — because they are all "tap to change the filter", and giving
/// them three appearances would be three things to learn.
class ActivityTag extends StatelessWidget {
  const ActivityTag({
    required this.label,
    required this.selected,
    required this.onTap,
    this.emphasis = TagEmphasis.normal,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// [TagEmphasis.quiet] is for the section's own controls — Select all, Clear,
  /// Any/All — which act on the tags rather than being one of them.
  final TagEmphasis emphasis;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;

    final background = selected
        ? c.surfaceBrand
        : (emphasis == TagEmphasis.quiet ? c.surfaceCanvas : c.surfaceRaised);
    final foreground = selected
        ? c.textOnBrand
        : (emphasis == TagEmphasis.quiet ? c.textTertiary : c.textSecondary);
    final border = selected ? c.surfaceBrand : c.borderSubtle;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FpSpace.s4,
              vertical: FpSpace.s3,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(FpRadius.sm),
              border: Border.all(color: border, width: FpStroke.hairline),
            ),
            child: Text(
              label,
              style: FpType.labelMd.copyWith(color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}

/// How loud a tag is. See [ActivityTag.emphasis].
enum TagEmphasis { normal, quiet }

/// One choice out of a small closed set, laid out as a row of tags.
///
/// Used for the four tri-state groups in More Filters (Show / Hide / Only) and
/// for the per-facet Any / All match mode.
class ChoiceTags<T> extends StatelessWidget {
  const ChoiceTags({
    required this.options,
    required this.labels,
    required this.value,
    required this.onChanged,
    this.emphasis = TagEmphasis.normal,
    super.key,
  });

  final List<T> options;
  final String Function(T) labels;
  final T value;
  final ValueChanged<T> onChanged;
  final TagEmphasis emphasis;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: FpSpace.s2,
      runSpacing: FpSpace.s2,
      children: <Widget>[
        for (final option in options)
          ActivityTag(
            label: labels(option),
            selected: option == value,
            emphasis: emphasis,
            onTap: () => onChanged(option),
          ),
      ],
    );
  }
}

/// Two or three views of the same list: All / Unassigned, Feed / Stats.
///
/// A rule under the selected label rather than a filled pill. The pill version
/// of this control is the single most generic thing in a mobile UI kit, and the
/// rule is the editorial move — it reads as a tab in a printed contents page.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    required this.options,
    required this.labels,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<T> options;
  final String Function(T) labels;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Row(
      children: <Widget>[
        for (final option in options) ...<Widget>[
          Semantics(
            button: true,
            selected: option == value,
            label: labels(option),
            child: ExcludeSemantics(
              child: GestureDetector(
                onTap: () => onChanged(option),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: ActivityMetrics.touchTarget,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: FpSpace.s1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        labels(option).toUpperCase(),
                        style: FpType.labelSm.copyWith(
                          color: option == value
                              ? c.textBrand
                              : c.textTertiary,
                        ),
                      ),
                      const SizedBox(height: ActivityMetrics.segmentRuleGap),
                      Container(
                        height: FpStroke.thick,
                        width: FpSpace.s7,
                        color: option == value
                            ? c.textBrand
                            : c.surfaceCanvas,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: FpSpace.s5),
        ],
      ],
    );
  }
}

/// An on/off control, squared off.
///
/// See [ActivityMetrics.switchTrackWidth] for why it is not a stadium.
class SquareSwitch extends StatelessWidget {
  const SquareSwitch({
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final track = !enabled
        ? c.borderSubtle
        : (value ? c.actionPrimaryBg : c.borderStrong);

    return Semantics(
      toggled: value,
      enabled: enabled,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: enabled ? () => onChanged(!value) : null,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: ActivityMetrics.touchTarget,
            width: ActivityMetrics.switchTrackWidth,
            child: Center(
              child: AnimatedContainer(
                duration: FpDuration.fast,
                curve: FpEasing.standard,
                width: ActivityMetrics.switchTrackWidth,
                height: ActivityMetrics.switchTrackHeight,
                padding: const EdgeInsets.all(ActivityMetrics.switchInset),
                alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: track,
                  borderRadius: BorderRadius.circular(FpRadius.sm),
                ),
                // Disabled hollows the knob out instead of only greying the
                // track. A `GestureDetector` has no ripple to withhold and the
                // track's colour change is colour alone, which is not a signal
                // (Components § Disabled states) — filled-to-outlined is the
                // same regular/fill distinction the icon set is chosen for,
                // applied to a shape rather than a glyph.
                child: Container(
                  width: ActivityMetrics.switchKnob,
                  height: ActivityMetrics.switchKnob,
                  decoration: BoxDecoration(
                    color: enabled ? c.surfaceRaised : null,
                    borderRadius: BorderRadius.circular(FpRadius.sm),
                    border: enabled
                        ? null
                        : Border.all(
                            color: c.surfaceRaised,
                            width: FpStroke.hairline,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// How loud a button is.
enum ButtonTone {
  /// The one thing the screen wants you to do.
  primary,

  /// A real alternative, not a cancel.
  secondary,

  /// A quiet action that sits inside other content.
  ghost,

  /// Destructive, and it says so.
  danger,
}

/// A button.
///
/// Rectangular at `FpRadius.md`, full-width by default, label-lg.
///
/// Disabled takes the tone's `bgDisabled`/`fgDisabled` pair, which the token
/// layer measures against each other at 6.43:1 in both schemes. It is not an
/// opacity over the enabled fill: that composites fill and label toward the
/// canvas together, so the label loses contrast against its own fill rather
/// than the button going quiet. A disabled control still has to be readable.
class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.label,
    required this.onPressed,
    this.tone = ButtonTone.primary,
    this.icon,
    this.expand = true,
    super.key,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;

  final ButtonTone tone;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final enabled = onPressed != null;

    // Disabled drops the tone's colour entirely and becomes an inert neutral.
    // The border collapses into the fill so the button keeps its geometry
    // without a ring the fill no longer justifies. `ghost` has no ramp of its
    // own and takes `tertiary`, which is what it draws from when enabled.
    final (Color background, Color foreground, Color border) = enabled
        ? switch (tone) {
            ButtonTone.primary => (
                c.actionPrimaryBg,
                c.actionPrimaryFg,
                c.actionPrimaryBg,
              ),
            ButtonTone.secondary => (
                c.actionSecondaryBg,
                c.actionSecondaryFg,
                c.borderDefault,
              ),
            ButtonTone.ghost => (
                c.surfaceCanvas,
                c.textSecondary,
                c.borderSubtle,
              ),
            ButtonTone.danger => (
                c.actionDangerBg,
                c.actionDangerFg,
                c.actionDangerBg,
              ),
          }
        : switch (tone) {
            ButtonTone.primary => (
                c.actionPrimaryBgDisabled,
                c.actionPrimaryFgDisabled,
                c.actionPrimaryBgDisabled,
              ),
            ButtonTone.secondary => (
                c.actionSecondaryBgDisabled,
                c.actionSecondaryFgDisabled,
                c.actionSecondaryBgDisabled,
              ),
            ButtonTone.ghost => (
                c.actionTertiaryBgDisabled,
                c.actionTertiaryFgDisabled,
                c.actionTertiaryBgDisabled,
              ),
            ButtonTone.danger => (
                c.actionDangerBgDisabled,
                c.actionDangerFgDisabled,
                c.actionDangerBgDisabled,
              ),
          };

    final glyph = icon;

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (glyph != null) ...<Widget>[
          PhosphorIcon(glyph, size: FpIconSize.md, color: foreground),
          const SizedBox(width: FpSpace.s3),
        ],
        Flexible(
          child: Text(
            label,
            style: FpType.labelLg.copyWith(color: foreground),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: ExcludeSemantics(
        // `Material` + `InkWell`, not a `GestureDetector`, so that a null
        // `onPressed` withholds a ripple that would otherwise be there. That
        // is the non-colour signal this button carries when it is disabled,
        // and it is the only one it can carry — `text.disabled` and the
        // `bgDisabled` fills are colour, and colour alone fails WCAG 1.4.1
        // (Components § Disabled states). `LogActionButton` and
        // `HardwareActionButton` are both built this way; this one was the
        // odd one out and had no structural signal at all.
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(FpRadius.md),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(FpRadius.md),
            child: Container(
              height: FpSpace.s10,
              padding: const EdgeInsets.symmetric(horizontal: FpSpace.s5),
              decoration: BoxDecoration(
                // No fill here: the fill is the `Material`'s, so the ink lands
                // on top of it rather than under an opaque box.
                borderRadius: BorderRadius.circular(FpRadius.md),
                border: Border.all(color: border, width: FpStroke.hairline),
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// A number and what it counts: the shape of every figure in the `DASHBOARD`
/// and `DASHBOARD_PUSHER` headers.
///
/// The number is Fraunces at display-sm and tabular; the caption is label-sm in
/// tertiary. Both figures in a header must therefore be the same height however
/// many digits they carry, which is what tabular is for.
class StatFigure extends StatelessWidget {
  const StatFigure({
    required this.value,
    required this.caption,
    this.onTap,
    super.key,
  });

  final String value;
  final String caption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final figure = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: FpType.displaySm.copyWith(color: c.textPrimary).tabular,
        ),
        const SizedBox(height: FpSpace.s1),
        Text(
          caption.toUpperCase(),
          style: FpType.labelSm.copyWith(color: c.textTertiary),
        ),
      ],
    );

    return Semantics(
      label: '$value $caption',
      child: ExcludeSemantics(
        child: onTap == null
            ? figure
            : GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: figure,
              ),
      ),
    );
  }
}

/// The dot that says "this has something set".
///
/// Count-free by design, the same argument as the tab bar's attention dot: it
/// says "go look", not "you have 3".
class ActiveDot extends StatelessWidget {
  const ActiveDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ActivityMetrics.activeDot,
      height: ActivityMetrics.activeDot,
      decoration: BoxDecoration(
        color: context.fpColors.accentBg,
        shape: BoxShape.circle,
      ),
    );
  }
}

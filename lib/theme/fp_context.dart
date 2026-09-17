import 'package:flutter/material.dart';

import 'generated/fp_tokens.dart';

/// Terse access to the design tokens from a [BuildContext].
///
/// Screen code reads:
///
/// ```dart
/// Container(
///   padding: EdgeInsets.all(context.fpSpace.s5),
///   decoration: BoxDecoration(
///     color: context.fpColors.surfaceRaised,
///     borderRadius: BorderRadius.circular(FpRadius.lg),
///     boxShadow: context.fpElevation.e1,
///   ),
///   child: Text('outside', style: context.fpType.displayMd
///       .copyWith(color: context.fpColors.textPrimary)),
/// );
/// ```
///
/// [fpColors] and [fpElevation] genuinely depend on the scheme and come out of
/// the theme. The rest are compile-time constants that never vary; the getters
/// exist for symmetry, and `FpSpace.s5` / `FpType.bodyMd` remain available and
/// are the better choice inside a `const` widget.
extension FpContext on BuildContext {
  /// Semantic colour for the current scheme. Never write a hex or a `Colors.*`
  /// constant; the two brand steps in ADR 0002 exist precisely because a
  /// literal cannot be right in both schemes.
  FpColors get fpColors => Theme.of(this).extension<FpColors>()!;

  /// Shadow stacks for the current scheme.
  FpElevation get fpElevation => Theme.of(this).extension<FpElevation>()!;

  /// The fourteen type styles. Colourless — combine with [fpColors].
  FpTypeTokens get fpType => const FpTypeTokens();

  /// The spacing scale, in logical pixels.
  FpSpaceTokens get fpSpace => const FpSpaceTokens();

  /// Corner radii, in logical pixels.
  FpRadiusTokens get fpRadius => const FpRadiusTokens();

  /// Border and divider widths.
  FpStrokeTokens get fpStroke => const FpStrokeTokens();

  /// Icon box sizes.
  FpIconSizeTokens get fpIconSize => const FpIconSizeTokens();

  /// State-layer and disabled opacities.
  FpStateLayerTokens get fpState => const FpStateLayerTokens();

  /// Motion durations.
  FpDurationTokens get fpDuration => const FpDurationTokens();

  /// Easing curves.
  FpEasingTokens get fpEasing => const FpEasingTokens();
}

/// Type conveniences the token layer cannot express.
extension FpTextStyle on TextStyle {
  /// Tabular numerals: digits all take the same advance width.
  ///
  /// The two mono styles already carry this, because the CSS sets
  /// `font-variant-numeric: tabular-nums` on them. The design also applies it
  /// ad hoc to several non-mono runs — the elapsed rail, the device health
  /// percentage, the status-bar clock, the summary counts — where a number
  /// changes while the user is looking at it. That is a per-use decision rather
  /// than a property of the style, so it lives here rather than in the tokens.
  ///
  /// Inter carries a `tnum` feature. Fraunces does not, so this is a no-op on
  /// display type.
  TextStyle get tabular =>
      copyWith(fontFeatures: const <FontFeature>[FontFeature.tabularFigures()]);
}

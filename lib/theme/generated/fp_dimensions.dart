// Originally generated from the design system's token build (tokens/build.mjs).
// That upstream is no longer wired to this repo: this file is now the source of
// truth and is maintained by hand. Background: docs/design-system/adr/.
// No Flutter import: every value here is a plain double in logical pixels.

/// Spacing scale, in logical pixels. Scheme-independent, so a plain const
/// class rather than a ThemeExtension — there is nothing here to lerp.
class FpSpace {
  const FpSpace._();

  static const double s0 = 0.0;
  static const double s1 = 2.0;
  static const double s2 = 4.0;
  static const double s3 = 8.0;
  static const double s4 = 12.0;
  static const double s5 = 16.0;
  static const double s6 = 20.0;
  static const double s7 = 24.0;
  static const double s8 = 32.0;
  static const double s9 = 40.0;
  static const double s10 = 48.0;
  static const double s11 = 64.0;
  static const double s12 = 80.0;
  static const double px = 1.0;
}

/// Instance mirror of [FpSpace], reached as `context`-scoped sugar.
/// Identical values; the statics remain for const contexts.
class FpSpaceTokens {
  const FpSpaceTokens();

  double get s0 => FpSpace.s0;
  double get s1 => FpSpace.s1;
  double get s2 => FpSpace.s2;
  double get s3 => FpSpace.s3;
  double get s4 => FpSpace.s4;
  double get s5 => FpSpace.s5;
  double get s6 => FpSpace.s6;
  double get s7 => FpSpace.s7;
  double get s8 => FpSpace.s8;
  double get s9 => FpSpace.s9;
  double get s10 => FpSpace.s10;
  double get s11 => FpSpace.s11;
  double get s12 => FpSpace.s12;
  double get px => FpSpace.px;
}

/// Corner radii, in logical pixels. `full` is the pill value; pass it to
/// BorderRadius.circular and let the shape clamp it.
class FpRadius {
  const FpRadius._();

  static const double none = 0.0;
  static const double sm = 6.0;
  static const double md = 10.0;
  static const double lg = 14.0;
  static const double xl = 20.0;
  static const double r2xl = 28.0;
  static const double full = 9999.0;
}

/// Instance mirror of [FpRadius], reached as `context`-scoped sugar.
/// Identical values; the statics remain for const contexts.
class FpRadiusTokens {
  const FpRadiusTokens();

  double get none => FpRadius.none;
  double get sm => FpRadius.sm;
  double get md => FpRadius.md;
  double get lg => FpRadius.lg;
  double get xl => FpRadius.xl;
  double get r2xl => FpRadius.r2xl;
  double get full => FpRadius.full;
}

/// Border and divider widths, in logical pixels.
class FpStroke {
  const FpStroke._();

  static const double hairline = 1.0;
  static const double thick = 2.0;
  static const double focus = 3.0;
}

/// Instance mirror of [FpStroke], reached as `context`-scoped sugar.
/// Identical values; the statics remain for const contexts.
class FpStrokeTokens {
  const FpStrokeTokens();

  double get hairline => FpStroke.hairline;
  double get thick => FpStroke.thick;
  double get focus => FpStroke.focus;
}

/// Icon box sizes, in logical pixels. Phosphor is the one icon set; weight
/// carries selected state, not a second mechanism.
class FpIconSize {
  const FpIconSize._();

  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// Instance mirror of [FpIconSize], reached as `context`-scoped sugar.
/// Identical values; the statics remain for const contexts.
class FpIconSizeTokens {
  const FpIconSizeTokens();

  double get sm => FpIconSize.sm;
  double get md => FpIconSize.md;
  double get lg => FpIconSize.lg;
  double get xl => FpIconSize.xl;
}

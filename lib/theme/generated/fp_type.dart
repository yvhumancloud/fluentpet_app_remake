// Originally generated from the design system's token build (tokens/build.mjs).
// That upstream is no longer wired to this repo: this file is now the source of
// truth and is maintained by hand. Background: docs/design-system/adr/.
// FontFeature comes from dart:ui via package:flutter/painting.dart, which
// material.dart re-exports; importing dart:ui directly trips unnecessary_import.
import 'package:flutter/material.dart';

/// The fourteen type styles, as real [TextStyle]s.
///
/// `height` is the token's leading divided by its size, because Flutter's is
/// unitless. `letterSpacing` is the token's em tracking multiplied by the size,
/// because Flutter's is in logical pixels. Mono styles carry
/// [FontFeature.tabularFigures] so numerals do not change width — several
/// component specs depend on it to stop headers twitching as values update.
///
/// These carry no colour. Colour comes from [FpColors]; combine with
/// `FpType.bodyMd.copyWith(color: context.fpColors.textSecondary)`.
class FpType {
  const FpType._();

  /// `type.display-lg` — Fraunces 36/40, w600, -0.02em.
  static const TextStyle displayLg = TextStyle(
    fontFamily: 'Fraunces',
    fontFamilyFallback: <String>['Georgia'],
    fontSize: 36.0,
    height: 1.1111111111111112,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.72,
  );

  /// `type.display-md` — Fraunces 30/36, w600, -0.02em.
  static const TextStyle displayMd = TextStyle(
    fontFamily: 'Fraunces',
    fontFamilyFallback: <String>['Georgia'],
    fontSize: 30.0,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.6,
  );

  /// `type.display-sm` — Fraunces 24/30, w600, -0.02em.
  static const TextStyle displaySm = TextStyle(
    fontFamily: 'Fraunces',
    fontFamilyFallback: <String>['Georgia'],
    fontSize: 24.0,
    height: 1.25,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.48,
  );

  /// `type.heading-lg` — Fraunces 22/28, w600, 0em.
  static const TextStyle headingLg = TextStyle(
    fontFamily: 'Fraunces',
    fontFamilyFallback: <String>['Georgia'],
    fontSize: 22.0,
    height: 1.2727272727272727,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
  );

  /// `type.heading-md` — Inter 18/24, w600, 0em.
  static const TextStyle headingMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18.0,
    height: 1.3333333333333333,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
  );

  /// `type.heading-sm` — Inter 16/22, w600, 0em.
  static const TextStyle headingSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.0,
    height: 1.375,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
  );

  /// `type.body-lg` — Inter 17/26, w400, 0em.
  static const TextStyle bodyLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 17.0,
    height: 1.5294117647058822,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
  );

  /// `type.body-md` — Inter 15/22, w400, 0em.
  static const TextStyle bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15.0,
    height: 1.4666666666666666,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
  );

  /// `type.body-sm` — Inter 13/18, w400, 0em.
  static const TextStyle bodySm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13.0,
    height: 1.3846153846153846,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
  );

  /// `type.label-lg` — Inter 15/20, w500, 0em.
  static const TextStyle labelLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15.0,
    height: 1.3333333333333333,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.0,
  );

  /// `type.label-md` — Inter 13/16, w500, 0em.
  static const TextStyle labelMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13.0,
    height: 1.2307692307692308,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.0,
  );

  /// `type.label-sm` — Inter 11/14, w600, 0.04em.
  static const TextStyle labelSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11.0,
    height: 1.2727272727272727,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.44,
  );

  /// `type.mono-md` — JetBrains Mono 14/20, w400, 0em, tabular figures.
  static const TextStyle monoMd = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 14.0,
    height: 1.4285714285714286,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );

  /// `type.mono-sm` — JetBrains Mono 12/16, w400, 0em, tabular figures.
  static const TextStyle monoSm = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 12.0,
    height: 1.3333333333333333,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );
}

/// Instance mirror of [FpType], reached as `context`-scoped sugar.
/// Identical values; the statics remain for const contexts.
class FpTypeTokens {
  const FpTypeTokens();

  TextStyle get displayLg => FpType.displayLg;
  TextStyle get displayMd => FpType.displayMd;
  TextStyle get displaySm => FpType.displaySm;
  TextStyle get headingLg => FpType.headingLg;
  TextStyle get headingMd => FpType.headingMd;
  TextStyle get headingSm => FpType.headingSm;
  TextStyle get bodyLg => FpType.bodyLg;
  TextStyle get bodyMd => FpType.bodyMd;
  TextStyle get bodySm => FpType.bodySm;
  TextStyle get labelLg => FpType.labelLg;
  TextStyle get labelMd => FpType.labelMd;
  TextStyle get labelSm => FpType.labelSm;
  TextStyle get monoMd => FpType.monoMd;
  TextStyle get monoSm => FpType.monoSm;
}

/// Font families as declared in `pubspec.yaml`. Prefer a style from [FpType];
/// this exists for the rare place that needs the family name itself.
class FpFontFamily {
  const FpFontFamily._();

  static const String display = 'Fraunces';
  static const List<String> displayFallback = <String>['Georgia'];
  static const String body = 'Inter';
  static const String mono = 'JetBrains Mono';
}

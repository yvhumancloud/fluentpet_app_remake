// Originally generated from the design system's token build (tokens/build.mjs).
// That upstream is no longer wired to this repo: this file is now the source of
// truth and is maintained by hand. Background: docs/design-system/adr/.
import 'package:flutter/material.dart';

/// Semantic colour, resolved per scheme.
///
/// Read it with `Theme.of(context).extension<FpColors>()!`, or the terser
/// `context.fpColors`. No colour in app code is ever a hex literal or a
/// `Colors.*` constant: the two brand steps (teal.700 light, teal.400 dark)
/// are deliberate and only the semantic layer knows which applies.
@immutable
class FpColors extends ThemeExtension<FpColors> {
  const FpColors({
    required this.surfaceCanvas,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.surfaceInverse,
    required this.surfaceBrand,
    required this.surfaceTint,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.textInverse,
    required this.textBrand,
    required this.textOnBrand,
    required this.textOnAccent,
    required this.borderSubtle,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderFocus,
    required this.actionPrimaryBg,
    required this.actionPrimaryBgHover,
    required this.actionPrimaryBgPressed,
    required this.actionPrimaryBgDisabled,
    required this.actionPrimaryFg,
    required this.actionPrimaryFgDisabled,
    required this.actionSecondaryBg,
    required this.actionSecondaryBgHover,
    required this.actionSecondaryBgPressed,
    required this.actionSecondaryBgDisabled,
    required this.actionSecondaryFg,
    required this.actionSecondaryFgDisabled,
    required this.actionTertiaryBg,
    required this.actionTertiaryBgHover,
    required this.actionTertiaryBgPressed,
    required this.actionTertiaryBgDisabled,
    required this.actionTertiaryFg,
    required this.actionTertiaryFgDisabled,
    required this.actionDangerBg,
    required this.actionDangerBgHover,
    required this.actionDangerBgPressed,
    required this.actionDangerBgDisabled,
    required this.actionDangerFg,
    required this.actionDangerFgDisabled,
    required this.accentBg,
    required this.accentSubtle,
    required this.accentFg,
    required this.accentBorder,
    required this.statusSuccessBg,
    required this.statusSuccessFg,
    required this.statusSuccessBorder,
    required this.statusSuccessSolid,
    required this.statusWarningBg,
    required this.statusWarningFg,
    required this.statusWarningBorder,
    required this.statusWarningSolid,
    required this.statusDangerBg,
    required this.statusDangerFg,
    required this.statusDangerBorder,
    required this.statusDangerSolid,
    required this.statusInfoBg,
    required this.statusInfoFg,
    required this.statusInfoBorder,
    required this.statusInfoSolid,
  });

  final Color surfaceCanvas;
  final Color surfaceRaised;
  final Color surfaceSunken;
  final Color surfaceInverse;
  final Color surfaceBrand;
  final Color surfaceTint;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color textInverse;
  final Color textBrand;
  final Color textOnBrand;
  final Color textOnAccent;
  final Color borderSubtle;
  final Color borderDefault;
  final Color borderStrong;
  final Color borderFocus;
  final Color actionPrimaryBg;
  final Color actionPrimaryBgHover;
  final Color actionPrimaryBgPressed;
  final Color actionPrimaryBgDisabled;
  final Color actionPrimaryFg;
  final Color actionPrimaryFgDisabled;
  final Color actionSecondaryBg;
  final Color actionSecondaryBgHover;
  final Color actionSecondaryBgPressed;
  final Color actionSecondaryBgDisabled;
  final Color actionSecondaryFg;
  final Color actionSecondaryFgDisabled;
  final Color actionTertiaryBg;
  final Color actionTertiaryBgHover;
  final Color actionTertiaryBgPressed;
  final Color actionTertiaryBgDisabled;
  final Color actionTertiaryFg;
  final Color actionTertiaryFgDisabled;
  final Color actionDangerBg;
  final Color actionDangerBgHover;
  final Color actionDangerBgPressed;
  final Color actionDangerBgDisabled;
  final Color actionDangerFg;
  final Color actionDangerFgDisabled;
  final Color accentBg;
  final Color accentSubtle;
  final Color accentFg;
  final Color accentBorder;
  final Color statusSuccessBg;
  final Color statusSuccessFg;
  final Color statusSuccessBorder;
  final Color statusSuccessSolid;
  final Color statusWarningBg;
  final Color statusWarningFg;
  final Color statusWarningBorder;
  final Color statusWarningSolid;
  final Color statusDangerBg;
  final Color statusDangerFg;
  final Color statusDangerBorder;
  final Color statusDangerSolid;
  final Color statusInfoBg;
  final Color statusInfoFg;
  final Color statusInfoBorder;
  final Color statusInfoSolid;

  static const FpColors light = FpColors(
    surfaceCanvas: Color(0xFFFAF9F7),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceSunken: Color(0xFFF4F2EF),
    surfaceInverse: Color(0xFF1C1A17),
    surfaceBrand: Color(0xFF006271),
    surfaceTint: Color(0xFFEFFAFB),
    textPrimary: Color(0xFF1C1A17),
    textSecondary: Color(0xFF5C5750),
    textTertiary: Color(0xFF746E65),
    textDisabled: Color(0xFF746E65),
    textInverse: Color(0xFFFAF9F7),
    textBrand: Color(0xFF006271),
    textOnBrand: Color(0xFFFFFFFF),
    textOnAccent: Color(0xFF331E06),
    borderSubtle: Color(0xFFE7E4DF),
    borderDefault: Color(0xFFD3CFC8),
    borderStrong: Color(0xFFA8A29A),
    borderFocus: Color(0xFF0097B0),
    actionPrimaryBg: Color(0xFF006271),
    actionPrimaryBgHover: Color(0xFF044E5A),
    actionPrimaryBgPressed: Color(0xFF08404A),
    actionPrimaryBgDisabled: Color(0xFFD3CFC8),
    actionPrimaryFg: Color(0xFFFFFFFF),
    actionPrimaryFgDisabled: Color(0xFF46423C),
    actionSecondaryBg: Color(0xFFEFFAFB),
    actionSecondaryBgHover: Color(0xFFD6F1F5),
    actionSecondaryBgPressed: Color(0xFFADE3EB),
    actionSecondaryBgDisabled: Color(0xFFD3CFC8),
    actionSecondaryFg: Color(0xFF044E5A),
    actionSecondaryFgDisabled: Color(0xFF46423C),
    actionTertiaryBg: Color(0xFFFFFFFF),
    actionTertiaryBgHover: Color(0xFFF4F2EF),
    actionTertiaryBgPressed: Color(0xFFE7E4DF),
    actionTertiaryBgDisabled: Color(0xFFD3CFC8),
    actionTertiaryFg: Color(0xFF2E2B27),
    actionTertiaryFgDisabled: Color(0xFF46423C),
    actionDangerBg: Color(0xFFC01527),
    actionDangerBgHover: Color(0xFF7A0D18),
    actionDangerBgPressed: Color(0xFF7A0D18),
    actionDangerBgDisabled: Color(0xFFD3CFC8),
    actionDangerFg: Color(0xFFFFFFFF),
    actionDangerFgDisabled: Color(0xFF46423C),
    accentBg: Color(0xFFFFB046),
    accentSubtle: Color(0xFFFFE6BA),
    accentFg: Color(0xFF855610),
    accentBorder: Color(0xFFF6A925),
    statusSuccessBg: Color(0xFFD7F2E5),
    statusSuccessFg: Color(0xFF146344),
    statusSuccessBorder: Color(0xFF6DCCA3),
    statusSuccessSolid: Color(0xFF30AE78),
    statusWarningBg: Color(0xFFFFE6BA),
    statusWarningFg: Color(0xFF855610),
    statusWarningBorder: Color(0xFFFFB046),
    statusWarningSolid: Color(0xFFF6A925),
    statusDangerBg: Color(0xFFFFE0E3),
    statusDangerFg: Color(0xFFC01527),
    statusDangerBorder: Color(0xFFFF8A96),
    statusDangerSolid: Color(0xFFF0374B),
    statusInfoBg: Color(0xFFD9EFF8),
    statusInfoFg: Color(0xFF046488),
    statusInfoBorder: Color(0xFF6DC1E0),
    statusInfoSolid: Color(0xFF0090C1),
  );

  static const FpColors dark = FpColors(
    surfaceCanvas: Color(0xFF100F0D),
    surfaceRaised: Color(0xFF1C1A17),
    surfaceSunken: Color(0xFF000000),
    surfaceInverse: Color(0xFFFAF9F7),
    surfaceBrand: Color(0xFF00B4D0),
    surfaceTint: Color(0xFF032A31),
    textPrimary: Color(0xFFFAF9F7),
    textSecondary: Color(0xFFD3CFC8),
    textTertiary: Color(0xFFA8A29A),
    textDisabled: Color(0xFFA8A29A),
    textInverse: Color(0xFF1C1A17),
    textBrand: Color(0xFF00B4D0),
    textOnBrand: Color(0xFF032A31),
    textOnAccent: Color(0xFF331E06),
    borderSubtle: Color(0xFF2E2B27),
    borderDefault: Color(0xFF46423C),
    borderStrong: Color(0xFF5C5750),
    borderFocus: Color(0xFF00B4D0),
    actionPrimaryBg: Color(0xFF00B4D0),
    actionPrimaryBgHover: Color(0xFF6AD1E3),
    actionPrimaryBgPressed: Color(0xFFADE3EB),
    actionPrimaryBgDisabled: Color(0xFF46423C),
    actionPrimaryFg: Color(0xFF032A31),
    actionPrimaryFgDisabled: Color(0xFFD3CFC8),
    actionSecondaryBg: Color(0xFF032A31),
    actionSecondaryBgHover: Color(0xFF08404A),
    actionSecondaryBgPressed: Color(0xFF044E5A),
    actionSecondaryBgDisabled: Color(0xFF46423C),
    actionSecondaryFg: Color(0xFFADE3EB),
    actionSecondaryFgDisabled: Color(0xFFD3CFC8),
    actionTertiaryBg: Color(0xFF1C1A17),
    actionTertiaryBgHover: Color(0xFF2E2B27),
    actionTertiaryBgPressed: Color(0xFF46423C),
    actionTertiaryBgDisabled: Color(0xFF46423C),
    actionTertiaryFg: Color(0xFFF4F2EF),
    actionTertiaryFgDisabled: Color(0xFFD3CFC8),
    actionDangerBg: Color(0xFFF0374B),
    actionDangerBgHover: Color(0xFFFF8A96),
    actionDangerBgPressed: Color(0xFFFF8A96),
    actionDangerBgDisabled: Color(0xFF46423C),
    actionDangerFg: Color(0xFF100F0D),
    actionDangerFgDisabled: Color(0xFFD3CFC8),
    accentBg: Color(0xFFFFB046),
    accentSubtle: Color(0xFF331E06),
    accentFg: Color(0xFFFFB046),
    accentBorder: Color(0xFFA67013),
    statusSuccessBg: Color(0xFF0E5539),
    statusSuccessFg: Color(0xFF6DCCA3),
    statusSuccessBorder: Color(0xFF146344),
    statusSuccessSolid: Color(0xFF30AE78),
    statusWarningBg: Color(0xFF331E06),
    statusWarningFg: Color(0xFFFFB046),
    statusWarningBorder: Color(0xFF855610),
    statusWarningSolid: Color(0xFFF6A925),
    statusDangerBg: Color(0xFF7A0D18),
    statusDangerFg: Color(0xFFFF8A96),
    statusDangerBorder: Color(0xFFC01527),
    statusDangerSolid: Color(0xFFF0374B),
    statusInfoBg: Color(0xFF053F55),
    statusInfoFg: Color(0xFF6DC1E0),
    statusInfoBorder: Color(0xFF046488),
    statusInfoSolid: Color(0xFF0090C1),
  );

  @override
  FpColors copyWith({
    Color? surfaceCanvas,
    Color? surfaceRaised,
    Color? surfaceSunken,
    Color? surfaceInverse,
    Color? surfaceBrand,
    Color? surfaceTint,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? textInverse,
    Color? textBrand,
    Color? textOnBrand,
    Color? textOnAccent,
    Color? borderSubtle,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderFocus,
    Color? actionPrimaryBg,
    Color? actionPrimaryBgHover,
    Color? actionPrimaryBgPressed,
    Color? actionPrimaryBgDisabled,
    Color? actionPrimaryFg,
    Color? actionPrimaryFgDisabled,
    Color? actionSecondaryBg,
    Color? actionSecondaryBgHover,
    Color? actionSecondaryBgPressed,
    Color? actionSecondaryBgDisabled,
    Color? actionSecondaryFg,
    Color? actionSecondaryFgDisabled,
    Color? actionTertiaryBg,
    Color? actionTertiaryBgHover,
    Color? actionTertiaryBgPressed,
    Color? actionTertiaryBgDisabled,
    Color? actionTertiaryFg,
    Color? actionTertiaryFgDisabled,
    Color? actionDangerBg,
    Color? actionDangerBgHover,
    Color? actionDangerBgPressed,
    Color? actionDangerBgDisabled,
    Color? actionDangerFg,
    Color? actionDangerFgDisabled,
    Color? accentBg,
    Color? accentSubtle,
    Color? accentFg,
    Color? accentBorder,
    Color? statusSuccessBg,
    Color? statusSuccessFg,
    Color? statusSuccessBorder,
    Color? statusSuccessSolid,
    Color? statusWarningBg,
    Color? statusWarningFg,
    Color? statusWarningBorder,
    Color? statusWarningSolid,
    Color? statusDangerBg,
    Color? statusDangerFg,
    Color? statusDangerBorder,
    Color? statusDangerSolid,
    Color? statusInfoBg,
    Color? statusInfoFg,
    Color? statusInfoBorder,
    Color? statusInfoSolid,
  }) {
    return FpColors(
      surfaceCanvas: surfaceCanvas ?? this.surfaceCanvas,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      surfaceInverse: surfaceInverse ?? this.surfaceInverse,
      surfaceBrand: surfaceBrand ?? this.surfaceBrand,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      textInverse: textInverse ?? this.textInverse,
      textBrand: textBrand ?? this.textBrand,
      textOnBrand: textOnBrand ?? this.textOnBrand,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderFocus: borderFocus ?? this.borderFocus,
      actionPrimaryBg: actionPrimaryBg ?? this.actionPrimaryBg,
      actionPrimaryBgHover: actionPrimaryBgHover ?? this.actionPrimaryBgHover,
      actionPrimaryBgPressed:
          actionPrimaryBgPressed ?? this.actionPrimaryBgPressed,
      actionPrimaryBgDisabled:
          actionPrimaryBgDisabled ?? this.actionPrimaryBgDisabled,
      actionPrimaryFg: actionPrimaryFg ?? this.actionPrimaryFg,
      actionPrimaryFgDisabled:
          actionPrimaryFgDisabled ?? this.actionPrimaryFgDisabled,
      actionSecondaryBg: actionSecondaryBg ?? this.actionSecondaryBg,
      actionSecondaryBgHover:
          actionSecondaryBgHover ?? this.actionSecondaryBgHover,
      actionSecondaryBgPressed:
          actionSecondaryBgPressed ?? this.actionSecondaryBgPressed,
      actionSecondaryBgDisabled:
          actionSecondaryBgDisabled ?? this.actionSecondaryBgDisabled,
      actionSecondaryFg: actionSecondaryFg ?? this.actionSecondaryFg,
      actionSecondaryFgDisabled:
          actionSecondaryFgDisabled ?? this.actionSecondaryFgDisabled,
      actionTertiaryBg: actionTertiaryBg ?? this.actionTertiaryBg,
      actionTertiaryBgHover:
          actionTertiaryBgHover ?? this.actionTertiaryBgHover,
      actionTertiaryBgPressed:
          actionTertiaryBgPressed ?? this.actionTertiaryBgPressed,
      actionTertiaryBgDisabled:
          actionTertiaryBgDisabled ?? this.actionTertiaryBgDisabled,
      actionTertiaryFg: actionTertiaryFg ?? this.actionTertiaryFg,
      actionTertiaryFgDisabled:
          actionTertiaryFgDisabled ?? this.actionTertiaryFgDisabled,
      actionDangerBg: actionDangerBg ?? this.actionDangerBg,
      actionDangerBgHover: actionDangerBgHover ?? this.actionDangerBgHover,
      actionDangerBgPressed:
          actionDangerBgPressed ?? this.actionDangerBgPressed,
      actionDangerBgDisabled:
          actionDangerBgDisabled ?? this.actionDangerBgDisabled,
      actionDangerFg: actionDangerFg ?? this.actionDangerFg,
      actionDangerFgDisabled:
          actionDangerFgDisabled ?? this.actionDangerFgDisabled,
      accentBg: accentBg ?? this.accentBg,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      accentFg: accentFg ?? this.accentFg,
      accentBorder: accentBorder ?? this.accentBorder,
      statusSuccessBg: statusSuccessBg ?? this.statusSuccessBg,
      statusSuccessFg: statusSuccessFg ?? this.statusSuccessFg,
      statusSuccessBorder: statusSuccessBorder ?? this.statusSuccessBorder,
      statusSuccessSolid: statusSuccessSolid ?? this.statusSuccessSolid,
      statusWarningBg: statusWarningBg ?? this.statusWarningBg,
      statusWarningFg: statusWarningFg ?? this.statusWarningFg,
      statusWarningBorder: statusWarningBorder ?? this.statusWarningBorder,
      statusWarningSolid: statusWarningSolid ?? this.statusWarningSolid,
      statusDangerBg: statusDangerBg ?? this.statusDangerBg,
      statusDangerFg: statusDangerFg ?? this.statusDangerFg,
      statusDangerBorder: statusDangerBorder ?? this.statusDangerBorder,
      statusDangerSolid: statusDangerSolid ?? this.statusDangerSolid,
      statusInfoBg: statusInfoBg ?? this.statusInfoBg,
      statusInfoFg: statusInfoFg ?? this.statusInfoFg,
      statusInfoBorder: statusInfoBorder ?? this.statusInfoBorder,
      statusInfoSolid: statusInfoSolid ?? this.statusInfoSolid,
    );
  }

  @override
  FpColors lerp(ThemeExtension<FpColors>? other, double t) {
    if (other is! FpColors) return this;
    return FpColors(
      surfaceCanvas: Color.lerp(surfaceCanvas, other.surfaceCanvas, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      surfaceInverse: Color.lerp(surfaceInverse, other.surfaceInverse, t)!,
      surfaceBrand: Color.lerp(surfaceBrand, other.surfaceBrand, t)!,
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textBrand: Color.lerp(textBrand, other.textBrand, t)!,
      textOnBrand: Color.lerp(textOnBrand, other.textOnBrand, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      actionPrimaryBg: Color.lerp(actionPrimaryBg, other.actionPrimaryBg, t)!,
      actionPrimaryBgHover: Color.lerp(
        actionPrimaryBgHover,
        other.actionPrimaryBgHover,
        t,
      )!,
      actionPrimaryBgPressed: Color.lerp(
        actionPrimaryBgPressed,
        other.actionPrimaryBgPressed,
        t,
      )!,
      actionPrimaryBgDisabled: Color.lerp(
        actionPrimaryBgDisabled,
        other.actionPrimaryBgDisabled,
        t,
      )!,
      actionPrimaryFg: Color.lerp(actionPrimaryFg, other.actionPrimaryFg, t)!,
      actionPrimaryFgDisabled: Color.lerp(
        actionPrimaryFgDisabled,
        other.actionPrimaryFgDisabled,
        t,
      )!,
      actionSecondaryBg: Color.lerp(
        actionSecondaryBg,
        other.actionSecondaryBg,
        t,
      )!,
      actionSecondaryBgHover: Color.lerp(
        actionSecondaryBgHover,
        other.actionSecondaryBgHover,
        t,
      )!,
      actionSecondaryBgPressed: Color.lerp(
        actionSecondaryBgPressed,
        other.actionSecondaryBgPressed,
        t,
      )!,
      actionSecondaryBgDisabled: Color.lerp(
        actionSecondaryBgDisabled,
        other.actionSecondaryBgDisabled,
        t,
      )!,
      actionSecondaryFg: Color.lerp(
        actionSecondaryFg,
        other.actionSecondaryFg,
        t,
      )!,
      actionSecondaryFgDisabled: Color.lerp(
        actionSecondaryFgDisabled,
        other.actionSecondaryFgDisabled,
        t,
      )!,
      actionTertiaryBg: Color.lerp(
        actionTertiaryBg,
        other.actionTertiaryBg,
        t,
      )!,
      actionTertiaryBgHover: Color.lerp(
        actionTertiaryBgHover,
        other.actionTertiaryBgHover,
        t,
      )!,
      actionTertiaryBgPressed: Color.lerp(
        actionTertiaryBgPressed,
        other.actionTertiaryBgPressed,
        t,
      )!,
      actionTertiaryBgDisabled: Color.lerp(
        actionTertiaryBgDisabled,
        other.actionTertiaryBgDisabled,
        t,
      )!,
      actionTertiaryFg: Color.lerp(
        actionTertiaryFg,
        other.actionTertiaryFg,
        t,
      )!,
      actionTertiaryFgDisabled: Color.lerp(
        actionTertiaryFgDisabled,
        other.actionTertiaryFgDisabled,
        t,
      )!,
      actionDangerBg: Color.lerp(actionDangerBg, other.actionDangerBg, t)!,
      actionDangerBgHover: Color.lerp(
        actionDangerBgHover,
        other.actionDangerBgHover,
        t,
      )!,
      actionDangerBgPressed: Color.lerp(
        actionDangerBgPressed,
        other.actionDangerBgPressed,
        t,
      )!,
      actionDangerBgDisabled: Color.lerp(
        actionDangerBgDisabled,
        other.actionDangerBgDisabled,
        t,
      )!,
      actionDangerFg: Color.lerp(actionDangerFg, other.actionDangerFg, t)!,
      actionDangerFgDisabled: Color.lerp(
        actionDangerFgDisabled,
        other.actionDangerFgDisabled,
        t,
      )!,
      accentBg: Color.lerp(accentBg, other.accentBg, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      accentFg: Color.lerp(accentFg, other.accentFg, t)!,
      accentBorder: Color.lerp(accentBorder, other.accentBorder, t)!,
      statusSuccessBg: Color.lerp(statusSuccessBg, other.statusSuccessBg, t)!,
      statusSuccessFg: Color.lerp(statusSuccessFg, other.statusSuccessFg, t)!,
      statusSuccessBorder: Color.lerp(
        statusSuccessBorder,
        other.statusSuccessBorder,
        t,
      )!,
      statusSuccessSolid: Color.lerp(
        statusSuccessSolid,
        other.statusSuccessSolid,
        t,
      )!,
      statusWarningBg: Color.lerp(statusWarningBg, other.statusWarningBg, t)!,
      statusWarningFg: Color.lerp(statusWarningFg, other.statusWarningFg, t)!,
      statusWarningBorder: Color.lerp(
        statusWarningBorder,
        other.statusWarningBorder,
        t,
      )!,
      statusWarningSolid: Color.lerp(
        statusWarningSolid,
        other.statusWarningSolid,
        t,
      )!,
      statusDangerBg: Color.lerp(statusDangerBg, other.statusDangerBg, t)!,
      statusDangerFg: Color.lerp(statusDangerFg, other.statusDangerFg, t)!,
      statusDangerBorder: Color.lerp(
        statusDangerBorder,
        other.statusDangerBorder,
        t,
      )!,
      statusDangerSolid: Color.lerp(
        statusDangerSolid,
        other.statusDangerSolid,
        t,
      )!,
      statusInfoBg: Color.lerp(statusInfoBg, other.statusInfoBg, t)!,
      statusInfoFg: Color.lerp(statusInfoFg, other.statusInfoFg, t)!,
      statusInfoBorder: Color.lerp(
        statusInfoBorder,
        other.statusInfoBorder,
        t,
      )!,
      statusInfoSolid: Color.lerp(statusInfoSolid, other.statusInfoSolid, t)!,
    );
  }
}

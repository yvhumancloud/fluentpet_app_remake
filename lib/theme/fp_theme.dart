import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'generated/fp_tokens.dart';

/// The two ThemeData the app runs on.
///
/// Everything visual is derived from the token classes in `generated/`. Nothing
/// here invents a colour, a size or a font — if a value is missing, add it to
/// the token class, which is now hand-maintained rather than built upstream.
///
/// Both schemes register [FpColors] and [FpElevation] as theme extensions.
/// Read them with `context.fpColors` / `context.fpElevation`
/// (see `fp_context.dart`), never by rebuilding a palette locally.
///
/// The brand colour is deliberately a different hex in each scheme —
/// `teal.700` in light, `teal.400` in dark. See ADR 0002: no single value
/// clears 4.5:1 against both a near-white and a near-black canvas. It is not a
/// bug and it is not to be unified.
abstract final class FpTheme {
  static ThemeData get light => _build(Brightness.light, FpColors.light, FpElevation.light);
  static ThemeData get dark => _build(Brightness.dark, FpColors.dark, FpElevation.dark);

  static ThemeData _build(Brightness brightness, FpColors c, FpElevation e) {
    final textTheme = _textTheme(c);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: <ThemeExtension<dynamic>>[c, e],
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.actionPrimaryBg,
        onPrimary: c.actionPrimaryFg,
        primaryContainer: c.actionSecondaryBg,
        onPrimaryContainer: c.actionSecondaryFg,
        secondary: c.accentBg,
        onSecondary: c.textOnAccent,
        secondaryContainer: c.accentSubtle,
        onSecondaryContainer: c.accentFg,
        error: c.statusDangerSolid,
        onError: c.textOnBrand,
        errorContainer: c.statusDangerBg,
        onErrorContainer: c.statusDangerFg,
        surface: c.surfaceRaised,
        onSurface: c.textPrimary,
        surfaceContainerLowest: c.surfaceSunken,
        surfaceContainerHighest: c.surfaceSunken,
        onSurfaceVariant: c.textSecondary,
        outline: c.borderDefault,
        outlineVariant: c.borderSubtle,
        inverseSurface: c.surfaceInverse,
        onInverseSurface: c.textInverse,
        shadow: c.textPrimary,
        scrim: c.textPrimary,
      ),
      scaffoldBackgroundColor: c.surfaceCanvas,
      canvasColor: c.surfaceCanvas,
      dividerColor: c.borderSubtle,
      // Fraunces is the display face and Inter is everything else; there is no
      // single app-wide family, so this points at the UI face and the type
      // styles override it wherever display type is wanted.
      fontFamily: FpFontFamily.body,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(color: c.textPrimary, size: FpIconSize.lg),
      primaryIconTheme: IconThemeData(color: c.textPrimary, size: FpIconSize.lg),
      dividerTheme: DividerThemeData(
        color: c.borderSubtle,
        thickness: FpStroke.hairline,
        space: FpStroke.hairline,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.surfaceCanvas,
        foregroundColor: c.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: FpType.labelSm.copyWith(color: c.textSecondary),
        iconTheme: IconThemeData(color: c.textPrimary, size: FpIconSize.lg),
      ),
      cardTheme: CardThemeData(
        color: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FpRadius.lg),
          side: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: c.textSecondary,
        textColor: c.textPrimary,
        titleTextStyle: FpType.bodyMd.copyWith(color: c.textPrimary),
        subtitleTextStyle: FpType.bodySm.copyWith(color: c.textSecondary),
      ),
      // Sheets and dialogs take their colours from here, never from the
      // `showModalBottomSheet`/`showDialog` call. Those arguments are read
      // once, at push time, and baked into the route: a scheme change while a
      // sheet is open then repaints its contents and leaves its background on
      // the old scheme, which puts near-black labels on a near-black panel.
      // A ThemeData is rebuilt on the change, so resolving through it is live.
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceRaised,
        modalBackgroundColor: c.surfaceRaised,
        modalBarrierColor:
            c.surfaceInverse.withValues(alpha: FpStateLayer.overlay),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(FpRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        barrierColor: c.surfaceInverse.withValues(alpha: FpStateLayer.overlay),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FpRadius.xl),
        ),
      ),
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Material's fifteen slots, filled from the fourteen token styles.
  ///
  /// The mapping is stated once here so a widget that reaches for
  /// `Theme.of(context).textTheme.titleMedium` lands on the same thing a widget
  /// asking for `FpType.headingMd` does. Prefer [FpType] directly: it is const,
  /// and it names the design's scale rather than Material's.
  static TextTheme _textTheme(FpColors c) {
    TextStyle on(TextStyle s, Color colour) => s.copyWith(color: colour);
    return TextTheme(
      displayLarge: on(FpType.displayLg, c.textPrimary),
      displayMedium: on(FpType.displayMd, c.textPrimary),
      displaySmall: on(FpType.displaySm, c.textPrimary),
      headlineLarge: on(FpType.headingLg, c.textPrimary),
      headlineMedium: on(FpType.headingMd, c.textPrimary),
      headlineSmall: on(FpType.headingSm, c.textPrimary),
      titleLarge: on(FpType.headingLg, c.textPrimary),
      titleMedium: on(FpType.headingMd, c.textPrimary),
      titleSmall: on(FpType.headingSm, c.textPrimary),
      bodyLarge: on(FpType.bodyLg, c.textPrimary),
      bodyMedium: on(FpType.bodyMd, c.textPrimary),
      bodySmall: on(FpType.bodySm, c.textSecondary),
      labelLarge: on(FpType.labelLg, c.textPrimary),
      labelMedium: on(FpType.labelMd, c.textSecondary),
      labelSmall: on(FpType.labelSm, c.textTertiary),
    );
  }
}

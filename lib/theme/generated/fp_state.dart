// Originally generated from the design system's token build (tokens/build.mjs).
// That upstream is no longer wired to this repo: this file is now the source of
// truth and is maintained by hand. Background: docs/design-system/adr/.

/// State-layer opacities, 0..1, for tinting ONE colour — a scrim, a ripple,
/// a hover wash over a resting fill.
///
/// Never wrap a two-tone control in `Opacity(opacity: FpStateLayer.disabled)`.
/// Fill and label then composite toward the canvas together, so the label
/// loses contrast against its own fill instead of the control going quiet.
/// Disabled buttons take `actionXBgDisabled` / `actionXFgDisabled` from
/// [FpColors], which are specified and measured as a pair.
class FpStateLayer {
  const FpStateLayer._();

  static const double hover = 0.06;
  static const double pressed = 0.12;
  static const double disabled = 0.38;
  static const double overlay = 0.6;
}

/// Instance mirror of [FpStateLayer], reached as `context`-scoped sugar.
/// Identical values; the statics remain for const contexts.
class FpStateLayerTokens {
  const FpStateLayerTokens();

  double get hover => FpStateLayer.hover;
  double get pressed => FpStateLayer.pressed;
  double get disabled => FpStateLayer.disabled;
  double get overlay => FpStateLayer.overlay;
}

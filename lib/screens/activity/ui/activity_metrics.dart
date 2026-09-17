/// Measurements this area needs that neither the token scale nor
/// `lib/widgets/fp_metrics.dart` carries.
///
/// `FpMetrics` holds the numbers the design system states for the twelve
/// ratified components. These are different: the filter sheet, the four facet
/// screens and the multi-select mode have **no visual specification** —
/// `design-system/src/screens/` designs the Activity screen and nothing else —
/// so every number below is a decision made here rather than a value read from
/// somewhere. Each says what it is for and why it is that size.
///
/// The rule this file exists to keep: no bare number in a widget. A literal
/// `40` in three files is three chances to change two of them.
class ActivityMetrics {
  const ActivityMetrics._();

  /// The toggle on the settings row.
  ///
  /// Squared off at [FpRadius.sm] rather than drawn as a pill: the visual
  /// direction is warmth from typography and a warm accent, deliberately not
  /// from rounded shapes, and a stadium switch is the single most pastel-app
  /// shape in a UI kit. 40×24 with an 18px knob keeps the 44px touch target
  /// through the row it sits in.
  static const double switchTrackWidth = 40.0;
  static const double switchTrackHeight = 24.0;
  static const double switchKnob = 18.0;
  static const double switchInset = 3.0;

  /// The "this section has filters set" dot, and the same dot on the filters
  /// icon. A count-free status, the same idea as the tab bar's attention dot.
  static const double activeDot = 6.0;

  /// The floating action button on `DASHBOARD`. 56 is the smallest circle that
  /// still reads as a primary action beside a 24px glyph, and it clears the
  /// 44px minimum comfortably.
  static const double fabDiameter = 56.0;

  /// The selection check that overlays an avatar in multi-select. Sized to the
  /// 24px timeline avatar it sits on, minus a hairline of surface either side.
  static const double selectionCheck = 20.0;

  /// The grab handle on a bottom sheet. Not an affordance the design system
  /// specifies; it is the platform's, and its absence reads as a bug.
  static const double sheetHandleWidth = 36.0;
  static const double sheetHandleHeight = 4.0;

  /// Minimum height of a row that can be tapped. Apple's 44pt, and the reason
  /// several controls here are larger than their glyphs.
  static const double touchTarget = 44.0;

  /// The selected-tab rule under a segmented control. Two pixels of `FpStroke`
  /// would be the token; the length of the rule is the label's own width, so
  /// only the inset below the text is stated here.
  static const double segmentRuleGap = 6.0;

  /// The empty-state illustration's mark. Large enough to be the first thing
  /// read on an otherwise blank screen, small enough not to be decoration.
  static const double emptyGlyph = 32.0;
}

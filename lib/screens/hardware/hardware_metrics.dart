/// Measurements these four screens need that neither the token scale nor
/// [FpMetrics] carries.
///
/// The Hardware screens have no visual specification — the design system draws
/// Activity at full fidelity and stops. So a handful of measurements are
/// genuinely new. They are named and argued for here rather than sitting as
/// bare numbers in a build method, on the same rule the shared [FpMetrics]
/// follows: a literal `56` in three files is three chances to change two of
/// them.
///
/// Anything that *does* have a token uses the token. Nothing here is a colour.
library;

/// The Hardware area's own measurements.
class HardwareMetrics {
  const HardwareMetrics._();

  /// The product thumbnail on a Base card and on the Buttons tile.
  ///
  /// The RN screens show photographs of the hardware
  /// (`BaseItem.tsx`, `ClassicButtonsList.tsx`). Phase 1 ships no product
  /// photography, so the same slot holds a Phosphor glyph in a square well —
  /// large enough to identify the row at arm's length, small enough that it
  /// never competes with the Base name.
  static const double productGlyphWell = 56.0;

  /// The glyph inside [productGlyphWell]. Between `FpIconSize.lg` (24) and
  /// `FpIconSize.xl` (32), because 24 rattles inside a 56 well and 32 crowds
  /// it.
  static const double productGlyph = 28.0;

  /// Minimum height of anything that can be tapped.
  ///
  /// 44 is the iOS minimum and the number the components page already cites
  /// when it explains why a 24px avatar is not itself a tap target. Every row,
  /// chip and sheet option on these screens is at least this tall.
  static const double touchTarget = 44.0;

  /// The battery pip drawn beside a linked Button's percent.
  ///
  /// Not a Phosphor glyph: the icon set's battery glyphs come in fill levels,
  /// and drawing a level would be a second battery scale next to
  /// `FpFormat.batteryLevel` — exactly the defect §8 of the inventory records.
  /// A dot carries the one distinction the scale has (low or not) and cannot
  /// grow a second one.
  static const double batteryDot = 6.0;

  /// The rule under a section heading, and the well a form field sits in.
  static const double fieldMinHeight = 48.0;

  /// How wide the interaction-timing diagram's press marks are, and how far
  /// apart the two example rows sit.
  ///
  /// The diagram is the one drawing on these four screens that is not a list
  /// of facts, and it is the reason `BASE_EDIT_INTERACTION_TIMING` is a screen
  /// rather than a tooltip: the setting groups presses, and grouping is
  /// something you show.
  static const double pressMark = 10.0;
  static const double diagramRowHeight = 34.0;

  /// The most characters a Base name may hold.
  ///
  /// **Invented.** The inventory records the client-side maximum as *unknown*
  /// — the RN form attaches no rule and the API's limit was not established
  /// (§10, §16). 40 is chosen against the widest place the name is drawn: the
  /// `BASE_EDIT` title at display-sm on a 390pt screen, where roughly 24
  /// characters fill the line and the rest ellipsises. 40 leaves headroom for
  /// a deliberately long name without letting the field accept a paragraph.
  /// It is a client-side guard only; if the API turns out to be stricter, this
  /// constant is where that lands.
  static const int baseNameMaxLength = 40;

  /// Where the name field starts warning that it is nearly full. Below this
  /// the counter is noise.
  static const int baseNameCounterFrom = 30;
}

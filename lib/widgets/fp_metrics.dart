/// Measurements the token scale does not carry.
///
/// Every number here is a measurement the design system states explicitly for
/// one component and that has no matching value in `FpSpace`, `FpRadius`,
/// `FpStroke` or `FpIconSize`. They live in one place, named and cited, rather
/// than as bare numbers scattered through the widgets — a literal `44` in three
/// files is three chances to change two of them.
///
/// Anything that *does* have a token uses the token. Nothing here is a colour,
/// and nothing here is a substitute for one.
class FpMetrics {
  const FpMetrics._();

  /// Width of the timeline's time-and-avatar column.
  ///
  /// Components page, Utterance row: "The time rail is 44px wide and holds a
  /// mono timestamp above a 24px avatar; the elapsed rail below aligns to that
  /// same column."
  static const double timeRailWidth = 44.0;

  /// Pusher avatar diameters. Components page, Pusher avatar: "sm 24px — the
  /// timeline / md 32px — list rows and pickers / lg 44px — detail screen
  /// headers". 24px is below the 44px touch target on purpose: at sm the
  /// avatar is decoration and the whole row is the tap target.
  static const double avatarSm = 24.0;
  static const double avatarMd = 32.0;
  static const double avatarLg = 44.0;

  /// The elapsed rail's rule, and where it sits in the 44px column.
  ///
  /// Components page, Elapsed-time rail: "The rule is a fixed 24px. Height is
  /// deliberately NOT proportional to the gap — a seven-hour overnight would
  /// push the next Interaction off screen." and "The rule centres on the 24px
  /// avatar above it: 44px column, 11px right padding, 1px rule."
  ///
  /// 44 − 11 − 1 puts the rule's centre at 32.5, which is the centre of a 24px
  /// avatar right-aligned in a 44px column. Change one of these and the rail
  /// stops lining up with the discs above it.
  static const double elapsedRuleHeight = 24.0;
  static const double elapsedRulePadRight = 11.0;

  /// Flag marker, inline on the timeline. Components page, Flag marker: "13px
  /// inline / 16px in a control". The control size is [FpIconSize.sm].
  static const double flagInline = 13.0;

  /// The tab bar's icon. Components page, Tab bar: "Weight alone is too quiet
  /// at 22px". Between [FpIconSize.md] (20) and [FpIconSize.lg] (24).
  static const double tabIcon = 22.0;

  /// The attention dot on a tab. A count-free status, not a badge — it says
  /// "go look", not "you have 3". Ringed in the bar's own surface so it reads
  /// as sitting on top of the icon.
  static const double attentionDot = 8.0;

  /// The device health pill's state dot, and its trailing chevron.
  static const double healthDot = 6.0;
  static const double healthChevron = 11.0;

  /// The screen header's back chevron glyph, and the box it is centred in.
  /// Invented — the components page has no ratified back affordance.
  static const double headerChevron = 18.0;
  static const double headerBackHit = 32.0;

  /// Opacity of a punctuation separator — the middots between words, between
  /// Contexts, and between summary segments. Punctuation, not content, so it
  /// sits below the tertiary text it is set in.
  static const double separatorOpacity = 0.5;
}

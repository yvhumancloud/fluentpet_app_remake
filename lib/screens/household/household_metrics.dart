/// Measurements the three Household screens need that neither the token scale
/// nor [FpMetrics] nor `HardwareMetrics` carries.
///
/// Same contract as `hardware_metrics.dart`: named, cited, in one place.
/// Nothing here is a colour and nothing here is a substitute for one.
library;

/// The Household area's own measurements and invented limits.
class HouseholdMetrics {
  const HouseholdMetrics._();

  /// The circular "add a photo" control on `HOUSEHOLD_ADD` / `HOUSEHOLD_EDIT`.
  ///
  /// Between [PusherAvatarSize.lg] (44, a detail-screen header) and something
  /// that reads as a genuine upload target rather than a bigger avatar. The RN
  /// screens use `AvatarSize.LARGE`, which the design system does not define a
  /// token for, so 88 is chosen: exactly double `lg`, which keeps it legible
  /// as "the same shape, scaled up" rather than a new shape.
  static const double avatarPicker = 88.0;

  /// The most characters a Learner or Teacher name may hold.
  ///
  /// **Invented**, on the same reasoning `HardwareMetrics.baseNameMaxLength`
  /// gives: the RN form (`HouseholdAdd.tsx`, `HouseholdEdit.tsx`) attaches no
  /// client-side rule at all. 40 matches the Base name limit for the same
  /// reason — a name is a name, and one guard number is easier to justify than
  /// two different ones for two kinds of name.
  static const int nameMaxLength = 40;
}

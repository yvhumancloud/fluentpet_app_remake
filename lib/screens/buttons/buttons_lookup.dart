/// Two lookups the Button screens share.
library;

import '../../domain/domain.dart';

/// A Button on the Board by id, or null — a deep link can name one that is
/// gone.
Button? findButton(List<Button> boardButtons, int? id) {
  if (id == null) return null;
  for (final button in boardButtons) {
    if (button.id == id) return button;
  }
  return null;
}

/// The Base a Connect [Button] is paired to, or null.
///
/// [Button] carries no Base reference on the wire — the link is the Base's
/// linked-button list, `Base.pairedButtons`, keyed by the physical Button's
/// serial. This is the same join `linkedButtonsProvider` in
/// `lib/screens/hardware/hardware_providers.dart` performs from the other
/// direction.
Base? baseForButton(List<Base> bases, Button button) {
  final serial = button.serialNumber;
  if (serial == null) return null;
  for (final base in bases) {
    for (final paired in base.pairedButtons) {
      if (paired.serialNumber == serial) return base;
    }
  }
  return null;
}

/// The option lists the Household forms need that the API does not serve.
///
/// Species comes from `GET /learner-types` (`learnerTypesProvider`). Country
/// and Language are the RN app's bundled `countries.json` / `languages.json`,
/// trimmed to a believable subset rather than ported whole; the field is a
/// free string on the wire.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';

/// Species names for the picker, from `learnerTypesProvider`.
List<String> householdSpeciesOptions(WidgetRef ref) =>
    (ref.read(learnerTypesProvider).value ?? const <int, String>{}).values
        .toList(growable: false);

/// The id behind a species name, case-insensitively, or null.
int? learnerTypeId(Map<int, String> types, String? name) {
  if (name == null) return null;
  for (final e in types.entries) {
    if (e.value.toLowerCase() == name.toLowerCase()) return e.key;
  }
  return null;
}

/// A curated subset of `TeacherForm.tsx`'s `countries.json` — a believable
/// list, not the real 195-entry one.
const List<String> householdCountryOptions = <String>[
  'United States',
  'United Kingdom',
  'Canada',
  'Australia',
  'Ireland',
  'Germany',
  'France',
  'Netherlands',
  'Sweden',
  'India',
  'Japan',
  'Other',
];

/// A curated subset of `LearnerForm.tsx`'s `languages.json`, offered on the
/// Learner Language multi-select. The RN field joins the chosen set with
/// commas on the wire (`onSelectedLanguageChange`); the form here keeps the
/// same shape — a `Set<String>` the caller joins for display.
const List<String> householdLanguageOptions = <String>[
  'English',
  'Spanish',
  'French',
  'German',
  'Mandarin',
  'Hindi',
  'Portuguese',
  'Japanese',
];

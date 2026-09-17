/// Curated option lists the Household forms need, and why no new [Pusher] or
/// [Household] fixtures live here.
///
/// ## Why the reserved id blocks (Pusher 200–299, Household 300–399) are
/// unused
///
/// `HouseholdRepository` (`lib/data/repositories.dart`) exposes exactly one
/// [Household] and one flat list of every [Pusher] in it — `household()` and
/// `pushers()`, neither parameterised. There is nowhere in the render path for
/// a *second* Household to appear, and no id-keyed lookup for a Pusher these
/// three screens could invent one into. Reserving 200–299 and 300–399 was the
/// right precaution — a screen that needed demo data would have had a
/// collision-proof place to put it — but `HOUSEHOLD`, `HOUSEHOLD_ADD` and
/// `HOUSEHOLD_EDIT` only ever read the one real Household and the one real
/// Pusher list from `lib/data/fixtures/household_fixture.dart` (read-only, not
/// this file). Inventing Pusher or Household records nothing would ever read
/// would be fixture data as decoration, which is worse than not writing it. If
/// a later pass adds a second Household (an invitation-accept flow, a
/// household switcher) this is where its id would come from.
///
/// ## What *is* here
///
/// The RN forms (`LearnerForm.tsx`, `TeacherForm.tsx`) offer a Species picker,
/// a Country picker and a Language picker, each backed by a real endpoint or a
/// bundled JSON file (`GET /api/v1/learner_types`, `countries.json`,
/// `languages.json`). None of those are ported whole — `countries.json` alone
/// is 195 entries and phase 1 fakes reads, not files. These are believable,
/// curated subsets shaped like the real thing, on the same reasoning
/// `lib/data/fixtures/household_fixture.dart` gives for its own invented data:
/// *"believable data shaped like the API, not a port of anything."*
///
/// None of the three needs an id. `Pusher.learnerType` is a bare `String?` in
/// the domain (`lib/domain/pusher.dart:61`) and Country/Language are
/// free-text-equivalent choices with no id-keyed consumer anywhere in the app
/// — unlike a Button's meaning or a Context, nothing matches these by id, so a
/// plain string list is the whole fixture and the reserved-block rule does not
/// apply to it.
library;

/// Species offered on the Learner form's Species picker.
///
/// `LearnerForm.tsx` sources this from `GET /api/v1/learner_types`, defaults
/// to "Dog" when present (`HouseholdAdd.tsx:84-92`), and the fixture keeps
/// that default first for the same reason.
const List<String> householdSpeciesOptions = <String>[
  'Dog',
  'Cat',
  'Rabbit',
  'Guinea Pig',
  'Horse',
  'Bird',
  'Other',
];

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

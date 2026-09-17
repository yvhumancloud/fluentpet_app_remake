/// Household and Pusher fixtures.
///
/// Not part of the designed Activity screen, so this is invented — believable
/// data shaped like the API, not a port of anything. Members, one of them an
/// admin, one invitation in each direction, because CONTEXT.md is explicit that
/// invitations exist in both directions at once and a screen that only ever
/// sees one of them will get that wrong.
///
/// [pushers] is **every** Pusher the app can encounter that is a person or a
/// pet, hidden ones included. It is the list the Log screen's Pusher strip, the
/// filter sheet's Household section and the Pusher facet screen all read, and
/// the same list the generated history attributes its entries to — so the
/// timeline cannot show a Pusher the Household does not have. It held three
/// while the Activity area kept two more of its own, which is exactly that.
/// The two pseudo-Pushers are not here; they are wire sentinels, and they live
/// beside each other in `activity_fixture.dart`.
library;

import '../../domain/domain.dart';
import 'activity_fixture.dart' show learner, teacher;

const HouseholdMember _sam = HouseholdMember(
  id: 1,
  fullname: 'Sam Okafor',
  email: 'sam@example.com',
  isAdmin: true,
);

const HouseholdMember _rae = HouseholdMember(
  id: 2,
  fullname: 'Rae Lindqvist',
  email: 'rae@example.com',
);

const HouseholdMember _sasha = HouseholdMember(
  id: 3,
  fullname: 'Sasha Okafor',
  email: 'sasha@example.com',
);

/// The signed-in user. The admin, so `HOUSEHOLD_MEMBERS` renders its fullest
/// state — invite, remove, and the one thing an admin cannot do (leave while
/// others remain). The member view differs only by what is absent.
const HouseholdMember me = _sam;

const Household household = Household(
  id: 4,
  name: 'Okafor–Lindqvist',
  members: <HouseholdMember>[_sam, _rae, _sasha],
  invitations: <HouseholdInvitation>[
    HouseholdInvitation(
      id: 31,
      fullname: 'Priya Raman',
      email: 'priya@example.com',
      direction: HouseholdInvitationDirection.toCurrentHousehold,
    ),
    HouseholdInvitation(
      id: 32,
      fullname: 'Tomasz Whitlock',
      email: 'tomasz@whitlock.example',
      direction: HouseholdInvitationDirection.fromOtherHousehold,
    ),
  ],
);

/// A second Learner, so the Pusher list is not a single row.
const Pusher secondLearner = Pusher(
  id: 13,
  name: 'Juno',
  isHuman: false,
  learnerType: 'Dog',
  interactionsCount: 312,
);

/// A Teacher sharing a first initial with Sam, so the avatar's single letter is
/// ambiguous on purpose. The RN app resolves this with a shortest-unique-prefix
/// algorithm (`getPusherInitials.ts`); `Pusher.initial` takes the first letter
/// and stops, so an ambiguous pair has to exist for anyone to see that the two
/// differ only by name.
const Pusher secondTeacher = Pusher(
  id: 14,
  name: 'Sasha Okafor',
  isHuman: true,
  interactionsCount: 41,
);

/// A Pusher who has left the Household. Hidden Pushers still own history, so
/// they still appear on the timeline and in the filter list — and never in the
/// strip a new press is attributed from.
const Pusher retiredTeacher = Pusher(
  id: 15,
  name: 'Devi',
  isHuman: true,
  isHidden: true,
  interactionsCount: 8,
);

/// Every Learner and Teacher, hidden ones included. Pseudo-Pushers excluded —
/// they are not members of anything.
const List<Pusher> pushers = <Pusher>[
  learner,
  secondLearner,
  teacher,
  secondTeacher,
  retiredTeacher,
];

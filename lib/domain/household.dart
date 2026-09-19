/// A member of a Household — a user with an account, not a Pusher.
///
/// [id] is the `users.id` that `DELETE /household/members/{user_id}` addresses.
/// The RN app keyed membership by email; the PRD keys it by id, and the email
/// stays because it is what the screen prints.
class HouseholdMember {
  const HouseholdMember({
    required this.id,
    required this.fullname,
    required this.email,
    this.isAdmin = false,
  });

  final int id;
  final String fullname;
  final String email;

  /// `users.is_household_admin`: the user who created the Household. Invites
  /// and removes members; cannot leave while anyone else is in it.
  final bool isAdmin;
}

/// Which way an invitation points. Both directions exist at once: a person may
/// hold pending invites from several Households while their own Household has
/// invites outstanding.
enum HouseholdInvitationDirection { fromOtherHousehold, toCurrentHousehold }

/// One row of `household_invitations`.
///
/// For [HouseholdInvitationDirection.toCurrentHousehold] the name and email
/// are the invitee's; for [HouseholdInvitationDirection.fromOtherHousehold]
/// they are the inviter's, since that is who the invitee needs to recognise.
/// [id] is what accept, reject and delete address.
class HouseholdInvitation {
  const HouseholdInvitation({
    required this.id,
    required this.fullname,
    required this.email,
    required this.direction,
  });

  final int id;
  final String fullname;
  final String email;
  final HouseholdInvitationDirection direction;
}

/// A group of people who share Bases, Boards and Pushers.
class Household {
  const Household({
    required this.id,
    required this.name,
    required this.members,
    this.invitations = const <HouseholdInvitation>[],
  });

  final int id;
  final String name;
  final List<HouseholdMember> members;
  final List<HouseholdInvitation> invitations;

  Iterable<HouseholdMember> get admins => members.where((m) => m.isAdmin);

  Iterable<HouseholdInvitation> get incoming => invitations.where(
    (i) => i.direction == HouseholdInvitationDirection.fromOtherHousehold,
  );

  Iterable<HouseholdInvitation> get outgoing => invitations.where(
    (i) => i.direction == HouseholdInvitationDirection.toCurrentHousehold,
  );
}

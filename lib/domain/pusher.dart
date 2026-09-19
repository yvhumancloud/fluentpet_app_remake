/// Who did the pressing.
///
/// The API has no `kind` field: the discriminator on the wire is
/// `is_human: boolean`, and the RN app derives the rest client-side
/// (`src/Home/LogDetails/helpers/getPusherType.tsx`). Two further variants are
/// matched by *name*, case-insensitively — a Pusher literally called
/// "event note" or "base". That is fragile and it is faithfully reproduced in
/// [PusherKind.fromWire] rather than silently improved, because the API will
/// keep sending it.
enum PusherKind {
  /// The pet. `is_human == false`.
  learner,

  /// A human modelling a word. `is_human == true`.
  teacher,

  /// The pseudo-Pusher a free-standing Note is attributed to. Carries id -1.
  eventNote,

  /// The pseudo-Pusher used when a press has no attribution at all.
  base;

  /// Reproduces the RN derivation exactly.
  static PusherKind fromWire({required String name, required bool isHuman}) {
    final lower = name.toLowerCase();
    if (lower == 'event note') return PusherKind.eventNote;
    if (lower == 'base') return PusherKind.base;
    return isHuman ? PusherKind.teacher : PusherKind.learner;
  }
}

/// A Pusher: a Learner (the pet) or a Teacher (a human).
///
/// Every [Interaction] is attributed to one, and a [Base] has a default one.
class Pusher {
  const Pusher({
    required this.id,
    required this.name,
    required this.isHuman,
    this.avatarUri,
    this.interactionsCount = 0,
    this.isHidden = false,
    this.learnerType,
    this.learnerTypeId,
    this.trainingStartedAt,
    this.birthDate,
    this.subType,
    this.country,
    this.language,
  });

  /// The sentinel id the API uses for the journal / event-note pseudo-Pusher.
  static const int journalPusherId = -1;

  final int id;
  final String name;

  /// The wire discriminator. Prefer [kind].
  final bool isHuman;

  final String? avatarUri;
  final int interactionsCount;
  final bool isHidden;

  /// e.g. "Dog". Learners only.
  final String? learnerType;

  /// `learner_type_id`, what `PATCH /pushers` takes; [learnerType] is its name.
  final int? learnerTypeId;

  final DateTime? trainingStartedAt;
  final DateTime? birthDate;

  /// Breed, for a Learner.
  final String? subType;
  final String? country;

  /// Comma-joined on the wire, as the RN form sent it.
  final String? language;

  PusherKind get kind => PusherKind.fromWire(name: name, isHuman: isHuman);

  bool get isLearner => kind == PusherKind.learner;
  bool get isTeacher => kind == PusherKind.teacher;

  /// The single letter shown in the avatar. Derived, never typed twice — the
  /// design system makes the same point in `src/components/ui/types.ts`.
  String get initial => name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();
}

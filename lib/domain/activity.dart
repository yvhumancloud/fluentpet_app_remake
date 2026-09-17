import 'button.dart';
import 'interaction_context.dart';
import 'pusher.dart';

/// Where a recorded press came from.
///
/// The wire values are inconsistent about separators — one hyphenated, three
/// underscored, one bare. They are reproduced exactly. Normalising them here
/// would make every future comparison against a live payload fail.
enum InteractionOrigin {
  app('app'),
  base('fp_connect_base'),
  dbManualImport('db-manual-import'),
  interactionImporter('interaction_importer'),

  /// Produced when an existing Interaction is split in two.
  interactionSplit('interaction_split');

  const InteractionOrigin(this.wire);

  final String wire;

  static InteractionOrigin fromWire(String value) => values.firstWhere(
        (o) => o.wire == value,
        orElse: () => InteractionOrigin.app,
      );
}

/// The two things that appear on the timeline. Rails STI class names, hence the
/// capitals on the wire.
enum ActivityType {
  interaction('Interaction'),
  note('Note');

  const ActivityType(this.wire);

  final String wire;
}

/// The supertype of things on the timeline: an [Interaction], or a
/// free-standing [Note]. Activities can be flagged.
///
/// Sealed, so a timeline that grows a third kind fails to compile rather than
/// silently rendering nothing. The RN app has no such supertype — it treats
/// everything as an interaction row and reads `type` — but CONTEXT.md describes
/// one, and switching over a sealed class is what the timeline wants.
sealed class Activity {
  const Activity({
    required this.id,
    required this.occurredAt,
    required this.pusher,
    this.isFlagged = false,
    this.note = '',
  });

  /// The Activity id. Distinct from [Interaction.interactionId]: the API's bulk
  /// delete works on activity ids and everything else works on interaction ids.
  final int id;

  final DateTime occurredAt;

  /// Who it is attributed to. A free-standing Note is attributed to the
  /// event-note pseudo-Pusher, id [Pusher.journalPusherId].
  final Pusher pusher;

  final bool isFlagged;

  /// The human annotation attached to this entry, if any.
  final String note;

  ActivityType get type;
}

/// One recorded press event.
class Interaction extends Activity {
  const Interaction({
    required super.id,
    required this.interactionId,
    required super.occurredAt,
    required super.pusher,
    required this.buttons,
    this.contexts = const <InteractionContext>[],
    this.origin = InteractionOrigin.base,
    this.baseId,
    this.createdAt,
    this.boardId = 0,
    this.deviceTimezone = '',
    this.isReviewed = false,
    this.modeledPushers = const <Pusher>[],
    this.firstTimeWord,
    super.isFlagged,
    super.note,
  });

  /// The interaction id, which is not the activity id. Split, merge, assign and
  /// update all address this one; only bulk delete addresses [Activity.id].
  final int interactionId;

  /// The Buttons pressed, in press order.
  final List<Button> buttons;

  final List<InteractionContext> contexts;
  final InteractionOrigin origin;

  /// The Base that recorded the press, or null when no Base did — an entry
  /// logged by hand in the app has no Base behind it.
  ///
  /// On the wire an Interaction knows its Base, and [DashboardFilters.baseIds]
  /// is a filter facet the API evaluates. Without this field that facet is
  /// unevaluable client-side, which is what it was until now: the Activity
  /// fixture carried a `baseIdOf()` stand-in beside the data and the filter
  /// went through it. This is the real field; the stand-in is gone.
  final int? baseId;

  /// When the row was **written**, as against [Activity.occurredAt], when the
  /// press happened.
  ///
  /// The two differ by seconds for a press a Base uploaded and by hours or
  /// days for one somebody logged by hand afterwards — which is the entire
  /// distinction `ActivitySortType` draws between "recently pressed" and
  /// "recently logged" (`docs/design-system/screen-inventory.md` §2). Sorting
  /// was unimplementable without it.
  ///
  /// Nullable because a draft has not been written yet: `LogDraft.preview`
  /// builds an Interaction that exists only on screen. [loggedAt] is the value
  /// to sort and display by, and it falls back to the press time.
  final DateTime? createdAt;

  final int boardId;

  /// IANA zone name recorded on the device that logged the press.
  final String deviceTimezone;

  final bool isReviewed;

  /// Teachers present when a Learner pressed — "modelled by".
  final List<Pusher> modeledPushers;

  /// A word this Learner had not pressed before.
  ///
  /// Not a wire field. The API exposes `Button.introduced_at`, from which this
  /// is computed; the Activity screen design shows it as a marker on the
  /// utterance, so it is carried on the model the screen is handed.
  final String? firstTimeWord;

  @override
  ActivityType get type => ActivityType.interaction;

  /// The words pressed, in press order. The design system's `Utterance.words`.
  List<String> get words => buttons.map((b) => b.text).toList(growable: false);

  bool get isMultiPress => buttons.length > 1;

  /// When this entry was logged, falling back to when it was pressed.
  DateTime get loggedAt => createdAt ?? occurredAt;

  /// Only presses that came from a Base can be split. The RN app gates the
  /// Split action on exactly this (`src/components/Dashboard/DashboardList.tsx`).
  bool get canSplit => origin == InteractionOrigin.base;
}

/// A free-standing Note: an entry on the timeline with no press behind it.
///
/// There is no `Note` type in the RN app; a note is a row with `type: "Note"`
/// and the event-note pseudo-Pusher. Modelling it as its own thing is a
/// departure, recorded in `domain.dart`.
class Note extends Activity {
  const Note({
    required super.id,
    required super.occurredAt,
    required super.pusher,
    required String body,
    super.isFlagged,
  }) : super(note: body);

  /// The text of the note. Same storage as [Activity.note]; named for what it
  /// is here, where the note is the entire entry rather than an annotation.
  String get body => note;

  @override
  ActivityType get type => ActivityType.note;
}

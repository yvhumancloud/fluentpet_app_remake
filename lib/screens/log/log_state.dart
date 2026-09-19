/// State for the two Log screens.
///
/// ## Why there is a draft object at all
///
/// In the RN app `LOG` hands `LOG_DETAILS` its Buttons, its Pusher, the Board
/// id **and an `onReturn` closure** through navigation params
/// (`src/Home/Log/LogScreen.tsx:163-176`). Flutter navigation cannot carry a
/// closure, and the screen inventory names this as one of the things that make
/// the redesign harder than it looks (§14.3): *"Phase 1 needs a filter
/// controller/notifier owned above both screens, or a result returned from the
/// route."* The same is true of the log draft, so here it is — one notifier
/// above both screens.
///
/// That also makes the deep links honest. `/…/log_details_nav/event_add` is a
/// real route; opened cold it now finds an empty draft and the screen says so,
/// instead of crashing on a missing param.
///
/// ## Where the Contexts come from
///
/// They come from the repository, like everything else. This file used to
/// import `data/fixtures/log_extra_fixture.dart` directly, because
/// `ActivityRepository` exposed `today()` and `dashboard()` and had no method
/// for Contexts at all — so the Log area declared its own list, the Activity
/// area declared another, and the two overlapped on ids: "morning" was 601 in
/// one and "raining" was 601 in the other, while Dashboard filtering matches
/// Contexts by id.
///
/// `ActivityRepository.contexts(forTeacher:)` is that missing method, the one
/// catalogue lives in `activity_fixture.dart`, and the providers below are
/// this area's names for the shared ones.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';

// ─────────────────────────── the draft ───────────────────────────

/// The Interaction being composed, from the first Button tapped to SAVE.
///
/// Immutable, and it carries the same fields the API's create call does
/// (`useCreateInteraction.ts`): board, Pusher, Buttons in press order,
/// Contexts, the modelled Learners, the note and the timestamp. [isFlagged] is
/// the one addition — see the note on it.
@immutable
class LogDraft {
  const LogDraft({
    required this.occurredAt,
    this.pusher,
    this.buttons = const <Button>[],
    this.contexts = const <InteractionContext>[],
    this.modeledPushers = const <Pusher>[],
    this.note = '',
    this.isFlagged = false,
    this.boardId = 0,
  });

  /// When the press happened. Defaults to the moment the draft was started and
  /// can be moved backwards, never forwards — a press cannot be logged into
  /// the future (`LogDetailsNewScreen.tsx:342`, `maximumDate={new Date()}`).
  final DateTime occurredAt;

  /// Null until a Pusher is chosen. `LOG` pre-selects the first Household
  /// member for display but does not write it here until the user taps one or
  /// presses LOG EVENT, so nothing mutates a provider during a build.
  final Pusher? pusher;

  /// The Buttons pressed, in press order. The same Button may appear twice:
  /// pressing "outside" twice is two presses, not one
  /// (`ButtonsBoard.tsx:148-151`).
  final List<Button> buttons;

  final List<InteractionContext> contexts;

  /// Teachers say which Learners were present — the modelling attribution.
  final List<Pusher> modeledPushers;

  final String note;

  /// **Invented for this screen.** The RN `LOG_DETAILS` cannot flag, only
  /// `LOG_ENTRY_EDIT` can, so flagging an interesting press means saving it,
  /// finding it on the timeline and opening it again. The flag is one bit and
  /// the marker already has a `FlagMarker.control` constructor built for
  /// exactly this position, so it is offered at compose time.
  final bool isFlagged;

  final int boardId;

  /// A free-standing Note rather than a press: the journal entry the Activity
  /// FAB starts. Discriminated by the event-note pseudo-Pusher, id -1, which
  /// is how the API discriminates it too.
  bool get isJournal => pusher?.kind == PusherKind.eventNote;

  bool get isTeacher => pusher?.isTeacher ?? false;

  /// Nothing to save. A journal entry with no note is still nothing; a press
  /// with no Buttons is nothing whatever the note says.
  bool get isEmpty => isJournal ? note.trim().isEmpty : buttons.isEmpty;

  List<String> get words => buttons.map((b) => b.text).toList(growable: false);

  /// The draft as an [Activity] — exactly the object the timeline renders.
  ///
  /// This is what lets `LOG_DETAILS` preview the entry with the same
  /// `UtteranceRow` the Activity screen uses, rather than with a second
  /// rendering of the same facts that can drift from it.
  ///
  /// Null while no Pusher is chosen, because an Activity without a Pusher is
  /// not a thing the domain has.
  Activity? get preview {
    final who = pusher;
    if (who == null) return null;
    if (isJournal) {
      return Note(
        id: _draftId,
        occurredAt: occurredAt,
        pusher: who,
        body: note,
        isFlagged: isFlagged,
      );
    }
    return Interaction(
      id: _draftId,
      interactionId: _draftId,
      occurredAt: occurredAt,
      pusher: who,
      buttons: buttons,
      contexts: contexts,
      // Logged by hand in the app, not grouped by a Base. This is what makes
      // the entry unsplittable later, and it is true of everything these two
      // screens produce.
      origin: InteractionOrigin.app,
      boardId: boardId,
      note: note,
      isFlagged: isFlagged,
      modeledPushers: modeledPushers,
    );
  }

  /// The id an unsaved draft carries. Zero rather than a negative sentinel:
  /// -1 already means the journal Pusher and reusing it here would be a second
  /// meaning for one number.
  static const int _draftId = 0;

  LogDraft copyWith({
    DateTime? occurredAt,
    Pusher? pusher,
    List<Button>? buttons,
    List<InteractionContext>? contexts,
    List<Pusher>? modeledPushers,
    String? note,
    bool? isFlagged,
    int? boardId,
  }) {
    return LogDraft(
      occurredAt: occurredAt ?? this.occurredAt,
      pusher: pusher ?? this.pusher,
      buttons: buttons ?? this.buttons,
      contexts: contexts ?? this.contexts,
      modeledPushers: modeledPushers ?? this.modeledPushers,
      note: note ?? this.note,
      isFlagged: isFlagged ?? this.isFlagged,
      boardId: boardId ?? this.boardId,
    );
  }
}

/// The draft, and every rule that changes it.
///
/// The domain rules baked into the RN screen live here rather than in a widget
/// callback, because three of them fire from two different screens and one of
/// them ("switching to a Teacher selects Modeled") is easy to implement twice
/// and get subtly different.
class LogDraftNotifier extends Notifier<LogDraft> {
  @override
  LogDraft build() => LogDraft(occurredAt: DateTime.now());

  /// Choose who pressed, applying the Pusher-type rules in one place.
  ///
  /// From `LogDetailsNewScreen.tsx`:
  ///
  /// * Learner → Teacher **clears** the Contexts and selects the one named
  ///   `Modeled` (`:122-134`, `updatePusher` at `:203-211`).
  ///   The Context vocabulary itself changes with the Pusher's type, so
  ///   carrying Learner Contexts over would keep ids the Teacher list does not
  ///   contain.
  /// * Teacher → Learner **removes** "Modeled" and keeps nothing else, for the
  ///   same reason (`:212-226`).
  /// * The journal Pusher has no Contexts at all — the block is hidden for it
  ///   (`:269-273`) — so they are dropped rather than left invisible and
  ///   saved.
  ///
  /// [availableContexts] is the list for the *new* Pusher, which the caller
  /// already has; passing it in keeps this notifier free of the fixture.
  void selectPusher(
    Pusher pusher, {
    required List<InteractionContext> availableContexts,
  }) {
    if (pusher.id == state.pusher?.id) return;

    final List<InteractionContext> contexts;
    if (pusher.kind == PusherKind.eventNote) {
      contexts = const <InteractionContext>[];
    } else if (pusher.isTeacher) {
      contexts = availableContexts
          .where((ctx) => ctx.text == modeledContextText)
          .toList(growable: false);
    } else {
      contexts = state.contexts
          .where((ctx) => ctx.text != modeledContextText)
          .toList(growable: false);
    }

    state = state.copyWith(
      pusher: pusher,
      contexts: contexts,
      // Only a Teacher models. Moving the entry to a Learner leaves the
      // modelled set describing nobody.
      modeledPushers: pusher.isTeacher
          ? state.modeledPushers
          : const <Pusher>[],
    );
  }

  /// Start from an entry that already exists — Duplicate, on a timeline row.
  ///
  /// The RN app's Duplicate GETs the original and pre-fills everything,
  /// timestamp included (`DashboardList.tsx:244-274`), then opens
  /// `LOG_DETAILS`, which is a **create** surface: what is saved is a new
  /// Interaction, and the original is untouched.
  ///
  /// Three things are deliberately not copied. The flag is the person's
  /// judgement on *that* entry, not on this one. The note is the same. And
  /// [LogDraft.occurredAt] is copied — the RN app copies it — so a duplicate
  /// lands beside its original on the timeline rather than at the moment
  /// somebody pressed Duplicate.
  ///
  /// Without this the Duplicate option on the row sheet was drawn permanently
  /// disabled, because there was no entry point that seeded a draft from an
  /// existing Interaction.
  void startFrom(Interaction interaction) {
    state = LogDraft(
      occurredAt: interaction.occurredAt,
      pusher: interaction.pusher,
      buttons: interaction.buttons,
      contexts: interaction.contexts,
      modeledPushers: interaction.modeledPushers,
      boardId: interaction.boardId,
    );
  }

  /// Start a free-standing Note — the Activity FAB's "Add Journal Entry".
  ///
  /// The entry point for that path, which lives on another screen: hand it the
  /// event-note pseudo-Pusher and push the LOG_DETAILS route. `LOG` offers the
  /// same thing from its empty state so the variant is reachable in phase 1.
  void startJournal(Pusher journalPusher) {
    state = LogDraft(occurredAt: DateTime.now(), pusher: journalPusher);
  }

  /// Append a press. The same Button twice is two presses.
  void addButton(Button button) {
    state = state.copyWith(
      buttons: <Button>[...state.buttons, button],
      boardId: state.boardId == 0 ? button.boardId : state.boardId,
    );
  }

  /// Remove one occurrence by position, not by id — the list may hold the same
  /// Button more than once and removing "the outside one" would take the wrong
  /// press.
  void removeButtonAt(int index) {
    if (index < 0 || index >= state.buttons.length) return;
    final next = <Button>[...state.buttons]..removeAt(index);
    state = state.copyWith(buttons: next);
  }

  void toggleContext(InteractionContext context) {
    final selected = state.contexts.any((ctx) => ctx.id == context.id);
    final next = selected
        ? state.contexts
              .where((ctx) => ctx.id != context.id)
              .toList(growable: false)
        : (<InteractionContext>[...state.contexts, context]
            ..sort((a, b) => a.id.compareTo(b.id)));
    state = state.copyWith(contexts: next);
  }

  void toggleModeledPusher(Pusher pusher) {
    final selected = state.modeledPushers.any((p) => p.id == pusher.id);
    final next = selected
        ? state.modeledPushers
              .where((p) => p.id != pusher.id)
              .toList(growable: false)
        : <Pusher>[...state.modeledPushers, pusher];
    state = state.copyWith(modeledPushers: next);
  }

  /// Auto-attribute when the Household has exactly one Learner
  /// (`LogDetailsNewScreen.tsx:93-99`). Idempotent, so a rebuild cannot undo a
  /// deliberate deselection: it only fires while the set is empty and only
  /// once there is a Teacher to attribute.
  void adoptSoleLearner(List<Pusher> learners) {
    if (learners.length != 1) return;
    if (state.modeledPushers.isNotEmpty) return;
    if (!state.isTeacher) return;
    state = state.copyWith(modeledPushers: learners);
  }

  void setNote(String note) => state = state.copyWith(note: note);

  void toggleFlag() => state = state.copyWith(isFlagged: !state.isFlagged);

  void setBoardId(int boardId) => state = state.copyWith(boardId: boardId);

  /// Move the timestamp. Never forwards: a press that has not happened yet
  /// cannot be recorded, and the RN pickers enforce the same bound.
  ///
  /// Returns false when [at] was in the future and was refused, so the screen
  /// can say why rather than silently snapping the value.
  bool setOccurredAt(DateTime at, {required DateTime now}) {
    if (at.isAfter(now)) return false;
    state = state.copyWith(occurredAt: at);
    return true;
  }

  /// The separate two-digit seconds field. Clamped to 0–59; empty means zero
  /// (`src/components/LogEntryEdit/DateAndTime.tsx:43-55`).
  void setSeconds(int seconds) {
    final clamped = seconds.clamp(0, 59);
    final at = state.occurredAt;
    state = state.copyWith(
      occurredAt: DateTime(
        at.year,
        at.month,
        at.day,
        at.hour,
        at.minute,
        clamped,
      ),
    );
  }

  /// SAVE EVENT & LOG ANOTHER: keep who pressed, drop what was pressed.
  ///
  /// This is `onReturn(true)` from the RN screen, which clears the caller's
  /// selection (`LogScreen.tsx:96-105`). Contexts go with the Buttons — they
  /// described *that* press — except the automatic "Modeled" on a Teacher,
  /// which describes the Pusher and survives.
  void clearComposition({required List<InteractionContext> availableContexts}) {
    final who = state.pusher;
    state = LogDraft(
      occurredAt: DateTime.now(),
      pusher: who,
      boardId: state.boardId,
      contexts: who != null && who.isTeacher
          ? availableContexts
                .where((ctx) => ctx.text == modeledContextText)
                .toList(growable: false)
          : const <InteractionContext>[],
    );
  }

  /// Back to nothing — after SAVE EVENT, or when the modal is dismissed.
  void reset() => state = LogDraft(occurredAt: DateTime.now());
}

final NotifierProvider<LogDraftNotifier, LogDraft> logDraftProvider =
    NotifierProvider<LogDraftNotifier, LogDraft>(LogDraftNotifier.new);

// ─────────────────────────── the Board view ───────────────────────────

/// How the Buttons Board is ordered.
///
/// The three the RN sort sheet offers (`src/Home/Log/components/ButtonSort.tsx:29-33`).
/// The preference is a server-side `button_sort` in the real app; phase 1 holds
/// it in memory and does not persist it `[FAKE]`.
enum LogButtonSort {
  alphabet('A–Z'),
  introduced('Introduced'),
  mostUsed('Most used');

  const LogButtonSort(this.label);

  final String label;
}

/// Search text, sort order and the Buttons archived this session.
@immutable
class LogBoardView {
  const LogBoardView({
    this.search = '',
    this.sort = LogButtonSort.alphabet,
    this.archivedButtonIds = const <int>{},
  });

  /// Prefix match, case-insensitive, against the Button's meaning — the same
  /// `_.startsWith` the RN board uses (`ButtonsBoard.tsx:73-83`). A contains
  /// match would be friendlier and would also be a different screen.
  final String search;

  final LogButtonSort sort;

  /// Buttons archived from this screen this session, hidden immediately
  /// while `PATCH /buttons/{id}` and the Board refetch catch up.
  final Set<int> archivedButtonIds;

  LogBoardView copyWith({
    String? search,
    LogButtonSort? sort,
    Set<int>? archivedButtonIds,
  }) {
    return LogBoardView(
      search: search ?? this.search,
      sort: sort ?? this.sort,
      archivedButtonIds: archivedButtonIds ?? this.archivedButtonIds,
    );
  }
}

class LogBoardViewNotifier extends Notifier<LogBoardView> {
  @override
  LogBoardView build() => const LogBoardView();

  void setSearch(String search) => state = state.copyWith(search: search);

  void clearSearch() => state = state.copyWith(search: '');

  void setSort(LogButtonSort sort) => state = state.copyWith(sort: sort);

  void archive(Button button) => state = state.copyWith(
    archivedButtonIds: <int>{...state.archivedButtonIds, button.id},
  );
}

final NotifierProvider<LogBoardViewNotifier, LogBoardView>
logBoardViewProvider = NotifierProvider<LogBoardViewNotifier, LogBoardView>(
  LogBoardViewNotifier.new,
);

// ─────────────────────────── Contexts ───────────────────────────

/// The Contexts offered for a Learner's Interaction, and for a Teacher's.
///
/// `GET /api/v1/contexts?filter=learner|teacher` in the real app; the filter
/// changes with `selectedPusher.is_human` (`LogDetailsNewScreen.tsx:74-76`).
/// Both are the shared providers under this area's names, so a Context tagged
/// here is the same object — same id — that the Activity tab filters by.
///
/// The Teacher list contains the `Modeled` Context, which three rules key off
/// by name.
final FutureProvider<List<InteractionContext>> logLearnerContextsProvider =
    learnerContextsProvider;

final FutureProvider<List<InteractionContext>> logTeacherContextsProvider =
    teacherContextsProvider;

/// A Context list as the screens use it: whatever has loaded, and nothing
/// before it has.
///
/// Every read of these lists happens on a tap — opening the checklist, saving,
/// switching Pusher — long after the fixture has resolved, so an empty list
/// here means "there are none to offer", which is the truth in the only case it
/// can occur. Stated once rather than three `?? const []`s that could differ.
List<InteractionContext> logContexts(
  AsyncValue<List<InteractionContext>> contexts,
) => contexts.value ?? const <InteractionContext>[];

/// The event-note pseudo-Pusher a free-standing Note is attributed to.
final Provider<Pusher> logJournalPusherProvider = journalPusherProvider;

/// The literal Context name the Teacher rules turn on. Re-exposed so no screen
/// spells it a second time.
const String logModeledContextText = modeledContextText;

// ─────────────────────────── derivations ───────────────────────────

/// The Household members a press can be attributed to, Learners first.
///
/// Pseudo-Pushers are excluded: the RN strip filters to
/// `isPusherHumanOrAnimal` (`LogScreen.tsx:62-66`), which drops the `base` and
/// `event note` sentinels, and then `_.sortBy(["is_human"])` puts Learners
/// ahead of Teachers (`:67-71`). Hidden Pushers are dropped too — an archived
/// member is not someone a new press is attributed to.
List<Pusher> logMembers(List<Pusher> all) {
  final members = all
      .where(
        (p) => p.kind == PusherKind.learner || p.kind == PusherKind.teacher,
      )
      .where((p) => !p.isHidden)
      .toList(growable: false);
  return <Pusher>[
    ...members.where((p) => p.isLearner),
    ...members.where((p) => !p.isLearner),
  ];
}

/// The Learners among [all] — who a Teacher's modelling can be attributed to.
List<Pusher> logLearners(List<Pusher> all) =>
    logMembers(all).where((p) => p.isLearner).toList(growable: false);

/// Whether the Household is short of a Learner or short of a Teacher, and the
/// ADD circle at the head of the Pusher strip should therefore appear.
///
/// The RN helper is called `isAtLeastOneLearnerAndTeacher` and **returns the
/// negation of its own name** (`src/Home/Log/helpers/isAtLeastOneLearnerAndTeacher.ts:13`).
/// It is consumed as `shouldRenderAddMember`, so the behaviour is right and the
/// name is a lie. The inventory's instruction is explicit: *"In Flutter call it
/// `isMissingLearnerOrTeacher`."*
bool logIsMissingLearnerOrTeacher(List<Pusher> all) {
  final members = logMembers(all);
  return !members.any((p) => p.isLearner) || !members.any((p) => p.isTeacher);
}

/// The Buttons the Board shows, after archiving, searching and sorting.
///
/// The `inaudible` Button is **not** here: it is pinned last as a special
/// badge and comes back from the inaudible lookup below
/// (`ButtonsBoard.tsx:120-126`, `:218-230`).
List<Button> logVisibleButtons(Board board, LogBoardView view) {
  final query = view.search.trim().toLowerCase();
  final matched = board.activeButtons
      .where((b) => !view.archivedButtonIds.contains(b.id))
      .where((b) => b.kind != ButtonKind.inaudible)
      .where((b) => query.isEmpty || b.text.toLowerCase().startsWith(query))
      .toList();

  switch (view.sort) {
    case LogButtonSort.alphabet:
      matched.sort(
        (a, b) => a.text.toLowerCase().compareTo(b.text.toLowerCase()),
      );
    case LogButtonSort.introduced:
      // Newest first, and a Button with no date sinks to the bottom rather
      // than claiming the epoch.
      matched.sort((a, b) {
        final left = a.introducedAt;
        final right = b.introducedAt;
        if (left == null && right == null) return 0;
        if (left == null) return 1;
        if (right == null) return -1;
        return right.compareTo(left);
      });
    case LogButtonSort.mostUsed:
      matched.sort((a, b) => b.buttonPresses.compareTo(a.buttonPresses));
  }
  return List<Button>.unmodifiable(matched);
}

/// The `inaudible` Button, if this Board has one.
///
/// Many Boards do not, and §5 of the inventory records that the filter screen
/// breaks on those. Null here renders nothing, which is the whole handling.
Button? logInaudibleButton(Board board, LogBoardView view) {
  for (final button in board.activeButtons) {
    if (button.kind == ButtonKind.inaudible &&
        !view.archivedButtonIds.contains(button.id)) {
      return button;
    }
  }
  return null;
}

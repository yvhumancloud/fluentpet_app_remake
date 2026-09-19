/// State for the three `LOG_ENTRY_EDIT*` screens, and the lookup that feeds
/// them.
///
/// ## Which screen this is not
///
/// `LOG_ENTRY_EDIT` is `src/Home/LogDetails/LogDetailsEditScreen.tsx`
/// (619 lines), registered in `LogEntryEditNavigator.tsx` — the screen a tap on
/// a timeline row lands on. It **updates** an existing [Activity]; it does not
/// create one. `LOG_DETAILS` (`LogDetailsNewScreen.tsx`, in `../log_state.dart`
/// as [LogDraft]) is the create surface, reached from `LOG`'s LOG EVENT and the
/// Activity FAB. The two are easy to confuse because the RN filenames are the
/// opposite way round from the screen keys: `LogDetailsNewScreen` is
/// `LOG_DETAILS` (create) and `LogDetailsEditScreen` is `LOG_ENTRY_EDIT`
/// (update). Checked against `LogEntryEditNavigator.tsx:49-56` and
/// `LogDetailsNavigator.tsx:51-69` before writing a line of this file.
///
/// `LOG_ENTRY_EDIT_BUTTONS` and `LOG_ENTRY_EDIT_PUSHER` are this screen's own
/// picker sub-screens, in a different navigator from — but sharing the exact
/// same RN components as — `LOG_DETAILS_EDIT_BUTTONS` and
/// `LOG_DETAILS_EDIT_PUSHER`, which pick values for [LogDraft] instead and are
/// built in `log_entry_edit_buttons_screen.dart` /
/// `log_entry_edit_pusher_screen.dart` alongside their `LOG_ENTRY_EDIT_*`
/// siblings, thin wrappers around the same picker body.
///
/// ## Why there is a second draft object, distinct from [LogDraft]
///
/// [LogDraft] starts empty and is built up by hand. An entry reached from the
/// timeline already exists — it has to be **fetched** before there is anything
/// to edit, it carries an [Activity.id] the eventual PATCH would need to
/// address, and its dirty state is measured against what was loaded, not
/// against emptiness. Three real differences, one object each, rather than
/// overloading [LogDraft] with an "am I editing or composing" flag that every
/// method would have to branch on.
///
/// The RN screen holds the same distinction as two objects too:
/// `formData` and `initialData`, compared with `_.isEqual` to gate the SAVE
/// button (`LogDetailsEditScreen.tsx:99-101`, `:157-168`). [isDirty] here is
/// that comparison, field by field, because [EditEntryDraft] has no derived
/// `==`.
///
/// ## The two members of [Activity], both handled
///
/// A timeline row is an [Interaction] or a free-standing [Note] — the sealed
/// supertype this rewrite gives the RN app's single `type: "Note"` row
/// (`domain.dart`). [EditEntryDraftNotifier.loadFrom] switches on both. A
/// [Note] has no Buttons, no Contexts and no modelled Learners — those fields
/// simply have nothing to populate — and the
/// screen built on top of this state hides the sections that would edit them,
/// the same way it already hides them for the RN's "event note" pseudo-Pusher.
///
/// ## A defect in the RN screen, not reproduced
///
/// `LogDetailsEditScreen.tsx:195-210` re-selects the Context named "Modeled"
/// whenever `selectedPusher?.is_human && contexts` — and that effect's
/// dependencies are `[selectedPusher, contexts]`, which are also set by the
/// *load* effect just above it. Opening an existing Teacher-attributed
/// Interaction therefore fires this effect on mount, immediately overwriting
/// whatever Contexts were actually saved with `["Modeled"]` alone — before
/// anyone has touched anything. That reads as a copy-paste of the create
/// screen's genuinely-intentional "switching to a Teacher selects Modeled"
/// rule (`LogDetailsNewScreen.tsx:122-134`, reproduced correctly in
/// `LogDraftNotifier.selectPusher`) into a screen where it now also fires on
/// load, which a create screen never does because there is nothing loaded to
/// clobber.
///
/// [EditEntryDraftNotifier.loadFrom] populates Contexts from the fetched
/// Activity and stops there; [EditEntryDraftNotifier.selectPusher] applies the
/// Modeled-on-Teacher rule only on an explicit reassignment, the one case the
/// RN screen's own create-screen rule was written for. The alternative —
/// silently discarding a saved Interaction's Contexts every time somebody
/// opens it to fix its timestamp — is not a capability worth keeping.
library;

import 'package:flutter/foundation.dart' show immutable, listEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/domain.dart';
import '../log_state.dart' show logModeledContextText;

// ─────────────────────────── finding the Activity ───────────────────────────

/// The Activity a deep link named, by [Activity.id], or null when it is gone.
///
/// A timeline row tap seeds the draft before it navigates, so this only runs
/// for a cold link. An Interaction's id is its wire id and `GET
/// /interactions/{id}` finds it; a Note's is the negative of its wire id
/// (`mappers.dart`) and has no single-row read, so a cold link to a Note
/// resolves to "not here" rather than to the wrong row.
final logActivityProvider = FutureProvider.autoDispose.family<Activity?, int>(
  (ref, id) => id < 0
      ? Future<Activity?>.value()
      : ref.watch(activityRepositoryProvider).interaction(id),
);

// ─────────────────────────── the edit draft ───────────────────────────

/// An existing [Activity], as the edit screen is composing changes to it.
///
/// Unpopulated ([activityId] null) until [EditEntryDraftNotifier.loadFrom]
/// fills it in. Deliberately not a copy of [LogDraft] with extra fields: a
/// draft that starts empty and one that starts from a fetched record answer
/// different questions ("is there anything to save" vs "has anything
/// changed"), and conflating them is exactly what produced the RN defect
/// documented on this library.
@immutable
class EditEntryDraft {
  const EditEntryDraft({
    this.activityId,
    this.interactionId,
    this.occurredAt,
    this.pusher,
    this.buttons = const <Button>[],
    this.contexts = const <InteractionContext>[],
    this.modeledPushers = const <Pusher>[],
    this.note = '',
    this.isFlagged = false,
  });

  /// [Activity.id]. Null until [EditEntryDraftNotifier.loadFrom] runs.
  final int? activityId;

  /// [Interaction.interactionId] — what an eventual PATCH would address. Null
  /// for a [Note], which has no such field, and null before load.
  final int? interactionId;

  final DateTime? occurredAt;
  final Pusher? pusher;

  /// Empty for a [Note] — the domain type has no Buttons to hold.
  final List<Button> buttons;

  /// Empty for a [Note] and for the event-note pseudo-Pusher generally.
  final List<InteractionContext> contexts;

  /// Empty for a [Note] and for anything not attributed to a Teacher.
  final List<Pusher> modeledPushers;

  final String note;
  final bool isFlagged;

  bool get isLoaded => activityId != null;

  bool get isJournal => pusher?.kind == PusherKind.eventNote;

  bool get isTeacher => pusher?.isTeacher ?? false;

  List<String> get words => buttons.map((b) => b.text).toList(growable: false);

  /// The draft as an [Activity], for the same [UtteranceRow] the timeline
  /// draws — the one structural idea `log_details_screen.dart`'s `_Preview`
  /// established, carried over so an entry reads identically whether it is
  /// being composed or corrected. Null before [isLoaded].
  ///
  /// [Activity.id] is [activityId] itself: the preview stands in for the very
  /// row this screen edits, not a draft copy with a placeholder id the way
  /// [LogDraft.preview] needs one.
  Activity? get preview {
    final id = activityId;
    final who = pusher;
    if (id == null || who == null) return null;
    if (isJournal) {
      return Note(
        id: id,
        occurredAt: occurredAt!,
        pusher: who,
        body: note,
        isFlagged: isFlagged,
      );
    }
    return Interaction(
      id: id,
      interactionId: interactionId ?? id,
      occurredAt: occurredAt!,
      pusher: who,
      buttons: buttons,
      contexts: contexts,
      note: note,
      isFlagged: isFlagged,
      modeledPushers: modeledPushers,
    );
  }

  EditEntryDraft copyWith({
    int? activityId,
    int? interactionId,
    DateTime? occurredAt,
    Pusher? pusher,
    List<Button>? buttons,
    List<InteractionContext>? contexts,
    List<Pusher>? modeledPushers,
    String? note,
    bool? isFlagged,
  }) {
    return EditEntryDraft(
      activityId: activityId ?? this.activityId,
      interactionId: interactionId ?? this.interactionId,
      occurredAt: occurredAt ?? this.occurredAt,
      pusher: pusher ?? this.pusher,
      buttons: buttons ?? this.buttons,
      contexts: contexts ?? this.contexts,
      modeledPushers: modeledPushers ?? this.modeledPushers,
      note: note ?? this.note,
      isFlagged: isFlagged ?? this.isFlagged,
    );
  }
}

/// The edit draft, and the rules that change it — [LogDraftNotifier]'s
/// counterpart for an entry that already exists.
class EditEntryDraftNotifier extends Notifier<EditEntryDraft> {
  /// The snapshot [loadFrom] populated, kept to measure [isDirty] against.
  /// Not part of [state] itself: it never changes once set, so it does not
  /// belong to the value the screen renders.
  EditEntryDraft? _initial;

  @override
  EditEntryDraft build() => const EditEntryDraft();

  /// Populate from a fetched [Activity]. Idempotent for the Activity already
  /// loaded, so re-entering the same entry (a rebuild, a pop-and-return)
  /// cannot clobber edits in progress; a *different* id replaces the draft
  /// outright, the same as opening a different row would in the RN app.
  void loadFrom(Activity activity) {
    if (state.activityId == activity.id) return;

    final EditEntryDraft next = switch (activity) {
      Interaction i => EditEntryDraft(
        activityId: i.id,
        interactionId: i.interactionId,
        occurredAt: i.occurredAt,
        pusher: i.pusher,
        buttons: i.buttons,
        contexts: i.contexts,
        modeledPushers: i.modeledPushers,
        note: i.note,
        isFlagged: i.isFlagged,
      ),
      Note n => EditEntryDraft(
        activityId: n.id,
        occurredAt: n.occurredAt,
        pusher: n.pusher,
        note: n.body,
        isFlagged: n.isFlagged,
      ),
    };
    _initial = next;
    state = next;
  }

  /// Whether anything has changed since [loadFrom]. False before a load, which
  /// keeps SAVE disabled on every state that is not "an entry, loaded, with an
  /// edit made" — loading, not-found and freshly-opened are all included by
  /// construction rather than by a screen remembering to check three flags.
  bool get isDirty {
    final base = _initial;
    if (base == null) return false;
    return base.pusher?.id != state.pusher?.id ||
        base.note != state.note ||
        base.isFlagged != state.isFlagged ||
        base.occurredAt != state.occurredAt ||
        !listEquals(
          base.buttons.map((b) => b.id).toList(growable: false),
          state.buttons.map((b) => b.id).toList(growable: false),
        ) ||
        !listEquals(
          base.contexts.map((c) => c.id).toList(growable: false),
          state.contexts.map((c) => c.id).toList(growable: false),
        ) ||
        !listEquals(
          base.modeledPushers.map((p) => p.id).toList(growable: false),
          state.modeledPushers.map((p) => p.id).toList(growable: false),
        );
  }

  /// Re-assign the entry to a different Pusher, applying the same
  /// Learner/Teacher Context rules [LogDraftNotifier.selectPusher] applies —
  /// see the library note for why this fires only here and not from
  /// [loadFrom].
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
          .where((ctx) => ctx.text == logModeledContextText)
          .toList(growable: false);
    } else {
      contexts = state.contexts
          .where((ctx) => ctx.text != logModeledContextText)
          .toList(growable: false);
    }

    state = state.copyWith(
      pusher: pusher,
      contexts: contexts,
      modeledPushers: pusher.isTeacher
          ? state.modeledPushers
          : const <Pusher>[],
    );
  }

  /// Replace the whole selection at once — what LOG_ENTRY_EDIT_BUTTONS'
  /// UPDATE hands back (`updateSelectedButtons`, a closure in the RN app; a
  /// return value here, per `log_state.dart`'s note on why `LOG` and
  /// `LOG_DETAILS` share a provider instead).
  void setButtons(List<Button> buttons) =>
      state = state.copyWith(buttons: buttons);

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
        : (<Pusher>[...state.modeledPushers, pusher]
            ..sort((a, b) => a.id.compareTo(b.id)));
    state = state.copyWith(modeledPushers: next);
  }

  void setNote(String note) => state = state.copyWith(note: note);

  void toggleFlag() => state = state.copyWith(isFlagged: !state.isFlagged);

  /// Never forwards, the same bound `LogDraftNotifier.setOccurredAt` enforces.
  bool setOccurredAt(DateTime at, {required DateTime now}) {
    if (at.isAfter(now)) return false;
    state = state.copyWith(occurredAt: at);
    return true;
  }

  void setSeconds(int seconds) {
    final clamped = seconds.clamp(0, 59);
    final at = state.occurredAt;
    if (at == null) return;
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

  /// Back to nothing loaded — after the faked SAVE, so re-opening any entry
  /// (this one included) starts from a genuine fetch rather than the draft
  /// this session already had for it.
  void reset() {
    _initial = null;
    state = const EditEntryDraft();
  }
}

final NotifierProvider<EditEntryDraftNotifier, EditEntryDraft>
logEditDraftProvider = NotifierProvider<EditEntryDraftNotifier, EditEntryDraft>(
  EditEntryDraftNotifier.new,
);

// ─────────────────────────── Pusher eligibility ───────────────────────────

/// Who a press can be re-assigned to, for the entry currently being edited.
///
/// Reproduces `LogDetailsEditScreen.tsx`'s `onPusherPress` filter exactly:
/// hidden Pushers never appear, and the event-note pseudo-Pusher appears only
/// when the entry carries no Buttons — you can turn a buttonless press into a
/// journal note, but not one that says something (`:284-296`).
///
/// [journalPusher] is not on [pushersProvider]'s list — it is a wire sentinel,
/// carried separately as `journalPusherProvider` — so it is threaded in rather
/// than assumed to be part of [household].
List<Pusher> logEditEligiblePushers(
  List<Pusher> household, {
  required bool hasButtons,
  required Pusher journalPusher,
}) {
  final visible = household.where((p) => !p.isHidden).toList(growable: false);
  if (hasButtons) return visible;
  return <Pusher>[...visible, journalPusher];
}

/// The Contexts a given Pusher's press can carry — the same
/// `useContexts(teacher|learner)` switch every screen in this area makes.
List<InteractionContext> logEditContextsFor(WidgetRef ref, Pusher? pusher) {
  return (pusher?.isTeacher ?? false)
      ? logSyncContexts(ref, forTeacher: true)
      : logSyncContexts(ref, forTeacher: false);
}

/// Reads whichever Context list is already loaded, synchronously — every call
/// site is a tap handler, long after both lists have resolved.
List<InteractionContext> logSyncContexts(
  WidgetRef ref, {
  required bool forTeacher,
}) {
  final provider = forTeacher
      ? teacherContextsProvider
      : learnerContextsProvider;
  return ref.read(provider).value ?? const <InteractionContext>[];
}

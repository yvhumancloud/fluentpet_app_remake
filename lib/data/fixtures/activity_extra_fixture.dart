/// The history behind the one designed day.
///
/// `activity_fixture.dart` is a faithful port of
/// `design-system/src/screens/activity-data.ts`: eight entries on one day, and
/// nothing else. That is exactly right for checking the Activity screen against
/// its specification and exactly not enough for the five screens built on top
/// of it — pagination never pages, the day grouping never groups, a facet
/// screen has one row in it, and the Pusher statistics are computed from a
/// single afternoon.
///
/// `docs/design-system/screen-inventory.md` §15 says what the fixture owes:
///
/// > One in-memory list of ~120 Interactions covering: Base-origin unassigned,
/// > app-origin, a free-standing Note, flagged, multi-Button, with/without
/// > Contexts, long note, no note. A local
/// > slicer that honours `page`/`per_page` so infinite scroll is exercised;
/// > the last page short so `isLastPage` fires.
///
/// This file is that list. The slicer lives with the screens, in
/// `lib/screens/activity/data/`, because paging is a screen concern and this
/// file is only data.
///
/// ## Rules it keeps
///
/// * **The designed day is untouched.** [history] ends with
///   `activity_fixture.activities` verbatim, so 2026-08-19 renders exactly what
///   the specification draws. Everything generated sits on earlier days.
/// * **Ids never collide.** Activity ids here start at 9100; the designed day
///   uses 9001–9009.
/// * **Nothing here declares a Context or a Button.** Both catalogues are
///   shared — Contexts in `activity_fixture.dart`, Buttons in
///   `hardware_fixture.dart` — and this file draws from them by name. Dashboard
///   filtering matches Contexts by **id** and the Board is one Board, so a
///   second `InteractionContext` also called "evening", or a second Button also
///   called "walk", would silently split a facet in two. Both happened while
///   three areas each kept their own list.
/// * **Deterministic.** A fixed `Random(_seed)`, so the same 120 rows appear
///   every run and a screenshot taken twice is the same screenshot.
///
/// Nothing here is a port of anything — the RN app has no fixtures. It is
/// invented, believable data shaped like the API, and every value that had to
/// be chosen is chosen to make a state reachable rather than to look tidy.
library;

import 'dart:math';

import '../../domain/domain.dart';
import 'activity_fixture.dart' as designed;
import 'hardware_fixture.dart' as hardware;
import 'household_fixture.dart' as household;

// ─────────────────────────── the clock ───────────────────────────

/// The moment every screen renders against.
///
/// The designed day's own `asOf` — 2026-08-19 20:16 — so "Today" means the day
/// the specification drew and the elapsed rail's last gap is the real one.
final DateTime asOf = designed.asOf;

DateTime _at(int daysAgo, int hour, int minute) {
  final day = asOf.subtract(Duration(days: daysAgo));
  return DateTime(day.year, day.month, day.day, hour, minute);
}

// ─────────────────────────── Pushers ───────────────────────────

/// Every Pusher the Activity screens can encounter, pseudo-Pushers included.
///
/// Wider than the Household's own list only by the two sentinels: a
/// `DASHBOARD_PUSHER` deep link carries an id and nothing else, and one of those
/// ids can be -1 or -2. The five real Pushers are the Household's, from
/// `household_fixture.dart`, so the timeline cannot attribute an entry to
/// somebody the Household has never heard of.
final List<Pusher> allPushers = List<Pusher>.unmodifiable(<Pusher>[
  ...household.pushers,
  designed.eventNotePusher,
  designed.basePusher,
]);

/// The Pushers a filter list offers: the Household's, hidden ones included,
/// pseudo-Pushers excluded. Notes are filtered by their own tri-state control,
/// not by picking the event-note Pusher (`DashboardFilters.tsx:60-63`).
final List<Pusher> filterablePushers =
    List<Pusher>.unmodifiable(household.pushers);

// ─────────────────────────── Contexts ───────────────────────────

/// The Contexts a Learner's press can carry, and a Teacher's.
///
/// Both come from the one catalogue in `activity_fixture.dart`. They used to be
/// declared here *and* in `log_extra_fixture.dart`, with the ids overlapping —
/// "raining" and "morning" were both 601 — so a filter set on the Activity tab
/// matched a different Context from the one the Log screen had tagged.
List<InteractionContext> get learnerContexts => designed.learnerContexts;
List<InteractionContext> get teacherContexts => designed.teacherContexts;

// ─────────────────────────── the history ───────────────────────────

/// Fixed so the same history appears every run.
const int _seed = 20260819;

const List<String> _learnerVocabulary = <String>[
  'outside', 'now', 'food', 'play', 'water', 'come', 'love', 'you', 'bed',
  'walk', 'treat', 'later', 'please', 'scritches', 'mad',
];

const List<String> _teacherVocabulary = <String>[
  'walk', 'outside', 'water', 'treat', 'bed', 'play',
];

const List<String> _shortNotes = <String>[
  'Pressed twice before I got there.',
  'Stood by the door afterwards.',
  'Nudged the board with a paw, not a nose.',
  'Right after the postman.',
];

/// Deliberately long, and deliberately containing a line break: the RN app
/// truncated notes to two lines on iOS and not on Android
/// (`DashboardItem.tsx:271-275`). This rewrite truncates on neither — the note
/// is content — so the long case has to exist to prove the row grows.
const String _longNote =
    'Came in from the garden soaking wet, pressed all three, then went back to '
    'the door and pressed again when I did not move.\n'
    'Third time this week at roughly this hour, so I am starting to think it is '
    'the light going rather than anything I am doing.';

/// The Button that speaks [word], from the one Board.
Button _button(String word) =>
    hardware.board.buttons.firstWhere((b) => b.text == word);

/// Everything that has ever happened, newest **last**.
///
/// The designed day is appended verbatim at the end, so it is the most recent
/// day and the Activity screen opens on it.
final List<Activity> history = List<Activity>.unmodifiable(_build());

/// Everything, newest **first** — the order a paged timeline reads in.
final List<Activity> newestFirst = List<Activity>.unmodifiable(
  history.reversed.toList(growable: false),
);

List<Activity> _build() {
  final random = Random(_seed);
  final out = <Activity>[];
  var activityId = 9100;
  var interactionId = 100;

  // Thirteen days of history behind the designed day. Enough that a page size
  // of 45 pages three times and the last page comes up short, which is the
  // condition `isLastPage` turns on.
  for (var daysAgo = 13; daysAgo >= 1; daysAgo--) {
    // A quiet day and a busy day have to look different — that is the whole
    // argument for the elapsed rail. 3 to 13 entries.
    final entries = 3 + random.nextInt(11);
    var minutes = 6 * 60 + random.nextInt(90);

    for (var i = 0; i < entries; i++) {
      minutes += 12 + random.nextInt(150);
      if (minutes > 23 * 60 + 30) break;
      final hour = minutes ~/ 60;
      final minute = minutes % 60;
      final at = _at(daysAgo, hour, minute);
      final roll = random.nextInt(100);

      if (roll < 6) {
        // A free-standing Note: an Activity with no press behind it.
        out.add(Note(
          id: activityId++,
          occurredAt: at,
          pusher: designed.eventNotePusher,
          body: _noteBody(random),
          isFlagged: random.nextInt(10) == 0,
        ));
        continue;
      }

      final isTeacher = roll < 22;
      // A press the Base recorded that nobody has attributed yet. This is the
      // whole reason the Unassigned tab exists.
      final isUnassigned = !isTeacher && roll >= 22 && roll < 32;

      final pusher = isTeacher
          ? _pick(random, <Pusher>[
              designed.teacher,
              household.secondTeacher,
              if (daysAgo > 9) household.retiredTeacher,
            ])
          : isUnassigned
              ? designed.basePusher
              : _pick(random,
                  <Pusher>[designed.learner, household.secondLearner]);

      final vocabulary = isTeacher ? _teacherVocabulary : _learnerVocabulary;
      final wordCount = random.nextInt(100) < 62 ? 1 : 1 + random.nextInt(3);
      final words = <String>[];
      while (words.length < wordCount) {
        final word = vocabulary[random.nextInt(vocabulary.length)];
        if (!words.contains(word)) words.add(word);
      }
      // One press of the phrase Button, so the wrapping case is on the
      // timeline rather than only in the component gallery.
      if (daysAgo == 4 && i == 2) {
        words
          ..clear()
          ..add('I want to go outside right now please');
      }

      final contextPool = isTeacher ? teacherContexts : learnerContexts;
      final contextCount = switch (random.nextInt(10)) {
        0 || 1 || 2 => 0,
        3 || 4 || 5 || 6 => 1,
        7 || 8 => 2,
        _ => 3,
      };
      final contexts = <InteractionContext>[];
      while (contexts.length < contextCount) {
        final ctx = contextPool[random.nextInt(contextPool.length)];
        if (!contexts.contains(ctx)) contexts.add(ctx);
      }
      // A Teacher's press is modelling, and modelling is tagged "Modeled".
      if (isTeacher && !contexts.contains(teacherContexts.first)) {
        contexts.insert(0, teacherContexts.first);
      }

      final hasNote = random.nextInt(100) < 16;
      final isLongNote = hasNote && random.nextInt(4) == 0;

      // A Teacher's entry is typed into the app; everything else arrived from
      // a Base. One press on day 7 is the product of a split.
      final origin = isTeacher
          ? InteractionOrigin.app
          : (daysAgo == 7 && i == 1
              ? InteractionOrigin.interactionSplit
              : InteractionOrigin.base);

      // Bound before the constructor rather than incremented inside it: the
      // id is read twice — once as the Activity id and once to decide which
      // Base heard it — and `activityId++` in an argument list makes the answer
      // depend on argument order.
      final id = activityId++;

      out.add(Interaction(
        id: id,
        interactionId: interactionId++,
        occurredAt: at,
        // An unassigned press has no Contexts shown in the RN app
        // (`DashboardItem.tsx:265-270`); here it has none recorded at all,
        // which is the honest version of the same thing — nobody has said what
        // was going on because nobody has said who pressed.
        pusher: pusher,
        buttons: words.map(_button).toList(growable: false),
        contexts: isUnassigned ? const <InteractionContext>[] : contexts,
        origin: origin,
        // Which Base heard it, and when the row was written. Both are real
        // fields on `Interaction` now: the Base filter and the "recently
        // logged" sort each read one of them, and until they existed the
        // filter went through a `baseIdOf()` stand-in beside the data and the
        // sort was not implementable at all.
        baseId: _baseIdFor(origin, id),
        createdAt: _createdAtFor(origin, at, i),
        boardId: designed.boardId,
        deviceTimezone: 'Europe/London',
        note: hasNote
            ? (isLongNote ? _longNote : _pick(random, _shortNotes))
            : '',
        isFlagged: random.nextInt(100) < 11,
        modeledPushers: isTeacher
            ? <Pusher>[designed.learner]
            : const <Pusher>[],
        // A word pressed for the first time. Rare on purpose: the accent
        // underline is the only accent on the timeline and it has to mean
        // something when it appears.
        firstTimeWord: !isTeacher && random.nextInt(100) < 5 ? words.last : null,
      ));
    }
  }

  // The designed day, verbatim and last. Everything above is earlier.
  out.addAll(designed.activities);
  return out;
}

// ──────────────────── which Base, and when it was written ────────────────────

/// The Base a press came from, or null when it did not come from one.
///
/// Deterministic and not random: even activity ids are the Kitchen Base, odd
/// ones the Porch Base. An entry logged in the app came from no Base at all.
int? _baseIdFor(InteractionOrigin origin, int activityId) {
  if (origin == InteractionOrigin.app) return null;
  return activityId.isEven ? designed.kitchenBase.id : designed.porchBase.id;
}

/// When the row was written, as against when the press happened.
///
/// A Base uploads as it goes, so `created_at` trails `occurred_at` by seconds.
/// A person typing an entry in afterwards is hours behind — which is the whole
/// difference between "recently pressed" and "recently logged", and the reason
/// the two sort orders are visibly different lists rather than the same one
/// twice. The lag varies with the entry's position in its day so the two orders
/// interleave rather than shifting as a block.
DateTime _createdAtFor(InteractionOrigin origin, DateTime at, int index) {
  if (origin != InteractionOrigin.app) {
    return at.add(const Duration(seconds: 2));
  }
  return at.add(Duration(minutes: 20 + (index * 37) % 300));
}

String _noteBody(Random random) => switch (random.nextInt(4)) {
      0 => 'Vet said the limp is nothing. Back to normal walks from tomorrow.',
      1 => 'Rearranged the board this morning — “outside” moved to the top row.',
      2 => 'Quiet day; we were out from lunchtime.',
      _ => 'Guests over, so the board was busier than usual all afternoon.',
    };

T _pick<T>(Random random, List<T> from) => from[random.nextInt(from.length)];

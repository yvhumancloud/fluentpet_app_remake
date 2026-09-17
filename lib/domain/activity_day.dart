import '../format/fp_format.dart';
import 'activity.dart';
import 'dashboard.dart';

/// One day of the timeline, as the Activity screen consumes it.
///
/// Invented for the rewrite — there is no such thing in the RN app, where the
/// feed is a flat infinite list. It exists because the designed Activity screen
/// (`design-system/src/screens/ActivityScreen.astro`) is built around a day: a
/// short label and a long one in the header, a summary line under it, and the
/// rail between entries carrying real elapsed time.
///
/// [asOf] is the clock the screen renders against. It is a field rather than
/// `DateTime.now()` so a fixture renders identically every time it is opened;
/// a live implementation passes the real clock.
class ActivityDay {
  const ActivityDay({
    required this.label,
    required this.longLabel,
    required this.asOf,
    required this.activities,
  });

  /// "Today".
  final String label;

  /// "Wednesday 19 August".
  final String longLabel;

  final DateTime asOf;

  /// Newest last, as the timeline reads top to bottom.
  final List<Activity> activities;

  /// The elapsed gap between entry [index] and the one after it, e.g.
  /// "1 h 12 min". Null for the last entry.
  ///
  /// Real gaps, not decoration: a quiet day and a busy hour have to look
  /// different, which is the whole argument for the rail.
  ///
  /// The label itself is [FpFormat.elapsedBetween]'s, not this method's. It
  /// used to be written out here, and then three screens needed the same rule
  /// for gaps that are not between two rows of one day — so the rule moved to
  /// the one place that owns formatting and this delegates. `fp_format.dart`
  /// imports nothing, Flutter included; it is pure string arithmetic, which is
  /// why the domain can depend on it.
  ///
  /// It lives in `lib/format/` rather than `lib/widgets/` for exactly that
  /// reason: this line used to make the domain depend on the widget layer, and
  /// the direction was wrong however harmless the file was. `lib/widgets/` still
  /// exports it, so every screen reaches it through `widgets.dart` as before.
  ///
  /// One behaviour changed in the move: a gap under a minute now reads
  /// "< 1 min" rather than "0 min".
  String? elapsedAfter(int index) {
    if (index < 0 || index >= activities.length - 1) return null;
    return FpFormat.elapsedBetween(
      activities[index].occurredAt,
      activities[index + 1].occurredAt,
    );
  }

  /// Learner utterances, multi-word ones among them, and words pressed for the
  /// first time. Teacher modelling is deliberately not counted.
  DashboardSummary get summary {
    final learnerUtterances = activities
        .whereType<Interaction>()
        .where((i) => i.pusher.isLearner)
        .toList(growable: false);
    return DashboardSummary(
      utterances: learnerUtterances.length,
      multiWord: learnerUtterances.where((i) => i.isMultiPress).length,
      firstTimes: activities
          .whereType<Interaction>()
          .where((i) => i.firstTimeWord != null)
          .length,
    );
  }
}

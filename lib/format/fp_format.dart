/// Every string the screens have to build out of a number, a date or a
/// duration, as pure functions in one place.
///
/// Three screens are being built in parallel and all three need to say when
/// something happened, how long a gap was, and how full a battery is. Three
/// private helpers would be three answers to the same question, drifting
/// apart the way the old app's two battery scales did — 7 buckets on a Base,
/// 3 on a Button, different thresholds, same product
/// (`docs/design-system/screen-inventory.md` §8). So the rules live here, each
/// one documented with where it comes from.
///
/// Nothing in this file imports Flutter. These are strings and numbers in,
/// strings and numbers out: no widget, no `BuildContext`, no colour, no state.
/// That is what makes them checkable later without a rendering test.
///
/// It sits in `lib/format/` rather than in `lib/widgets/`, because the domain
/// uses it — `ActivityDay.elapsedAfter` delegates here — and the fixtures name
/// its battery sentinel. Under `lib/widgets/` that made `lib/domain` depend on
/// `lib/widgets`, which is the wrong direction whatever the file imports.
/// `widgets.dart` still exports it, so `import '.../widgets/widgets.dart'`
/// reaches it exactly as before and no screen had to change.
///
/// ## What is deliberately not here
///
/// **Tabular numerals.** Several of these produce a number that changes while
/// someone is looking at it — the battery percent in the header, the elapsed
/// gap, a last-seen ladder ticking over. The design's answer is tabular
/// figures, and that is a `TextStyle` property: use `.tabular` from
/// `theme/fp_context.dart` at the call site. A formatter cannot carry it.
///
/// **Localisation.** English month and weekday names, 24-hour clock, and no
/// `intl` package. The RN app localised through moment and read the device's
/// 12/24-hour preference (`src/hooks/use24hourClock`); phase 1 has neither, and
/// every time in the design system is drawn 24-hour ("08:04", "13:58",
/// "21:30"). When localisation lands it lands here, in one file.
library;

/// The formatting rules, as static functions.
class FpFormat {
  const FpFormat._();

  // ───────────────────────── pluralisation ─────────────────────────

  /// The right form of a word for [count]. "1 utterance", "7 utterances" —
  /// never "1 utterance(s)".
  ///
  /// Components page, Summary line: *"Pluralise properly. '1 utterance', not
  /// '1 utterances' and not '1 utterance(s)'."* The rule was solved once
  /// inside that component; it is a primitive, so it lives here and every
  /// screen gets it.
  ///
  /// The default plural is [singular] with an "s". Pass [irregularPlural] for
  /// anything that is not — "Pusher"/"Pushers" is regular, "person"/"people"
  /// is not.
  static String pluralWord(
    int count,
    String singular, [
    String? irregularPlural,
  ]) =>
      count == 1 ? singular : (irregularPlural ?? '${singular}s');

  /// [count] and its noun together: "1 utterance", "0 utterances".
  ///
  /// Zero takes the plural, which is correct English and is why this is not
  /// simply `count > 1`.
  static String countOf(
    int count,
    String singular, [
    String? irregularPlural,
  ]) =>
      '$count ${pluralWord(count, singular, irregularPlural)}';

  // ───────────────────────── large numbers ─────────────────────────

  /// A count as a header shows it: plain under a thousand, `1.5k` above it.
  ///
  /// The RN app runs **every count in every header and in the Pusher stats**
  /// through `formatLargeNumber` (`src/helpers/formatLargeNumber.ts`,
  /// `docs/design-system/screen-inventory.md` §2, §13.2). The rule is
  /// reproduced exactly, its rounding included:
  ///
  /// * Under 1000 → the number itself. `999` stays `999`.
  /// * 1000 and over → thousands to **one decimal, truncated after rounding to
  ///   three**: `1500` → `1.5k`, `6380` → `6.3k`, `22699` → `22.6k`.
  /// * A trailing `.0` goes: `11000` → `11k`, `500000` → `500k`.
  ///
  /// Negative counts are returned unchanged. There is no such thing as a
  /// negative number of presses, and inventing `-1.5k` would only hide the bug
  /// that produced it.
  static String largeNumber(int count) {
    if (count < _thousand) return '$count';

    // toFixed(3) then drop two characters is the RN expression, and it is not
    // the same as rounding to one decimal: 22699/1000 is 22.699, which becomes
    // "22.6" here and "22.7" under ordinary rounding. The API's numbers and
    // the app's have to agree, so this agrees with the app.
    final thousands = (count / _thousand).toStringAsFixed(3);
    final oneDecimal = thousands.substring(0, thousands.length - 2);
    return oneDecimal.endsWith('0')
        ? '${oneDecimal.substring(0, oneDecimal.length - 2)}k'
        : '${oneDecimal}k';
  }

  /// [count] in [largeNumber] form with its noun: "1.5k presses", "1 press".
  ///
  /// The plural is decided by the real count, never by the abbreviated string —
  /// "1.0k press" would be the bug this exists to avoid.
  static String largeCountOf(
    int count,
    String singular, [
    String? irregularPlural,
  ]) =>
      '${largeNumber(count)} ${pluralWord(count, singular, irregularPlural)}';

  static const int _thousand = 1000;

  // ───────────────────────── time of day ─────────────────────────

  /// A press time as it appears in the timeline's rail: 24-hour "HH:MM",
  /// local.
  ///
  /// 24-hour because that is what the specification draws, and zero-padded
  /// because the rail is a fixed 44px mono column that must not reflow between
  /// "09:16" and "13:58". Local because a press happened where the pet is.
  ///
  /// This was `UtteranceRow.formatTime`, which still forwards here. A row
  /// widget is the wrong owner for a rule three screens need.
  static String timeOfDay(DateTime at) {
    final local = at.toLocal();
    return '${pad2(local.hour)}:${pad2(local.minute)}';
  }

  /// The same time with its seconds: 24-hour "HH:MM:SS", local.
  ///
  /// A press carries a second on the wire and the log screens let one be
  /// entered, so there has to be a form that can say it. Everything the
  /// timeline shows drops to [timeOfDay] — a second is noise when you are
  /// reading a day — and everything that edits or verifies an exact moment
  /// uses this one.
  static String timeOfDayWithSeconds(DateTime at) {
    final local = at.toLocal();
    return '${timeOfDay(local)}:${pad2(local.second)}';
  }

  /// A number as two digits: `7` → "07", `19` → "19".
  ///
  /// Public because the seconds field on `LOG_DETAILS` is a two-digit field
  /// and was padding its own text; anything that lays digits out in a fixed
  /// column needs the same rule, and two implementations of it would be one
  /// too many. Values of three digits or more are returned whole rather than
  /// truncated — losing a digit is worse than breaking an alignment.
  static String pad2(int value) => value.toString().padLeft(2, '0');

  // ───────────────────────── dates in words ─────────────────────────

  /// "Thursday".
  static String weekdayName(DateTime day) =>
      _weekdays[day.toLocal().weekday - 1];

  /// "August".
  static String monthName(DateTime day) => _months[day.toLocal().month - 1];

  /// "19 August", gaining a year — "19 August 2025" — when [day] falls in a
  /// different year from [asOf].
  ///
  /// The year is conditional rather than always-on because it is noise on the
  /// day you are looking at and essential the moment you are not.
  static String dayAndMonth(DateTime day, {DateTime? asOf}) {
    final local = day.toLocal();
    final base = '${local.day} ${monthName(local)}';
    if (asOf == null || local.year == asOf.toLocal().year) return base;
    return '$base ${local.year}';
  }

  /// "Wednesday 19 August", with the same conditional year as [dayAndMonth].
  ///
  /// Components page, Screen header: *"The subtitle is the full date in words.
  /// 'Today' alone is ambiguous once the user scrolls into history."*
  static String fullDate(DateTime day, {DateTime? asOf}) =>
      '${weekdayName(day)} ${dayAndMonth(day, asOf: asOf)}';

  /// "Today", "Yesterday", "Tomorrow" — or null when [day] is none of those.
  ///
  /// Null rather than a fallback string, so a caller has to decide what to say
  /// instead rather than getting a silent default. [dayTitle] is that
  /// decision, made once.
  ///
  /// Compared by calendar day in local time, not by elapsed hours: 23:50 and
  /// 00:10 are twenty minutes apart and are still different days.
  static String? relativeDay(DateTime day, {required DateTime asOf}) {
    final difference = _calendarDaysBetween(asOf, day);
    return switch (difference) {
      0 => 'Today',
      -1 => 'Yesterday',
      1 => 'Tomorrow',
      _ => null,
    };
  }

  /// What goes in a screen header's **title** for a day.
  ///
  /// "Today" and "Yesterday" where they apply; the bare weekday inside the
  /// last week, because "Tuesday" is still unambiguous that recently; the date
  /// beyond that. Pairs with [daySubtitle], which says whatever this did not.
  ///
  /// The design draws both halves of the pair: `title="Today"
  /// subtitle="Wednesday 19 August"` and `title="Tuesday" subtitle="17 August"`.
  static String dayTitle(DateTime day, {required DateTime asOf}) {
    final relative = relativeDay(day, asOf: asOf);
    if (relative != null) return relative;

    final difference = _calendarDaysBetween(asOf, day);
    if (difference < 0 && difference > -_daysInAWeek) return weekdayName(day);
    return dayAndMonth(day, asOf: asOf);
  }

  /// What goes under a [dayTitle], and never repeats it.
  ///
  /// After "Today" the subtitle carries the whole date, weekday included —
  /// that is the ambiguity rule. After "Tuesday" the weekday is already said,
  /// so the subtitle drops to "17 August". After a bare date the title has
  /// said everything and the subtitle is empty.
  static String daySubtitle(DateTime day, {required DateTime asOf}) {
    final title = dayTitle(day, asOf: asOf);
    if (title == dayAndMonth(day, asOf: asOf)) return '';
    if (title == weekdayName(day)) return dayAndMonth(day, asOf: asOf);
    return fullDate(day, asOf: asOf);
  }

  // ───────────────────────── elapsed gaps ─────────────────────────

  /// The gap between two consecutive Interactions, as the elapsed rail shows
  /// it: "22 min", "3 h 27 min", "1 h".
  ///
  /// The units are "min" and "h", which is what the specification's own
  /// fixture produces (`design-system/src/screens/activity-data.ts`) and what
  /// the one fully designed screen was drawn against. Not "mins", not "hrs" —
  /// abbreviations do not take a plural.
  ///
  /// Thresholds, chosen here and stated once:
  ///
  /// * **Under a minute → "< 1 min".** Truncated whole minutes would render
  ///   "0 min", which reads as a defect rather than as two presses in quick
  ///   succession. The fixture never produces it, because presses that close
  ///   together are grouped into one Interaction by the Base — but a
  ///   configurable grouping window means it is reachable.
  /// * **Under an hour → minutes only.** "47 min", not "0 h 47 min".
  /// * **An hour and over → hours, plus minutes when there are any.** "1 h",
  ///   not "1 h 0 min".
  /// * **A day and over → days, plus hours when there are any.** Defensive:
  ///   the timeline is bounded by a day, so this is for a caller that hands
  ///   over something else rather than for the rail.
  ///
  /// Everything truncates and nothing rounds up. A gap is reported as at least
  /// what it was, never as more — "3 h 27 min" is 3:27:00 through 3:27:59.
  static String elapsedGap(Duration gap) {
    if (gap.inMinutes < 1) return '< 1 min';
    if (gap.inHours < 1) return '${gap.inMinutes} min';

    if (gap.inDays < 1) {
      final minutes = gap.inMinutes % Duration.minutesPerHour;
      return minutes == 0
          ? '${gap.inHours} h'
          : '${gap.inHours} h $minutes min';
    }

    final hours = gap.inHours % Duration.hoursPerDay;
    return hours == 0 ? '${gap.inDays} d' : '${gap.inDays} d $hours h';
  }

  /// [elapsedGap] between two timestamps, or null when there is no gap to
  /// report.
  ///
  /// Null when [to] is not after [from]. Components page, Elapsed-time rail:
  /// *"Null renders nothing, including no padding."* — so a caller can hand
  /// the result straight to `ElapsedRail(gap: ...)` and the last row of a day
  /// ends cleanly.
  static String? elapsedBetween(DateTime from, DateTime to) {
    final gap = to.difference(from);
    return gap.isNegative || gap == Duration.zero ? null : elapsedGap(gap);
  }

  // ───────────────── the Base's press-grouping window ─────────────────

  /// The narrowest and widest grouping windows the API accepts.
  ///
  /// The RN app validates this field at 0–3600 inclusive, with the message
  /// *"Interaction timing must be a number between 0 and 3600"*
  /// (`src/Home/Base/helpers/validateInteractionTiming.ts`). Reproduced rather
  /// than re-derived: the backend enforces it too, and a client that allowed
  /// more would only fail later.
  static const int groupingWindowMinSeconds = 0;
  static const int groupingWindowMaxSeconds = 3600;

  /// The Base's press-grouping window, spelled out: "30 seconds",
  /// "1 minute 30 seconds", "1 hour".
  ///
  /// Presses inside this window become one Interaction. The explanatory screen
  /// (`BASE_EDIT_INTERACTION_TIMING`) sets it in prose and suggests 30s for a
  /// slow talker, so the words are spelled out in full — "30 seconds", not
  /// "30 s" — and pluralised properly through [countOf].
  ///
  /// Whole units collapse: 120 is "2 minutes", not "2 minutes 0 seconds".
  /// 3600, the maximum, is "1 hour" rather than "60 minutes".
  static String groupingWindow(int seconds) {
    if (seconds < Duration.secondsPerMinute) return countOf(seconds, 'second');

    final wholeHours = seconds ~/ Duration.secondsPerHour;
    final remainderOfHour = seconds % Duration.secondsPerHour;
    if (wholeHours > 0 && remainderOfHour == 0) {
      return countOf(wholeHours, 'hour');
    }

    final minutes = seconds ~/ Duration.secondsPerMinute;
    final remainder = seconds % Duration.secondsPerMinute;
    if (remainder == 0) return countOf(minutes, 'minute');
    return '${countOf(minutes, 'minute')} ${countOf(remainder, 'second')}';
  }

  // ───────────────────────── battery ─────────────────────────

  /// The one battery scale.
  ///
  /// The old app had two and they disagreed
  /// (`docs/design-system/screen-inventory.md` §8): a Base ran through seven
  /// buckets at >90 / >64 / >45 / >20 / ≥0 / charging / unavailable, while a
  /// Button in the linked-Button list ran through three at ≥25 / ≥10 / ≥0.
  /// A Button at 15% was drawn a whole bucket healthier than a Base at 15%,
  /// for no reason anyone could state.
  ///
  /// This is three values, and the same three for a Base and for a Button.
  /// The design system specifies exactly one battery distinction — the pill's
  /// warning tone at or below [lowBatteryPercent] — so a scale with more steps
  /// than that would be inventing states nothing draws.
  static FpBatteryLevel batteryLevel(int? percent) {
    if (percent == null || percent < 0) return FpBatteryLevel.unknown;
    return percent <= lowBatteryPercent
        ? FpBatteryLevel.low
        : FpBatteryLevel.ok;
  }

  /// At or below this percent a battery is low. **The** threshold: a Base and
  /// a Button use this one number, and `DeviceHealthPill.lowBatteryThreshold`
  /// forwards to it rather than restating it.
  ///
  /// 20 is kept from the old app because it is the only one of its thresholds
  /// with a reason attached — the comment beside it reads *"backend reports to
  /// user at this level"* (`src/components/BatteryLevel/BatteryLevel.tsx:24`).
  /// The app should not go quiet about a battery the backend is already
  /// emailing about, and it should not cry earlier than the backend either.
  /// The other six boundaries carried no such argument and are dropped.
  static const int lowBatteryPercent = 20;

  /// True when [percent] is at or below [lowBatteryPercent]. An unknown level
  /// is not low — it is unknown, and saying "low" would be a guess.
  static bool isLowBattery(int? percent) =>
      batteryLevel(percent) == FpBatteryLevel.low;

  /// "87%".
  ///
  /// Components page, Device health pill: *"The percent is tabular so the
  /// header does not twitch as it ticks down."* — the digits are the caller's
  /// job, through `TextStyle.tabular`; the per-cent sign is this one's.
  static String batteryPercent(int percent) => '$percent%';

  /// The wire's charging sentinel.
  ///
  /// `battery_level == -1` means charging in the old app
  /// (`BatteryLevel.tsx`). Nothing in the design system draws a charging Base,
  /// so no charging state is invented here: [batteryLevel] reports it as
  /// [FpBatteryLevel.unknown], which is at least true and is never a number
  /// that stopped meaning anything. Mapping the sentinel to something better
  /// belongs to the integration phase, with the rest of the wire's oddities.
  static const int chargingWireSentinel = -1;

  // ───────────────────────── last seen ─────────────────────────

  /// When a Base was last online, relative to [asOf].
  ///
  /// New: `last_online_at` is not shown on the Hardware list at all in the old
  /// app — it appears only inside the Base edit screen, through the same
  /// component the timeline uses, as an absolute date plus a relative age
  /// (`docs/design-system/screen-inventory.md` §9, §10). A list that answers
  /// "is my Base healthy" and cannot say when it was last heard from is
  /// answering half the question.
  ///
  /// The ladder, and why each rung is where it is:
  ///
  /// * **null → "Never seen".** A Base that has never reported is a different
  ///   thing from one that reported a long time ago.
  /// * **Under a minute → "Just now".** Below a minute the number is noise.
  /// * **Under an hour → "6 min ago".** Matches the design fixture's
  ///   "2 min ago" exactly.
  /// * **Under a day → "3 h ago".** Same units as [elapsedGap], because the
  ///   two appear on screens a tab apart and different abbreviations for the
  ///   same hour would read as different quantities. Hours run the whole first
  ///   24, past midnight included: "5 h ago" is more use than "Yesterday" when
  ///   it is one in the morning.
  /// * **Past 24 hours → calendar days.** "Yesterday", then "3 days ago".
  ///   Counted date-to-date rather than in 24-hour blocks, so a reading from
  ///   Tuesday evening is "2 days ago" on Thursday morning however the hours
  ///   fall.
  /// * **Beyond that → the date.** "on 19 August", gaining a year across a
  ///   year boundary. "47 days ago" is arithmetic, not information; past a
  ///   week the actual date is what a person can act on.
  static String lastSeen(DateTime? at, {required DateTime asOf}) {
    if (at == null) return 'Never seen';

    final age = asOf.difference(at);

    // A clock that has run backwards, or a reading from the future. Reporting
    // it as an age would produce a negative one.
    if (age.isNegative) return 'Just now';

    if (age.inMinutes < 1) return 'Just now';
    if (age.inHours < 1) return '${age.inMinutes} min ago';
    if (age.inDays < 1) return '${age.inHours} h ago';

    final days = -_calendarDaysBetween(asOf, at);
    if (days <= 1) return 'Yesterday';
    if (days < _daysInAWeek) return '${countOf(days, 'day')} ago';
    return 'on ${dayAndMonth(at, asOf: asOf)}';
  }

  // ───────────────────────── internals ─────────────────────────

  /// A week, as the boundary between "3 days ago" and a date. Named because
  /// both [dayTitle] and [lastSeen] turn on it and they must turn together.
  static const int _daysInAWeek = 7;

  /// Whole calendar days from [from] to [to], in local time. Negative when
  /// [to] is in the past.
  ///
  /// Compared date-to-date rather than by elapsed hours, so 23:50 and 00:10
  /// are one day apart rather than zero.
  static int _calendarDaysBetween(DateTime from, DateTime to) {
    final a = _midnight(from);
    final b = _midnight(to);
    return b.difference(a).inDays;
  }

  static DateTime _midnight(DateTime at) {
    final local = at.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  /// Monday first, matching [DateTime.weekday]'s 1–7.
  static const List<String> _weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
}

/// How full a battery is, on the one scale.
///
/// Three values, not seven and not three-with-other-thresholds. See
/// [FpFormat.batteryLevel] for what the old app had and why this replaces it.
enum FpBatteryLevel {
  /// No reading, or the charging sentinel. Not the same as empty.
  unknown,

  /// At or below [FpFormat.lowBatteryPercent].
  low,

  /// Above it. The design draws no further distinction, so neither does this.
  ok,
}

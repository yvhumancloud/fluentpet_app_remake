import 'package:flutter/material.dart';

import '../domain/domain.dart';
import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import '../format/fp_format.dart';
import 'fp_metrics.dart';

/// The day's counts, under the Screen header: how much was said, how much of
/// it was multi-word, and how many words were pressed for the first time.
///
/// Rules it owes:
///
/// * Pluralise properly. "1 utterance", never "1 utterances" and never
///   "1 utterance(s)".
/// * Zero is its own sentence. "0 utterances · 0 multi-word" reads as a broken
///   screen rather than a quiet day.
/// * **The zero sentence is date-aware.** Today's is "Nothing pressed yet
///   today"; any past day's is "Nothing pressed". The word "yet" promises the
///   day can still change, which is a lie about a day that is over — and the
///   Activity header can be showing a fortnight-old day whenever a timeframe
///   filter is set. Pass [isToday]; it defaults to true, which is the
///   overwhelmingly common case and what every existing call site meant.
/// * The new-word clause disappears at zero rather than showing a nought. It
///   is the only accent-coloured text on the screen and has to mean something
///   when it appears.
/// * Counts describe the Learner. Teacher Interactions are excluded before
///   they reach this widget — `ActivityDay.summary` does that.
/// * Numerals are tabular, so the line does not shift as counts tick over.
/// * The separators are punctuation and are hidden from assistive technology,
///   with real spaces around them.
class SummaryLine extends StatelessWidget {
  const SummaryLine({
    required this.count,
    required this.multi,
    this.firstTimes = 0,
    this.isToday = true,
    super.key,
  });

  /// The same three numbers, as the domain already computes them.
  SummaryLine.of(DashboardSummary summary, {this.isToday = true, super.key})
    : count = summary.utterances,
      multi = summary.multiWord,
      firstTimes = summary.firstTimes;

  /// Learner utterances today.
  final int count;

  /// How many of those were multi-press.
  final int multi;

  /// Words pressed for the first time.
  final int firstTimes;

  /// Whether the day being summarised is the current one.
  ///
  /// Only the zero sentence reads it: "Nothing pressed yet today" against
  /// "Nothing pressed". Optional, and true by default, because the Activity
  /// header's unfiltered case is today and because a required flag here would
  /// have broken every call site at once.
  final bool isToday;

  /// The quiet-day sentence for a day that is still running.
  static const String zeroToday = 'Nothing pressed yet today';

  /// The quiet-day sentence for a day that is over. No "yet": nothing more is
  /// going to arrive on it.
  static const String zeroPastDay = 'Nothing pressed';

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final base = FpType.labelMd.copyWith(color: c.textSecondary);

    if (count == 0) {
      return Text(
        isToday ? zeroToday : zeroPastDay,
        style: base.copyWith(color: c.textTertiary),
      );
    }

    final number = base.copyWith(color: c.textPrimary).tabular;
    final separator = base
        .copyWith(
          color: c.textTertiary.withValues(alpha: FpMetrics.separatorOpacity),
        )
        .tabular;

    final utterances = FpFormat.pluralWord(count, 'utterance');
    final newWords = FpFormat.pluralWord(firstTimes, 'word');

    final spoken = StringBuffer()
      ..write('$count $utterances, ')
      ..write('$multi multi-word');
    if (firstTimes > 0) {
      spoken.write(', $firstTimes new $newWords');
    }

    return Semantics(
      label: spoken.toString(),
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            style: base,
            children: <InlineSpan>[
              TextSpan(text: '$count', style: number),
              TextSpan(text: ' $utterances'),
              TextSpan(text: ' · ', style: separator),
              TextSpan(text: '$multi', style: number),
              const TextSpan(text: ' multi-word'),
              if (firstTimes > 0) ...<InlineSpan>[
                TextSpan(text: ' · ', style: separator),
                TextSpan(
                  text: '$firstTimes new $newWords',
                  style: base.copyWith(color: c.accentFg).tabular,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

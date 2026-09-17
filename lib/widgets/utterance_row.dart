import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../domain/domain.dart';
import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import 'context_list.dart';
import 'flag_marker.dart';
import '../format/fp_format.dart';
import 'fp_metrics.dart';
import 'note_block.dart';
import 'pusher_avatar.dart';

/// One Interaction on the timeline: the words a Pusher pressed, when, by whom,
/// in what Contexts, with any note and flag. It composes [PusherAvatar],
/// [ContextList], [NoteBlock] and [FlagMarker], and owns no colour of its own
/// beyond the two type ramps below.
///
/// The words are the content of this app and everything else on the row is
/// apparatus around them. A Learner's words are Fraunces at display-sm in
/// primary; a Teacher's drop to heading-md in secondary and gain an explicit
/// "modelled this" line. That recession is a rule: a human modelling a word is
/// context, not the thing the user opened the app to read.
///
/// The middot between words is a **press boundary**, not decoration and not a
/// comma. A multi-word utterance is several discrete Button presses that the
/// Base grouped into one Interaction with its grouping window, and the dots
/// mark where one press ended and the next began. There is never one for a
/// single word, and never one inside a phrase that lives on one Button.
///
/// A first-time word carries an amber underline and nothing else — no badge,
/// no colour on the word itself, no animation. The count is reported once, in
/// the Summary line.
///
/// The attribution line under the words is decided by [PusherKind], not by
/// "is this a Learner". There are four kinds and only one of them models: a
/// Teacher gets "*name* modelled this", the `base` pseudo-Pusher — a press the
/// Base recorded that nobody has attributed — gets [unattributedLine], and a
/// Learner gets neither, because the words are already theirs. Reading the
/// question as `!pusher.isLearner` made every unattributed press claim that
/// somebody called "base" had modelled it.
///
/// The row never truncates. A long utterance wraps; it is the content.
///
/// With [words] empty this renders a free-standing Note, the other member of
/// the Activity supertype.
class UtteranceRow extends StatelessWidget {
  const UtteranceRow({
    required this.at,
    required this.words,
    required this.pusher,
    this.contexts = const <String>[],
    this.note,
    this.flagged = false,
    this.firstTimeWord,
    this.onTap,
    super.key,
  });

  /// The row for one [Activity], sealed subtype and all.
  ///
  /// Here rather than in three screens so the timestamp is formatted once and
  /// so a [Note] and an [Interaction] cannot drift into two different rows.
  factory UtteranceRow.activity(
    Activity activity, {
    VoidCallback? onTap,
    Key? key,
  }) {
    return switch (activity) {
      Interaction(
        :final occurredAt,
        :final words,
        :final pusher,
        :final contexts,
        :final note,
        :final isFlagged,
        :final firstTimeWord,
      ) =>
        UtteranceRow(
          at: formatTime(occurredAt),
          words: words,
          pusher: pusher,
          contexts: contexts.map((ctx) => ctx.text).toList(growable: false),
          note: note.isEmpty ? null : note,
          flagged: isFlagged,
          firstTimeWord: firstTimeWord,
          onTap: onTap,
          key: key,
        ),
      Note(:final occurredAt, :final pusher, :final body, :final isFlagged) =>
        UtteranceRow(
          at: formatTime(occurredAt),
          words: const <String>[],
          pusher: pusher,
          note: body,
          flagged: isFlagged,
          onTap: onTap,
          key: key,
        ),
    };
  }

  /// 24-hour "HH:MM", which is what the rail's mono column is measured for.
  ///
  /// The rule moved to [FpFormat.timeOfDay] once three screens needed it — a
  /// row widget is the wrong owner for it. This forwards rather than
  /// duplicating, and stays because the timeline reads better calling it here.
  static String formatTime(DateTime at) => FpFormat.timeOfDay(at);

  /// The timestamp as it appears in the rail.
  final String at;

  /// The words pressed, in press order. Empty renders a free-standing Note.
  final List<String> words;

  final Pusher pusher;
  final List<String> contexts;
  final String? note;
  final bool flagged;

  /// A word this Learner has not pressed before. Underlined in accent, and
  /// nothing else.
  final String? firstTimeWord;

  /// The whole row is the tap target — the 24px avatar is decoration and is
  /// well below a 44px touch target on its own.
  final VoidCallback? onTap;

  /// What the row says under a press the Base recorded and nobody has claimed.
  ///
  /// Stated here rather than on the Activity screen, because every surface that
  /// draws an Interaction can be handed one of these — the timeline, the log
  /// preview, the gallery — and three wordings for one fact is how a product
  /// stops sounding like itself.
  static const String unattributedLine = 'Nobody attributed this press';

  /// The glue that pins the flag to the last word. See [FlagMarker.glue] —
  /// U+2060 WORD JOINER, and the note there says why it is not U+00A0.
  static const String flagGlue = FlagMarker.glue;

  /// The glue and the marker as one inseparable pair.
  ///
  /// A [FlagMarker.inlineSpans] pair rather than a [WidgetSpan], because a
  /// placeholder is an unconditional break opportunity in Skia and no glue
  /// character in front of one can hold it. Proved in `test/flag_pin_test.dart`.
  ///
  /// Exposed rather than written out at each call site so there is exactly one
  /// place the marker in running text is constructed, and so the test lays out
  /// *this* list rather than a copy of it. A copy would keep passing after
  /// someone changed the real one back.
  ///
  /// Carries no semantics: both call sites below say "flagged" themselves.
  static List<InlineSpan> flagSpans(Color color) =>
      FlagMarker.inlineSpans(color: color);

  /// The words, their press boundaries and — when [flagged] — the pinned flag,
  /// as the one span list [_Utterance] paints.
  ///
  /// Public and static only so the line-breaking test can lay out the real
  /// thing. Nothing else should call it: the widget is the interface.
  static List<InlineSpan> utteranceSpans({
    required List<String> words,
    required bool flagged,
    required Color flagColor,
    String? firstTimeWord,
    TextStyle? boundaryStyle,
    TextStyle? firstTimeStyle,
  }) {
    return <InlineSpan>[
      for (var i = 0; i < words.length; i++) ...<InlineSpan>[
        // Never for a single word: there was no boundary to mark.
        if (i > 0) TextSpan(text: ' \u00B7 ', style: boundaryStyle),
        TextSpan(
          text: words[i],
          style: words[i] == firstTimeWord ? firstTimeStyle : null,
        ),
      ],
      if (flagged) ...flagSpans(flagColor),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final isNote = words.isEmpty;
    final noteText = note;
    final attribution = switch (pusher.kind) {
      PusherKind.teacher => '${pusher.name} modelled this',
      PusherKind.base => unattributedLine,
      PusherKind.learner || PusherKind.eventNote => null,
    };

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: FpMetrics.timeRailWidth,
          child: Padding(
            padding: const EdgeInsets.only(top: FpSpace.s2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  at,
                  style: FpType.monoSm.copyWith(color: c.textTertiary).tabular,
                ),
                const SizedBox(height: FpSpace.s3),
                PusherAvatar(pusher: pusher),
              ],
            ),
          ),
        ),
        const SizedBox(width: FpSpace.s4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: FpSpace.s2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (isNote)
                  _NoteActivity(text: noteText ?? '', flagged: flagged)
                else
                  _Utterance(
                    words: words,
                    // The recession is a Teacher's, not "anybody who is not the
                    // pet". An unattributed press is still the pet talking as
                    // far as anyone knows, and its words are the content of the
                    // row.
                    prominent: pusher.kind != PusherKind.teacher,
                    firstTimeWord: firstTimeWord,
                    flagged: flagged,
                  ),
                if (!isNote && attribution != null) ...<Widget>[
                  const SizedBox(height: FpSpace.s2),
                  Text(
                    attribution,
                    style: FpType.labelSm.copyWith(color: c.textTertiary),
                  ),
                ],
                if (contexts.isNotEmpty) ...<Widget>[
                  const SizedBox(height: FpSpace.s2),
                  ContextList(contexts: contexts),
                ],
                if (!isNote && noteText != null && noteText.isNotEmpty) ...[
                  const SizedBox(height: FpSpace.s3),
                  NoteBlock(text: noteText),
                ],
              ],
            ),
          ),
        ),
      ],
    );

    if (onTap == null) return row;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }
}

/// The words themselves, as one wrapping run of rich text.
///
/// Rich text rather than a `Wrap` of boxes because the dots, the underline and
/// the flag all have to sit on the same baseline as the words, and because the
/// run must break across lines mid-phrase without any of them detaching.
class _Utterance extends StatelessWidget {
  const _Utterance({
    required this.words,
    required this.prominent,
    required this.firstTimeWord,
    required this.flagged,
  });

  final List<String> words;

  /// Display type in primary, rather than the Teacher's recessed heading.
  final bool prominent;
  final String? firstTimeWord;
  final bool flagged;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;

    final base = prominent
        ? FpType.displaySm.copyWith(color: c.textPrimary)
        : FpType.headingMd.copyWith(color: c.textSecondary);

    // The press boundary. Body-sm so it stays small beside display type, and
    // half-opacity because it is punctuation rather than a word.
    final boundary = FpType.bodySm.copyWith(
      color: c.textTertiary.withValues(alpha: FpMetrics.separatorOpacity),
    );

    final firstTime = base.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: c.accentBg,
      // Flutter's decorationThickness is a multiple of the font's own
      // underline, not a pixel value; 2 is the closest expression of the
      // spec's 2px rule.
      decorationThickness: FpStroke.thick,
    );

    return Semantics(
      label: words.join(', ') + (flagged ? ', flagged' : ''),
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            style: base,
            children: UtteranceRow.utteranceSpans(
              words: words,
              flagged: flagged,
              flagColor: c.accentFg,
              firstTimeWord: firstTimeWord,
              boundaryStyle: boundary,
              firstTimeStyle: firstTime,
            ),
          ),
        ),
      ),
    );
  }
}

/// A free-standing Note — an Activity with no press behind it.
class _NoteActivity extends StatelessWidget {
  const _NoteActivity({required this.text, required this.flagged});

  final String text;
  final bool flagged;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: FpSpace.s1),
          child: PhosphorIcon(
            PhosphorIconsRegular.notePencil,
            size: FpIconSize.sm,
            color: c.textTertiary,
          ),
        ),
        const SizedBox(width: FpSpace.s3),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: FpType.bodyMd.copyWith(color: c.textSecondary),
              children: <InlineSpan>[
                TextSpan(text: text),
                // The joiner then the marker. See [UtteranceRow.flagSpans].
                if (flagged) ...UtteranceRow.flagSpans(c.accentFg),
              ],
            ),
            // The marker is a private-use code point with no semantics of its
            // own; without this a screen reader reads the note and stops.
            semanticsLabel: flagged ? '$text, flagged' : null,
          ),
        ),
      ],
    );
  }
}

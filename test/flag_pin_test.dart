/// Proves decision 5: **the flag pins to the last word.**
///
/// ## What this test found
///
/// The flag used to be an inline [WidgetSpan] with U+00A0 in front of it. The
/// reasoning was UAX #14: U+00A0 is line-break class GL, and LB12/LB12a forbid a
/// break on either side of it, ahead of anything that would permit a break at
/// the U+FFFC object-replacement character a placeholder occupies. What that
/// reasoning could not rule out was that Skia's `skparagraph` treats a
/// placeholder as a break opportunity regardless of the character before it.
///
/// It does. [_theControlThatMakesThisMeanSomething] is that construction,
/// reproduced verbatim, and it orphans the flag at over a hundred of the swept
/// widths. Measured separately while diagnosing this, a `WidgetSpan` marker
/// orphans behind U+00A0, behind U+2060 and behind a plain space alike: no
/// character in front of a placeholder holds it.
///
/// The reasoning about the glue itself was sound — it simply never applied.
/// Drawing the marker as the **text glyph** it already is (Phosphor is a font)
/// puts it back under the line-breaker's normal rules, and the glue starts
/// working. Verified by mutation on [FlagMarker.glue] against these fixtures:
///
/// | glue | result |
/// |---|---|
/// | U+0020 SPACE | fails — orphaned at 108 widths, first at 141.5pt |
/// | U+00A0 NO-BREAK SPACE | passes |
/// | U+2060 WORD JOINER | passes — what ships, see [FlagMarker.glue] |
///
/// That mutation row for U+0020 is the whole reason to trust the other two.
///
/// ## Scope
///
/// Headless [TextPainter] layout. No widget tree, no simulator, no golden. The
/// real spans from `utterance_row.dart` and `flag_marker.dart` — not a copy — in
/// the real [FpType] styles with the real vendored Fraunces.
///
/// What it does not prove: this is the host engine `flutter test` runs on. It is
/// the same `skparagraph`, but it is not literally the arm64 iOS build.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluentpet/theme/generated/fp_tokens.dart';
import 'package:fluentpet/widgets/flag_marker.dart';
import 'package:fluentpet/widgets/fp_metrics.dart';
import 'package:fluentpet/widgets/utterance_row.dart';

/// The width an utterance actually gets on the timeline, on a 402pt device.
///
/// 402 is the iPhone 16 / 15 Pro logical width. Everything subtracted from it is
/// read off the widgets between the screen edge and the words:
///
/// * `SliverPadding(horizontal: FpSpace.s6)` — `activity_timeline.dart:282`
/// * the selection rule (`FpStroke.thick`) and `padding: left: FpSpace.s3` on
///   the row container — `activity_timeline.dart:437-449`
/// * `FpMetrics.timeRailWidth` and the `SizedBox(width: FpSpace.s4)` beside it —
///   `utterance_row.dart`'s own [Row]
const double _screenWidth = 402.0;
const double _contentWidth = _screenWidth -
    FpSpace.s6 * 2 -
    FpStroke.thick -
    FpSpace.s3 -
    FpMetrics.timeRailWidth -
    FpSpace.s4;

/// A Learner's words: Fraunces 24/30, the loudest type in the app and the case
/// where a wrap is most likely.
final TextStyle _learner =
    FpType.displaySm.copyWith(color: const Color(0xFF1C1A17));

/// The press boundary, as `_Utterance` styles it.
final TextStyle _boundary = FpType.bodySm.copyWith(
  color: const Color(0xFF746E65).withValues(alpha: FpMetrics.separatorOpacity),
);

/// `accent.fg` in light, which is what `_Utterance` hands the marker.
const Color _accentFg = Color(0xFF8A5A00);

/// Six presses of mixed length, so the sweep lands the final word at many
/// different positions across a line.
const List<String> _long = <String>[
  'outside',
  'now',
  'please',
  'want',
  'walk',
  'park',
];

/// Two presses. This is the fixture that actually catches the bug: it is short
/// enough that a band of widths exists where the whole utterance fits on one
/// line and the flag does not, and an earlier break *is* available — so an
/// engine that honoured the glue would move the last word down with the flag,
/// and one that does not leaves the flag behind alone.
const List<String> _short = <String>['outside', 'now'];

void main() {
  setUpAll(() async {
    // The vendored faces, read from disk rather than through `rootBundle`, so
    // the test does not depend on how the tool happened to build the bundle.
    // Without them every glyph is the test font's fixed em box and the wrap
    // points are not the app's wrap points.
    await _loadFont('Fraunces', 'assets/fonts/Fraunces-SemiBold.ttf');
    await _loadFont('Inter', 'assets/fonts/Inter-Regular.ttf');
  });

  test('the flag shares the last word\'s line at the real 402pt width', () {
    final result = _layout(_long, _contentWidth);

    expect(
      result.lines,
      greaterThan(1),
      reason: 'A single-line layout cannot orphan anything, so it would not '
          'test the claim. If this fires, the fixture is too short for '
          '${_contentWidth}pt.',
    );
    expect(
      result.flagLine,
      result.lastWordLine,
      reason: 'The flag landed on line ${result.flagLine} and the last word '
          '("${_long.last}") on line ${result.lastWordLine}.',
    );
  });

  test('the flag is never orphaned, at any width, for either fixture', () {
    final orphaned = <String>[];
    var wrapped = 0;
    for (final words in <List<String>>[_short, _long]) {
      for (var w = 100.0; w <= _screenWidth; w += 0.25) {
        final result = _layout(words, w);
        if (result.lines > 1) wrapped++;
        if (result.flagLine != result.lastWordLine) {
          orphaned.add('${words.length} words @${w}pt');
        }
      }
    }

    expect(
      wrapped,
      greaterThan(0),
      reason: 'Nothing wrapped anywhere in the sweep, so nothing was tested.',
    );
    expect(
      orphaned,
      isEmpty,
      reason: 'U+2060 before a text glyph did not hold at ${orphaned.length} '
          'widths, first at ${orphaned.isEmpty ? '-' : orphaned.first}.',
    );
  });

  test(_theControlThatMakesThisMeanSomething, () {
    // The construction this file replaced, reproduced deliberately: U+00A0 in
    // front of a WidgetSpan. If this does not orphan, the two tests above are
    // passing for some reason that has nothing to do with the fix.
    final orphaned = <double>[];
    for (var w = 100.0; w <= _screenWidth; w += 0.25) {
      if (_layoutLegacy(_short, w)) orphaned.add(w);
    }
    expect(
      orphaned,
      isNotEmpty,
      reason: 'The pre-fix construction never orphaned the flag at any width, '
          'so this fixture cannot detect the failure and the tests above prove '
          'nothing.',
    );
  });
}

/// Named so the failure output says what the control is for.
const String _theControlThatMakesThisMeanSomething =
    'control: the old WidgetSpan-behind-U+00A0 construction DOES orphan the '
    'flag, so the assertions above can detect the failure they rule out';

/// Which line the flag landed on, which line the last word landed on.
class _Layout {
  const _Layout({
    required this.flagLine,
    required this.lastWordLine,
    required this.lines,
  });

  final int flagLine;
  final int lastWordLine;
  final int lines;
}

/// Lays out the real production spans at [width].
_Layout _layout(List<String> words, double width) {
  final painter = TextPainter(
    text: TextSpan(
      style: _learner,
      children: UtteranceRow.utteranceSpans(
        words: words,
        flagged: true,
        flagColor: _accentFg,
        boundaryStyle: _boundary,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: width);

  final metrics = painter.computeLineMetrics();

  // The paragraph's plain text is the words joined by the boundary, then the
  // joiner, then the one-code-point glyph. So the last word ends where the
  // joined run ends, and the glyph is the final code unit.
  final joined = words.join(' · ');
  final plain = '$joined${UtteranceRow.flagGlue}x';

  final flagBoxes = painter.getBoxesForSelection(
    TextSelection(baseOffset: plain.length - 1, extentOffset: plain.length),
  );
  final lastWordBoxes = painter.getBoxesForSelection(
    TextSelection(
      baseOffset: joined.length - words.last.length,
      extentOffset: joined.length,
    ),
  );

  final layout = _Layout(
    flagLine: _lineOf(metrics, flagBoxes.last),
    lastWordLine: _lineOf(metrics, lastWordBoxes.last),
    lines: metrics.length,
  );
  painter.dispose();
  return layout;
}

/// The pre-fix construction: U+00A0 then a [WidgetSpan]. True if the flag ended
/// up on a different line from the last word.
bool _layoutLegacy(List<String> words, double width) {
  final joined = words.join(' · ');
  final painter = TextPainter(
    text: TextSpan(
      style: _learner,
      children: <InlineSpan>[
        TextSpan(text: joined),
        const TextSpan(text: ' '),
        const WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: FlagMarker(flagged: true),
        ),
      ],
    ),
    textDirection: TextDirection.ltr,
  )..setPlaceholderDimensions(const <PlaceholderDimensions>[
      PlaceholderDimensions(
        size: Size(FpMetrics.flagInline, FpMetrics.flagInline),
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        baselineOffset: FpMetrics.flagInline,
      ),
    ]);
  painter.layout(maxWidth: width);

  final metrics = painter.computeLineMetrics();
  final flag = painter.inlinePlaceholderBoxes!.single;
  final lastWord = painter.getBoxesForSelection(
    TextSelection(
      baseOffset: joined.length - words.last.length,
      extentOffset: joined.length,
    ),
  );
  final orphaned = lastWord.isNotEmpty &&
      _lineOf(metrics, flag) != _lineOf(metrics, lastWord.last);
  painter.dispose();
  return orphaned;
}

/// The line a box sits on, found by walking the cumulative line heights.
///
/// [LineMetrics] carries no top, so the bands are summed. The box's vertical
/// centre is the probe: a marker box is shorter than its line and a glyph box
/// taller than its glyph, but both lie wholly inside one band.
int _lineOf(List<LineMetrics> metrics, TextBox box) {
  final centre = (box.top + box.bottom) / 2;
  var top = 0.0;
  for (final line in metrics) {
    if (centre < top + line.height) return line.lineNumber;
    top += line.height;
  }
  return metrics.last.lineNumber;
}

Future<void> _loadFont(String family, String path) async {
  final bytes = await File(path).readAsBytes();
  final loader = FontLoader(family)
    ..addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
  await loader.load();
}

/// `BASE_EDIT_INTERACTION_TIMING` — what the grouping window actually does.
///
/// The RN screen is 39 lines of static copy: a bold heading and two paragraphs,
/// no data and no controls (`BaseEditInteractionTimingScreen.tsx`, §11). The
/// inventory says the only decision left is presentational — keep it a pushed
/// screen or turn it into a tooltip.
///
/// It stays a pushed screen, and it stops being only prose. The grouping window
/// is load-bearing domain behaviour: it is the reason several presses become
/// one Interaction, which is the reason a timeline row can read
/// "play · outside · now" with two press boundaries in it
/// (`lib/widgets/utterance_row.dart` calls those middots press boundaries for
/// this exact reason). Grouping is something you show, not something you
/// assert, so the middle of this screen is a diagram of the same three presses
/// inside the window and outside it. That is what a tooltip could not carry and
/// what earns the screen its push.
///
/// The current window is passed in from `BASE_EDIT` when the `?` is tapped, so
/// the page can say what *this* Base does rather than only what the setting
/// means. Arriving by deep link with no parameter is a real state — the route
/// takes no params in the RN app either — and the page then explains the
/// setting generically.
///
/// All numbers go through `FpFormat.groupingWindow`, including the bounds, so
/// the range this page quotes and the range the form enforces are the same two
/// constants.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import 'hardware_metrics.dart';
import 'hardware_ui.dart';

class BaseEditInteractionTimingScreen extends ConsumerWidget {
  const BaseEditInteractionTimingScreen({
    this.windowSeconds,
    this.baseName,
    super.key,
  });

  /// The window of the Base the reader came from, when they came from one.
  final int? windowSeconds;

  /// That Base's name, for the same reason.
  final String? baseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final seconds = windowSeconds;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Interaction timing',
              subtitle: 'How several presses become one Interaction',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FpSpace.s6,
                  FpSpace.s2,
                  FpSpace.s6,
                  FpSpace.s10,
                ),
                children: <Widget>[
                  if (seconds != null) _CurrentWindow(
                    seconds: seconds,
                    baseName: baseName,
                  ),
                  if (seconds != null) const SizedBox(height: FpSpace.s7),
                  Text(
                    'A Base watches for presses that arrive close together and '
                    'records them as one Interaction. The window is how close '
                    '“close together” is.',
                    style: FpType.bodyMd.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: FpSpace.s7),
                  const _GroupingDiagram(),
                  const SizedBox(height: FpSpace.s8),
                  const SectionHeading(label: 'Why it is adjustable'),
                  const SizedBox(height: FpSpace.s5),
                  // The RN copy, kept. It carries the one piece of advice
                  // nobody in the rewrite is in a position to reinvent: what
                  // to do when the Learner is a slow talker.
                  Text(
                    'Customising the timing between Button presses lets the '
                    'app match the communication tempo of your Learner. If '
                    'your Learner is a slow talker, we suggest increasing the '
                    'window — 30 seconds is a good place to start.',
                    style: FpType.bodyMd.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: FpSpace.s5),
                  Text(
                    'Presses that all fall inside the window are logged as one '
                    'multi-word Interaction. Presses that fall outside it are '
                    'logged separately, and the time between them shows on the '
                    'timeline.',
                    style: FpType.bodyMd.copyWith(color: c.textSecondary),
                  ),
                  const SizedBox(height: FpSpace.s7),
                  const SectionHeading(label: 'What the Base accepts'),
                  const SizedBox(height: FpSpace.s5),
                  const _Bounds(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// What this Base does right now, in words rather than in seconds.
class _CurrentWindow extends StatelessWidget {
  const _CurrentWindow({required this.seconds, this.baseName});

  final int seconds;
  final String? baseName;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final name = baseName;
    return HardwareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name ?? 'This Base',
            style: FpType.labelSm.copyWith(color: c.textTertiary),
          ),
          const SizedBox(height: FpSpace.s3),
          Text(
            'Presses less than ${FpFormat.groupingWindow(seconds)} apart '
            'become one Interaction.',
            style: FpType.headingSm.copyWith(color: c.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// The same three presses, grouped and not grouped.
///
/// A capsule is one Interaction and a mark is one press, so the difference
/// between the two rows is the whole of what the setting does. The marks are
/// deliberately identical between the rows: nothing about the presses changed,
/// only the window they landed in.
class _GroupingDiagram extends StatelessWidget {
  const _GroupingDiagram();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _DiagramRow(
          label: 'Inside the window',
          groups: <int>[3],
          caption: 'One Interaction — “play · outside · now”',
          highlight: true,
        ),
        SizedBox(height: FpSpace.s6),
        _DiagramRow(
          label: 'Outside the window',
          groups: <int>[1, 1, 1],
          caption: 'Three Interactions, with the gaps between them on the '
              'timeline',
          highlight: false,
        ),
      ],
    );
  }
}

class _DiagramRow extends StatelessWidget {
  const _DiagramRow({
    required this.label,
    required this.groups,
    required this.caption,
    required this.highlight,
  });

  /// How many presses fall in each capsule, left to right.
  final List<int> groups;

  final String label;
  final String caption;

  /// The grouped row takes the brand tint; the ungrouped one stays neutral.
  /// One of the two has to be the answer the copy is arguing for.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: FpType.labelSm.copyWith(color: c.textTertiary)),
        const SizedBox(height: FpSpace.s3),
        Container(
          height: HardwareMetrics.diagramRowHeight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: c.borderSubtle,
                width: FpStroke.hairline,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              for (var i = 0; i < groups.length; i++) ...<Widget>[
                if (i > 0) const Spacer(),
                _Capsule(presses: groups[i], highlight: highlight),
              ],
              if (groups.length == 1) const Spacer(),
            ],
          ),
        ),
        const SizedBox(height: FpSpace.s3),
        Text(caption, style: FpType.bodySm.copyWith(color: c.textSecondary)),
      ],
    );
  }
}

/// One Interaction: a capsule holding one or more press marks.
class _Capsule extends StatelessWidget {
  const _Capsule({required this.presses, required this.highlight});

  final int presses;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.s3,
        vertical: FpSpace.s3,
      ),
      decoration: BoxDecoration(
        color: highlight ? c.surfaceTint : c.surfaceSunken,
        borderRadius: BorderRadius.circular(FpRadius.full),
        border: Border.all(
          color: highlight ? c.borderDefault : c.borderSubtle,
          width: FpStroke.hairline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < presses; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: FpSpace.s3),
            Container(
              width: HardwareMetrics.pressMark,
              height: HardwareMetrics.pressMark,
              decoration: BoxDecoration(
                color: highlight ? c.textBrand : c.borderStrong,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The accepted range, quoted from the same two constants the form validates
/// against.
class _Bounds extends StatelessWidget {
  const _Bounds();

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return HardwareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FactRow(
            label: 'Shortest',
            value:
                '${FpFormat.groupingWindow(FpFormat.groupingWindowMinSeconds)}'
                ' — every press its own Interaction',
          ),
          FactRow(
            label: 'Longest',
            value:
                '${FpFormat.groupingWindow(FpFormat.groupingWindowMaxSeconds)}'
                ' — everything within the hour together',
          ),
          const SizedBox(height: FpSpace.s3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PhosphorIcon(
                PhosphorIconsRegular.info,
                size: FpIconSize.sm,
                color: c.textTertiary,
              ),
              const SizedBox(width: FpSpace.s3),
              Expanded(
                child: Text(
                  'Changing the window does not regroup Interactions that have '
                  'already been recorded.',
                  style: FpType.bodySm.copyWith(color: c.textTertiary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

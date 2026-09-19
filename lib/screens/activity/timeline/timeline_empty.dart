/// The three empty states, told apart.
///
/// `docs/design-system/screen-inventory.md` §14.4:
///
/// > **Empty states are undifferentiated.** "You don't have any logs yet"
/// > appears for a genuinely empty account, for an over-filtered timeline, and
/// > for a facet screen with no matches. Three different messages are needed
/// > and none exists to copy.
///
/// They are three different situations and the user's next action differs in
/// each, which is the actual argument — not that the copy is repetitive:
///
/// | Situation | What is true | What to do next |
/// | --- | --- | --- |
/// | Empty account | there is nothing, anywhere | record something |
/// | Over-filtered | there is plenty, and you hid it | widen or clear the filters |
/// | Empty facet | this word exists but has no matching presses | clear the filters, or go back |
///
/// So each state names what is true, says how much is hidden where it can count
/// it, and offers the one action that changes the situation. The empty-account
/// state is the only one that offers "log a press", because it is the only one
/// where pressing something is the fix.
library;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../domain/domain.dart';
import '../../../theme/fp_context.dart';
import '../../../theme/generated/fp_tokens.dart';
import '../../../widgets/widgets.dart';
import '../data/filters_edit.dart';
import '../data/timeline_query.dart';
import '../ui/activity_controls.dart';
import '../ui/activity_metrics.dart';

/// What emptied the timeline.
enum TimelineEmptyCause {
  /// Nothing has ever been recorded.
  emptyAccount,

  /// Everything is attributed, so the Unassigned tab has nothing in it. A good
  /// state, not a failure, and it says so.
  nothingUnassigned,

  /// There is history; the filters hide all of it.
  overFiltered,

  /// A facet with no presses at all — reachable by deep link, or by a Button
  /// that was added and never used.
  emptyFacet,

  /// A facet with presses, all of them filtered out.
  filteredFacet;

  /// Which of the five applies.
  static TimelineEmptyCause of({
    required TimelineQuery query,
    required DashboardFilters filters,
    required int facetTotal,
  }) {
    final filtered = filters.activeCount > 0;
    if (query.isRoot) {
      if (filtered && facetTotal > 0) return TimelineEmptyCause.overFiltered;
      return query.facet == TimelineFacet.unassigned
          ? TimelineEmptyCause.nothingUnassigned
          : TimelineEmptyCause.emptyAccount;
    }
    return filtered && facetTotal > 0
        ? TimelineEmptyCause.filteredFacet
        : TimelineEmptyCause.emptyFacet;
  }
}

/// The empty timeline, in whichever of its five situations it is in.
class TimelineEmpty extends StatelessWidget {
  const TimelineEmpty({
    required this.query,
    required this.filters,
    required this.facetTotal,
    required this.asOf,
    required this.onClearFilters,
    required this.onEditFilters,
    required this.onLogPress,
    required this.onShowAll,
    super.key,
  });

  final TimelineQuery query;
  final DashboardFilters filters;

  /// How many rows the facet has before the filters are applied.
  final int facetTotal;

  final DateTime asOf;
  final VoidCallback onClearFilters;
  final VoidCallback onEditFilters;
  final VoidCallback onLogPress;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final cause = TimelineEmptyCause.of(
      query: query,
      filters: filters,
      facetTotal: facetTotal,
    );

    final (IconData icon, String title, String body) = switch (cause) {
      TimelineEmptyCause.emptyAccount => (
        PhosphorIconsRegular.chatTeardropDots,
        'Nothing logged yet',
        'Press a Button on the board, or log one by hand, and the day fills '
            'in here.',
      ),
      TimelineEmptyCause.nothingUnassigned => (
        PhosphorIconsRegular.checks,
        'Everything is attributed',
        'No press is waiting for a Pusher. Presses the Base records without '
            'knowing who made them collect here.',
      ),
      TimelineEmptyCause.overFiltered => (
        PhosphorIconsRegular.funnel,
        'No activity matches these filters',
        '${FpFormat.countOf(filters.activeCount, 'filter')} '
            '${filters.activeCount == 1 ? 'is' : 'are'} narrowing the '
            'timeline, and '
            '${FpFormat.largeCountOf(facetTotal, 'entry', 'entries')} '
            'sit behind ${filters.activeCount == 1 ? 'it' : 'them'}.',
      ),
      TimelineEmptyCause.emptyFacet => (
        PhosphorIconsRegular.magnifyingGlass,
        _facetTitle(never: true),
        _facetBody(never: true),
      ),
      TimelineEmptyCause.filteredFacet => (
        PhosphorIconsRegular.funnel,
        _facetTitle(never: false),
        _facetBody(never: false),
      ),
    };

    final describes = filters.describe(asOf);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: FpSpace.s7,
          vertical: FpSpace.s9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PhosphorIcon(
              icon,
              size: ActivityMetrics.emptyGlyph,
              color: c.textTertiary,
            ),
            const SizedBox(height: FpSpace.s5),
            Text(title, style: FpType.headingLg.copyWith(color: c.textPrimary)),
            const SizedBox(height: FpSpace.s3),
            Text(body, style: FpType.bodyMd.copyWith(color: c.textSecondary)),
            if (describes.isNotEmpty) ...<Widget>[
              const SizedBox(height: FpSpace.s4),
              // Naming the filters is the whole point: the RN app knew exactly
              // what it was hiding and said "You don't have any logs yet".
              Text(
                describes.join(' · '),
                style: FpType.labelMd.copyWith(color: c.textTertiary),
              ),
            ],
            const SizedBox(height: FpSpace.s7),
            ..._actions(cause),
          ],
        ),
      ),
    );
  }

  String _facetTitle({required bool never}) => switch (query.facet) {
    TimelineFacet.button =>
      never
          ? '“${query.label}” has never been pressed'
          : 'All of them are filtered out',
    TimelineFacet.context =>
      never
          ? 'Nothing is tagged “${query.label}”'
          : 'All of them are filtered out',
    TimelineFacet.pusher =>
      never
          ? '${query.label} has not pressed anything'
          : 'All of it is filtered out',
    _ => 'Nothing here',
  };

  String _facetBody({required bool never}) {
    if (never) {
      return switch (query.facet) {
        TimelineFacet.button =>
          'The Button is on the Board and has no presses recorded against it.',
        TimelineFacet.context => 'No Interaction carries this Context yet.',
        TimelineFacet.pusher =>
          '${query.label} is in the Household and has no Activity recorded.',
        _ => 'There is nothing to show.',
      };
    }
    final noun = switch (query.facet) {
      TimelineFacet.pusher => FpFormat.largeCountOf(
        facetTotal,
        'entry',
        'entries',
      ),
      _ => FpFormat.largeCountOf(facetTotal, 'press', 'presses'),
    };
    return 'There ${facetTotal == 1 ? 'is' : 'are'} $noun here in total, and '
        'the filters you have set hide all of them.';
  }

  List<Widget> _actions(TimelineEmptyCause cause) => switch (cause) {
    TimelineEmptyCause.emptyAccount => <Widget>[
      ActionButton(
        label: 'Log a press',
        icon: PhosphorIconsRegular.plus,
        onPressed: onLogPress,
      ),
    ],
    TimelineEmptyCause.nothingUnassigned => <Widget>[
      ActionButton(
        label: 'Show all activity',
        tone: ButtonTone.secondary,
        onPressed: onShowAll,
      ),
    ],
    TimelineEmptyCause.overFiltered ||
    TimelineEmptyCause.filteredFacet => <Widget>[
      ActionButton(label: 'Clear filters', onPressed: onClearFilters),
      const SizedBox(height: FpSpace.s3),
      ActionButton(
        label: 'Edit filters',
        tone: ButtonTone.ghost,
        onPressed: onEditFilters,
      ),
    ],
    TimelineEmptyCause.emptyFacet => <Widget>[
      ActionButton(
        label: 'Back to Activity',
        tone: ButtonTone.secondary,
        onPressed: onShowAll,
      ),
    ],
  };
}

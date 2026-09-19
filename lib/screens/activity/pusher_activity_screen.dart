/// `DASHBOARD_PUSHER` — one Pusher's feed and statistics.
///
/// The fifth wrapper, and the only one that is more than a header: it carries a
/// Feed / Stats control, and the Stats side is a different surface entirely
/// (`docs/design-system/screen-inventory.md` §7).
///
/// The RN screen hides the timeline with `display: "none"` rather than
/// unmounting it while Stats is showing (`DashboardList.tsx:656-657`, `:723`).
/// Here the two are alternatives in a build method: the timeline keeps its
/// loaded pages because the provider outlives the widget, so there is nothing
/// to preserve by leaving a hidden list mounted.
///
/// ## Decisions this screen forced
///
/// * **The "Days" figure is live again.** `PusherHeader.tsx:48-52` prefers
///   `ceil(now − filters.sinceDate)` and falls back to the oldest entry — and
///   the first branch is dead in the RN app because no UI ever sets
///   `sinceDate` (§5). The filter sheet in this rewrite does, so the figure now
///   means "days in the window you are looking at" whenever there is one.
/// * **The statistics are served** by `GET /pushers/{id}/stats` and `GET /stats/summary`.
///   Computing them from the same rows the Feed shows means the two halves of
///   this screen cannot disagree, which static numbers eventually would.
/// * **Share is gone.** The RN header shared to a `ShareModal` whose card
///   layouts §16 leaves uninventoried. It was drawn disabled for a pass; with
///   the PRD scoping the product down it is dropped rather than left inert.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/domain.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import 'data/activity_providers.dart';
import 'data/timeline_query.dart';
import 'data/timeline_source.dart';
import 'timeline/activity_timeline.dart';
import 'ui/activity_controls.dart';

/// The two halves of this screen.
enum PusherFeedTab { feed, stats }

class PusherActivityScreen extends ConsumerStatefulWidget {
  const PusherActivityScreen({
    required this.pusherId,
    required this.name,
    super.key,
  });

  final int pusherId;

  /// Carried on the route so the header has a name before the Pusher list
  /// resolves. A header that spins where a name should be is a header that
  /// says nothing.
  final String name;

  @override
  ConsumerState<PusherActivityScreen> createState() =>
      _PusherActivityScreenState();
}

class _PusherActivityScreenState extends ConsumerState<PusherActivityScreen> {
  PusherFeedTab _tab = PusherFeedTab.feed;

  @override
  Widget build(BuildContext context) {
    final pusher = ref
        .watch(allPushersProvider)
        .firstWhere(
          (p) => p.id == widget.pusherId,
          orElse: () =>
              Pusher(id: widget.pusherId, name: widget.name, isHuman: false),
        );

    final query = TimelineQuery.pusher(id: pusher.id, name: pusher.name);
    final stats = ref.watch(pusherStatsProvider(pusher.id));

    Widget header(BuildContext context, TimelineSlice? slice) => _PusherHeader(
      pusher: pusher,
      stats: stats.value,
      tab: _tab,
      onTab: (tab) => setState(() => _tab = tab),
    );

    return FpOsChrome(
      child: _tab == PusherFeedTab.feed
          ? ActivityTimeline(query: query, header: header)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                header(context, null),
                Expanded(
                  child: stats.when(
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: context.fpColors.textBrand,
                      ),
                    ),
                    error: (error, stack) => const _StatsUnavailable(),
                    data: (data) =>
                        PusherStatsView(pusher: pusher, stats: data),
                  ),
                ),
              ],
            ),
    );
  }
}

/// Avatar, name, three figures, and the Feed / Stats control.
class _PusherHeader extends StatelessWidget {
  const _PusherHeader({
    required this.pusher,
    required this.stats,
    required this.tab,
    required this.onTab,
  });

  final Pusher pusher;
  final PusherStatistics? stats;
  final PusherFeedTab tab;
  final ValueChanged<PusherFeedTab> onTab;

  @override
  Widget build(BuildContext context) {
    final subtitle = switch (pusher.kind) {
      PusherKind.learner => pusher.learnerType ?? 'Learner',
      PusherKind.teacher => 'Teacher',
      PusherKind.eventNote => 'Journal entries',
      PusherKind.base => 'Recorded by a Base, unattributed',
    };

    return ScreenHeader(
      title: pusher.name,
      subtitle: pusher.isHidden ? '$subtitle · no longer active' : subtitle,
      onBack: () => context.pop(),
      // One trailing control, and on this screen it is the portrait rather
      // than a button: the Pusher *is* what the screen is about.
      trailing: PusherAvatar(pusher: pusher, size: PusherAvatarSize.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: StatFigure(
                  // Every figure in a header goes through `formatLargeNumber`
                  // (§7, §13.2): "1.5k", not "1500", which is how three
                  // four-digit numbers fit across one row on a 390pt screen.
                  value: FpFormat.largeNumber(stats?.days ?? 0),
                  caption: 'Days',
                ),
              ),
              Expanded(
                child: StatFigure(
                  value: FpFormat.largeNumber(stats?.distinctButtons ?? 0),
                  caption: 'Buttons',
                ),
              ),
              Expanded(
                child: StatFigure(
                  value: FpFormat.largeNumber(stats?.pressCount ?? 0),
                  caption: 'Presses',
                ),
              ),
            ],
          ),
          const SizedBox(height: FpSpace.s4),
          SegmentedControl<PusherFeedTab>(
            options: PusherFeedTab.values,
            labels: (t) => t == PusherFeedTab.feed ? 'Feed' : 'Stats',
            value: tab,
            onChanged: onTab,
          ),
        ],
      ),
    );
  }
}

/// The Stats tab.
///
/// Six blocks, in the RN order (§7). Two of them are Learner-only, and they are
/// absent rather than empty for a Teacher: "Most Modeled" on a human means
/// nothing, and an empty block that can never fill is furniture.
class PusherStatsView extends StatelessWidget {
  const PusherStatsView({required this.pusher, required this.stats, super.key});

  final Pusher pusher;
  final PusherStatistics stats;

  @override
  Widget build(BuildContext context) {
    final learner = pusher.isLearner;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s5,
        FpSpace.s6,
        FpSpace.s9,
      ),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: StatFigure(
                value: stats.averageDailyPresses,
                caption: 'Average daily presses',
              ),
            ),
            Expanded(
              child: StatFigure(
                value: FpFormat.largeNumber(stats.distinctButtons),
                caption: 'Unique Buttons pressed',
              ),
            ),
          ],
        ),
        const _Divider(),
        _RankedList(title: 'Most pressed', rows: stats.mostPressed),
        _RankedList(title: 'Least pressed', rows: stats.leastPressed),
        if (learner) ...<Widget>[
          const _Divider(),
          _UsageTypes(contexts: stats.commonContexts),
        ],
        if (stats.mostFrequentCombination.isNotEmpty) ...<Widget>[
          const _Divider(),
          _Combination(words: stats.mostFrequentCombination),
        ],
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: FpSpace.s6),
    child: Container(
      height: FpStroke.hairline,
      color: context.fpColors.borderSubtle,
    ),
  );
}

/// A numbered list of words and their counts. "None" when it is empty, which is
/// what the RN app writes (`ButtonPresses.tsx:23-24`) and is better than an
/// absent block: the block being empty is itself the fact.
class _RankedList extends StatelessWidget {
  const _RankedList({required this.title, required this.rows});

  final String title;
  final List<ButtonPressCount> rows;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: FpSpace.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: FpType.labelSm.copyWith(color: c.textTertiary),
          ),
          const SizedBox(height: FpSpace.s3),
          if (rows.isEmpty)
            Text('None', style: FpType.bodyMd.copyWith(color: c.textTertiary))
          else
            for (var i = 0; i < rows.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: FpSpace.s2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    SizedBox(
                      width: FpSpace.s6,
                      child: Text(
                        '${i + 1}',
                        style: FpType.monoSm
                            .copyWith(color: c.textTertiary)
                            .tabular,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rows[i].text,
                        style: FpType.bodyMd.copyWith(color: c.textPrimary),
                      ),
                    ),
                    const SizedBox(width: FpSpace.s4),
                    Text(
                      FpFormat.largeNumber(rows[i].count),
                      style: FpType.labelMd
                          .copyWith(color: c.textSecondary)
                          .tabular,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

/// Common usage types — the Contexts this Pusher's presses carry most.
///
/// The RN version splits the first five into a left column and items six to ten
/// into a right one, omitting the right column entirely at five or fewer
/// (`UsageTypes.tsx:38-42`). One wrapping list does the same job without the
/// arithmetic, and reflows on a narrow phone rather than squeezing two columns
/// into 390px.
class _UsageTypes extends StatelessWidget {
  const _UsageTypes({required this.contexts});

  final List<ButtonPressCount> contexts;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'COMMON USAGE TYPES',
          style: FpType.labelSm.copyWith(color: c.textTertiary),
        ),
        const SizedBox(height: FpSpace.s3),
        if (contexts.isEmpty)
          Text('None', style: FpType.bodyMd.copyWith(color: c.textTertiary))
        else
          Wrap(
            spacing: FpSpace.s4,
            runSpacing: FpSpace.s2,
            children: <Widget>[
              for (final ctx in contexts)
                Text.rich(
                  TextSpan(
                    style: FpType.bodyMd.copyWith(color: c.textPrimary),
                    children: <InlineSpan>[
                      TextSpan(text: ctx.text),
                      TextSpan(
                        text: '  ${FpFormat.largeNumber(ctx.count)}',
                        style: FpType.labelMd
                            .copyWith(color: c.textTertiary)
                            .tabular,
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

/// The combination this Pusher reaches for most, set the way the timeline sets
/// an utterance — same middots, same meaning: they are press boundaries.
class _Combination extends StatelessWidget {
  const _Combination({required this.words});

  final List<String> words;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'MOST FREQUENT COMBINATION',
          style: FpType.labelSm.copyWith(color: c.textTertiary),
        ),
        const SizedBox(height: FpSpace.s3),
        Text.rich(
          TextSpan(
            style: FpType.displaySm.copyWith(color: c.textPrimary),
            children: <InlineSpan>[
              for (var i = 0; i < words.length; i++) ...<InlineSpan>[
                if (i > 0)
                  TextSpan(
                    text: ' · ',
                    style: FpType.bodySm.copyWith(
                      color: c.textTertiary.withValues(
                        alpha: FpMetrics.separatorOpacity,
                      ),
                    ),
                  ),
                TextSpan(text: words[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// If `pusher_stats` is absent the RN Stats tab is a blank white filler view
/// (`DashboardList.tsx:650-652`). This says what happened instead.
class _StatsUnavailable extends StatelessWidget {
  const _StatsUnavailable();

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FpSpace.s7),
        child: Text(
          'The statistics did not load. The feed is still there.',
          textAlign: TextAlign.center,
          style: FpType.bodyMd.copyWith(color: c.textSecondary),
        ),
      ),
    );
  }
}

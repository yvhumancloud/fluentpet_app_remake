/// `DASHBOARD_BUTTON` and `DASHBOARD_CONTEXT` — two facet timelines.
///
/// In the RN app these are three sixteen-line files, each rendering
/// `<DashboardInfiniteScroll button={…} />` and differing only in the prop and
/// the header (`docs/design-system/screen-inventory.md` §6). They are three
/// sixteen-line classes here for the same reason: everything that makes them a
/// timeline is in `ActivityTimeline`, and everything that makes them *this*
/// timeline is one [TimelineQuery].
///
/// ## What changed
///
/// * **The caption casing is settled.** The RN app writes "Presses" on the
///   Button header and "PRESSES" on the other two (`ButtonHeader.tsx:21` vs
///   `ContextHeader.tsx:22`). §6 says pick one. Sentence case, in a subtitle
///   that also names the facet, so the number never floats without a noun.
/// * **The filters are inherited, not dropped.** These screens suppress the
///   settings row in the RN app, mount a fresh `DashboardInfiniteScroll` with
///   `DEFAULT_FILTERS`, and therefore show a Button's *unfiltered* history when
///   it was reached from a filtered timeline — a mismatch §13.3 asks the
///   redesign to verify. Filter state is one provider here, so the facet shows
///   what the user is actually looking at, and `ActivityTimeline`'s filter
///   strip says so and offers a way out.
/// * **The empty state knows why it is empty.** A screen reached by tapping a
///   badge that plainly exists cannot say "You don't have any logs yet".
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/widgets.dart';
import 'data/timeline_query.dart';
import 'data/timeline_source.dart';
import 'timeline/activity_timeline.dart';

/// The shape both share: a back chevron, the facet's own name as the
/// title, and the count under it.
class _FacetScreen extends ConsumerWidget {
  const _FacetScreen({required this.query, required this.countNoun});

  final TimelineQuery query;

  /// What the number counts. "press" everywhere except where a facet can also
  /// match a Note.
  final String countNoun;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FpOsChrome(
      child: ActivityTimeline(
        query: query,
        header: (context, slice) =>
            _FacetHeader(query: query, slice: slice, countNoun: countNoun),
      ),
    );
  }
}

class _FacetHeader extends StatelessWidget {
  const _FacetHeader({
    required this.query,
    required this.slice,
    required this.countNoun,
  });

  final TimelineQuery query;
  final TimelineSlice? slice;
  final String countNoun;

  @override
  Widget build(BuildContext context) {
    final matched = slice?.matched;
    final subtitle = matched == null
        ? query.facetNoun
        // A header count, so it goes through the `1.5k` rule like every other
        // one (§13.2): a Button with four thousand presses must not push its
        // own noun off the line.
        : '${query.facetNoun} · '
              '${FpFormat.largeCountOf(matched, countNoun, '${countNoun}es')}';

    return ScreenHeader(
      // The facet's own word, in the same display type the timeline sets
      // utterances in — because it is one.
      title: query.label,
      subtitle: subtitle,
      onBack: () => context.pop(),
    );
  }
}

/// `DASHBOARD_BUTTON` — every press of one Button.
class ButtonActivityScreen extends StatelessWidget {
  const ButtonActivityScreen({
    required this.buttonId,
    required this.meaning,
    super.key,
  });

  final int buttonId;
  final String meaning;

  @override
  Widget build(BuildContext context) => _FacetScreen(
    query: TimelineQuery.button(id: buttonId, meaning: meaning),
    countNoun: 'press',
  );
}

/// `DASHBOARD_CONTEXT` — everything tagged with one Context.
class ContextActivityScreen extends StatelessWidget {
  const ContextActivityScreen({
    required this.contextId,
    required this.text,
    super.key,
  });

  final int contextId;
  final String text;

  @override
  Widget build(BuildContext context) => _FacetScreen(
    query: TimelineQuery.context(id: contextId, text: text),
    countNoun: 'press',
  );
}

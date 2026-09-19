/// What a timeline is a timeline *of*.
///
/// `docs/design-system/screen-inventory.md` §1 is unambiguous: `DASHBOARD`,
/// `DASHBOARD_BUTTON`, `DASHBOARD_CONTEXT`, `DASHBOARD_MEANING` and
/// `DASHBOARD_PUSHER` are five 16-to-119-line wrappers around one 806-line
/// widget, which picks its header and its list type from whichever prop was
/// set. §14.2 says what to do about it: *"Six screens are one widget. Building
/// five separate Flutter screens will produce five divergent timelines. Build
/// one with a mode."*
///
/// This is the mode. One value type, five constructors, and the screens differ
/// by which one they build. (`DASHBOARD_MEANING` was dropped with the meanings
/// dictionary — the PRD's `interactions` has no meaning column.)
library;

/// The two orders a timeline can be read in.
///
/// `ActivitySortType` in the RN app, read from the `activity_sort` user
/// preference and sent to the API — with **no UI anywhere to change it**:
/// `src/components/Dashboard/ActivitySort.tsx` implements the picker and is
/// imported by nothing (`docs/design-system/screen-inventory.md` §2, §14.10,
/// which says to either wire it up or drop the preference and not to port dead
/// code). It is wired up.
///
/// The distinction is only expressible because `Interaction.createdAt` exists:
/// a press that happened on Tuesday and was typed in on Thursday is in a
/// different place in the two lists, and without a written-at timestamp both
/// orders were the same list.
enum ActivitySortType {
  /// When the press happened. The diary order, and the default.
  recentlyPressed('Recently pressed'),

  /// When the row was written. Puts a fortnight-old press somebody logged this
  /// morning at the top, which is what you want after an evening of catching
  /// up on the journal.
  recentlyLogged('Recently logged');

  const ActivitySortType(this.label);

  final String label;
}

/// Which facet a timeline is narrowed to, if any.
enum TimelineFacet {
  /// The Activity tab root — every Activity in the Household.
  all,

  /// The Activity tab root, showing only presses the Base recorded and nobody
  /// has attributed. The `All / Unassigned` control on `DASHBOARD`.
  unassigned,

  /// One Button's history, reached by tapping a word on a row.
  button,

  /// One Context's history, reached by tapping a Context.
  context,

  /// One Pusher's history, reached by tapping an avatar.
  pusher,
}

/// The query one timeline runs.
///
/// Value-equal, because it keys a provider family: two screens asking for the
/// same Button must share one loaded list rather than paginate twice.
///
/// [label] and [id] are carried together on purpose. A facet screen is reached
/// by tapping a badge, so the label is already in hand, and re-fetching a
/// Button just to render its own word would put a spinner where a word should
/// be. The id is what filters; the label is what the header says.
class TimelineQuery {
  const TimelineQuery._({required this.facet, this.id, this.label = ''});

  /// Everything, as the Activity tab shows it.
  const TimelineQuery.all() : this._(facet: TimelineFacet.all);

  /// Presses the Base recorded with no Pusher attributed.
  const TimelineQuery.unassigned() : this._(facet: TimelineFacet.unassigned);

  /// One Button, by id. [meaning] is its text — the word it speaks.
  const TimelineQuery.button({required int id, required String meaning})
    : this._(facet: TimelineFacet.button, id: id, label: meaning);

  /// One Context, by id.
  const TimelineQuery.context({required int id, required String text})
    : this._(facet: TimelineFacet.context, id: id, label: text);

  /// One Pusher, by id.
  const TimelineQuery.pusher({required int id, required String name})
    : this._(facet: TimelineFacet.pusher, id: id, label: name);

  final TimelineFacet facet;

  /// The facet's id, where the facet has one. Null for [TimelineFacet.all]
  /// and [TimelineFacet.unassigned].
  final int? id;

  /// What the facet is called, ready to render.
  final String label;

  /// True for the two roots — the screens that own the filter controls.
  ///
  /// The four facet screens suppress the settings row in the RN app
  /// (`DashboardInfiniteScroll.tsx:329-332`), which is why drilling into a
  /// Button silently drops the filters the user had set. This rewrite keeps the
  /// filters and says so on the facet screen instead; see
  /// `ActivityTimeline`'s filter strip.
  bool get isRoot =>
      facet == TimelineFacet.all || facet == TimelineFacet.unassigned;

  /// The noun for this facet, as the empty state and the header use it.
  String get facetNoun => switch (facet) {
    TimelineFacet.all || TimelineFacet.unassigned => 'Activity',
    TimelineFacet.button => 'Button',
    TimelineFacet.context => 'Context',
    TimelineFacet.pusher => 'Pusher',
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineQuery &&
          other.facet == facet &&
          other.id == id &&
          other.label == label;

  @override
  int get hashCode => Object.hash(facet, id, label);

  @override
  String toString() => 'TimelineQuery(${facet.name}, id: $id, label: $label)';
}

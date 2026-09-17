/// `HOUSEHOLD` — the roster of Pushers who share this Household, and the way
/// into `HOUSEHOLD_ADD` / `HOUSEHOLD_EDIT`.
///
/// A **root tab**, not a pushed screen (`lib/router/tabs.dart`, `screens.g.dart`
/// `navigator: 'HOUSEHOLD'`): first in tab order, landing on Activity is a
/// separate fact about which tab is *selected* on launch, and this screen never
/// draws a back chevron.
///
/// ## What is kept from `Household.tsx`
///
/// Every Learner and Teacher (Note and Base pseudo-Pushers excluded — they are
/// not members of anything, and `pushersProvider`'s fixture never contains
/// them), sorted archived-last then by interaction count, with an archived
/// toggle, a tap to edit, a distinct avatar tap to the Pusher's Activity feed,
/// a long-press for Edit/Archive, and the add-a-member affordance.
///
/// ## What changed, and why
///
/// * **The archived toggle is one switch-shaped row, not a modal with its own
///   Save.** The RN screen's "Show Archived" control opens a `Modal` with a
///   `Switch` and a separate `SAVE` button (`Household.tsx:188-210`) for a
///   value that is never sent anywhere — it only ever filters the list already
///   on screen. A control that writes nothing does not need a two-step commit.
/// * **"Add a Member" is the bottom-pinned primary button**
///   [HardwarePrimaryButton] in [HardwareActionBar], the same shape
///   `CONNECT A BASE` and every `SAVE` bar on these three screens already use,
///   rather than a port of `AddMemberButton.tsx`'s bespoke scalloped SVG
///   pill — the design system has no floating-action-button component, and one
///   bottom-pinned action pattern used everywhere is worth more than a second
///   shape used once.
/// * **The on-mount "add pusher guide" nudge is dropped.**
///   `shouldOpenAddPusherGuide` gates itself on `AsyncStorage`
///   (`STORAGE_KEYS.HAS_SEEN_ADD_PUSHER_GUIDE`), which is exactly the kind of
///   local persistence §15 excludes from phase 1, and it only fires when the
///   Household is missing a Learner or a Teacher — never true against the one
///   fixture Household, which always has both. Auto-pushing a modal the moment
///   a root tab lands is also the kind of surprise navigation the rest of this
///   pass has been removing, not adding. The affordance it would have opened
///   — `HOUSEHOLD_ADD` — is reachable from the button below regardless.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../hardware/hardware_ui.dart';
import '../log/log_controls.dart';

class HouseholdScreen extends ConsumerStatefulWidget {
  const HouseholdScreen({super.key});

  @override
  ConsumerState<HouseholdScreen> createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends ConsumerState<HouseholdScreen> {
  /// Local UI state, same reasoning as the RN screen's `showArchive`: it
  /// filters what is already loaded and is never sent anywhere, so it does not
  /// need to survive navigating away and back.
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final household = ref.watch(householdProvider);
    final pushers = ref.watch(pushersProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Household',
              subtitle: household.maybeWhen(
                data: (h) => h.name,
                orElse: () => null,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // The people with accounts, as against the Pushers below.
                  // The PRD delivers invitations in-app, so this is where a
                  // pending one is found; it earns a header slot for that.
                  LogHeaderIconButton(
                    icon: PhosphorIconsRegular.usersThree,
                    semanticLabel: 'Household members and invitations',
                    onTap: () => context.push(FpScreen.householdMembers.path),
                  ),
                  LogHeaderIconButton(
                    icon: PhosphorIconsRegular.slidersHorizontal,
                    semanticLabel: 'Archived members',
                    onTap: _openArchiveSheet,
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: c.textBrand,
                backgroundColor: c.surfaceRaised,
                onRefresh: () async {
                  ref.invalidate(householdProvider);
                  ref.invalidate(pushersProvider);
                },
                child: switch (pushers) {
                  AsyncData<List<Pusher>>(:final value) =>
                    _Roster(pushers: value, showArchived: _showArchived),
                  AsyncError<List<Pusher>>() => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const <Widget>[
                        HardwareNotice(
                          icon: PhosphorIconsRegular.warningOctagon,
                          title: 'Could not load your Household',
                          body: 'Pull down to try again.',
                          tone: HardwareNoticeTone.danger,
                        ),
                      ],
                    ),
                  _ => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const <Widget>[HardwareLoading()],
                    ),
                },
              ),
            ),
            HardwareActionBar(
              child: HardwarePrimaryButton(
                label: 'ADD A MEMBER',
                icon: PhosphorIconsRegular.plus,
                onPressed: () => context.push(FpScreen.householdAdd.path),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openArchiveSheet() async {
    final result = await showHardwareActions<bool>(
      context: context,
      title: 'Archived members',
      message: 'Hidden Pushers still own their history. Archiving is a '
          'preview-only toggle in this build and is not saved.',
      options: <HardwareAction<bool>>[
        HardwareAction<bool>(
          label: 'Show archived members',
          value: true,
          icon: PhosphorIconsRegular.archive,
          selected: _showArchived,
        ),
        HardwareAction<bool>(
          label: 'Hide archived members',
          value: false,
          icon: PhosphorIconsRegular.eyeSlash,
          selected: !_showArchived,
        ),
      ],
    );
    if (result == null || !mounted) return;
    setState(() => _showArchived = result);
  }
}

class _Roster extends StatelessWidget {
  const _Roster({required this.pushers, required this.showArchived});

  final List<Pusher> pushers;
  final bool showArchived;

  @override
  Widget build(BuildContext context) {
    // Real Learners and Teachers only — the fixture never contains a
    // pseudo-Pusher, but a screen that assumed that rather than stating it
    // is one fixture edit away from drawing a "?" avatar in a member list.
    final members = pushers.where((p) => p.isLearner || p.isTeacher).toList()
      ..sort(_byArchivedThenPresses);
    final visible =
        showArchived ? members : members.where((p) => !p.isHidden).toList();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s2,
        FpSpace.s6,
        FpSpace.s8,
      ),
      children: <Widget>[
        const SectionHeading(label: 'Members'),
        const SizedBox(height: FpSpace.s4),
        if (visible.isEmpty)
          HardwareNotice(
            icon: PhosphorIconsRegular.usersThree,
            title: 'Get started by adding a Household Member',
            body: 'Add the pet who presses the Buttons, or a person who '
                'models words for them.',
            action: LogTextAction(
              label: 'Add a member',
              icon: PhosphorIconsRegular.plus,
              onTap: () => context.push(FpScreen.householdAdd.path),
            ),
          )
        else
          for (final pusher in visible) ...<Widget>[
            _MemberCard(pusher: pusher),
            const SizedBox(height: FpSpace.s4),
          ],
      ],
    );
  }

  /// `Household.tsx:51-60`'s comparator: archived last, then by interaction
  /// count descending. The RN third key is `created_at`, which
  /// [Pusher] does not carry (`lib/domain/pusher.dart`); name ascending is
  /// the stand-in, so the order is at least stable rather than
  /// undefined for two Pushers that tie on both real keys.
  static int _byArchivedThenPresses(Pusher a, Pusher b) {
    if (a.isHidden != b.isHidden) return a.isHidden ? 1 : -1;
    final byCount = b.interactionsCount.compareTo(a.interactionsCount);
    if (byCount != 0) return byCount;
    return a.name.compareTo(b.name);
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.pusher});

  final Pusher pusher;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final archived = pusher.isHidden;
    final typeLabel = pusher.isTeacher
        ? 'Teacher'
        : (pusher.learnerType == null || pusher.learnerType!.isEmpty)
            ? 'Learner'
            : pusher.learnerType!;

    return HardwareCard(
      semanticLabel: '${pusher.name}, $typeLabel'
          '${archived ? ', archived' : ''}',
      onTap: () => _openEdit(context),
      onLongPress: () => _openActions(context),
      child: Row(
        children: <Widget>[
          // The avatar is its own tap target, to the Pusher's Activity feed —
          // distinct from the card's own tap, which opens `HOUSEHOLD_EDIT`.
          // The two destinations are real and different
          // (`Household.tsx:141-153`), and Flutter resolves a tap inside a
          // smaller opaque region to the inner detector before the outer
          // `InkWell` sees it, the same way an icon button inside a list tile
          // works anywhere else in Flutter.
          GestureDetector(
            onTap: () => _openFeed(context),
            behavior: HitTestBehavior.opaque,
            child: Opacity(
              opacity: archived ? 0.6 : 1.0,
              child: PusherAvatar(pusher: pusher, size: PusherAvatarSize.md),
            ),
          ),
          const SizedBox(width: FpSpace.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  pusher.name,
                  style: FpType.displaySm.copyWith(
                    color: archived ? c.textTertiary : c.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: FpSpace.s1),
                MetaLine(
                  facts: <MetaFact>[
                    MetaFact(typeLabel.toUpperCase()),
                    MetaFact(
                      FpFormat.largeCountOf(pusher.interactionsCount, 'press'),
                    ),
                    if (archived) const MetaFact('Archived'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: FpSpace.s3),
          PhosphorIcon(
            PhosphorIconsRegular.caretRight,
            size: FpIconSize.md,
            color: c.textTertiary,
          ),
        ],
      ),
    );
  }

  void _openFeed(BuildContext context) {
    context.push(
      '${FpScreen.dashboardPusher.path}?pusherId=${pusher.id}'
      '&name=${Uri.encodeComponent(pusher.name)}',
    );
  }

  void _openEdit(BuildContext context) {
    context.push('${FpScreen.householdEdit.path}?id=${pusher.id}');
  }

  Future<void> _openActions(BuildContext context) async {
    final archived = pusher.isHidden;
    final choice = await showHardwareActions<_MemberAction>(
      context: context,
      title: pusher.name,
      message: pusher.isTeacher ? 'Teacher' : (pusher.learnerType ?? 'Learner'),
      options: <HardwareAction<_MemberAction>>[
        const HardwareAction<_MemberAction>(
          label: 'Edit',
          value: _MemberAction.edit,
          icon: PhosphorIconsRegular.pencilSimple,
        ),
        HardwareAction<_MemberAction>(
          label: archived ? 'Unarchive' : 'Archive',
          value: _MemberAction.toggleArchive,
          icon: archived
              ? PhosphorIconsRegular.arrowUUpLeft
              : PhosphorIconsRegular.archive,
          destructive: !archived,
        ),
      ],
    );
    if (!context.mounted || choice == null) return;

    switch (choice) {
      case _MemberAction.edit:
        _openEdit(context);
      case _MemberAction.toggleArchive:
        // `updatePusherVisibilityMutation` is a write `HouseholdRepository`
        // has no method for (`lib/data/repositories.dart` — `household()` and
        // `pushers()` only). §15 no-op, same words as the rest of this pass.
        showPhaseOneNotice(
          context,
          '${pusher.name} ${archived ? 'not restored' : 'not archived'}',
        );
    }
  }
}

enum _MemberAction { edit, toggleArchive }

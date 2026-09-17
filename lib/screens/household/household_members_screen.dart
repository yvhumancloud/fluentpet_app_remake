/// `HOUSEHOLD_MEMBERS` — the people who share this Household, and the
/// invitations in both directions.
///
/// No RN screen of its own: `src/Home/Settings/SharedHouseholdSettings.tsx`
/// rendered all of this inside `SETTINGS`, gated on an admin flag. The PRD
/// makes invitations first-class and in-app — "when a user signs in, `GET /me`
/// and `GET /household/invitations` surface any pending invitation addressed
/// to their email" — so the surface gets a screen and a route, pushed on the
/// root navigator like `SETTINGS` itself, reached from the Household tab's
/// header and from Settings.
///
/// ## What is kept from the RN component
///
/// Every section and every action, in the same order: who owns the Household
/// (with LEAVE for a member), the member list (ME / OWNER badges, REMOVE for
/// the admin), invitations sent (REMOVE for the admin, plus the invite field),
/// invitations received (ACCEPT / DECLINE), and the explanatory note. The
/// `canLeaveHousehold` rule is reproduced: an admin with other members cannot
/// leave, and cannot accept an invitation either, and the screen says why
/// rather than just disabling.
///
/// ## What changed
///
/// * The RN component keyed every mutation by email. The PRD keys members and
///   invitations by id (`DELETE /household/members/{user_id}`,
///   `POST /household/invitations/{id}/accept`), so [HouseholdMember.id] and
///   [HouseholdInvitation.id] are what the handlers carry.
/// * "You are the owner of X Household" was one caption; here the screen
///   header carries the Household name and the caption carries only the fact.
/// * Every destructive action confirms first with [confirmDestructive], the
///   same dialog Hardware's Delete uses, rather than a bare `Alert.alert`.
///
/// Fixtures only (PLAN.md): invite, remove, accept, decline and leave all
/// validate and then say so through [showPhaseOneNotice].
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../auth/auth_rules.dart';
import '../hardware/hardware_ui.dart';
import '../log/log_controls.dart';
import '../settings/settings_ui.dart' show SettingsTextField;
import 'household_ui.dart';

class HouseholdMembersScreen extends ConsumerStatefulWidget {
  const HouseholdMembersScreen({super.key});

  @override
  ConsumerState<HouseholdMembersScreen> createState() =>
      _HouseholdMembersScreenState();
}

class _HouseholdMembersScreenState
    extends ConsumerState<HouseholdMembersScreen> {
  final TextEditingController _invite = TextEditingController();
  String? _inviteError;

  @override
  void dispose() {
    _invite.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final household = ref.watch(householdProvider);
    final me = ref.watch(meProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Household members',
              subtitle: household.value?.name,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: RefreshIndicator(
                color: c.textBrand,
                backgroundColor: c.surfaceRaised,
                onRefresh: () async {
                  ref.invalidate(householdProvider);
                  ref.invalidate(meProvider);
                },
                child: switch ((household, me)) {
                  (
                    AsyncData<Household>(value: final h),
                    AsyncData<HouseholdMember>(value: final m)
                  ) =>
                    _body(h, m),
                  (AsyncError<Household>(), _) ||
                  (_, AsyncError<HouseholdMember>()) =>
                    ListView(
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
          ],
        ),
      ),
    );
  }

  Widget _body(Household household, HouseholdMember me) {
    final c = context.fpColors;
    final isAdmin = me.isAdmin;
    // `canLeaveHousehold` in the RN component: an admin is stuck while anyone
    // else is in the Household. The PRD's `POST /household/leave` says the
    // same — "not allowed for admin unless sole member".
    final canLeave = !isAdmin || household.members.length == 1;
    final admins = household.admins.map(_printUser).join(', ');

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s2,
        FpSpace.s6,
        FpSpace.s8,
      ),
      children: <Widget>[
        Text(
          isAdmin
              ? 'You own this Household. You can invite and remove members '
                  'below.'
              : 'You are a member of this Household, owned by $admins.',
          style: FpType.bodySm.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: FpSpace.s3),
        if (canLeave)
          LogTextAction(
            label: 'Leave Household',
            icon: PhosphorIconsRegular.signOut,
            onTap: _leave,
          )
        else
          Text(
            'As the owner you cannot leave until you are the only member.',
            style: FpType.bodySm.copyWith(color: c.textTertiary),
          ),
        const SizedBox(height: FpSpace.s6),
        const LogHairline(),
        const SizedBox(height: FpSpace.s6),
        LogSection(
          title: 'Members',
          child: Column(
            children: <Widget>[
              for (final member in household.members)
                _PersonRow(
                  name: _printUser(member),
                  badges: <String>[
                    if (member.id == me.id) 'ME',
                    if (member.isAdmin) 'OWNER',
                  ],
                  actions: <_RowAction>[
                    if (isAdmin && member.id != me.id)
                      _RowAction(
                        label: 'Remove',
                        destructive: true,
                        onTap: () => _remove(member),
                      ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: FpSpace.s6),
        const LogHairline(),
        const SizedBox(height: FpSpace.s6),
        LogSection(
          title: 'Invitations sent',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (household.outgoing.isEmpty)
                Text(
                  'No invitations sent.',
                  style: FpType.bodySm.copyWith(color: c.textTertiary),
                ),
              for (final invitation in household.outgoing)
                _PersonRow(
                  name: _printInvitee(invitation),
                  badges: const <String>['PENDING'],
                  actions: <_RowAction>[
                    if (isAdmin)
                      _RowAction(
                        label: 'Remove',
                        destructive: true,
                        onTap: () => _withdraw(invitation),
                      ),
                  ],
                ),
              if (isAdmin) ...<Widget>[
                const SizedBox(height: FpSpace.s4),
                SettingsTextField(
                  controller: _invite,
                  hintText: 'Invite by email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() => _inviteError = null),
                ),
                if (_inviteError != null) ...<Widget>[
                  const SizedBox(height: FpSpace.s2),
                  HouseholdFieldError(message: _inviteError!),
                ],
                const SizedBox(height: FpSpace.s3),
                LogActionButton(
                  label: 'INVITE',
                  tone: LogActionTone.secondary,
                  onPressed: _invite.text.trim().isEmpty ? null : _sendInvite,
                ),
                const SizedBox(height: FpSpace.s2),
                Text(
                  'They see the invitation in the app the next time they sign '
                  'in. It lasts 72 hours.',
                  style: FpType.bodySm.copyWith(color: c.textTertiary),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: FpSpace.s6),
        const LogHairline(),
        const SizedBox(height: FpSpace.s6),
        LogSection(
          title: 'Invitations to join another Household',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (household.incoming.isEmpty)
                Text(
                  'No pending invitations.',
                  style: FpType.bodySm.copyWith(color: c.textTertiary),
                ),
              for (final invitation in household.incoming)
                _PersonRow(
                  name: _printInvitee(invitation),
                  actions: <_RowAction>[
                    _RowAction(
                      label: 'Accept',
                      onTap: canLeave ? () => _accept(invitation) : null,
                    ),
                    _RowAction(
                      label: 'Decline',
                      onTap: () => _decline(invitation),
                    ),
                  ],
                ),
              if (household.incoming.isNotEmpty && !canLeave) ...<Widget>[
                const SizedBox(height: FpSpace.s2),
                Text(
                  'Accepting moves you to their Household, which the owner '
                  'of this one cannot do while other members remain.',
                  style: FpType.bodySm.copyWith(color: c.textTertiary),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: FpSpace.s6),
        const LogHairline(),
        const SizedBox(height: FpSpace.s6),
        const HouseholdInfoNote(
          text: 'Everyone in a Household shares its Pushers, Buttons, Bases '
              'and activity. The owner invites and removes members. If you '
              'join another Household you can always leave it again, and '
              'you get a fresh Household of your own.',
        ),
      ],
    );
  }

  // ─────────────────────────── actions ───────────────────────────

  /// `printUser` in the RN component: a name that is really an email is not
  /// printed twice.
  static String _printUser(HouseholdMember m) =>
      m.fullname.contains('@') ? m.fullname : '${m.fullname}, ${m.email}';

  static String _printInvitee(HouseholdInvitation i) =>
      i.fullname.contains('@') ? i.fullname : '${i.fullname}, ${i.email}';

  void _sendInvite() {
    final error = AuthRules.emailError(_invite.text);
    if (error != null) {
      setState(() => _inviteError = error);
      return;
    }
    // POST /api/v1/household/invitations is a phase-1 no-op.
    showPhaseOneNotice(context, 'Invite ${_invite.text.trim()}');
    setState(() => _invite.clear());
  }

  Future<void> _remove(HouseholdMember member) async {
    final ok = await confirmDestructive(
      context: context,
      title: 'Remove ${member.fullname}?',
      message: 'They will be moved to a fresh Household of their own.',
      confirmLabel: 'Remove',
    );
    if (ok && mounted) showPhaseOneNotice(context, 'Remove ${member.email}');
  }

  Future<void> _withdraw(HouseholdInvitation invitation) async {
    final ok = await confirmDestructive(
      context: context,
      title: 'Remove invitation?',
      message: '${invitation.email} will not be able to join your Household.',
      confirmLabel: 'Remove',
    );
    if (ok && mounted) {
      showPhaseOneNotice(context, 'Withdraw invite to ${invitation.email}');
    }
  }

  Future<void> _accept(HouseholdInvitation invitation) async {
    final ok = await confirmDestructive(
      context: context,
      title: 'Join ${invitation.fullname}’s Household?',
      message: 'You leave this one. Your other pending invitations are '
          'declined.',
      confirmLabel: 'Join',
    );
    if (ok && mounted) {
      showPhaseOneNotice(context, 'Accept invite from ${invitation.email}');
    }
  }

  void _decline(HouseholdInvitation invitation) =>
      showPhaseOneNotice(context, 'Decline invite from ${invitation.email}');

  Future<void> _leave() async {
    final ok = await confirmDestructive(
      context: context,
      title: 'Leave Household?',
      message: 'You get a fresh Household of your own. Nothing here is '
          'deleted.',
      confirmLabel: 'Leave',
    );
    if (ok && mounted) showPhaseOneNotice(context, 'Leave Household');
  }
}

// ─────────────────────────── rows ───────────────────────────

class _RowAction {
  const _RowAction({
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final String label;

  /// Null disables; the row's caption says why.
  final VoidCallback? onTap;
  final bool destructive;
}

/// One person: a name, the badges that describe them, and the actions the
/// viewer may take on them.
///
/// The RN component draws badges and actions as identical filled pills, which
/// is why ME and OWNER "buttons" had to be `disabled`. Here a badge is a
/// label and an action is a [LogTextAction], so nothing inert looks pressable.
class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.name,
    this.badges = const <String>[],
    this.actions = const <_RowAction>[],
  });

  final String name;
  final List<String> badges;
  final List<_RowAction> actions;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FpSpace.s3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PhosphorIcon(
            PhosphorIconsRegular.userCircle,
            size: FpIconSize.lg,
            color: c.textSecondary,
          ),
          const SizedBox(width: FpSpace.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: FpType.bodyMd.copyWith(color: c.textPrimary),
                ),
                if (badges.isNotEmpty || actions.isNotEmpty)
                  Wrap(
                    spacing: FpSpace.s4,
                    runSpacing: FpSpace.s1,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      for (final badge in badges)
                        Text(
                          badge,
                          style: FpType.labelSm.copyWith(color: c.textTertiary),
                        ),
                      for (final action in actions)
                        action.onTap == null
                            ? Text(
                                action.label,
                                style: FpType.labelMd
                                    .copyWith(color: c.textDisabled),
                              )
                            : _ActionText(action: action),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionText extends StatelessWidget {
  const _ActionText({required this.action});

  final _RowAction action;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      label: action.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: action.onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: FpSpace.s2),
            child: Text(
              action.label,
              style: FpType.labelMd.copyWith(
                color: action.destructive ? c.statusDangerFg : c.textBrand,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

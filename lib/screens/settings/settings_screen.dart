/// `SETTINGS` — `src/Home/Settings/Settings.tsx`, titled "ADVANCED TOOLS" in
/// the RN app and "Tools" in its route name. It is plain Settings now: with
/// the diagnostic rows gone, what is left is what every user needs.
///
/// Presentation is `drawer` in `screens.g.dart` — the RN app reaches this from
/// a side drawer, not a tab or a modal. `app_router.dart` has no drawer
/// concept; it is an ordinary pushed route, so it gets the ratified back
/// chevron rather than a close.
///
/// ## What the RN screen was, and what the PRD keeps
///
/// A flat, feature-flag-gated list of admin and diagnostic tools: PetCube
/// account linking, CSV data export, shared-Household invites,
/// impersonate-a-user, switch API environment, force-crash / log-error /
/// reset-onboarding, delete-account, and the app version.
///
/// `../backend/PRD.md` lists Petcube, CSV reports and the onboarding
/// questionnaire as non-goals, has one deployed environment per build, and has
/// no crash button worth a row. Those sections are gone. What it keeps or adds
/// is what is here:
///
/// * **Account** — `PATCH /me` (`full_name`), and sign-out, which Firebase
///   Auth needs a door for and the RN app hid in Auth0's browser session.
/// * **Notifications** — the `push_frequency` preference, all three values.
///   The Activity tab's Snooze switch is the `none` value of the same
///   provider, so the two controls cannot disagree.
/// * **Default Pusher** — the `default_pusher_id` preference: who a Base press
///   goes to when the Base has no default of its own.
/// * **Household** — one line of counts and the way into `HOUSEHOLD_MEMBERS`,
///   which is where the RN component's whole invitation list now lives.
/// * **Admin** — a session toggle standing in for the Firebase `admin` custom
///   claim, gating Login-as (`X-Login-As`, which the PRD keeps and logs).
/// * **Delete account** — `DELETE /me`, required by Play Store policy. The
///   copy now says what the PRD does: immediate, and blocked for the owner of
///   a Household that still has other members.
/// * **Appearance** — new to this app (ADR 0002), unchanged from last pass.
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
import '../../theme/theme_mode.dart';
import '../../widgets/widgets.dart';
import '../hardware/hardware_providers.dart' show appDebuggingEnabledProvider;
import '../hardware/hardware_ui.dart'
    show HardwareAction, MetaFact, MetaLine, showHardwareActions, showPhaseOneNotice;
import '../log/log_controls.dart';
import 'settings_ui.dart' show SettingsTextField;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _loginAsEmail = TextEditingController();
  bool _loggedInAsSomeone = false;

  /// The user the name field was filled from, so a rebuild does not overwrite
  /// what someone is typing — the same guard `BASE_EDIT` uses.
  int? _loadedFor;

  @override
  void dispose() {
    _fullName.dispose();
    _loginAsEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final admin = ref.watch(appDebuggingEnabledProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      // `bottom: true`: this screen is a plain push on the root navigator,
      // outside every tab, so nothing under it already claims the bottom
      // safe-area inset the way `FpTabBar` does for a tab-branch screen.
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Settings',
              onBack: context.canPop() ? () => context.pop() : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FpSpace.s6,
                  FpSpace.s2,
                  FpSpace.s6,
                  FpSpace.s8,
                ),
                children: <Widget>[
                  _accountSection(),
                  const SizedBox(height: FpSpace.s6),
                  const LogHairline(),
                  const SizedBox(height: FpSpace.s6),
                  _appearanceSection(),
                  const SizedBox(height: FpSpace.s6),
                  const LogHairline(),
                  const SizedBox(height: FpSpace.s6),
                  _notificationsSection(),
                  const SizedBox(height: FpSpace.s6),
                  const LogHairline(),
                  const SizedBox(height: FpSpace.s6),
                  _defaultPusherSection(),
                  const SizedBox(height: FpSpace.s6),
                  const LogHairline(),
                  const SizedBox(height: FpSpace.s6),
                  _householdSection(),
                  const SizedBox(height: FpSpace.s6),
                  const LogHairline(),
                  const SizedBox(height: FpSpace.s6),
                  _adminToggleSection(admin),
                  if (admin) ...<Widget>[
                    const SizedBox(height: FpSpace.s6),
                    const LogHairline(),
                    const SizedBox(height: FpSpace.s6),
                    _loginAsSection(),
                  ],
                  const SizedBox(height: FpSpace.s6),
                  const LogHairline(),
                  const SizedBox(height: FpSpace.s6),
                  _deleteAccountSection(),
                  const SizedBox(height: FpSpace.s6),
                  const LogHairline(),
                  const SizedBox(height: FpSpace.s6),
                  _appVersionSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── account ───────────────────────────

  /// `PATCH /me` for the name; email is Firebase's and read-only here.
  Widget _accountSection() {
    final c = context.fpColors;
    final me = ref.watch(meProvider);
    return LogSection(
      title: 'Account',
      child: switch (me) {
        AsyncData<HouseholdMember>(:final value) => Builder(
            builder: (context) {
              if (_loadedFor != value.id) {
                _loadedFor = value.id;
                _fullName.text = value.fullname;
              }
              final dirty = _fullName.text.trim() != value.fullname;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SettingsTextField(
                    controller: _fullName,
                    hintText: 'Your name',
                    keyboardType: TextInputType.name,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: FpSpace.s2),
                  Text(
                    value.email,
                    style: FpType.bodySm.copyWith(color: c.textTertiary),
                  ),
                  const SizedBox(height: FpSpace.s3),
                  LogActionButton(
                    label: 'SAVE NAME',
                    tone: LogActionTone.secondary,
                    onPressed: dirty && _fullName.text.trim().isNotEmpty
                        ? () => showPhaseOneNotice(context, 'Name change')
                        : null,
                  ),
                  const SizedBox(height: FpSpace.s4),
                  LogTextAction(
                    label: 'Sign out',
                    icon: PhosphorIconsRegular.signOut,
                    onTap: () => context.go(FpScreen.welcome.path),
                  ),
                ],
              );
            },
          ),
        AsyncError<HouseholdMember>() => Text(
            'Could not load your account.',
            style: FpType.bodySm.copyWith(color: c.statusDangerFg),
          ),
        _ => Text(
            'Loading…',
            style: FpType.bodySm.copyWith(color: c.textTertiary),
          ),
      },
    );
  }

  // ─────────────────────────── appearance ───────────────────────────

  /// The light/dark/system control. Reads and writes `themeModeProvider`
  /// directly — `theme_mode.dart` is Foundation's file and already does
  /// exactly what a settings row needs; this only draws the row.
  Widget _appearanceSection() {
    final mode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);
    return LogSection(
      title: 'Appearance',
      child: Column(
        children: <Widget>[
          LogCheckRow(
            label: 'Match system',
            selected: mode == ThemeMode.system,
            onTap: () => notifier.set(ThemeMode.system),
          ),
          LogCheckRow(
            label: 'Light',
            selected: mode == ThemeMode.light,
            onTap: () => notifier.set(ThemeMode.light),
          ),
          LogCheckRow(
            label: 'Dark',
            selected: mode == ThemeMode.dark,
            onTap: () => notifier.set(ThemeMode.dark),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── notifications ───────────────────────────

  /// `push_frequency`. The RN app only ever wrote `all` and `none` (the
  /// Snooze switch); the PRD adds `on_interaction`, so the full set is here.
  Widget _notificationsSection() {
    final c = context.fpColors;
    final frequency = ref.watch(pushFrequencyProvider);
    final notifier = ref.read(pushFrequencyProvider.notifier);
    return LogSection(
      title: 'Press notifications',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LogCheckRow(
            label: 'Every press',
            selected: frequency == PushFrequency.all,
            onTap: () => notifier.set(PushFrequency.all),
          ),
          LogCheckRow(
            label: 'First press of each Interaction',
            selected: frequency == PushFrequency.onInteraction,
            onTap: () => notifier.set(PushFrequency.onInteraction),
          ),
          LogCheckRow(
            label: 'None',
            selected: frequency == PushFrequency.none,
            onTap: () => notifier.set(PushFrequency.none),
          ),
          const SizedBox(height: FpSpace.s1),
          Text(
            'Base battery, offline and Button link notices are always sent. '
            '"None" is the Snooze switch on the Activity tab.',
            style: FpType.bodySm.copyWith(color: c.textTertiary),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── default pusher ───────────────────────────

  /// `default_pusher_id`. A Base's own default wins over this one.
  Widget _defaultPusherSection() {
    final c = context.fpColors;
    final id = ref.watch(defaultPusherIdProvider);
    final pushers = ref.watch(pushersProvider).value ?? const <Pusher>[];
    final chosen = pushers.where((p) => p.id == id).firstOrNull;
    return LogSection(
      title: 'Default Pusher',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LogSelectRow(
            label: 'Presses go to',
            onTap: () => _chooseDefaultPusher(pushers, chosen),
            child: Text(
              chosen?.name ?? 'Nobody — left unassigned',
              style: FpType.bodyMd.copyWith(
                color: chosen == null ? c.textTertiary : c.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: FpSpace.s2),
          Text(
            'Used when a Base has no Default Presser of its own.',
            style: FpType.bodySm.copyWith(color: c.textTertiary),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseDefaultPusher(List<Pusher> pushers, Pusher? current) async {
    final choice = await showHardwareActions<int>(
      context: context,
      title: 'Default Pusher',
      options: <HardwareAction<int>>[
        HardwareAction<int>(
          label: 'Nobody',
          // Sentinel: the sheet cannot return null for "None" because null
          // already means "dismissed".
          value: _none,
          description: 'Leave those presses unassigned.',
          selected: current == null,
        ),
        for (final pusher in pushers)
          if (!pusher.isHidden && pusher.id != Pusher.journalPusherId)
            HardwareAction<int>(
              label: pusher.name,
              value: pusher.id,
              description: pusher.isLearner
                  ? (pusher.learnerType ?? 'Learner')
                  : 'Teacher',
              selected: current?.id == pusher.id,
            ),
      ],
    );
    if (choice == null) return;
    ref.read(defaultPusherIdProvider.notifier).set(choice == _none ? null : choice);
  }

  static const int _none = -1;

  // ─────────────────────────── household ───────────────────────────

  /// Reads the same `householdProvider` the Household tab does, and hands off
  /// to `HOUSEHOLD_MEMBERS` for everything else — the invitation list lives
  /// there now, and a second copy here is how the two start disagreeing.
  Widget _householdSection() {
    final household = ref.watch(householdProvider);
    return LogSection(
      title: 'Household',
      child: switch (household) {
        AsyncData<Household>(:final value) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MetaLine(
                facts: <MetaFact>[
                  MetaFact(value.name),
                  MetaFact(FpFormat.countOf(value.members.length, 'member')),
                  if (value.incoming.isNotEmpty)
                    MetaFact(
                      '${FpFormat.countOf(value.incoming.length, 'invite')} '
                      'waiting on you',
                    ),
                  if (value.outgoing.isNotEmpty)
                    MetaFact(
                      '${FpFormat.countOf(value.outgoing.length, 'invite')} '
                      'sent',
                    ),
                ],
              ),
              const SizedBox(height: FpSpace.s3),
              LogTextAction(
                label: 'Members and invitations',
                icon: PhosphorIconsRegular.usersThree,
                onTap: () => context.push(FpScreen.householdMembers.path),
              ),
            ],
          ),
        AsyncError<Household>() => Text(
            'Could not load your Household.',
            style: FpType.bodySm
                .copyWith(color: context.fpColors.statusDangerFg),
          ),
        _ => Text(
            'Loading your Household…',
            style: FpType.bodySm.copyWith(color: context.fpColors.textTertiary),
          ),
      },
    );
  }

  // ─────────────────────────── admin gate ───────────────────────────

  /// Stands in for the Firebase `admin: true` custom claim. Shares
  /// `appDebuggingEnabledProvider` with `BASE_EDIT`'s shadow dump so there is
  /// one admin switch, not two that can disagree.
  Widget _adminToggleSection(bool admin) {
    final c = context.fpColors;
    return LogSection(
      title: 'Admin',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LogCheckRow(
            label: 'Admin tools',
            selected: admin,
            onTap: () =>
                ref.read(appDebuggingEnabledProvider.notifier).toggle(),
          ),
          const SizedBox(height: FpSpace.s1),
          Text(
            'A stand-in for the admin claim on your sign-in. Also unlocks the '
            'device-state dump on a Base.',
            style: FpType.bodySm.copyWith(color: c.textTertiary),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── login as ───────────────────────────

  /// `X-Login-As`. Every use is logged server-side (PRD §7), which the caption
  /// says.
  Widget _loginAsSection() {
    final c = context.fpColors;
    return LogSection(
      title: 'Login as a different user',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_loggedInAsSomeone) ...<Widget>[
            Text(
              'You are logged in as ${_loginAsEmail.text}.',
              style: FpType.bodySm.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: FpSpace.s3),
            LogActionButton(
              label: 'LOGOUT',
              tone: LogActionTone.secondary,
              onPressed: () => setState(() => _loggedInAsSomeone = false),
            ),
          ] else ...<Widget>[
            SettingsTextField(
              controller: _loginAsEmail,
              hintText: 'Email, e.g. user@gmail.com',
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: FpSpace.s3),
            LogActionButton(
              label: 'LOGIN',
              tone: LogActionTone.secondary,
              onPressed: _loginAsEmail.text.trim().isEmpty
                  ? null
                  : () {
                      setState(() => _loggedInAsSomeone = true);
                      showPhaseOneNotice(
                        context,
                        'Signed in as ${_loginAsEmail.text}',
                      );
                    },
            ),
          ],
          const SizedBox(height: FpSpace.s3),
          Text(
            'You can view, add, edit or delete any of their data, so remain '
            'cautious. Every request made this way is logged.',
            style: FpType.bodySm.copyWith(color: c.textTertiary),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── delete account ───────────────────────────

  /// `DELETE /me`. Immediate, not a request; blocked for a Household owner
  /// with other members, which the copy says up front.
  Widget _deleteAccountSection() {
    final c = context.fpColors;
    return LogSection(
      title: 'Delete your account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Deletes your account and your sign-in straight away. If you own '
            'a Household with other members, remove them or hand it over '
            'first.',
            style: FpType.bodySm.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: FpSpace.s4),
          LogActionButton(
            label: 'DELETE YOUR ACCOUNT',
            tone: LogActionTone.secondary,
            onPressed: () async {
              final confirmed = await logConfirm(
                context,
                title: 'Are you sure?',
                message: 'This cannot be undone.',
                confirmLabel: 'Delete',
              );
              if (confirmed && mounted) {
                showPhaseOneNotice(context, 'Account deletion');
              }
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── app version ───────────────────────────

  Widget _appVersionSection() {
    return LogSection(
      title: 'App version',
      // pubspec.yaml's own `version:` field, mirroring `src/constants.ts`'s
      // `APP_VERSION`. Not read from a package-info platform channel: that
      // would be a new dependency for one static string on a phase that
      // ships no build pipeline to wire it through.
      child: Text(
        '1.0.0 (1)',
        style:
            FpType.monoSm.copyWith(color: context.fpColors.textTertiary),
      ),
    );
  }
}

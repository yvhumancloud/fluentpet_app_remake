/// `BASE_EDIT` — one Base's detail, settings and linked Buttons.
///
/// The densest of the four, and the one with the most to correct.
///
/// ## The not-loaded state, which was a data-loss affordance
///
/// The RN screen wraps its entire body in `{base && (…)}` while leaving the
/// **SAVE bar outside that guard** (`BaseEditScreen.tsx:264`, `:429`, §10,
/// §14.8). A stale deep link, or a Base deleted on another device, therefore
/// renders an empty screen with a live SAVE button over it — a control that
/// offers to write a form nobody can see, over a record that may not exist.
///
/// Here the screen resolves to one of four states and only one of them has a
/// SAVE bar: **loading** (a spinner, no bar), **not found** (a named state with
/// a way back, no bar), **failed** (the same, in the danger tone, no bar), and
/// **loaded** (the form, with the bar). The bar cannot outlive its form because
/// it is built from the same value.
///
/// ## Everything else, kept
///
/// The read-only header — name, battery, `ID:`, `Last Online At:`, firmware
/// (admin-only) and the device-shadow dump (admin-only). The three form fields
/// with their exact constraints. The linked-Button list with its search,
/// sort, per-Button serial, firmware chip and battery, and its Edit / Merge /
/// Unlink action sheet (the `+` row that opened BLE pairing is a caption now —
/// Buttons link themselves when a Base reports them). Pull to refresh. What
/// changed is recorded at each site.
///
/// One number is new: [HardwareMetrics.baseNameMaxLength]. The inventory marks
/// the Base name's maximum as **unknown** — none is enforced client-side and
/// the API's was not established (§10, §16) — so 40 is chosen here, argued for
/// where it is declared, and flagged as an invention.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import 'hardware_metrics.dart';
import 'hardware_providers.dart';
import 'hardware_ui.dart';

class BaseEditScreen extends ConsumerStatefulWidget {
  const BaseEditScreen({required this.serialNumber, super.key});

  /// The Base is addressed by serial, not by id — that is what the RN route
  /// carries and what `PATCH /api/v1/bases/{serial}` addresses.
  final String serialNumber;

  @override
  ConsumerState<BaseEditScreen> createState() => _BaseEditScreenState();
}

class _BaseEditScreenState extends ConsumerState<BaseEditScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _timing = TextEditingController();
  final TextEditingController _search = TextEditingController();

  /// Null and "not yet chosen" are different things: the Default Presser can
  /// deliberately be **None**, which the picker offers as a synthetic entry
  /// (`SelectPusherModal.tsx:43-46`). So the chosen value is held separately
  /// from whether a choice was made.
  Pusher? _pusher;
  bool _pusherChosen = false;

  /// The serial the controllers were filled from, so a rebuild does not
  /// overwrite what someone is typing.
  String? _loadedFor;

  String _query = '';

  @override
  void dispose() {
    _name.dispose();
    _timing.dispose();
    _search.dispose();
    super.dispose();
  }

  void _loadFrom(Base base) {
    if (_loadedFor == base.serialNumber) return;
    _loadedFor = base.serialNumber;
    _name.text = base.name ?? '';
    _timing.text = base.groupInteractionsWithinSeconds.toString();
    _pusher = base.defaultPusher;
    _pusherChosen = false;
  }

  /// The validator, reproduced from `validateInteractionTiming.ts` including
  /// its message. The bounds themselves come from `FpFormat`, so the form and
  /// the explanatory screen cannot quote two different ranges.
  String? get _timingError {
    final raw = _timing.text.trim();
    if (raw.isEmpty) return 'Interaction timing must be a valid number';
    final value = int.tryParse(raw);
    if (value == null) return 'Interaction timing must be a valid number';
    if (value < FpFormat.groupingWindowMinSeconds ||
        value > FpFormat.groupingWindowMaxSeconds) {
      return 'Interaction timing must be a number between '
          '${FpFormat.groupingWindowMinSeconds} and '
          '${FpFormat.groupingWindowMaxSeconds}';
    }
    return null;
  }

  bool _isDirty(Base base) {
    if (_name.text != (base.name ?? '')) return true;
    if (_timing.text != base.groupInteractionsWithinSeconds.toString()) {
      return true;
    }
    return _pusherChosen && _pusher?.id != base.defaultPusher?.id;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final base = ref.watch(baseBySerialProvider(widget.serialNumber));

    return switch (base) {
      AsyncData<Base?>(value: final found) when found != null =>
        _loaded(context, c, found),
      AsyncData<Base?>() => _missing(
          context,
          c,
          icon: PhosphorIconsRegular.magnifyingGlass,
          title: 'That Base is not here any more',
          body: 'Serial ${widget.serialNumber} is not in this Household. It '
              'may have been deleted, or the link that brought you here may be '
              'out of date.',
          tone: HardwareNoticeTone.neutral,
        ),
      AsyncError<Base?>() => _missing(
          context,
          c,
          icon: PhosphorIconsRegular.warningOctagon,
          title: 'Could not load this Base',
          body: 'Go back to Hardware and pull down to try again.',
          tone: HardwareNoticeTone.danger,
        ),
      _ => Scaffold(
          backgroundColor: c.surfaceCanvas,
          body: FpOsChrome(
            child: Column(
              children: <Widget>[
                ScreenHeader(
                  title: 'Base',
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                const Expanded(child: HardwareLoading()),
              ],
            ),
          ),
        ),
    };
  }

  /// Loading, not-found and failed all share this: a way back, and **no SAVE
  /// bar**. That absence is the fix.
  Widget _missing(
    BuildContext context,
    FpColors c, {
    required IconData icon,
    required String title,
    required String body,
    required HardwareNoticeTone tone,
  }) {
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Base',
              subtitle: widget.serialNumber,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  HardwareNotice(
                    icon: icon,
                    title: title,
                    body: body,
                    tone: tone,
                    action: HardwarePrimaryButton(
                      label: 'BACK TO HARDWARE',
                      onPressed: () => context.go(FpScreen.bases.path),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loaded(BuildContext context, FpColors c, Base base) {
    _loadFrom(base);
    final dirty = _isDirty(base);
    final error = _timingError;
    final canSave = dirty && error == null;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: base.displayName,
              subtitle: base.name == null ? 'Unnamed Base' : 'Base',
              onBack: () => Navigator.of(context).maybePop(),
              trailing: DeviceHealthPill.forBase(base),
            ),
            Expanded(
              child: RefreshIndicator(
                color: c.textBrand,
                backgroundColor: c.surfaceRaised,
                onRefresh: () async => refreshHardware(ref),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    FpSpace.s6,
                    FpSpace.s2,
                    FpSpace.s6,
                    FpSpace.s8,
                  ),
                  children: <Widget>[
                    _Facts(base: base),
                    const SizedBox(height: FpSpace.s8),
                    const SectionHeading(label: 'Settings'),
                    const SizedBox(height: FpSpace.s5),
                    _nameField(c),
                    const SizedBox(height: FpSpace.s7),
                    _timingField(c, base, error),
                    const SizedBox(height: FpSpace.s7),
                    _defaultPresser(c, base),
                    const SizedBox(height: FpSpace.s8),
                    _LinkedButtons(
                      base: base,
                      search: _search,
                      query: _query,
                      onQueryChanged: (value) => setState(() => _query = value),
                    ),
                    if (ref.watch(appDebuggingEnabledProvider)) ...<Widget>[
                      const SizedBox(height: FpSpace.s8),
                      _Diagnostics(base: base),
                    ],
                  ],
                ),
              ),
            ),
            HardwareActionBar(
              child: HardwarePrimaryButton(
                label: 'SAVE',
                onPressed: canSave ? () => _save(base) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── the three fields ───────────────────────────

  Widget _nameField(FpColors c) {
    final length = _name.text.characters.length;
    final showCounter = length >= HardwareMetrics.baseNameCounterFrom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FieldLabel(
          label: 'Base name',
          hint: 'What this Base is called in the app. The room it lives in is '
              'usually the useful answer.',
        ),
        const SizedBox(height: FpSpace.s3),
        HardwareTextField(
          controller: _name,
          hintText: 'Name',
          maxLength: HardwareMetrics.baseNameMaxLength,
          onChanged: (_) => setState(() {}),
        ),
        // The counter appears only near the limit. A permanent "0/40" tells
        // nobody anything and turns a name field into a form field.
        if (showCounter) ...<Widget>[
          const SizedBox(height: FpSpace.s2),
          Text(
            '$length of ${HardwareMetrics.baseNameMaxLength} characters',
            style: FpType.labelSm
                .copyWith(
                  color: length >= HardwareMetrics.baseNameMaxLength
                      ? c.statusWarningFg
                      : c.textTertiary,
                )
                .tabular,
          ),
        ],
      ],
    );
  }

  Widget _timingField(FpColors c, Base base, String? error) {
    final seconds = int.tryParse(_timing.text.trim());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: _FieldLabel(
                label: 'Interaction timing',
                hint: 'In seconds.',
              ),
            ),
            _HelpButton(
              onTap: () => context.push(
                '${FpScreen.baseEditInteractionTiming.path}'
                '?seconds=${base.groupInteractionsWithinSeconds}'
                '&name=${Uri.encodeComponent(base.displayName)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: FpSpace.s3),
        HardwareTextField(
          controller: _timing,
          keyboardType: TextInputType.number,
          // Every non-digit is stripped as it is typed, which is the RN
          // behaviour (`:359`) and is why the validator only ever sees digits.
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          errorText: error,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: FpSpace.s3),
        // The setting explained where it is set, in words, live.
        //
        // This is the load-bearing part: the window is *why* several presses
        // become one Interaction, and a bare number in a text field says none
        // of that. `FpFormat.groupingWindow` spells the units out in full.
        if (error == null && seconds != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PhosphorIcon(
                PhosphorIconsRegular.arrowsInLineHorizontal,
                size: FpIconSize.sm,
                color: c.textBrand,
              ),
              const SizedBox(width: FpSpace.s3),
              Expanded(
                child: Text(
                  seconds == FpFormat.groupingWindowMinSeconds
                      ? 'Every press is recorded as its own Interaction.'
                      : 'Presses less than ${FpFormat.groupingWindow(seconds)} '
                          'apart are recorded as one Interaction.',
                  style: FpType.bodySm.copyWith(color: c.textSecondary),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _defaultPresser(FpColors c, Base base) {
    final pusher = _pusher;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _FieldLabel(
          label: 'Default Presser',
          hint: 'Who a press is attributed to when this Base cannot tell.',
        ),
        const SizedBox(height: FpSpace.s3),
        Semantics(
          label: 'Default Presser, ${pusher?.name ?? 'none'}',
          button: true,
          child: ExcludeSemantics(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _choosePusher(base),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: HardwareMetrics.fieldMinHeight,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: FpSpace.s4,
                  vertical: FpSpace.s3,
                ),
                decoration: BoxDecoration(
                  color: c.surfaceRaised,
                  borderRadius: BorderRadius.circular(FpRadius.md),
                  border: Border.all(
                    color: c.borderDefault,
                    width: FpStroke.hairline,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    if (pusher != null)
                      PusherAvatar(pusher: pusher, size: PusherAvatarSize.md)
                    else
                      // The RN avatar falls back to the word "Add" with a plus
                      // (`getDefaultPusherAvatarText.ts`). An empty slot is
                      // drawn as an empty slot here rather than as a disc with
                      // a verb in it — a person's face and a control are not
                      // the same object.
                      Container(
                        width: FpMetrics.avatarMd,
                        height: FpMetrics.avatarMd,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: c.borderStrong,
                            width: FpStroke.hairline,
                          ),
                        ),
                        child: PhosphorIcon(
                          PhosphorIconsRegular.plus,
                          size: FpIconSize.sm,
                          color: c.textTertiary,
                        ),
                      ),
                    const SizedBox(width: FpSpace.s4),
                    Expanded(
                      child: Text(
                        pusher?.name ?? 'None',
                        style: FpType.bodyMd.copyWith(
                          color: pusher == null
                              ? c.textTertiary
                              : c.textPrimary,
                        ),
                      ),
                    ),
                    PhosphorIcon(
                      PhosphorIconsRegular.caretRight,
                      size: FpIconSize.sm,
                      color: c.textTertiary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _choosePusher(Base base) async {
    final pushers = ref.read(pushersProvider).value ?? const <Pusher>[];
    final current = _pusher;

    final choice = await showHardwareActions<_PusherChoice>(
      context: context,
      title: 'Default Presser',
      message: 'Presses this Base cannot attribute are recorded as this '
          'Pusher.',
      options: <HardwareAction<_PusherChoice>>[
        // "None" leads the list, exactly as the RN modal's synthetic entry
        // does when `enableSelectNone` is set.
        HardwareAction<_PusherChoice>(
          label: 'None',
          value: const _PusherChoice(null),
          description: 'Leave those presses unattributed.',
          selected: current == null,
        ),
        for (final pusher in pushers)
          // Hidden Pushers and the journal pseudo-Pusher are not people who
          // press Buttons, and the RN modal is fed `usePushers({onlyActive:
          // true})` for the same reason.
          if (!pusher.isHidden && pusher.id != Pusher.journalPusherId)
            HardwareAction<_PusherChoice>(
              label: pusher.name,
              value: _PusherChoice(pusher),
              description: pusher.isLearner
                  ? (pusher.learnerType ?? 'Learner')
                  : 'Teacher',
              selected: current?.id == pusher.id,
            ),
      ],
    );
    if (choice == null) return;
    setState(() {
      _pusher = choice.pusher;
      _pusherChosen = true;
    });
  }

  void _save(Base base) {
    // PATCH /api/v1/bases/{serial} is a §15 no-op. The RN screen pops on
    // success; this one stays, because popping after a write that did not
    // happen would report success the app cannot claim.
    showPhaseOneNotice(context, '${base.displayName} not saved');
  }
}

/// A Pusher, or the deliberate absence of one. Wrapping it means a cancelled
/// sheet and a chosen "None" are distinguishable — with a bare `Pusher?` they
/// would both be null.
class _PusherChoice {
  const _PusherChoice(this.pusher);

  final Pusher? pusher;
}

// ─────────────────────────── read-only facts ───────────────────────────

/// The header block: identity and health, as facts.
class _Facts extends ConsumerWidget {
  const _Facts({required this.base});

  final Base base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final now = ref.watch(hardwareNowProvider);
    final at = base.lastOnlineAt?.toLocal();

    return HardwareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FactRow(
            label: 'ID',
            value: base.serialNumber,
            mono: true,
            // The admin-only fields have no admin to gate on in phase 1. A
            // long-press on the serial is the switch that reveals them; it is
            // dev scaffolding, not product surface, and it is on the serial
            // because that is what a person reads out when they are already
            // debugging.
            onLongPress: () =>
                ref.read(appDebuggingEnabledProvider.notifier).toggle(),
          ),
          // The RN header labels this "Last Online At:" and renders it with
          // the very component the timeline uses — an absolute date and time,
          // then a relative age (§10, §13.1). Both halves are kept, stacked so
          // the age can take the danger tone without dragging the date with
          // it. The relative half is what now also appears on the Hardware
          // list, where this screen used to be the only place it existed.
          FactSlot(
            label: 'Last online',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // A Base that has never reported has no absolute date to
                // print, and printing the epoch or today would both be lies.
                // The relative half below says the whole of what is known.
                if (at != null)
                  Text(
                    '${FpFormat.fullDate(at, asOf: now)} · '
                    '${FpFormat.timeOfDay(at)}',
                    style: FpType.bodySm.copyWith(color: c.textPrimary),
                  )
                else
                  Text(
                    'This Base has never reported in.',
                    style: FpType.bodySm.copyWith(color: c.textSecondary),
                  ),
                const SizedBox(height: FpSpace.s1),
                Text(
                  FpFormat.lastSeen(base.lastOnlineAt, asOf: now),
                  style: FpType.labelMd.copyWith(
                    color: base.online ? c.textSecondary : c.statusDangerFg,
                  ),
                ),
              ],
            ),
          ),
          FactSlot(
            label: 'Battery',
            child: Align(
              alignment: Alignment.centerLeft,
              child: BatteryReadout(percent: base.batteryLevel),
            ),
          ),
          if (ref.watch(appDebuggingEnabledProvider))
            // Firmware is admin-only in the RN app (`appDebuggingEnabled`,
            // §13.4). Split on commas onto separate lines there; the same
            // here, because a Base can report more than one component's
            // version in that one string.
            FactRow(
              label: 'Firmware',
              value: base.firmwareVersion.isEmpty
                  ? 'not reported'
                  : base.firmwareVersion.split(',').join('\n'),
              mono: true,
            ),
        ],
      ),
    );
  }
}

/// The admin-only device-shadow dump.
///
/// The RN screen prints the whole AWS IoT shadow, `JSON.stringify`d twice
/// (`:416-423`). PLAN.md forbids a device shadow in phase 1, so what this
/// shows is the fixture's stand-in for it: the fields the shadow would have
/// carried, named, rather than a fabricated JSON blob pretending to be a
/// device's own report.
class _Diagnostics extends ConsumerWidget {
  const _Diagnostics({required this.base});

  final Base base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final linked = ref.watch(linkedButtonsProvider).value?[base.serialNumber] ??
        const <LinkedButton>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeading(
          label: 'Diagnostics',
          trailing: Text(
            'admin',
            style: FpType.labelSm.copyWith(color: c.statusInfoFg),
          ),
        ),
        const SizedBox(height: FpSpace.s5),
        HardwareCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'There is no device shadow in phase 1. These are the reported '
                'fields the shadow would carry.',
                style: FpType.bodySm.copyWith(color: c.textTertiary),
              ),
              const SizedBox(height: FpSpace.s4),
              FactRow(label: 'bat_level', value: '${base.batteryLevel}', mono: true),
              FactRow(
                label: 'fw_ver',
                value: base.firmwareVersion.isEmpty
                    ? '—'
                    : base.firmwareVersion,
                mono: true,
              ),
              FactRow(
                label: 'group_s',
                value: '${base.groupInteractionsWithinSeconds}',
                mono: true,
              ),
              const SizedBox(height: FpSpace.s3),
              Text(
                'paired_children',
                style: FpType.labelMd.copyWith(color: c.textTertiary),
              ),
              const SizedBox(height: FpSpace.s2),
              for (final child in linked)
                Text(
                  '${child.serialNumber}  ${child.firmwareVersion}'
                  '${child.isKnown ? '' : '  (not in database)'}',
                  style: FpType.monoSm.copyWith(color: c.textPrimary),
                ),
              if (linked.isEmpty)
                Text(
                  '—',
                  style: FpType.monoSm.copyWith(color: c.textTertiary),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── linked Buttons ───────────────────────────

class _LinkedButtons extends ConsumerWidget {
  const _LinkedButtons({
    required this.base,
    required this.search,
    required this.query,
    required this.onQueryChanged,
  });

  final Base base;
  final TextEditingController search;
  final String query;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final sort = ref.watch(buttonSortProvider);
    final linked = ref.watch(linkedButtonsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionHeading(label: 'Linked Buttons'),
        const SizedBox(height: FpSpace.s5),
        // The RN screen's `+` row opened the BLE pairing flow. There is no
        // pairing step in the PRD: a Base reports an unknown Button serial
        // and the API creates and links it (`POST /device/events`). So the
        // row says how a Button gets here, and does nothing on tap.
        Text(
          'Press a new Connect Button near this Base and it links itself.',
          style: FpType.bodySm.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: FpSpace.s5),
        switch (linked) {
          AsyncData<Map<String, List<LinkedButton>>>(:final value) =>
            _LinkedList(
              base: base,
              rows: value[base.serialNumber] ?? const <LinkedButton>[],
              sort: sort,
              search: search,
              query: query,
              onQueryChanged: onQueryChanged,
            ),
          AsyncError<Map<String, List<LinkedButton>>>() => HardwareNotice(
              icon: PhosphorIconsRegular.warningOctagon,
              title: 'Could not load this Base’s Buttons',
              body: 'Pull down to try again.',
              tone: HardwareNoticeTone.danger,
            ),
          // The RN list renders its search and sort controls over an empty
          // list while the query is in flight (`BaseButtonList.tsx:122`), so
          // the screen looks like a Base with no Buttons until the data
          // lands. Nothing is drawn here until there is something to draw.
          _ => const HardwareLoading(),
        },
      ],
    );
  }
}

class _LinkedList extends ConsumerWidget {
  const _LinkedList({
    required this.base,
    required this.rows,
    required this.sort,
    required this.search,
    required this.query,
    required this.onQueryChanged,
  });

  final Base base;
  final List<LinkedButton> rows;
  final ButtonSort sort;
  final TextEditingController search;
  final String query;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (rows.isEmpty) {
      return const HardwareNotice(
        icon: PhosphorIconsRegular.circlesThree,
        title: 'No linked Buttons',
        body: 'Nothing is paired to this Base yet. Pair a Connect Button and '
            'its presses arrive here without anyone logging them.',
      );
    }

    // Sorted by the Button behind the row where there is one; rows with no
    // Button in the database keep their shadow order at the end, because there
    // is nothing to sort them by and hiding them would make the count lie.
    final known = <LinkedButton>[];
    final unknown = <LinkedButton>[];
    for (final row in rows) {
      (row.isKnown ? known : unknown).add(row);
    }
    final order = sortButtons(known.map((r) => r.button!), sort);
    final sorted = <LinkedButton>[
      for (final button in order)
        known.firstWhere((r) => r.button!.id == button.id),
      ...unknown,
    ];

    final matched =
        sorted.where((r) => buttonMatches(r.label, query)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ButtonSearchAndSort(
          controller: search,
          sort: sort,
          onSortChanged: (next) =>
              ref.read(buttonSortProvider.notifier).set(next),
          onChanged: onQueryChanged,
          hintText: 'Search linked Buttons',
        ),
        const SizedBox(height: FpSpace.s5),
        if (matched.isEmpty)
          HardwareNotice(
            icon: PhosphorIconsRegular.magnifyingGlass,
            title: 'No linked Button starts with “${query.trim()}”',
            body: '${FpFormat.countOf(rows.length, 'Button')} '
                '${rows.length == 1 ? 'is' : 'are'} linked to this Base.',
          )
        else
          for (final row in matched)
            _LinkedButtonRow(base: base, row: row),
      ],
    );
  }
}

/// One linked Button: what it says, which one it is, what it is running, and
/// how full it is.
///
/// Two lines rather than one. The RN row puts the badge, the serial, the
/// version and the battery on a single flex-wrapping line, which at 390pt
/// wraps into something that reads as two unrelated rows. Here the word is the
/// line, and the hardware facts are the line under it.
class _LinkedButtonRow extends ConsumerWidget {
  const _LinkedButtonRow({required this.base, required this.row});

  final Base base;
  final LinkedButton row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final button = row.button;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: FpSpace.s3),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: button == null
                      // In the shadow, not in the database. Disabled, because
                      // there is no record to open, merge or edit.
                      ? const ButtonChip(
                          label: 'unavailable',
                          kind: ButtonKind.connect,
                          enabled: false,
                        )
                      : ButtonChip.of(
                          button,
                          onTap: () => _openActions(context, ref, button),
                          onLongPress: () => _openActions(context, ref, button),
                        ),
                ),
              ),
              const SizedBox(width: FpSpace.s3),
              BatteryReadout(percent: button?.batteryLevel, compact: true),
            ],
          ),
          const SizedBox(height: FpSpace.s3),
          Row(
            children: <Widget>[
              Text(
                // The last four characters, which is what is printed on the
                // hardware and all the RN row shows.
                row.shortSerial,
                style: FpType.monoSm.copyWith(color: c.textTertiary),
              ),
              const SizedBox(width: FpSpace.s4),
              _VersionChip(wireVersion: row.firmwareVersion),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openActions(
    BuildContext context,
    WidgetRef ref,
    Button button,
  ) async {
    final choice = await showHardwareActions<_LinkedAction>(
      context: context,
      title: button.text,
      message: 'Linked to ${base.displayName}',
      options: <HardwareAction<_LinkedAction>>[
        const HardwareAction<_LinkedAction>(
          label: 'Edit',
          value: _LinkedAction.edit,
          icon: PhosphorIconsRegular.pencilSimple,
        ),
        const HardwareAction<_LinkedAction>(
          label: 'Merge',
          value: _LinkedAction.merge,
          description: 'Fold this Button’s history into another one.',
          icon: PhosphorIconsRegular.arrowsMerge,
        ),
        const HardwareAction<_LinkedAction>(
          label: 'Unlink',
          value: _LinkedAction.unlink,
          description: 'Unpairs it from this Base.',
          icon: PhosphorIconsRegular.linkBreak,
          destructive: true,
        ),
      ],
    );
    if (!context.mounted || choice == null) return;

    switch (choice) {
      case _LinkedAction.edit:
        final query = <String>[
          'buttonId=${button.id}',
          if (button.batteryLevel != null) 'batteryLevel=${button.batteryLevel}',
        ].join('&');
        context.push('${FpScreen.buttonEdit.path}?$query');
      case _LinkedAction.merge:
        context.push('${FpScreen.buttonConversion.path}?buttonId=${button.id}');
      case _LinkedAction.unlink:
        final confirmed = await confirmDestructive(
          context: context,
          title: 'Are you sure?',
          message: 'Are you sure you want to unlink “${button.text}”?',
          confirmLabel: 'Unlink',
        );
        if (!context.mounted || !confirmed) return;
        // POST /api/v1/buttons/{id}/unlink is a §15 no-op. The RN screen
        // then sent the user to RESYNC_BASE; the PRD's device script picks
        // the change up from `GET /device/desired`, so nothing follows.
        showPhaseOneNotice(context, '“${button.text}” not unlinked');
    }
  }
}

enum _LinkedAction { edit, merge, unlink }

/// A Connect Button's firmware, mapped and toned.
///
/// Green for one of the two current versions, danger for a mapped older one,
/// and a neutral question mark for a value the table does not know — the RN
/// row's three outcomes exactly (`BaseButton.tsx`, `versionAlert.tsx`).
/// Unknown is deliberately not drawn as outdated: the app cannot tell.
class _VersionChip extends StatelessWidget {
  const _VersionChip({required this.wireVersion});

  final String wireVersion;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final state = ButtonFirmware.of(wireVersion);
    final label = ButtonFirmware.label(wireVersion);

    final (Color tone, IconData icon) = switch (state) {
      ButtonFirmware.latest => (c.statusSuccessFg, PhosphorIconsRegular.check),
      ButtonFirmware.outdated => (
          c.statusWarningFg,
          PhosphorIconsRegular.arrowCircleUp
        ),
      ButtonFirmware.unknown => (
          c.textTertiary,
          PhosphorIconsRegular.question
        ),
    };

    return Semantics(
      label: switch (state) {
        ButtonFirmware.latest => 'Firmware $label, up to date',
        ButtonFirmware.outdated => 'Firmware $label, outdated',
        ButtonFirmware.unknown => 'Firmware version unknown',
      },
      button: true,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _explain(context, state, label),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PhosphorIcon(icon, size: FpIconSize.sm, color: tone),
              const SizedBox(width: FpSpace.s2),
              Text(
                label ?? 'version unknown',
                style: FpType.monoSm.copyWith(color: tone),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The RN alert, kept — including its Learn More, which opens
  /// `support.fluent.pet` in a browser and is a §15 no-op here.
  Future<void> _explain(
    BuildContext context,
    ButtonFirmware state,
    String? label,
  ) async {
    // Colour comes from `dialogTheme`; see the note on [showHardwareActions].
    final learnMore = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dc = dialogContext.fpColors;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FpRadius.lg),
          ),
          title: Text(
            switch (state) {
              ButtonFirmware.latest => 'Up to date',
              ButtonFirmware.outdated => 'Outdated firmware',
              ButtonFirmware.unknown => 'Firmware not recognised',
            },
            style: FpType.headingSm.copyWith(color: dc.textPrimary),
          ),
          content: Text(
            switch (state) {
              ButtonFirmware.latest =>
                'This Button is running the latest firmware ($label).',
              ButtonFirmware.outdated =>
                'This Button is running $label, which is out of date. '
                    'Re-linking it to the Base usually updates it.',
              ButtonFirmware.unknown =>
                'This Button reports $wireVersion, which this version of the '
                    'app does not have a name for. It may be newer than the '
                    'app.',
            },
            style: FpType.bodyMd.copyWith(color: dc.textSecondary),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Close',
                style: FpType.labelLg.copyWith(color: dc.textSecondary),
              ),
            ),
            if (state != ButtonFirmware.latest)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  'Learn more',
                  style: FpType.labelLg.copyWith(color: dc.textBrand),
                ),
              ),
          ],
        );
      },
    );
    if (!context.mounted || learnMore != true) return;
    showPhaseOneNotice(context, 'support.fluent.pet not opened');
  }
}

// ─────────────────────────── small parts ───────────────────────────

/// A form label and the sentence that says what the field is for.
///
/// The RN form labels are bare nouns — "Base Name", "Interaction timing (in
/// seconds)", "Default Presser" — and two of the three are settings whose
/// effect is not guessable from the noun. The hint line is where the effect
/// goes.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, this.hint});

  final String label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final help = hint;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: FpType.headingSm.copyWith(color: c.textPrimary)),
        if (help != null) ...<Widget>[
          const SizedBox(height: FpSpace.s1),
          Text(help, style: FpType.bodySm.copyWith(color: c.textTertiary)),
        ],
      ],
    );
  }
}

/// The `?` beside the interaction-timing label, which opens the explanatory
/// screen. Phosphor's question mark in a circle, at the icon scale — not a
/// second glyph and not a coloured pill.
class _HelpButton extends StatelessWidget {
  const _HelpButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      label: 'What interaction timing does',
      button: true,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: HardwareMetrics.touchTarget,
            height: HardwareMetrics.touchTarget,
            child: Center(
              child: PhosphorIcon(
                PhosphorIconsRegular.question,
                size: FpIconSize.md,
                color: c.textBrand,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The `+` row above the linked-Button list, with the RN caption kept.

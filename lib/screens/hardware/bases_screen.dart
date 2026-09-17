/// `BASES` — the Hardware tab's root, and the screen the second job is
/// measured on.
///
/// PLAN.md's second job is *"see battery and online health at a glance"*, and
/// the inventory's finding about this screen is blunt: **`last_online_at` is
/// not shown here at all.** The only online-health readout in the whole RN app
/// is one level deeper, inside `BASE_EDIT`
/// (`docs/design-system/screen-inventory.md` §9, §10). The screen that exists
/// to answer the question does not answer it.
///
/// So the correction is the point of this file, not a decoration on it. Every
/// Base row now carries two things it did not have:
///
/// * a [DeviceHealthPill], which resolves paired / syncing / offline / low /
///   online in the one fixed precedence and drops the percent when offline
///   rather than showing a stale one; and
/// * a **last-seen line** — `FpFormat.lastSeen` — which says *when* the Base
///   was last heard from, in the danger tone when it is offline.
///
/// Those two together are the whole readout: the pill says what is wrong, the
/// line says how long it has been wrong. Neither is a new vocabulary. The pill
/// is the shared component; the ladder is the shared formatter; the threshold
/// is `FpFormat.lowBatteryPercent` and appears nowhere in this file as a
/// number.
///
/// The header's subtitle rolls the same facts up to Household level, so the
/// answer arrives before any scrolling: "3 Bases · 2 offline · 1 Button low".
///
/// ## What is kept from the RN screen
///
/// Every field and every capability. Name (with the domain's fallback), the
/// battery reading, `ID:`, the linked-Button count, the product image slot, tap
/// to edit, long-press for Edit / Delete, pull to refresh, the Buttons tile
/// with its total, the empty state, and CONNECT A BASE pinned at the bottom
/// (registration is a serial-and-name form now; the RN app's BLE/Wi-Fi setup
/// and its permission pre-check are out of the PRD). What changed is recorded
/// at each site.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../domain/domain.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import 'hardware_providers.dart';
import 'hardware_ui.dart';

class BasesScreen extends ConsumerWidget {
  const BasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final bases = ref.watch(hardwareBasesProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Hardware',
              subtitle: bases.maybeWhen(
                data: _householdHealthLine,
                orElse: () => null,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: c.textBrand,
                backgroundColor: c.surfaceRaised,
                onRefresh: () async => refreshHardware(ref),
                child: switch (bases) {
                  AsyncData<List<Base>>(:final value) => _BasesList(bases: value),
                  AsyncError<List<Base>>() => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const <Widget>[
                        HardwareNotice(
                          icon: PhosphorIconsRegular.warningOctagon,
                          title: 'Could not load your Bases',
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
                label: 'CONNECT A BASE',
                icon: PhosphorIconsRegular.plus,
                onPressed: () => context.push(FpScreen.baseRegistration.path),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The Household-level answer, in the header, before any scrolling.
  ///
  /// New. The RN header is the static word "HARDWARE" and nothing else, so a
  /// Household with an offline Base looks exactly like one without until you
  /// read every row. The parts are ordered worst-first and only appear when
  /// they are true; a healthy Household reads "3 Bases · all online", which is
  /// a statement rather than an absence of warnings.
  static String _householdHealthLine(List<Base> bases) {
    if (bases.isEmpty) return 'No Bases connected';

    final offline = bases.where((b) => !b.online).length;
    final lowBattery =
        bases.where((b) => FpFormat.isLowBattery(b.batteryLevel)).length;
    final lowButtons =
        bases.fold<int>(0, (sum, b) => sum + b.lowBatteryButtons);

    final parts = <String>[FpFormat.countOf(bases.length, 'Base')];
    if (offline > 0) parts.add('$offline offline');
    if (lowBattery > 0) parts.add('$lowBattery low battery');
    if (lowButtons > 0) {
      parts.add('${FpFormat.countOf(lowButtons, 'Button')} low');
    }
    if (parts.length == 1) parts.add('all online');
    return parts.join(' · ');
  }

}

class _BasesList extends StatelessWidget {
  const _BasesList({required this.bases});

  final List<Base> bases;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Always scrollable, so pull-to-refresh works on a Household with one
      // Base and half a screen of content.
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s2,
        FpSpace.s6,
        FpSpace.s8,
      ),
      children: <Widget>[
        const SectionHeading(label: 'Bases'),
        const SizedBox(height: FpSpace.s4),
        if (bases.isEmpty)
          const HardwareNotice(
            icon: PhosphorIconsRegular.broadcast,
            title: 'No Bases yet',
            body: 'Connect a Base and the presses your pet makes start '
                'arriving on their own, with the Buttons they came from.',
          )
        else
          for (final base in bases) ...<Widget>[
            _BaseCard(base: base),
            const SizedBox(height: FpSpace.s4),
          ],
        const SizedBox(height: FpSpace.s6),
        // The Buttons tile.
        //
        // The RN list injects it *before* the first Base row (`:99-103`). It
        // moves below the Bases here, deliberately: PLAN.md says that where
        // the two jobs compete for prominence the two jobs win, and this
        // screen's job is Base health. The tile is a way into the Board, not a
        // health readout, and it was pushing the health information down the
        // screen.
        const SectionHeading(label: 'Buttons'),
        const SizedBox(height: FpSpace.s4),
        const _ButtonsTile(),
      ],
    );
  }
}

/// One Base: identity, health, and the facts underneath.
class _BaseCard extends ConsumerWidget {
  const _BaseCard({required this.base});

  final Base base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final now = ref.watch(hardwareNowProvider);
    final linked = ref.watch(linkedButtonsProvider);
    final lastSeen = FpFormat.lastSeen(base.lastOnlineAt, asOf: now);

    return HardwareCard(
      semanticLabel: '${base.displayName}, '
          '${base.online ? 'online' : 'offline'}, last seen $lastSeen',
      onTap: () => _openEdit(context),
      onLongPress: () => _openActions(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ProductGlyph(icon: PhosphorIconsRegular.broadcast),
              const SizedBox(width: FpSpace.s4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      base.displayName,
                      style: FpType.displaySm.copyWith(color: c.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: FpSpace.s2),
                    _LastSeenLine(base: base, lastSeen: lastSeen),
                  ],
                ),
              ),
              const SizedBox(width: FpSpace.s3),
              // No onTap: the chevron means "this opens Hardware" and this is
              // Hardware. The whole card is the tap target instead.
              DeviceHealthPill.forBase(base),
            ],
          ),
          const SizedBox(height: FpSpace.s4),
          Divider(color: c.borderSubtle, height: FpStroke.hairline),
          const SizedBox(height: FpSpace.s4),
          MetaLine(
            facts: <MetaFact>[
              // The RN row labels this "ID:". The label is dropped and the
              // value set in mono, which is what the design reserves the mono
              // face for; a serial number does not need to be told it is one.
              //
              // An unnamed Base has no name to fall back to but its serial —
              // `Base.displayName`, the domain's one fallback — so the title
              // is already the serial and repeating it here would say the same
              // thing twice. The slot says why the title looks like that
              // instead.
              if (base.name == null)
                const MetaFact('Unnamed Base')
              else
                MetaFact(base.serialNumber, mono: true),
              _linkedFact(linked),
              if (base.lowBatteryButtons > 0)
                MetaFact(
                  '${FpFormat.countOf(base.lowBatteryButtons, 'Button')} low',
                  tone: c.statusWarningFg,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// The linked-Button count, in its three honest states.
  ///
  /// This is the count §9 records as broken: in the RN app it comes from a
  /// disabled query and resolves only off a cache entry the Activity tab
  /// happens to have filled, so it spins forever for anyone who opened
  /// Hardware first. Here it comes from [linkedButtonsProvider], which reads
  /// the Board this area fetches itself.
  ///
  /// Zero is spelled out as "No linked Buttons" rather than "0 linked
  /// Buttons": §9 asks for the loading and the zero states to be designed
  /// explicitly, and a zero that reads like a count is the one most easily
  /// mistaken for a count that has not arrived.
  MetaFact _linkedFact(AsyncValue<Map<String, List<LinkedButton>>> linked) {
    return switch (linked) {
      AsyncData<Map<String, List<LinkedButton>>>(:final value) => () {
          final count = value[base.serialNumber]?.length ?? 0;
          return MetaFact(
            count == 0
                ? 'No linked Buttons'
                : FpFormat.countOf(count, 'linked Button'),
          );
        }(),
      AsyncError<Map<String, List<LinkedButton>>>() =>
        const MetaFact('Linked Buttons unavailable'),
      _ => const MetaFact('Counting Buttons…'),
    };
  }

  void _openEdit(BuildContext context) {
    context.push('${FpScreen.baseEdit.path}?serialNumber=${base.serialNumber}');
  }

  /// Long-press: Edit / Delete, the RN action sheet exactly.
  Future<void> _openActions(BuildContext context) async {
    final choice = await showHardwareActions<_BaseAction>(
      context: context,
      title: base.displayName,
      message: base.serialNumber,
      options: <HardwareAction<_BaseAction>>[
        const HardwareAction<_BaseAction>(
          label: 'Edit',
          value: _BaseAction.edit,
          icon: PhosphorIconsRegular.pencilSimple,
        ),
        const HardwareAction<_BaseAction>(
          label: 'Delete',
          value: _BaseAction.delete,
          icon: PhosphorIconsRegular.trash,
          destructive: true,
        ),
      ],
    );
    if (!context.mounted || choice == null) return;

    switch (choice) {
      case _BaseAction.edit:
        _openEdit(context);
      case _BaseAction.delete:
        final confirmed = await confirmDestructive(
          context: context,
          title: 'Are you sure?',
          message: 'This will be permanently deleted.',
          confirmLabel: 'Delete',
        );
        if (!context.mounted || !confirmed) return;
        // DELETE /api/v1/bases/{serial} is one of §15's no-ops.
        showPhaseOneNotice(context, '${base.displayName} not deleted');
    }
  }
}

enum _BaseAction { edit, delete }

/// The line that did not exist before.
///
/// `FpFormat.lastSeen` owns the ladder — "Just now", "6 min ago", "3 h ago",
/// "Yesterday", "3 days ago", "on 19 August" — so this widget only decides the
/// tone and the glyph. Offline takes the danger ramp because an offline Base's
/// age is the thing that matters most on the screen; an online Base's is
/// reassurance and stays in secondary.
class _LastSeenLine extends StatelessWidget {
  const _LastSeenLine({required this.base, required this.lastSeen});

  final Base base;
  final String lastSeen;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final offline = !base.online;
    final tone = offline ? c.statusDangerFg : c.textSecondary;

    return Row(
      children: <Widget>[
        PhosphorIcon(
          offline
              ? PhosphorIconsRegular.wifiSlash
              : PhosphorIconsRegular.wifiHigh,
          size: FpIconSize.sm,
          color: tone,
        ),
        const SizedBox(width: FpSpace.s2),
        Flexible(
          child: Text(
            // A Base that has never been online reads "Never seen" on its own.
            // [FpFormat.lastSeen] answers "when?" with a whole sentence in that
            // one case, and prefixing it produced "Last seen Never seen".
            base.everSeen ? 'Last seen $lastSeen' : lastSeen,
            style: FpType.labelMd.copyWith(color: tone),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// The Buttons tile: the Board, and the way into `CLASSIC_BUTTONS`.
///
/// The RN tile shows a heading, "Total Buttons: N" and a product image, where
/// N is every **active** Button minus `inaudible` — Connect Buttons included,
/// despite the destination being called Classic Buttons
/// (`ClassicButtonsList.tsx:20-23`, §9, §14.12).
///
/// The count keeps that breadth, because the screen it opens keeps it too and
/// a tile whose number disagreed with the screen behind it would be worse than
/// either. What is added is the split — "12 Buttons · 8 Connect · 4 Classic" —
/// so the breadth is stated rather than discovered.
class _ButtonsTile extends ConsumerWidget {
  const _ButtonsTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final board = ref.watch(hardwareBoardProvider);

    return HardwareCard(
      semanticLabel: 'Buttons board',
      onTap: () => context.push(FpScreen.classicButtons.path),
      child: Row(
        children: <Widget>[
          const ProductGlyph(icon: PhosphorIconsRegular.circlesThree),
          const SizedBox(width: FpSpace.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Buttons',
                  style: FpType.displaySm.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: FpSpace.s2),
                switch (board) {
                  AsyncData<Board>(:final value) =>
                    MetaLine(facts: _counts(value)),
                  AsyncError<Board>() => const MetaLine(
                      facts: <MetaFact>[MetaFact('Board unavailable')],
                    ),
                  _ => const MetaLine(
                      facts: <MetaFact>[MetaFact('Counting Buttons…')],
                    ),
                },
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

  /// The total, then the split. `inaudible` is excluded from the total exactly
  /// as the RN tile excludes it, and named separately when the Board has one —
  /// it is a Button on the Board but it is not a word, and folding it into
  /// either kind would misreport both.
  ///
  /// Every segment carries its number, the inaudible one included: "1
  /// inaudible", never a bare "inaudible". A number-less segment beside three
  /// counted ones reads as a badge rather than as part of the count, and
  /// leaves "how many?" unanswered on the one segment that is easiest to
  /// misread. The noun does not inflect — "2 inaudible", not "2 inaudibles" —
  /// so this is a plain interpolation rather than [FpFormat.countOf].
  static List<MetaFact> _counts(Board board) {
    final active = board.activeButtons;
    final connect =
        active.where((b) => b.kind == ButtonKind.connect).length;
    final classic =
        active.where((b) => b.kind == ButtonKind.classic).length;
    final inaudible =
        active.where((b) => b.kind == ButtonKind.inaudible).length;

    return <MetaFact>[
      MetaFact(FpFormat.countOf(connect + classic, 'Button')),
      MetaFact('$connect Connect'),
      MetaFact('$classic Classic'),
      if (inaudible > 0) MetaFact('$inaudible inaudible'),
    ];
  }
}

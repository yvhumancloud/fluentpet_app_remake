import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../domain/domain.dart';
import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import '../format/fp_format.dart';
import 'fp_metrics.dart';

/// The one state a [DeviceHealthPill] is in.
///
/// Ordered by the precedence the design fixes: none → syncing → offline → low
/// → online. The pill shows exactly one dot and one label and never stacks two
/// states, so this is resolved once, in [DeviceHealthPill.stateOf], and read
/// everywhere else.
enum DeviceHealthState { none, syncing, offline, low, online }

/// Base online state and battery, as one control.
///
/// This carries the second of the product's two jobs on its own — see battery
/// and online health at a glance. It lives in the Activity header rather than
/// in a tab, because a health tab is a place you have to remember to visit.
///
/// Rules it owes:
///
/// * Precedence is fixed and single: none → syncing → offline → low → online.
///   One dot, one label, never two dots and never two states.
/// * **Syncing keeps the percent: `Syncing · 87%`.** This is the one relaxation
///   of one-dot-one-label, and it is deliberate. A sync in flight says nothing
///   about the cell in the Base; the battery reading is still true while it
///   runs, so hiding it would throw away a fact the user came for. The state is
///   still single — one dot, one line — the line just carries both halves.
/// * **Offline still drops the percent.** Offline is exactly the case where the
///   reading stopped being true, and a number that stopped being true is worse
///   than no number. Do not make this symmetrical with syncing; the asymmetry
///   is the point.
/// * With no battery to report, syncing falls back to a bare `Syncing`. There
///   is no `Syncing · —`.
/// * The low-battery threshold lives in [lowBatteryThreshold] and nowhere
///   else. No call site repeats it.
/// * The percent is tabular, so the header does not twitch as it ticks down.
/// * The chevron means "this opens Hardware". With no [onTap] it is not drawn.
/// * Syncing does not spin. Motion is designed in Flutter deliberately, and
///   this is not one of the places that earns it.
class DeviceHealthPill extends StatelessWidget {
  const DeviceHealthPill({
    this.paired = true,
    this.online = true,
    this.battery,
    this.syncing = false,
    this.onTap,
    super.key,
  });

  /// The pill for a Household's Base, or for no Base at all.
  ///
  /// [Base.batteryLevel] is non-nullable, but it is not always a percent: the
  /// wire's charging sentinel ([FpFormat.chargingWireSentinel]) rides in the
  /// same field, and two of the fixture's Bases carry it. [battery] is
  /// documented as "percent 0–100, or null", so the sentinel is resolved to
  /// null here rather than handed on as a number — passed through, it read as
  /// a low battery and the pill said "-1%".
  ///
  /// The rule is [FpFormat.batteryLevel]'s, asked once rather than restated:
  /// anything it calls unknown has no percent to show.
  DeviceHealthPill.forBase(
    Base? base, {
    this.syncing = false,
    this.onTap,
    super.key,
  })  : paired = base != null,
        online = base?.online ?? false,
        battery = base == null ||
                FpFormat.batteryLevel(base.batteryLevel) ==
                    FpBatteryLevel.unknown
            ? null
            : base.batteryLevel;

  /// At or below this percent the pill goes to the warning tone.
  ///
  /// Stated once, in [FpFormat.lowBatteryPercent], because a Button's battery
  /// is judged by the same number on the Hardware screens. This name stays as
  /// the pill's own vocabulary and forwards; it is not a second definition.
  static const int lowBatteryThreshold = FpFormat.lowBatteryPercent;

  /// What joins "Syncing" to the percent: a spaced middot, non-breaking on
  /// both sides so the pill's one label can never wrap into two lines inside a
  /// header that is already fighting a truncating title.
  static const String _syncPercentSeparator = '\u00A0·\u00A0';

  /// Whether a Base is paired to this Household at all.
  final bool paired;

  final bool online;

  /// Percent 0–100, or null when the Base has not reported a level yet.
  final int? battery;

  /// A sync is in flight.
  final bool syncing;

  /// Where the chevron goes. Null means the pill cannot navigate, and then no
  /// chevron is drawn.
  final VoidCallback? onTap;

  /// The single state these conditions resolve to, in the fixed precedence.
  ///
  /// Public because the tab bar's attention dot asks the same question, and it
  /// must get the same answer.
  static DeviceHealthState stateOf({
    bool paired = true,
    bool online = true,
    int? battery,
    bool syncing = false,
  }) {
    if (!paired) return DeviceHealthState.none;
    if (syncing) return DeviceHealthState.syncing;
    if (!online) return DeviceHealthState.offline;
    if (battery != null && battery <= lowBatteryThreshold) {
      return DeviceHealthState.low;
    }
    return DeviceHealthState.online;
  }

  /// Whether a Household's Bases warrant the tab bar's attention dot.
  ///
  /// The dot is count-free — "go look", never "you have 3" — so this is one
  /// bool over the whole list rather than a tally. It fires on the two states
  /// that mean the product has stopped working: a Base that has dropped off,
  /// and a Household with no Base paired at all. Low battery deliberately does
  /// not fire it. Low battery is a warning about later; the dot is drawn in
  /// the danger tone and spending it on "12%" is how a permanent dot teaches
  /// people to ignore it.
  ///
  /// It resolves through [stateOf] rather than reading `online` directly, so
  /// the dot and the pill can never disagree about what "unhealthy" means. No
  /// battery is handed over, because no battery reading can change the answer:
  /// `offline` outranks `low` in the precedence, and `low` is not a trigger.
  static bool needsAttention(Iterable<Base> bases) {
    if (bases.isEmpty) return true;
    return bases.any(
      (b) => stateOf(online: b.online) == DeviceHealthState.offline,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final state = stateOf(
      paired: paired,
      online: online,
      battery: battery,
      syncing: syncing,
    );

    final dot = switch (state) {
      DeviceHealthState.none => c.borderStrong,
      DeviceHealthState.syncing => c.statusInfoSolid,
      DeviceHealthState.offline => c.statusDangerSolid,
      DeviceHealthState.low => c.statusWarningSolid,
      DeviceHealthState.online => c.statusSuccessSolid,
    };

    final tone = switch (state) {
      DeviceHealthState.none => c.textTertiary,
      DeviceHealthState.syncing => c.statusInfoFg,
      DeviceHealthState.offline => c.statusDangerFg,
      DeviceHealthState.low => c.statusWarningFg,
      DeviceHealthState.online => c.textPrimary,
    };

    // Syncing keeps the percent; offline drops it. A sync in flight does not
    // invalidate the battery reading the way going offline does.
    final label = switch (state) {
      DeviceHealthState.none => 'No Base',
      DeviceHealthState.syncing =>
        battery == null ? 'Syncing' : 'Syncing$_syncPercentSeparator$battery%',
      DeviceHealthState.offline => 'Offline',
      DeviceHealthState.low => '$battery%',
      DeviceHealthState.online => battery == null ? 'Online' : '$battery%',
    };

    final pill = Container(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s3,
        FpSpace.s2,
        FpSpace.s4,
        FpSpace.s2,
      ),
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(FpRadius.full),
        border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: FpMetrics.healthDot,
            height: FpMetrics.healthDot,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: FpSpace.s2),
          Text(label, style: FpType.labelMd.copyWith(color: tone).tabular),
          if (onTap != null) ...<Widget>[
            const SizedBox(width: FpSpace.s2),
            PhosphorIcon(
              PhosphorIconsRegular.caretRight,
              size: FpMetrics.healthChevron,
              color: c.textTertiary,
            ),
          ],
        ],
      ),
    );

    // The middot is punctuation and a screen reader should not announce it;
    // the two facts are read as two clauses instead.
    final spoken = switch (state) {
      DeviceHealthState.syncing when battery != null =>
        'Syncing, $battery percent',
      _ => label,
    };

    return Semantics(
      label: 'Base health: $spoken',
      button: onTap != null,
      child: ExcludeSemantics(
        child: onTap == null
            ? pill
            : GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: pill,
              ),
      ),
    );
  }
}

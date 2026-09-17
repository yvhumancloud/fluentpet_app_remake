/// The bottom sheets the Activity screens open.
///
/// The RN app uses the native action sheet in three places on these screens —
/// the `DASHBOARD` floating action button, the per-row single-item menu, and
/// the multi-select menu — and builds each option list dynamically, so the
/// index order changes with the flags
/// (`docs/design-system/screen-inventory.md` §1.3). The dynamic list survives
/// here; the native sheet does not, because a platform sheet cannot be given
/// the type scale or the two schemes.
///
/// ## Disabled options say why
///
/// Several of the options are **writes**, and phase 1 has no writes — the
/// repositories read and nothing else (`lib/data/repositories.dart`). Rather
/// than hide them, which would quietly drop capability from the inventory, or
/// show them and do nothing, which is worse, a write-shaped option is drawn
/// disabled with its reason on the line below it. The information architecture
/// survives; the lie does not.
library;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../theme/fp_context.dart';
import '../../../theme/generated/fp_tokens.dart';
import 'activity_controls.dart';
import 'activity_metrics.dart';

/// One line in a sheet.
class SheetOption {
  const SheetOption({
    required this.label,
    required this.icon,
    this.onSelected,
    this.detail,
    this.destructive = false,
  }) : assert(
          onSelected != null || detail != null,
          'A disabled option must say why. Colour is not a signal — '
          'text.disabled is the same primitive as text.tertiary, and a sheet '
          'row is a GestureDetector with no ripple to withhold, so this line '
          'is the only thing that distinguishes it. See Components '
          'Disabled states.',
        );

  final String label;
  final IconData icon;

  /// Null draws the option disabled. Pair it with a [detail] that says why.
  final VoidCallback? onSelected;

  /// A second line under the label. Where an option is disabled this is the
  /// reason, and the constructor asserts it — every one of these is a `const`
  /// construction, so a disabled option with no reason does not compile.
  final String? detail;

  final bool destructive;
}

/// The sentence every write-shaped option carries in phase 1.
const String phaseOneReadOnly =
    'Arrives with integration — phase 1 runs on fixtures and never writes.';

/// How much of the screen a sheet may cover before it scrolls instead.
const double _maxSheetFraction = 0.82;

/// Opens a sheet of [options] under [title].
Future<void> showActivitySheet(
  BuildContext context, {
  required String title,
  String? subtitle,
  required List<SheetOption> options,
}) {
  // Colour and shape come from `bottomSheetTheme`, never from an argument
  // here: an argument is read once at push time and baked into the route, so a
  // scheme change with the sheet open repaints its contents and leaves the
  // panel on the old scheme — near-black labels on a near-black surface.
  return showModalBottomSheet<void>(
    context: context,
    // A row's sheet lists every facet the row can open as well as its own
    // actions, so it can be long. Scroll-controlled, and the options scroll
    // while the title and Cancel stay put.
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * _maxSheetFraction,
    ),
    builder: (context) => _Sheet(
      title: title,
      subtitle: subtitle,
      options: options,
    ),
  );
}

/// A confirmation, matching the RN app's two alerts: *"Are you sure?"* with a
/// destructive confirm, and the multi-item variant that names the count
/// (`helpers/multiConfirmationAlert.ts`, `helpers/deleteConfirmationAlert.ts`).
///
/// [onConfirm] null draws the confirm button disabled with [reason] under it.
Future<void> showActivityConfirm(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  VoidCallback? onConfirm,
  String reason = phaseOneReadOnly,
}) {
  // Colour and shape come from `bottomSheetTheme`; see [showActivitySheet].
  return showModalBottomSheet<void>(
    context: context,
    builder: (context) => _Confirm(
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      onConfirm: onConfirm,
      reason: reason,
    ),
  );
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: FpSpace.s3, bottom: FpSpace.s5),
        width: ActivityMetrics.sheetHandleWidth,
        height: ActivityMetrics.sheetHandleHeight,
        decoration: BoxDecoration(
          color: context.fpColors.borderDefault,
          borderRadius: BorderRadius.circular(FpRadius.full),
        ),
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.title,
    required this.subtitle,
    required this.options,
  });

  final String title;
  final String? subtitle;
  final List<SheetOption> options;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final sub = subtitle;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _Handle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FpSpace.s6,
              FpSpace.s0,
              FpSpace.s6,
              FpSpace.s4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: FpType.headingSm.copyWith(color: c.textPrimary),
                ),
                if (sub != null) ...<Widget>[
                  const SizedBox(height: FpSpace.s1),
                  Text(
                    sub,
                    style: FpType.bodySm.copyWith(color: c.textTertiary),
                  ),
                ],
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final option in options) _OptionRow(option: option),
                ],
              ),
            ),
          ),
          const SizedBox(height: FpSpace.s3),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FpSpace.s6,
              FpSpace.s2,
              FpSpace.s6,
              FpSpace.s5,
            ),
            child: ActionButton(
              label: 'Cancel',
              tone: ButtonTone.ghost,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.option});

  final SheetOption option;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final enabled = option.onSelected != null;
    // A row, not a control with a fill of its own, so disabled recedes on the
    // sheet surface rather than taking `action.*.bgDisabled` — a filled slab
    // here would make the unavailable option the loudest row in the list. The
    // destructive red drops out with it: a row that cannot act cannot destroy.
    //
    // `text.disabled` now measures 4.80:1 light / 7.57:1 dark and is legible,
    // but it resolves to the same primitive as `text.tertiary` in both schemes,
    // so it cannot be the *only* signal that this row is unavailable — see the
    // structural signals below and `design-system` Components → Disabled.
    //
    // Destructive takes `status.danger.fg`, not `action.danger.bg`: an unfilled
    // row is text on a surface, and `actionDangerBg` in dark is 4.42:1 here,
    // under AA.
    final tone = switch ((enabled, option.destructive)) {
      (false, _) => c.textDisabled,
      (true, true) => c.statusDangerFg,
      (true, false) => c.textPrimary,
    };
    final detail = option.detail;

    return Semantics(
      button: true,
      enabled: enabled,
      label: option.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled
              ? () {
                  Navigator.of(context).pop();
                  option.onSelected!.call();
                }
              : null,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: ActivityMetrics.touchTarget,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: FpSpace.s6,
              vertical: FpSpace.s3,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: FpSpace.s1),
                  child: PhosphorIcon(
                    option.icon,
                    size: FpIconSize.md,
                    color: tone,
                  ),
                ),
                const SizedBox(width: FpSpace.s4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        option.label,
                        style: FpType.bodyMd.copyWith(color: tone),
                      ),
                      if (detail != null) ...<Widget>[
                        const SizedBox(height: FpSpace.s1),
                        // The reason line is drawn on enabled options too — it
                        // is a detail there and a reason here — so on its own
                        // it does not distinguish the two. The prohibit glyph
                        // is what does: it appears only when the option cannot
                        // act, in the same place every time, and it is a mark
                        // rather than a colour. See Components §
                        // Disabled states, and `ButtonChip`, which uses the
                        // same glyph for the same meaning.
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (!enabled) ...<Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: FpSpace.s1),
                                child: PhosphorIcon(
                                  PhosphorIconsRegular.prohibit,
                                  size: FpIconSize.sm,
                                  color: c.textTertiary,
                                ),
                              ),
                              const SizedBox(width: FpSpace.s2),
                            ],
                            Expanded(
                              child: Text(
                                detail,
                                style: FpType.bodySm
                                    .copyWith(color: c.textTertiary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Confirm extends StatelessWidget {
  const _Confirm({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.onConfirm,
    required this.reason,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final VoidCallback? onConfirm;
  final String reason;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final action = onConfirm;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          FpSpace.s6,
          FpSpace.s0,
          FpSpace.s6,
          FpSpace.s5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _Handle(),
            Text(
              title,
              style: FpType.headingSm.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: FpSpace.s2),
            Text(body, style: FpType.bodyMd.copyWith(color: c.textSecondary)),
            if (action == null) ...<Widget>[
              const SizedBox(height: FpSpace.s3),
              Text(reason, style: FpType.bodySm.copyWith(color: c.textTertiary)),
            ],
            const SizedBox(height: FpSpace.s6),
            ActionButton(
              label: confirmLabel,
              tone: ButtonTone.danger,
              onPressed: action == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      action();
                    },
            ),
            const SizedBox(height: FpSpace.s3),
            ActionButton(
              label: 'Cancel',
              tone: ButtonTone.ghost,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

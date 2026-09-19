/// The controls the two Log screens share.
///
/// These are **not** components. The twelve shared widgets live in
/// `lib/widgets/` and are composed from wherever they fit — `UtteranceRow`,
/// `PusherAvatar`, `ContextList`, `NoteBlock`, `FlagMarker`, `ScreenHeader` all
/// appear on these screens as they are. What is here is the input surface the
/// design system has not specified: a Board chip, a removable word, a select
/// row, an action button, a bottom sheet. `LOG` is the one write-side screen in
/// the twelve and it needs form controls that no read screen does.
///
/// The rule they all obey is the one the components page states for the
/// widgets: colour comes from `context.fpColors` without exception, every
/// measurement that has a token uses the token, and a measurement that has none
/// is named and cited in [LogMetrics].
///
/// Selection is a **Phosphor weight change** everywhere it appears here —
/// regular to fill — never a second glyph and never a background pill. That is
/// the same mechanism the tab bar and the flag marker use, and it is why the
/// icon set was chosen.
library;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/api/api_client.dart' show apiErrorMessage;
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';

/// Measurements these screens need that the token scale does not carry.
///
/// Same contract as `FpMetrics`: named, cited, in one place. Nothing here is a
/// colour and nothing here is a substitute for a token.
class LogMetrics {
  const LogMetrics._();

  /// The minimum comfortable touch target.
  ///
  /// Stated on the components page in the negative — *"24px is below the 44px
  /// touch target on purpose: at sm the avatar is decoration and the whole row
  /// is the tap target"* — so 44 is the number the system already works to.
  /// Every control on `LOG` is a tap target, which is why it is a floor here
  /// rather than an exception.
  static const double tapTarget = 44.0;

  /// The pinned action button at the foot of both screens. 48 clears the
  /// 44 floor with room for the label's descenders and matches the full-width
  /// primary the RN app pins to the safe area.
  static const double actionHeight = 48.0;

  /// The note field's resting height. `src/components/LogEntryEdit/Notes.tsx`
  /// sets `MIN_HEIGHT = 120` — enough for four lines, so the field looks like
  /// somewhere to write prose rather than somewhere to type a word.
  static const double noteMinHeight = 120.0;

  /// The two-digit seconds field. `DateAndTime.tsx` sets `width: 60`; it holds
  /// exactly "00" and must not stretch to share the row with the time select.
  static const double secondsFieldWidth = 60.0;

  /// One Pusher in the horizontal strip: a 32px avatar over a name that may
  /// wrap to a second line. Fixed so the strip's items line up rather than
  /// jittering with name length.
  static const double pusherOptionWidth = 76.0;

  /// The rule under the selected Pusher. 2px is `FpStroke.thick`; this is how
  /// long it is.
  static const double pusherSelectionRule = 28.0;

  /// The Pusher strip's height: a 32px avatar, the gap, one line of label-md,
  /// the gap, and the 2px selection rule — 72 with the rounding that keeps the
  /// strip from resizing when a name wraps.
  static const double pusherStripHeight = 72.0;
}

// ─────────────────────────── actions ───────────────────────────

/// Which of the action ramps a button draws from.
enum LogActionTone {
  /// The one thing this screen is for. `action.primary.*`.
  primary,

  /// The alternative that is not a cancel. `action.secondary.*`.
  secondary,
}

/// A full-width action, as both screens pin to the bottom safe area.
///
/// Disabled is expressed as a state, not as a lower opacity on the enabled
/// fill: a translucent brand fill on a warm canvas reads as a rendering bug.
/// It takes the tone's `bgDisabled`/`fgDisabled` pair, which the token layer
/// measures against each other at 6.43:1 in both schemes. It used to take the
/// sunken surface with `textDisabled` on it, which is not a pair anything
/// guarantees — in light that was a grey on a slightly lighter grey at 2.0:1.
class LogActionButton extends StatelessWidget {
  const LogActionButton({
    required this.label,
    required this.onPressed,
    this.tone = LogActionTone.primary,
    super.key,
  });

  final String label;

  /// Null disables. There is no separate `enabled` flag to disagree with it.
  final VoidCallback? onPressed;

  final LogActionTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final enabled = onPressed != null;

    final Color background;
    final Color foreground;
    if (tone == LogActionTone.primary) {
      background = enabled ? c.actionPrimaryBg : c.actionPrimaryBgDisabled;
      foreground = enabled ? c.actionPrimaryFg : c.actionPrimaryFgDisabled;
    } else {
      background = enabled ? c.actionSecondaryBg : c.actionSecondaryBgDisabled;
      foreground = enabled ? c.actionSecondaryFg : c.actionSecondaryFgDisabled;
    }

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: ExcludeSemantics(
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(FpRadius.md),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(FpRadius.md),
            child: SizedBox(
              height: LogMetrics.actionHeight,
              child: Center(
                child: Text(
                  label,
                  style: FpType.labelLg.copyWith(color: foreground),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The bottom bar both screens pin their actions into.
///
/// A hairline above it and the canvas behind it, so the list scrolls under a
/// rule rather than under a floating slab. The bar sits inside the bottom safe
/// area — these screens have no tab bar below them.
class LogActionBar extends StatelessWidget {
  const LogActionBar({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceCanvas,
        border: Border(
          top: BorderSide(color: c.borderSubtle, width: FpStroke.hairline),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s4,
        FpSpace.s6,
        FpSpace.s4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(height: FpSpace.s3),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// The one trailing control a modal's header gets: an icon in a 32px hit box.
///
/// The same box `ScreenHeader`'s back chevron uses, so a header with a close on
/// the right and a chevron on the left is optically balanced.
class LogHeaderIconButton extends StatelessWidget {
  const LogHeaderIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: FpMetrics.headerBackHit,
            height: FpMetrics.headerBackHit,
            child: Center(
              child: PhosphorIcon(
                icon,
                size: FpMetrics.headerChevron,
                color: c.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── structure ───────────────────────────

/// A titled block of a form.
///
/// The title is label-sm at tertiary — the same rung the summary line and the
/// elapsed rail sit on, so a form section never competes with an utterance.
class LogSection extends StatelessWidget {
  const LogSection({
    required this.title,
    required this.child,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget child;

  /// An optional control on the title's line, e.g. the Board's sort.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final control = trailing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: FpType.labelSm.copyWith(color: c.textTertiary),
              ),
            ),
            ?control,
          ],
        ),
        const SizedBox(height: FpSpace.s3),
        child,
      ],
    );
  }
}

/// A full-bleed hairline between sections.
class LogHairline extends StatelessWidget {
  const LogHairline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FpStroke.hairline,
      color: context.fpColors.borderSubtle,
    );
  }
}

/// A state with nothing in it, and a sentence that says which nothing.
///
/// The screen inventory is blunt about the old app here: *"'You don't have any
/// logs yet' appears for a genuinely empty account, for an over-filtered
/// timeline, and for a facet screen with no matches. Three different messages
/// are needed and none exists to copy"* (§14.4). This widget is deliberately
/// message-shaped rather than a fixed illustration, so every reachable empty on
/// these screens says its own thing.
class LogEmptyState extends StatelessWidget {
  const LogEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final label = actionLabel;
    final action = onAction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PhosphorIcon(icon, size: FpIconSize.lg, color: c.textTertiary),
        const SizedBox(height: FpSpace.s3),
        Text(title, style: FpType.headingSm.copyWith(color: c.textSecondary)),
        const SizedBox(height: FpSpace.s1),
        Text(message, style: FpType.bodySm.copyWith(color: c.textTertiary)),
        if (label != null && action != null) ...<Widget>[
          const SizedBox(height: FpSpace.s3),
          LogTextAction(label: label, onTap: action),
        ],
      ],
    );
  }
}

/// A quiet inline action — "Add Context", "Add the first Button".
///
/// Brand-coloured label type, no fill and no border. The brand step is
/// `text.brand`, which differs per scheme by design (ADR 0002).
class LogTextAction extends StatelessWidget {
  const LogTextAction({
    required this.label,
    required this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final glyph = icon;
    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: LogMetrics.tapTarget),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (glyph != null) ...<Widget>[
                  PhosphorIcon(glyph, size: FpIconSize.sm, color: c.textBrand),
                  const SizedBox(width: FpSpace.s2),
                ],
                Text(label, style: FpType.labelLg.copyWith(color: c.textBrand)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A labelled row that opens something: a picker, a screen, a sheet.
///
/// Label above, value below, one caret on the right. The caret is drawn only
/// when there is somewhere to go — the same rule the device health pill states
/// for its own chevron.
class LogSelectRow extends StatelessWidget {
  const LogSelectRow({
    required this.label,
    required this.child,
    this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final Widget child;
  final VoidCallback? onTap;

  /// An optional glyph in front of the value — the calendar and the clock on
  /// the timestamp fields.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final tap = onTap;
    final glyph = icon;

    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: LogMetrics.tapTarget),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (glyph != null) ...<Widget>[
            PhosphorIcon(glyph, size: FpIconSize.sm, color: c.textTertiary),
            const SizedBox(width: FpSpace.s3),
          ],
          Expanded(child: child),
          if (tap != null) ...<Widget>[
            const SizedBox(width: FpSpace.s3),
            PhosphorIcon(
              PhosphorIconsRegular.caretRight,
              size: FpIconSize.sm,
              color: c.textTertiary,
            ),
          ],
        ],
      ),
    );

    final labelled = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: FpType.labelSm.copyWith(color: c.textTertiary)),
        row,
      ],
    );

    if (tap == null) return labelled;
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: tap,
        behavior: HitTestBehavior.opaque,
        child: labelled,
      ),
    );
  }
}

// ─────────────────────────── the Board ───────────────────────────

/// What a Board chip is for. Connect versus Classic is the distinction the
/// inventory says *"must survive the restyle"* (§13.1) — it is on every Button
/// chip on every screen in the old app, carried by two background colours.
enum LogChipKind {
  /// A smart Button, paired to a Base. Filled.
  connect,

  /// Unconnected, logged by hand. Outlined.
  classic,

  /// The `inaudible` Button, pinned last with its own glyph. Many Boards do
  /// not have one; that renders nothing rather than a gap.
  inaudible,

  /// The `+` that adds a Button to the Board.
  add,
}

/// One Button on the Board.
///
/// Connect is **filled**, Classic is **outlined**. Fill versus no fill rather
/// than two hues, for the same reason the Pusher avatar distinguishes Learner
/// from Teacher by weight: the two have to stay apart in greyscale and for
/// anyone who cannot separate one tint from another. The old app used a blue
/// and a green, which fails both tests.
///
/// The corner is `radius.sm`, not a pill. Pills are the soft-and-friendly look
/// this design is deliberately not (PLAN.md).
class LogButtonChip extends StatelessWidget {
  const LogButtonChip({
    required this.kind,
    required this.onTap,
    this.label,
    this.onLongPress,
    super.key,
  });

  final LogChipKind kind;

  /// Null on the `+` chip, which is a glyph and no text.
  final String? label;

  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final text = label;

    final Color background;
    final Color border;
    final Color foreground;
    switch (kind) {
      case LogChipKind.connect:
        background = c.surfaceRaised;
        border = c.borderDefault;
        foreground = c.textPrimary;
      case LogChipKind.classic:
        background = c.surfaceCanvas;
        border = c.borderDefault;
        foreground = c.textSecondary;
      case LogChipKind.inaudible:
        background = c.surfaceCanvas;
        border = c.borderSubtle;
        foreground = c.textTertiary;
      case LogChipKind.add:
        background = c.surfaceCanvas;
        border = c.borderStrong;
        foreground = c.textBrand;
    }

    return Semantics(
      button: true,
      label: switch (kind) {
        LogChipKind.add => 'Add a Button',
        LogChipKind.inaudible => 'inaudible, Button',
        LogChipKind.connect => '${text ?? ''}, Connect Button',
        LogChipKind.classic => '${text ?? ''}, Classic Button',
      },
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          behavior: HitTestBehavior.opaque,
          child: Container(
            constraints: const BoxConstraints(minHeight: LogMetrics.tapTarget),
            // No `alignment` here. A Container that is given one expands to
            // fill whatever bounded width its parent offers, and this chip's
            // parent is a `Wrap` — so an alignment turned every chip into a
            // full-width row and the Board into a single column. The Row below
            // is `MainAxisSize.min` and centres itself vertically, which is
            // all the alignment this needed.
            padding: const EdgeInsets.symmetric(
              horizontal: FpSpace.s5,
              vertical: FpSpace.s3,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(FpRadius.sm),
              border: Border.all(color: border, width: FpStroke.hairline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (kind == LogChipKind.add)
                  PhosphorIcon(
                    PhosphorIconsRegular.plus,
                    size: FpIconSize.md,
                    color: foreground,
                  ),
                if (kind == LogChipKind.inaudible) ...<Widget>[
                  PhosphorIcon(
                    PhosphorIconsRegular.speakerSimpleSlash,
                    size: FpIconSize.sm,
                    color: foreground,
                  ),
                  const SizedBox(width: FpSpace.s2),
                ],
                if (text != null)
                  Text(text, style: FpType.bodyMd.copyWith(color: foreground)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One word in the utterance being composed, with the control that takes it
/// back out.
///
/// The word is display type — the same face and size the timeline gives it —
/// because what is being built here is the thing the whole app is about, and
/// showing it as a small grey chip while composing and as display type
/// afterwards would be two answers to one question.
class LogWordToken extends StatelessWidget {
  const LogWordToken({required this.word, required this.onRemove, super.key});

  final String word;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      label: 'Remove $word',
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onRemove,
          behavior: HitTestBehavior.opaque,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: LogMetrics.tapTarget),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  word,
                  style: FpType.displaySm.copyWith(color: c.textPrimary),
                ),
                const SizedBox(width: FpSpace.s2),
                PhosphorIcon(
                  PhosphorIconsRegular.x,
                  size: FpIconSize.sm,
                  color: c.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The press boundary, between two words in the composer.
///
/// The same middot the timeline draws, at the same half-opacity, because it
/// means the same thing in both places: one press ended and the next began.
class LogPressBoundary extends StatelessWidget {
  const LogPressBoundary({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return ExcludeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: LogMetrics.tapTarget),
        // `widthFactor: 1` is load-bearing. A bare `Center` takes the widest
        // width its parent offers, and this sits in the composer's `Wrap` — so
        // without it the middot claimed a full-width run of its own and every
        // word in a multi-press utterance landed on a separate line.
        child: Center(
          widthFactor: 1,
          child: Text(
            '·',
            style: FpType.bodySm.copyWith(
              color: c.textTertiary.withValues(
                alpha: FpMetrics.separatorOpacity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── sheets ───────────────────────────

/// One line of a [showLogSheet] list.
class LogSheetOption {
  const LogSheetOption({
    required this.label,
    required this.onSelected,
    this.icon,
    this.selected = false,
    this.destructive = false,
  });

  final String label;
  final VoidCallback onSelected;
  final IconData? icon;

  /// Drawn with a filled Phosphor check. Weight, not a background pill.
  final bool selected;

  /// Takes the danger ramp's foreground. Archive and delete only.
  final bool destructive;
}

/// The action sheet, as this design draws it.
///
/// The RN app uses the OS action sheet for the Board's long-press menu, the
/// sort control and the timeline's row menu. That is a platform control with
/// no design surface, so it becomes an in-app sheet on the raised surface with
/// a hairline between the rows.
///
/// Cancel is the sheet's own dismiss — a scrim tap or a drag — rather than a
/// row, so the list holds only things that do something.
///
/// ## Height
///
/// Scroll-controlled, with the title pinned and the rows scrolling. The Log
/// area's own menus are four or five rows, but the Meaning picker on
/// `BUTTON_ADD`/`BUTTON_EDIT` is nine (`buttonMeanings` plus "None") and a
/// default sheet is capped at nine-sixteenths of the viewport with no scroller
/// inside it, so those rows do not go below the fold — they overflow. Growing
/// the cap without adding the scroller would only move the failure.
Future<void> showLogSheet(
  BuildContext context, {
  required String title,
  required List<LogSheetOption> options,
}) {
  // Colour and shape come from `bottomSheetTheme`, never from an argument
  // here: an argument is read once at push time and baked into the route, so a
  // scheme change with the sheet open leaves the panel on the old scheme.
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) => SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FpSpace.s6,
              FpSpace.s6,
              FpSpace.s6,
              FpSpace.s3,
            ),
            child: Text(
              title,
              style: FpType.labelSm.copyWith(
                color: sheetContext.fpColors.textTertiary,
              ),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: FpSpace.s4),
              children: <Widget>[
                for (final option in options)
                  _LogSheetRow(
                    option: option,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      option.onSelected();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _LogSheetRow extends StatelessWidget {
  const _LogSheetRow({required this.option, required this.onTap});

  final LogSheetOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    // `status.danger.fg`, not `action.danger.bg`. `action.danger.bg` is a
    // fill token; an unfilled row is text on the sheet surface, which is
    // what `status.danger.fg` is for. In light the two are the same hex so
    // nothing moves, but in dark `actionDangerBg` (#F0374B) measures 4.42:1
    // on `surfaceRaised` and misses AA; `statusDangerFg` (#FF8A96) is
    // 7.71:1.
    final colour = option.destructive ? c.statusDangerFg : c.textPrimary;
    final glyph = option.icon;

    return Semantics(
      button: true,
      selected: option.selected,
      label: option.label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: LogMetrics.tapTarget),
            padding: const EdgeInsets.symmetric(
              horizontal: FpSpace.s6,
              vertical: FpSpace.s3,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: c.borderSubtle,
                  width: FpStroke.hairline,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                if (glyph != null) ...<Widget>[
                  PhosphorIcon(glyph, size: FpIconSize.md, color: colour),
                  const SizedBox(width: FpSpace.s4),
                ],
                Expanded(
                  child: Text(
                    option.label,
                    style: FpType.bodyLg.copyWith(color: colour),
                  ),
                ),
                // Selected is a weight change on one glyph, never a second
                // glyph and never a pill behind the row.
                if (option.selected)
                  PhosphorIcon(
                    PhosphorIconsFill.checkCircle,
                    size: FpIconSize.md,
                    color: c.textBrand,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A checklist row for a multi-select sheet — Contexts, and the Learners a
/// Teacher was modelling for.
///
/// Selected is `circle` → `check-circle` at fill weight in brand. Unselected is
/// the outlined circle at tertiary. One glyph family, two weights, two colours.
class LogCheckRow extends StatelessWidget {
  const LogCheckRow({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      label: label,
      checked: selected,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: LogMetrics.tapTarget),
            padding: const EdgeInsets.symmetric(
              horizontal: FpSpace.s6,
              vertical: FpSpace.s3,
            ),
            child: Row(
              children: <Widget>[
                PhosphorIcon(
                  selected
                      ? PhosphorIconsFill.checkCircle
                      : PhosphorIconsRegular.circle,
                  size: FpIconSize.md,
                  color: selected ? c.textBrand : c.textTertiary,
                ),
                const SizedBox(width: FpSpace.s4),
                Expanded(
                  child: Text(
                    label,
                    style: FpType.bodyMd.copyWith(
                      color: selected ? c.textPrimary : c.textSecondary,
                    ),
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

// ─────────────────────────── feedback ───────────────────────────

/// Say something that does not need an answer.
///
/// There is no snackbar in the design system, so this is the smallest honest
/// one: the inverse surface, inverse text, a squared-off corner rather than
/// Material's pill, and no action slot — anything with an action belongs in a
/// sheet where it can be read.
void logSay(BuildContext context, String message) {
  final c = context.fpColors;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: FpType.bodySm.copyWith(color: c.textInverse),
        ),
        backgroundColor: c.surfaceInverse,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(FpSpace.s5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FpRadius.md),
        ),
        duration: FpDuration.slow * _snackBarBeats,
      ),
    );
}

/// Runs a write and says so if it failed. True when it went through.
///
/// One wrapper so every SAVE, archive and delete in the app reports the same
/// way: the server's own message when it has one, [failed] otherwise. The
/// caller decides what success looks like — a pop, a refresh, a snackbar.
Future<bool> logWrite(
  BuildContext context,
  Future<void> Function() write, {
  String failed = 'Could not save. Try again.',
}) async {
  try {
    await write();
    return true;
  } catch (e) {
    if (context.mounted) logSay(context, apiErrorMessage(e, failed));
    return false;
  }
}

/// How many `motion.slow` beats a snackbar stays up.
///
/// The token set carries durations for motion, not for reading. Twelve beats
/// of 320ms is 3.8 seconds, which is Material's own default for a message with
/// no action — long enough to read a sentence, short enough not to sit over
/// the action bar.
const int _snackBarBeats = 12;

/// Ask before something destructive, and name the thing.
///
/// The RN confirm is *"Are you sure? / This will be permanently deleted."*
/// (`src/helpers/deleteConfirmationAlert.ts`) with no mention of what "this"
/// is. Naming it costs nothing and is the difference between a confirmation
/// and a reflex.
Future<bool> logConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  // Every colour is read from `dialogContext`, inside the builder. Reading
  // them from the caller's context captures the scheme at push time and the
  // dialog then stops following it — see the note on [showLogSheet].
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final dc = dialogContext.fpColors;
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FpRadius.lg),
        ),
        title: Text(
          title,
          style: FpType.headingSm.copyWith(color: dc.textPrimary),
        ),
        content: Text(
          message,
          style: FpType.bodyMd.copyWith(color: dc.textSecondary),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Cancel',
              style: FpType.labelLg.copyWith(color: dc.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              confirmLabel,
              // `statusDangerFg` — see the note on `_LogSheetRow`. A
              // `TextButton` label is text on the dialog surface, not a fill.
              style: FpType.labelLg.copyWith(color: dc.statusDangerFg),
            ),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

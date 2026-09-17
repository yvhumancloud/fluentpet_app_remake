/// The pieces more than one Hardware screen needs.
///
/// None of these is a variant of one of the twelve shared components. Where a
/// shared component fits, the screens use it directly — [ScreenHeader],
/// [DeviceHealthPill], [PusherAvatar], [NoteBlock] and [FpFormat] all appear
/// verbatim. What is here is what the design system does not draw at all: the
/// Hardware area has no visual specification, so its card, its Button chip,
/// its fact rows and its sheets are designed here, inside the established
/// direction.
///
/// **The direction, applied.** Warm editorial: the warmth is in the type and
/// in one accent, not in rounded shapes and pastel fills. So a Base is a card
/// with a hairline border and almost no shadow rather than a soft blob; the
/// Base's name is the only display-type element on the row; identifiers and
/// versions are mono because that is what the design reserves mono for; and
/// the only saturated colour on a healthy screen is the health dot.
///
/// **Status colour is not brand colour.** Health uses the `status*` ramp,
/// which steps per scheme like everything else. The brand teal is two values
/// by design (ADR 0002) and is never borrowed to mean "good".
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../domain/domain.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import 'hardware_metrics.dart';
import 'hardware_providers.dart';

// ─────────────────────────── surfaces ───────────────────────────

/// A raised, hairline-bordered block. The unit every Hardware list is built
/// from.
///
/// One card shape for a Base, for the Buttons tile and for a fact block, so
/// three lists on three screens read as one system. [onTap] and [onLongPress]
/// go through [InkWell] rather than a [GestureDetector] so a press is visible;
/// the ripple takes the scheme's own tint rather than a colour of its own.
class HardwareCard extends StatelessWidget {
  const HardwareCard({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.all(FpSpace.s5),
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final radius = BorderRadius.circular(FpRadius.lg);

    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: Container(
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          borderRadius: radius,
          border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
          boxShadow: context.fpElevation.e1,
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: c.surfaceRaised,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            splashColor: c.surfaceTint,
            highlightColor: c.surfaceSunken,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// An all-caps section label with a rule beside it.
///
/// label-sm already carries the tracking this needs (0.44 in the token), so the
/// all-caps treatment is a `toUpperCase()` and nothing else — no letter-spacing
/// invented at the call site.
class SectionHeading extends StatelessWidget {
  const SectionHeading({required this.label, this.trailing, super.key});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final end = trailing;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          label.toUpperCase(),
          style: FpType.labelSm.copyWith(color: c.textTertiary),
        ),
        const SizedBox(width: FpSpace.s3),
        Expanded(
          child: Divider(color: c.borderSubtle, height: FpStroke.hairline),
        ),
        if (end != null) ...<Widget>[
          const SizedBox(width: FpSpace.s3),
          end,
        ],
      ],
    );
  }
}

/// A label and a value on one line: the shape every read-only hardware fact
/// takes.
///
/// The value is mono when it is an identifier — a serial number, a firmware
/// version — because the design reserves the mono face for exactly those, and
/// because a column of serials that does not align is a column nobody scans.
class FactRow extends StatelessWidget {
  const FactRow({
    required this.label,
    required this.value,
    this.mono = false,
    this.tone,
    this.onLongPress,
    super.key,
  });

  final String label;
  final String value;
  final bool mono;

  /// Overrides the value's colour. Health readings use it; nothing else should.
  final Color? tone;

  final VoidCallback? onLongPress;

  /// The fact-label column, public because a fact whose value is a widget
  /// rather than a string has to line up with the ones whose value is a
  /// string. Wide enough for "Last online", the longest label on these
  /// screens, and fixed so a stack of facts reads as a table rather than as a
  /// ragged list.
  static const double labelWidth = 96.0;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final row = FactSlot(
      label: label,
      child: Text(
        value,
        style: (mono ? FpType.monoSm : FpType.bodySm)
            .copyWith(color: tone ?? c.textPrimary),
      ),
    );
    if (onLongPress == null) return row;
    return GestureDetector(
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }
}

/// A fact whose value is a widget: a battery readout, a two-line reading, a
/// chip. Same label column as [FactRow], so the two interleave without the
/// column shifting.
class FactSlot extends StatelessWidget {
  const FactSlot({required this.label, required this.child, super.key});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FpSpace.s2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: FactRow.labelWidth,
            child: Text(
              label,
              style: FpType.labelMd.copyWith(color: c.textTertiary),
            ),
          ),
          const SizedBox(width: FpSpace.s4),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────── Button chips ───────────────────────────

/// A Button, as a chip.
///
/// The distinction that must survive the restyle is Connect versus Classic:
/// the RN app encodes it in `ButtonBadge`'s background on every screen a Button
/// appears on (§13.1), and losing it would make the Board unreadable. It is
/// carried here by **two** signals rather than by colour alone — a Connect chip
/// is filled with the brand tint and leads with a filled dot; a Classic chip is
/// an outline on the canvas with no dot. Colour alone would fail anyone who
/// cannot separate the two hues.
///
/// `inaudible` is neither: it is the pseudo-Button that records a press with no
/// word, it is pinned last on every board, and it takes tertiary type and a
/// muted icon so it does not read as a word the pet said.
class ButtonChip extends StatelessWidget {
  const ButtonChip({
    required this.label,
    required this.kind,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    super.key,
  });

  /// The chip for a domain [Button].
  ButtonChip.of(
    Button button, {
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    super.key,
  })  : label = button.text,
        kind = button.kind;

  final String label;
  final ButtonKind kind;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// False draws the `unavailable` state: a Button the Base reports but the
  /// database does not have. It is inert because there is nothing to open.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final isConnect = kind == ButtonKind.connect;
    final isInaudible = kind == ButtonKind.inaudible;

    final Color background;
    final Color border;
    final Color foreground;
    if (!enabled) {
      // The specified disabled pair, measured against each other. The old
      // sunken-surface-plus-`textDisabled` combination was a grey on a
      // slightly lighter grey and could not be read in either scheme.
      background = c.actionTertiaryBgDisabled;
      border = c.actionTertiaryBgDisabled;
      foreground = c.actionTertiaryFgDisabled;
    } else if (isInaudible) {
      background = c.surfaceSunken;
      border = c.borderSubtle;
      foreground = c.textTertiary;
    } else if (isConnect) {
      background = c.surfaceTint;
      border = c.borderDefault;
      foreground = c.textBrand;
    } else {
      background = c.surfaceRaised;
      border = c.borderDefault;
      foreground = c.textPrimary;
    }

    final chip = Container(
      constraints: const BoxConstraints(minHeight: HardwareMetrics.touchTarget),
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.s4,
        vertical: FpSpace.s3,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(FpRadius.md),
        border: Border.all(color: border, width: FpStroke.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Unavailable takes the prohibit glyph in the adornment slot,
          // whatever the kind — and the kind's own adornment goes with it, so
          // the mark is never ambiguous. This is the one non-colour signal the
          // chip carries at rest: the fill swap is colour, and a disabled chip
          // has no GestureDetector, so there is nothing to feel either. The
          // dot used to be dropped for `connect` and nothing at all changed
          // for `classic`, which left two of the three kinds signalling by
          // colour alone. Same glyph, same meaning, as the disabled sheet row
          // in `activity_sheet.dart`. See Components § Disabled states.
          if (!enabled) ...<Widget>[
            PhosphorIcon(
              PhosphorIconsRegular.prohibit,
              size: FpIconSize.sm,
              color: foreground,
            ),
            const SizedBox(width: FpSpace.s2),
          ] else ...<Widget>[
            if (isConnect) ...<Widget>[
              Container(
                width: HardwareMetrics.batteryDot,
                height: HardwareMetrics.batteryDot,
                decoration: BoxDecoration(
                  color: foreground,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: FpSpace.s2),
            ],
            if (isInaudible) ...<Widget>[
              PhosphorIcon(
                PhosphorIconsRegular.speakerSimpleSlash,
                size: FpIconSize.sm,
                color: foreground,
              ),
              const SizedBox(width: FpSpace.s2),
            ],
          ],
          Text(
            label,
            style: FpType.bodyMd.copyWith(color: foreground),
          ),
        ],
      ),
    );

    if (!enabled || (onTap == null && onLongPress == null)) {
      return Semantics(
        label: '$label, ${_kindWord(kind)}${enabled ? '' : ', unavailable'}',
        child: ExcludeSemantics(child: chip),
      );
    }

    return Semantics(
      label: '$label, ${_kindWord(kind)}',
      button: true,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          behavior: HitTestBehavior.opaque,
          child: chip,
        ),
      ),
    );
  }

  static String _kindWord(ButtonKind kind) => switch (kind) {
        ButtonKind.connect => 'Connect Button',
        ButtonKind.classic => 'Classic Button',
        ButtonKind.inaudible => 'Inaudible Button',
      };
}

// ─────────────────────────── battery ───────────────────────────

/// A battery reading, on the one scale.
///
/// Deliberately not a Phosphor battery glyph: the set's battery icons come in
/// fill levels, and choosing a level would be inventing a second scale beside
/// [FpFormat.batteryLevel] — which is the exact defect §8 of the inventory
/// records, where a Button at 15% drew a whole bucket healthier than a Base at
/// 15%. A dot can carry one distinction and cannot grow a second.
///
/// Unknown shows an em dash rather than "0%". `-1` on the wire means charging
/// and there is no charging state in the design; a number that stopped meaning
/// anything is worse than no number.
class BatteryReadout extends StatelessWidget {
  const BatteryReadout({required this.percent, this.compact = false, super.key});

  final int? percent;

  /// Drops the word "battery" from the label. Used inside dense rows.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final level = FpFormat.batteryLevel(percent);

    final (Color dot, Color tone) = switch (level) {
      FpBatteryLevel.unknown => (c.borderStrong, c.textTertiary),
      FpBatteryLevel.low => (c.statusWarningSolid, c.statusWarningFg),
      FpBatteryLevel.ok => (c.statusSuccessSolid, c.textSecondary),
    };

    final text = switch (level) {
      FpBatteryLevel.unknown => '—',
      _ => FpFormat.batteryPercent(percent!),
    };

    return Semantics(
      label: level == FpBatteryLevel.unknown
          ? 'Battery unknown'
          : 'Battery $text${level == FpBatteryLevel.low ? ', low' : ''}',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: HardwareMetrics.batteryDot,
              height: HardwareMetrics.batteryDot,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: FpSpace.s2),
            Text(
              compact ? text : '$text battery',
              style: FpType.labelMd.copyWith(color: tone).tabular,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── search and sort ───────────────────────────

/// The search field and sort control every Button list carries.
///
/// One widget for both places the RN app puts them — `CLASSIC_BUTTONS` and the
/// linked-Button list on `BASE_EDIT` — because they are the same control with
/// the same preference behind them, and building two would be how they start
/// to differ.
///
/// Search is a **prefix** match, which is the RN rule kept deliberately: on a
/// board of short words a substring match lights up almost everything.
class ButtonSearchAndSort extends StatelessWidget {
  const ButtonSearchAndSort({
    required this.controller,
    required this.sort,
    required this.onSortChanged,
    required this.onChanged,
    this.hintText = 'Search Buttons',
    super.key,
  });

  final TextEditingController controller;
  final ButtonSort sort;
  final ValueChanged<ButtonSort> onSortChanged;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Row(
      children: <Widget>[
        Expanded(
          child: HardwareTextField(
            controller: controller,
            hintText: hintText,
            onChanged: onChanged,
            prefix: PhosphorIcon(
              PhosphorIconsRegular.magnifyingGlass,
              size: FpIconSize.md,
              color: c.textTertiary,
            ),
            suffix: controller.text.isEmpty
                ? null
                : _ClearButton(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                  ),
          ),
        ),
        const SizedBox(width: FpSpace.s3),
        _SortControl(sort: sort, onChanged: onSortChanged),
      ],
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      label: 'Clear search',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(FpSpace.s2),
          child: PhosphorIcon(
            PhosphorIconsRegular.x,
            size: FpIconSize.sm,
            color: c.textTertiary,
          ),
        ),
      ),
    );
  }
}

/// The sort control: the current order, and a sheet with the three.
///
/// The RN control is a label between two chevrons that opens an action sheet
/// (`ButtonSort.tsx`). Two chevrons on something that is not a stepper is a
/// misdirection — it looks like it moves one step per tap and it does not. One
/// caret, one sheet.
class _SortControl extends StatelessWidget {
  const _SortControl({required this.sort, required this.onChanged});

  final ButtonSort sort;
  final ValueChanged<ButtonSort> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      label: 'Sort Buttons, currently ${sort.label}',
      button: true,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            final chosen = await showHardwareActions<ButtonSort>(
              context: context,
              title: 'Sort Buttons',
              options: <HardwareAction<ButtonSort>>[
                for (final option in ButtonSort.values)
                  HardwareAction<ButtonSort>(
                    label: option.label,
                    value: option,
                    selected: option == sort,
                  ),
              ],
            );
            if (chosen != null) onChanged(chosen);
          },
          child: Container(
            constraints: const BoxConstraints(
              minHeight: HardwareMetrics.fieldMinHeight,
            ),
            padding: const EdgeInsets.symmetric(horizontal: FpSpace.s4),
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(FpRadius.md),
              border: Border.all(
                color: c.borderDefault,
                width: FpStroke.hairline,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PhosphorIcon(
                  PhosphorIconsRegular.arrowsDownUp,
                  size: FpIconSize.sm,
                  color: c.textSecondary,
                ),
                const SizedBox(width: FpSpace.s2),
                Text(
                  sort.label,
                  style: FpType.labelMd.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── text fields ───────────────────────────

/// The one text field these screens use.
///
/// Material's own decoration would bring its own radius, its own focus colour
/// and its own floating label, none of which are in the token set. This is a
/// plain [TextField] inside a token-drawn well: hairline border, `border.focus`
/// when focused at `FpStroke.thick`, `status.danger` when it is carrying an
/// error.
class HardwareTextField extends StatefulWidget {
  const HardwareTextField({
    required this.controller,
    this.hintText,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.errorText,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.textInputAction = TextInputAction.done,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputAction textInputAction;

  @override
  State<HardwareTextField> createState() => _HardwareTextFieldState();
}

class _HardwareTextFieldState extends State<HardwareTextField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final hasError = widget.errorText != null;
    final Color border = hasError
        ? c.statusDangerBorder
        : _focus.hasFocus
            ? c.borderFocus
            : c.borderDefault;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(
            minHeight: HardwareMetrics.fieldMinHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: FpSpace.s4),
          decoration: BoxDecoration(
            color: c.surfaceRaised,
            borderRadius: BorderRadius.circular(FpRadius.md),
            border: Border.all(
              color: border,
              width: _focus.hasFocus ? FpStroke.thick : FpStroke.hairline,
            ),
          ),
          child: Row(
            children: <Widget>[
              if (widget.prefix != null) ...<Widget>[
                widget.prefix!,
                const SizedBox(width: FpSpace.s3),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  onChanged: widget.onChanged,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  maxLength: widget.maxLength,
                  textInputAction: widget.textInputAction,
                  cursorColor: c.textBrand,
                  style: FpType.bodyMd.copyWith(color: c.textPrimary),
                  // The Material counter is styled from ThemeData, not from
                  // the tokens, so it is suppressed and the screen draws its
                  // own where it wants one.
                  buildCounter: (
                    _, {
                    required int currentLength,
                    required bool isFocused,
                    required int? maxLength,
                  }) =>
                      null,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: FpSpace.s4,
                    ),
                    hintText: widget.hintText,
                    hintStyle: FpType.bodyMd.copyWith(color: c.textTertiary),
                  ),
                ),
              ),
              if (widget.suffix != null) ...<Widget>[
                const SizedBox(width: FpSpace.s3),
                widget.suffix!,
              ],
            ],
          ),
        ),
        if (hasError) ...<Widget>[
          const SizedBox(height: FpSpace.s2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PhosphorIcon(
                PhosphorIconsRegular.warningCircle,
                size: FpIconSize.sm,
                color: c.statusDangerFg,
              ),
              const SizedBox(width: FpSpace.s2),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: FpType.labelMd.copyWith(color: c.statusDangerFg),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────── buttons ───────────────────────────

/// The bottom-pinned primary action — CONNECT A BASE, SAVE.
///
/// Full width, sitting on its own surface above the bottom inset, because both
/// screens that have one had one in the RN app and it is the only control on
/// the screen that commits anything. Disabled takes the primary ramp's
/// specified `bgDisabled`/`fgDisabled` pair — an opacity over the enabled fill
/// would fade the label along with it and leave the two illegible against each
/// other.
class HardwarePrimaryButton extends StatelessWidget {
  const HardwarePrimaryButton({
    required this.label,
    required this.onPressed,
    this.onLongPress,
    this.icon,
    super.key,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final enabled = onPressed != null;
    final glyph = icon;
    final background = enabled ? c.actionPrimaryBg : c.actionPrimaryBgDisabled;
    final foreground = enabled ? c.actionPrimaryFg : c.actionPrimaryFgDisabled;

    return Semantics(
      label: label,
      button: true,
      enabled: enabled,
      child: ExcludeSemantics(
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(FpRadius.md),
          child: InkWell(
            onTap: onPressed,
            onLongPress: enabled ? onLongPress : null,
            borderRadius: BorderRadius.circular(FpRadius.md),
            child: Container(
              height: HardwareMetrics.touchTarget + FpSpace.s2,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (glyph != null) ...<Widget>[
                    PhosphorIcon(
                      glyph,
                      size: FpIconSize.md,
                      color: foreground,
                    ),
                    const SizedBox(width: FpSpace.s3),
                  ],
                  Text(
                    label,
                    style: FpType.labelLg.copyWith(color: foreground),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The bar a bottom-pinned button sits in: its own surface, and a hairline
/// above it.
///
/// It does **not** take the bottom safe-area inset. All four Hardware screens
/// live inside the tab branch, so [FpTabBar] is underneath every one of them
/// and already adds the inset below its own row — the same rule the components
/// page states as *"the tab bar sits above this inset, never inside it"*. A
/// second SafeArea here would pad it twice.
class HardwareActionBar extends StatelessWidget {
  const HardwareActionBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceRaised,
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
      child: child,
    );
  }
}

// ─────────────────────────── sheets and alerts ───────────────────────────

/// One option in a [showHardwareActions] sheet.
class HardwareAction<T> {
  const HardwareAction({
    required this.label,
    required this.value,
    this.description,
    this.icon,
    this.destructive = false,
    this.selected = false,
  });

  final String label;
  final T value;
  final String? description;
  final IconData? icon;

  /// Drawn in the danger ramp. Delete and Unlink, and nothing else.
  final bool destructive;

  /// Drawn with a check. Used by the sort sheet.
  final bool selected;
}

/// The action sheet, as the four screens use it.
///
/// The RN app reaches for `@expo/react-native-action-sheet`, whose options are
/// built by index — and the indices shift with the flags, which is how
/// `getSingleItemActionSheetOptions` became a source of bugs. This takes a
/// typed value per option, so an option cannot be off by one.
///
/// Cancel is the sheet's own dismissal, not an option in the list: an explicit
/// Cancel row on a sheet that already dismisses on a tap outside is a row that
/// only ever adds height.
///
/// ## Height
///
/// The sheet is scroll-controlled and its option list is scrollable, because
/// callers outside Hardware pass lists Hardware never did — Household's country
/// picker is twelve options with descriptions. A default `showModalBottomSheet`
/// is capped at half the viewport and does not scroll, so the eleventh option
/// is not "below the fold", it is *unreachable*, and on a short viewport a
/// `Column` past that cap overflows outright.
///
/// The title and message stay pinned and only the options scroll: what the
/// sheet is asking has to stay visible while you look for the answer. With few
/// enough options the sheet still shrink-wraps exactly as before — [Flexible]
/// over a shrink-wrapping list changes nothing until the content would not fit.
Future<T?> showHardwareActions<T>({
  required BuildContext context,
  required String title,
  required List<HardwareAction<T>> options,
  String? message,
}) {
  // Colour comes from `bottomSheetTheme`, never from an argument here: an
  // argument is read once at push time and baked into the route, so a scheme
  // change with the sheet open repaints its contents and leaves the panel on
  // the old scheme.
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    // Lifts the default half-viewport cap. Without it the constraint below has
    // nothing to expand into.
    isScrollControlled: true,
    // Keeps the sheet clear of the status bar and the home indicator once it
    // is allowed to grow past half the screen.
    useSafeArea: true,
    builder: (sheetContext) {
      final sc = sheetContext.fpColors;
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                FpSpace.s6,
                FpSpace.s0,
                FpSpace.s6,
                FpSpace.s3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: FpType.headingSm.copyWith(color: sc.textPrimary),
                  ),
                  if (message != null) ...<Widget>[
                    const SizedBox(height: FpSpace.s2),
                    Text(
                      message,
                      style: FpType.bodySm.copyWith(color: sc.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: FpSpace.s4),
                children: <Widget>[
                  for (final option in options)
                    _ActionRow<T>(
                      option: option,
                      onTap: () => Navigator.of(sheetContext).pop(option.value),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _ActionRow<T> extends StatelessWidget {
  const _ActionRow({required this.option, required this.onTap});

  final HardwareAction<T> option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    // `status.danger.fg`, not `action.danger.fg`. An `action.*.fg` is defined
    // only against its own `action.*.bg` — the token file says so on
    // `action.*.fgDisabled`: "measured against bgDisabled rather than against
    // the canvas". This row has no fill, so it is the canvas, and
    // `actionDangerFg` here is #FFFFFF on the #FFFFFF sheet in light and
    // #100F0D on the #1C1A17 sheet in dark: 1.00:1 and 1.10:1, an invisible
    // Delete row in both schemes. `statusDangerFg` is the system's danger-
    // coloured *text* — 6.21:1 light, 7.71:1 dark on the raised surface.
    final tone = option.destructive ? c.statusDangerFg : c.textPrimary;
    final glyph = option.icon;
    final description = option.description;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: HardwareMetrics.touchTarget,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: FpSpace.s6,
          vertical: FpSpace.s4,
        ),
        child: Row(
          children: <Widget>[
            if (glyph != null) ...<Widget>[
              PhosphorIcon(glyph, size: FpIconSize.md, color: tone),
              const SizedBox(width: FpSpace.s4),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    option.label,
                    style: FpType.bodyMd.copyWith(color: tone),
                  ),
                  if (description != null) ...<Widget>[
                    const SizedBox(height: FpSpace.s1),
                    Text(
                      description,
                      style: FpType.bodySm.copyWith(color: c.textTertiary),
                    ),
                  ],
                ],
              ),
            ),
            if (option.selected)
              PhosphorIcon(
                PhosphorIconsFill.check,
                size: FpIconSize.md,
                color: c.textBrand,
              ),
          ],
        ),
      ),
    );
  }
}

/// The destructive confirmation, in the RN app's own words.
///
/// Delete a Base and unlink a Button both go through a confirm first, and both
/// keep their copy: *"Are you sure? / This will be permanently deleted."* and
/// *"Are you sure you want to unlink "X"?"* (`deleteConfirmationAlert.ts`,
/// `hideConfirmationAlert.ts`). Reproduced because the words are the part of a
/// destructive dialog that does the work.
Future<bool> confirmDestructive({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  // Colour comes from `dialogTheme` — see the note on [showHardwareActions].
  final result = await showDialog<bool>(
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
            // `statusDangerFg`, for the reason spelled out on `_ActionRow`:
            // a `TextButton` has no fill, so `actionDangerFg` would be white
            // on the white dialog in light and near-black on near-black in
            // dark. An invisible confirm button on a destructive dialog.
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              confirmLabel,
              style: FpType.labelLg.copyWith(color: dc.statusDangerFg),
            ),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

/// What a phase-1 write does instead of writing.
///
/// Every mutation on these four screens — delete a Base, save a Base, archive
/// a Button, unlink a Button, open an external browser — is listed in §15 as a
/// no-op. A control that silently does nothing is indistinguishable from a
/// broken one, so each says so, once, in the same place and the same words.
void showPhaseOneNotice(BuildContext context, String what) {
  final c = context.fpColors;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: c.surfaceInverse,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FpRadius.md),
        ),
        content: Text(
          '$what — phase 1 stores nothing.',
          style: FpType.bodySm.copyWith(color: c.textInverse),
        ),
      ),
    );
}

// ─────────────────────────── states ───────────────────────────

/// The one loading treatment these screens use.
class HardwareLoading extends StatelessWidget {
  const HardwareLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FpSpace.s10),
      child: Center(
        child: SizedBox(
          width: FpIconSize.lg,
          height: FpIconSize.lg,
          child: CircularProgressIndicator(
            strokeWidth: FpStroke.thick,
            color: c.textTertiary,
          ),
        ),
      ),
    );
  }
}

/// An empty or failed state: a glyph, a line that says what happened, and a
/// line that says what to do about it.
///
/// §14.4 of the inventory records that the RN app's empty states are
/// undifferentiated — one string covering a genuinely empty account, an
/// over-filtered list and a facet with no matches. Every empty state on these
/// four screens says which one it is.
class HardwareNotice extends StatelessWidget {
  const HardwareNotice({
    required this.icon,
    required this.title,
    this.body,
    this.tone = HardwareNoticeTone.neutral,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? body;
  final HardwareNoticeTone tone;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final (Color glyph, Color heading) = switch (tone) {
      HardwareNoticeTone.neutral => (c.textTertiary, c.textPrimary),
      HardwareNoticeTone.danger => (c.statusDangerSolid, c.statusDangerFg),
    };
    final text = body;
    final control = action;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.s6,
        vertical: FpSpace.s9,
      ),
      child: Column(
        children: <Widget>[
          PhosphorIcon(icon, size: FpIconSize.xl, color: glyph),
          const SizedBox(height: FpSpace.s5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: FpType.headingSm.copyWith(color: heading),
          ),
          if (text != null) ...<Widget>[
            const SizedBox(height: FpSpace.s3),
            Text(
              text,
              textAlign: TextAlign.center,
              style: FpType.bodySm.copyWith(color: c.textSecondary),
            ),
          ],
          if (control != null) ...<Widget>[
            const SizedBox(height: FpSpace.s6),
            control,
          ],
        ],
      ),
    );
  }
}

enum HardwareNoticeTone { neutral, danger }

// ─────────────────────────── odds and ends ───────────────────────────

/// The square well that stands in for the RN screens' product photography.
///
/// `BaseItem` and `ClassicButtonsList` each render a photograph of the hardware
/// beside the text. Phase 1 ships no product photography — and a screen that
/// silently dropped it would lose the one cue that tells a Base row apart from
/// a Buttons row at a glance. A Phosphor glyph in a sunken square keeps that
/// cue and stays honest about being a stand-in.
class ProductGlyph extends StatelessWidget {
  const ProductGlyph({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      width: HardwareMetrics.productGlyphWell,
      height: HardwareMetrics.productGlyphWell,
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(FpRadius.md),
        border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
      ),
      alignment: Alignment.center,
      child: PhosphorIcon(
        icon,
        size: HardwareMetrics.productGlyph,
        color: c.textTertiary,
      ),
    );
  }
}

/// One fact in a middot-separated meta line, with its own tone.
class MetaFact {
  const MetaFact(this.text, {this.tone, this.mono = false});

  final String text;

  /// Null takes tertiary. A warning fact — "1 Button low" — passes the status
  /// ramp; nothing else should.
  final Color? tone;

  final bool mono;
}

/// A wrapping line of [MetaFact]s separated by middots.
///
/// The middot is punctuation, so it takes the same half-opacity the timeline's
/// separators do ([FpMetrics.separatorOpacity]) — one rule for separators
/// across the app rather than a second, denser dot here.
class MetaLine extends StatelessWidget {
  const MetaLine({required this.facts, super.key});

  final List<MetaFact> facts;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final separator = FpType.labelMd.copyWith(
      color: c.textTertiary.withValues(alpha: FpMetrics.separatorOpacity),
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        for (var i = 0; i < facts.length; i++) ...<Widget>[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FpSpace.s2),
              child: Text('·', style: separator),
            ),
          Text(
            facts[i].text,
            style: (facts[i].mono ? FpType.monoSm : FpType.labelMd)
                .copyWith(color: facts[i].tone ?? c.textTertiary),
          ),
        ],
      ],
    );
  }
}

/// What these five screens need that neither `lib/widgets/` nor
/// `lib/screens/log/log_controls.dart` already draws.
///
/// Per the coordinator's addendum: `log_controls.dart` sits one directory up
/// and already carries almost everything a select/check/chip form screen
/// needs — `LogSelectRow`, `LogActionButton`, `LogActionBar`, `LogSection`,
/// `LogHairline`, `LogEmptyState`, `LogTextAction`, `LogButtonChip`,
/// `LogHeaderIconButton`, `showLogSheet`/`LogSheetOption`, `LogCheckRow`,
/// `logSay`, `logConfirm`. These five screens import and use those directly
/// rather than redrawing them; see each screen file for where.
///
/// What is here is only what does not already exist anywhere in the app:
///
/// * [ButtonTextField] — a free-text input. `log_controls.dart` has select
///   rows and tokens but no editable field, and `BUTTON_ADD`/`BUTTON_EDIT`
///   need one for the Word and the Webhook URL.
/// * [buttonsModalHeader] — the header the four `modal`-presented screens
///   share. `LOG` already answers this question
///   (`lib/screens/log/log_screen.dart`, itself `FpPresentation.modal`): the
///   shared [ScreenHeader] with no `onBack` — so no back chevron, which means
///   "go back one screen" and is the wrong gesture for a modal's dismissal
///   (`docs/second-pass-brief.md`: *"`modal` must stay modal: presenting a
///   modal as a push changes what the back gesture means"*) — and a close
///   (×) `LogHeaderIconButton` in the `trailing` slot instead. This is that
///   same composition, factored out once rather than repeated four times.
/// * [ButtonsExpander] — the "Show/Hide Advanced Settings" disclosure both
///   `BUTTON_ADD` and `BUTTON_EDIT` use to keep the Meaning/Date/Type/Webhook
///   block out of the way until asked for (`SectionToggle` in the RN app).
/// * [ButtonAudioSection] — the honest stand-in for `ButtonAudio.tsx`'s
///   record/play/delete control. Phase 1 has no microphone and no player
///   (PLAN.md), so Record and Play are wired to [logSay] rather than to
///   anything real; Delete, which only clears local form state, works.
///
/// The same rules as everywhere else: colour from `context.fpColors`, every
/// sized measurement that has a token uses it, anything that does not is
/// named in [ButtonsMetrics].
library;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../log/log_controls.dart';

/// The RN screens gate the Webhook URL field on
/// `useFeatureFlags(user).homeIntegrationEnabled`. Phase 1 has no
/// authentication and therefore no per-user flags (§13.4); this shows the
/// field, the "default to what a normal user sees" call
/// `hardware_providers.dart`'s `appDebuggingEnabledProvider` makes for its own
/// admin-only field, made the other way here because a webhook is an
/// ordinary setting rather than an admin one. Shared by `BUTTON_ADD` and
/// `BUTTON_EDIT`, which is why it lives here rather than in either screen.
const bool buttonWebhooksEnabled = true;

/// Measurements these screens need that no token and no `LogMetrics` value
/// already names.
class ButtonsMetrics {
  const ButtonsMetrics._();

  /// The well a text field sits in. Matches `LogMetrics.tapTarget` /
  /// `HardwareMetrics.fieldMinHeight` — the same 44/48 floor every other
  /// area's field uses, named again here because this file cannot import a
  /// sibling area's metrics class for one constant.
  static const double fieldMinHeight = 48.0;

  /// The record/play/delete controls in [ButtonAudioSection] — big enough to
  /// be the obvious primary action on an otherwise quiet section, the same
  /// diameter the RN screen gives its own mic button.
  static const double audioControl = 64.0;

  /// The one success-state icon these screens share (`BUTTON_PAIRING`'s
  /// paired state, `DOWNLOAD_SOUND`'s completed state) — the RN screens draw
  /// each at a different size (`CheckCircleSolid` 24, `CheckCircleSolidIcon`
  /// 162); one shared size reads as one system rather than two coincidences.
  static const double heroIcon = 96.0;
}

// ─────────────────────────── modal header ───────────────────────────

/// The header the four `modal`-presented screens share: [ScreenHeader] with
/// no `onBack` — so no back chevron — and a close (×) `LogHeaderIconButton`
/// in the `trailing` slot instead.
///
/// The same composition `LOG` already uses for its own modal header
/// (`lib/screens/log/log_screen.dart`), factored out here because four more
/// screens need it. [title] comes from [FpScreen.title] verbatim, which is
/// already upper-case (the RN app's own `ScreenTitle` strings) — `ScreenHeader`
/// does not re-case it, and neither does this.
Widget buttonsModalHeader({
  required String title,
  required VoidCallback onClose,
}) {
  return ScreenHeader(
    title: title,
    trailing: LogHeaderIconButton(
      icon: PhosphorIconsRegular.x,
      semanticLabel: 'Close',
      onTap: onClose,
    ),
  );
}

// ─────────────────────────── text field ───────────────────────────

/// The one free-text input these screens use: the Word, the Webhook URL, the
/// merge board's search box.
///
/// Same recipe `lib/screens/hardware/hardware_ui.dart`'s `HardwareTextField`
/// draws — a plain [TextField] inside a token-bordered well, `border.focus`
/// at [FpStroke.thick] when focused, `status.danger` when carrying an error —
/// kept local rather than imported because that class lives in a sibling
/// area this group does not own and two areas independently reaching the
/// same four-line recipe is the expected shape here, not a defect (the
/// coordinator's addendum: reuse `log_controls.dart` first; invent only what
/// is missing, and keep what is invented to one file).
class ButtonTextField extends StatefulWidget {
  const ButtonTextField({
    required this.controller,
    this.hintText,
    this.onChanged,
    this.keyboardType,
    this.errorText,
    this.prefix,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final String? errorText;
  final Widget? prefix;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;

  @override
  State<ButtonTextField> createState() => _ButtonTextFieldState();
}

class _ButtonTextFieldState extends State<ButtonTextField> {
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
            minHeight: ButtonsMetrics.fieldMinHeight,
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
                  textInputAction: widget.textInputAction,
                  textCapitalization: widget.textCapitalization,
                  cursorColor: c.textBrand,
                  style: FpType.bodyMd.copyWith(color: c.textPrimary),
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

// ─────────────────────────── advanced-settings disclosure ───────────────────────────

/// "Show/Hide Advanced Settings" — `SectionToggle` in the RN app
/// (`src/components/common/SectionToggle.tsx`), used on both `BUTTON_ADD` and
/// `BUTTON_EDIT` to keep Meaning, Date, Type and Webhook out of the way of the
/// one field that matters until someone asks for the rest.
class ButtonsExpander extends StatefulWidget {
  const ButtonsExpander({required this.child, super.key});

  final Widget child;

  @override
  State<ButtonsExpander> createState() => _ButtonsExpanderState();
}

class _ButtonsExpanderState extends State<ButtonsExpander> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LogTextAction(
          label: _open ? 'Hide Advanced Settings' : 'Show Advanced Settings',
          icon: _open
              ? PhosphorIconsRegular.caretUp
              : PhosphorIconsRegular.caretDown,
          onTap: () => setState(() => _open = !_open),
        ),
        AnimatedSize(
          duration: context.fpDuration.base,
          curve: context.fpEasing.standard,
          alignment: Alignment.topCenter,
          child: _open
              ? Padding(
                  padding: const EdgeInsets.only(top: FpSpace.s4),
                  child: widget.child,
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

// ─────────────────────────── audio (phase-1 stand-in) ───────────────────────────

/// The honest stand-in for `ButtonAudio.tsx`'s record/play/delete control.
///
/// Phase 1 has no microphone and no player (PLAN.md). Record and Play are
/// real, tappable controls that say so through [logSay] rather than pretend
/// to work; Delete is real — it only clears the form's local sound state, the
/// same as the RN control's `onSoundEdit(null)`.
class ButtonAudioSection extends StatelessWidget {
  const ButtonAudioSection({
    required this.hasSound,
    required this.label,
    required this.onDelete,
    super.key,
  });

  /// True when the form currently has a sound attached — recorded this
  /// session or already on the Button.
  final bool hasSound;

  /// What to show beside the sound when [hasSound] is true.
  final String label;

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return LogSection(
      title: 'Sound',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: FpSpace.s5,
          vertical: FpSpace.s5,
        ),
        decoration: BoxDecoration(
          color: c.surfaceSunken,
          borderRadius: BorderRadius.circular(FpRadius.md),
          border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
        ),
        child: Column(
          children: <Widget>[
            Text(
              hasSound
                  ? 'To record again, delete the current sound.'
                  : 'Tap to record a sound for your Button',
              textAlign: TextAlign.center,
              style: FpType.bodySm.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: FpSpace.s4),
            if (hasSound) ...<Widget>[
              Text(label, style: FpType.labelMd.copyWith(color: c.textPrimary)),
              const SizedBox(height: FpSpace.s4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Brand, not the success ramp: Play is an action, not a
                  // health reading, and "status colour is not brand colour"
                  // cuts both ways — the success ramp is not borrowed to mean
                  // "playable" either (components page, Device health pill).
                  _AudioControl(
                    icon: PhosphorIconsRegular.play,
                    semanticLabel: 'Play sound',
                    background: c.actionPrimaryBg,
                    foreground: c.actionPrimaryFg,
                    onTap: () =>
                        logSay(context, 'Playback arrives in a later build.'),
                  ),
                  const SizedBox(width: FpSpace.s5),
                  _AudioControl(
                    icon: PhosphorIconsRegular.trash,
                    semanticLabel: 'Delete sound',
                    background: c.actionDangerBg,
                    foreground: c.actionDangerFg,
                    onTap: onDelete,
                  ),
                ],
              ),
            ] else
              _AudioControl(
                icon: PhosphorIconsRegular.microphone,
                semanticLabel: 'Record a sound',
                background: c.actionDangerBg,
                foreground: c.actionDangerFg,
                onTap: () =>
                    logSay(context, 'Recording arrives in a later build.'),
              ),
          ],
        ),
      ),
    );
  }
}

class _AudioControl extends StatelessWidget {
  const _AudioControl({
    required this.icon,
    required this.semanticLabel,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Material(
          color: background,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: ButtonsMetrics.audioControl,
              height: ButtonsMetrics.audioControl,
              child: Center(
                child: PhosphorIcon(
                  icon,
                  color: foreground,
                  size: FpIconSize.lg,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── battery ───────────────────────────

/// A battery reading as a dot plus a percent, on `FpFormat`'s one scale.
///
/// `BUTTON_EDIT`'s header shows a Connect Button's own battery
/// (`ButtonEdit.tsx:268-274`) when the caller passed one. Same recipe
/// `hardware_ui.dart`'s `BatteryReadout` uses — a dot, not a Phosphor battery
/// glyph with a fill level, so there is exactly one scale in the app rather
/// than two disagreeing at 15% (`docs/screen-inventory.md` §8) — kept local
/// for the same reason [ButtonTextField] is: this group does not import
/// Hardware's widgets.
class ButtonBatteryDot extends StatelessWidget {
  const ButtonBatteryDot({required this.percent, super.key});

  final int? percent;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final level = FpFormat.batteryLevel(percent);
    final Color dot = switch (level) {
      FpBatteryLevel.unknown => c.borderStrong,
      FpBatteryLevel.low => c.statusWarningSolid,
      FpBatteryLevel.ok => c.statusSuccessSolid,
    };
    final text = level == FpBatteryLevel.unknown
        ? '—'
        : FpFormat.batteryPercent(percent!);

    return Semantics(
      label: level == FpBatteryLevel.unknown
          ? 'Battery unknown'
          : 'Battery $text',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: FpSpace.s2,
              height: FpSpace.s2,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: FpSpace.s2),
            Text(
              text,
              style: FpType.labelMd.copyWith(color: c.textSecondary).tabular,
            ),
          ],
        ),
      ),
    );
  }
}

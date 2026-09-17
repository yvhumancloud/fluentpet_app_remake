/// Everything the six auth screens needed that did not already exist.
///
/// **Fixtures only. Nothing here authenticates.** No widget in this file sends
/// anything, stores anything, or hands a password to anything except the two
/// pure predicates in `auth_rules.dart` that measure its length. The submit
/// path is deliberately absent — see each screen's own doc comment.
///
/// ## What was reused, and what had to be built
///
/// Reused as they are, not re-drawn: [ScreenHeader] for the title block and
/// the back chevron, [LogActionButton] and [LogActionBar] for the pinned
/// primary, [LogTextAction] for every quiet inline route, [LogHairline] for a
/// section rule, [HardwareNotice] for a screen whose whole content is a state
/// rather than a form, and `FpFormat` for the one string built from a number.
///
/// What is here is what none of those can express:
///
/// * [AuthField] — a labelled field that can obscure its content and reveal it
///   again. See the note on that class: it is **one more text-field
///   implementation than this repo should have**, it exists only because
///   `HardwareTextField` cannot obscure and cannot be edited from here, and the
///   exact change that would delete it is written down rather than left for
///   somebody to rediscover.
/// * [AuthBanner] — a message about the form as a whole rather than about one
///   field. Nothing existing carries a form-level rejection.
/// * [AuthRequirementList] — the live requirement list under a new password.
/// * [AuthSubmit] — the pinned primary plus the *stated reason* a disabled one
///   owes, per Components § Disabled states.
/// * [AuthAddressWell] — the address a message went to, quoted back.
/// * [AuthResendControl] — a rate-limited resend, and the disabled treatment
///   the rule asks for: affordance removed, reason in words.
/// * [AuthPhaseNote] — the honest footnote on any screen that talks about mail
///   nobody sent.
/// * [AuthScaffold] — the page shape all six share.
/// * [authLocation] and [authSwap] — the two navigation rules the flow needs.
///
/// ## The direction, applied
///
/// Warm editorial, the same reading as the Hardware area: warmth in the type
/// and in one accent, not in rounded shapes and pastel fills. So an auth screen
/// here is a display-type title, a line of prose that says what the screen is
/// for, hairline-drawn fields on the raised surface, and exactly one saturated
/// colour — whichever status ramp the current state earns. An auth screen is
/// the second-easiest surface in this app to render as stock Material; the
/// tells to avoid are a floating label, a filled field, a coloured focus ring
/// that is not `border.focus`, and a centred logo lockup. None appear.
///
/// **Disabled is structural.** `text.disabled` and `text.tertiary` are the same
/// value on purpose, so colour carries nothing. Every disabled control in this
/// file changes shape: [AuthSubmit] loses its ripple *and* grows a reason line
/// led by Phosphor `prohibit`, and [AuthResendControl] deletes its affordance
/// outright rather than greying it.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../activity/ui/activity_controls.dart' show ActionButton, ButtonTone;
import '../hardware/hardware_metrics.dart';
import '../log/log_controls.dart'
    show LogActionBar, LogActionButton, LogHairline, LogMetrics, LogTextAction;

// ─────────────────────────── page shape ───────────────────────────

/// The shape all five auth screens take.
///
/// A title block, a scrolling body, and an optional pinned action bar. The
/// body scrolls because the keyboard takes roughly half of a 402pt screen and
/// a form that cannot scroll under it is a form with a hidden field; the bar is
/// outside the scroll view because a primary action that scrolls away is one
/// nobody finds.
///
/// [bottom] is true on [FpOsChrome] because none of these screens sits inside
/// the tab branch — `AUTHENTICATION` is a root stack — so there is no
/// [FpTabBar] below them to take the inset.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.children,
    this.onBack,
    this.footer,
    super.key,
  });

  final String title;

  /// The body, top to bottom. Spacing between items is each screen's own.
  final List<Widget> children;

  /// Null draws no back chevron, which is [ScreenHeader]'s own rule: the
  /// chevron exists exactly when there is somewhere to go back to.
  final VoidCallback? onBack;

  /// Goes inside a [LogActionBar]. Null means the screen pins nothing.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final bar = footer;
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(title: title, onBack: onBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  FpSpace.s6,
                  FpSpace.s0,
                  FpSpace.s6,
                  FpSpace.s7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
            if (bar != null) LogActionBar(children: <Widget>[bar]),
          ],
        ),
      ),
    );
  }
}

/// The sentence under the title that says what the screen is for.
///
/// One paragraph, body-md at secondary. Not a heading: the title is already
/// the heading, and a second one competing with it is the standard auth-screen
/// mistake.
class AuthLead extends StatelessWidget {
  const AuthLead(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: FpType.bodyMd.copyWith(color: context.fpColors.textSecondary),
      );
}

// ─────────────────────────── fields ───────────────────────────

/// A labelled text field that can obscure its contents and reveal them again.
///
/// ## This is one more field implementation than there should be
///
/// The repo already draws this well in three named widgets —
/// `HardwareTextField`, `SettingsTextField`, `ButtonTextField` — and in nine
/// further ad-hoc `TextField`s inside individual screens' build methods
/// (`activity_filters_screen`, `log_screen`, `log_details_screen` ×2,
/// `log_entry_edit_screen` ×2, `log_entry_edit_buttons_screen`,
/// `button_add_screen`, `button_edit_screen`). This class is one more, and it
/// should not have been.
///
/// The right change was a handful of optional parameters on
/// `HardwareTextField`, which already draws exactly this well: same
/// `FpRadius.md`, same hairline, same `border.focus` at `FpStroke.thick`, same
/// `status.danger` error row, same `HardwareMetrics.fieldMinHeight`. The
/// measurements here are read from `HardwareMetrics` and `LogMetrics` rather
/// than restated precisely so the two cannot drift apart while they coexist.
///
/// `HardwareTextField` cannot express a password. It has no `obscureText`, no
/// `autofillHints`, no `onSubmitted`, no `autofocus` and no way to hand in a
/// [FocusNode] — and a `TextField` cannot be obscured from outside itself.
/// The only "composition" available is feeding a masked string through the
/// controller, which breaks the cursor, the selection and autofill, and is
/// worse than either honest option. This file is not permitted to edit
/// `hardware_ui.dart`, so the field was rebuilt.
///
/// **The fix, for whoever consolidates these:** add `obscureText`,
/// `autofillHints`, `focusNode`, `onSubmitted`, `textCapitalization`,
/// `autocorrect`, `enableSuggestions` and `autofocus` to `HardwareTextField`,
/// every one of them defaulted so that no existing call site changes, then
/// delete this class and point the six auth screens at it. Nothing else in this
/// file depends on it, and the label/`below` slots are the only additions that
/// would need to come with it.
///
/// ## Autofill
///
/// [autofillHints] are set so the OS can *fill* the field from its own
/// keychain, which is a read into an in-memory [TextEditingController] and
/// nothing more. `TextInput.finishAutofillContext()` — the call that asks the
/// OS to **save** a credential — is never made anywhere in this app, and the
/// screens say so in their own doc comments.
class AuthField extends StatefulWidget {
  const AuthField({
    required this.controller,
    required this.label,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction = TextInputAction.done,
    this.obscurable = false,
    this.maxLength,
    this.autofocus = false,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.below,
    super.key,
  });

  final TextEditingController controller;

  /// Sentence case, above the well. Not a floating label: a label that moves
  /// is Material's idiom and it is not in this token set.
  final String label;

  final String? hintText;

  /// Non-null draws the error row and recolours the well's border. The screens
  /// pass null until the field has been submitted or corrected once — an error
  /// on the third keystroke of an address is noise, not help.
  final String? errorText;

  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction textInputAction;

  /// True hides the contents and adds the reveal toggle.
  final bool obscurable;

  final int? maxLength;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Hangs under the field and above the error row — the requirement list.
  final Widget? below;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  FocusNode? _own;
  bool _revealed = false;

  FocusNode get _focus => widget.focusNode ?? (_own ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  @override
  void didUpdateWidget(AuthField old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      old.focusNode?.removeListener(_onFocus);
      _focus.addListener(_onFocus);
    }
  }

  void _onFocus() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _own?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final error = widget.errorText;
    final hasError = error != null;
    final focused = _focus.hasFocus;
    final obscured = widget.obscurable && !_revealed;

    final Color border = hasError
        ? c.statusDangerBorder
        : focused
            ? c.borderFocus
            : c.borderDefault;

    final extra = widget.below;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: FpType.labelMd.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: FpSpace.s2),
        Container(
          constraints: const BoxConstraints(
            minHeight: HardwareMetrics.fieldMinHeight,
          ),
          padding: const EdgeInsets.only(left: FpSpace.s4),
          decoration: BoxDecoration(
            color: c.surfaceRaised,
            borderRadius: BorderRadius.circular(FpRadius.md),
            border: Border.all(
              color: border,
              width: focused ? FpStroke.thick : FpStroke.hairline,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  autofocus: widget.autofocus,
                  obscureText: obscured,
                  // An obscured field must not be corrected, suggested at, or
                  // capitalised: all three leak the contents to the keyboard's
                  // own dictionary. An address must not be either — `Otis` is
                  // not the same local part as `otis`.
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  keyboardType: widget.keyboardType,
                  autofillHints: widget.autofillHints,
                  textInputAction: widget.textInputAction,
                  maxLength: widget.maxLength,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  cursorColor: c.textBrand,
                  style: FpType.bodyMd.copyWith(color: c.textPrimary),
                  // The Material counter is styled from ThemeData rather than
                  // from the tokens, so it is suppressed. Nothing here wants a
                  // visible count: the length caps exist to stop a paste, not
                  // to be aimed at.
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
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: FpSpace.s4),
                    hintText: widget.hintText,
                    hintStyle: FpType.bodyMd.copyWith(color: c.textTertiary),
                  ),
                ),
              ),
              if (widget.obscurable)
                _RevealToggle(
                  revealed: _revealed,
                  onTap: () => setState(() => _revealed = !_revealed),
                )
              else
                const SizedBox(width: FpSpace.s4),
            ],
          ),
        ),
        if (extra != null) ...<Widget>[
          const SizedBox(height: FpSpace.s3),
          extra,
        ],
        if (hasError) ...<Widget>[
          const SizedBox(height: FpSpace.s2),
          _FieldError(message: error),
        ],
      ],
    );
  }
}

/// The eye. A glyph swap, not a colour swap — the same mechanism the tab bar
/// and the flag marker use, and the reason the icon set was chosen.
class _RevealToggle extends StatelessWidget {
  const _RevealToggle({required this.revealed, required this.onTap});

  final bool revealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      label: revealed ? 'Hide password' : 'Show password',
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: LogMetrics.tapTarget,
            height: LogMetrics.tapTarget,
            child: Center(
              child: PhosphorIcon(
                revealed
                    ? PhosphorIconsRegular.eyeSlash
                    : PhosphorIconsRegular.eye,
                size: FpIconSize.md,
                color: c.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One field's error, drawn the way `HardwareTextField` draws its own so the
/// two read as one system.
class _FieldError extends StatelessWidget {
  const _FieldError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Row(
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
            message,
            style: FpType.labelMd.copyWith(color: c.statusDangerFg),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── messages ───────────────────────────

/// Which status ramp a banner draws from.
enum AuthBannerTone { info, danger, success }

/// A message about the form as a whole.
///
/// Field errors say what is wrong with one field. This says what happened to
/// the submission — rejected, rate limited, done, or stopped because phase 1
/// stops here. Nothing that existed carried that; a snackbar was the closest
/// and a rejection that disappears after four seconds is a rejection the user
/// has to reproduce to read.
///
/// A tinted block with a hairline in its own ramp, not a filled slab: the
/// status backgrounds are the quiet end of each ramp by design and the
/// foreground is the only saturated thing in it.
class AuthBanner extends StatelessWidget {
  const AuthBanner({
    required this.message,
    this.tone = AuthBannerTone.info,
    this.title,
    super.key,
  });

  final String message;

  /// An optional first line, heavier than the message.
  final String? title;

  final AuthBannerTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final (Color bg, Color fg, Color line, IconData glyph) = switch (tone) {
      AuthBannerTone.info => (
          c.statusInfoBg,
          c.statusInfoFg,
          c.statusInfoBorder,
          PhosphorIconsRegular.info,
        ),
      AuthBannerTone.danger => (
          c.statusDangerBg,
          c.statusDangerFg,
          c.statusDangerBorder,
          PhosphorIconsRegular.warningCircle,
        ),
      AuthBannerTone.success => (
          c.statusSuccessBg,
          c.statusSuccessFg,
          c.statusSuccessBorder,
          PhosphorIconsRegular.checkCircle,
        ),
    };
    final heading = title;

    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(FpSpace.s4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(FpRadius.md),
          border: Border.all(color: line, width: FpStroke.hairline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PhosphorIcon(glyph, size: FpIconSize.md, color: fg),
            const SizedBox(width: FpSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (heading != null) ...<Widget>[
                    Text(
                      heading,
                      style: FpType.headingSm.copyWith(color: fg),
                    ),
                    const SizedBox(height: FpSpace.s1),
                  ],
                  Text(
                    message,
                    style: FpType.bodySm.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One rule a new password has to meet, and whether it does yet.
class AuthRequirement {
  const AuthRequirement({required this.label, required this.met});

  final String label;
  final bool met;
}

/// The live list under a new-password field.
///
/// The rules are shown *before* they are broken, which is the whole argument
/// for the list: a rule you learn by failing it is a rule the screen kept from
/// you. Met is a **glyph and weight change** — regular `circle` to filled
/// `check-circle` — so it survives being read without colour, which is the same
/// rule Components § Disabled states states for unavailability.
class AuthRequirementList extends StatelessWidget {
  const AuthRequirementList({required this.requirements, super.key});

  final List<AuthRequirement> requirements;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var i = 0; i < requirements.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: FpSpace.s2),
          Semantics(
            label: '${requirements[i].label} — '
                '${requirements[i].met ? 'met' : 'not met yet'}',
            child: ExcludeSemantics(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PhosphorIcon(
                    requirements[i].met
                        ? PhosphorIconsFill.checkCircle
                        : PhosphorIconsRegular.circle,
                    size: FpIconSize.sm,
                    color: requirements[i].met
                        ? c.statusSuccessSolid
                        : c.textTertiary,
                  ),
                  const SizedBox(width: FpSpace.s2),
                  Expanded(
                    child: Text(
                      requirements[i].label,
                      style: FpType.labelMd.copyWith(
                        color: requirements[i].met
                            ? c.textSecondary
                            : c.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A reason something cannot be done, marked as one.
///
/// Components § Disabled states: *"Phosphor `prohibit`, regular weight, leading
/// the reason. One glyph, one meaning, everywhere unavailability needs a
/// mark."* This is that, and it is the only place in this file that draws it.
class AuthUnavailableReason extends StatelessWidget {
  const AuthUnavailableReason(this.reason, {super.key});

  final String reason;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PhosphorIcon(
          PhosphorIconsRegular.prohibit,
          size: FpIconSize.sm,
          color: c.textTertiary,
        ),
        const SizedBox(width: FpSpace.s2),
        Expanded(
          child: Text(
            reason,
            style: FpType.labelMd.copyWith(color: c.textTertiary),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── actions ───────────────────────────

/// The pinned primary, and the reason it cannot act when it cannot.
///
/// [LogActionButton] supplies the button; this supplies what the design system
/// requires around a *disabled* one and nothing existing carried. Three states:
///
/// * **Ready** — the label, live, with its ripple.
/// * **Working** — the label becomes [pendingLabel] and the handler goes null,
///   so the ripple dies. The ellipsis is the signal, not a spinner: a spinner
///   would be a seventh control and this one is a beat long.
/// * **Not yet** — the handler is null (no ripple, per the rule) *and* a reason
///   appears under it, led by `prohibit` (per the rule). Two non-colour signals
///   where one was required, because the pinned primary is the control the
///   whole screen is for.
///
/// [disabledReason] is not optional when [onPressed] is null and the button is
/// not pending. "Disabled" is not a reason and neither is silence.
class AuthSubmit extends StatelessWidget {
  const AuthSubmit({
    required this.label,
    required this.onPressed,
    this.disabledReason,
    this.pendingLabel,
    this.pending = false,
    super.key,
  });

  final String label;

  /// Null disables. There is no separate flag to disagree with it.
  final VoidCallback? onPressed;

  /// Shown under the button while [onPressed] is null and [pending] is false.
  final String? disabledReason;

  /// The label while [pending]. Defaults to [label] with an ellipsis.
  final String? pendingLabel;

  final bool pending;

  @override
  Widget build(BuildContext context) {
    final reason = disabledReason;
    final showReason = !pending && onPressed == null && reason != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LogActionButton(
          label: pending ? (pendingLabel ?? '$label…') : label,
          onPressed: pending ? null : onPressed,
        ),
        if (showReason) ...<Widget>[
          const SizedBox(height: FpSpace.s3),
          AuthUnavailableReason(reason),
        ],
      ],
    );
  }
}

/// A rate-limited "send it again".
///
/// The available state is a plain [LogTextAction] — brand label, an
/// `arrow-clockwise`, no fill. The cooling state does not grey that out: it
/// **removes it** and states the wait instead. Components § Disabled states is
/// explicit that a `GestureDetector` has no ripple to withhold and so must use
/// one of the other signals, and *"affordance removed, not recoloured"* is the
/// one that fits a link.
///
/// The countdown is spelled out through `FpFormat.countOf` rather than as a
/// bare "24s", because every string built from a number in this app comes from
/// `FpFormat` and because "1 seconds" is the failure that rule exists for.
class AuthResendControl extends StatefulWidget {
  const AuthResendControl({
    required this.label,
    required this.cooldownSeconds,
    required this.onResend,
    this.startCooling = false,
    super.key,
  });

  /// "Send it again", "Send another link".
  final String label;

  final int cooldownSeconds;

  /// Called when the control is used. It does not send anything; the screen
  /// decides what to say about that.
  final VoidCallback onResend;

  /// True starts the screen in the cooling state — the mail the screen is about
  /// has, notionally, just gone out.
  final bool startCooling;

  @override
  State<AuthResendControl> createState() => _AuthResendControlState();
}

class _AuthResendControlState extends State<AuthResendControl> {
  Timer? _tick;
  int _remaining = 0;

  @override
  void initState() {
    super.initState();
    if (widget.startCooling) _cool();
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _cool() {
    _tick?.cancel();
    setState(() => _remaining = widget.cooldownSeconds);
    _tick = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _remaining -= 1);
      if (_remaining <= 0) timer.cancel();
    });
  }

  void _resend() {
    widget.onResend();
    _cool();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining > 0) {
      return AuthUnavailableReason(
        'You can ask again in ${FpFormat.countOf(_remaining, 'second')}.',
      );
    }
    return LogTextAction(
      label: widget.label,
      icon: PhosphorIconsRegular.arrowClockwise,
      onTap: _resend,
    );
  }
}

// ─────────────────────────── odds and ends ───────────────────────────

/// The address a message went to, quoted back.
///
/// Mono, because the design reserves the mono face for identifiers and an email
/// address is the identifier on these screens. In a sunken well so it reads as
/// something the screen is telling you rather than something you can edit —
/// which matters here, because the field it came from is on the screen behind.
///
/// [SelectableText] rather than [Text]: the one thing a person does with an
/// address they suspect is wrong is read it character by character.
class AuthAddressWell extends StatelessWidget {
  const AuthAddressWell(this.address, {super.key});

  final String address;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.s4,
        vertical: FpSpace.s4,
      ),
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(FpRadius.md),
        border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PhosphorIcon(
            PhosphorIconsRegular.envelopeSimple,
            size: FpIconSize.md,
            color: c.textTertiary,
          ),
          const SizedBox(width: FpSpace.s3),
          Expanded(
            child: SelectableText(
              address,
              style: FpType.monoSm.copyWith(color: c.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// The footnote on a screen that talks about mail nobody sent.
///
/// Every one of these screens describes something happening off the device —
/// a message going out, an account being created, a session starting — and
/// none of it does. The project's existing answer to that is to say so on the
/// surface rather than in a comment (`ProductGlyph` "stays honest about being a
/// stand-in"; the support bubble on `WELCOME` says phase 1 has no Intercom
/// session), so this is the same move: a hairline, a mark, one sentence.
///
/// [demoLabel] and [onDemo] are the other half of the same honesty. The reset
/// and verification links exist only in mail nobody sent, so without an
/// affordance the two screens they lead to are unreachable except by typing a
/// URL. The action is labelled `(demo)`, sits under the footnote rather than in
/// the flow, and is the only control on these screens that is not part of the
/// product.
///
/// Keep that label short. [LogTextAction] lays its label out in a `Row` with no
/// `Flexible` around the `Text`, so a label wider than the content column
/// overflows rather than wrapping — "Simulate opening the link" overflowed by
/// 13px at 402pt, which is how this was found. That is a property of
/// `LogTextAction`, not of this widget, and it is not this file's to fix.
class AuthPhaseNote extends StatelessWidget {
  const AuthPhaseNote({
    required this.text,
    this.demoLabel,
    this.onDemo,
    super.key,
  });

  final String text;
  final String? demoLabel;
  final VoidCallback? onDemo;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final label = demoLabel;
    final action = onDemo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const LogHairline(),
        const SizedBox(height: FpSpace.s4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PhosphorIcon(
              PhosphorIconsRegular.flask,
              size: FpIconSize.sm,
              color: c.textTertiary,
            ),
            const SizedBox(width: FpSpace.s2),
            Expanded(
              child: Text(
                text,
                style: FpType.labelMd.copyWith(color: c.textTertiary),
              ),
            ),
          ],
        ),
        if (label != null && action != null)
          LogTextAction(label: label, onTap: action),
      ],
    );
  }
}

// ─────────────────────────── navigation helpers ───────────────────────────

/// A generated path with query parameters on it, encoded.
///
/// Arguments travel as query parameters on the generated path rather than as
/// `state.extra` — the README's rule, because `extra` survives a push and
/// evaporates on a deep link or a restore. An email address is the reason the
/// encoding matters here rather than string interpolation being enough: `+` is
/// a legal and common character in a local part, and unencoded it decodes back
/// as a space.
String authLocation(String path, Map<String, String> query) {
  final parts = query.entries
      .where((e) => e.value.isNotEmpty)
      .map((e) =>
          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
      .join('&');
  return parts.isEmpty ? path : '$path?$parts';
}

/// Go sideways: replace the current screen rather than stack on top of it.
///
/// Sign in and sign up are siblings, not a sequence. Pushing each onto the
/// other builds `welcome → sign in → sign up → sign in …` and leaves the back
/// gesture walking a history nobody meant to create. Replacing keeps the stack
/// two deep however many times the user changes their mind, and keeps *back*
/// meaning "out of auth entirely".
///
/// [GoRouter.pushReplacement] needs something under it to replace, so a screen
/// opened directly by deep link — where there is nothing below — goes through
/// `go` instead. The outcome is the same: one auth screen on the stack.
/// "Continue with Google" — the PRD's second sign-in method (Firebase Auth:
/// email/password and Google). One widget so `SIGN_IN` and `SIGN_UP` cannot
/// drift, with the "or" rule above it.
///
/// The glyph is Phosphor's `google-logo`, the app's one icon set, not Google's
/// official "G" asset. Google's branding guidelines want the official mark on
/// a real button; that swap belongs to the integration pass that wires the
/// sign-in itself, and it is a one-line change here.
class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({required this.onPressed, super.key});

  /// Null disables. Phase 1 passes a notice, not a sign-in.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(child: LogHairline()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FpSpace.s4),
              child: Text(
                'or',
                style: FpType.labelMd.copyWith(color: c.textTertiary),
              ),
            ),
            const Expanded(child: LogHairline()),
          ],
        ),
        const SizedBox(height: FpSpace.s5),
        ActionButton(
          label: 'CONTINUE WITH GOOGLE',
          tone: ButtonTone.secondary,
          icon: PhosphorIconsRegular.googleLogo,
          onPressed: onPressed,
        ),
      ],
    );
  }
}

void authSwap(BuildContext context, String location) {
  if (context.canPop()) {
    context.pushReplacement(location);
  } else {
    context.go(location);
  }
}

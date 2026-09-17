/// The pieces the six Settings-area screens need that fit nowhere else.
///
/// Two kits already cover most of a settings list: `lib/screens/hardware/
/// hardware_ui.dart` (`HardwareCard`, `SectionHeading`, `MetaLine`,
/// `ProductGlyph`, `showPhaseOneNotice`) and `lib/screens/log/log_controls.dart`
/// (`LogSection`, `LogHairline`, `LogSelectRow`, `LogCheckRow`,
/// `LogActionButton`, `LogActionBar`, `LogHeaderIconButton`, `LogEmptyState`,
/// `LogTextAction`, `showLogSheet`, `logConfirm`, `logSay`). Every screen in
/// this area imports from both rather than growing a third copy — the
/// coordinator flagged that `hardware_ui.dart` and `log_controls.dart` already
/// duplicate a Button chip and a section heading independently, and a settings
/// list is built almost entirely from rows, sections and sheets those two
/// files already solved.
///
/// What is here is the small remainder neither kit has a shape for:
///
/// * [SettingsChoiceTile] — an image-and-label tile in a grid. `SYSTEM_SELECTION`
///   is a picker between four hardware kinds, not a list of rows.
/// * [SettingsTextField] / [SettingsMultilineField] — single- and multi-line
///   text wells, in `HardwareTextField`'s visual language but built locally:
///   neither `hardware_ui.dart` nor `log_controls.dart` is this area's file to
///   extend, and `BUG_REPORT`'s "what happened" field needs several lines
///   where `LOGIN AS DIFFERENT USER`'s email needs one.
/// * [SettingsMediaPlaceholder] — the honest stand-in for a network-sourced
///   video surface. See `petcube_videos_screen.dart` for why this exists
///   instead of an embed.
///
/// Same contract as `HardwareCard` and `LogActionButton`: colour comes from
/// `context.fpColors` without exception, every measurement that has a token
/// uses the token, and warm-editorial stays warm-editorial — a hairline border
/// and type doing the work, not a pastel fill.
library;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../hardware/hardware_ui.dart' show ProductGlyph;

// ─────────────────────────── choice tiles ───────────────────────────

/// One tile in `SYSTEM_SELECTION`'s picker: an icon well over a label.
///
/// The RN screen (`ButtonTypesList.tsx`) shows product photography per tile —
/// a Connect Base, a Classic Base, a third-party remote. Phase 1 ships no
/// product photography (see `ProductGlyph` in `hardware_ui.dart`, imported for
/// the well itself); this only supplies the label and the tap target around
/// it. A fixed square rather than `Container(alignment:)` inside the grid's
/// `Wrap` — the components page's own warning about that combination applies
/// here as much as anywhere.
class SettingsChoiceTile extends StatelessWidget {
  const SettingsChoiceTile({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  static const double _side = 148.0;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: _side,
            height: _side,
            child: Container(
              decoration: BoxDecoration(
                color: c.surfaceRaised,
                borderRadius: BorderRadius.circular(FpRadius.lg),
                border: Border.all(
                  color: c.borderDefault,
                  width: FpStroke.hairline,
                ),
              ),
              padding: const EdgeInsets.all(FpSpace.s4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ProductGlyph(icon: icon),
                  const SizedBox(height: FpSpace.s4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: FpType.labelMd.copyWith(color: c.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

// ─────────────────────────── text input ───────────────────────────

/// The one multi-line field this area needs — `BUG_REPORT`'s "what happened".
///
/// Same well as `HardwareTextField` (hairline border, `border.focus` at
/// `FpStroke.thick` while focused), because a second visual language for one
/// extra field would read as a mistake rather than a choice. Not built by
/// extending `HardwareTextField` itself: it is `hardware`'s file to change and
/// this area does not edit it.
class SettingsMultilineField extends StatefulWidget {
  const SettingsMultilineField({
    required this.controller,
    this.hintText,
    this.onChanged,
    this.minLines = 5,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final int minLines;

  @override
  State<SettingsMultilineField> createState() =>
      _SettingsMultilineFieldState();
}

class _SettingsMultilineFieldState extends State<SettingsMultilineField> {
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.s4,
        vertical: FpSpace.s3,
      ),
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(FpRadius.md),
        border: Border.all(
          color: _focus.hasFocus ? c.borderFocus : c.borderDefault,
          width: _focus.hasFocus ? FpStroke.thick : FpStroke.hairline,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        onChanged: widget.onChanged,
        minLines: widget.minLines,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        cursorColor: c.textBrand,
        style: FpType.bodyMd.copyWith(color: c.textPrimary),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: FpType.bodyMd.copyWith(color: c.textTertiary),
        ),
      ),
    );
  }
}

/// The one single-line field this area needs — `LOGIN AS DIFFERENT USER`'s
/// email. Same well as [SettingsMultilineField] and `hardware`'s
/// `HardwareTextField`; built locally rather than by extending either, since
/// neither is this area's file to add to.
class SettingsTextField extends StatefulWidget {
  const SettingsTextField({
    required this.controller,
    this.hintText,
    this.onChanged,
    this.keyboardType,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  @override
  State<SettingsTextField> createState() => _SettingsTextFieldState();
}

class _SettingsTextFieldState extends State<SettingsTextField> {
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
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: FpSpace.s4),
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(FpRadius.md),
        border: Border.all(
          color: _focus.hasFocus ? c.borderFocus : c.borderDefault,
          width: _focus.hasFocus ? FpStroke.thick : FpStroke.hairline,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        autocorrect: false,
        style: FpType.bodyMd.copyWith(color: c.textPrimary),
        cursorColor: c.textBrand,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: FpType.bodyMd.copyWith(color: c.textTertiary),
        ),
      ),
    );
  }
}

// ─────────────────────────── media placeholder ───────────────────────────

/// The honest stand-in for a network-sourced video surface.
///
/// `PETCUBE_VIDEOS_SCREEN` is not a webview — the RN screen plays real camera
/// clips through `react-native-video`, streamed from PetCube's API for a time
/// window around one press (`PetCubeVideosScreen.tsx`). There is nothing in
/// this app to embed even honestly, because the surface itself does not exist
/// without a network call this phase forbids (PLAN.md). This draws the frame
/// the video would sit in — a 16:9 well matching the RN component's own
/// `ASPECT_RATIO` — and says plainly that the footage is absent, rather than
/// a grey box that could be mistaken for a loading spinner that will resolve.
class SettingsMediaPlaceholder extends StatelessWidget {
  const SettingsMediaPlaceholder({
    required this.message,
    this.icon = PhosphorIconsRegular.videoCamera,
    super.key,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: c.surfaceSunken,
          borderRadius: BorderRadius.circular(FpRadius.lg),
          border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
        ),
        padding: const EdgeInsets.all(FpSpace.s6),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PhosphorIcon(icon, size: FpIconSize.xl, color: c.textTertiary),
            const SizedBox(height: FpSpace.s3),
            Text(
              message,
              textAlign: TextAlign.center,
              style: FpType.bodySm.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

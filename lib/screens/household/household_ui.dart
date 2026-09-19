/// The pieces more than one Household screen needs, and that nothing at the
/// shared tier or in `hardware_ui.dart` / `log_controls.dart` already covers.
///
/// Per the coordinator's addendum: reuse first. `HardwareCard`,
/// `SectionHeading`, `FactRow`/`FactSlot` and `HardwareNotice` draw `HOUSEHOLD`'s
/// list; `HardwareTextField`, `HardwarePrimaryButton`/`HardwareActionBar`,
/// `showHardwareActions`/`HardwareAction` and
/// `confirmDestructive` (all from `hardware_ui.dart`), and `LogActionButton`,
/// `LogActionBar`, `LogHeaderIconButton`, `LogSection`, `LogCheckRow` (from
/// `log_controls.dart`) cover most of the two forms. `PusherAvatar` is used
/// verbatim from `lib/widgets/`. What is here is what none of those three files
/// has: a Learner/Teacher toggle, the photo-upload placeholder, a collapsible
/// "Advanced Settings" section, and a small multi-select sheet for Learner
/// Language, which `showHardwareActions` cannot do because it resolves on the
/// first tap.
///
/// Same rule as both files it borrows from: colour is always
/// `context.fpColors`, a measurement with a token uses the token, and anything
/// invented is named and cited in `household_metrics.dart`.
///
/// [HouseholdLearnerFields] and [HouseholdTeacherFields] are the one further
/// thing here: the type-specific half of the form, shared between
/// `HOUSEHOLD_ADD` and `HOUSEHOLD_EDIT` the same way `LearnerForm.tsx` and
/// `TeacherForm.tsx` are shared in the RN app. Controlled, not stateful — every
/// value and every callback comes from the screen that owns the form state, on
/// the same reasoning `LogSelectRow` and `HardwareTextField` are controlled.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../hardware/hardware_metrics.dart';
import '../hardware/hardware_ui.dart';
import '../log/log_controls.dart';
import 'household_metrics.dart';

// ─────────────────────────── the type toggle ───────────────────────────

/// `FormSelect.tsx`'s Learner/Teacher segmented control, on `HOUSEHOLD_ADD`
/// only — `HOUSEHOLD_EDIT` fixes the type from the loaded Pusher and draws no
/// control to change it (`HouseholdEdit.tsx` has no `FormSelect` at all).
///
/// The RN control is a pill with the two options absolutely positioned over a
/// third, full-width, colourless "spacer" button — a layout trick this design
/// does not need. Two equal, tappable halves inside one hairline-bordered
/// container is the same choice with none of the trick, and it is a weight/fill
/// change on the selected half rather than a third hue, on the same rule the
/// Pusher avatar and the Button chip already state.
class HouseholdTypeToggle extends StatelessWidget {
  const HouseholdTypeToggle({
    required this.isLearner,
    required this.onChanged,
    super.key,
  });

  /// True selects Learner, false selects Teacher. A `bool` rather than
  /// [PusherKind] because the pseudo-Pusher kinds have no place on this
  /// control — nobody adds a journal entry or an unattributed press here.
  final bool isLearner;

  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      height: HardwareMetrics.touchTarget,
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(FpRadius.md),
        border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
      ),
      padding: const EdgeInsets.all(FpSpace.s1),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _Segment(
              label: 'Learner',
              selected: isLearner,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _Segment(
              label: 'Teacher',
              selected: !isLearner,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: Material(
          type: selected ? MaterialType.canvas : MaterialType.transparency,
          color: selected ? c.actionPrimaryBg : null,
          borderRadius: BorderRadius.circular(FpRadius.sm),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(FpRadius.sm),
            child: Center(
              child: Text(
                label,
                style: FpType.labelLg.copyWith(
                  color: selected ? c.actionPrimaryFg : c.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── the photo placeholder ───────────────────────────

/// Stands in for `openAvatarPicker` — the device photo library.
///
/// PLAN.md forbids a real permission prompt in phase 1, on the same rule
/// `hardware_providers.dart` states for Base setup's camera/location checks.
/// Rather than open nothing and look broken, the circle is real, tappable, and
/// honest about what it does: [onTap] is wired to a notice by the
/// caller, the same widget every other phase-1 write on these screens already
/// uses.
///
/// A dashed hairline rather than a solid one, because a dashed border is the
/// one visual vocabulary this design system reserves for "drop something
/// here" — nothing else on these three screens draws one, so it cannot be
/// mistaken for a card or a field.
class HouseholdAvatarPicker extends StatelessWidget {
  const HouseholdAvatarPicker({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Semantics(
      button: true,
      label: 'Add a photo',
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: HouseholdMetrics.avatarPicker,
                height: HouseholdMetrics.avatarPicker,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: c.surfaceSunken,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DashedCirclePainter(color: c.borderStrong),
                      ),
                    ),
                    PhosphorIcon(
                      PhosphorIconsRegular.userCirclePlus,
                      size: FpIconSize.xl,
                      color: c.textTertiary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: FpSpace.s2),
              Text(
                'Add Photo',
                style: FpType.labelMd.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The dashed ring on [HouseholdAvatarPicker]. A solid `Border` cannot draw a
/// dash, and this is the one place on these three screens that needs one, so
/// it is a two-line `CustomPainter` rather than a package dependency.
class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});

  final Color color;

  static const double _dashLength = 4;
  static const double _gapLength = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (_dashLength + _gapLength)).floor();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = FpStroke.hairline;
    final sweep = (_dashLength / circumference) * 2 * math.pi;
    final gap = (_gapLength / circumference) * 2 * math.pi;
    var angle = 0.0;
    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 1),
        angle,
        sweep,
        false,
        paint,
      );
      angle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}

// ─────────────────────────── the Advanced disclosure ───────────────────────────

/// `SectionToggle`'s "Show Advanced Settings" / "Hide Advanced Settings",
/// reproduced. Both Learner forms use it to hide Breed, Research Participant
/// ID, Language and Birth Date behind one line — fields that describe the
/// pet in more depth than the two headline fields need to compete with.
class HouseholdDisclosure extends StatefulWidget {
  const HouseholdDisclosure({required this.child, super.key});

  final Widget child;

  @override
  State<HouseholdDisclosure> createState() => _HouseholdDisclosureState();
}

class _HouseholdDisclosureState extends State<HouseholdDisclosure> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Semantics(
          button: true,
          expanded: _expanded,
          label: _expanded
              ? 'Hide Advanced Settings'
              : 'Show Advanced Settings',
          child: ExcludeSemantics(
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              behavior: HitTestBehavior.opaque,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: HardwareMetrics.touchTarget,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _expanded
                          ? 'Hide Advanced Settings'
                          : 'Show Advanced Settings',
                      style: FpType.labelLg.copyWith(color: c.textBrand),
                    ),
                    const SizedBox(width: FpSpace.s2),
                    PhosphorIcon(
                      _expanded
                          ? PhosphorIconsRegular.caretUp
                          : PhosphorIconsRegular.caretDown,
                      size: FpIconSize.sm,
                      color: c.textBrand,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_expanded) ...<Widget>[
          const SizedBox(height: FpSpace.s3),
          widget.child,
        ],
      ],
    );
  }
}

// ─────────────────────────── info notes ───────────────────────────

/// A quiet explanatory line under a control — `TeacherForm.tsx`'s
/// `info-circle` captions, reproduced verbatim: *"When invitation email is
/// sent…"* and *"You can manage Household invitations through…"*.
class HouseholdInfoNote extends StatelessWidget {
  const HouseholdInfoNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PhosphorIcon(
          PhosphorIconsRegular.info,
          size: FpIconSize.sm,
          color: c.textTertiary,
        ),
        const SizedBox(width: FpSpace.s2),
        Expanded(
          child: Text(
            text,
            style: FpType.bodySm.copyWith(color: c.textTertiary),
          ),
        ),
      ],
    );
  }
}

/// The label above a [HardwareTextField] — `<Label>` in the RN forms.
/// `HardwareTextField` draws no label of its own (`BASE_EDIT`'s three fields
/// each pair it with a private `_FieldLabel`); this is the same pairing, made
/// reusable because `HOUSEHOLD_ADD` and `HOUSEHOLD_EDIT` both need it for the
/// Name field and `_FieldLabel` is private to `base_edit_screen.dart`.
class HouseholdFieldLabel extends StatelessWidget {
  const HouseholdFieldLabel({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Text(label, style: FpType.headingSm.copyWith(color: c.textPrimary));
  }
}

/// The error line a picker row needs but does not have built in.
/// [HardwareTextField] draws its own; [LogSelectRow] (Species, Country, the
/// two dates) does not, so this is the same treatment applied beside it.
class HouseholdFieldError extends StatelessWidget {
  const HouseholdFieldError({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.only(top: FpSpace.s2),
      child: Row(
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
      ),
    );
  }
}

// ─────────────────────────── multi-select sheet ───────────────────────────

/// The Learner Language picker: several values at once, joined with commas on
/// the wire (`onSelectedLanguageChange`, `LearnerForm.tsx:83-85`).
///
/// [showHardwareActions] cannot do this — it pops the sheet on the first tap,
/// which is right for Species and Country and wrong here. This keeps the
/// selection open across taps and returns it on "Done", using the same
/// checklist row (`LogCheckRow`) the Contexts and Learners sheets already use
/// on `LOG_DETAILS`.
Future<Set<String>?> showHouseholdMultiSelect(
  BuildContext context, {
  required String title,
  required List<String> options,
  required Set<String> selected,
}) {
  // Colour comes from `bottomSheetTheme`, never from an argument here — see
  // the note on `showHardwareActions`.
  return showModalBottomSheet<Set<String>>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    // Scroll-controlled sheets may grow past half the viewport; without this
    // a long list runs under the status bar.
    useSafeArea: true,
    builder: (sheetContext) {
      var chosen = Set<String>.of(selected);
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
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
                  child: Text(
                    title,
                    style: FpType.headingSm.copyWith(color: sc.textPrimary),
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      for (final option in options)
                        LogCheckRow(
                          label: option,
                          selected: chosen.contains(option),
                          onTap: () => setSheetState(() {
                            if (!chosen.remove(option)) chosen.add(option);
                          }),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FpSpace.s6,
                    FpSpace.s4,
                    FpSpace.s6,
                    FpSpace.s4,
                  ),
                  child: LogActionButton(
                    label: 'DONE',
                    onPressed: () => Navigator.of(sheetContext).pop(chosen),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// ─────────────────────────── picker value text ───────────────────────────

/// The value half of a [LogSelectRow]: placeholder tone when nothing is
/// chosen, primary tone once something is.
class _PickerValue extends StatelessWidget {
  const _PickerValue(this.text, {required this.filled});

  final String text;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Text(
      text,
      style: FpType.bodyMd.copyWith(
        color: filled ? c.textPrimary : c.textTertiary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ─────────────────────────── type-specific fields ───────────────────────────

/// `LearnerForm.tsx`, reproduced field for field: Species and Teaching Start
/// Date up front, then Breed, Learner Language and Learner Birth Date behind
/// [HouseholdDisclosure]. The RN form's Research Participant ID is gone —
/// research surveys are a PRD non-goal and `pushers` has no column for it.
///
/// The RN form sets Species and Teaching Start Date side by side in a two-column
/// row (`LearnerForm.tsx:113-161`). Stacked full-width here instead: a species
/// name and a formatted date both have to survive at 402pt without truncating,
/// and a fixed two-column split is the layout most likely to clip one of them
/// on a long species name — the very failure `Container(alignment:)` inside a
/// `Wrap` produces for a different reason elsewhere in this pass.
class HouseholdLearnerFields extends StatelessWidget {
  const HouseholdLearnerFields({
    required this.species,
    required this.onSpeciesTap,
    required this.trainingStartDate,
    required this.onTrainingStartDateTap,
    required this.breed,
    required this.languages,
    required this.onLanguagesTap,
    required this.birthDate,
    required this.onBirthDateTap,
    this.speciesError,
    this.now,
    super.key,
  });

  final String? species;
  final String? speciesError;
  final VoidCallback onSpeciesTap;

  final DateTime? trainingStartDate;
  final VoidCallback onTrainingStartDateTap;

  /// "Kind of {species}" in the RN placeholder — `subType` on the wire.
  final TextEditingController breed;

  final Set<String> languages;
  final VoidCallback onLanguagesTap;

  final DateTime? birthDate;
  final VoidCallback onBirthDateTap;

  /// For the date rows' conditional year — see [FpFormat.dayAndMonth]. Null is
  /// fine; it only means every date shows its year.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final chosenSpecies = species;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LogSelectRow(
          label: 'Species',
          onTap: onSpeciesTap,
          child: _PickerValue(
            chosenSpecies ?? 'Species',
            filled: chosenSpecies != null,
          ),
        ),
        if (speciesError != null) HouseholdFieldError(message: speciesError!),
        const SizedBox(height: FpSpace.s4),
        LogSelectRow(
          label: 'Teaching Start Date',
          icon: PhosphorIconsRegular.calendarBlank,
          onTap: onTrainingStartDateTap,
          child: _PickerValue(
            trainingStartDate == null
                ? 'Date'
                : FpFormat.dayAndMonth(trainingStartDate!, asOf: now),
            filled: trainingStartDate != null,
          ),
        ),
        const SizedBox(height: FpSpace.s4),
        HouseholdDisclosure(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HardwareTextField(
                controller: breed,
                hintText: (chosenSpecies == null || chosenSpecies.isEmpty)
                    ? 'Breed'
                    : 'Kind of $chosenSpecies',
              ),
              const SizedBox(height: FpSpace.s4),
              LogSelectRow(
                label: 'Learner Language',
                onTap: onLanguagesTap,
                child: _PickerValue(
                  languages.isEmpty ? 'Language' : languages.join(', '),
                  filled: languages.isNotEmpty,
                ),
              ),
              const SizedBox(height: FpSpace.s4),
              LogSelectRow(
                label: 'Learner Birth Date',
                icon: PhosphorIconsRegular.calendarBlank,
                onTap: onBirthDateTap,
                child: _PickerValue(
                  birthDate == null
                      ? 'Birth Date'
                      : FpFormat.dayAndMonth(birthDate!, asOf: now),
                  filled: birthDate != null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// `TeacherForm.tsx`'s Country. Its Email field and the invitation checkbox
/// beside it are gone: a Teacher is a Pusher, and in the PRD a Pusher has no
/// email — inviting a person to the Household is `HOUSEHOLD_MEMBERS`'s job,
/// and the two were only ever coupled because the RN app created a Teacher
/// and an invitation from one form.
class HouseholdTeacherFields extends StatelessWidget {
  const HouseholdTeacherFields({
    required this.country,
    required this.onCountryTap,
    super.key,
  });

  final String? country;
  final VoidCallback onCountryTap;

  @override
  Widget build(BuildContext context) {
    return LogSelectRow(
      label: 'Country',
      onTap: onCountryTap,
      child: _PickerValue(country ?? 'Country', filled: country != null),
    );
  }
}

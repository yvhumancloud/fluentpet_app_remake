/// `HOUSEHOLD_ADD` — add a Learner or a Teacher to the Household.
///
/// A modal, per `screens.g.dart` (`presentation: FpPresentation.modal`,
/// `navigator: 'MODAL'`) — **not** a pushed screen. The coordinator's brief
/// said the two Household forms get the pushed-screen back chevron; the
/// generated screen map disagrees, and `LOG` (`screens.g.dart`'s other modal
/// with a form on it) already settles how a modal closes here: [ScreenHeader]
/// with an `X` in [LogHeaderIconButton.trailing], no [ScreenHeader.onBack]. The
/// source wins; this screen and `HOUSEHOLD_EDIT` both follow `LOG`'s pattern
/// instead of growing a chevron a modal should not have.
///
/// SAVE validates, `POST /pushers`, refetches the roster and pops back to it.
///
/// ## What is kept from `HouseholdAdd.tsx`
///
/// The Learner/Teacher toggle, the photo placeholder, the Name field, the
/// Learner fields (Species, Teaching Start Date, then Breed, Language and
/// Birth Date behind Advanced Settings), the Teacher's Country, and the exact
/// validation rules and messages. Research Participant ID, Email and the
/// invitation checkbox are gone: the PRD's `pushers` has no such columns, and
/// inviting a person is `HOUSEHOLD_MEMBERS`'s job.
///
/// ## What changed, and why
///
/// * **The in-body "Let's add a Member to your Household" heading is
///   dropped.** `ScreenHeader`'s own title already says this (see below); the
///   RN screen's nav header carries no title at all
///   (`ScreenTitle` for `HOUSEHOLD_ADD` is `'ADD MEMBER'` only for deep-link
///   chrome), so the in-body heading was doing the job a title bar does here.
///   Two headings stacked would repeat the screen's own name to itself.
/// * **The title tracks the toggle**: "Add a Learner" / "Add a Teacher"
///   rather than the generic "Add a Member", so the header always describes
///   what SAVE is about to create.
/// * **The `addPusherGuide` deep-link argument is dropped** along with the
///   on-mount nudge that supplied it (see `household_screen.dart`) — nothing
///   in this build ever passes one, and the toggle a guide would have
///   disabled is otherwise always both options.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../hardware/hardware_ui.dart';
import '../log/log_controls.dart';
import 'household_metrics.dart';
import 'household_options.dart';
import 'household_ui.dart';

class HouseholdAddScreen extends ConsumerStatefulWidget {
  const HouseholdAddScreen({super.key});

  @override
  ConsumerState<HouseholdAddScreen> createState() => _HouseholdAddScreenState();
}

class _HouseholdAddScreenState extends ConsumerState<HouseholdAddScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _breed = TextEditingController();

  bool _isLearner = true;
  String? _species = 'Dog'; // HouseholdAdd.tsx:84-92 defaults to Dog.
  DateTime? _trainingStartDate;
  DateTime? _birthDate;
  final Set<String> _languages = <String>{};
  String? _country;

  bool _submitted = false;
  String? _nameError;
  String? _speciesError;

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final now = ref.watch(nowProvider);
    // Loaded here so the Species picker has its options when it opens.
    ref.watch(learnerTypesProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: _isLearner ? 'Add a Learner' : 'Add a Teacher',
              trailing: LogHeaderIconButton(
                icon: PhosphorIconsRegular.x,
                semanticLabel: 'Close',
                onTap: () => context.pop(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  FpSpace.s6,
                  FpSpace.s2,
                  FpSpace.s6,
                  FpSpace.s8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    HouseholdTypeToggle(
                      isLearner: _isLearner,
                      onChanged: (value) => setState(() => _isLearner = value),
                    ),
                    const SizedBox(height: FpSpace.s6),
                    Center(
                      child: HouseholdAvatarPicker(
                        // ponytail: no image_picker yet — `PUT /pushers/{id}/avatar`
                        // waits on it.
                        onTap: () =>
                            logSay(context, 'Photos arrive in a later build.'),
                      ),
                    ),
                    const SizedBox(height: FpSpace.s6),
                    HouseholdFieldLabel(
                      label: _isLearner ? 'Learner Name' : 'Teacher Name',
                    ),
                    const SizedBox(height: FpSpace.s3),
                    HardwareTextField(
                      controller: _name,
                      hintText: _isLearner ? 'Learner Name' : 'Teacher Name',
                      maxLength: HouseholdMetrics.nameMaxLength,
                      errorText: _nameError,
                      onChanged: (_) {
                        if (_submitted) setState(_validate);
                      },
                    ),
                    const SizedBox(height: FpSpace.s5),
                    if (_isLearner)
                      HouseholdLearnerFields(
                        species: _species,
                        speciesError: _speciesError,
                        onSpeciesTap: _pickSpecies,
                        trainingStartDate: _trainingStartDate,
                        onTrainingStartDateTap: () =>
                            _pickDate(isBirthDate: false),
                        breed: _breed,
                        languages: _languages,
                        onLanguagesTap: _pickLanguages,
                        birthDate: _birthDate,
                        onBirthDateTap: () => _pickDate(isBirthDate: true),
                        now: now,
                      )
                    else ...<Widget>[
                      HouseholdTeacherFields(
                        country: _country,
                        onCountryTap: _pickCountry,
                      ),
                      const SizedBox(height: FpSpace.s2),
                      const HouseholdInfoNote(
                        text:
                            'A Teacher is someone whose presses get logged. '
                            'To give a person their own sign-in to this '
                            'Household, invite them from Household members.',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            LogActionBar(
              children: <Widget>[
                LogActionButton(
                  label: _isLearner ? 'SAVE NEW LEARNER' : 'SAVE NEW TEACHER',
                  onPressed: _save,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// `validate()` in both RN screens, reproduced with its exact messages.
  bool _validate() {
    _nameError = _name.text.trim().isEmpty ? 'You must enter a Name' : null;

    _speciesError = _isLearner && (_species == null || _species!.isEmpty)
        ? 'You must select a Species'
        : null;

    return _nameError == null && _speciesError == null;
  }

  Future<void> _save() async {
    setState(() {
      _submitted = true;
      _validate();
    });
    if (_nameError != null || _speciesError != null) return;
    final ok = await logWrite(
      context,
      () => ref.read(householdRepositoryProvider).createPusher(_pusher()),
    );
    if (!ok || !mounted) return;
    ref.invalidate(pushersProvider);
    if (context.canPop()) context.pop();
  }

  /// The form as a [Pusher]. Species is picked by name and sent by id.
  Pusher _pusher() {
    final types = ref.read(learnerTypesProvider).value ?? const <int, String>{};
    final breed = _breed.text.trim();
    return Pusher(
      id: 0,
      name: _name.text.trim(),
      isHuman: !_isLearner,
      learnerTypeId: _isLearner ? learnerTypeId(types, _species) : null,
      subType: _isLearner && breed.isNotEmpty ? breed : null,
      trainingStartedAt: _isLearner ? _trainingStartDate : null,
      birthDate: _isLearner ? _birthDate : null,
      language: _isLearner && _languages.isNotEmpty
          ? _languages.join(', ')
          : null,
      country: _isLearner ? null : _country,
    );
  }

  Future<void> _pickSpecies() async {
    final choice = await showHardwareActions<String>(
      context: context,
      title: 'Species',
      options: <HardwareAction<String>>[
        for (final option in householdSpeciesOptions(ref))
          HardwareAction<String>(
            label: option,
            value: option,
            selected: option == _species,
          ),
      ],
    );
    if (choice == null || !mounted) return;
    setState(() {
      _species = choice;
      if (_submitted) _validate();
    });
  }

  Future<void> _pickCountry() async {
    final choice = await showHardwareActions<String>(
      context: context,
      title: 'Country',
      options: <HardwareAction<String>>[
        for (final option in householdCountryOptions)
          HardwareAction<String>(
            label: option,
            value: option,
            selected: option == _country,
          ),
      ],
    );
    if (choice == null || !mounted) return;
    setState(() => _country = choice);
  }

  Future<void> _pickLanguages() async {
    final choice = await showHouseholdMultiSelect(
      context,
      title: 'Learner Language',
      options: householdLanguageOptions,
      selected: _languages,
    );
    if (choice == null || !mounted) return;
    setState(() {
      _languages
        ..clear()
        ..addAll(choice);
    });
  }

  Future<void> _pickDate({required bool isBirthDate}) async {
    final now = DateTime.now();
    final current = isBirthDate ? _birthDate : _trainingStartDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(now.year - _yearsBack),
      // Both RN pickers cap at today (`maximumDate={today}`): nobody's
      // training start or birth date is in the future.
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isBirthDate) {
        _birthDate = picked;
      } else {
        _trainingStartDate = picked;
      }
    });
  }
}

/// How far back the birth-date and training-date pickers open. Neither RN
/// picker states a minimum (`DateTimePickerModal` defaults to its own), so
/// this is invented on the same reasoning `LOG_DETAILS`'s own date picker
/// gives for its bound: old enough for a Learner's whole life, young enough
/// that the picker does not open on a wheel of centuries nobody will use.
const int _yearsBack = 30;

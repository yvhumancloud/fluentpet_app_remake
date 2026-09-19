/// `HOUSEHOLD_EDIT` — edit an existing Learner or Teacher.
///
/// A modal (`screens.g.dart`: `presentation: FpPresentation.modal`), reached
/// from `HOUSEHOLD`'s row tap and its long-press "Edit" — see
/// `household_add_screen.dart`'s header note for why this draws an `X` close
/// rather than the back chevron the coordinator's brief described.
///
/// ## The argument, and the honest not-found state
///
/// `household_routes.dart` carries the Pusher id as `?id=`, matching the RN
/// route param name (`Household.tsx:135`, `:145`: `{ id: pusher.id }`). A
/// missing or unresolvable id is not an error — it resolves to a named state
/// with a way back and, on the same rule `BASE_EDIT` states for its own three
/// states, **no SAVE bar**: a control offering to write a form nobody can see,
/// over a record that may not exist, is the exact data-loss affordance
/// `base_edit_screen.dart` was written to correct, and reproducing it here
/// would undo that correction for the one other screen in this pass shaped
/// the same way.
///
/// ## What phase 1's domain cannot prefill, and why that is not silently
/// dropped
///
/// [Pusher] (`lib/domain/pusher.dart`) carries `name`, `isHuman`,
/// `learnerType` and `trainingStartedAt` — nothing else the RN form edits.
/// Birth date, breed, Language and Country have no field to read them from,
/// because `HouseholdRepository` returns domain types only and none of those
/// four is one (`lib/data/repositories.dart`'s own rule: *"No screen ever sees
/// a fixture, a JSON map…"*). Every one of those four fields is still on this
/// screen, still fully editable, still validated where the RN form validates
/// it — they simply open **empty** rather than pre-filled, which is an honest
/// "this build does not have that on record" rather than a silently dropped
/// capability.
///
/// The RN form's Email field, Research Participant ID and three-way
/// member/invited/not-invited line are gone rather than empty: the PRD's
/// `pushers` has no email and no research id, and Household membership is
/// `HOUSEHOLD_MEMBERS`'s job now, which the note under the Teacher fields
/// points to.
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

class HouseholdEditScreen extends ConsumerStatefulWidget {
  const HouseholdEditScreen({required this.pusherId, super.key});

  /// Null when `?id=` was absent or not a number — the deep link a stale
  /// bookmark or a hand-typed link produces. Resolves to the not-found state
  /// exactly like an id that does not match any Pusher.
  final int? pusherId;

  @override
  ConsumerState<HouseholdEditScreen> createState() =>
      _HouseholdEditScreenState();
}

class _HouseholdEditScreenState extends ConsumerState<HouseholdEditScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _breed = TextEditingController();

  bool _isLearner = true;
  String? _species;
  DateTime? _trainingStartDate;
  DateTime? _birthDate;
  final Set<String> _languages = <String>{};
  String? _country;

  /// The id the fields were filled from, so a provider rebuild does not
  /// overwrite what someone is typing — the same guard
  /// `_BaseEditScreenState._loadedFor` uses.
  int? _loadedFor;

  bool _dirty = false;
  bool _submitted = false;
  String? _nameError;
  String? _speciesError;

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    super.dispose();
  }

  void _loadFrom(Pusher pusher) {
    if (_loadedFor == pusher.id) return;
    _loadedFor = pusher.id;
    _name.text = pusher.name;
    _isLearner = pusher.isLearner;
    _species = pusher.learnerType;
    _trainingStartDate = pusher.trainingStartedAt;
    _birthDate = pusher.birthDate;
    _breed.text = pusher.subType ?? '';
    _languages
      ..clear()
      ..addAll(
        (pusher.language ?? '')
            .split(',')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty),
      );
    _country = pusher.country;
    _dirty = false;
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final id = widget.pusherId;
    final pushers = ref.watch(pushersProvider);

    if (id == null) {
      return _notFound(
        context,
        c,
        title: 'This link is missing a Member',
        body:
            'There is no Household Member id on this link, so there is '
            'nothing here to edit.',
      );
    }

    return switch (pushers) {
      AsyncData<List<Pusher>>(:final value) => () {
        final pusher = _find(value, id);
        if (pusher == null) {
          return _notFound(
            context,
            c,
            title: 'That Member is not here any more',
            body:
                'This Household does not have a Member with that id. '
                'They may have been removed, or the link that brought you '
                'here may be out of date.',
          );
        }
        _loadFrom(pusher);
        return _loaded(context, c, pusher);
      }(),
      AsyncError<List<Pusher>>() => _notFound(
        context,
        c,
        title: 'Could not load this Member',
        body: 'Go back to Household and pull down to try again.',
        danger: true,
      ),
      _ => Scaffold(
        backgroundColor: c.surfaceCanvas,
        body: FpOsChrome(
          bottom: true,
          child: Column(
            children: <Widget>[
              ScreenHeader(
                title: 'Edit Member',
                trailing: LogHeaderIconButton(
                  icon: PhosphorIconsRegular.x,
                  semanticLabel: 'Close',
                  onTap: () => context.pop(),
                ),
              ),
              const Expanded(child: HardwareLoading()),
            ],
          ),
        ),
      ),
    };
  }

  static Pusher? _find(List<Pusher> pushers, int id) {
    for (final pusher in pushers) {
      if (pusher.id == id) return pusher;
    }
    return null;
  }

  /// Loading, not-found and failed all share this: a way to close, and **no
  /// SAVE bar** — see the header note.
  Widget _notFound(
    BuildContext context,
    FpColors c, {
    required String title,
    required String body,
    bool danger = false,
  }) {
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Edit Member',
              trailing: LogHeaderIconButton(
                icon: PhosphorIconsRegular.x,
                semanticLabel: 'Close',
                onTap: () => context.pop(),
              ),
            ),
            Expanded(
              child: HardwareNotice(
                icon: danger
                    ? PhosphorIconsRegular.warningOctagon
                    : PhosphorIconsRegular.magnifyingGlass,
                title: title,
                body: body,
                tone: danger
                    ? HardwareNoticeTone.danger
                    : HardwareNoticeTone.neutral,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loaded(BuildContext context, FpColors c, Pusher pusher) {
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
              title: _isLearner ? 'Edit Learner' : 'Edit Teacher',
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
                    // No `HouseholdTypeToggle` — `HouseholdEdit.tsx` fixes the
                    // type from the loaded Pusher and draws no control to
                    // change it.
                    Center(
                      child: HouseholdAvatarPicker(
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
                        _markDirty();
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
                            'People with their own sign-in are managed '
                            'under Household members.',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            LogActionBar(
              children: <Widget>[
                LogActionButton(
                  label: 'SAVE ${_isLearner ? 'LEARNER' : 'TEACHER'}',
                  onPressed: _dirty ? _save : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
    final id = _loadedFor;
    if (id == null) return;
    final types = ref.read(learnerTypesProvider).value ?? const <int, String>{};
    final breed = _breed.text.trim();
    final edited = Pusher(
      id: id,
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
    final ok = await logWrite(
      context,
      () => ref.read(householdRepositoryProvider).updatePusher(edited),
    );
    if (!ok || !mounted) return;
    ref.invalidate(pushersProvider);
    setState(() => _dirty = false);
    if (context.canPop()) context.pop();
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
    _markDirty();
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
    _markDirty();
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
    _markDirty();
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
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    _markDirty();
    setState(() {
      if (isBirthDate) {
        _birthDate = picked;
      } else {
        _trainingStartDate = picked;
      }
    });
  }
}

/// See `household_add_screen.dart`'s constant of the same name and reasoning.
const int _yearsBack = 30;

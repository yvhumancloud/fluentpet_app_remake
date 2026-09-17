/// `BUTTON_EDIT` — edit one Button, Classic or Connect.
///
/// `src/Home/ButtonEdit/ButtonEdit.tsx`. Reached with `buttonId` (and,
/// sometimes, `batteryLevel`) from `CLASSIC_BUTTONS`'s action sheet,
/// `BASE_EDIT`'s Linked Buttons action sheet — both of which call
/// `${FpScreen.buttonEdit.path}?buttonId=…&batteryLevel=…` — and
/// `BUTTON_CONVERSION` after a merge.
///
/// ## What differs by kind
///
/// Classic and Connect share Word, Meaning, Date, the disabled Type fact and
/// the note. Connect adds two things Classic never has: the Sound section
/// (`ButtonAudio.tsx`, honest phase-1 stand-in in [ButtonAudioSection]) and
/// two more disabled facts — Button ID and Base — read by joining the
/// watched Base list against [Button.serialNumber]
/// ([buttons_fixture.dart]'s [baseForButton], the same join
/// `linkedButtonsProvider` performs from the other side).
///
/// ## What phase 1 does not attempt
///
/// The RN screen's `onError` branch — a 404 with `duplicate_button_id`
/// triggers a merge-instead-of-rename prompt (`ButtonEdit.tsx:209-219`) — is a
/// real network error path with nothing to trigger it here (PLAN.md: no
/// network). UPDATE BUTTON always succeeds, as a phase-1 no-op, the same
/// `showPhaseOneNotice` pattern `hardware_ui.dart` uses under a different
/// name ([logSay], reused from `log_controls.dart` per the coordinator's
/// addendum).
///
/// The RN screen's hand-off to `DOWNLOAD_SOUND` after attaching a sound
/// (`ButtonEdit.tsx:190-207`) is gone with that screen: the PRD's device
/// script pulls desired audio from `GET /device/desired` on its own schedule,
/// so there is nothing for the app to wait on. A save just saves.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../log/log_controls.dart';
import 'buttons_fixture.dart';
import 'buttons_ui.dart';

class ButtonEditScreen extends ConsumerStatefulWidget {
  const ButtonEditScreen({
    required this.buttonId,
    required this.batteryLevel,
    super.key,
  });

  /// From the query string. Null (unparseable or absent) renders the
  /// not-found state rather than a live form with nothing to save — the same
  /// call `hardware_routes.dart` makes for `BASE_EDIT` with no serial.
  final int? buttonId;

  final int? batteryLevel;

  @override
  ConsumerState<ButtonEditScreen> createState() => _ButtonEditScreenState();
}

class _ButtonEditScreenState extends ConsumerState<ButtonEditScreen> {
  final TextEditingController _word = TextEditingController();
  final TextEditingController _webhook = TextEditingController();
  final TextEditingController _note = TextEditingController();

  String? _meaning;
  DateTime _introducedAt = DateTime.now();
  bool _dirty = false;
  bool _submitting = false;
  bool _initialised = false;

  /// Local mirror of `newSoundUri`: true means "a sound was attached or
  /// replaced this session", which is enough on its own to enable the save.
  bool _soundChanged = false;
  bool _hasSound = false;

  @override
  void dispose() {
    _word.dispose();
    _webhook.dispose();
    _note.dispose();
    super.dispose();
  }

  void _seed(Button button) {
    if (_initialised) return;
    _initialised = true;
    _word.text = button.text;
    _webhook.text = '';
    _note.text = button.note;
    _introducedAt = button.introducedAt ?? DateTime.now();
    _meaning = buttonMeaningById[button.id];
    _hasSound = buttonSounds.containsKey(button.id);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final boardId = widget.buttonId;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            buttonsModalHeader(
              title: FpScreen.buttonEdit.title ?? 'Edit Button',
              onClose: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child:
                  boardId == null ? const _NotFound() : _buildBody(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final board = ref.watch(boardProvider);
    final bases = ref.watch(basesProvider);
    return switch (board) {
      AsyncData<Board>(:final value) =>
        _buildForm(context, value, bases.value ?? const <Base>[]),
      AsyncError<Board>() =>
        const _NotFound(message: 'Could not load this Button.'),
      _ => const _Loading(),
    };
  }

  Widget _buildForm(BuildContext context, Board board, List<Base> bases) {
    final button = findButton(board.buttons, widget.buttonId);
    if (button == null) {
      return const _NotFound();
    }
    _seed(button);

    final c = context.fpColors;
    final isConnect = button.kind == ButtonKind.connect;
    final base = isConnect ? baseForButton(bases, button) : null;
    final sound = buttonSounds[button.id];

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              FpSpace.s6,
              FpSpace.s6,
              FpSpace.s6,
              FpSpace.s8,
            ),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      button.text,
                      textAlign: TextAlign.center,
                      style: FpType.displaySm.copyWith(color: c.textPrimary),
                    ),
                  ),
                  if (widget.batteryLevel != null) ...<Widget>[
                    const SizedBox(width: FpSpace.s3),
                    ButtonBatteryDot(percent: widget.batteryLevel),
                  ],
                ],
              ),
              const SizedBox(height: FpSpace.s4),
              const LogHairline(),
              const SizedBox(height: FpSpace.s6),
              LogSection(
                title: 'Word',
                child: ButtonTextField(
                  controller: _word,
                  hintText: 'Button Name',
                  onChanged: (_) => setState(() => _dirty = true),
                ),
              ),
              if (isConnect) ...<Widget>[
                const SizedBox(height: FpSpace.s5),
                ButtonAudioSection(
                  hasSound: _hasSound,
                  label: sound?.label ?? 'Custom sound',
                  onDelete: () => setState(() {
                    _hasSound = false;
                    _soundChanged = true;
                  }),
                ),
                if (!_hasSound)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setState(() {
                        _hasSound = true;
                        _soundChanged = true;
                      }),
                      child: Text(
                        'Simulate a recording',
                        style: FpType.labelMd.copyWith(color: c.textBrand),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: FpSpace.s5),
              ButtonsExpander(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LogSelectRow(
                      label: 'Meaning',
                      onTap: () => _pickMeaning(context),
                      child: Text(
                        _meaning ?? 'Button Meaning',
                        style: FpType.bodyMd.copyWith(
                          color:
                              _meaning == null ? c.textTertiary : c.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: FpSpace.s5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: LogSelectRow(
                            label: 'Date Button Added',
                            icon: PhosphorIconsRegular.calendarBlank,
                            onTap: () => _pickDate(context),
                            child: Text(
                              FpFormat.dayAndMonth(_introducedAt),
                              style:
                                  FpType.bodyMd.copyWith(color: c.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(width: FpSpace.s5),
                        Expanded(
                          child: LogSelectRow(
                            label: 'Button Type',
                            child: Text(
                              isConnect ? 'Connect' : 'Classic',
                              style: FpType.bodyMd
                                  .copyWith(color: c.textTertiary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isConnect) ...<Widget>[
                      const SizedBox(height: FpSpace.s5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: LogSelectRow(
                              label: 'Button ID',
                              child: Text(
                                button.serialNumber ?? '—',
                                style: FpType.monoSm
                                    .copyWith(color: c.textTertiary),
                              ),
                            ),
                          ),
                          const SizedBox(width: FpSpace.s5),
                          Expanded(
                            child: LogSelectRow(
                              label: 'Base',
                              child: Text(
                                base?.displayName ?? 'unavailable',
                                style: FpType.bodyMd
                                    .copyWith(color: c.textTertiary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (buttonWebhooksEnabled) ...<Widget>[
                      const SizedBox(height: FpSpace.s5),
                      LogSection(
                        title: 'Webhook URL',
                        child: ButtonTextField(
                          controller: _webhook,
                          hintText: 'URL',
                          keyboardType: TextInputType.url,
                          onChanged: (_) => setState(() => _dirty = true),
                        ),
                      ),
                    ],
                    const SizedBox(height: FpSpace.s5),
                    LogSection(
                      title: 'More Meanings & Details',
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          minHeight: LogMetrics.noteMinHeight,
                        ),
                        padding: const EdgeInsets.all(FpSpace.s4),
                        decoration: BoxDecoration(
                          color: c.surfaceSunken,
                          borderRadius: BorderRadius.circular(FpRadius.md),
                          border: Border.all(
                            color: c.borderSubtle,
                            width: FpStroke.hairline,
                          ),
                        ),
                        child: TextField(
                          controller: _note,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (_) => setState(() => _dirty = true),
                          style:
                              FpType.bodyMd.copyWith(color: c.textPrimary),
                          cursorColor: c.textBrand,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Add more detail',
                            hintStyle: FpType.bodyMd
                                .copyWith(color: c.textTertiary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        LogActionBar(
          children: <Widget>[
            LogActionButton(
              label: 'UPDATE BUTTON',
              onPressed: (_dirty || _soundChanged) && !_submitting
                  ? () => _save(context)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickMeaning(BuildContext context) {
    return showLogSheet(
      context,
      title: 'Meaning',
      options: <LogSheetOption>[
        LogSheetOption(
          label: 'None',
          selected: _meaning == null,
          onSelected: () => setState(() {
            _meaning = null;
            _dirty = true;
          }),
        ),
        for (final meaning in buttonMeanings)
          LogSheetOption(
            label: meaning,
            selected: _meaning == meaning,
            onSelected: () => setState(() {
              _meaning = meaning;
              _dirty = true;
            }),
          ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _introducedAt.isAfter(now) ? now : _introducedAt,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _introducedAt = picked;
        _dirty = true;
      });
    }
  }

  Future<void> _save(BuildContext context) async {
    setState(() => _submitting = true);
    // `PATCH /api/v1/buttons/{id}` (§15) — a no-op. Fixtures only (PLAN.md).
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!context.mounted) return;
    setState(() => _submitting = false);

    logSay(context, '“${_word.text.trim()}” updated — phase 1 stores nothing.');
    Navigator.of(context).maybePop();
  }
}

/// What the Board/Bases loading gate falls through to.
///
/// It used to say this was "the same spinner every other screen uses". That was
/// not true and, being a doc comment that instructs, it propagated: the app has
/// sixteen spinners, twelve in `text.brand` and four — this one,
/// `button_conversion_screen.dart`, `petcube_videos_screen.dart` and
/// `HardwareLoading` — in `text.tertiary`, and all five `RefreshIndicator`s are
/// brand without exception. The design system specifies no spinner at all
/// (`design-system/src/pages/components/index.astro` lists twelve components
/// and none of them is one), so neither colour is wrong and this is a decision
/// nobody has taken rather than a bug. Left as it is, and reported, so it is
/// settled once in the system instead of four more times here.
class _Loading extends StatelessWidget {
  const _Loading();

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

/// What every screen in this group renders when its id parameter is absent
/// or resolves to nothing — the same honesty `hardware_routes.dart` asks for
/// `BASE_EDIT`'s missing serial: a real state on screen, not a crash.
class _NotFound extends StatelessWidget {
  const _NotFound({this.message = 'This Button no longer exists.'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FpSpace.s6,
        vertical: FpSpace.s9,
      ),
      child: Column(
        children: <Widget>[
          PhosphorIcon(
            PhosphorIconsRegular.warningCircle,
            size: FpIconSize.xl,
            color: c.textTertiary,
          ),
          const SizedBox(height: FpSpace.s4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: FpType.headingSm.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

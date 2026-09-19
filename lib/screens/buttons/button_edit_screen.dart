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
/// ## What this screen does not attempt
///
/// The RN screen's `onError` branch — a 404 with `duplicate_button_id`
/// triggers a merge-instead-of-rename prompt (`ButtonEdit.tsx:209-219`) — is a
/// real network error path with nothing to trigger it here (PLAN.md: no
/// network). UPDATE BUTTON always succeeds, as a phase-1 no-op, the same
/// snackbar pattern `hardware_ui.dart` uses under a different
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
import 'buttons_lookup.dart';
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

  int? _conceptId;
  DateTime _introducedAt = DateTime.now();
  bool _dirty = false;
  bool _submitting = false;
  bool _initialised = false;

  /// The sound on the Button as the form now has it. Only removal is
  /// possible here: recording needs a microphone and an Opus encoder the app
  /// does not carry yet.
  int? _audioId;
  bool _soundChanged = false;

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
    _conceptId = button.conceptId;
    _audioId = button.audioId;
    _webhook.text = button.webhookUrl ?? '';
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
              child: boardId == null ? const _NotFound() : _buildBody(context),
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
      AsyncData<Board>(:final value) => _buildForm(
        context,
        value,
        bases.value ?? const <Base>[],
      ),
      AsyncError<Board>() => const _NotFound(
        message: 'Could not load this Button.',
      ),
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
                  hasSound: _audioId != null,
                  label: 'Custom sound',
                  onDelete: () => setState(() {
                    _audioId = null;
                    _soundChanged = true;
                  }),
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
                        ref.watch(buttonConceptsProvider).value?[_conceptId] ??
                            'Button Meaning',
                        style: FpType.bodyMd.copyWith(
                          color: _conceptId == null
                              ? c.textTertiary
                              : c.textPrimary,
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
                              style: FpType.bodyMd.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: FpSpace.s5),
                        Expanded(
                          child: LogSelectRow(
                            label: 'Button Type',
                            child: Text(
                              isConnect ? 'Connect' : 'Classic',
                              style: FpType.bodyMd.copyWith(
                                color: c.textTertiary,
                              ),
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
                                style: FpType.monoSm.copyWith(
                                  color: c.textTertiary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: FpSpace.s5),
                          Expanded(
                            child: LogSelectRow(
                              label: 'Base',
                              child: Text(
                                base?.displayName ?? 'unavailable',
                                style: FpType.bodyMd.copyWith(
                                  color: c.textTertiary,
                                ),
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
                          style: FpType.bodyMd.copyWith(color: c.textPrimary),
                          cursorColor: c.textBrand,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Add more detail',
                            hintStyle: FpType.bodyMd.copyWith(
                              color: c.textTertiary,
                            ),
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
                  ? () => _save(context, button)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickMeaning(BuildContext context) {
    final concepts =
        ref.read(buttonConceptsProvider).value ?? const <int, String>{};
    return showLogSheet(
      context,
      title: 'Meaning',
      options: <LogSheetOption>[
        LogSheetOption(
          label: 'None',
          selected: _conceptId == null,
          onSelected: () => setState(() {
            _conceptId = null;
            _dirty = true;
          }),
        ),
        for (final entry in concepts.entries)
          LogSheetOption(
            label: entry.value,
            selected: _conceptId == entry.key,
            onSelected: () => setState(() {
              _conceptId = entry.key;
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

  Future<void> _save(BuildContext context, Button button) async {
    setState(() => _submitting = true);
    final webhook = _webhook.text.trim();
    final ok = await logWrite(
      context,
      () => ref
          .read(hardwareRepositoryProvider)
          .updateButton(
            Button(
              id: button.id,
              boardId: button.boardId,
              text: _word.text.trim(),
              kind: button.kind,
              note: _note.text.trim(),
              introducedAt: _introducedAt,
              conceptId: _conceptId,
              audioId: _audioId,
              webhookUrl: webhook.isEmpty ? null : webhook,
            ),
          ),
    );
    if (!context.mounted) return;
    setState(() => _submitting = false);
    if (!ok) return;
    ref.invalidate(boardProvider);
    logSay(context, '“${_word.text.trim()}” updated.');
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

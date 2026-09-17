/// `BUTTON_ADD` — add a Classic Button to the Board.
///
/// `src/Home/ButtonAdd/ButtonAdd.tsx`. Reached from `CLASSIC_BUTTONS`'s `+`
/// badge, which always supplies `boardId` and sometimes a `prepopulatedName`
/// (`lib/screens/hardware/classic_buttons_screen.dart:_addButton`).
///
/// ## Why this can only ever create a Classic Button
///
/// The RN form hardcodes `button_type = "Classic"` and disables the Type
/// field — the caption above the Word field spells out why: *"To add a
/// Connect Button, please link a new Button to your Base; afterwards you can
/// edit the Button here."* A Connect Button always starts life through
/// `BUTTON_PAIRING`, never through this form. That is kept exactly: the Type
/// row is a disabled fact, not a picker with one disabled option.
///
/// ## What is kept from the RN form
///
/// Word (required), the Meaning picker, Date Button Added (max today), the
/// Webhook URL field behind the `homeIntegrationEnabled` flag, and the
/// free-text "More Meanings & Details" note — all inside the same
/// Show/Hide Advanced Settings disclosure the RN screen uses to keep the one
/// required field from being crowded by five optional ones.
///
/// Fixtures only (PLAN.md): SAVE never calls `POST /api/v1/buttons`. It
/// says so through [logSay] and pops, the same phase-1 pattern
/// `lib/screens/hardware/hardware_ui.dart`'s `showPhaseOneNotice` uses.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/providers.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../log/log_controls.dart';
import 'buttons_fixture.dart';
import 'buttons_ui.dart';

class ButtonAddScreen extends ConsumerStatefulWidget {
  const ButtonAddScreen({
    required this.boardId,
    required this.prepopulatedName,
    super.key,
  });

  /// From `CLASSIC_BUTTONS`'s query string. Absent falls back to the watched
  /// Board's own id, the same fallback `ButtonAdd.tsx:74` performs
  /// (`boardId ?? board?.id`) — there being no Board to attach a new Button
  /// to is not a state a running app reaches.
  final int? boardId;

  final String? prepopulatedName;

  @override
  ConsumerState<ButtonAddScreen> createState() => _ButtonAddScreenState();
}

class _ButtonAddScreenState extends ConsumerState<ButtonAddScreen> {
  late final TextEditingController _word =
      TextEditingController(text: widget.prepopulatedName ?? '');
  late final TextEditingController _webhook = TextEditingController();
  final TextEditingController _note = TextEditingController();

  String? _meaning;
  DateTime _introducedAt = DateTime.now();
  bool _touchedWord = false;
  bool _submitting = false;

  @override
  void dispose() {
    _word.dispose();
    _webhook.dispose();
    _note.dispose();
    super.dispose();
  }

  String? get _wordError {
    if (!_touchedWord) return null;
    return _word.text.trim().isEmpty ? 'Button Name is required' : null;
  }

  /// `ButtonAdd.tsx:249-251`'s pattern, verbatim: an empty field is valid —
  /// the webhook is optional — anything non-empty must be `http(s)://…`.
  static final RegExp _urlPattern = RegExp(r'^(http|https):\/\/[^ "]+$');

  String? get _webhookError {
    final value = _webhook.text.trim();
    if (value.isEmpty || _urlPattern.hasMatch(value)) return null;
    return 'Invalid URL';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final board = ref.watch(boardProvider);

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            buttonsModalHeader(
              title: FpScreen.buttonAdd.title ?? 'Add Button',
              onClose: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FpSpace.s6,
                  FpSpace.s6,
                  FpSpace.s6,
                  FpSpace.s8,
                ),
                children: <Widget>[
                  Text(
                    'Add a Classic Button',
                    textAlign: TextAlign.center,
                    style: FpType.displaySm.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: FpSpace.s4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PhosphorIcon(
                        PhosphorIconsRegular.question,
                        size: FpIconSize.sm,
                        color: c.textTertiary,
                      ),
                      const SizedBox(width: FpSpace.s2),
                      Expanded(
                        child: Text(
                          'To add a Connect Button, please link a new Button '
                          'to your Base; afterwards you can edit the Button '
                          'here.',
                          style: FpType.bodySm.copyWith(color: c.textTertiary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FpSpace.s6),
                  const LogHairline(),
                  const SizedBox(height: FpSpace.s6),
                  LogSection(
                    title: 'Word',
                    child: ButtonTextField(
                      controller: _word,
                      hintText: 'Button Name',
                      textCapitalization: TextCapitalization.none,
                      errorText: _wordError,
                      onChanged: (_) => setState(() => _touchedWord = true),
                    ),
                  ),
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
                              color: _meaning == null
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
                                  style: FpType.bodyMd
                                      .copyWith(color: c.textPrimary),
                                ),
                              ),
                            ),
                            const SizedBox(width: FpSpace.s5),
                            Expanded(
                              child: LogSelectRow(
                                label: 'Button Type',
                                child: Text(
                                  'Classic',
                                  style: FpType.bodyMd
                                      .copyWith(color: c.textTertiary),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (buttonWebhooksEnabled) ...<Widget>[
                          const SizedBox(height: FpSpace.s5),
                          LogSection(
                            title: 'Webhook URL',
                            child: ButtonTextField(
                              controller: _webhook,
                              hintText: 'URL',
                              keyboardType: TextInputType.url,
                              errorText: _webhookError,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(height: FpSpace.s2),
                          Text(
                            'Enter an HTTP URL to POST, when this button is '
                            'pressed.',
                            style:
                                FpType.labelMd.copyWith(color: c.textTertiary),
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
                              borderRadius:
                                  BorderRadius.circular(FpRadius.md),
                              border: Border.all(
                                color: c.borderSubtle,
                                width: FpStroke.hairline,
                              ),
                            ),
                            child: TextField(
                              controller: _note,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              textCapitalization:
                                  TextCapitalization.sentences,
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
                  label: 'SAVE',
                  onPressed: _submitting
                      ? null
                      : () => _save(context, board.value?.id),
                ),
              ],
            ),
          ],
        ),
      ),
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
          onSelected: () => setState(() => _meaning = null),
        ),
        for (final meaning in buttonMeanings)
          LogSheetOption(
            label: meaning,
            selected: _meaning == meaning,
            onSelected: () => setState(() => _meaning = meaning),
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
    if (picked != null) setState(() => _introducedAt = picked);
  }

  Future<void> _save(BuildContext context, int? loadedBoardId) async {
    setState(() => _touchedWord = true);
    if (_word.text.trim().isEmpty || _webhookError != null) return;

    // `boardId ?? board?.id` (`ButtonAdd.tsx:74`) — a Board to attach to is
    // always available once the fixture has loaded.
    final boardId = widget.boardId ?? loadedBoardId ?? fixtureBoardId;

    setState(() => _submitting = true);
    // `POST /api/v1/buttons` (§15) — a no-op here. Fixtures only (PLAN.md).
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!context.mounted) return;
    setState(() => _submitting = false);

    logSay(
      context,
      '“${_word.text.trim()}” added to Board $boardId — phase 1 stores '
      'nothing.',
    );
    Navigator.of(context).maybePop();
  }
}

/// `BUTTON_CONVERSION` — merge a Classic Button's history into a new Connect
/// Button.
///
/// `src/Home/ButtonConversion/ButtonConversionScreen.tsx`. Reached with
/// `buttonId` (the Connect Button) from `BASE_EDIT`'s Linked Buttons action
/// sheet. The RN app also reached it from the pairing flow's success state
/// with `isOnboardingFlow=true`, which added a SKIP button and a leave-confirm;
/// that flow is gone (the PRD's bases link Buttons on their own when the
/// device script reports them), and so is the flag.
///
/// ## The board this screen shows is not the Board
///
/// `ButtonsBoard hideSpecialButtons` (`ButtonConversionScreen.tsx:200-209`)
/// hides both the `inaudible` chip and the `+` add chip, even though the RN
/// array it is given (`type !== CONNECT`) technically still contains
/// `inaudible`. The rendered list here is filtered to
/// `ButtonKind.classic` for the same effective result, directly rather than
/// through a hide flag — merging a Connect Button's press history into the
/// placeholder that means "no word" is not a choice this screen's own copy
/// ("Choose a Button to update") describes, so there is nothing to hide.
///
/// MERGE's confirm, on acceptance, hands off to `BUTTON_EDIT` for the
/// **Classic** Button's id, not the Connect Button's
/// (`ButtonConversionScreen.tsx:102-105`) — kept exactly as the RN source has
/// it, even though the direction reads backwards at first.
///
/// ## What could not be reproduced
///
/// `getConnectButtonDisplayName` suffixes the Connect Button's label with the
/// last four characters of its hardware SSID
/// (`ButtonConversion/helpers/getConnectButtonDisplayName.ts`). Neither the
/// SSID nor `base_button` metadata exists on `lib/domain/button.dart` — the
/// device-shadow join this screen would need is deeper than
/// `Base.pairedButtons` carries. The Connect Button's own [Button.text] is
/// shown instead.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

class ButtonConversionScreen extends ConsumerStatefulWidget {
  const ButtonConversionScreen({required this.buttonId, super.key});

  final int? buttonId;

  @override
  ConsumerState<ButtonConversionScreen> createState() =>
      _ButtonConversionScreenState();
}

class _ButtonConversionScreenState
    extends ConsumerState<ButtonConversionScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  Button? _selected;
  bool _redirectedForEmptyBoard = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            buttonsModalHeader(
              title: FpScreen.buttonConversion.title ?? 'Merge Buttons',
              onClose: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: widget.buttonId == null
                  ? const _MissingButton()
                  : _buildGate(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGate(BuildContext context) {
    final board = ref.watch(boardProvider);
    return switch (board) {
      AsyncData<Board>(:final value) => _buildBody(context, value),
      AsyncError<Board>() => const _MissingButton(
        message: 'Could not load the Board.',
      ),
      _ => const _Loading(),
    };
  }

  Widget _buildBody(BuildContext context, Board board) {
    final connectButton = findButton(board.buttons, widget.buttonId);
    if (connectButton == null) return const _MissingButton();

    final classicButtons = board.activeButtons
        .where((b) => b.kind == ButtonKind.classic)
        .toList();

    // `ButtonConversionScreen.tsx:84-91`: nothing to merge into, so this
    // screen has no reason to exist for this Button — go straight to editing
    // the Connect Button itself.
    if (classicButtons.isEmpty) {
      if (!_redirectedForEmptyBoard) {
        _redirectedForEmptyBoard = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.pushReplacement(
            '${FpScreen.buttonEdit.path}?buttonId=${connectButton.id}',
          );
        });
      }
      return const _Loading();
    }

    // Prefix, case-insensitive — the one search rule every Button list in
    // the app uses (`hardware_providers.dart`'s `buttonMatches`,
    // `ButtonsBoard.tsx:73-83`), kept here rather than reinvented as a
    // substring match.
    final needle = _query.trim().toLowerCase();
    final matched =
        classicButtons
            .where(
              (b) => needle.isEmpty || b.text.toLowerCase().startsWith(needle),
            )
            .toList()
          ..sort(
            (a, b) => a.text.toLowerCase().compareTo(b.text.toLowerCase()),
          );

    final c = context.fpColors;
    final selected = _selected;

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
              Text(
                'Update Classic to Connect?',
                textAlign: TextAlign.center,
                style: FpType.displaySm.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: FpSpace.s3),
              Text(
                'Merge a Classic Button with your new Connect Button, by '
                'selecting that Classic Button below.\n\n'
                'Pressing "Merge" will associate all information and button '
                'presses from your Classic Button with this Connect Button.',
                textAlign: TextAlign.center,
                style: FpType.bodyMd.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: FpSpace.s6),
              Text(
                'Connect Button',
                textAlign: TextAlign.center,
                style: FpType.labelMd.copyWith(color: c.textTertiary),
              ),
              const SizedBox(height: FpSpace.s3),
              Center(
                child: LogButtonChip(
                  kind: LogChipKind.connect,
                  label: connectButton.text,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: FpSpace.s3),
              Text(
                'will be merged with Classic Button',
                textAlign: TextAlign.center,
                style: FpType.labelMd.copyWith(color: c.textTertiary),
              ),
              const SizedBox(height: FpSpace.s5),
              if (selected != null) ...<Widget>[
                Center(
                  child: LogButtonChip(
                    kind: LogChipKind.classic,
                    label: selected.text,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: FpSpace.s4),
                _SelectedButtonFacts(button: selected),
              ] else
                Center(
                  child: LogEmptyState(
                    icon: PhosphorIconsRegular.arrowsMerge,
                    title: "You haven't chosen a Button yet",
                    message: 'Choose a Button to update',
                  ),
                ),
              const SizedBox(height: FpSpace.s6),
              const LogHairline(),
              const SizedBox(height: FpSpace.s6),
              ButtonTextField(
                controller: _search,
                hintText: 'Search Classic Buttons',
                prefix: PhosphorIcon(
                  PhosphorIconsRegular.magnifyingGlass,
                  size: FpIconSize.md,
                  color: c.textTertiary,
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: FpSpace.s5),
              if (matched.isEmpty)
                LogEmptyState(
                  icon: PhosphorIconsRegular.magnifyingGlass,
                  title: 'No Classic Button matches "${_query.trim()}"',
                  message: 'Try a different search.',
                )
              else
                Wrap(
                  spacing: FpSpace.s3,
                  runSpacing: FpSpace.s3,
                  children: <Widget>[
                    for (final button in matched)
                      LogButtonChip(
                        kind: LogChipKind.classic,
                        label: button.text,
                        onTap: () => setState(() => _selected = button),
                      ),
                  ],
                ),
            ],
          ),
        ),
        LogActionBar(
          children: <Widget>[
            LogActionButton(
              label: 'MERGE',
              onPressed: selected == null
                  ? null
                  : () => _merge(context, connectButton, selected),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _merge(
    BuildContext context,
    Button connectButton,
    Button classicButton,
  ) async {
    final confirmed = await logConfirm(
      context,
      title: '',
      message:
          "Are you sure you want to replace Classic Button "
          "'${classicButton.text}' with your new Connect Button? This "
          'action cannot be undone.',
      confirmLabel: 'Replace',
    );
    if (!confirmed || !context.mounted) return;
    // `POST /buttons/merge`: the Classic Button keeps its history and takes
    // the Connect Button's Base link; the Connect Button goes.
    final ok = await logWrite(
      context,
      () => ref
          .read(hardwareRepositoryProvider)
          .mergeButtons(source: connectButton, target: classicButton),
      failed: 'Could not replace the Button. Try again.',
    );
    if (!ok || !context.mounted) return;
    ref.invalidate(boardProvider);
    ref.invalidate(basesProvider);
    // `ButtonConversionScreen.tsx:100-105`: replaces with `BUTTON_EDIT` for
    // the **Classic** Button's id, not the Connect Button's.
    context.pushReplacement(
      '${FpScreen.buttonEdit.path}?buttonId=${classicButton.id}',
    );
  }
}

/// `ButtonInfo` (`commponents/ButtonInfo.tsx`), reproduced as three labelled
/// facts rather than the RN component's own icon set — this app's icon
/// vocabulary is Phosphor throughout, not the RN screen's bespoke SVGs.
class _SelectedButtonFacts extends ConsumerWidget {
  const _SelectedButtonFacts({required this.button});

  final Button button;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fpColors;
    final meaning = ref.watch(buttonConceptsProvider).value?[button.conceptId];
    final introducedAt = button.introducedAt;

    Widget fact(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(bottom: FpSpace.s2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PhosphorIcon(icon, size: FpIconSize.sm, color: c.textTertiary),
          const SizedBox(width: FpSpace.s2),
          Text(text, style: FpType.bodySm.copyWith(color: c.textTertiary)),
        ],
      ),
    );

    return Column(
      children: <Widget>[
        fact(
          PhosphorIconsRegular.handTap,
          FpFormat.largeCountOf(button.buttonPresses, 'press', 'presses'),
        ),
        fact(
          PhosphorIconsRegular.calendarBlank,
          introducedAt == null
              ? 'Added — unknown'
              : 'Added ${FpFormat.dayAndMonth(introducedAt)}',
        ),
        fact(
          PhosphorIconsRegular.chatTeardropDots,
          'Interpretation: ${meaning?.toUpperCase() ?? 'None added'}',
        ),
      ],
    );
  }
}

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

class _MissingButton extends StatelessWidget {
  const _MissingButton({this.message = 'This Button no longer exists.'});

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

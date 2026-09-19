/// `BASE_REGISTRATION` — register a Base by serial number.
///
/// The RN screen (`src/Home/BaseRegistration/BaseRegistration.tsx`) was an
/// eleven-step wizard: BLE pairing, a captive Wi-Fi access point, a firmware
/// update, server polling. None of that survives `../backend/PRD.md`: the API's
/// whole registration contract is `POST /bases { serial_number, name }`, and
/// the Base's own network setup is done outside this app. So this is a form
/// with two fields, and the screen title the RN app gave it ("CONNECT SETUP")
/// now describes exactly what it does.
///
/// ## What is kept
///
/// The serial rule, verbatim from `validateBaseSerialNumber.ts`: twelve
/// characters, `A-F` and `0-9` only. Input is upper-cased as it is typed so a
/// lower-case serial off the label is not rejected for its case. The name
/// field shares [HardwareMetrics.baseNameMaxLength] with `BASE_EDIT`, so the
/// two screens cannot accept two different lengths.
///
/// ## What the PRD adds
///
/// A serial already registered to another Household is **transferred**, not
/// rejected (`POST /bases` — "old links removed, new record under mine"). The
/// copy under the serial field says so, because a second person registering a
/// shared Base is the one surprising outcome and it should be read before
/// SAVE, not after.
///
/// REGISTER is `POST /bases`; on success the Bases list refreshes and this
/// pops back to it.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../router/screens.g.dart';
import '../../theme/fp_context.dart';
import '../../theme/generated/fp_tokens.dart';
import '../../widgets/widgets.dart';
import '../hardware/hardware_metrics.dart';
import '../hardware/hardware_providers.dart' show refreshHardware;
import '../hardware/hardware_ui.dart';
import '../log/log_controls.dart' show logWrite;

/// `BASE_SERIAL_NUMBER_LENGTH` in the RN app and "12 chars" in the PRD.
const int baseSerialLength = 12;

/// `validateBaseSerialNumber.ts`, verbatim.
bool isValidBaseSerial(String serial) =>
    serial.length == baseSerialLength &&
    RegExp(r'^[A-F0-9]*$').hasMatch(serial);

class BaseRegistrationScreen extends ConsumerStatefulWidget {
  const BaseRegistrationScreen({super.key});

  @override
  ConsumerState<BaseRegistrationScreen> createState() =>
      _BaseRegistrationScreenState();
}

class _BaseRegistrationScreenState
    extends ConsumerState<BaseRegistrationScreen> {
  final TextEditingController _serial = TextEditingController();
  final TextEditingController _name = TextEditingController();

  /// Errors show after the first attempt, not while the serial is half typed.
  bool _attempted = false;

  @override
  void dispose() {
    _serial.dispose();
    _name.dispose();
    super.dispose();
  }

  String get _serialValue => _serial.text.trim().toUpperCase();

  String? get _serialError {
    if (!_attempted) return null;
    if (_serialValue.isEmpty) return 'Enter the serial number on the Base';
    if (!isValidBaseSerial(_serialValue)) {
      return 'A serial is $baseSerialLength characters, letters A–F and '
          'digits only';
    }
    return null;
  }

  Future<void> _register() async {
    setState(() => _attempted = true);
    if (_serialError != null) return;
    final name = _name.text.trim();
    final ok = await logWrite(
      context,
      () => ref
          .read(hardwareRepositoryProvider)
          .registerBase(
            serialNumber: _serialValue,
            name: name.isEmpty ? _serialValue : name,
          ),
      failed: 'Could not register the Base. Try again.',
    );
    if (!ok || !mounted) return;
    refreshHardware(ref);
    if (context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final error = _serialError;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Register a Base',
              subtitle: FpScreen.baseRegistration.title,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FpSpace.s6,
                  FpSpace.s2,
                  FpSpace.s6,
                  FpSpace.s8,
                ),
                children: <Widget>[
                  Text(
                    'Serial number',
                    style: FpType.headingSm.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: FpSpace.s1),
                  Text(
                    'Printed on the label underneath the Base.',
                    style: FpType.bodySm.copyWith(color: c.textTertiary),
                  ),
                  const SizedBox(height: FpSpace.s3),
                  HardwareTextField(
                    controller: _serial,
                    hintText: 'AAAA1234BBBB',
                    maxLength: baseSerialLength,
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: <TextInputFormatter>[
                      _UpperCaseFormatter(),
                      FilteringTextInputFormatter.allow(RegExp('[A-F0-9]')),
                    ],
                    errorText: error,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: FpSpace.s3),
                  Text(
                    'If this Base is already registered to another Household '
                    'it moves to yours, and its Buttons unlink there.',
                    style: FpType.bodySm.copyWith(color: c.textTertiary),
                  ),
                  const SizedBox(height: FpSpace.s7),
                  Text(
                    'Base name',
                    style: FpType.headingSm.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: FpSpace.s1),
                  Text(
                    'Optional. The room it lives in is usually the useful '
                    'answer.',
                    style: FpType.bodySm.copyWith(color: c.textTertiary),
                  ),
                  const SizedBox(height: FpSpace.s3),
                  HardwareTextField(
                    controller: _name,
                    hintText: 'Kitchen',
                    maxLength: HardwareMetrics.baseNameMaxLength,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: FpSpace.s7),
                  Text(
                    'Once registered, press any Connect Button near the Base '
                    'and it links itself. Buttons show up on the Base’s page '
                    'as they are seen.',
                    style: FpType.bodySm.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            HardwareActionBar(
              child: HardwarePrimaryButton(
                label: 'REGISTER',
                onPressed: _serialValue.isEmpty ? null : _register,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Upper-cases as it is typed, keeping the caret where it was.
class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}

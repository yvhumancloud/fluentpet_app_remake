import 'package:flutter/material.dart';

import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import 'screens.g.dart';

/// What every route resolves to until someone builds the real screen.
///
/// It is deliberately loud, and as of this pass nothing reaches it: all
/// thirty-six screens have builders and `app_router.dart`'s `_merge` asserts
/// that they do. It stays because `FpScreen` is generated from the design
/// system's screen map — a screen added upstream regenerates the enum without
/// regenerating any route map, and a route that silently rendered nothing would
/// look like a working app with a broken screen rather than a screen nobody has
/// written yet.
///
/// A path that resolves to no screen at all is a different statement and goes
/// elsewhere: `UNKNOWN` and `UnknownScreen`, via the router's `errorBuilder`.
/// This screen says "not written"; that one says "no such link".
///
/// It shows the screen key and the route, because when a navigation lands
/// somewhere unexpected the first question is always "which screen is this".
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.screen, super.key});

  final FpScreen screen;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final isModal = screen.presentation == FpPresentation.modal;

    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      appBar: AppBar(
        title: Text(screen.title ?? screen.key),
        leading: isModal
            ? IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(FpSpace.s6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FpSpace.s3,
                  vertical: FpSpace.s2,
                ),
                decoration: BoxDecoration(
                  color: c.statusWarningBg,
                  borderRadius: BorderRadius.circular(FpRadius.full),
                  border: Border.all(
                    color: c.statusWarningBorder,
                    width: FpStroke.hairline,
                  ),
                ),
                child: Text(
                  'NOT BUILT YET',
                  style: FpType.labelSm.copyWith(color: c.statusWarningFg),
                ),
              ),
              const SizedBox(height: FpSpace.s6),
              Text(
                screen.title ?? screen.key,
                style: FpType.displaySm.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: FpSpace.s3),
              Text(
                'This route exists so navigation can be exercised end to end. '
                'The screen itself is somebody else’s work.',
                style: FpType.bodyMd.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: FpSpace.s7),
              _Facts(screen: screen),
            ],
          ),
        ),
      ),
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.screen});

  final FpScreen screen;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(FpRadius.lg),
        border: Border.all(color: c.borderSubtle, width: FpStroke.hairline),
        boxShadow: context.fpElevation.e1,
      ),
      padding: const EdgeInsets.all(FpSpace.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Row(label: 'Screen key', value: screen.key),
          _Row(label: 'Route', value: screen.route),
          _Row(label: 'Path', value: screen.path),
          _Row(label: 'Presentation', value: screen.presentation.name),
          _Row(label: 'Navigator', value: screen.navigator ?? '—'),
          if (screen.invented)
            _Row(
              label: 'Path origin',
              value: 'invented — no deep link in the RN app',
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: FpSpace.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: FpType.labelSm.copyWith(color: c.textTertiary)),
          const SizedBox(height: FpSpace.s1),
          // Mono, and therefore tabular: these are identifiers and paths, and
          // the mono styles are what the design reserves for exactly that.
          SelectableText(
            value,
            style: FpType.monoSm.copyWith(color: c.textPrimary),
          ),
        ],
      ),
    );
  }
}

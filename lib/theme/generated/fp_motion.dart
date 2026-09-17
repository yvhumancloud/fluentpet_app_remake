// Originally generated from the design system's token build (tokens/build.mjs).
// That upstream is no longer wired to this repo: this file is now the source of
// truth and is maintained by hand. Background: docs/design-system/adr/.
import 'package:flutter/animation.dart';

/// Durations. Per ADR 0001 the specification deliberately stops at durations
/// and curves: motion cannot be judged in a static page, so which of these a
/// given transition uses is a Flutter decision.
class FpDuration {
  const FpDuration._();

  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 320);
}

/// Easing curves.
class FpEasing {
  const FpEasing._();

  static const Cubic standard = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Cubic decelerate = Cubic(0.0, 0.0, 0.0, 1.0);
  static const Cubic accelerate = Cubic(0.3, 0.0, 1.0, 1.0);
}

/// Instance mirror of [FpDuration], reached as `context`-scoped sugar.
/// Identical values; the statics remain for const contexts.
class FpDurationTokens {
  const FpDurationTokens();

  Duration get fast => FpDuration.fast;
  Duration get base => FpDuration.base;
  Duration get slow => FpDuration.slow;
}

/// Instance mirror of [FpEasing], reached as `context`-scoped sugar.
/// Identical values; the statics remain for const contexts.
class FpEasingTokens {
  const FpEasingTokens();

  Cubic get standard => FpEasing.standard;
  Cubic get decelerate => FpEasing.decelerate;
  Cubic get accelerate => FpEasing.accelerate;
}

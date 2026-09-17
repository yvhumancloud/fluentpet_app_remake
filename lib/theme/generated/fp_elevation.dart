// Originally generated from the design system's token build (tokens/build.mjs).
// That upstream is no longer wired to this repo: this file is now the source of
// truth and is maintained by hand. Background: docs/design-system/adr/.
import 'package:flutter/material.dart';

/// Shadow stacks, resolved per scheme — dark mode needs its own, far heavier,
/// alphas to read at all against a near-black canvas.
///
/// CSS blur and Flutter's [BoxShadow.blurRadius] are carried across one to one.
/// They are not the same unit — Flutter converts radius to a Gaussian sigma —
/// so a shadow will read slightly softer here than in the specification site.
@immutable
class FpElevation extends ThemeExtension<FpElevation> {
  const FpElevation({
    required this.e0,
    required this.e1,
    required this.e2,
    required this.e3,
    required this.e4,
  });

  final List<BoxShadow> e0;
  final List<BoxShadow> e1;
  final List<BoxShadow> e2;
  final List<BoxShadow> e3;
  final List<BoxShadow> e4;

  static const FpElevation light = FpElevation(
    e0: <BoxShadow>[],
    e1: <BoxShadow>[
      BoxShadow(
        color: Color(0x0A1C1A17),
        offset: Offset(0.0, 1.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Color(0x0F1C1A17),
        offset: Offset(0.0, 1.0),
        blurRadius: 3.0,
        spreadRadius: 0.0,
      ),
    ],
    e2: <BoxShadow>[
      BoxShadow(
        color: Color(0x0D1C1A17),
        offset: Offset(0.0, 2.0),
        blurRadius: 4.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Color(0x121C1A17),
        offset: Offset(0.0, 4.0),
        blurRadius: 8.0,
        spreadRadius: 0.0,
      ),
    ],
    e3: <BoxShadow>[
      BoxShadow(
        color: Color(0x0F1C1A17),
        offset: Offset(0.0, 6.0),
        blurRadius: 12.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Color(0x141C1A17),
        offset: Offset(0.0, 10.0),
        blurRadius: 20.0,
        spreadRadius: 0.0,
      ),
    ],
    e4: <BoxShadow>[
      BoxShadow(
        color: Color(0x1A1C1A17),
        offset: Offset(0.0, 12.0),
        blurRadius: 24.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Color(0x1A1C1A17),
        offset: Offset(0.0, 20.0),
        blurRadius: 40.0,
        spreadRadius: 0.0,
      ),
    ],
  );

  static const FpElevation dark = FpElevation(
    e0: <BoxShadow>[],
    e1: <BoxShadow>[
      BoxShadow(
        color: Color(0x66000000),
        offset: Offset(0.0, 1.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Color(0x4D000000),
        offset: Offset(0.0, 1.0),
        blurRadius: 3.0,
        spreadRadius: 0.0,
      ),
    ],
    e2: <BoxShadow>[
      BoxShadow(
        color: Color(0x73000000),
        offset: Offset(0.0, 2.0),
        blurRadius: 6.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Color(0x59000000),
        offset: Offset(0.0, 4.0),
        blurRadius: 10.0,
        spreadRadius: 0.0,
      ),
    ],
    e3: <BoxShadow>[
      BoxShadow(
        color: Color(0x80000000),
        offset: Offset(0.0, 6.0),
        blurRadius: 14.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Color(0x66000000),
        offset: Offset(0.0, 10.0),
        blurRadius: 24.0,
        spreadRadius: 0.0,
      ),
    ],
    e4: <BoxShadow>[
      BoxShadow(
        color: Color(0x8C000000),
        offset: Offset(0.0, 12.0),
        blurRadius: 28.0,
        spreadRadius: 0.0,
      ),
      BoxShadow(
        color: Color(0x73000000),
        offset: Offset(0.0, 20.0),
        blurRadius: 48.0,
        spreadRadius: 0.0,
      ),
    ],
  );

  @override
  FpElevation copyWith({
    List<BoxShadow>? e0,
    List<BoxShadow>? e1,
    List<BoxShadow>? e2,
    List<BoxShadow>? e3,
    List<BoxShadow>? e4,
  }) {
    return FpElevation(
      e0: e0 ?? this.e0,
      e1: e1 ?? this.e1,
      e2: e2 ?? this.e2,
      e3: e3 ?? this.e3,
      e4: e4 ?? this.e4,
    );
  }

  @override
  FpElevation lerp(ThemeExtension<FpElevation>? other, double t) {
    if (other is! FpElevation) return this;
    return FpElevation(
      e0: BoxShadow.lerpList(e0, other.e0, t) ?? const <BoxShadow>[],
      e1: BoxShadow.lerpList(e1, other.e1, t) ?? const <BoxShadow>[],
      e2: BoxShadow.lerpList(e2, other.e2, t) ?? const <BoxShadow>[],
      e3: BoxShadow.lerpList(e3, other.e3, t) ?? const <BoxShadow>[],
      e4: BoxShadow.lerpList(e4, other.e4, t) ?? const <BoxShadow>[],
    );
  }
}

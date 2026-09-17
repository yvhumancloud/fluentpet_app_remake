import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../domain/domain.dart';
import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import 'fp_metrics.dart';

/// The three sizes the design specifies, with their diameters.
///
/// Components page, Pusher avatar: sm on the timeline, md in list rows and
/// pickers, lg in detail screen headers.
///
/// [glyph] is the icon size for the two Pushers that are drawn as a mark
/// rather than a letter — always the token one step below the disc, so the
/// glyph sits inside it the way a capital does.
enum PusherAvatarSize {
  sm(FpMetrics.avatarSm, FpIconSize.sm),
  md(FpMetrics.avatarMd, FpIconSize.md),
  lg(FpMetrics.avatarLg, FpIconSize.lg);

  const PusherAvatarSize(this.diameter, this.glyph);

  final double diameter;
  final double glyph;
}

/// Who did the pressing, as one disc.
///
/// A Learner (the pet) is a **filled** brand disc; a Teacher (a human
/// modelling a word) is an **outlined** one. The difference is weight, not
/// hue, and that is the rule rather than a preference: the two have to stay
/// apart in greyscale and for anyone who cannot separate teal from grey.
///
/// The letter comes from [Pusher.initial], which the domain derives from the
/// name. It is never stored as a second field that can drift.
///
/// On a filled disc the letter is `text.onBrand`, never white — dark mode's
/// brand step is light enough to need a dark letter (ADR 0002).
///
/// The two **pseudo-Pushers** are marks, not letters, which is what the old app
/// did too (`AvatarTypeSpecific.tsx`, quoted in
/// `docs/design-system/screen-inventory.md` §1.1): a press nobody has
/// attributed is a question mark, and a free-standing journal entry is a note.
/// Their names are wire sentinels — the literal strings "base" and "event
/// note" — so their initials would put a "B" or an "E" on the timeline and
/// read as somebody's name.
class PusherAvatar extends StatelessWidget {
  const PusherAvatar({
    required this.pusher,
    this.size = PusherAvatarSize.sm,
    super.key,
  });

  final Pusher pusher;
  final PusherAvatarSize size;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final isLearner = pusher.isLearner;

    final letterStyle = switch (size) {
      PusherAvatarSize.sm => FpType.labelSm,
      PusherAvatarSize.md => FpType.labelMd,
      PusherAvatarSize.lg => FpType.headingSm,
    };

    // A mark for the two pseudo-Pushers, a letter for the two real ones.
    final IconData? mark = switch (pusher.kind) {
      PusherKind.base => PhosphorIconsRegular.question,
      PusherKind.eventNote => PhosphorIconsRegular.notePencil,
      PusherKind.learner || PusherKind.teacher => null,
    };

    return Semantics(
      label: switch (pusher.kind) {
        PusherKind.learner => '${pusher.name} · Learner',
        PusherKind.teacher => '${pusher.name} · Teacher',
        PusherKind.base => 'Nobody attributed',
        PusherKind.eventNote => 'Journal entry',
      },
      child: Container(
        width: size.diameter,
        height: size.diameter,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLearner ? c.surfaceBrand : c.surfaceRaised,
          border: isLearner
              ? null
              : Border.all(color: c.borderDefault, width: FpStroke.hairline),
        ),
        child: mark == null
            ? Text(
                pusher.initial,
                style: letterStyle.copyWith(
                  color: isLearner ? c.textOnBrand : c.textTertiary,
                  // The letter has to sit on the disc's optical centre; the
                  // token's leading would push it low inside a circle this
                  // small.
                  height: 1.0,
                ),
              )
            : PhosphorIcon(mark, size: size.glyph, color: c.textTertiary),
      ),
    );
  }
}

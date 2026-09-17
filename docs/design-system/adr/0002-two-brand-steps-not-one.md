# 2. Two brand steps, not one hex

Date: 2026-08-19

## Status

Accepted

## Context

The brand teal renders as a different value in light and dark mode, and this
looks like an inconsistency worth fixing. It is not. It is forced.

For a colour to carry small text at WCAG AA it needs 4.5:1 against its
background. Against our light canvas that caps its luminance at 0.172. Against
our dark canvas it needs at least 0.197. Those two requirements do not overlap,
so no single colour satisfies both. The best any single colour can manage
against both is 4.27:1, and even if the dark canvas were pure black the ceiling
is 4.47:1 — still under AA. This is arithmetic, not a matter of picking a better
teal.

Three options were measured:

- **One hex at the optimum**, `#008397`, reaching 4.25:1 on light and 4.28:1 on
  dark. Fine for icons, fills and large text, which only need 3:1. Fails AA for
  small brand-coloured text in *both* modes.
- **One hex plus a design rule**, `#007A8E`, with brand colour forbidden from
  carrying small text — the active tab icon tinted, its label left at normal text
  colour. No contrast failures, at the cost of a constraint every future screen
  must hold to.
- **Two steps of one ramp**, which is what mature design systems do.

An earlier version of the ramp genuinely was wrong, and that is what prompted
the question: the dark step had drifted to 58% saturation while the light step
sat at 100%, and a desaturated teal reads as blue-grey. That was a real defect
and it is fixed. The remaining difference is lightness alone.

## Decision

Two steps of the same ramp: `teal.700` in light, `teal.400` in dark. Both at
188 degrees and full saturation, differing only in lightness — 22% against 41%.

Any colour that carries meaning may take a different step per mode. Hue and
saturation must match across modes; only lightness may move.

## Consequences

The two modes read as one colour, and everything passes AA in both — 6.68:1 and
7.70:1 respectively, against 4.27 for the best single-hex alternative.

Nobody writes either value by hand. The semantic token layer selects the step,
so a screen asks for `text.brand` and gets whichever is correct. The two hexes
exist only in the ramp.

This generalises: no token that must contrast against the canvas can share one
value across modes. It is the reason the token layer is semantic rather than a
flat list of colours, and the reason the old app's `Colors` enum could not have
supported dark mode without being rewritten.

If someone later proposes collapsing the brand to a single hex, the answer is
the arithmetic above: it cannot carry small text, in either mode.

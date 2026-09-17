# 1. Astro as design specification, not as source of code

Date: 2026-08-19

## Status

Accepted

## Context

The FluentPet mobile app is being redesigned and simultaneously rewritten from
React Native to Flutter. We needed somewhere to do the design work.

Astro produces HTML and CSS. Flutter consumes neither. There is no path by which
an Astro component becomes a Flutter widget, so every component will be written
by hand in Dart no matter what we choose here. Anyone proposing this arrangement
should be assumed, by default, to expect some code reuse — and that expectation
is wrong.

The alternatives were real:

- **Flutter Widgetbook** — design directly in Dart, in the target language, with
  a component gallery included. Nothing is translated because nothing crosses a
  language boundary.
- **Storybook with React Native Web** — reuses the existing app's components, so
  the redesign starts from what exists.
- **Figma** — the conventional answer, and the one with the best drawing tools.

Astro was chosen for iteration speed on a design that is mostly typography and
colour, for rendering real type in a real browser, and because the design work
does not want to wait on a Flutter toolchain that does not yet exist. Widgetbook
was the strongest rival and was rejected on that last point alone: it makes the
design phase depend on the rewrite phase, when we want the reverse.

## Decision

The Astro site is a **visual specification**. It is not a component library, and
none of its code is reused.

A single `tokens.json`, in W3C Design Tokens format, is the canonical artifact.
Style Dictionary generates CSS custom properties for the Astro site and a Dart
`ThemeExtension` for the Flutter app. That file is the only thing that crosses
from design into the product.

## Consequences

Every component is built twice — once in HTML/CSS to specify it, once in Dart to
ship it. This is accepted as the cost of designing before the Flutter app exists.

Because the token file is generated into both targets rather than copied, the
design and the app cannot silently drift apart on colour, type, spacing, radius
or elevation. They can and will drift on everything a token cannot express —
layout, composition, and above all motion. Motion is therefore deliberately left
out of the specification and designed in Flutter.

A future reader finding an Astro project beside a Flutter app should not go
looking for the build step that connects them. There is none, and there was never
meant to be one.

# Design system (archived reference)

This app used to be generated from a separate Astro design-system repo at
`../design-system`. That link is cut: nothing in this repo builds, runs or
tests against it any more, and the generator scripts (`tool/gen_screens.dart`,
`tool/sync_design_system.sh`) have been removed.

What was generated is now hand-maintained source:

| File | Was generated from |
|---|---|
| `lib/theme/generated/*.dart` | the design system's `tokens/build.mjs` |
| `lib/router/screens.g.dart` | `src/data/screen-map.json`, via `tool/gen_screens.dart` |

Their "do not edit by hand" banners have been rewritten to say so. Edit them
directly.

## What is kept here, and why

The Dart doc comments across `lib/` cite the specification by path and section
number. These are the cited documents, vendored so those citations resolve:

- `screen-inventory.md` — the screen-by-screen specification. 27 citations.
- `adr/0001-astro-as-design-specification-not-code.md` — why the design system
  was a specification rather than shared code.
- `adr/0002-two-brand-steps-not-one.md` — why the brand colour is a different
  hex per scheme. Cited by `lib/theme/fp_theme.dart` and `lib/widgets/widgets.dart`.
- `data/screen-map.json` — the input `screens.g.dart` was built from, including
  the 36 in-scope / 11 retired / 6 invented arithmetic the generator enforced.
- `data/invented-screens.json` — the six native auth screens this app adds.

## Citations that no longer resolve

Twelve doc comments still cite the Astro implementation (`src/screens/`,
`src/components/`, `src/pages/`, `CONTEXT.md`), which is not vendored here.
They are provenance — a record of what a widget was drawn from — and remain
accurate as history even though the file is not in this repo.

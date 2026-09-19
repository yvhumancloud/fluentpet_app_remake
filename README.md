# FluentPet — Flutter app

The FluentPet Connect device-management product, rebuilt in Flutter against the
visual specification in `../design-system`.

The app talks to the FastAPI backend in `../backend` (`PRD.md` there is the
scope), signs in with Firebase Auth, receives FCM pushes and reports to Sentry.
No Bluetooth, no pairing, no device shadow: a Base is registered by serial and
the device script does the rest.

## Backend and environment

`lib/env.dart` is the one place that knows which environment a build is:
`--dart-define=ENV=dev|prod` (a debug build defaults to `dev`), the API base
URL (`API_URL`; dev defaults to `http://10.0.2.2:8080`, the Android emulator's
name for the host) and the Sentry DSN.

The client is generated. `tool/gen_api.sh` fetches the backend's OpenAPI
spec, tidies it (FastAPI's operation ids, the per-route auth headers, a few
defaults the generator mishandles) and runs openapi-generator's `dart-dio`
into `packages/fluentpet_api`. Re-run it when the backend changes; never edit
the package. `lib/data/api/api_client.dart` wraps it with the Firebase bearer
token; `lib/data/api/mappers.dart` turns wire models into `lib/domain/`.

## The screen map is hand-maintained now

`lib/router/screens.g.dart` was generated from the design system's screen map
by `tool/sync_design_system.sh`. Both are gone; the file is the source of truth
and is edited by hand. The map it was built from is vendored at
`docs/design-system/data/screen-map.json` for the record.

## Scope

`../backend/PRD.md` (2026-09-16) is the product contract. It drops base
onboarding (BLE pairing, captive Wi-Fi, firmware update, resync), Petcube, the
meanings dictionary, CSV export and outbound email. The eleven RN screens that
served those are not in the enum; the ones the PRD adds — a serial-and-name
Base registration, in-app Household invitations (`HOUSEHOLD_MEMBERS`), the
`push_frequency` and `default_pusher_id` preferences, Google sign-in — are.

## Tokens

Everything visual comes from `lib/theme/generated/`, which is generated from
`design-system/tokens/`.

**No colour in app code is ever a hex literal or a `Colors.*` constant.** The
brand is deliberately two different hex values — `teal.700` in light,
`teal.400` in dark — because no single value clears 4.5:1 against both a
near-white and a near-black canvas. That is arithmetic, not an oversight; see
ADR 0002. Ask the semantic layer for `textBrand` and get whichever is right.

```dart
import 'package:fluentpet/theme/fp_context.dart';
import 'package:fluentpet/theme/generated/fp_tokens.dart';

Container(
  padding: const EdgeInsets.all(FpSpace.s5),
  decoration: BoxDecoration(
    color: context.fpColors.surfaceRaised,
    borderRadius: BorderRadius.circular(FpRadius.lg),
    boxShadow: context.fpElevation.e1,
  ),
  child: Text('outside',
      style: FpType.displayMd.copyWith(color: context.fpColors.textPrimary)),
);
```

`context.fpColors` and `context.fpElevation` come out of the theme and are
correct for the active scheme. Everything else is a compile-time constant:
`FpSpace`, `FpRadius`, `FpStroke`, `FpIconSize`, `FpType`, `FpStateLayer`,
`FpDuration`, `FpEasing`. Each also has a `context.` form
(`context.fpSpace.s5`, `context.fpType.bodyMd`) for symmetry, but the statics
are better inside a `const` widget.

`TextStyle` gains `.tabular` for numerals that must not change width —
`FpType.labelMd.tabular`. The two mono styles already carry it.

**Every string built from a number, a date or a duration comes from `FpFormat`**
(`lib/format/fp_format.dart`, exported by `widgets/widgets.dart`): times, dates,
elapsed gaps, battery, last-seen, plurals, and the `1.5k` rule the old app
applied to every count in every header. It imports nothing — not even Flutter —
which is why the domain can use it too.

## Data

Screens watch providers in `lib/data/providers.dart` and never see the wire:

| provider | yields |
| --- | --- |
| `dashboardFiltersProvider` | `DashboardFilters` — the current filter set |
| `householdProvider` | `Household` |
| `pushersProvider` | `List<Pusher>` |
| `basesProvider` | `List<Base>` |
| `boardProvider` | `Board` — **the** Board, every Button in the Household |
| `learnerContextsProvider` / `teacherContextsProvider` | `List<InteractionContext>` |
| `allContextsProvider` | both Context lists, as the filter sheet offers them |
| `preferencesProvider` | the user's server-side preferences |
| `learnerTypesProvider` / `buttonConceptsProvider` | the pickers' options |
| `nowProvider` | `DateTime` — the one clock every relative time reads, ticking once a minute |

The three `*RepositoryProvider`s hand out `lib/data/api/api_repositories.dart`;
the interfaces in `lib/data/repositories.dart` carry the writes too. A screen
that writes calls the repository through `logWrite` (`log_controls.dart`),
which reports the server's message on failure, then invalidates the provider
it changed. The Activity timeline is paged by `POST /interactions/search`
through `lib/screens/activity/data/timeline_source.dart`.

**There is one Board and one Context catalogue**, both from the API. A second
Board is how `CLASSIC_BUTTONS` ends up showing Buttons the Log screen has never
heard of, and a second Context list is how a filter set on the Activity tab
stops matching what the Log screen tagged (Contexts filter by id).

Domain vocabulary is `../design-system/CONTEXT.md`, verbatim. One deliberate
rename: the domain's **Context** is the Dart type `InteractionContext`, because
`Context` sits one careless import away from `BuildContext`. See the note at the
top of `lib/domain/domain.dart`.

## Navigation

Riverpod plus `go_router`. All thirty-two screens are routed — twenty-six at
the deep-link paths the React Native app used, with the presentation it
registered (modals present as modals), plus the six this app adds.

**To add a screen, add one entry to `screenBuilders` in
`lib/router/app_router.dart`.** Anything without a builder resolves to
`PlaceholderScreen`, which shows the screen key and route so unbuilt work is
visible rather than a crash. Do not hand-write a `GoRoute`; the table is derived
from `lib/router/screens.g.dart`.

All thirty-two are built. `screenBuilders` is the merge of the nine areas' own
maps — `activityRoutes`, `authRoutes`, `logRoutes`, … — which exist so areas
can be built at once without everyone editing one map. The merge asserts that
no two areas claim the same screen and that none is missing; a plain spread
would let the last one win silently.

Arguments travel as **query parameters on the generated path**, never as
`state.extra`: `…/activity_button?buttonId=101&meaning=outside`. `extra`
survives a push and evaporates on a deep link or a restore, which is the one
case anybody tests it in.

The drawer carries a full route index, so any route can be reached without a
screen to navigate from.

## Fonts

Fraunces (display), Inter (body and UI) and JetBrains Mono are vendored in
`assets/fonts/`, not fetched at runtime. Only the weights the tokens reference
ship: Fraunces 600, Inter 400/500/600, JetBrains Mono 400. All three are SIL
Open Font License 1.1; the licence texts are in `assets/fonts/licenses/` and are
bundled with the app.

A weight the tokens do not reference will be synthesised by the engine rather
than loaded. If a design needs Inter 700, add it to the tokens first, then ship
the file.

## Layout

```
lib/
  main.dart                  entry point
  app.dart                   MaterialApp.router, scheme selection
  theme/
    generated/               the design tokens, vendored
    fp_theme.dart            FpTheme.light / FpTheme.dark
    fp_context.dart          context.fpColors, .fpType, .fpSpace, …
    theme_mode.dart          system / light / dark override
  domain/                    the model, in CONTEXT.md's vocabulary
  format/
    fp_format.dart           every string built from a number, date or duration
  widgets/                   the twelve shared components
  screens/
    activity/                the five Activity screens, one timeline
    auth/                    sign in, sign up, reset, verify
    buttons/                 add, edit, merge
    hardware/                the four Hardware screens
    household/               Pushers, and the people with accounts
    log/                     LOG and LOG_DETAILS, and the edit sequence
    settings/                Settings and UNKNOWN
    setup/                   WELCOME and Base registration
  dev/
    widget_gallery_screen.dart  every component, every state (drawer, dev only)
  data/
    repositories.dart        the interfaces screens are allowed to call
    providers.dart           what screens watch
    api/                     the generated client wrapped, and wire → domain
  auth/                      Firebase Auth and FCM, behind two classes
  router/
    screens.g.dart           the screen enum — hand-maintained
    tabs.dart                the three tab roots
    app_router.dart          the route table — add screens here
    app_shell.dart           tab chrome and drawer (scaffolding, not the design)
    placeholder_screen.dart  what unbuilt routes resolve to
```

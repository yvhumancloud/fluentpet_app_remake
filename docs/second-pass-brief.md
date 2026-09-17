# Second screen pass — coordination brief

Written 2026-08-20 by the coordinator. Binding on every agent in this pass.
Read `docs/screen-inventory.md` (design-system) and `README.md` first.

## Decisions ratified this session — these are settled, do not re-litigate

1. **Process:** the 24 remaining screens are designed directly in Flutter within
   the design system, and ratified after. No Astro spec pass. Log every
   invention in the commit body.
2. **`text.disabled` moves** to light `sand.500` (4.80:1) and dark `sand.400`
   (7.57:1). Hue and saturation stay matched per ADR 0002.
3. **All four "Invented" component states are ratified**: free-standing Note,
   No Base paired, tab attention dot, detail-screen back chevron. They are part
   of the system now; use them.
4. **Elapsed rail stays label-only.** Fixed 24px rule. Not proportional, not
   stepped, not re-weighted. The spec's third rule stands.
5. **The flag pins to the last word.** Non-breaking space before the marker so
   it wraps together with the final word and is never orphaned on its own line.
6. **The health pill shows `Syncing · 87%`.** Syncing does not invalidate the
   battery reading the way Offline does. This is the one relaxation of the
   one-dot-one-label rule; Offline still drops the percent.
7. **`SummaryLine`'s zero copy is date-aware**: "Nothing pressed yet today" for
   the current day, "Nothing pressed" for any past day. The word "yet" is what
   lies about a finished day.
8. **The fixture day label is corrected to "Wednesday 19 August."** The date is
   right and other fixtures key off it; the day name was wrong.
9. **The Buttons tile meta counts the inaudible**: `1 inaudible`, never a bare
   `inaudible`. No segment is number-less.

## File ownership — absolute

An agent edits **only** the paths listed for it. If you need a change outside
your paths, **report it, do not make it**. This is not advisory; last pass three
agents each stayed in their directory and still shipped a silent data bug by
ignoring the shared-data rule below.

Nobody edits `lib/router/app_router.dart`. Each group exports a route map named
`<group>Routes` from `lib/screens/<group>/<group>_routes.dart`, exactly like
`lib/screens/hardware/hardware_routes.dart` does. Integration folds them in.

Nobody edits `lib/router/screens.g.dart`. It is generated. Paths and enum values
are not yours to change.

Nobody edits `lib/theme/**` or `lib/widgets/**`. Foundation owns those.

## Fixture id allocation — reserved blocks, collision-proof by construction

Ids in use today: Pushers and Bases in 4–15, Buttons 101–128,
InteractionContexts 501–556, Activities 9001–9009.

Every block below is disjoint from those and from each other. **Use only your
block. Never reuse an id from another block, and never invent an id outside
yours** — dashboard filtering matches Contexts by id, so a collision is a
silent wrong-data bug, not a compile error.

| Group | Entity | Reserved range |
|---|---|---|
| Setup | Base | 7100–7199 |
| Setup | anything else it needs | 7200–7299 |
| Buttons | Button | 1300–1399 |
| Buttons | Sound | 1400–1499 |
| Household | Pusher | 200–299 |
| Household | Household | 300–399 |
| Log edit | **none — invents nothing** | — |
| Settings | **none — invents nothing** | — |

Log edit and Settings reuse `lib/data/fixtures/activity_fixture.dart` through
the repositories. They do not add fixture data at all. If you believe you need
some, you have misread the screen — report it instead.

Each group that does invent data puts it in its own directory as
`lib/screens/<group>/<group>_fixture.dart`. Nobody edits
`lib/data/fixtures/**` except Foundation.

## Rules that are load-bearing

- **A doc comment that instructs is code.** Last pass, one wrong sentence in
  `FpStateLayer`'s docs produced the same bug in three files. If you write a
  doc comment telling other implementers what to do, you are on the hook for it.
- **`flutter analyze` does not analyze pub-cache packages.** Green analysis does
  not mean it builds. Only a real build proves a build.
- **`Container(alignment:)` inside a `Wrap`** expands to the widest bounded
  width. If a `Wrap` renders one item per row, that is why.
- **Sheets and dialogs bake their colours at push time.** Set them on the theme,
  never pass `backgroundColor`/`barrierColor` from the caller's context, or a
  live scheme change leaves near-black text on a near-black panel.
- **`LOG_DETAILS` creates an Interaction. It is not a read surface.**
  `LOG_ENTRY_EDIT` is the edit surface reached from a timeline row tap. The RN
  filenames are named the opposite way round from the screen keys.
- **`InteractionContext` is the domain's Context**, renamed to avoid colliding
  with `BuildContext`. Never alias it back.
- **The brand is two hex values**, teal.700 light and teal.400 dark. Never unify.
- Fixtures only. No network, BLE, auth, analytics or persistence in this pass.
- `cd` does not persist between Bash calls. Prefix every command.

## Push back

If the brief contradicts the code, the code wins and you tell the coordinator.
Agents correcting the coordinator has been valuable twice already this project —
the tab order and the `LOG_DETAILS` misreading were both coordinator errors
caught by agents who checked the source instead of trusting the brief. Check.

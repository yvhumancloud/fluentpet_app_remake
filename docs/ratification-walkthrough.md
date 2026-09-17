# Ratification walkthrough — all 36 screens

Written 2026-08-21. A checklist for the first time anyone sees these screens.

## Launch

```
cd /Users/yogesh-hc/Documents/new_fluentpet/fluentpet
open -a Simulator
flutter run
```

Scheme switch, without restarting — get the UDID from `xcrun simctl list devices | grep Booted`:

```
xcrun simctl ui booted appearance dark
xcrun simctl ui booted appearance light
```

The app rebuilds its theme live. **Switch schemes while sitting on each screen**, do not
restart between passes — a live switch is what catches colours baked at push time,
which is the defect class sheets and dialogs are prone to.

## There is no URL scheme

`xcrun simctl openurl` will NOT work. `ios/Runner/Info.plist` registers no
`CFBundleURLTypes`, so the paths below are not openable from the shell.

For the six screens with no in-app link, relaunch with an initial route:

```
flutter run --route='/welcome'
```

Unverified: nobody has run this app yet, so whether `--route` reaches go_router
here is reasoned from `buildRouter({String? initialLocation})` and
`MaterialApp.router`, not observed. If it does not work, the fallback is to edit
`initialLocation` in `lib/router/app_router.dart:144` and hot restart.

## The six with no in-app entry point

Nothing in `lib/` navigates to these. They are reachable only by initial route.

| Screen | Path |
|---|---|
| `WELCOME` | `/welcome` |
| `UNKNOWN` | `/unknown` — also the router's `errorBuilder`, so any bad path shows it |
| `BUG_REPORT` | `/home/home_nav/modal_nav/bug_report` |
| `SYSTEM_SELECTION` | `/home/home_nav/modal_nav/base_registration_nav/system_selection` |
| `BASE_FIRMWARE_UPDATE` | `/home/home_nav/modal_nav/base_registration_nav/base_firmware_update` |
| `PETCUBE_VIDEOS_SCREEN` | `/home/home_nav/modal_nav/petcube_videos` |

`BASE_FIRMWARE_UPDATE` having a registered route nothing navigates to is
inherited from the RN app, not a porting mistake — it is only ever rendered
inline inside the registration stepper. Both call sites exist.

`PETCUBE_VIDEOS_SCREEN` currently renders only its missing-id state: it takes
`interactionId` but matches against `activity.id`. Known defect, unfixed.

## Fixture values the parameterised screens need

Passing no parameter is also worth seeing once — every one of these has a
deliberate not-found state rather than a crash. That is by design; look at it.

| Screen | Parameter | A value that resolves |
|---|---|---|
| `BASE_EDIT` | `serialNumber` | `FPB-0A31` … `FPB-0A38` |
| `BASE_EDIT_INTERACTION_TIMING` | `seconds`, `name` | `seconds=8&name=Kitchen` |
| `BUTTON_EDIT` | `buttonId` | `101`–`110`, `121`–`128`, or `1300` |
| `BUTTON_CONVERSION` | `buttonId` | a **classic** Button only |
| `DOWNLOAD_SOUND` | `audioId`, `buttonSerialNumber` | `1400`, `1401`; `1450` = just-attached |
| `BUTTON_PAIRING` | `justPaired` | `true` |
| `HOUSEHOLD_EDIT` | `id` | `4`, `13`, `14`, `15` |
| `LOG_ENTRY_EDIT` (+ its two pickers) | `activityId` | `9001`–`9009` |
| `DASHBOARD_FILTERS` | `timeframeOnly` | `true` / omitted |
| `PETCUBE_SHOP_SCREEN` | `fromSettings` | `true` |

Serials `FPB-0A39`, `0A3A`, `0A3B` and `0A5D` belong to no Base. That is a known
fixture defect, not a rendering bug — `baseForButton` returns null and the
`BUTTON_CONVERSION → BUTTON_EDIT → DOWNLOAD_SOUND` chain dead-ends quietly.

## What to look for — the specific risks, not a general once-over

These are where the reasoning is thinnest, so weight your attention here.

1. **Sheets and dialogs, switched live.** Colours baked at push time leave
   near-black text on a near-black panel. Every sheet, every confirm.
2. **The newly invented setup widgets** — checklist circles, the QR viewfinder
   mock, the progress bar, permission rows. Designed by consistency with the
   token system, never rendered.
3. **A long utterance with a flag.** Button `127` is
   `'I want to go outside right now please'` and exists for this. The flag must
   sit with the last word. It was fixed once wrongly; `test/flag_pin_test.dart`
   now proves the layout, but nobody has seen it.
4. **Disabled controls.** They no longer differ in colour from tertiary text on
   purpose — disabled-ness is carried structurally now (missing chevron, a
   `prohibit` glyph, an outlined knob). Check the signal actually reads.
5. **The Hardware Delete row and destructive confirms.** These were invisible —
   white on white in light, 1.00:1 — until yesterday. Confirm they are now legible.
6. **Enabled-but-inert controls.** ~35 of them ripple like live controls and then
   report that nothing happened. Judge whether that reads as broken.
7. **Long lists in sheets.** Household's Country picker is 12 rows; both sheet
   helpers were unscrollable until yesterday.
8. **`DASHBOARD_MEANING` with real data** — only its empty state has ever been seen.

## Not covered by this pass

Larger text scales, landscape, a physical device, and Android. All four remain
entirely unseen. Android does not currently build in this sandbox (blocked NDK
download), which is an environment limit, not a code result.

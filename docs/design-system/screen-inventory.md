# Screen Inventory — the twelve screens the two jobs run on

Written 2026-08-19 for the Flutter rewrite. This is a **functional** inventory, not a
design. It records what each screen must carry so a redesign does not silently drop
behaviour. It designs nothing and prescribes no layout.

Vocabulary is CONTEXT.md's: Base, Button (Connect / Classic / Inaudible), Board,
Pusher (Learner / Teacher), Household, Interaction, Context, Activity, Dashboard.
The three names for the Dashboard concept (`Dashboard` in code, `Activity` in the tab
bar, `Log` in the screen enum) and the two for the Base section (`Base`, `HardwareNav`)
are kept.

All paths are relative to `fluentpet_app/` unless absolute. **`fluentpet_app/` is
read-only reference.** Line numbers are from the tree as of 2026-08-19.

Where a fact could not be established from the code it says **unknown**. Nothing here
is inferred from behaviour of a running app — the app was not run.

---

## 0. How to read this

* **Presentation / route / deep link** come from `design-system/src/data/screen-map.json`,
  which is generated from the navigator files. Where the generated deep link disagrees
  with `src/navigation/linking.ts`, both are given.
* **Phase 1 is fixtures only.** Every network call, permission prompt, BLE hop, share
  sheet and local-storage write below is flagged `[FAKE]`. None of them should be wired
  to real I/O in phase 1. Section 15 collects them.
* **Counting.** Where a figure appears it says how it was counted so it can be rechecked.

---

## 1. The shape all eight Job-1 screens share

Six of the eight Job-1 screens are the *same widget* with different arguments.
`DASHBOARD`, `DASHBOARD_BUTTON`, `DASHBOARD_CONTEXT`, `DASHBOARD_MEANING` and
`DASHBOARD_PUSHER` are thin route wrappers around `DashboardInfiniteScroll`
(`src/components/Dashboard/DashboardInfiniteScroll.tsx`), which in turn renders
`DashboardList` (`src/components/Dashboard/DashboardList.tsx`, 806 lines — the real
screen). Read section 1 before any of the per-screen sections; the per-screen sections
only record what differs.

The wrappers, in full:

| Screen | File | Body |
| --- | --- | --- |
| `DASHBOARD` | `src/Home/Dashboard/Dashboard.tsx` (119 lines) | `DashboardInfiniteScroll` + a floating action button |
| `DASHBOARD_BUTTON` | `src/Home/Dashboard/DashboardButton.tsx` (16 lines) | `<DashboardInfiniteScroll button={route.params.button} />` |
| `DASHBOARD_CONTEXT` | `src/Home/Dashboard/DashboardContext.tsx` (16 lines) | `<DashboardInfiniteScroll context={…} />` |
| `DASHBOARD_MEANING` | `src/Home/Dashboard/DashboardMeaning.tsx` (16 lines) | `<DashboardInfiniteScroll meaning={…} />` |
| `DASHBOARD_PUSHER` | `src/Home/Dashboard/DashboardPusher.tsx` (50 lines) | `DashboardInfiniteScroll` + Feed/Stats tab state + Android back override |

`DashboardInfiniteScroll` picks the header and the list type from which prop is set
(`DashboardInfiniteScroll.tsx:274-313` for the header, `:357-375` for the list type).
One Flutter widget with a mode enum, not five widgets.

### 1.1 Data on every timeline row (`DashboardItem`)

Source: `src/components/Dashboard/DashboardItem/DashboardItem.tsx:217-289`. An
Interaction (or free-standing Note — both are Activities) renders:

| Element | Field | Meaning / derivation |
| --- | --- | --- |
| Avatar | `interaction.pusher` | Who pressed. Rendered by `AvatarTypeSpecific` (`src/components/Avatar/AvatarTypeSpecific.tsx`): a Pusher named `base` (case-insensitive) → question-mark icon; a Pusher named `event note` → journal icon; anything else → initials from `getPusherInitials`. `imageUri` = `pusher.avatar_uri`. Dimmed/deselected styling when `pusher.is_hidden` (`:238`). |
| Avatar initials | derived | `src/helpers/getPusherInitials.ts` — full name if ≤3 chars; else the **shortest unique prefix** of first name, plus shortest unique prefix of surname, disambiguated against every other Pusher in the Household. If the two together exceed 3 chars they are stacked on two lines with an embedded `\n` (`:25-28`). This is a real algorithm, not a two-letter initialism. |
| Timestamp | `interaction.occurred_at` | `OccurredAt` (`DashboardItem/OccurredAt.tsx:22-26`). Two lines: `MMM Do · h:mm A` (or `MMM Do · H:mm` when the device clock is 24-hour, from `expo-localization`), then a relative age (`moment().fromNow()`) upper-cased. |
| Buttons | `interaction.buttons[]` | One badge per Button, `button.text` = its meaning. Badge colour distinguishes Connect (`button.base` present) from Classic (`DashboardItem/DashboardButtons.tsx:23`). Tappable → `DASHBOARD_BUTTON`. |
| Interpretation | `interaction.meaning` | Rendered only if present, as a badge labelled `Interpretation: {text}` (`DashboardItem/DashboardMeaning.tsx:19`). Tappable → `DASHBOARD_MEANING`. |
| Contexts | `interaction.contexts[]` | One badge each, `context.text`. Tappable → `DASHBOARD_CONTEXT`. **Rendered only when `interaction.pusher` is truthy** (`DashboardItem.tsx:265-270`) — an unassigned Base row never shows Contexts even if it has them. |
| Note | `interaction.note` | 2 lines max. On iOS passed through `truncateNote` first, which keeps the first two `\n`-separated lines and appends `...`; on Android the raw string is used (`:271-275`, helper at `:101-108`). |
| Flag (star) | `interaction.is_flagged` | Filled amber star vs outline. Tapping toggles it — a **PATCH** — and vibrates 100 ms (`:132-139`). Hidden while multi-select is active (`:160`). |
| Ellipsis | — | Opens the per-item action sheet. Hidden for unselected rows during multi-select (`:80-81`, `:169`). |
| ASSIGN | derived | Rendered only when the Pusher resolves to the literal `base` (`:277`, `isPusherBase`), i.e. the Base recorded the press but nobody has been attributed. Opens `SelectPusherModal`. |
| Selection check | local | Filled check-circle overlay on the avatar when the row is in the multi-select set (`:241-250`). |

### 1.2 Interactions on a timeline row

| Gesture | Behaviour | Source |
| --- | --- | --- |
| Tap row | If nothing selected → open `LOG_ENTRY_EDIT` for that Interaction. Otherwise → toggle its selection. | `DashboardList.tsx:488-496` |
| Long-press row | If nothing selected → start multi-select with this row. Otherwise → toggle. | `:498-505` |
| Tap avatar | If items are selected → toggles selection. Else if the row has a Pusher → `DASHBOARD_PUSHER`. Else → open the edit screen. | `:565-579` |
| Long-press avatar | No-op while items are selected. Else, for a visible non-Note Pusher → `HOUSEHOLD_EDIT` with the Pusher id. For a hidden Pusher or a Note → `DASHBOARD_PUSHER`. | `:541-563` |
| Tap Button badge | → `DASHBOARD_BUTTON` (or toggles selection during multi-select). | `:581-591` |
| Tap Context badge | → `DASHBOARD_CONTEXT`. No-op during multi-select. | `:593-602` |
| Tap Interpretation badge | → `DASHBOARD_MEANING`. No-op during multi-select. | `:604-611` |
| Tap star | Toggle `is_flagged`. `[FAKE]` PATCH. | `DashboardItem.tsx:137-139` |
| Tap ASSIGN | Opens `SelectPusherModal`. `[FAKE]` PATCH on choose. | `DashboardItem.tsx:196-206` |
| Tap ellipsis | Opens the single- or multi-item action sheet. | `DashboardList.tsx:507-539` |
| Pull to refresh | Refetch page 0 and flush all loaded pages. | `DashboardList.tsx:672-682` |
| Scroll to end | `onEndReached` at threshold 0.25 → load the next page. | `DashboardList.tsx:758-759` |

### 1.3 The two action sheets

**Single item** — options are built dynamically, so the index order changes with the
flags (`src/components/Dashboard/helpers/getSingleItemActionSheetOptions.ts`). In
order, when enabled:

1. `What could this mean?` — only if `assignMeaningEnabled` **and** the Interaction has ≥1 Button (`DashboardList.tsx:518-519`). `assignMeaningEnabled` is **admin-only** (`src/hooks/useFeatureFlags.ts:34`).
2. `Edit` — always.
3. `Share` — only if the Interaction has a Pusher whose id is neither null nor `-1` (`:516`).
4. `Duplicate` — if `duplicationEnabled` (hardcoded `true`).
5. `Split` — if `splittingEnabled` **and** the Interaction has >1 Button **and** `interaction.origin === "fp_connect_base"` (`:520-523`). Splitting a Base-grouped multi-press back into separate Interactions.
6. `Delete` — always, marked destructive.
7. `Cancel`.

**Multiple items** (`getMultipleItemsActionSheetOptions.ts`):

1. `Assign` — if `bulkAssignMeaningEnabled` (hardcoded `true`) and the selection contains no Notes. Despite the flag's name this opens `SelectPusherModal` and bulk-assigns a **Pusher**, not a meaning (`DashboardList.tsx:406-407`, `:431-450`).
2. `Merge` — if `mergeEnabled`, no Notes selected, and ≥2 items selected.
3. `Delete` — destructive.
4. `Cancel` — explicitly does nothing, not even deselect ("Users prefer we do nothing", `:424-426`).

Merge and Delete both go through `multiConfirmationAlert` first: title "Are you sure?",
body `The selected N item(s) will be merged|deleted`, Cancel + destructive Confirm
(`helpers/multiConfirmationAlert.ts`). Single-item Delete uses
`deleteConfirmationAlert` — "Are you sure? / This will be permanently deleted."
(`src/helpers/deleteConfirmationAlert.ts`).

### 1.4 Multi-select mode

Entered by long-pressing a row. While active (`DashboardList.tsx:191-208`):

* The **navigation-bar title becomes `N SELECTED`** and the left header button becomes a close (X) that clears the selection. This replaces the drawer button on `DASHBOARD` and the back button on the nested screens. A redesign that keeps a static app bar loses this.
* Per-row star buttons disappear; the ellipsis shows only on selected rows.
* Selection is cleared automatically when the screen loses focus (`:185-189`).

### 1.5 Pagination model

* Page size **45** (`DashboardInfiniteScroll.tsx:50`), passed as `per_page`. The API hook's own default is 25 (`src/api/hooks/useInteractions.ts:11`) and applies to callers that omit it — `UnassignedPressesBanner` is one.
* Pages are held in a **map keyed by page number** (`interactionsPaginated`), then flattened in ascending key order into one list (`:187-200`). This exists so that a single page can be re-fetched in place after an edit without discarding the rest.
* `page.current` is a **ref**, not state: `{ pageNumber, isLastPage, flushInteractions }` (`:69-79`).
* `isLastPage` is set when a page returns fewer than 45 rows (`:144-146`). There is no total-count-based termination.
* After an inline edit, `setIsUpdateInteractions(true)` triggers a refetch of just the page containing the edited index — `Math.floor(selectedActivityIndex / 45)` (`:173-185`).
* Any change to tab, sort or filters resets to page 0 and flushes (`:202-208`).
* Pull-to-refresh flushes; `onLoadMore` does not.
* The React Query cache key includes `Object.values(options)`, and `options` contains `onSuccess`/`onError` closures that are new on every render (`useInteractions.ts:57`). Whether this thrashes the cache in practice is **unknown** — flagged because a naive Flutter port of "the key is everything in the request" will behave differently.

### 1.6 Sticky-header trick (affects the Flutter list structure)

`DashboardList` uses a `FlashList` with `stickyHeaderIndices={[0]}`. To make the
settings row sticky *below* the stats header it **prepends a literal empty object `{}`
to the data array** and special-cases index 0 in `renderItem`
(`DashboardList.tsx:459-462`, `:738-746`). When the list is empty the same widget is
rendered as part of `ListHeaderComponent` instead (`:659-670`), because
`ListEmptyComponent` cannot coexist with a sticky header. `isLastItem` (used to
suppress the final divider) is computed differently in the two cases (`:464-467`).
Flutter should express this as a real pinned-header sliver; do not port the sentinel.

### 1.7 States

| State | Behaviour | Source |
| --- | --- | --- |
| Loading | Full-screen centred spinner overlaid on the content by `ScreenWrapper`, shown when any of the pushers / preferences / interactions queries is fetching **and** we are not in a pull-to-refresh | `DashboardInfiniteScroll.tsx:378`, `src/components/ScreenWrapper.tsx:65-69` |
| Refreshing | Native pull-to-refresh spinner instead of the overlay | `:378`, `DashboardList.tsx:672-682` |
| Empty | `ThreeButtonsBanner` illustration + "You don't have any logs yet" / "Record a button press event to get started". When `connectFeaturesEnabled` is false, instead: the banner plus an `ADD FIRST ENTRY` button → `LOG` | `DashboardList.tsx:684-707` |
| **Empty because filtered** | **Not distinguished.** The same "You don't have any logs yet" copy shows when filters or a search term hide everything. | same |
| Error | No error UI on the list. `onError` only unwinds the page pointer (`DashboardInfiniteScroll.tsx:148-154`). Mutations surface errors as a flash message (`showErrorMessage`) | `DashboardList.tsx:319`, `:371`, `:388`, `:446` |
| Offline | A red "Unable to connect to the Internet." banner is injected above the content by `ScreenWrapper` when `isOffline && shouldShowOfflineStatus` | `ScreenWrapper.tsx:63`, `src/components/OfflineBanner.tsx` |
| Impersonation | A blue "LOGGED IN AS x" strip above everything when `globalState.loginAs` is set | `ScreenWrapper.tsx:46-52` |
| Non-production backend | A 3px coloured top border: red = staging, blue = IoT, orange = local | `ScreenWrapper.tsx:29-40` |
| Permission-denied | None on these screens | — |

The impersonation strip, environment border and offline banner are **global chrome on
every one of the twelve screens** (all use `ScreenWrapper`). They are easy to lose in a
redesign.

---

## 2. `DASHBOARD` — the Activity timeline

* **Route** `Dashboard` · **Title** `ACTIVITY FEED` · **Tab label** `Activity` (derived by `TabBar` from the navigator name `ActivityNav` minus `Nav`) · **Presentation** Stack, first screen of `ActivityNav` inside `TabNav`.
* **Deep link** `/home/home_nav/modal_nav/tab_nav/activity_tab/activity`; accepts `defaultDashboardTab`.
* **Impl** `src/Home/Dashboard/Dashboard.tsx`. **Annotation** `three-names-dashboard`.
* **Job** Job 1, and the app's default landing tab when `isAlpha` is off (`TabNavigator.tsx:53`). The single most central screen in the product.

**Navigated to from:** the Activity tab; the drawer (`HomeNavigator.tsx:102`); after
saving an event from `LOG_DETAILS` (`LogDetailsNewScreen.tsx:192-198`) and from the
edit screen (`LogDetailsEditScreen.tsx:232`); from device setup completion
(`SystemSelection.tsx:28`); and from a **button-pressed push notification**, which
deep-links with `defaultDashboardTab: All` (`src/Home/PushNotification/helpers/onNotificationOpened.ts:98-100`) `[FAKE]`.

**Navigated to:** `LOG` and `LOG_DETAILS` (FAB), `DASHBOARD_FILTERS`,
`DASHBOARD_PUSHER` / `_BUTTON` / `_CONTEXT` / `_MEANING`, `LOG_ENTRY_EDIT`,
`HOUSEHOLD_EDIT`.

### Header (stats block)

Two figures, side by side (`DashboardHeader/DashboardHeader.tsx:24-33`):

* **Communication Events** — `interactionsData.communication_events`
* **Modeling Events** — `interactionsData.modeling_events`

Both run through `formatLargeNumber` (`src/helpers/formatLargeNumber.ts`): under 1000
plain; 1000+ as `1.5k`, dropping a trailing `.0` (`11000` → `11k`). Both fall back to
`0` while data is absent, so the header shows **`0 / 0` during first load** rather than
a skeleton.

Below it a two-way segmented control, **All / Unassigned** (`DashboardTab`), rendered
only when `connectFeaturesEnabled` (`DashboardHeader/DashboardFilter.tsx:17-29`).
Selecting a tab resets pagination and refetches.

### Sticky settings row (`SettingsHeader.tsx`)

* **"Snooze press notifications"** with a switch. On = `PushNotificationFrequency.NONE`, off = `ALL`. Writing it POSTs a user preference; `ALL` is written as `null` to mean "reset to default" (`DashboardInfiniteScroll.tsx:256-268`) `[FAKE]`. The switch is disabled while the preference query is fetching or a write is in flight.
* **Filters icon**, with a small red dot when the current filters differ from `DEFAULT_FILTERS` by deep equality (`DashboardInfiniteScroll.tsx:342`).

### Unassigned-presses banner

`UnassignedPressesBanner.tsx` runs its own `useInteractions(0, {tab: Unassigned})`
query purely to read `.total`, and renders `You have N unassigned event(s)` with a
question-mark avatar. It **returns `null` when the count is 0 or still unknown**
(`:42-44`). Tapping it switches the tab to Unassigned and scrolls to top. It is hidden
on `DASHBOARD_PUSHER` (`DashboardInfiniteScroll.tsx:350`). There is a dead `ASSIGN`
button behind `{false && …}` (`:57`) — do not resurrect it without a decision.

### Floating action button

Bottom-right circular `+` (`Dashboard.tsx:87-89`). Opens an action sheet with:
`Log Button Press` → `LOG`; `Add Journal Entry` → `LOG_DETAILS` pre-set to the
Household's "event note" Pusher with an empty Button list; `Cancel`
(`Dashboard.tsx:48-78`). The Journal option **passes `boardId!`** — if the Board query
has not resolved this is `undefined` at runtime.

### Not presentational

`[FAKE]` GET `/api/v2/interactions`, GET `/api/v1/pushers`, GET `/api/v1/preferences`,
GET `/api/v2/boards/default`, POST `/api/v1/preferences`, plus everything in §1.

### Confusing / apparently broken

* `Dashboard.tsx:28-29` — `const boardQuery = useBoard();` is used for nothing except `console.log(boardQuery.isFetched)`. It is a leftover debug line, **and** the only thing that populates the React Query cache key `[BOARD, "date"]` that `BASES` silently depends on (see §9). Do not "clean it up" without fixing `BASES`.
* Sorting: `ActivitySortType` (Recently pressed / Recently logged) is read from the `activity_sort` user preference and sent to the API (`DashboardInfiniteScroll.tsx:100`, `:218`), but **there is no UI anywhere to change it**. `src/components/Dashboard/ActivitySort.tsx` implements the picker and is imported by nothing (verified by `grep -rn ActivitySort src` — only its own file, the model enum, and the type import in `DashboardInfiniteScroll`). Either wire it up in the redesign or drop the preference; do not port dead code.
* `setDefaultPafination` — typo, spelled that way at both the definition (`:250`) and the two call sites.

---

## 3. `LOG` — record a Button press manually

* **Route** `Log` · **Title** `LOG` · **Presentation** **Modal**, registered in `ModalNavigator` (`ModalNavigator.tsx:135-139`). Header back image is a close (X) for the whole modal stack (`:112`).
* **Deep link** `/home/home_nav/modal_nav/log`. No params.
* **Impl** `src/Home/Log/LogScreen.tsx` (288 lines). **Annotation** `three-names-dashboard`.
* **Job** Job 1's write side. Reached from the `DASHBOARD` FAB and from the timeline empty state.

### Data displayed

* Prompt "Who pressed the Buttons?" then a **horizontal Pusher strip** (`components/PusherList.tsx`): every active Household Pusher that is a human or animal (Notes and the Base pseudo-Pusher excluded), sorted Learners first (`LogScreen.tsx:68-71`, `_.sortBy` on `is_human`). Avatar background differs for Teacher vs Learner (`PusherList.tsx:40-42`). The **first Pusher is pre-selected** (`LogScreen.tsx:83-87`).
* An `ADD` circle at the head of the strip, shown only when the Household is **missing** either a Learner or a Teacher (see the naming bug below). Opens `HOUSEHOLD_ADD`.
* **Selected Buttons area** — the Buttons tapped so far, each removable with an ✕ (`src/components/Board/SelectedButtonsDragAndDrop.tsx`). When empty it shows a `ThreeButtonsBanner` with "Tap on a Member and a Button to get started".
* **Buttons Board** (`src/components/ButtonsBoard.tsx`) — search field, optional speech-to-text mic, sort control, then a `+` badge and one badge per active Button, with the `inaudible` Button pinned last as a special badge (`:218-230`). Badge colour distinguishes Connect from Classic (`:157-159`).
* **LOG EVENT** primary button pinned to the bottom safe area. Hidden on Android while the keyboard is up (`LogScreen.tsx:74`).

### Controls

| Control | Behaviour |
| --- | --- |
| Tap Pusher | Select (does not submit) |
| Tap Button badge | Append to the selected list, clearing the search box (`ButtonsBoard.tsx:148-151`). The same Button can be added repeatedly. |
| Long-press Button badge | Action sheet: `Edit` → `BUTTON_EDIT`; `Archive` (destructive, Classic/Inaudible only — suppressed for `type === "connect"`) → confirm alert → PATCH `is_hidden: true`; `Cancel` (`LogScreen.tsx:109-154`) |
| Tap ✕ on a selected Button | Remove that one occurrence |
| Search field | Prefix match, case-insensitive, on `button.text` (`ButtonsBoard.tsx:73-83`). Cleared on screen blur. |
| `+` badge | `BUTTON_ADD`, **pre-filling the new Button's name with the search text** when the search matched nothing (`ButtonsBoard.tsx:209-214`) |
| Sort control | Sort by A-Z / Introduction date / Most used (`components/ButtonSort.tsx:29-33`). Persists as the `button_sort` user preference `[FAKE]`. |
| Mic | Speech-to-text; matches spoken words to Button text with naive singular/plural fallback (`ButtonsBoard.tsx:92-119`). Gated on `speechToTextEnabled`, hardcoded **false** (`useFeatureFlags.ts:45`). `[FAKE]` — treat as out of scope for phase 1. |
| LOG EVENT | → `LOG_DETAILS` carrying the selected Buttons, the selected Pusher, the Board id, and an `onReturn` callback |

### Validation / constraints

* LOG EVENT is disabled when there are no active Pushers **or** no Buttons selected (`LogScreen.tsx:72-73`).
* Tapping a non-Note Pusher with zero Buttons selected raises an alert: *"To log an event, tap Buttons, then tap a Learner."* (`:159-161`). A Note Pusher may proceed with zero Buttons.

### States

Loading spinner (board + preferences), plus an `isUpdating` spinner while archiving.
**No empty state for a Board with no Buttons** — the board area shows only the `+`
badge. The screen scrolls to the top whenever it regains focus (`:89-93`).

### Confusing / apparently broken

* `src/Home/Log/helpers/isAtLeastOneLearnerAndTeacher.ts:13` **returns the negation of its own name** (`return !isAtLeastOneLearnerAndPusher`). Consumed as `shouldRenderAddMember`, so the behaviour is right and the name is a lie. In Flutter call it `isMissingLearnerOrTeacher`.
* `src/components/Board/SelectedButtonsDragAndDrop.tsx` **has no drag and drop.** It is a wrap row of chips with a delete ✕. Do not build a reorderable list because of the filename.
* `useButtons` sets `data.id = res.data[0].board_id` (`src/api/hooks/useButtons.ts:24`) — this **throws on a Board with zero Buttons**. `LOG`, `CLASSIC_BUTTONS` and `DASHBOARD_FILTERS` all depend on it. Phase 1 fixtures must include a zero-Button Board so the empty case gets designed.

---

## 4. `LOG_DETAILS` — annotate and save a new Interaction

* **Route** `LogDetails` · **Title** `LOG DETAILS` · **Presentation** Stack, first screen of `LogDetailsNav`, which is itself a headerless screen inside the modal stack.
* **Deep link** `/home/home_nav/modal_nav/log_details_nav/event_add`. Its `buttonPresses` param is JSON-parsed from the URL (`linking.ts:34-38`).
* **Impl** `src/Home/LogDetails/LogDetailsNewScreen.tsx` (392 lines).
* **Params** `buttonPresses`, `buttonPusher?`, `boardId?`, `occurredAt?`, `selectedContexts?`, `note?`, `onReturn?`.
* **Header left** is a **close (X)** that pops and then calls `route.params.onReturn()` (`LogDetailsNavigator.tsx:58-67`).

**Reached from:** `LOG` (LOG EVENT), the `DASHBOARD` FAB (`Add Journal Entry`), and
`Duplicate` on a timeline row — which first **GETs the full Interaction** and pre-fills
everything including `occurredAt` (`DashboardList.tsx:244-274`).

**Note:** the sibling `LogDetailsEditScreen.tsx` (619 lines) is a *different* screen —
`LOG_ENTRY_EDIT`, registered in `LogEntryEditNavigator.tsx:49-56`. It is where a tap on
a timeline row lands. It is out of scope for these twelve but is the natural companion.

### Data displayed / editable

| Field | Detail |
| --- | --- |
| Pusher avatar + name | `AvatarTypeSpecific`. Name shown only for a human/animal Pusher (`:288-292`). Tapping opens `LOG_DETAILS_EDIT_PUSHER` — **suppressed when the Pusher is the "event note" Pusher** (`:286`). |
| Selected Buttons | Chips. **Editable only when duplicating** — `onButtonPress` is passed only if `isDuplicatingEntry`, which is `!!initialOccurredAt` (`:89`, `:297`). From `LOG` you cannot correct a wrong Button here. |
| Contexts | `Contexts` block: chips for the selected ones plus an "Add Context" link opening a bottom-sheet checklist. Hidden entirely for the Note Pusher (`:269-273`). The "Add Context" link is hidden for a **Teacher** (`showAddContext={!selectedPusher?.is_human}`, `:304`). |
| "Choose learners involved" | Only when the Pusher is a Teacher. A horizontal multi-select of Learners (`:308-319`) — the modelling attribution. |
| Note | Multiline free text, placeholder "Write a note", min height 120 (`src/components/LogEntryEdit/Notes.tsx`). |
| Timestamp | Date select, time select and a **separate 2-digit seconds text field** (`src/components/LogEntryEdit/DateAndTime.tsx`). Seconds are clamped to 59 and stripped to digits (`:43-55`); empty means 0. The pickers cannot select a future time (`maximumDate={new Date()}`, `:342`). 12/24-hour follows the device. |

### Domain rules baked in

* **Context list depends on Pusher type**: `useContexts(teacher|learner)` — the filter changes with `selectedPusher.is_human` (`:74-76`) `[FAKE]`.
* Selecting a Teacher auto-selects the Context literally named **"Modeled"** (`:122-134`); switching back to a Learner removes it (`:212-226`); switching Learner→Teacher clears all Contexts.
* If the Household has exactly one Learner, that Learner is auto-added to the modelled set (`:93-99`).
* The Note Pusher is excluded from the Pusher picker by id `-1` (`PusherTypes.JOURNAL`, `src/Home/LogDetails/constants.ts`).

### Actions

* **SAVE EVENT** → POST, then navigate to `DASHBOARD` (`:190-200`).
* **SAVE EVENT & LOG ANOTHER** → POST, call `onReturn(true)` to clear the caller's selection, then back to `LOG` (`:202-210`). Hidden when the Pusher is a Note.
* Both are disabled while submitting. There is no client-side required-field validation; the only guard is `if (!boardId && !board?.id) { console.error("No board ID!"); return; }` (`:159-164`) — which **silently does nothing**, leaving the user staring at an unresponsive button.

### States

Loading spinner while contexts/pushers/board load or while submitting. No empty state.
Errors surface as a flash message from the mutation hook
(`src/api/hooks/useCreateInteraction.ts:57-59`).

---

## 5. `DASHBOARD_FILTERS` — the filter sheet

* **Route** `DashboardFilters` · **Title** `ACTIVITY FILTERS` · **Presentation** **Modal**, registered in `ModalNavigator.tsx:235-248`. Header right is a **`Reset` text button**.
* **Deep link** generated as `/home/home_nav/modal_nav/activity_filters`. **`linking.ts:113` actually nests the `activity_filters` segment under `activity_tab`**, i.e. under `ActivityNav`, where the screen is not registered. Whether the deep link resolves at runtime is **unknown**; treat the path as unreliable.
* **Impl** `src/Home/DashboardFilters/DashboardFilters.tsx` (381 lines).
* **Params** `passedFilters`, `editTimeframeOnly?`, and three **function** params: `onFiltersUpdated`, `onReset`, `onReturn` (`ModalNavigator.tsx:76-82`). Passing closures through navigation params does not translate to Flutter — see §14.

**Reached from:** the filters icon on any `DashboardInfiniteScroll` screen
(`DashboardInfiniteScroll.tsx:320-327`). On `DASHBOARD_PUSHER` it is opened with
`editTimeframeOnly: true`, which hides everything except Timeframe (`:324`,
`DashboardFilters.tsx:278`).

### Sections

Six `FiltersSection` blocks in the file (counted with `grep -c "<FiltersSection"` = 6);
five of them are hidden when `editTimeframeOnly`:

1. **Timeframe** — Start Date and End Date, each a calendar picker. Start is capped by End and End by Start, and neither can exceed today (`DateFilter.tsx:44-48`). Display format `MMMM Do yyyy`.
2. **Household Members** — one tag per active Pusher, Note Pushers excluded (`:60-63`). Multi-select by id.
3. **Buttons** — matched **by meaning (the Button's `text`), not by id** (`src/model/dashboard.ts:27`). Tag list is the Board's active Buttons with `inaudible` moved to the front.
4. **Context** — one tag per Context, by id.
5. **Bases** — one tag per Base, labelled `base.name` falling back to `base.serial_number` (`:71-75`), by id.
6. **More Filters** — see below.

Sections 3, 4 and 5 additionally carry four setting tags: **Select All**, **De-Select
All**, and an **Any / All** match-mode pair (`FilterTags.tsx:41-70`). "Any" vs "All" is
stored per facet in `filters.searchType.{buttons,contexts,bases}`.

Each section starts **collapsed unless it already has active filters**, and shows a red
dot in its header when it does (`FiltersSection.tsx:28`, `:38`).

### More Filters (`MoreFilters.tsx`)

* A free-text **Search (case insensitive)** field → `filters.searchText`.
* Four tri-state tag groups:
  * **Journal Entries** — Show / Hide / Show Only Journal Entries
  * **Entries With Notes** — Show / Hide / Show Only Entries w/ Notes
  * **Flagged Entries** — Show / Hide / Show Only Flagged Entries
  * **Button Presses** — All / Single Button / Multi-Button

### Cross-field rules

* Choosing **"Show Only Journal Entries"** clears the Pusher selection (`helpers/applyFilter.ts:36-40`).
* Conversely, touching **any** Pusher tag or Journal-Entries tag downgrades an existing `showOnly` back to `show` (`DashboardFilters.tsx:103-126`).
* `moreFiltersIsActive` is true if any of the four tri-states is off its default or the search text is non-empty (`:77-82`).

### Actions

* **SAVE** (bottom, safe-area pinned) — disabled by deep equality against the filters as received (`:362`). On press: `onReturn()` (resets the caller's pagination), `onFiltersUpdated(filters)`, then pop.
* **Reset** in the header — sets `DEFAULT_FILTERS` locally. It does **not** save or close; the user must still press SAVE.
* Back/dismiss without SAVE discards everything.

### States

While `pushers`, `buttons` or `contexts` are missing the body renders **`null`** — a
blank screen behind the loading overlay (`:239`, `:246`). There is no error state and
no empty state.

### Confusing / apparently broken

* `const sortedButtons = userDefinedButtons && inaudibleButton && [inaudibleButton, ...userDefinedButtons]` (`:57-58`) — if the Board has **no `inaudible` Button, `sortedButtons` is `undefined` and the entire Buttons filter section renders zero tags.** Very likely a real bug.
* `basesQuery` is deliberately **not** in the `queries` loading array (`:45`), so the Bases section can render empty while it is still loading.
* "Select All" for Buttons uses the unsorted `buttons` list while the tags come from `sortedButtons` (`:174` vs `:66`) — the two can disagree about `inaudible`.
* `TIMEFRAME_FILTER_TAGS` in `constants.ts:17-46` defines seven relative presets (All Time / Today / Last 2 Days / 3 Days / 7 Days / 2 Weeks / 30 Days) and is **imported by nothing** (verified: `grep -rn TIMEFRAME_FILTER_TAGS src` returns only its own definition). Correspondingly, `filters.sinceDate` is **never set by this screen** — yet `PusherHeader` and `PusherStats` both read it (§7). This is a half-removed feature; decide deliberately whether the redesign restores relative presets or drops `sinceDate`.

---

## 6. `DASHBOARD_BUTTON` / `DASHBOARD_CONTEXT` / `DASHBOARD_MEANING` — facet timelines

Three near-identical screens. Everything in §1 applies; the differences are:

| | `DASHBOARD_BUTTON` | `DASHBOARD_CONTEXT` | `DASHBOARD_MEANING` |
| --- | --- | --- | --- |
| Route | `DashboardButton` | `DashboardContext` | `DashboardMeaning` |
| Title | `BUTTON ACTIVITY` | `CONTEXT ACTIVITY` | `MEANING ACTIVITY` |
| Deep link | `…/activity_tab/activity_button` | `…/activity_context` | `…/activity_meaning` |
| Param | `button: Button` | `context: Context` | `meaning: Meaning` |
| API filter | `button_id` | `context_id` | `meaning_id` |
| Header | `ButtonHeader` | `ContextHeader` | `MeaningHeader` |
| Header content | `interactionsData.total` under the caption **"Presses"** + a pill showing `button.text` | same but caption **"PRESSES"** (upper-case) + grey pill with `context.text` | caption **"PRESSES"** + grey pill with `meaning.text` |

All three are Stack screens in `ActivityNav`, reached only by tapping the corresponding
badge on a timeline row. All three suppress the sticky settings row and the unassigned
banner (`DashboardInfiniteScroll.tsx:329-332`) — **so there is no filters icon and no
snooze switch on these three**, and the filter state they inherit is whatever the
parent had.

The caption casing difference ("Presses" vs "PRESSES") is a real inconsistency in the
current app (`ButtonHeader.tsx:21` vs `ContextHeader.tsx:22`, `MeaningHeader.tsx:22`).
Pick one.

Empty state is the generic "You don't have any logs yet", which reads oddly on a facet
screen that was reached by tapping a badge that plainly exists.

---

## 7. `DASHBOARD_PUSHER` — one Pusher's feed and statistics

* **Route** `DashboardPusher` · **Title** `ACTIVITY` · **Presentation** Stack in `ActivityNav`.
* **Deep link** `/home/home_nav/modal_nav/tab_nav/activity_tab/activity_pusher`. **Param** `pusher: Pusher`.
* **Impl** `src/Home/Dashboard/DashboardPusher.tsx` + `DashboardHeader/PusherHeader.tsx` + `PusherStats/`.

**Reached from:** tapping or long-pressing an avatar on the timeline
(`DashboardList.tsx:559`, `:573`) and from the Household screen
(`src/Home/Household/Household.tsx:150-151`).

### Header (`PusherHeader.tsx`)

* Avatar, selectable-styled by `!pusher.is_hidden`.
* Pusher name + a **share icon** — but only when `pusher.name !== "Event Note"`, an exact-case string comparison (`:75`) that does not match the lower-cased `isPusherEventNote` predicate used everywhere else. Share opens `ShareModal` in "status" mode `[FAKE]`.
* Three figures: **Days**, **Buttons**, **Presses**.
  * *Days* = if `filters.sinceDate` is set, `ceil(now − sinceDate in days)`; otherwise `pusher_stats.days_since_oldest_entry` (`:48-52`). As noted in §5, nothing currently sets `sinceDate`, so the first branch is dead today.
  * *Buttons* = `pusher_stats.active_buttons`; *Presses* = `pusher_stats.number_of_buttons_pressed`. Both `formatLargeNumber`ed.
* A **Feed / Stats** segmented control (`PusherFeedTab`).

### Stats tab (`PusherStats/PusherStats.tsx`)

Rendered inside a plain `ScrollView`, with the timeline `FlashList` hidden by
`display: "none"` rather than unmounted (`DashboardList.tsx:656-657`, `:723`).

| Block | Content | Notes |
| --- | --- | --- |
| Average Daily Presses | `floor(number_of_buttons_pressed / days)` | Returns `"0"` when either input is 0, and the literal **`"<1"`** when the quotient floors to 0 (`helpers/getAverageDailyPresses.ts`). Has a unit test. |
| Unique Buttons Pressed | `number_of_buttons_distinct_by_name` | |
| Most Pressed / Least Pressed | `most_/least_frequent_learner_button_presses` | Numbered list `1. text` + count |
| Most Modeled / Least Modeled | `most_/least_frequent_teacher_button_presses` | **Learner only** — hidden when the Pusher is human or a Note (`:43`, `:79`) |
| Common Usage Types | `most_frequent_contexts`, first 5 in the left column, items 6–10 in the right | **Learner only**. Right column omitted entirely when ≤5 (`:38-42`) |
| Most Frequent Combination | `most_frequent_button_combination.buttons` as non-tappable badges | Whole block hidden when the array is empty (`:110`) |

Empty sub-states: each Most/Least list shows the literal **"None"** when empty
(`ButtonPresses.tsx:23-24`); usage types show "None" only for the left column
(`UsageTypes.tsx:15-17`). If `pusher_stats` is absent the whole stats tab is a blank
white filler view (`DashboardList.tsx:650-652`).

### Other behaviour

* The header's left button is overridden: on **Android** it `reset`s the stack to `DASHBOARD` rather than `goBack`, because arriving from another tab makes `goBack` leave the Activity tab (`DashboardNavigator.tsx:52-68`).
* The **Android hardware back button** is separately intercepted with the same reset (`DashboardPusher.tsx:20-38`).
* The unassigned banner is suppressed here; the settings row (snooze + filters) is not.
* Opening filters from here passes `editTimeframeOnly: true`.

---

## 8. Job 2 shape — Base health

Job 2's four screens have far less shared machinery. `BASES` is the surface that
answers "battery and online health at a glance"; `BASE_EDIT` is where the detail lives.

Battery is rendered by two different, **inconsistent** components:

* `src/components/BatteryLevel/BatteryLevel.tsx` (Base battery, and Button battery on the edit screen header): >90 full, >64 three-quarters, >45 half, >20 quarter, ≥0 empty, `-1` charging, `undefined` unavailable. Green / green / green / **orange** / **red** / blue / grey.
* `src/Home/Base/helpers/useButtonBattery.ts` (per-Button rows in the linked-Button list): ≥25 full, ≥10 quarter, ≥0 empty, else unavailable. **Three buckets, different thresholds, no half or three-quarters.**

The redesign should unify these; if it does, say so, because the thresholds encode
"the backend warns the user at 20%" (`BatteryLevel.tsx:24`).

---

## 9. `BASES` — the Hardware list

* **Route** `Bases` · **Title** `HARDWARE` · **Tab label** `Hardware` · **Presentation** Stack, first screen of `HardwareNav` inside `TabNav`.
* **Deep link** `/home/home_nav/modal_nav/tab_nav/bases_nav/bases`. No params.
* **Impl** `src/Home/Base/BasesScreen.tsx` (205 lines). **Annotation** `base-hardware`.
* **Job** Job 2, primary.

**Reached from:** the Hardware tab; the base-registration flow's return
(`BaseRegistration.tsx:356`); `DownloadSound.tsx:55`; and two **push notifications** —
low Base battery and Button unlinked — which deep-link straight here
(`onNotificationOpened.ts:53`, `:154`) `[FAKE]`.

### List content

A `FlatList` over `bases`, with the **Buttons tile injected before the first row**
(`:99-103`) and repeated in the empty state (`:175`).

**Buttons tile** (`components/ClassicButtonsList.tsx`) — heading "Buttons", "Total
Buttons: N", and a Button product image. N = every **active** Button on the Board minus
`inaudible` (`:20-23`). Note this counts **all** Buttons, Connect included, despite the
destination being `CLASSIC_BUTTONS`. Tap or long-press → `CLASSIC_BUTTONS`. Shows a
spinner in place of N until the Board query resolves.

**Base row** (`components/BaseItem.tsx`) — per Base:

| Field | Source |
| --- | --- |
| Name | `base.name`, falling back to the literal `"Base"` (`helpers/baseName.ts`) |
| Battery icon | `base.battery_level ?? base.shadow.state.reported.bat_level`, `parseInt`ed (`:30-31`, `:51`). Rendered inline **inside** the title Text node. Hidden entirely when both are undefined. |
| `ID:` | `base.serial_number` |
| `Linked Buttons:` | count from `useBaseButtonMetadata` — spinner until fetched |
| Image | Static Base product image |

The Base's **`last_online_at` is not shown on this screen** — only inside `BASE_EDIT`.
For a screen whose stated job is "online health at a glance", that is the single
biggest gap to consider.

### Controls

* Tap a Base row → `BASE_EDIT` with its serial number.
* Long-press a Base row → action sheet `Edit` / `Delete` (destructive) / `Cancel`. Delete goes through the generic confirm alert then **DELETE `/api/v1/bases/{serial}`** `[FAKE]`.
* Pull to refresh — invalidates the `BASES` and `BUTTONS` query caches.
* **CONNECT A BASE** button pinned at the bottom. Before navigating it **reads camera, foreground-location and notification permission status** and jumps straight to `BASE_REGISTRATION` if all are granted, otherwise to `BASE_SETUP_PERMISSIONS`. iOS checks camera + notifications; Android also checks location (`:117-143`) `[FAKE]`.

### States

* Loading: full-screen overlay (also shown while a delete is in flight).
* Refreshing: native pull-to-refresh.
* **Empty**: the Buttons tile followed by *"You don't have any bases yet!"* (`:172-183`). The CONNECT A BASE button remains.
* Offline: on focus this screen re-enables the global offline banner via `setShouldShowOfflineStatus(true)` — the device-setup flow disables it, and `BASES` is what turns it back on (`:46-50`). Easy to lose.
* Error: none.

### Confusing / apparently broken

* **`Linked Buttons` can spin forever.** `BaseItem` calls `useBaseButtonMetadata(base)` with no sort argument (`BaseItem.tsx:29`); inside, that becomes `useBoard(undefined, { enabled: !!undefined })` — i.e. **the query is disabled** (`helpers/useBaseButtonMetadata.ts:16-18`). It returns `isFetched: board !== undefined`, which is only true if some *other* component already populated the React Query cache under `[BOARD, "date"]`. The only such component is the otherwise-pointless `useBoard()` in `Dashboard.tsx:28`. So the Linked Buttons count on the Hardware tab depends on the user having visited the Activity tab first. Design the loading and the "0 linked" states explicitly.
* A `<View>` containing the battery icon is nested inside a `<Title1>` text node (`BaseItem.tsx:49-53`) — layout-fragile in RN and not a pattern to reproduce.

---

## 10. `BASE_EDIT` — one Base's detail and settings

* **Route** `BaseEdit` · **Title** `EDIT BASE` · **Presentation** Stack in `HardwareNav`.
* **Deep link** `/home/home_nav/modal_nav/tab_nav/bases_nav/base_edit`. **Param** `serialNumber: string`, read through `decodeParams` so it survives a deep link (`BaseEditScreen.tsx:70`).
* **Impl** `src/Home/Base/BaseEditScreen.tsx` (459 lines). The densest of the four Job-2 screens.

**Reached from:** tapping or long-pressing → Edit on a `BASES` row.
**Navigates to:** `BASE_EDIT_INTERACTION_TIMING`, `BUTTON_EDIT`, `BUTTON_CONVERSION`,
`BUTTON_PAIRING` (in `BaseRegistrationNav`), `RESYNC_BASE`.

The Base itself is found by **searching the cached `useBases()` list for a matching
serial number** (`:104`) — there is no fetch-by-id.

### Read-only header

| Field | Source |
| --- | --- |
| Base name | `baseName(base)` |
| Battery | `base.battery_level ?? shadow.state.reported.bat_level` |
| `ID:` | `base.serial_number` |
| `Last Online At:` | `base.last_online_at` rendered by the **same `OccurredAt` component the timeline uses** (`:294-297`) — absolute date/time plus a relative age. This is the app's only online-health readout. |
| `Firmware:` | `shadow.state.reported.fw_ver`, split on commas onto separate lines. **Admin only** — gated on `appDebuggingEnabled` (`:299-304`, flag at `useFeatureFlags.ts:33`). |
| `Base Shadow` | The whole AWS IoT device shadow, `JSON.stringify`d twice. **Admin only** (`:416-423`). |

### Form (react-hook-form, mode `onChange`)

| Field | Constraint |
| --- | --- |
| **Base Name** (`displayName`) | Free text, placeholder "Name". No validation rule attached. Max length **unknown** — none set client-side. |
| **Interaction timing (in seconds)** (`interactionTiming`) | Numeric keyboard; every non-digit stripped on change (`:359`). Validator `helpers/validateInteractionTiming.ts`: must be **0–3600**, error text *"Interaction timing must be a number between 0 and 3600"*. This is the Base's press-grouping window. A `?` icon next to the label opens `BASE_EDIT_INTERACTION_TIMING`. |
| **Default Presser** (`defaultPusher`) | An avatar; tapping opens `SelectPusherModal` with `enableSelectNone`, so a synthetic **"None"** entry (id `null`) leads the list (`SelectPusherModal.tsx:43-46`). The avatar falls back to the word **"Add"** with a `+` icon when nothing is set (`helpers/getDefaultPusherAvatarText.ts`). |

**SAVE** is bottom-pinned and disabled unless the form is dirty, error-free and not
already saving (`:429`). It PATCHes `/api/v1/bases/{serial}` and pops on success;
failure shows a flash message and stays (`:146-164`) `[FAKE]`.

### Linked Buttons list (`components/BaseButtonList.tsx`)

Header row: a `+` badge → pair a new Connect Button, next to the caption *"Add a new
Connect Button."*. Then a search field and the same three-way sort as `LOG`, then one
row per Button (`components/BaseButton.tsx`):

* Button text as a badge — or the literal **`"unavailable"`**, disabled, when the Button exists in the Base's device shadow but not in the database (`BaseButton.tsx:33-39`).
* The **last 4 characters of the Button's serial number** (`:43`).
* A firmware-derived Button version, mapped through a hardcoded table (`helpers/contants.ts` — filename typo is in the repo): `1.3.20240308 → 1.0.7`, `1.3.20230428 → 1.0.3`, `1.3.20230221 → 1.0.1`, `1.3.20230117 → 0.1.1`, `1.3.20221214 → 0.1.0`, `1.3.20221018 → 0.0.1`. Shown **green if it is one of the two "latest" versions, red otherwise**, and tappable → an alert saying either "running the latest firmware" or "outdated, try re-linking", the latter with a **Learn More** button opening `support.fluent.pet` in a web browser (`components/versionAlert.tsx`) `[FAKE]`. An unmapped firmware shows a grey `?` icon instead.
* A battery icon from `useButtonBattery` (the 3-bucket scale, §8).

Tapping a Button row opens an action sheet: **Edit** → `BUTTON_EDIT`; **Merge** →
`BUTTON_CONVERSION`; **Unlink** (destructive) → confirm alert *"Are you sure you want
to unlink "X"?"* → POST unlink → refresh → **navigate to `RESYNC_BASE`**
(`:166-209`, `:142-145`) `[FAKE]`.

Linked-Button list **empty state**: `ThreeButtonsBanner` with *"There are no linked
buttons"* — but only once `isFetched` is true; before that the search/sort UI renders
over an empty list (`BaseButtonList.tsx:122`, `:154-158`).

### Other states

* Pull-to-refresh invalidates `BASES`, `BOARD` and `BUTTONS`.
* On **iOS only**, the Button list's fetching state is promoted to the screen-level spinner (`BaseButtonList.tsx:66-73`).
* **Base not found**: `{base && (…)}` (`:264`) means the entire body — header, form, Button list — renders as nothing, while the **SAVE bar stays visible**. Reachable via a stale deep link or after the Base is deleted on another device. This needs a real not-found state in the redesign.
* No error state for the Base lookup itself.

---

## 11. `BASE_EDIT_INTERACTION_TIMING` — the explanatory page

* **Route** — the enum value is the literal string **`"INTERACTION TIMING"`, with a space** (`src/navigation/constants/Screen.ts:9`). Every other Screen enum value is a PascalCase identifier. Recorded in the screen map as annotation `route-value-is-a-title`. It is the route name in navigation state and the key the linking config uses.
* **Title** `INTERACTION TIMING` · **Presentation** Stack in `HardwareNav`.
* **Deep link** `/home/home_nav/modal_nav/tab_nav/bases_nav/base_edit_interaction_timing`. No params.
* **Impl** `src/Home/Base/BaseEditInteractionTimingScreen.tsx` — 39 lines, entirely static.

Two paragraphs of fixed copy under a bold heading *"Conversation Timing
Customization"*: that customising the gap between presses aligns the tempo with the
Learner, that a slow talker suggests 30s, and that presses inside the window are logged
as one Interaction. **No data, no controls, no states.** Reached only from the `?` icon
on `BASE_EDIT`.

The one decision here is presentational: keep it a pushed screen or turn it into a
sheet/tooltip. Everything else is a copy block.

---

## 12. `CLASSIC_BUTTONS` — the Button board on the Hardware tab

* **Route** `ClassicButtons` · **Title** `BUTTONS` · **Presentation** Stack in `HardwareNav`.
* **Deep link** `/home/home_nav/modal_nav/tab_nav/bases_nav/classic_buttons`. No params.
* **Impl** `src/Home/Base/ClassicButtonsScreen.tsx` (142 lines).

**Reached from:** the Buttons tile on `BASES`, and nowhere else.

### Content

A single `ButtonsBoard` — the same component `LOG` uses — over `board.active_buttons`:
search field, sort control, `+` badge, one badge per Button, `inaudible` pinned last.

**It shows every active Button, Connect and Classic alike**; nothing filters on
`type === "classic"` despite the screen's name and route. Verified: the only filtering
in the component is by search text (`ButtonsBoard.tsx:73-83`) and by `text !==
"inaudible"` (`:121-129`).

### Controls

| Control | Behaviour |
| --- | --- |
| Tap a Button badge | **Opens the action sheet** — `onButtonPress` is wired to `handleLongPress` (`ClassicButtonsScreen.tsx:126`). Tap and long-press do the same thing here, unlike on `LOG` where tap selects. |
| Long-press a Button badge | Same action sheet |
| Action sheet | `Edit` → `BUTTON_EDIT` (passing the Button's battery level); `Archive` — destructive, **suppressed for `type === "connect"`** — confirm alert then PATCH `is_hidden: true`; `Cancel` |
| `+` badge | `BUTTON_ADD` with the Board id, pre-filling the name from the search text when nothing matched |
| Search | Prefix, case-insensitive; cleared on blur |
| Sort | A-Z / Introduction date / Most used; persisted as the `button_sort` preference `[FAKE]` |
| Pull to refresh | Invalidates `BASES`, `BOARD`, `BUTTONS` |

### States

Loading and updating overlays. **No empty state at all** — a Board with no Buttons
renders a lone `+` badge, and per §3 the `useButtons` hook may throw before it gets
there. No error state.

---

## 13. Cross-screen

### 13.1 Shared child components used by several of the twelve

| Component | Path | Used by |
| --- | --- | --- |
| `ScreenWrapper` | `src/components/ScreenWrapper.tsx` | **All twelve.** Loading overlay, offline banner, impersonation strip, environment border |
| `DashboardInfiniteScroll` | `src/components/Dashboard/DashboardInfiniteScroll.tsx` | The five Activity screens |
| `DashboardList` | `src/components/Dashboard/DashboardList.tsx` | via the above |
| `DashboardItem` (+ `OccurredAt`, `DashboardButtons`, `DashboardContexts`, `DashboardMeaning`, `StarButton`) | `src/components/Dashboard/DashboardItem/` | via the above |
| `OccurredAt` | `src/components/Dashboard/DashboardItem/OccurredAt.tsx` | timeline rows **and** `BASE_EDIT`'s Last-Online-At |
| `SelectPusherModal` | `src/components/Dashboard/SelectPusherModal.tsx` | timeline row ASSIGN, bulk assign, `BASE_EDIT` Default Presser |
| `AssignMeaningModal` | `src/components/Dashboard/AssignMeaningModal.tsx` | timeline single-item action sheet |
| `AvatarTypeSpecific` / `Avatar` | `src/components/Avatar/` | timeline rows, `PusherHeader`, `LOG_DETAILS`, `BASE_EDIT` |
| `ButtonBadge` | `src/components/ButtonBadge.tsx` | every Button, Context and Interpretation chip on every screen |
| `ButtonsBoard` | `src/components/ButtonsBoard.tsx` | `LOG`, `CLASSIC_BUTTONS` |
| `ButtonSort` / `TextInput` | `src/Home/Log/components/` | `LOG`, `CLASSIC_BUTTONS`, `BASE_EDIT`'s Button list, `DASHBOARD_FILTERS`' search |
| `ThreeButtonsBanner` | `src/Home/Log/components/ThreeButtonsBanner.tsx` | timeline empty state, `LOG` empty selection, `BASE_EDIT` empty Button list |
| `BatteryLevel` | `src/components/BatteryLevel/` | `BASES`, `BASE_EDIT` |
| `ShareModal` | `src/Home/ShareModal/ShareModal.tsx` | timeline Share action, `DASHBOARD_PUSHER` header |
| `FormSelect` | `src/Home/HouseholdAdd/FormSelect.tsx` | the All/Unassigned control and the Feed/Stats control — a Household component reused on the Activity screens |

`ButtonBadge` background encodes Connect vs Classic on every screen it appears on. That
distinction must survive the restyle.

### 13.2 Date and time formatting rules

Every date/time in these twelve goes through `moment` and one of these formats.
12/24-hour comes from `expo-localization` via `use24hourClock()`
(`src/hooks/use24hourClock.ts`) — the OS setting, not a user preference.

| Where | Format |
| --- | --- |
| Timeline row, `BASE_EDIT` Last Online At | `MMM Do · h:mm A` / `MMM Do · H:mm` + relative `fromNow()` upper-cased |
| `LOG_DETAILS` date field | `MMM Do YYYY` |
| `LOG_DETAILS` time field | `h:mm:ss A` / `H:mm:ss` |
| `DASHBOARD_FILTERS` date fields | `MMMM Do yyyy` |
| Filter start date sent to the API | `moment(startDate).local().startOf("day").toISOString()` (`useInteractions.ts:43-46`) |
| Filter end date sent to the API | `.endOf("day").toISOString()` (`:50-53`) |
| `sinceDate` (if ever set) | `moment().subtract(n,"d").startOf("day").format()` — start of day **with local offset**, deliberately not UTC (`helpers/createSinceDateTimestamp.ts`) |
| Written on create/update | `device_timezone: moment.tz.guess()` accompanies `occurred_at` (`useCreateInteraction.ts:43`) |

`OccurredAt.tsx:26` calls `moment(localDate, "YYYYMMDD")` passing a moment object with
a format string — the format is ignored. Harmless; do not copy it.

Numbers: `formatLargeNumber` (§2) is used for every count in every header and in the
Pusher stats.

### 13.3 The filter model

`DashboardFilters` (`src/model/dashboard.ts:21-35`) has **13 fields** (counted by
parsing the interface body: `searchText, startDate, endDate, sinceDate, pushers,
buttons, contexts, eventNotes, entriesWithNotes, buttonPresses, flaggedEntries,
searchType, bases`).

| Field | Type | Default | Facet |
| --- | --- | --- | --- |
| `searchText` | `string \| null` | `null` | free text, case-insensitive |
| `startDate` / `endDate` | `string \| null` | `null` | date range |
| `sinceDate` | `string \| null` | `null` | relative range — **no UI sets it today** |
| `pushers` | `number[]` | `[]` | Pusher **ids** |
| `buttons` | `string[]` | `[]` | Button **meanings (text)**, not ids |
| `contexts` | `number[]` | `[]` | Context ids |
| `bases` | `number[]` | `[]` | Base ids |
| `eventNotes` | `show \| hide \| showOnly` | `show` | free-standing Notes |
| `entriesWithNotes` | `show \| hide \| showOnly` | `show` | Activities carrying a note |
| `flaggedEntries` | `show \| hide \| showOnly` | `show` | flags |
| `buttonPresses` | `all \| singlePress \| multiPress` | `all` | single- vs multi-press |
| `searchType` | `{buttons, contexts, bases: any \| all}` | all `any` | match mode per facet |

**All filtering is server-side.** The whole object is serialised into the
`filters` query parameter of `GET /api/v2/interactions` (`useInteractions.ts:67`). The
only client-side transform is the start/end-of-day normalisation. `applyFilter`
(`src/Home/DashboardFilters/helpers/applyFilter.ts`) is a pure reducer — it toggles
membership in the id/text arrays and sets the scalars; it never filters a list.

**How filter state flows.** There are no picker screens in the sense of separate
routes — `DASHBOARD_BUTTON` / `_CONTEXT` / `_MEANING` / `_PUSHER` are *result* screens,
not filter pickers. Filter state lives in one place and moves like this:

```
DashboardInfiniteScroll                       DASHBOARD_FILTERS (modal)
  useState<DashboardFilters>(DEFAULT_FILTERS)
        │
        │ openFiltersScreen()                        local useState<filters>
        │   navigate(DASHBOARD_FILTERS, {            initialised from passedFilters
        │     passedFilters: filters,       ───────►
        │     editTimeframeOnly: !!pusher,           user edits tags/dates/toggles
        │     onFiltersUpdated,                      "Reset" → DEFAULT_FILTERS (local only)
        │     onReturn: setDefaultPafination })
        │                                            SAVE:
        │   ◄──────────────────────────────────────  onReturn()        (reset caller pagination)
        │                                            onFiltersUpdated(filters)
        │                                            navigation.pop()
        ▼
  setFilters(...) → useEffect on [dashboardTab, sortType, filters]
                  → page 0, flush, refetch
```

Facet screens **inherit whatever filters their parent had at mount** (they mount a new
`DashboardInfiniteScroll` with `DEFAULT_FILTERS` — so in fact they start unfiltered)
and expose no filter UI at all. Verify this in the redesign: today, drilling into a
Button from a filtered timeline shows that Button's **unfiltered** history.

Filters are **not persisted** — they live in component state and are lost when the
Activity stack unmounts. Only `activity_sort`, `button_sort` and
`push_notification_frequency` are server-side preferences.

### 13.4 Feature flags and admin gating across the twelve

From `src/hooks/useFeatureFlags.ts`. Note line 54 spreads a JSON-parsed `feature_flags`
user preference **over** the hardcoded defaults, so any of these can be overridden
server-side per user.

| Flag | Value | Affects |
| --- | --- | --- |
| `assignMeaningEnabled` | **admin only** | "What could this mean?" in the single-item action sheet |
| `appDebuggingEnabled` | **admin only** | Firmware line and Base Shadow dump on `BASE_EDIT` |
| `impersonateUsersEnabled` | admin only | The "LOGGED IN AS" strip's origin |
| `bulkAssignMeaningEnabled`, `mergeEnabled`, `duplicationEnabled`, `splittingEnabled`, `connectFeaturesEnabled` | hardcoded `true` | Action-sheet options; All/Unassigned tabs; which timeline empty state shows |
| `speechToTextEnabled` | hardcoded **false** | The mic on `ButtonsBoard` |
| `registerBaseViaAppEnabled` | hardcoded **false** | (not on these twelve) |
| `isAlpha` | user flag | Tab count: 5 tabs when on, 3 when off (`src/navigation/components/TabBar/TabBar.tsx:57`). Per PLAN.md the learning product is retired, so the redesign is permanently **Household / Activity / Hardware**. |

Platform branches on these twelve: Android hides the LOG EVENT button while the
keyboard is up (`LogScreen.tsx:74`); Android skips iOS's note truncation
(`DashboardItem.tsx:273`); Android intercepts hardware back on `DASHBOARD_PUSHER`;
Android's `BASE_EDIT` skips the iOS-only Button-list spinner promotion; `BASES`'
permission pre-check includes location on Android only; and the seconds field on
`LOG_DETAILS` clears on focus manually on Android because `clearTextOnFocus` is
iOS-only (`DateAndTime.tsx:57-62`).

### 13.5 Global chrome

* **Tab bar** — three tabs, custom-drawn, labels derived from the navigator route names minus `Nav` (`Household`, `Activity`, `Hardware`), icons Home / SpeechBubble / Base, hidden while the keyboard is shown with a delay on reappearance (`src/navigation/components/TabBar/TabBar.tsx:62-68`).
* **Header** on the first screen of each stack: drawer button left, a FluentPet logo button right that opens `fluent.pet/collections/kits` in a browser (`helpers/getFirstScreenOptions.tsx`, `components/FluentPetButton.tsx`) `[FAKE]`.
* Header style: `Font.BLACK`, letter-spacing 3, centre-aligned, all-caps titles (`src/navigation/options.tsx:17-21`).

---

## 14. Things that will make a redesign harder than it looks

1. **The nav bar is not static on the Activity screens.** Multi-select rewrites the title to `N SELECTED` and swaps the left button. Any redesign with a decorative or scroll-collapsing header must still express this.
2. **Six screens are one widget.** Building five separate Flutter screens will produce five divergent timelines. Build one with a mode.
3. **`DASHBOARD_FILTERS` receives three callbacks as navigation params.** Flutter navigation cannot carry closures the way React Navigation does. Phase 1 needs a filter controller/notifier owned above both screens, or a result returned from the route.
4. **Empty states are undifferentiated.** "You don't have any logs yet" appears for a genuinely empty account, for an over-filtered timeline, and for a facet screen with no matches. Three different messages are needed and none exists to copy.
5. **`sinceDate` is half-wired** — read by `PusherHeader` and `PusherStats`, never written by any UI, with an orphaned seven-preset constant sitting next to the filter screen. Decide before building.
6. **Two battery scales** with different bucket counts and thresholds (§8).
7. **The Buttons filter section vanishes** on Boards without an `inaudible` Button (§5).
8. **`BASE_EDIT` renders nothing** when the Base isn't in the cached list, with the SAVE bar still on screen (§10).
9. **A cross-screen cache dependency**: the Hardware tab's Linked-Buttons count needs the Activity tab's stray `useBoard()` call (§9). Any fixture layer must supply Board data to `BASES` directly.
10. **Sort exists in the data model but not in the UI** — `ActivitySort.tsx` is dead code and the preference is read-only from the app's side (§2).
11. **`Screen.BASE_EDIT_INTERACTION_TIMING` is the string `"INTERACTION TIMING"`**, spaces and all, and that string is the route name (§11).
12. **`CLASSIC_BUTTONS` is not about Classic Buttons** — it lists every active Button (§12), and the tile that opens it counts every active Button too (§9).
13. **The sticky header is implemented with a sentinel `{}` list item** (§1.6). Port the intent, not the mechanism.

---

## 15. What phase 1 must fake

Everything below is real-world I/O in the current app. Phase 1 is fixtures only; none
of it should be wired up. For each, the smallest honest stand-in.

### Network — reads

| Call | Used by | Smallest honest fixture |
| --- | --- | --- |
| `GET /api/v2/interactions` (page, sort_type, tab, filters, per_page, button_id, context_id, meaning_id, pusher_id) | all five Activity screens | One in-memory list of ~120 Interactions covering: Base-origin unassigned, app-origin, a free-standing Note, flagged, multi-Button, with/without Contexts, with/without an Interpretation, long note, no note. A local slicer that honours `page`/`per_page` so infinite scroll is exercised; the last page short so `isLastPage` fires. `communication_events`, `modeling_events`, `total`, `pusher_stats` as static numbers. |
| `GET /api/v1/pushers` | Activity screens, `LOG`, `LOG_DETAILS`, `BASE_EDIT`, filters | 5–6 Pushers: two Learners, two Teachers, one hidden, plus the `event note` Pusher (id `-1`). Include one pair with the same first initial so `getPusherInitials` is exercised. |
| `GET /api/v2/boards/default` and `GET /api/v1/buttons` | `LOG`, `CLASSIC_BUTTONS`, `BASES` tile, filters | One Board with ~20 active Buttons, a mix of Connect and Classic, **including an `inaudible` Button**, plus a second fixture Board with **zero** Buttons and one **without** `inaudible` so the two failure modes (§3, §5) get designed. |
| `GET /api/v1/contexts?filter=learner\|teacher` | `LOG_DETAILS`, filters, `DashboardItem` | Two lists; the Teacher list must contain a Context named exactly **`Modeled`** — three code paths key off that literal string. |
| `GET /api/v1/bases` | `BASES`, `BASE_EDIT`, filters | 2–3 Bases: one named, one unnamed (so the `"Base"` fallback shows), one with `battery_level` absent but a shadow, one with neither (icon hidden), varied `last_online_at` including several days ago. |
| `GET /api/v1/preferences` | Activity screens, `LOG`, `BASE_EDIT` | A static map: `activity_sort`, `button_sort`, `push_notification_frequency`, `feature_flags`. |
| `GET /api/v1/interaction_meanings`, `GET /api/v1/household` | `AssignMeaningModal` | A list of ~15 meanings with `uses` counts; one Household object with an id. |
| `GET /api/v1/interactions/{id}` | Duplicate action | Return the fixture row by id. |

### Network — writes (all no-ops that mutate the in-memory fixture and return success)

`POST /api/v1/interactions` (create) · `PATCH /api/v1/interactions/{id}` (flag, assign
Pusher, assign meaning) · `DELETE /api/v1/interactions/{id}` · `POST
/api/v1/activities/bulk/delete` · `POST /api/v3/interactions/bulk/merge` · `POST
/api/v3/interactions/bulk/assign` · `POST /api/v3/interactions/{id}/split` · `POST
/api/v1/interaction_meanings` · `POST /api/v1/preferences` · `PATCH
/api/v1/bases/{serial}` · `DELETE /api/v1/bases/{serial}` · `PATCH
/api/v1/buttons/{id}` (archive) · `POST /api/v1/buttons/{id}/unlink`.

**Each of these should also have a "fails" fixture toggle**, because every one of them
has an error path that currently shows a flash message, and those messages are part of
the design.

### Non-network dependencies

| Dependency | Where | Stand-in |
| --- | --- | --- |
| **Camera / location / notification permission status reads** | `BASES` CONNECT A BASE (`BasesScreen.tsx:117-131`) | A constant `permissionsGranted` flag; wire the button straight to the "all granted" branch and leave the other branch reachable behind a debug switch. **No real permission prompt.** |
| **Push notification handling** (deep-links into `DASHBOARD` with a tab, and into `BASES`) | `onNotificationOpened.ts` | Nothing. Optionally a debug menu entry that pushes the same routes so the deep-link destinations get exercised. |
| **Speech recognition** | `ButtonsBoard` mic | Omit — the flag is hardcoded false. |
| **AWS IoT device shadow** | `base.shadow` on `BASES` / `BASE_EDIT` | A literal JSON blob in the Base fixture with `state.reported.{bat_level, fw_ver, paired_children}`; `paired_children` keyed by Button serial with an `fw_ver` each, so the version chip and the "unavailable" Button case both render. |
| **BLE / Button pairing** | `BASE_EDIT` `+` → `BUTTON_PAIRING` | Out of scope for the twelve. Make the `+` a dead end or a stub route. |
| **Native share sheet, view-shot capture, media-library permission, Instagram-installed check** | `ShareModal` | A stub sheet that renders the share card and a disabled "Share" — the card layout is the design work; the export is not. Note the modal caps its own date range at **180 days** (`src/Home/ShareModal/ShareModal.tsx:62-75`). |
| **External browser** (`WebBrowser.openBrowserAsync`) | FluentPet logo button; Button firmware "Learn More" | No-op with a snackbar, or nothing. |
| **Haptics** — `Vibration.vibrate(100)` on flag toggle | `DashboardItem.tsx:133` | Keep as a real (cheap) haptic; it is part of the feel. |
| **Device 12/24-hour clock** | every timestamp | Read the real platform locale — it is free and it changes layout width. |
| **Network reachability** (`NetInfo`) → offline banner | `ScreenWrapper` / `OfflineStatusProvider` | A settable boolean in the fixture layer so the banner can be seen and designed. |
| **Local persistence** (`AsyncStorage`, `SecureStore`) | not on these twelve except the Household-add guide flag | Nothing. |
| **Analytics / crash reporting** (Amplitude, Sentry) | `openUrl` tracking, bug report | Nothing. |

---

## 16. Coverage and gaps

All twelve implementations were read end to end, together with `DashboardList`,
`DashboardInfiniteScroll`, `DashboardItem` and its five children, the five dashboard
headers, `PusherStats` and its four children, `ButtonsBoard`, `SelectPusherModal`,
`AssignMeaningModal`, `BaseItem`, `BaseButtonList`, `BaseButton`, `ClassicButtonsList`,
`ScreenWrapper`, `BatteryLevel`, the four `DashboardFilters` children, the two
`LogEntryEdit` children, the relevant navigators, `linking.ts`, and the API hooks each
screen calls.

Not fully traced, and deliberately left as **unknown**:

* **`ShareModal`** (291 lines) — read only far enough to characterise its dependencies and the 180-day cap. Its two card layouts (`ButtonShare`, `StatusShare`) and its Android permission modal were not inventoried; they are a separate design surface reached from two of the twelve.
* **`LOG_ENTRY_EDIT` (`LogDetailsEditScreen.tsx`, 619 lines)** — the destination of a tap on any timeline row, and therefore the most-used neighbour of these twelve, but not one of them. Not inventoried.
* **`AssignMeaningModal`'s** exact server-side meaning-matching semantics (what `interaction.meanings` contains versus the global list) — **unknown** from the client.
* Whether the `DASHBOARD_FILTERS` deep link resolves at runtime given the linking/registration mismatch (§5) — **unknown** without running the app, which was not done.
* Maximum lengths on the Base Name and note fields — **unknown**; none are enforced client-side.

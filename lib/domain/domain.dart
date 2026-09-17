/// The FluentPet Connect domain, in the vocabulary of `design-system/CONTEXT.md`.
///
/// Names match the existing app and API deliberately. The redesign changes
/// presentation, not terminology, so `Pusher` stays `Pusher` and the three
/// names for the Dashboard concept (`Dashboard` in code, "Activity" in the tab
/// bar, `Log` in the screen enum) are all kept.
///
/// ## The `Context` collision, resolved once
///
/// `Context` is a domain term — a tag on an [Interaction] describing the
/// surrounding situation — and `BuildContext` is everywhere in Flutter. Worse,
/// `Context` alone would sit one careless import away from being confused with
/// it in every widget file.
///
/// The domain type is therefore named **[InteractionContext]**. The domain term
/// stays "Context" in prose, in field names ([Interaction.contexts]) and on
/// screen. The rule for anyone adding code: never `import ... as Context`,
/// never alias it back, never introduce a second spelling. One name, decided
/// here, so it is not re-decided per file.
///
/// ## Shape
///
/// These mirror the RN app's `src/model/*.ts`, with three deliberate
/// departures, each marked at its declaration:
///
/// 1. Wire strings become enums ([ButtonKind], [InteractionOrigin],
///    [PusherKind]) so an unhandled case is a compile error.
/// 2. `Activity` is a real sealed supertype with [Interaction] and [Note]
///    subtypes. The RN app has no `Note` type — a note is an interaction row
///    with `type: "Note"` — but CONTEXT.md describes a supertype and switching
///    on a sealed class is what the timeline actually wants.
/// 3. Timestamps are [DateTime]. The API sends ISO 8601 strings; parsing
///    belongs in the integration phase's mapping layer, not in the screens.
///
/// Everything is immutable. There is no `fromJson` anywhere: phase 1 has no
/// HTTP (PLAN.md), and writing serialisation against an API nobody has called
/// yet would be guesswork committed to the repo.
library;

export 'activity.dart';
export 'activity_day.dart';
export 'base.dart';
export 'board.dart';
export 'button.dart';
export 'dashboard.dart';
export 'household.dart';
export 'interaction_context.dart';
export 'pusher.dart';

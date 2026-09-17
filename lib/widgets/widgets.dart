/// The twelve shared components, as the design system specifies them.
///
/// Ten are widgets. Two — the status bar and the home indicator — are OS
/// chrome that the specification tells Flutter to take from `SafeArea` rather
/// than draw; see `os_chrome.dart` for what stands in their place and why.
///
/// Every measurement that has a token uses the token; every measurement that
/// does not is named and cited in [FpMetrics]. No widget in here contains a
/// hex literal, a `Colors.*` constant or a `Color(0x…)` — colour comes from
/// `context.fpColors` without exception, because the brand alone is two
/// different values by scheme (ADR 0002) and a literal cannot be right in both.
library;

// `FpFormat` is not a widget and does not live here — it is pure string
// arithmetic in `lib/format/`, where the domain can use it without depending on
// the widget layer. It is exported from here because every screen that draws a
// component also formats something, and one import for both is what the screens
// were written against.
export '../format/fp_format.dart';
export 'context_list.dart';
export 'device_health_pill.dart';
export 'elapsed_rail.dart';
export 'flag_marker.dart';
export 'fp_metrics.dart';
export 'note_block.dart';
export 'os_chrome.dart';
export 'pusher_avatar.dart';
export 'screen_header.dart';
export 'summary_line.dart';
export 'tab_bar.dart';
export 'utterance_row.dart';

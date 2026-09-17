import 'package:flutter/material.dart';

import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';

/// Free text a human wrote on an Interaction, under the utterance it belongs
/// to.
///
/// A left rule, not a card: a filled card makes the note look like a second
/// Activity on the timeline rather than a continuation of the entry above it.
/// body-sm at secondary keeps it subordinate to the words the Pusher pressed.
///
/// The rule takes `border.default`, which steps per scheme. It is never pinned
/// to a grey.
///
/// The Astro spec sets `overflow-wrap: anywhere` so a pasted deep link does not
/// break one character per line. Flutter's line breaker already breaks an
/// over-long unbreakable run at the width of the box, so there is nothing to
/// set here — the behaviour the rule asks for is the default.
class NoteBlock extends StatelessWidget {
  const NoteBlock({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Container(
      padding: const EdgeInsets.only(left: FpSpace.s3),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: c.borderDefault, width: FpStroke.thick),
        ),
      ),
      child: Text(
        text,
        style: FpType.bodySm.copyWith(color: c.textSecondary),
      ),
    );
  }
}

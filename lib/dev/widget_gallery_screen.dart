import 'package:flutter/material.dart';

import '../domain/domain.dart';
import '../router/tabs.dart';
import '../screens/activity/ui/activity_controls.dart';
import '../screens/hardware/hardware_ui.dart';
import '../screens/log/log_controls.dart';
import '../theme/fp_context.dart';
import '../theme/generated/fp_tokens.dart';
import '../widgets/widgets.dart';

/// **Dev scaffolding. Not product surface.**
///
/// Every one of the shared components, in every state the components page
/// documents, on one scrollable page — so a human can check the set at a
/// glance rather than navigating to wherever each one happens to appear.
///
/// It is reached from the dev drawer and is deliberately not in the route
/// table: the routes are generated from the design system's screen map, the
/// gallery is not a screen in that map, and a gallery with a deep link is a
/// gallery that ships.
///
/// Nothing here is a component. If a specimen needs markup a component does not
/// have, that is a gap in the component, not a thing to fix here.
class WidgetGalleryScreen extends StatelessWidget {
  const WidgetGalleryScreen({super.key});

  static final Pusher _otis = Pusher(id: 1, name: 'Otis', isHuman: false);
  static final Pusher _sam = Pusher(id: 2, name: 'Sam', isHuman: true);

  /// The two pseudo-Pushers. Both are matched by **name** on the wire — the
  /// literal strings "base" and "event note" — and both draw as a mark rather
  /// than an initial, which is the only way an unattributed press does not read
  /// as somebody called B.
  static final Pusher _unattributed =
      Pusher(id: -2, name: 'base', isHuman: false);
  static final Pusher _journal =
      Pusher(id: Pusher.journalPusherId, name: 'event note', isHuman: false);

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Scaffold(
      backgroundColor: c.surfaceCanvas,
      body: FpOsChrome(
        bottom: true,
        child: Column(
          children: <Widget>[
            ScreenHeader(
              title: 'Widget gallery',
              subtitle: 'Dev only · twelve components and the four buttons, '
                  'every documented state',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: FpSpace.s10),
                children: <Widget>[
                  const _Section('1 · Utterance row'),
                  _Specimen(
                    label: 'Learner · single word',
                    note: 'No dots. One press, one word.',
                    child: UtteranceRow(
                      at: '08:04',
                      words: const <String>['food'],
                      pusher: _otis,
                      contexts: const <String>['kitchen'],
                    ),
                  ),
                  _Specimen(
                    label: 'Learner · multi-word',
                    note: 'Three presses, two boundaries, two dots.',
                    child: UtteranceRow(
                      at: '09:16',
                      words: const <String>['play', 'outside', 'now'],
                      pusher: _otis,
                      contexts: const <String>['after breakfast'],
                    ),
                  ),
                  _Specimen(
                    label: 'Teacher · recedes',
                    note: 'Heading type, secondary, outlined avatar, '
                        'attribution line.',
                    child: UtteranceRow(
                      at: '11:30',
                      words: const <String>['water'],
                      pusher: _sam,
                      contexts: const <String>['modelling'],
                    ),
                  ),
                  _Specimen(
                    label: 'First-time word',
                    note: 'Amber underline under the new word only.',
                    child: UtteranceRow(
                      at: '13:58',
                      words: const <String>['Sam', 'come'],
                      pusher: _otis,
                      contexts: const <String>['living room'],
                      firstTimeWord: 'Sam',
                    ),
                  ),
                  _Specimen(
                    label: 'Flagged',
                    note: 'The flag sits on the utterance line, after the last '
                        'word.',
                    child: UtteranceRow(
                      at: '18:47',
                      words: const <String>['love', 'you'],
                      pusher: _otis,
                      contexts: const <String>['evening', 'sofa'],
                      flagged: true,
                    ),
                  ),
                  _Specimen(
                    label: 'With note',
                    child: UtteranceRow(
                      at: '09:16',
                      words: const <String>['play', 'outside'],
                      pusher: _otis,
                      contexts: const <String>['after breakfast'],
                      note: 'Brought the rope toy over first, then pressed '
                          'both.',
                    ),
                  ),
                  _Specimen(
                    label: 'No Contexts',
                    note: 'The empty state renders nothing at all.',
                    child: UtteranceRow(
                      at: '15:20',
                      words: const <String>['outside'],
                      pusher: _otis,
                    ),
                  ),
                  _Specimen(
                    label: 'Many Contexts',
                    note: 'They wrap as one dot-separated line.',
                    child: UtteranceRow(
                      at: '16:02',
                      words: const <String>['outside'],
                      pusher: _otis,
                      contexts: const <String>[
                        'evening',
                        'by the door',
                        'after the walk',
                        'raining',
                        'with Sam',
                      ],
                    ),
                  ),
                  _Specimen(
                    label: 'Everything at once',
                    child: UtteranceRow(
                      at: '19:04',
                      words: const <String>['Sam', 'play', 'outside', 'now'],
                      pusher: _otis,
                      contexts: const <String>[
                        'evening',
                        'living room',
                        'unprompted',
                      ],
                      note: 'First time she has combined a name with a '
                          'request. Repeated it twice after.',
                      flagged: true,
                      firstTimeWord: 'Sam',
                    ),
                  ),
                  _Specimen(
                    label: 'Long utterance · wrapping',
                    note: 'Display type wraps rather than shrinking; the rail '
                        'stays put.',
                    child: UtteranceRow(
                      at: '20:41',
                      words: const <String>[
                        'mum',
                        'come',
                        'outside',
                        'play',
                        'later',
                        'please',
                      ],
                      pusher: _otis,
                      contexts: const <String>['bedtime'],
                    ),
                  ),
                  _Specimen(
                    label: 'Free-standing Note',
                    note: 'An Activity with no words at all.',
                    child: UtteranceRow(
                      at: '12:15',
                      words: const <String>[],
                      pusher: _sam,
                      note: 'Vet visit this afternoon; expect a quiet board.',
                      flagged: true,
                    ),
                  ),
                  _Specimen(
                    label: 'Unusually long word',
                    note: "A Button's meaning can be a phrase.",
                    child: UtteranceRow(
                      at: '21:30',
                      words: const <String>[
                        'I want to go outside right now please',
                      ],
                      pusher: _otis,
                      contexts: const <String>['persistent'],
                    ),
                  ),
                  _Specimen(
                    label: 'Unattributed · nobody pressed it *that anyone knows*',
                    note: 'PusherKind.base. A question-mark disc and the row\'s '
                        'own attribution line — never "base modelled this", '
                        'which is what reading the question as '
                        '"not a Learner" produced.',
                    child: UtteranceRow(
                      at: '15:20',
                      words: const <String>['outside'],
                      pusher: _unattributed,
                    ),
                  ),
                  _Specimen(
                    label: 'From an Activity',
                    note: 'UtteranceRow.activity, the constructor screens use.',
                    child: UtteranceRow.activity(
                      Note(
                        id: 99,
                        occurredAt: DateTime(2026, 8, 19, 12, 15),
                        pusher: _sam,
                        body: 'Sealed-subtype dispatch, timestamp formatted '
                            'once.',
                      ),
                    ),
                  ),

                  const _Section('2 · Pusher avatar'),
                  _Specimen(
                    label: 'Learner · sm 24, md 32, lg 44',
                    note: 'Filled brand disc, letter in text.onBrand.',
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        for (final size in PusherAvatarSize.values) ...<Widget>[
                          PusherAvatar(pusher: _otis, size: size),
                          const SizedBox(width: FpSpace.s5),
                        ],
                      ],
                    ),
                  ),
                  _Specimen(
                    label: 'Teacher · sm 24, md 32, lg 44',
                    note: 'Outlined disc, tertiary letter. Weight, not hue.',
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        for (final size in PusherAvatarSize.values) ...<Widget>[
                          PusherAvatar(pusher: _sam, size: size),
                          const SizedBox(width: FpSpace.s5),
                        ],
                      ],
                    ),
                  ),
                  _Specimen(
                    label: 'Pseudo-Pushers · unattributed, journal',
                    note: 'Marks, not letters: their names are wire sentinels '
                        'and "base".initial is a B.',
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        for (final size in PusherAvatarSize.values) ...<Widget>[
                          PusherAvatar(pusher: _unattributed, size: size),
                          const SizedBox(width: FpSpace.s3),
                          PusherAvatar(pusher: _journal, size: size),
                          const SizedBox(width: FpSpace.s5),
                        ],
                      ],
                    ),
                  ),
                  _Specimen(
                    label: 'Side by side',
                    note: 'The difference must survive greyscale.',
                    child: Row(
                      children: <Widget>[
                        PusherAvatar(
                          pusher: _otis,
                          size: PusherAvatarSize.lg,
                        ),
                        const SizedBox(width: FpSpace.s5),
                        PusherAvatar(pusher: _sam, size: PusherAvatarSize.lg),
                      ],
                    ),
                  ),

                  const _Section('3 · Context list'),
                  const _Specimen(
                    label: 'Empty',
                    note: 'Nothing is the correct rendering.',
                    child: ContextList(contexts: <String>[]),
                  ),
                  const _Specimen(
                    label: 'One',
                    child: ContextList(contexts: <String>['kitchen']),
                  ),
                  const _Specimen(
                    label: 'Many',
                    child: ContextList(
                      contexts: <String>[
                        'morning',
                        'by the door',
                        'raining',
                        'before the walk',
                        'with Sam',
                      ],
                    ),
                  ),
                  const _Specimen(
                    label: 'Long names',
                    note: 'Free text, so this happens. It wraps.',
                    child: ContextList(
                      contexts: <String>[
                        'just after the second walk of the afternoon',
                        'visitors in the house',
                      ],
                    ),
                  ),

                  const _Section('4 · Note block'),
                  const _Specimen(
                    label: 'Short',
                    child: NoteBlock(
                      text: 'Unprompted. Second time this week.',
                    ),
                  ),
                  const _Specimen(
                    label: 'Long prose',
                    child: NoteBlock(
                      text: 'Pressed this three times in a row while standing '
                          'at the back door, then went and sat by the lead. '
                          'Waited about a minute between the second and third '
                          "press, which is longer than the Base's grouping "
                          'window, so it logged as two Interactions rather '
                          'than one.',
                    ),
                  ),
                  const _Specimen(
                    label: 'With a pasted link',
                    note: 'The token wraps mid-string, not one character per '
                        'line.',
                    child: NoteBlock(
                      text: 'Discussed on the forum: '
                          'https://community.fluent.pet/t/multi-press-grouping'
                          '-window-and-what-it-does-to-long-utterances/48213',
                    ),
                  ),

                  const _Section('5 · Flag marker'),
                  const _Specimen(
                    label: 'Flagged · inline 13px',
                    child: FlagMarker(flagged: true),
                  ),
                  const _Specimen(
                    label: 'Not flagged · inline',
                    note: 'Renders nothing. No gap, no placeholder.',
                    child: FlagMarker(),
                  ),
                  const _Specimen(
                    label: 'As a control · flagged',
                    child: FlagMarker.control(flagged: true),
                  ),
                  const _Specimen(
                    label: 'As a control · unflagged',
                    note: 'The only place the unflagged state is drawn.',
                    child: FlagMarker.control(flagged: false),
                  ),

                  const _Section('6 · Elapsed-time rail'),
                  _Specimen(
                    label: 'Short gap · 22 min',
                    note: 'In place, so the rail alignment is visible.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UtteranceRow(
                          at: '07:42',
                          words: const <String>['outside', 'now'],
                          pusher: _otis,
                          contexts: const <String>['morning'],
                        ),
                        const ElapsedRail(gap: '22 min'),
                        UtteranceRow(
                          at: '08:04',
                          words: const <String>['food'],
                          pusher: _otis,
                          contexts: const <String>['kitchen'],
                        ),
                      ],
                    ),
                  ),
                  const _Specimen(
                    label: 'Long gap · 3 h 27 min',
                    child: ElapsedRail(gap: '3 h 27 min'),
                  ),
                  const _Specimen(
                    label: 'Overnight · 9 h 12 min',
                    note: 'Same rule height. The label does the work.',
                    child: ElapsedRail(gap: '9 h 12 min'),
                  ),
                  _Specimen(
                    label: 'No gap · last row',
                    note: 'Nothing renders, including no padding.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        UtteranceRow(
                          at: '20:12',
                          words: const <String>['bed'],
                          pusher: _otis,
                          contexts: const <String>['evening'],
                        ),
                        const ElapsedRail(gap: null),
                      ],
                    ),
                  ),

                  const _Section('7 · Device health pill'),
                  const _Specimen(
                    label: 'All six states',
                    note: 'none → syncing → offline → low → online, and '
                        'online with the level unknown.',
                    child: Wrap(
                      spacing: FpSpace.s3,
                      runSpacing: FpSpace.s3,
                      children: <Widget>[
                        DeviceHealthPill(battery: 87),
                        DeviceHealthPill(battery: 12),
                        DeviceHealthPill(online: false, battery: 64),
                        DeviceHealthPill(battery: 87, syncing: true),
                        DeviceHealthPill(paired: false),
                        DeviceHealthPill(),
                      ],
                    ),
                  ),
                  _Specimen(
                    label: 'With somewhere to go',
                    note: 'The chevron appears only when the pill can '
                        'navigate.',
                    child: DeviceHealthPill(battery: 87, onTap: () {}),
                  ),
                  _Specimen(
                    label: 'Precedence · offline at 12%',
                    note: 'One dot, one label. Offline wins and the stale '
                        'percent is dropped.',
                    child: DeviceHealthPill.forBase(
                      Base(
                        id: 1,
                        serialNumber: 'FP-0001',
                        batteryLevel: 12,
                        lastOnlineAt: DateTime(2026, 8, 19, 6),
                        name: 'Kitchen Base',
                        online: false,
                      ),
                    ),
                  ),

                  const _Section('8 · Summary line'),
                  const _Specimen(
                    label: 'Zero · today',
                    child: SummaryLine(count: 0, multi: 0),
                  ),
                  const _Specimen(
                    label: 'Zero · a past day',
                    child: SummaryLine(count: 0, multi: 0, isToday: false),
                  ),
                  const _Specimen(
                    label: 'One · singular',
                    child: SummaryLine(count: 1, multi: 0),
                  ),
                  const _Specimen(
                    label: 'Many · no new words',
                    child: SummaryLine(count: 7, multi: 3),
                  ),
                  const _Specimen(
                    label: 'Many · one new word',
                    child: SummaryLine(count: 7, multi: 3, firstTimes: 1),
                  ),
                  const _Specimen(
                    label: 'Many · several new words',
                    child: SummaryLine(count: 24, multi: 11, firstTimes: 4),
                  ),
                  const _Specimen(
                    label: 'Both singulars at once',
                    child: SummaryLine(count: 1, multi: 1, firstTimes: 1),
                  ),

                  const _Section('9 · Tab bar'),
                  for (final tab in FpTab.values)
                    _Specimen(
                      label: '${tab.label} active'
                          '${tab == FpTab.activity ? ' · the default' : ''}',
                      inset: false,
                      child: FpTabBar(
                        currentIndex: tab.index,
                        onSelected: _ignore,
                      ),
                    ),
                  _Specimen(
                    label: 'With an attention dot',
                    note: 'Count-free status. It says "go look", not "you '
                        'have 3".',
                    inset: false,
                    child: FpTabBar(
                      currentIndex: FpTab.activity.index,
                      onSelected: _ignore,
                      alert: FpTab.hardware,
                    ),
                  ),

                  const _Section('10 · Screen header'),
                  const _Specimen(
                    label: 'Activity · as shipped',
                    inset: false,
                    child: ScreenHeader(
                      title: 'Today',
                      subtitle: 'Wednesday 19 August',
                      trailing: DeviceHealthPill(battery: 87),
                      child: SummaryLine(count: 7, multi: 3, firstTimes: 1),
                    ),
                  ),
                  const _Specimen(
                    label: 'Title and date only',
                    inset: false,
                    child: ScreenHeader(title: 'Tuesday', subtitle: '17 August'),
                  ),
                  _Specimen(
                    label: 'Detail screen · back chevron',
                    note: 'Invented. Every pushed screen in the map needs one.',
                    inset: false,
                    child: ScreenHeader(
                      title: 'Kitchen Base',
                      subtitle: 'Connect · fw 2.14.0',
                      onBack: () {},
                      trailing: const DeviceHealthPill(battery: 87),
                    ),
                  ),
                  const _Specimen(
                    label: 'Long title · truncates',
                    note: 'The pill holds its width; the title gives way.',
                    inset: false,
                    child: ScreenHeader(
                      title: "Otis and Bramble's downstairs board",
                      subtitle: 'Wednesday 19 August',
                      trailing: DeviceHealthPill(online: false, battery: 64),
                    ),
                  ),
                  const _Specimen(
                    label: 'Quiet day',
                    inset: false,
                    child: ScreenHeader(
                      title: 'Today',
                      subtitle: 'Wednesday 19 August',
                      trailing: DeviceHealthPill(battery: 9),
                      child: SummaryLine(count: 0, multi: 0),
                    ),
                  ),

                  const _Section('11 & 12 · Status bar and home indicator'),
                  const _Specimen(
                    label: 'Not built, on purpose',
                    note: 'Both are the OS\'s chrome. The specification says '
                        'Flutter gets them from SafeArea, so there is no fake '
                        'clock and no fake home bar in this app. The top inset '
                        'and the overlay style come from FpOsChrome, which '
                        'this page is wrapped in; the bottom inset is added by '
                        'FpTabBar, below its own row.',
                    child: SizedBox.shrink(),
                  ),

                  const _Section('13 · Buttons, enabled and disabled'),
                  _Specimen(
                    label: 'ActionButton · every tone',
                    note: 'Disabled is a specified pair of tokens, not an '
                        'opacity over the enabled fill. Compare each row: the '
                        'colour drops out, the label stays readable at 6.43:1.',
                    child: Column(
                      children: <Widget>[
                        for (final (String name, ButtonTone tone) in const
                            <(String, ButtonTone)>[
                          ('primary', ButtonTone.primary),
                          ('secondary', ButtonTone.secondary),
                          ('ghost', ButtonTone.ghost),
                          ('danger', ButtonTone.danger),
                        ]) ...<Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ActionButton(
                                  label: name,
                                  tone: tone,
                                  onPressed: _nothing,
                                ),
                              ),
                              const SizedBox(width: FpSpace.s3),
                              Expanded(
                                child: ActionButton(
                                  label: '$name off',
                                  tone: tone,
                                  onPressed: null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: FpSpace.s3),
                        ],
                      ],
                    ),
                  ),
                  _Specimen(
                    label: 'LogActionButton · the LOG and LOG_DETAILS bar',
                    note: '"Log event" is disabled until a Button is picked. '
                        'That is the state this screen spends most of its '
                        'life in, so it has to be readable.',
                    child: Column(
                      children: <Widget>[
                        LogActionButton(
                          label: 'Log event',
                          onPressed: _nothing,
                        ),
                        const SizedBox(height: FpSpace.s3),
                        const LogActionButton(
                          label: 'Log event',
                          onPressed: null,
                        ),
                        const SizedBox(height: FpSpace.s3),
                        LogActionButton(
                          label: 'Save and log another',
                          tone: LogActionTone.secondary,
                          onPressed: _nothing,
                        ),
                        const SizedBox(height: FpSpace.s3),
                        const LogActionButton(
                          label: 'Save and log another',
                          tone: LogActionTone.secondary,
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                  _Specimen(
                    label: 'HardwarePrimaryButton · the pinned commit',
                    note: 'BASE_EDIT keeps it disabled until something '
                        'changes.',
                    child: Column(
                      children: <Widget>[
                        HardwarePrimaryButton(
                          label: 'SAVE',
                          onPressed: _nothing,
                        ),
                        const SizedBox(height: FpSpace.s3),
                        const HardwarePrimaryButton(
                          label: 'SAVE',
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                  _Specimen(
                    label: 'ButtonChip · three kinds, plus unavailable',
                    note: 'Unavailable is a Button the Base reports and the '
                        'database does not have.',
                    child: Wrap(
                      spacing: FpSpace.s3,
                      runSpacing: FpSpace.s3,
                      children: <Widget>[
                        ButtonChip(
                          label: 'outside',
                          kind: ButtonKind.connect,
                          onTap: _nothing,
                        ),
                        ButtonChip(
                          label: 'food',
                          kind: ButtonKind.classic,
                          onTap: _nothing,
                        ),
                        ButtonChip(
                          label: 'inaudible',
                          kind: ButtonKind.inaudible,
                          onTap: _nothing,
                        ),
                        const ButtonChip(
                          label: 'unavailable',
                          kind: ButtonKind.connect,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _ignore(int index) {}

  /// A live callback for a specimen. `null` is what disables a button, so an
  /// enabled specimen needs a real one.
  static void _nothing() {}
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s6,
        FpSpace.s8,
        FpSpace.s6,
        FpSpace.s4,
      ),
      child: Text(
        title,
        style: FpType.headingLg.copyWith(color: c.textPrimary),
      ),
    );
  }
}

class _Specimen extends StatelessWidget {
  const _Specimen({
    required this.label,
    required this.child,
    this.note,
    this.inset = true,
  });

  final String label;
  final String? note;

  /// False where the component draws its own full-bleed edges — the tab bar
  /// and the screen header both own their horizontal padding.
  final bool inset;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.fpColors;
    final subtitle = note;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FpSpace.s5,
        FpSpace.s0,
        FpSpace.s5,
        FpSpace.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: FpType.labelSm.copyWith(color: c.textTertiary),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: FpSpace.s1),
            Text(
              subtitle,
              style: FpType.bodySm.copyWith(color: c.textSecondary),
            ),
          ],
          const SizedBox(height: FpSpace.s3),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(inset ? FpSpace.s5 : FpSpace.s0),
            decoration: BoxDecoration(
              color: c.surfaceCanvas,
              borderRadius: BorderRadius.circular(FpRadius.lg),
              border: Border.all(
                color: c.borderSubtle,
                width: FpStroke.hairline,
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

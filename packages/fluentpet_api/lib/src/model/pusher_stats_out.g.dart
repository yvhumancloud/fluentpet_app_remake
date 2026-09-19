// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pusher_stats_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PusherStatsOut extends PusherStatsOut {
  @override
  final BuiltList<TextCount> mostPressed;
  @override
  final BuiltList<TextCount> leastPressed;
  @override
  final BuiltList<TextCount> topContexts;
  @override
  final Combination? mostFrequentCombination;
  @override
  final int? daysSinceFirstEntry;

  factory _$PusherStatsOut([void Function(PusherStatsOutBuilder)? updates]) =>
      (PusherStatsOutBuilder()..update(updates))._build();

  _$PusherStatsOut._(
      {required this.mostPressed,
      required this.leastPressed,
      required this.topContexts,
      this.mostFrequentCombination,
      this.daysSinceFirstEntry})
      : super._();
  @override
  PusherStatsOut rebuild(void Function(PusherStatsOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PusherStatsOutBuilder toBuilder() => PusherStatsOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PusherStatsOut &&
        mostPressed == other.mostPressed &&
        leastPressed == other.leastPressed &&
        topContexts == other.topContexts &&
        mostFrequentCombination == other.mostFrequentCombination &&
        daysSinceFirstEntry == other.daysSinceFirstEntry;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mostPressed.hashCode);
    _$hash = $jc(_$hash, leastPressed.hashCode);
    _$hash = $jc(_$hash, topContexts.hashCode);
    _$hash = $jc(_$hash, mostFrequentCombination.hashCode);
    _$hash = $jc(_$hash, daysSinceFirstEntry.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PusherStatsOut')
          ..add('mostPressed', mostPressed)
          ..add('leastPressed', leastPressed)
          ..add('topContexts', topContexts)
          ..add('mostFrequentCombination', mostFrequentCombination)
          ..add('daysSinceFirstEntry', daysSinceFirstEntry))
        .toString();
  }
}

class PusherStatsOutBuilder
    implements Builder<PusherStatsOut, PusherStatsOutBuilder> {
  _$PusherStatsOut? _$v;

  ListBuilder<TextCount>? _mostPressed;
  ListBuilder<TextCount> get mostPressed =>
      _$this._mostPressed ??= ListBuilder<TextCount>();
  set mostPressed(ListBuilder<TextCount>? mostPressed) =>
      _$this._mostPressed = mostPressed;

  ListBuilder<TextCount>? _leastPressed;
  ListBuilder<TextCount> get leastPressed =>
      _$this._leastPressed ??= ListBuilder<TextCount>();
  set leastPressed(ListBuilder<TextCount>? leastPressed) =>
      _$this._leastPressed = leastPressed;

  ListBuilder<TextCount>? _topContexts;
  ListBuilder<TextCount> get topContexts =>
      _$this._topContexts ??= ListBuilder<TextCount>();
  set topContexts(ListBuilder<TextCount>? topContexts) =>
      _$this._topContexts = topContexts;

  CombinationBuilder? _mostFrequentCombination;
  CombinationBuilder get mostFrequentCombination =>
      _$this._mostFrequentCombination ??= CombinationBuilder();
  set mostFrequentCombination(CombinationBuilder? mostFrequentCombination) =>
      _$this._mostFrequentCombination = mostFrequentCombination;

  int? _daysSinceFirstEntry;
  int? get daysSinceFirstEntry => _$this._daysSinceFirstEntry;
  set daysSinceFirstEntry(int? daysSinceFirstEntry) =>
      _$this._daysSinceFirstEntry = daysSinceFirstEntry;

  PusherStatsOutBuilder() {
    PusherStatsOut._defaults(this);
  }

  PusherStatsOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mostPressed = $v.mostPressed.toBuilder();
      _leastPressed = $v.leastPressed.toBuilder();
      _topContexts = $v.topContexts.toBuilder();
      _mostFrequentCombination = $v.mostFrequentCombination?.toBuilder();
      _daysSinceFirstEntry = $v.daysSinceFirstEntry;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PusherStatsOut other) {
    _$v = other as _$PusherStatsOut;
  }

  @override
  void update(void Function(PusherStatsOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PusherStatsOut build() => _build();

  _$PusherStatsOut _build() {
    _$PusherStatsOut _$result;
    try {
      _$result = _$v ??
          _$PusherStatsOut._(
            mostPressed: mostPressed.build(),
            leastPressed: leastPressed.build(),
            topContexts: topContexts.build(),
            mostFrequentCombination: _mostFrequentCombination?.build(),
            daysSinceFirstEntry: daysSinceFirstEntry,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'mostPressed';
        mostPressed.build();
        _$failedField = 'leastPressed';
        leastPressed.build();
        _$failedField = 'topContexts';
        topContexts.build();
        _$failedField = 'mostFrequentCombination';
        _mostFrequentCombination?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PusherStatsOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

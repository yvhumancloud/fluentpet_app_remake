// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_summary_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatsSummaryOut extends StatsSummaryOut {
  @override
  final PusherRef pusher;
  @override
  final int? daysSinceTrainingStarted;
  @override
  final int? daysSinceFirstInteraction;
  @override
  final StatsTotals totals;
  @override
  final StatsRange range;

  factory _$StatsSummaryOut([void Function(StatsSummaryOutBuilder)? updates]) =>
      (StatsSummaryOutBuilder()..update(updates))._build();

  _$StatsSummaryOut._(
      {required this.pusher,
      this.daysSinceTrainingStarted,
      this.daysSinceFirstInteraction,
      required this.totals,
      required this.range})
      : super._();
  @override
  StatsSummaryOut rebuild(void Function(StatsSummaryOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatsSummaryOutBuilder toBuilder() => StatsSummaryOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatsSummaryOut &&
        pusher == other.pusher &&
        daysSinceTrainingStarted == other.daysSinceTrainingStarted &&
        daysSinceFirstInteraction == other.daysSinceFirstInteraction &&
        totals == other.totals &&
        range == other.range;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pusher.hashCode);
    _$hash = $jc(_$hash, daysSinceTrainingStarted.hashCode);
    _$hash = $jc(_$hash, daysSinceFirstInteraction.hashCode);
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jc(_$hash, range.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatsSummaryOut')
          ..add('pusher', pusher)
          ..add('daysSinceTrainingStarted', daysSinceTrainingStarted)
          ..add('daysSinceFirstInteraction', daysSinceFirstInteraction)
          ..add('totals', totals)
          ..add('range', range))
        .toString();
  }
}

class StatsSummaryOutBuilder
    implements Builder<StatsSummaryOut, StatsSummaryOutBuilder> {
  _$StatsSummaryOut? _$v;

  PusherRefBuilder? _pusher;
  PusherRefBuilder get pusher => _$this._pusher ??= PusherRefBuilder();
  set pusher(PusherRefBuilder? pusher) => _$this._pusher = pusher;

  int? _daysSinceTrainingStarted;
  int? get daysSinceTrainingStarted => _$this._daysSinceTrainingStarted;
  set daysSinceTrainingStarted(int? daysSinceTrainingStarted) =>
      _$this._daysSinceTrainingStarted = daysSinceTrainingStarted;

  int? _daysSinceFirstInteraction;
  int? get daysSinceFirstInteraction => _$this._daysSinceFirstInteraction;
  set daysSinceFirstInteraction(int? daysSinceFirstInteraction) =>
      _$this._daysSinceFirstInteraction = daysSinceFirstInteraction;

  StatsTotalsBuilder? _totals;
  StatsTotalsBuilder get totals => _$this._totals ??= StatsTotalsBuilder();
  set totals(StatsTotalsBuilder? totals) => _$this._totals = totals;

  StatsRangeBuilder? _range;
  StatsRangeBuilder get range => _$this._range ??= StatsRangeBuilder();
  set range(StatsRangeBuilder? range) => _$this._range = range;

  StatsSummaryOutBuilder() {
    StatsSummaryOut._defaults(this);
  }

  StatsSummaryOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pusher = $v.pusher.toBuilder();
      _daysSinceTrainingStarted = $v.daysSinceTrainingStarted;
      _daysSinceFirstInteraction = $v.daysSinceFirstInteraction;
      _totals = $v.totals.toBuilder();
      _range = $v.range.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatsSummaryOut other) {
    _$v = other as _$StatsSummaryOut;
  }

  @override
  void update(void Function(StatsSummaryOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatsSummaryOut build() => _build();

  _$StatsSummaryOut _build() {
    _$StatsSummaryOut _$result;
    try {
      _$result = _$v ??
          _$StatsSummaryOut._(
            pusher: pusher.build(),
            daysSinceTrainingStarted: daysSinceTrainingStarted,
            daysSinceFirstInteraction: daysSinceFirstInteraction,
            totals: totals.build(),
            range: range.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pusher';
        pusher.build();

        _$failedField = 'totals';
        totals.build();
        _$failedField = 'range';
        range.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StatsSummaryOut', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

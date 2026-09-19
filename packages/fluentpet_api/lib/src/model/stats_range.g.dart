// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_range.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatsRange extends StatsRange {
  @override
  final Date from;
  @override
  final Date to;
  @override
  final BuiltList<TextCount> buttonsLogged;
  @override
  final BuiltList<TextCount> buttonsCreated;
  @override
  final BuiltList<TextCount> combinations;
  @override
  final BuiltList<TextCount> contexts;
  @override
  final BuiltList<DayStat> perDay;
  @override
  final BuiltList<HourStat> perHour;

  factory _$StatsRange([void Function(StatsRangeBuilder)? updates]) =>
      (StatsRangeBuilder()..update(updates))._build();

  _$StatsRange._(
      {required this.from,
      required this.to,
      required this.buttonsLogged,
      required this.buttonsCreated,
      required this.combinations,
      required this.contexts,
      required this.perDay,
      required this.perHour})
      : super._();
  @override
  StatsRange rebuild(void Function(StatsRangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatsRangeBuilder toBuilder() => StatsRangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatsRange &&
        from == other.from &&
        to == other.to &&
        buttonsLogged == other.buttonsLogged &&
        buttonsCreated == other.buttonsCreated &&
        combinations == other.combinations &&
        contexts == other.contexts &&
        perDay == other.perDay &&
        perHour == other.perHour;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, buttonsLogged.hashCode);
    _$hash = $jc(_$hash, buttonsCreated.hashCode);
    _$hash = $jc(_$hash, combinations.hashCode);
    _$hash = $jc(_$hash, contexts.hashCode);
    _$hash = $jc(_$hash, perDay.hashCode);
    _$hash = $jc(_$hash, perHour.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatsRange')
          ..add('from', from)
          ..add('to', to)
          ..add('buttonsLogged', buttonsLogged)
          ..add('buttonsCreated', buttonsCreated)
          ..add('combinations', combinations)
          ..add('contexts', contexts)
          ..add('perDay', perDay)
          ..add('perHour', perHour))
        .toString();
  }
}

class StatsRangeBuilder implements Builder<StatsRange, StatsRangeBuilder> {
  _$StatsRange? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  ListBuilder<TextCount>? _buttonsLogged;
  ListBuilder<TextCount> get buttonsLogged =>
      _$this._buttonsLogged ??= ListBuilder<TextCount>();
  set buttonsLogged(ListBuilder<TextCount>? buttonsLogged) =>
      _$this._buttonsLogged = buttonsLogged;

  ListBuilder<TextCount>? _buttonsCreated;
  ListBuilder<TextCount> get buttonsCreated =>
      _$this._buttonsCreated ??= ListBuilder<TextCount>();
  set buttonsCreated(ListBuilder<TextCount>? buttonsCreated) =>
      _$this._buttonsCreated = buttonsCreated;

  ListBuilder<TextCount>? _combinations;
  ListBuilder<TextCount> get combinations =>
      _$this._combinations ??= ListBuilder<TextCount>();
  set combinations(ListBuilder<TextCount>? combinations) =>
      _$this._combinations = combinations;

  ListBuilder<TextCount>? _contexts;
  ListBuilder<TextCount> get contexts =>
      _$this._contexts ??= ListBuilder<TextCount>();
  set contexts(ListBuilder<TextCount>? contexts) => _$this._contexts = contexts;

  ListBuilder<DayStat>? _perDay;
  ListBuilder<DayStat> get perDay => _$this._perDay ??= ListBuilder<DayStat>();
  set perDay(ListBuilder<DayStat>? perDay) => _$this._perDay = perDay;

  ListBuilder<HourStat>? _perHour;
  ListBuilder<HourStat> get perHour =>
      _$this._perHour ??= ListBuilder<HourStat>();
  set perHour(ListBuilder<HourStat>? perHour) => _$this._perHour = perHour;

  StatsRangeBuilder() {
    StatsRange._defaults(this);
  }

  StatsRangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _buttonsLogged = $v.buttonsLogged.toBuilder();
      _buttonsCreated = $v.buttonsCreated.toBuilder();
      _combinations = $v.combinations.toBuilder();
      _contexts = $v.contexts.toBuilder();
      _perDay = $v.perDay.toBuilder();
      _perHour = $v.perHour.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatsRange other) {
    _$v = other as _$StatsRange;
  }

  @override
  void update(void Function(StatsRangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatsRange build() => _build();

  _$StatsRange _build() {
    _$StatsRange _$result;
    try {
      _$result = _$v ??
          _$StatsRange._(
            from: BuiltValueNullFieldError.checkNotNull(
                from, r'StatsRange', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(to, r'StatsRange', 'to'),
            buttonsLogged: buttonsLogged.build(),
            buttonsCreated: buttonsCreated.build(),
            combinations: combinations.build(),
            contexts: contexts.build(),
            perDay: perDay.build(),
            perHour: perHour.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'buttonsLogged';
        buttonsLogged.build();
        _$failedField = 'buttonsCreated';
        buttonsCreated.build();
        _$failedField = 'combinations';
        combinations.build();
        _$failedField = 'contexts';
        contexts.build();
        _$failedField = 'perDay';
        perDay.build();
        _$failedField = 'perHour';
        perHour.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StatsRange', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_stat.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DayStat extends DayStat {
  @override
  final Date date;
  @override
  final int presses;
  @override
  final int interactions;

  factory _$DayStat([void Function(DayStatBuilder)? updates]) =>
      (DayStatBuilder()..update(updates))._build();

  _$DayStat._(
      {required this.date, required this.presses, required this.interactions})
      : super._();
  @override
  DayStat rebuild(void Function(DayStatBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DayStatBuilder toBuilder() => DayStatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DayStat &&
        date == other.date &&
        presses == other.presses &&
        interactions == other.interactions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, presses.hashCode);
    _$hash = $jc(_$hash, interactions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DayStat')
          ..add('date', date)
          ..add('presses', presses)
          ..add('interactions', interactions))
        .toString();
  }
}

class DayStatBuilder implements Builder<DayStat, DayStatBuilder> {
  _$DayStat? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _presses;
  int? get presses => _$this._presses;
  set presses(int? presses) => _$this._presses = presses;

  int? _interactions;
  int? get interactions => _$this._interactions;
  set interactions(int? interactions) => _$this._interactions = interactions;

  DayStatBuilder() {
    DayStat._defaults(this);
  }

  DayStatBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _presses = $v.presses;
      _interactions = $v.interactions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DayStat other) {
    _$v = other as _$DayStat;
  }

  @override
  void update(void Function(DayStatBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DayStat build() => _build();

  _$DayStat _build() {
    final _$result = _$v ??
        _$DayStat._(
          date: BuiltValueNullFieldError.checkNotNull(date, r'DayStat', 'date'),
          presses: BuiltValueNullFieldError.checkNotNull(
              presses, r'DayStat', 'presses'),
          interactions: BuiltValueNullFieldError.checkNotNull(
              interactions, r'DayStat', 'interactions'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

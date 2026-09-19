// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hour_stat.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HourStat extends HourStat {
  @override
  final int hour;
  @override
  final int interactions;

  factory _$HourStat([void Function(HourStatBuilder)? updates]) =>
      (HourStatBuilder()..update(updates))._build();

  _$HourStat._({required this.hour, required this.interactions}) : super._();
  @override
  HourStat rebuild(void Function(HourStatBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HourStatBuilder toBuilder() => HourStatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HourStat &&
        hour == other.hour &&
        interactions == other.interactions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hour.hashCode);
    _$hash = $jc(_$hash, interactions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HourStat')
          ..add('hour', hour)
          ..add('interactions', interactions))
        .toString();
  }
}

class HourStatBuilder implements Builder<HourStat, HourStatBuilder> {
  _$HourStat? _$v;

  int? _hour;
  int? get hour => _$this._hour;
  set hour(int? hour) => _$this._hour = hour;

  int? _interactions;
  int? get interactions => _$this._interactions;
  set interactions(int? interactions) => _$this._interactions = interactions;

  HourStatBuilder() {
    HourStat._defaults(this);
  }

  HourStatBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hour = $v.hour;
      _interactions = $v.interactions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HourStat other) {
    _$v = other as _$HourStat;
  }

  @override
  void update(void Function(HourStatBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HourStat build() => _build();

  _$HourStat _build() {
    final _$result = _$v ??
        _$HourStat._(
          hour:
              BuiltValueNullFieldError.checkNotNull(hour, r'HourStat', 'hour'),
          interactions: BuiltValueNullFieldError.checkNotNull(
              interactions, r'HourStat', 'interactions'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

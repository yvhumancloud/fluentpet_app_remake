// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_totals.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatsTotals extends StatsTotals {
  @override
  final int interactions;
  @override
  final int presses;
  @override
  final int distinctButtons;

  factory _$StatsTotals([void Function(StatsTotalsBuilder)? updates]) =>
      (StatsTotalsBuilder()..update(updates))._build();

  _$StatsTotals._(
      {required this.interactions,
      required this.presses,
      required this.distinctButtons})
      : super._();
  @override
  StatsTotals rebuild(void Function(StatsTotalsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatsTotalsBuilder toBuilder() => StatsTotalsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatsTotals &&
        interactions == other.interactions &&
        presses == other.presses &&
        distinctButtons == other.distinctButtons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, interactions.hashCode);
    _$hash = $jc(_$hash, presses.hashCode);
    _$hash = $jc(_$hash, distinctButtons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatsTotals')
          ..add('interactions', interactions)
          ..add('presses', presses)
          ..add('distinctButtons', distinctButtons))
        .toString();
  }
}

class StatsTotalsBuilder implements Builder<StatsTotals, StatsTotalsBuilder> {
  _$StatsTotals? _$v;

  int? _interactions;
  int? get interactions => _$this._interactions;
  set interactions(int? interactions) => _$this._interactions = interactions;

  int? _presses;
  int? get presses => _$this._presses;
  set presses(int? presses) => _$this._presses = presses;

  int? _distinctButtons;
  int? get distinctButtons => _$this._distinctButtons;
  set distinctButtons(int? distinctButtons) =>
      _$this._distinctButtons = distinctButtons;

  StatsTotalsBuilder() {
    StatsTotals._defaults(this);
  }

  StatsTotalsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _interactions = $v.interactions;
      _presses = $v.presses;
      _distinctButtons = $v.distinctButtons;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatsTotals other) {
    _$v = other as _$StatsTotals;
  }

  @override
  void update(void Function(StatsTotalsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatsTotals build() => _build();

  _$StatsTotals _build() {
    final _$result = _$v ??
        _$StatsTotals._(
          interactions: BuiltValueNullFieldError.checkNotNull(
              interactions, r'StatsTotals', 'interactions'),
          presses: BuiltValueNullFieldError.checkNotNull(
              presses, r'StatsTotals', 'presses'),
          distinctButtons: BuiltValueNullFieldError.checkNotNull(
              distinctButtons, r'StatsTotals', 'distinctButtons'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

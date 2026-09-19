// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combination.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Combination extends Combination {
  @override
  final BuiltList<ButtonRef> buttons;
  @override
  final int count;

  factory _$Combination([void Function(CombinationBuilder)? updates]) =>
      (CombinationBuilder()..update(updates))._build();

  _$Combination._({required this.buttons, required this.count}) : super._();
  @override
  Combination rebuild(void Function(CombinationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CombinationBuilder toBuilder() => CombinationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Combination &&
        buttons == other.buttons &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, buttons.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Combination')
          ..add('buttons', buttons)
          ..add('count', count))
        .toString();
  }
}

class CombinationBuilder implements Builder<Combination, CombinationBuilder> {
  _$Combination? _$v;

  ListBuilder<ButtonRef>? _buttons;
  ListBuilder<ButtonRef> get buttons =>
      _$this._buttons ??= ListBuilder<ButtonRef>();
  set buttons(ListBuilder<ButtonRef>? buttons) => _$this._buttons = buttons;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  CombinationBuilder() {
    Combination._defaults(this);
  }

  CombinationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _buttons = $v.buttons.toBuilder();
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Combination other) {
    _$v = other as _$Combination;
  }

  @override
  void update(void Function(CombinationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Combination build() => _build();

  _$Combination _build() {
    _$Combination _$result;
    try {
      _$result = _$v ??
          _$Combination._(
            buttons: buttons.build(),
            count: BuiltValueNullFieldError.checkNotNull(
                count, r'Combination', 'count'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'buttons';
        buttons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Combination', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

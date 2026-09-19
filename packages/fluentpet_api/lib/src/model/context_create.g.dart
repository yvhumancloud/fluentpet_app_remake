// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContextCreateAppliesToEnum _$contextCreateAppliesToEnum_human =
    const ContextCreateAppliesToEnum._('human');
const ContextCreateAppliesToEnum _$contextCreateAppliesToEnum_learner =
    const ContextCreateAppliesToEnum._('learner');
const ContextCreateAppliesToEnum _$contextCreateAppliesToEnum_both =
    const ContextCreateAppliesToEnum._('both');

ContextCreateAppliesToEnum _$contextCreateAppliesToEnumValueOf(String name) {
  switch (name) {
    case 'human':
      return _$contextCreateAppliesToEnum_human;
    case 'learner':
      return _$contextCreateAppliesToEnum_learner;
    case 'both':
      return _$contextCreateAppliesToEnum_both;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ContextCreateAppliesToEnum> _$contextCreateAppliesToEnumValues =
    BuiltSet<ContextCreateAppliesToEnum>(const <ContextCreateAppliesToEnum>[
  _$contextCreateAppliesToEnum_human,
  _$contextCreateAppliesToEnum_learner,
  _$contextCreateAppliesToEnum_both,
]);

Serializer<ContextCreateAppliesToEnum> _$contextCreateAppliesToEnumSerializer =
    _$ContextCreateAppliesToEnumSerializer();

class _$ContextCreateAppliesToEnumSerializer
    implements PrimitiveSerializer<ContextCreateAppliesToEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'human': 'human',
    'learner': 'learner',
    'both': 'both',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'human': 'human',
    'learner': 'learner',
    'both': 'both',
  };

  @override
  final Iterable<Type> types = const <Type>[ContextCreateAppliesToEnum];
  @override
  final String wireName = 'ContextCreateAppliesToEnum';

  @override
  Object serialize(Serializers serializers, ContextCreateAppliesToEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ContextCreateAppliesToEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ContextCreateAppliesToEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ContextCreate extends ContextCreate {
  @override
  final String text;
  @override
  final ContextCreateAppliesToEnum? appliesTo;

  factory _$ContextCreate([void Function(ContextCreateBuilder)? updates]) =>
      (ContextCreateBuilder()..update(updates))._build();

  _$ContextCreate._({required this.text, this.appliesTo}) : super._();
  @override
  ContextCreate rebuild(void Function(ContextCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContextCreateBuilder toBuilder() => ContextCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContextCreate &&
        text == other.text &&
        appliesTo == other.appliesTo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, appliesTo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContextCreate')
          ..add('text', text)
          ..add('appliesTo', appliesTo))
        .toString();
  }
}

class ContextCreateBuilder
    implements Builder<ContextCreate, ContextCreateBuilder> {
  _$ContextCreate? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  ContextCreateAppliesToEnum? _appliesTo;
  ContextCreateAppliesToEnum? get appliesTo => _$this._appliesTo;
  set appliesTo(ContextCreateAppliesToEnum? appliesTo) =>
      _$this._appliesTo = appliesTo;

  ContextCreateBuilder() {
    ContextCreate._defaults(this);
  }

  ContextCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _appliesTo = $v.appliesTo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContextCreate other) {
    _$v = other as _$ContextCreate;
  }

  @override
  void update(void Function(ContextCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContextCreate build() => _build();

  _$ContextCreate _build() {
    final _$result = _$v ??
        _$ContextCreate._(
          text: BuiltValueNullFieldError.checkNotNull(
              text, r'ContextCreate', 'text'),
          appliesTo: appliesTo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

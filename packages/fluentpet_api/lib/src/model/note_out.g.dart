// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NoteOutTypeEnum _$noteOutTypeEnum_note = const NoteOutTypeEnum._('note');

NoteOutTypeEnum _$noteOutTypeEnumValueOf(String name) {
  switch (name) {
    case 'note':
      return _$noteOutTypeEnum_note;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NoteOutTypeEnum> _$noteOutTypeEnumValues =
    BuiltSet<NoteOutTypeEnum>(const <NoteOutTypeEnum>[
  _$noteOutTypeEnum_note,
]);

Serializer<NoteOutTypeEnum> _$noteOutTypeEnumSerializer =
    _$NoteOutTypeEnumSerializer();

class _$NoteOutTypeEnumSerializer
    implements PrimitiveSerializer<NoteOutTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'note': 'note',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'note': 'note',
  };

  @override
  final Iterable<Type> types = const <Type>[NoteOutTypeEnum];
  @override
  final String wireName = 'NoteOutTypeEnum';

  @override
  Object serialize(Serializers serializers, NoteOutTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NoteOutTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NoteOutTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$NoteOut extends NoteOut {
  @override
  final NoteOutTypeEnum? type;
  @override
  final int id;
  @override
  final String text;
  @override
  final DateTime occurredAt;
  @override
  final String? deviceTimezone;
  @override
  final bool isFavourite;
  @override
  final bool isHidden;
  @override
  final DateTime createdAt;

  factory _$NoteOut([void Function(NoteOutBuilder)? updates]) =>
      (NoteOutBuilder()..update(updates))._build();

  _$NoteOut._(
      {this.type,
      required this.id,
      required this.text,
      required this.occurredAt,
      this.deviceTimezone,
      required this.isFavourite,
      required this.isHidden,
      required this.createdAt})
      : super._();
  @override
  NoteOut rebuild(void Function(NoteOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoteOutBuilder toBuilder() => NoteOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoteOut &&
        type == other.type &&
        id == other.id &&
        text == other.text &&
        occurredAt == other.occurredAt &&
        deviceTimezone == other.deviceTimezone &&
        isFavourite == other.isFavourite &&
        isHidden == other.isHidden &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jc(_$hash, deviceTimezone.hashCode);
    _$hash = $jc(_$hash, isFavourite.hashCode);
    _$hash = $jc(_$hash, isHidden.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoteOut')
          ..add('type', type)
          ..add('id', id)
          ..add('text', text)
          ..add('occurredAt', occurredAt)
          ..add('deviceTimezone', deviceTimezone)
          ..add('isFavourite', isFavourite)
          ..add('isHidden', isHidden)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class NoteOutBuilder implements Builder<NoteOut, NoteOutBuilder> {
  _$NoteOut? _$v;

  NoteOutTypeEnum? _type;
  NoteOutTypeEnum? get type => _$this._type;
  set type(NoteOutTypeEnum? type) => _$this._type = type;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  String? _deviceTimezone;
  String? get deviceTimezone => _$this._deviceTimezone;
  set deviceTimezone(String? deviceTimezone) =>
      _$this._deviceTimezone = deviceTimezone;

  bool? _isFavourite;
  bool? get isFavourite => _$this._isFavourite;
  set isFavourite(bool? isFavourite) => _$this._isFavourite = isFavourite;

  bool? _isHidden;
  bool? get isHidden => _$this._isHidden;
  set isHidden(bool? isHidden) => _$this._isHidden = isHidden;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  NoteOutBuilder() {
    NoteOut._defaults(this);
  }

  NoteOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _text = $v.text;
      _occurredAt = $v.occurredAt;
      _deviceTimezone = $v.deviceTimezone;
      _isFavourite = $v.isFavourite;
      _isHidden = $v.isHidden;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoteOut other) {
    _$v = other as _$NoteOut;
  }

  @override
  void update(void Function(NoteOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoteOut build() => _build();

  _$NoteOut _build() {
    final _$result = _$v ??
        _$NoteOut._(
          type: type,
          id: BuiltValueNullFieldError.checkNotNull(id, r'NoteOut', 'id'),
          text: BuiltValueNullFieldError.checkNotNull(text, r'NoteOut', 'text'),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
              occurredAt, r'NoteOut', 'occurredAt'),
          deviceTimezone: deviceTimezone,
          isFavourite: BuiltValueNullFieldError.checkNotNull(
              isFavourite, r'NoteOut', 'isFavourite'),
          isHidden: BuiltValueNullFieldError.checkNotNull(
              isHidden, r'NoteOut', 'isHidden'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'NoteOut', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

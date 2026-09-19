//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_out.g.dart';

/// NoteOut
///
/// Properties:
/// * [type]
/// * [id]
/// * [text]
/// * [occurredAt]
/// * [deviceTimezone]
/// * [isFavourite]
/// * [isHidden]
/// * [createdAt]
@BuiltValue()
abstract class NoteOut implements Built<NoteOut, NoteOutBuilder> {
  @BuiltValueField(wireName: r'type')
  NoteOutTypeEnum? get type;
  // enum typeEnum {  note,  };

  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'occurred_at')
  DateTime get occurredAt;

  @BuiltValueField(wireName: r'device_timezone')
  String? get deviceTimezone;

  @BuiltValueField(wireName: r'is_favourite')
  bool get isFavourite;

  @BuiltValueField(wireName: r'is_hidden')
  bool get isHidden;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  NoteOut._();

  factory NoteOut([void updates(NoteOutBuilder b)]) = _$NoteOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteOutBuilder b) =>
      b..type = NoteOutTypeEnum.valueOf('note');

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteOut> get serializer => _$NoteOutSerializer();
}

class _$NoteOutSerializer implements PrimitiveSerializer<NoteOut> {
  @override
  final Iterable<Type> types = const [NoteOut, _$NoteOut];

  @override
  final String wireName = r'NoteOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(NoteOutTypeEnum),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'occurred_at';
    yield serializers.serialize(
      object.occurredAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'device_timezone';
    yield object.deviceTimezone == null
        ? null
        : serializers.serialize(
            object.deviceTimezone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'is_favourite';
    yield serializers.serialize(
      object.isFavourite,
      specifiedType: const FullType(bool),
    );
    yield r'is_hidden';
    yield serializers.serialize(
      object.isHidden,
      specifiedType: const FullType(bool),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NoteOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NoteOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(NoteOutTypeEnum),
          ) as NoteOutTypeEnum?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'occurred_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.occurredAt = valueDes;
          break;
        case r'device_timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceTimezone = valueDes;
          break;
        case r'is_favourite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isFavourite = valueDes;
          break;
        case r'is_hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHidden = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NoteOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteOutBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class NoteOutTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'note')
  static const NoteOutTypeEnum note = _$noteOutTypeEnum_note;

  static Serializer<NoteOutTypeEnum> get serializer =>
      _$noteOutTypeEnumSerializer;

  const NoteOutTypeEnum._(String name) : super(name);

  static BuiltSet<NoteOutTypeEnum> get values => _$noteOutTypeEnumValues;
  static NoteOutTypeEnum valueOf(String name) => _$noteOutTypeEnumValueOf(name);
}

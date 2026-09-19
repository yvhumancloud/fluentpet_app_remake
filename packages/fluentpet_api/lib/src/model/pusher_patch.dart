//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pusher_patch.g.dart';

/// PusherPatch
///
/// Properties:
/// * [name]
/// * [isHuman]
/// * [birthDate]
/// * [sex]
/// * [learnerTypeId]
/// * [subType]
/// * [country]
/// * [language]
/// * [trainingStartedAt]
/// * [isHidden]
@BuiltValue()
abstract class PusherPatch implements Built<PusherPatch, PusherPatchBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'is_human')
  bool? get isHuman;

  @BuiltValueField(wireName: r'birth_date')
  Date? get birthDate;

  @BuiltValueField(wireName: r'sex')
  String? get sex;

  @BuiltValueField(wireName: r'learner_type_id')
  int? get learnerTypeId;

  @BuiltValueField(wireName: r'sub_type')
  String? get subType;

  @BuiltValueField(wireName: r'country')
  String? get country;

  @BuiltValueField(wireName: r'language')
  String? get language;

  @BuiltValueField(wireName: r'training_started_at')
  Date? get trainingStartedAt;

  @BuiltValueField(wireName: r'is_hidden')
  bool? get isHidden;

  PusherPatch._();

  factory PusherPatch([void updates(PusherPatchBuilder b)]) = _$PusherPatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PusherPatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PusherPatch> get serializer => _$PusherPatchSerializer();
}

class _$PusherPatchSerializer implements PrimitiveSerializer<PusherPatch> {
  @override
  final Iterable<Type> types = const [PusherPatch, _$PusherPatch];

  @override
  final String wireName = r'PusherPatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PusherPatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.isHuman != null) {
      yield r'is_human';
      yield serializers.serialize(
        object.isHuman,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.birthDate != null) {
      yield r'birth_date';
      yield serializers.serialize(
        object.birthDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.sex != null) {
      yield r'sex';
      yield serializers.serialize(
        object.sex,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.learnerTypeId != null) {
      yield r'learner_type_id';
      yield serializers.serialize(
        object.learnerTypeId,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.subType != null) {
      yield r'sub_type';
      yield serializers.serialize(
        object.subType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.country != null) {
      yield r'country';
      yield serializers.serialize(
        object.country,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.language != null) {
      yield r'language';
      yield serializers.serialize(
        object.language,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.trainingStartedAt != null) {
      yield r'training_started_at';
      yield serializers.serialize(
        object.trainingStartedAt,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.isHidden != null) {
      yield r'is_hidden';
      yield serializers.serialize(
        object.isHidden,
        specifiedType: const FullType.nullable(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PusherPatch object, {
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
    required PusherPatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'is_human':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isHuman = valueDes;
          break;
        case r'birth_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.birthDate = valueDes;
          break;
        case r'sex':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sex = valueDes;
          break;
        case r'learner_type_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.learnerTypeId = valueDes;
          break;
        case r'sub_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subType = valueDes;
          break;
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.country = valueDes;
          break;
        case r'language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.language = valueDes;
          break;
        case r'training_started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.trainingStartedAt = valueDes;
          break;
        case r'is_hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isHidden = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PusherPatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PusherPatchBuilder();
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

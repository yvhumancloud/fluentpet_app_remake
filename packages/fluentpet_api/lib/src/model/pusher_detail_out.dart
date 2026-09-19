//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pusher_detail_out.g.dart';

/// PusherDetailOut
///
/// Properties:
/// * [id]
/// * [name]
/// * [isHuman]
/// * [isHidden]
/// * [birthDate]
/// * [sex]
/// * [learnerTypeId]
/// * [subType]
/// * [country]
/// * [language]
/// * [trainingStartedAt]
/// * [interactionsCount]
/// * [avatarUrl]
@BuiltValue()
abstract class PusherDetailOut
    implements Built<PusherDetailOut, PusherDetailOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'is_human')
  bool get isHuman;

  @BuiltValueField(wireName: r'is_hidden')
  bool get isHidden;

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

  @BuiltValueField(wireName: r'interactions_count')
  int get interactionsCount;

  @BuiltValueField(wireName: r'avatar_url')
  String? get avatarUrl;

  PusherDetailOut._();

  factory PusherDetailOut([void updates(PusherDetailOutBuilder b)]) =
      _$PusherDetailOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PusherDetailOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PusherDetailOut> get serializer =>
      _$PusherDetailOutSerializer();
}

class _$PusherDetailOutSerializer
    implements PrimitiveSerializer<PusherDetailOut> {
  @override
  final Iterable<Type> types = const [PusherDetailOut, _$PusherDetailOut];

  @override
  final String wireName = r'PusherDetailOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PusherDetailOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'is_human';
    yield serializers.serialize(
      object.isHuman,
      specifiedType: const FullType(bool),
    );
    yield r'is_hidden';
    yield serializers.serialize(
      object.isHidden,
      specifiedType: const FullType(bool),
    );
    yield r'birth_date';
    yield object.birthDate == null
        ? null
        : serializers.serialize(
            object.birthDate,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'sex';
    yield object.sex == null
        ? null
        : serializers.serialize(
            object.sex,
            specifiedType: const FullType.nullable(String),
          );
    yield r'learner_type_id';
    yield object.learnerTypeId == null
        ? null
        : serializers.serialize(
            object.learnerTypeId,
            specifiedType: const FullType.nullable(int),
          );
    yield r'sub_type';
    yield object.subType == null
        ? null
        : serializers.serialize(
            object.subType,
            specifiedType: const FullType.nullable(String),
          );
    yield r'country';
    yield object.country == null
        ? null
        : serializers.serialize(
            object.country,
            specifiedType: const FullType.nullable(String),
          );
    yield r'language';
    yield object.language == null
        ? null
        : serializers.serialize(
            object.language,
            specifiedType: const FullType.nullable(String),
          );
    yield r'training_started_at';
    yield object.trainingStartedAt == null
        ? null
        : serializers.serialize(
            object.trainingStartedAt,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'interactions_count';
    yield serializers.serialize(
      object.interactionsCount,
      specifiedType: const FullType(int),
    );
    yield r'avatar_url';
    yield object.avatarUrl == null
        ? null
        : serializers.serialize(
            object.avatarUrl,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PusherDetailOut object, {
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
    required PusherDetailOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'is_human':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHuman = valueDes;
          break;
        case r'is_hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHidden = valueDes;
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
        case r'interactions_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.interactionsCount = valueDes;
          break;
        case r'avatar_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PusherDetailOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PusherDetailOutBuilder();
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

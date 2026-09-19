//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_out.g.dart';

/// UserOut
///
/// Properties:
/// * [id]
/// * [email]
/// * [fullName]
/// * [timezone]
/// * [appVersion]
/// * [isHouseholdAdmin]
@BuiltValue()
abstract class UserOut implements Built<UserOut, UserOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'full_name')
  String? get fullName;

  @BuiltValueField(wireName: r'timezone')
  String get timezone;

  @BuiltValueField(wireName: r'app_version')
  String? get appVersion;

  @BuiltValueField(wireName: r'is_household_admin')
  bool get isHouseholdAdmin;

  UserOut._();

  factory UserOut([void updates(UserOutBuilder b)]) = _$UserOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserOut> get serializer => _$UserOutSerializer();
}

class _$UserOutSerializer implements PrimitiveSerializer<UserOut> {
  @override
  final Iterable<Type> types = const [UserOut, _$UserOut];

  @override
  final String wireName = r'UserOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'full_name';
    yield object.fullName == null
        ? null
        : serializers.serialize(
            object.fullName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(String),
    );
    yield r'app_version';
    yield object.appVersion == null
        ? null
        : serializers.serialize(
            object.appVersion,
            specifiedType: const FullType.nullable(String),
          );
    yield r'is_household_admin';
    yield serializers.serialize(
      object.isHouseholdAdmin,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserOut object, {
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
    required UserOutBuilder result,
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
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fullName = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timezone = valueDes;
          break;
        case r'app_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.appVersion = valueDes;
          break;
        case r'is_household_admin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isHouseholdAdmin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserOutBuilder();
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

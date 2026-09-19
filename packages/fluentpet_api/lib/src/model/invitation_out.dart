//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invitation_out.g.dart';

/// InvitationOut
///
/// Properties:
/// * [id]
/// * [householdId]
/// * [householdName]
/// * [invitedBy]
/// * [email]
/// * [status]
/// * [expiresAt]
@BuiltValue()
abstract class InvitationOut
    implements Built<InvitationOut, InvitationOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'household_id')
  int get householdId;

  @BuiltValueField(wireName: r'household_name')
  String get householdName;

  @BuiltValueField(wireName: r'invited_by')
  String get invitedBy;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  InvitationOut._();

  factory InvitationOut([void updates(InvitationOutBuilder b)]) =
      _$InvitationOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvitationOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvitationOut> get serializer =>
      _$InvitationOutSerializer();
}

class _$InvitationOutSerializer implements PrimitiveSerializer<InvitationOut> {
  @override
  final Iterable<Type> types = const [InvitationOut, _$InvitationOut];

  @override
  final String wireName = r'InvitationOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvitationOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'household_id';
    yield serializers.serialize(
      object.householdId,
      specifiedType: const FullType(int),
    );
    yield r'household_name';
    yield serializers.serialize(
      object.householdName,
      specifiedType: const FullType(String),
    );
    yield r'invited_by';
    yield serializers.serialize(
      object.invitedBy,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InvitationOut object, {
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
    required InvitationOutBuilder result,
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
        case r'household_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.householdId = valueDes;
          break;
        case r'household_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.householdName = valueDes;
          break;
        case r'invited_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invitedBy = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvitationOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvitationOutBuilder();
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

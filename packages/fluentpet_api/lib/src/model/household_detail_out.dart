//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/invitation_out.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/user_out.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'household_detail_out.g.dart';

/// HouseholdDetailOut
///
/// Properties:
/// * [id]
/// * [name]
/// * [members]
/// * [invitations]
@BuiltValue()
abstract class HouseholdDetailOut
    implements Built<HouseholdDetailOut, HouseholdDetailOutBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'members')
  BuiltList<UserOut> get members;

  @BuiltValueField(wireName: r'invitations')
  BuiltList<InvitationOut> get invitations;

  HouseholdDetailOut._();

  factory HouseholdDetailOut([void updates(HouseholdDetailOutBuilder b)]) =
      _$HouseholdDetailOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HouseholdDetailOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HouseholdDetailOut> get serializer =>
      _$HouseholdDetailOutSerializer();
}

class _$HouseholdDetailOutSerializer
    implements PrimitiveSerializer<HouseholdDetailOut> {
  @override
  final Iterable<Type> types = const [HouseholdDetailOut, _$HouseholdDetailOut];

  @override
  final String wireName = r'HouseholdDetailOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HouseholdDetailOut object, {
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
    yield r'members';
    yield serializers.serialize(
      object.members,
      specifiedType: const FullType(BuiltList, [FullType(UserOut)]),
    );
    yield r'invitations';
    yield serializers.serialize(
      object.invitations,
      specifiedType: const FullType(BuiltList, [FullType(InvitationOut)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HouseholdDetailOut object, {
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
    required HouseholdDetailOutBuilder result,
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
        case r'members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UserOut)]),
          ) as BuiltList<UserOut>;
          result.members.replace(valueDes);
          break;
        case r'invitations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InvitationOut)]),
          ) as BuiltList<InvitationOut>;
          result.invitations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HouseholdDetailOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HouseholdDetailOutBuilder();
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

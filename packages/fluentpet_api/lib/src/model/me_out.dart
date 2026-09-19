//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/invitation_out.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluentpet_api/src/model/household_out.dart';
import 'package:fluentpet_api/src/model/pusher_out.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'me_out.g.dart';

/// MeOut
///
/// Properties:
/// * [id]
/// * [email]
/// * [fullName]
/// * [timezone]
/// * [appVersion]
/// * [isHouseholdAdmin]
/// * [household]
/// * [pushers]
/// * [featureFlags]
/// * [pendingInvitations]
@BuiltValue()
abstract class MeOut implements Built<MeOut, MeOutBuilder> {
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

  @BuiltValueField(wireName: r'household')
  HouseholdOut get household;

  @BuiltValueField(wireName: r'pushers')
  BuiltList<PusherOut> get pushers;

  @BuiltValueField(wireName: r'feature_flags')
  BuiltMap<String, JsonObject?> get featureFlags;

  @BuiltValueField(wireName: r'pending_invitations')
  BuiltList<InvitationOut> get pendingInvitations;

  MeOut._();

  factory MeOut([void updates(MeOutBuilder b)]) = _$MeOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeOut> get serializer => _$MeOutSerializer();
}

class _$MeOutSerializer implements PrimitiveSerializer<MeOut> {
  @override
  final Iterable<Type> types = const [MeOut, _$MeOut];

  @override
  final String wireName = r'MeOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeOut object, {
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
    yield r'household';
    yield serializers.serialize(
      object.household,
      specifiedType: const FullType(HouseholdOut),
    );
    yield r'pushers';
    yield serializers.serialize(
      object.pushers,
      specifiedType: const FullType(BuiltList, [FullType(PusherOut)]),
    );
    yield r'feature_flags';
    yield serializers.serialize(
      object.featureFlags,
      specifiedType: const FullType(
          BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'pending_invitations';
    yield serializers.serialize(
      object.pendingInvitations,
      specifiedType: const FullType(BuiltList, [FullType(InvitationOut)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MeOut object, {
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
    required MeOutBuilder result,
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
        case r'household':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HouseholdOut),
          ) as HouseholdOut;
          result.household.replace(valueDes);
          break;
        case r'pushers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PusherOut)]),
          ) as BuiltList<PusherOut>;
          result.pushers.replace(valueDes);
          break;
        case r'feature_flags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.featureFlags.replace(valueDes);
          break;
        case r'pending_invitations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InvitationOut)]),
          ) as BuiltList<InvitationOut>;
          result.pendingInvitations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MeOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeOutBuilder();
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

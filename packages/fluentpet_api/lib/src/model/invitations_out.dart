//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fluentpet_api/src/model/invitation_out.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invitations_out.g.dart';

/// InvitationsOut
///
/// Properties:
/// * [sent]
/// * [received]
@BuiltValue()
abstract class InvitationsOut
    implements Built<InvitationsOut, InvitationsOutBuilder> {
  @BuiltValueField(wireName: r'sent')
  BuiltList<InvitationOut> get sent;

  @BuiltValueField(wireName: r'received')
  BuiltList<InvitationOut> get received;

  InvitationsOut._();

  factory InvitationsOut([void updates(InvitationsOutBuilder b)]) =
      _$InvitationsOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvitationsOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvitationsOut> get serializer =>
      _$InvitationsOutSerializer();
}

class _$InvitationsOutSerializer
    implements PrimitiveSerializer<InvitationsOut> {
  @override
  final Iterable<Type> types = const [InvitationsOut, _$InvitationsOut];

  @override
  final String wireName = r'InvitationsOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvitationsOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sent';
    yield serializers.serialize(
      object.sent,
      specifiedType: const FullType(BuiltList, [FullType(InvitationOut)]),
    );
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(BuiltList, [FullType(InvitationOut)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InvitationsOut object, {
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
    required InvitationsOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InvitationOut)]),
          ) as BuiltList<InvitationOut>;
          result.sent.replace(valueDes);
          break;
        case r'received':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InvitationOut)]),
          ) as BuiltList<InvitationOut>;
          result.received.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvitationsOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvitationsOutBuilder();
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

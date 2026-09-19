//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'me_patch.g.dart';

/// MePatch
///
/// Properties:
/// * [fullName]
/// * [timezone]
/// * [appVersion]
@BuiltValue()
abstract class MePatch implements Built<MePatch, MePatchBuilder> {
  @BuiltValueField(wireName: r'full_name')
  String? get fullName;

  @BuiltValueField(wireName: r'timezone')
  String? get timezone;

  @BuiltValueField(wireName: r'app_version')
  String? get appVersion;

  MePatch._();

  factory MePatch([void updates(MePatchBuilder b)]) = _$MePatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MePatchBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MePatch> get serializer => _$MePatchSerializer();
}

class _$MePatchSerializer implements PrimitiveSerializer<MePatch> {
  @override
  final Iterable<Type> types = const [MePatch, _$MePatch];

  @override
  final String wireName = r'MePatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MePatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fullName != null) {
      yield r'full_name';
      yield serializers.serialize(
        object.fullName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.timezone != null) {
      yield r'timezone';
      yield serializers.serialize(
        object.timezone,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.appVersion != null) {
      yield r'app_version';
      yield serializers.serialize(
        object.appVersion,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MePatch object, {
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
    required MePatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MePatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MePatchBuilder();
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

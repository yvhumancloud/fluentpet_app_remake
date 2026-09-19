//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'url_out.g.dart';

/// UrlOut
///
/// Properties:
/// * [url]
@BuiltValue()
abstract class UrlOut implements Built<UrlOut, UrlOutBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  UrlOut._();

  factory UrlOut([void updates(UrlOutBuilder b)]) = _$UrlOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UrlOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UrlOut> get serializer => _$UrlOutSerializer();
}

class _$UrlOutSerializer implements PrimitiveSerializer<UrlOut> {
  @override
  final Iterable<Type> types = const [UrlOut, _$UrlOut];

  @override
  final String wireName = r'UrlOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UrlOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UrlOut object, {
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
    required UrlOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UrlOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UrlOutBuilder();
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

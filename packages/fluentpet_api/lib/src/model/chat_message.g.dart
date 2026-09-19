// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatMessageRoleEnum _$chatMessageRoleEnum_user =
    const ChatMessageRoleEnum._('user');
const ChatMessageRoleEnum _$chatMessageRoleEnum_assistant =
    const ChatMessageRoleEnum._('assistant');

ChatMessageRoleEnum _$chatMessageRoleEnumValueOf(String name) {
  switch (name) {
    case 'user':
      return _$chatMessageRoleEnum_user;
    case 'assistant':
      return _$chatMessageRoleEnum_assistant;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatMessageRoleEnum> _$chatMessageRoleEnumValues =
    BuiltSet<ChatMessageRoleEnum>(const <ChatMessageRoleEnum>[
  _$chatMessageRoleEnum_user,
  _$chatMessageRoleEnum_assistant,
]);

Serializer<ChatMessageRoleEnum> _$chatMessageRoleEnumSerializer =
    _$ChatMessageRoleEnumSerializer();

class _$ChatMessageRoleEnumSerializer
    implements PrimitiveSerializer<ChatMessageRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'user': 'user',
    'assistant': 'assistant',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'user': 'user',
    'assistant': 'assistant',
  };

  @override
  final Iterable<Type> types = const <Type>[ChatMessageRoleEnum];
  @override
  final String wireName = 'ChatMessageRoleEnum';

  @override
  Object serialize(Serializers serializers, ChatMessageRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatMessageRoleEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatMessageRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatMessage extends ChatMessage {
  @override
  final ChatMessageRoleEnum role;
  @override
  final String content;

  factory _$ChatMessage([void Function(ChatMessageBuilder)? updates]) =>
      (ChatMessageBuilder()..update(updates))._build();

  _$ChatMessage._({required this.role, required this.content}) : super._();
  @override
  ChatMessage rebuild(void Function(ChatMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessageBuilder toBuilder() => ChatMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessage &&
        role == other.role &&
        content == other.content;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatMessage')
          ..add('role', role)
          ..add('content', content))
        .toString();
  }
}

class ChatMessageBuilder implements Builder<ChatMessage, ChatMessageBuilder> {
  _$ChatMessage? _$v;

  ChatMessageRoleEnum? _role;
  ChatMessageRoleEnum? get role => _$this._role;
  set role(ChatMessageRoleEnum? role) => _$this._role = role;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  ChatMessageBuilder() {
    ChatMessage._defaults(this);
  }

  ChatMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _content = $v.content;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessage other) {
    _$v = other as _$ChatMessage;
  }

  @override
  void update(void Function(ChatMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatMessage build() => _build();

  _$ChatMessage _build() {
    final _$result = _$v ??
        _$ChatMessage._(
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'ChatMessage', 'role'),
          content: BuiltValueNullFieldError.checkNotNull(
              content, r'ChatMessage', 'content'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

import 'user_model.dart';

class ChatMessageModel {
  final String? id;
  final UserModel? sender;
  final String? content;
  final String? type;
  final String? chatRoom;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  ChatMessageModel({
    this.id,
    this.sender,
    this.content,
    this.type,
    this.chatRoom,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ChatMessageModel copyWith({
    String? id,
    UserModel? sender,
    String? content,
    String? type,
    String? chatRoom,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      type: type ?? this.type,
      chatRoom: chatRoom ?? this.chatRoom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  ChatMessageModel.fromJson(Map<String, dynamic> json)
    : id = json['_id'] as String?,
      sender = (json['sender'] as Map<String, dynamic>?) != null
          ? UserModel.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      content = json['content'] as String?,
      type = json['type'] as String?,
      chatRoom = json['chat_room'] as String?,
      createdAt = json['createdAt'] as String?,
      updatedAt = json['updatedAt'] as String?,
      v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'sender': sender?.toJson(),
    'content': content,
    'type': type,
    'chat_room': chatRoom,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}

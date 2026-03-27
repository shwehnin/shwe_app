import 'chat_message_model.dart';
import 'user_model.dart';

class ChatRoomModel {
  final String? id;
  final List<UserModel>? members;
  final String? roomName;
  final List<String>? roomAdmins;
  final String? roomAvatar;
  final String? createdBy;
  final ChatMessageModel? lastMessage;
  final String? roomType;
  final String? createdAt;
  final String? updatedAt;

  ChatRoomModel({
    this.id,
    this.members,
    this.roomName,
    this.roomAdmins,
    this.roomAvatar,
    this.createdBy,
    this.lastMessage,
    this.roomType,
    this.createdAt,
    this.updatedAt,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
    : id = json['_id'] as String?,
      members = (json['members'] as List?)
          ?.map((dynamic e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      roomName = json['room_name'] as String?,
      roomAdmins = (json['room_admins'] as List?)
          ?.map((dynamic e) => e as String)
          .toList(),
      roomAvatar = json['room_avatar'] as String?,
      createdBy = json['created_by'] as String?,
      lastMessage = (json['last_message'] as Map<String, dynamic>?) != null
          ? ChatMessageModel.fromJson(
              json['last_message'] as Map<String, dynamic>,
            )
          : null,
      roomType = json['room_type'] as String?,
      createdAt = json['createdAt'] as String?,
      updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'members': members?.map((e) => e.toJson()).toList(),
    'room_name': roomName,
    'room_admins': roomAdmins,
    'room_avatar': roomAvatar,
    'created_by': createdBy,
    'last_message': lastMessage?.toJson(),
    'room_type': roomType,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  ChatRoomModel copyWith({
    String? id,
    List<UserModel>? members,
    String? roomName,
    List<String>? roomAdmins,
    String? roomAvatar,
    String? createdBy,
    ChatMessageModel? lastMessage,
    String? roomType,
    String? createdAt,
    String? updatedAt,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      members: members ?? this.members,
      roomName: roomName ?? this.roomName,
      roomAdmins: roomAdmins ?? this.roomAdmins,
      roomAvatar: roomAvatar ?? this.roomAvatar,
      createdBy: createdBy ?? this.createdBy,
      lastMessage: lastMessage ?? this.lastMessage,
      roomType: roomType ?? this.roomType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

import 'package:flutter/material.dart';
import '../data/models/chat_message_model.dart';
import '../data/models/chat_room_model.dart';

class ChatRoomProvider extends ChangeNotifier {
  List<ChatRoomModel> chatRooms = [];

  assign(List<ChatRoomModel> chatList) {
    chatRooms = chatList;
    notifyListeners();
  }

  void updateLastMessage({
    required String roomId,
    required ChatMessageModel message,
  }) {
    var idx = chatRooms.indexWhere((rm) => rm.id == roomId);

    if (idx != -1) {
      // Update the room with the new last message
      var updatedRoom = chatRooms[idx].copyWith(lastMessage: message);

      // Create new list with updated room moved to top
      List<ChatRoomModel> updatedRooms = [updatedRoom];

      // Add other rooms (excluding the updated one)
      updatedRooms.addAll(
        chatRooms.where((room) => room.id != roomId).toList(),
      );
      chatRooms = updatedRooms;
      notifyListeners();
    }
  }
}

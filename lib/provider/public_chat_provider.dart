import 'package:flutter/material.dart';
import '../data/models/chat_message_model.dart';

class PublicChatProvider extends ChangeNotifier {
  List<ChatMessageModel> messages = [];

  assign(List<ChatMessageModel> messages) {
    this.messages = messages;
    notifyListeners();
  }

  addNew(ChatMessageModel message) {
    if (messages.any((e) => e.id == message.id)) return;
    // if (Global.user != null && message.sender!.id == Global.user!.id) return;
    messages.insert(0, message);
    notifyListeners();
  }
}

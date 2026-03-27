import 'api_service.dart';
import '../models/chat_message_model.dart';
import '../models/response_model.dart';
import '../../utils/const.dart';

class PrivateChatApi {
  PrivateChatApi._();

  static const String _url = "${Const.postSvrURL}/chat-message";

  static Future<ResponseModel> sendMessage({
    required String content,
    required String chatRoomId,
  }) async {
    var url = "$_url/create";
    var body = {"content": content, "chat_room": chatRoomId};

    var resp = await ApiService.post(url: url, body: body);

    if (resp.status) {
      resp.data = ChatMessageModel.fromJson(resp.data);
    }

    return resp;
  }

  static Future<ResponseModel> loadHistory({
    int page = 1,
    required String chatRoomId,
  }) async {
    var url = "$_url/by-room/$chatRoomId?page=$page";
    var resp = await ApiService.get(url: url);
    if (resp.status) {
      var list = resp.data as List<dynamic>;
      resp.data = list.map((e) => ChatMessageModel.fromJson(e)).toList();
    }

    return resp;
  }
}

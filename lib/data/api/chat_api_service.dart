import 'api_service.dart';
import '../models/chat_room_model.dart';
import '../models/response_model.dart';
import '../../utils/const.dart';

class ChatApiService {
  ChatApiService._();

  static const String _url = "${Const.postSvrURL}/chat-room";

  static Future<ResponseModel> getChatList() async {
    var url = "$_url/by-user";

    var resp = await ApiService.post(url: url);

    if (resp.status) {
      var list = resp.data as List<dynamic>;
      resp.data = list.map((e) => ChatRoomModel.fromJson(e)).toList();
    }

    return resp;
  }

  static Future<ResponseModel> createChat({
    required List<String> members,
    String? roomName,
  }) async {
    var url = "$_url/create";

    var resp = await ApiService.post(
      url: url,
      body: {"members": members, "room_name": roomName},
    );

    if (resp.status) {
      resp.data = ChatRoomModel.fromJson(resp.data);
    }

    return resp;
  }
}

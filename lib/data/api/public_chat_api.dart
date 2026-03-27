import 'api_service.dart';
import '../models/chat_message_model.dart';
import '../models/response_model.dart';
import '../../utils/const.dart';

class PublicChatApi {
  static Future<ResponseModel> getChatHistory() async {
    var response = await ApiService.get(
      url: "${Const.workerURL}/api/chat/history",
    );

    if (response.status) {
      var list = response.data as List<dynamic>;
      response.data = list.map((e) => ChatMessageModel.fromJson(e)).toList();
    }

    return response;
  }
}

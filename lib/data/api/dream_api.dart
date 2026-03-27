import 'api_service.dart';
import '../models/dream_model.dart';
import '../models/response_model.dart';
import '../../utils/const.dart';

class DreamApi {
  static Future<ResponseModel> get() async {
    var response = await ApiService.get(url: "${Const.workerURL}/dream/get");

    if (response.status) {
      response.data = (response.data as List)
          .map((e) => Dream.fromJson(e))
          .toList();
    }
    return response;
  }
}

import 'api_service.dart';
import '../models/config_model.dart';
import '../models/response_model.dart';
import '../../utils/const.dart';
import '../../utils/global.dart';
import '../../utils/shared_pref.dart';

class ConfigApi {
  static const _url = "${Const.workerURL}/config";
  static Future<ResponseModel?> get() async {
    String? email = await SharedPref.getData(key: Const.token);
    var response = await ApiService.get(url: "$_url/get?email=$email");

    if (response.status) {
      Global.config = ConfigModel.fromJson(response.data);
      Global.user = Global.config.user?.profile;
      if (Global.user != null) {
        Global.isBanned.value = Global.user!.isBanned ?? false;
      }
    }

    return response;
  }
}

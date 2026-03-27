import 'api_service.dart';
import '../models/lotto_thai_model.dart';
import '../models/response_model.dart';
import '../../utils/const.dart';

class LotoThaiApi {
  static final _url = "${Const.workerURL}/th-lottery";

  static Future<ResponseModel> get() async {
    var response = await ApiService.get(url: '$_url/get');

    if (response.status) {
      response.data = LottoThaiModel.fromJson(response.data);
    }
    return response;
  }
}

import 'api_service.dart';
import '../models/response_model.dart';
import '../../utils/const.dart';

class GiftApi {
  static final _url = "${Const.workerURL}/gift";

  static Future<ResponseModel> get({required String giftType}) async {
    return await ApiService.post(
      url: '$_url/get',
      body: {"gift_type": giftType},
    );
  }
}

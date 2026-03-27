import '../models/response_model.dart';
import '../models/three_d_model.dart';
import '../../utils/const.dart';

import 'api_service.dart';

class ThreedApi {
  static const String _url = '${Const.dataSvrURL}/threed';

  static Future<ResponseModel> get({int page = 1}) async {
    ResponseModel res = await ApiService.get(url: '$_url?page=$page');
    if (res.status) {
      var nums = res.data as List;
      res.data = nums.map((e) => ThreeDModel.fromJson(e)).toList();
    }
    return res;
  }
}

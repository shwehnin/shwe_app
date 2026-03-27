import '../models/analysis_model.dart';
import '../models/response_model.dart';
import '../models/stock_model.dart';
import '../../utils/const.dart';

import 'api_service.dart';

class TwodApi {
  static final _url = "${Const.dataSvrURL}/twod";

  static Future<ResponseModel> analysis() async {
    var resp = await ApiService.get(url: '$_url/analysis');
    if (resp.status) {
      resp.data = AnalysisModel.fromJson(resp.data);
    }
    return resp;
  }

  static Future<ResponseModel> byYear({
    required int year,
    required int month,
  }) async {
    var resp = await ApiService.post(
      url: '$_url/by-year',
      body: {"year": year, "month": month},
    );
    if (resp.status) {
      var list = resp.data as List;
      resp.data = list.map((e) => StockModel.fromJson(e)).toList();
    }
    return resp;
  }

  static Future<ResponseModel> getAll({int page = 1}) async {
    var resp = await ApiService.get(url: '$_url?page=$page');
    if (resp.status) {
      var list = resp.data as List;
      resp.data = list.map((e) => StockModel.fromJson(e)).toList();
    }
    return resp;
  }
}

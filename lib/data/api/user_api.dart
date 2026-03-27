import 'package:dio/dio.dart';
import 'api_service.dart';
import '../models/picked_file.dart';
import '../models/response_model.dart';
import '../models/user_model.dart';
import '../../utils/const.dart';
import '../../utils/global.dart';

class UserApi {
  static final _postServerUrl = "${Const.postSvrURL}/user";
  static final _url = "${Const.workerURL}/user";

  static Future<ResponseModel> update({
    String? name,
    String? coverURL,
    PickedFile? file,
  }) async {
    String url = '$_postServerUrl/${Global.user!.id}';
    Map<String, dynamic> data = {};

    if (name != null) {
      data['name'] = name;
    }

    if (file != null) {
      data['cover'] = MultipartFile.fromBytes(file.bytes, filename: file.name);
    }

    if (coverURL != null) {
      data['cover'] = coverURL;
    }

    var resp = await ApiService.patch(
      url: url,
      formData: FormData.fromMap(data),
    );
    if (resp.status) {
      resp.data = UserModel.fromJson(resp.data);
    }
    return resp;
  }

  static Future<ResponseModel> addToBlockList({required UserModel user}) async {
    return await ApiService.post(
      url: '$_url/add-block-list',
      body: {"email": Global.user!.email, "unwanted_user": user.toJson()},
    );
  }

  static Future<ResponseModel> removeFromBlockList({
    required UserModel user,
  }) async {
    return await ApiService.delete(
      url: '$_url/unblock',
      body: {"email": Global.user!.email, "unwanted_user": user.toJson()},
    );
  }
}

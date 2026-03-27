import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/response_model.dart';
import '../../utils/const.dart';
import 'api_service.dart';

class PostApi {
  PostApi._();

  static const String _url = '${Const.postSvrURL}/post';

  static Future<ResponseModel> get({int page = 1}) async {
    ResponseModel res = await ApiService.get(
      url: '$_url?page=$page',
    );
    if (res.status) {
      var nums = res.data as List;
      res.data = nums.map((e) => PostModel.fromJson(e)).toList();
    }
    return res;
  }

  static Future<ResponseModel> getComments(
      {required String post, int page = 1}) async {
    ResponseModel res = await ApiService.post(
      url: '$_url/$post/get-comment?page=$page',
    );
    if (res.status) {
      var nums = res.data as List;
      res.data = nums.map((e) => CommentModel.fromJson(e)).toList();
    }
    return res;
  }

  static Future<ResponseModel> addComments({
    required String post,
    required String content,
  }) async {
    ResponseModel res = await ApiService.post(
      url: '$_url/$post/add-comment',
      body: {'content': content},
    );
    if (res.status) {
      res.data = CommentModel.fromJson(res.data);
    }
    return res;
  }

  static Future<ResponseModel> toggleLike({required String post}) async {
    return await ApiService.post(url: '$_url/$post/like');
  }
}

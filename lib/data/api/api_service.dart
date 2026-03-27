import '../models/response_model.dart';
import '../../utils/const.dart';
import '../../utils/shared_pref.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';
import 'package:restart_app/restart_app.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

enum RequestMethod { get, post, put, patch, delete }

class ApiService {
  static const _dataKey = "data";
  static const _statusKey = "status";
  static const _messageKey = "message";
  // static const _authorizationHeader = 'Authorization';
  // static const _bearerPrefix = 'Bearer ';
  static late Dio dio;
  static Future<ResponseModel> _request(
    RequestMethod method, {
    required String url,
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
  }) async {
    dio = _createDioInstance();
    try {
      final response = await _executeRequest(
        dio,
        method,
        url,
        formData,
        body,
        params,
      );
      return _handleResponse(response);
    } catch (e) {
      return ResponseModel(
        status: false,
        data: null,
        msg: 'Error -> ${e.toString()}',
      );
    }
  }

  static Dio _createDioInstance() {
    final options = BaseOptions(
      validateStatus: (status) => status! <= 500,
      headers: {
        'access-code': 'ruby_master',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final dios = Dio(options);
    dios.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
      RetryInterceptor(
        dio: dios,
        retries: 10, // Reduced from 10 to 3 for better UX
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
      InterceptorsWrapper(
        onRequest: _addAuthHeader,
        onResponse: _handleAuthResponse,
        onError: _handleAuthError,
      ),
    ]);
    return dios;
  }

  static Future<void> _addAuthHeader(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SharedPref.getData(key: Const.token);
    if (token != null) {
      options.headers["email"] = token;
    }
    handler.next(options);
  }

  static Future<void> _handleAuthResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 400) {
      await _clearTokensAndRestart();
      return;
    }

    if (response.statusCode == 498) {
      try {
        // final resp = await UserApiService.refreshToken();
        // response.requestOptions.headers[_authorizationHeader] =
        //     '$_bearerPrefix${resp.data}';
        // final newResponse = await dio.fetch(response.requestOptions);
        // handler.resolve(newResponse);
      } catch (e) {
        await _clearTokensAndRestart();
      }
      return;
    }
    handler.next(response);
  }

  static Future<void> _handleAuthError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 400) {
      await _clearTokensAndRestart();
      return;
    }

    if (error.response?.statusCode == 498) {
      try {
        // final resp = await UserApiService.refreshToken();
        // error.requestOptions.headers[_authorizationHeader] =
        //     '$_bearerPrefix${resp.data}';
        // final newResponse = await dio.fetch(error.requestOptions);
        // handler.resolve(newResponse);
      } catch (e) {
        await _clearTokensAndRestart();
      }
      return;
    }
    handler.next(error);
  }

  static Future<void> _clearTokensAndRestart() async {
    // await SharedPref.clearData(key: Const.token);
    // await SharedPref.clearData(key: Const.refreshToken);
    Restart.restartApp();
  }

  static Future<Response> _executeRequest(
    Dio dio,
    RequestMethod method,
    String url,
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
  ) async {
    switch (method) {
      case RequestMethod.get:
        return dio.get(url, data: body, queryParameters: params);
      case RequestMethod.post:
        return dio.post(url, data: formData ?? body, queryParameters: params);
      case RequestMethod.put:
        return dio.put(url, data: formData ?? body, queryParameters: params);
      case RequestMethod.patch:
        return dio.patch(url, data: formData ?? body, queryParameters: params);
      case RequestMethod.delete:
        return dio.delete(url, data: formData ?? body, queryParameters: params);
    }
  }

  static ResponseModel _handleResponse(Response response) {
    final responseData = response.data as Map<String, dynamic>? ?? {};
    final isSuccess = response.statusCode == 200 || response.statusCode == 201;
    final status = responseData[_statusKey] as bool? ?? false;
    final message =
        responseData[_messageKey] as String? ??
        'Error ${isSuccess ? '' : 'Code '}-> ${response.statusCode}';

    return ResponseModel(
      status: isSuccess && status,
      data: responseData[_dataKey],
      msg: message,
    );
  }

  // Public request methods
  static Future<ResponseModel> get({
    required String url,
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
  }) => _request(
    RequestMethod.get,
    url: url,
    formData: formData,
    body: body,
    params: params,
  );

  static Future<ResponseModel> post({
    required String url,
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
  }) => _request(
    RequestMethod.post,
    url: url,
    formData: formData,
    body: body,
    params: params,
  );

  static Future<ResponseModel> put({
    required String url,
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
  }) => _request(
    RequestMethod.put,
    url: url,
    formData: formData,
    body: body,
    params: params,
  );

  static Future<ResponseModel> patch({
    required String url,
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
  }) => _request(
    RequestMethod.patch,
    url: url,
    formData: formData,
    body: body,
    params: params,
  );

  static Future<ResponseModel> delete({
    required String url,
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
  }) => _request(
    RequestMethod.delete,
    url: url,
    formData: formData,
    body: body,
    params: params,
  );
}

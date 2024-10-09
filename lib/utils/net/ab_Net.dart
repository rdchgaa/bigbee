

import 'dart:convert';
import 'dart:io';

import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/net/net_model.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../pages/login_regist/start_page.dart';
import '../ab_shared_preferences.dart';
import 'dio_manager.dart';

const bool isTest = true;
const String baseUrl = "http://api.beechatai.cc";
const String baseUrlTest = "http://192.168.110.190:9181";
const String signString = "d75Lcq6aj195vYJX1nQ4q7q3o3goEOqf";
const String signStringTest = "sWXrnTln2sq0Rj7CkDmFpmIaqAZY63hm";
const Duration _connectTimeout = Duration(milliseconds: 15000);
const Duration _receiveTimeout = Duration(milliseconds: 15000);
const Duration _sendTimeout = Duration(milliseconds: 15000);


class ABNet {

  static void config() {
    DioManager.instance.setOptions(_defaultOptions());
  }

  static Future<RequestResult<T>> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? params,
    Options? options,
    bool isShowTip = true,
    bool showLoading = false,
  }) async {

    if(showLoading){
      ABLoading.show();
    }
    Response response;
    final resu = await doRequest(path: path, method: method, params: params, options: options);
    if(showLoading){
      await ABLoading.dismiss();
    }
    if (resu.$2 != null) {
      final result = _errorAction<T>(resu.$2!, path: path);
      if (isShowTip) {
        ABToast.show(result.error?.message ?? "请求失败，请检查网络");
      }
      return Future.value(result);
    }
    if (resu.$1 == null) {
      if (isShowTip) {
        ABToast.show("请求失败，请检查网络");
      }
      return Future.value(RequestResult(null, ErrorMessageModel(code: 999, message: "请求失败，请检查网络")));
    }
    response = resu.$1!;
    if (response.data == null) {
      if (isShowTip) {
        ABToast.show("请求失败，请检查网络");
      }
      return RequestResult(null, ErrorMessageModel(code: 999, message: "请求失败，请检查网络"));
    }
    final resultModel = RequestResult<T>.fromJson(response.data);
    if (resultModel.code == 401) {
      // ABSharedPreferences.clear();
      await ABSharedPreferences.setToken("");
      await ABSharedPreferences.setUserId("");
      await ABSharedPreferences.setUserSign("");
      Future.delayed(Duration(milliseconds: 500)).then((_){
        ABRoute.popToRoot();
        ABRoute.pushReplacement(const StartPage(), tag: "root");
      });

    }
    if (isShowTip && resultModel.error != null) {
      ABToast.show(resultModel.error?.message ?? "数据错误");
    }
    return Future.value(resultModel);
  }


  // 分页
  static Future<RequestResult<PageModel<T>>> requestPage<T>({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? params,
    Options? options,
    bool isShowTip = true,
  }) async {

    Response response;
    final resu = await doRequest(path: path, method: method, params: params, options: options);
    if (resu.$2 != null) {
      final result = _errorAction<PageModel<T>>(resu.$2!, path: path);
      if (isShowTip) {
        ABToast.show(result.error?.message ?? "请求失败，请检查网络");
      }
      return Future.value(result);
    }
    if (resu.$1 == null) {
      if (isShowTip) {
        ABToast.show("请求失败，请检查网络");
      }
      return Future.value(RequestResult(null, ErrorMessageModel(code: 999, message: "请求失败，请检查网络")));
    }
    response = resu.$1!;
    if (response.data == null) {
      if (isShowTip) {
        ABToast.show("请求失败，请检查网络");
      }
      return RequestResult(null, ErrorMessageModel(code: 999, message: "请求失败，请检查网络"));
    }
    final resultModel = RequestResult.pageModelFromJson<T>(response.data);
    if (resultModel.code == 401) {
      await ABSharedPreferences.setToken("");
      await ABSharedPreferences.setUserId("");
      await ABSharedPreferences.setUserSign("");
      Future.delayed(Duration(milliseconds: 500)).then((_){
        ABRoute.popToRoot();
        ABRoute.pushReplacement(const StartPage(), tag: "root");
      });
    }
    if (isShowTip && resultModel.error != null) {
      ABToast.show(resultModel.error?.message ?? "数据错误");
    }
    return Future.value(resultModel);
  }



  static RequestResult<T> _errorAction<T>(DioException e, {required String path}) {
    final response = e.response;
    if (response?.data == null) {
      return RequestResult(null, ErrorMessageModel(code: 999, message: "请求失败，请检查网络"));
    }
    String msg = 'Unknown error';
    final errorMessage = ErrorMessageModel.fromJson(response?.data);
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        msg = 'Connect timeout';
      case DioExceptionType.connectionError:
        msg = 'Connect error';
      case DioExceptionType.badCertificate:
        msg = 'Bad certificate';
      case DioExceptionType.sendTimeout:
        msg = 'Send timeout';
      case DioExceptionType.receiveTimeout:
        msg = 'Receive timeout';
      case DioExceptionType.badResponse:
        msg = 'Bad response';
      case DioExceptionType.cancel:
        msg = 'Request cancel';
      case DioExceptionType.unknown:
        msg = e.message ?? 'Unknown error';
    }
    debugPrint("请求错误：${path} - ${errorMessage.message}");
    if (errorMessage.message == null || errorMessage.message!.isEmpty) {
      errorMessage.message = msg;
    }
    return RequestResult(null, errorMessage);
  }


  static Future<(Response?, DioException?)> doRequest({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    final languageCode = ABSharedPreferences.getLanguageCodeSync() ?? "zh";
    Response response;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyyMMddHHmmss").format(now);
    // 签名
    String sign = _signature(params: params, timestamp: formattedDate);
    // 配置请求头
    Options op = options ?? Options();
    Map<String, dynamic> headers = op.headers ?? {};
    headers["h-timestamp"] = formattedDate;
    headers["h-sign"] = sign;
    headers["access-auth-token"] = "Bearer ${ABSharedPreferences.getTokenSync()}";
    headers["accept-language"] = Locale.fromSubtags(languageCode: languageCode).acceptLanguage;
    op.headers = headers;
    try {
      switch (method) {
        case HttpMethod.get:
          response = await DioManager.instance.get(path, params: params, options: op);
        case HttpMethod.post:
          response = await DioManager.instance.post(path, data: params, options: op);
        case HttpMethod.put:
          response = await DioManager.instance.put(path, data: params, options: op);
        case HttpMethod.delete:
          response = await DioManager.instance.delete(path, data: params, options: op);
      }
    } on DioException catch (e) {
      print("请求异常：$path - ${e}");
      return Future.value((null, e));
    }
    return Future.value((response, null));
  }


  /* 默认选项
  * */
  static BaseOptions _defaultOptions() {
    final languageCode = ABSharedPreferences.getLanguageCodeSync() ?? "zh";
    var headers = {
      "Content-Type": HttpContentType.json.value,
      "access-auth-token": "Bearer ${ABSharedPreferences.getTokenSync()}",
      "accept-language": Locale.fromSubtags(languageCode: languageCode).acceptLanguage,
    };
    // 初始选项
    var options = BaseOptions(
      baseUrl: isTest ? baseUrlTest : baseUrl,
      headers: headers,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      responseType: ResponseType.json,
    );
    return options;
  }

  /* 签名
  * params: 请求参数
  * timestamp: 时间戳
  * */
  static String _signature({Map<String, dynamic>? params, required String timestamp}) {
    Map<String, dynamic> p = Map<String, dynamic>.from(params ?? {});
    p["_t"] = timestamp;
    // 字典排序
    List<String> sortedKeys = p.keys.toList()..sort();
    String value = "";
    for (var key in sortedKeys) {
      final v = p[key];
      // 如果v是List<String>，转为json
      if (v is List<String>) {
        value += json.encode(v);
      } else {
        value += "${p[key]}";
      }
    }
    value += isTest ? signStringTest : signString;
    print("签名前 - ${value}");
    final sign = md5.convert(utf8.encode(value)).toString().toUpperCase();
    print("签名后 - ${sign}");
    return sign;
  }


}

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

enum HttpContentType {
  json,
  form,
}
extension HttpContentTypeExtension on HttpContentType {
  String get value {
    switch (this) {
      case HttpContentType.json:
        return "application/json";
      case HttpContentType.form:
        return "application/x-www-form-urlencoded";
    }
  }
}


import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class DioManager {
  static final DioManager instance = DioManager._();
  late Dio _dio;

  DioManager._() {
    _dio = Dio(BaseOptions());
    // 拦截器
    _dio.interceptors.add(RequestInterceptors());
  }

  void setOptions(BaseOptions options) {
    _dio.options = options;
  }
  void addInterceptors(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// get 请求
  Future<Response> get(
      String url, {
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
        String? contentType,
      }) async {
    Options requestOptions = options ?? Options();
    if (contentType != null) {
      requestOptions.contentType = contentType;
    }
    Response response = await _dio.get(
      url,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// post 请求
  Future<Response> post(
      String url, {
        dynamic data,
        Options? options,
        CancelToken? cancelToken,
        String? contentType,
      }) async {
    var requestOptions = options ?? Options();
    if (contentType != null) {
      requestOptions.contentType = contentType;
    }
    Response response = await _dio.post(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// put 请求
  Future<Response> put(
      String url, {
        dynamic data,
        Options? options,
        CancelToken? cancelToken,
        String? contentType,
      }) async {
    var requestOptions = options ?? Options();
    if (contentType != null) {
      requestOptions.contentType = contentType;
    }
    Response response = await _dio.put(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// delete 请求
  Future<Response> delete(
      String url, {
        dynamic data,
        Options? options,
        CancelToken? cancelToken,
        String? contentType,
      }) async {
    var requestOptions = options ?? Options();
    if (contentType != null) {
      requestOptions.contentType = contentType;
    }
    Response response = await _dio.delete(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

}

/// 拦截
class RequestInterceptors extends Interceptor {
  //

  /// 发送请求
  /// 我们这里可以添加一些公共参数，或者对参数进行加密
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint("请求url: [${options.method}] ${options.uri}");
    debugPrint("请求头: ${options.headers}");
    debugPrint("请求参数: ${options.data}");
    // super.onRequest(options, handler);

    // http header 头加入 Authorization
    // if (UserService.to.hasToken) {
    //   options.headers['Authorization'] = 'Bearer ${UserService.to.token}';
    // }

    return handler.next(options);
    // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  }

  /// 响应
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("响应数据: ${response.data}");
    handler.next(response);
  }

  /// 错误
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final exception = HttpException(err.message ?? "error message");
    DioException errNext = err.copyWith(
      error: exception,
    );
    handler.next(errNext);
  }
}


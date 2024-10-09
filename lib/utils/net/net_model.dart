import 'package:bee_chat/models/common/empty_model.dart';
import 'package:flutter/cupertino.dart';

import '../../generated/json/base/json_convert_content.dart';

/// 错误体信息
class ErrorMessageModel {
  int? code;
  String? error;
  String? message;

  ErrorMessageModel({this.code, this.error, this.message});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      code: json['code'] as int?,
      error: json['error'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'error': error,
    'message': message,
  };
}


class RequestResult<T> {
  final int? code;
  final String? message;
  final bool? success;
  final T? data;
  final ErrorMessageModel? error;
  final dynamic jsonData;
  RequestResult(this.data, this.error, {this.code, this.message, this.success, this.jsonData});

  factory RequestResult.fromJson(Map<String, dynamic> json) {
    final code = json['code'] as int?;
    final data = json['data'];
    final success = json['success'] as bool?;
    final message = json['message'] as String?;
    if (code == 200) {
      if (T == EmptyModel) {
        return RequestResult(EmptyModel() as T, null, code: code, message: message, success: success, jsonData: data);
      }
      if (data == null) {
        return RequestResult(null, ErrorMessageModel(code: 900, message: "数据为空"), code: code, message: message, success: success, jsonData: data);
      }
      final model = JsonConvert.fromJsonAsT<T>(data);
      if (model != null) {
        return RequestResult(model, null, code: code, message: message, success: success, jsonData: data);
      }
      return RequestResult(null, ErrorMessageModel(code: 901, message: "数据解析错误"), code: code, message: message, success: success, jsonData: data);

    } else {
      return RequestResult(null, ErrorMessageModel(code: code, message: message), code: code, message: message, success: success, jsonData: data);
    }

  }


  static RequestResult<PageModel<M>> pageModelFromJson<M>(Map<String, dynamic> json) {
    final code = json['code'] as int?;
    final data = json['data'];
    final success = json['success'] as bool?;
    final message = json['message'] as String?;
    if (code == 200) {
      if (data == null) {
        return RequestResult(null, ErrorMessageModel(code: 900, message: "数据为空"), code: code, message: message, success: success, jsonData: data);
      }
      final model = PageModel.fromJson<M>(data);
      return RequestResult(model, null, code: code, message: message, success: success, jsonData: data);
    } else {
      return RequestResult(null, ErrorMessageModel(code: code, message: message), code: code, message: message, success: success, jsonData: data);
    }
  }


}

class PageModel<T> {
  final int current;
  final int size;
  late final int total;
  // 总页数
  final int pages;
  final List<T> records;

  PageModel({this.current = 1, this.size = 10, this.total = 0, this.pages = 1, this.records = const []});



  static PageModel<T> fromJson<T>(Map<String, dynamic> json) {
    final int current = jsonConvert.convert<int>(json['current']) ?? 1;
    final int size = jsonConvert.convert<int>(json['size']) ?? 10;
    final int total = jsonConvert.convert<int>(json['total']) ?? 0;
    final int pages = jsonConvert.convert<int>(json['pages']) ?? 0;

    if (json['records'] == null) {
      return PageModel(
        current: current,
        size: size,
        total: total,
        pages: pages,
        records: [],
      );
    }
    final model = JsonConvert.fromJsonAsT<List<T>>(json['records']);
    if (model != null) {
      return PageModel(
        current: current,
        size: size,
        total: total,
        pages: pages,
        records: model,
      );
    } else {
      return PageModel(
        current: current,
        size: size,
        total: total,
        pages: pages,
        records: [],
      );
    }

  }



}



import 'dart:convert';

import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

import 'color_extensions.dart';

extension HexStringToColor on String {
  Color get hexColor => HexColor(this);
}

extension StringToMD5String on String {
  String get generateMD5 {
    final Uint8List content = const Utf8Encoder().convert(this);
    final Digest digest = md5.convert(content);
    return digest.toString();
  }
}

extension UrlParametersString on String? {
  String queryParametersOf(String key) {
    if (this?.isNotEmpty == true) {
      try {
        final uri = Uri.parse(this!);
        final queryParameters = uri.queryParameters;
        String value = queryParameters[key] ?? '';
        if (value.isEmpty) {
          // 解决 url 包含 # 号的特殊情况
          final fragment = uri.fragment;
          if (fragment.isNotEmpty) {
            value = fragment.queryParametersOf(key);
          }
        }
        return value;
      } catch (e) {
        print('queryParametersOf key = $key error: $e');
        return '';
      }
    }
    return '';
  }

  Map<String, String>? queryParameters() {
    if (this?.isNotEmpty == true) {
      try {
        final uri = Uri.parse(this!);
        return uri.queryParameters;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String queryUriPath() {
    if (this?.isNotEmpty == true) {
      try {
        if (!this!.startsWith('kangxun://')) return '';
        final uri = Uri.parse(this!);
        return uri.path;
      } catch (e) {
        return '';
      }
    }
    return '';
  }
}

extension ClipboardStrExt on String? {
  // 复制到剪切版
  void copy({String tip = "Successful replication"}) {
    if (this?.isNotEmpty == true) {
      Clipboard.setData(ClipboardData(text: this ?? ""));
      ABToast.show(tip);
    }
  }
}

extension JsonString on String? {
  Map<String, dynamic>? get toJson {
    if (this == null) {
      return null;
    }
    try {
      return json.decode(this!);
    } catch (e) {
      return null;
    }
  }
}

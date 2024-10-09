import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:heif_converter/heif_converter.dart';
import '../models/common/upload_sign_model.dart';
import '../net/common_net.dart';
import 'dart:ui' as ui;

class OssUtils {

  static Future<(String?, String)> uploadToOss({required String path}) async {
    final S = AB_getS(MyApp.context, listen: false);
    String ext = getFileExtension(path: path);
    if (ext == "heic" || ext == "HEIC") {
      path = await heicToPng(path: path);
      ext = getFileExtension(path: path);
    }

    if (ext.isEmpty) return Future.value((null, S.filePathError));
    final result = await CommonNet.getOssToken(fileSuf: ext);
    if (result.data != null) {
      return _requestOss(signModel: result.data!, path: path);
    }
    if (result.error?.message != null && result.error!.message!.isNotEmpty) {
      return Future.value((null, result.error!.message!));
    }
    return Future.value((null, S.uploadSignError));
  }

  static Future<(List<String>, String)> uploadMultiFilesToOss({required List<String> paths}) async {
    final futures = paths.map((item) => uploadToOss(path: item)).toList();
    final results = await Future.wait(futures);
    final errorList = results.where((item) => (item.$1 == null || item.$1?.isEmpty == true)).toList();
    if (errorList.isNotEmpty) {
      return Future.value(([], errorList.first.$2) as FutureOr<(List<String>, String)>?);
    } else {
      return Future.value((results.map((item) => item.$1 ?? "").toList(), ""));
    }
  }

  static Future<(String?, String)> _requestOss({required UploadSignModel signModel, required String path}) async {
    final S = AB_getS(MyApp.context, listen: false);
    final host = signModel.host ?? "";
    var url = host;
    BaseOptions options = BaseOptions();
    options.responseType = ResponseType.plain;
    //创建dio对象
    Dio dio = Dio(options);
    // 生成oss的路径和文件名我这里目前设置的是moment/20201229/test.mp4
    String pathName = '${signModel.fileDir ?? ""}${signModel.fileName ?? ""}';
    // 请求参数的form对象
    FormData data = FormData.fromMap({
      'key': pathName,
      'policy': signModel.policy ?? "",
      'OSSAccessKeyId': signModel.accessKeyId ?? "",
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': signModel.signature ?? "",
      'contentType': 'multipart/form-data',
      'file': MultipartFile.fromFileSync(path),
    });
    Options? options1 = Options(headers: {
      "x-oss-storage-class": "IA", //低频存储
      "Host": "beechats.oss-cn-beijing.aliyuncs.com",
      "Content-Encoding": "utf-8",
      "Content-Type": "multipart/form-data",
      'Authorization': "OSS ${signModel.accessKeyId ?? ""}:${signModel.signature ?? ""}",
    });
    Response response;
    CancelToken uploadCancelToken = CancelToken();
    try {
      // 发送请求
      response = await dio.post(url, data: data, options: options1, cancelToken: uploadCancelToken, onSendProgress: (int count, int total) {
        print("进度 -  ${count} - ${total}");
      });
      print(" - ${response.statusCode}");
      if (response.statusCode == 200) {
        return Future.value(("$url$pathName", S.uploadSuccess));
      } else {
        return Future.value((null, S.uploadError));
      }
    } on DioException catch (e) {
      print(e);
      return Future.value((null, S.uploadError));
    }
  }

  // 获取文件后缀
  static String getFileExtension({required String path}) {
    if (path.isEmpty) return "";
    int dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex >= path.length - 1) {
      return '';
    }
    return path.substring(dotIndex + 1);
  }

  static Future<String> heicToPng({String path = ''}) async {
    print("开始转换 - ${path}");
    if (!path.endsWith(".HEIC") && !path.endsWith(".heic")) {
      return Future.value(path);
    }
    final jpgFilePath = path.replaceAll(".HEIC", ".JPEG").replaceAll(".heic", ".JPEG");
    final jpgFilePath1 = path.replaceAll(".HEIC", "1.JPEG").replaceAll(".heic", "1.JPEG");
    final pngFilePath = path.replaceAll(".HEIC", ".png").replaceAll(".heic", ".png");


    String? jpgPath = await HeifConverter.convert(path, output: jpgFilePath);
    // String? pngPath = await HeifConverter.convert(path, format: 'png');

    var result = await FlutterImageCompress.compressAndGetFile(
      jpgFilePath, jpgFilePath1,
      quality: 88,
      rotate: 180,
    );
    print(result?.lengthSync());
    return Future.value(jpgFilePath1 ?? "");


  }

}


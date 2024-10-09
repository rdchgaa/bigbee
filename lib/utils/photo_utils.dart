import 'dart:io';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUtils {
  ///选择一个图片
  ///[from] 是相机还是图库
  ///可选参数
  ///[maxWidth] 宽度,
  ///[maxHeight] 高度,
  ///[imageQuality] 质量
  static Future<XFile?> pickSinglePic(ImageFrom from,
      {double? maxWidth, double? maxHeight, int? imageQuality}) async {
    ImageSource source;
    switch (from) {
      case ImageFrom.camera:
        source = ImageSource.camera;
        break;
      case ImageFrom.gallery:
        source = ImageSource.gallery;
        break;
    }
    final pickerImages = await ImagePicker().pickImage(
      source: source,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return pickerImages;
  }

  ///裁切图片
  ///[image] 图片路径或文件
  ///[width] 宽度
  ///[height] 高度
  ///[aspectRatio] 比例
  ///[androidUiSettings]UI 参数
  ///[iOSUiSettings] ios的ui 参数
  static cropImage(
      {required image,
      required CropAspectRatio aspectRatio,
      androidUiSettings,
      iOSUiSettings}) async {
    String imagePth = "";
    if (image is String) {
      imagePth = image;
    } else if (image is File) {
      imagePth = image.path;
    } else {
      throw ("文件路径错误");
    }
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePth,
      maxWidth: ABScreen.width.toInt(),
      maxHeight: ABScreen.width.toInt(),
      aspectRatio: aspectRatio,
      uiSettings: [
        androidUiSettings ??
            AndroidUiSettings(
                toolbarTitle:
                    '${AB_getS(MyApp.context, listen: false).cutting}(${ABScreen.width.toInt()}*${ABScreen.width.toInt()})',
                toolbarColor:
                    AB_theme(MyApp.context, listen: false).primaryColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                hideBottomControls: false,
                lockAspectRatio: true),
        iOSUiSettings ??
            IOSUiSettings(
              title: AB_getS(MyApp.context, listen: false).cutting,
              doneButtonTitle: AB_getS(MyApp.context, listen: false).completed,
              cancelButtonTitle: AB_getS(MyApp.context, listen: false).cancel,
              resetAspectRatioEnabled: false,
            ),
      ],
    );
    return croppedFile;
  }
}

enum ImageFrom { camera, gallery }

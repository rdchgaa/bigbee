import 'dart:convert';
import 'dart:io';

import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_browser/photo_browser.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../provider/theme_provider.dart';
import 'package:http/http.dart' as http;

import 'package:universal_html/html.dart' as html;

class CommonUtil {
  static Future<AssetPickerResultData?> selectImages(BuildContext context,
      {int? maxAssets = 24,
      bool? showMergeSend = false,
      RequestType? requestType = RequestType.common,
      bool? isDynamic = false}) async {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isZh = languageProvider.locale.languageCode.contains("zh");
    AssetPickerTextDelegate? textDelegate;
    if (isZh) {
      textDelegate = AssetPickerTextDelegate();
    } else {
      textDelegate = EnglishAssetPickerTextDelegate();
    }

    AssetPickerResultData? pickedAssets = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(
            requestType: requestType ?? RequestType.common,
            textDelegate: textDelegate,
            pickerTheme:
                MediaQuery.platformBrightnessOf(context) == Brightness.dark ? ThemeData.dark() : ThemeData.light(),
            maxAssets: maxAssets ?? 24,
            showMergeSend: showMergeSend ?? false,isDynamic:isDynamic??false));
    return pickedAssets;
  }
}

String singleTimeToString(int time) {
  String value = time.toString();
  if (time < 10) {
    value = '0$value';
  }
  return value;
}

String getContentSpan(String text, BuildContext context) {
  List<InlineSpan> _contentList = [];
  String contentData = PlatformUtils().isWeb ? '\u200B' : "";

  Iterable<RegExpMatch> matches = LinkUtils.urlReg.allMatches(text);

  int index = 0;
  final theme = AB_theme(context);
  var style = TextStyle(fontSize: 16.px, color: theme.text282109);
  for (RegExpMatch match in matches) {
    String c = text.substring(match.start, match.end);
    if (match.start == index) {
      index = match.end;
    }
    if (index < match.start) {
      String a = text.substring(index, match.start);
      index = match.end;
      contentData += a;
      _contentList.add(
        TextSpan(text: a),
      );
    }

    if (LinkUtils.urlReg.hasMatch(c)) {
      contentData += '\$' + c + '\$';
      _contentList.add(TextSpan(
          text: c,
          style: TextStyle(color: LinkUtils.hexToColor("015fff")),
          recognizer: TapGestureRecognizer()..onTap = () {}));
    } else {
      contentData += c;
      _contentList.add(
        TextSpan(text: c, style: style ?? const TextStyle(fontSize: 16.0)),
      );
    }
  }
  if (index < text.length) {
    String a = text.substring(index, text.length);
    contentData += a;
    _contentList.add(
      TextSpan(text: a, style: style ?? const TextStyle(fontSize: 16.0)),
    );
  }

  return contentData;
}

String getFileNameFromUrl(String url) {
  var name = path.basename(url);
  if (name.length > 18) {
    name = name.substring(
          0,
          10,
        ) +
        '...' +
        name.substring(name.length - 8, name.length);
  }
  return name;
}

String getCoinAddressSimple(String url) {
  var name = path.basename(url);
  if (name.length > 15) {
    name = name.substring(
      0,
      7,
    ) +
        '...' +
        name.substring(name.length - 5, name.length);
  }
  return name;
}

String getFileName(String? url) {
  var name = path.basename(url ?? '1.txt');
  if (name.contains("?")) {
    name = name.substring(0, name.indexOf("?"));
  }
  return name;
}

Future<String?> doesFileExist(String filename) async {
  try {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getApplicationCacheDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);
    if (await file.exists()) {
      return filePath;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<String> downLoadNetWorkFile(String? url, {String? fileName}) async {
  if (fileName == null) {
    fileName = getFileName(url);
  }
  String? path = await doesFileExist(fileName);
  if (path != null) {
    return path;
  }
  final response = await http.get(Uri.parse(url ?? ''));
  final bytes = response.bodyBytes;
  // final directory = await getApplicationDocumentsDirectory();
  final directory = await getApplicationCacheDirectory();
  String filePath = '${directory.path}/${fileName}';
  final file = File(filePath);
  await file.writeAsBytes(bytes);
  return filePath;
}


//打开图片预览页面
void openImages(BuildContext context,List<String> imageUrls,{int? initIndex =0}) async {
  if (imageUrls == null || imageUrls.isEmpty) {
    return;
  }
  PhotoBrowser photoBrowser = PhotoBrowser(
    itemCount: imageUrls.length,
    initIndex: initIndex??0,
    controller: PhotoBrowserController(),
    allowTapToPop: true,
    allowSwipeDownToPop: true,
    heroTagBuilder: (int index) {
      return imageUrls[index];
    },
    // Large images setting.
    // 大图设置
    imageUrlBuilder: (int index) {
      return imageUrls[index];
    },
    // 缩略图设置
    thumbImageUrlBuilder: (int index) {
      return imageUrls[index] + "?x-oss-process=image/resize,m_lfit,h_160,w_160";
    },
    loadFailedChild: ColoredBox(color: Colors.grey),
  );

  photoBrowser.push(context);
}

String numToK (num num){
  if(num < 1000){
    return num.toString();
  }else{
    return "${(num/1000).toStringAsFixed(0)}K";
  }
}
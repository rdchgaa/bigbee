import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';


const String imageAssets = "assets/images/";

class CollectionUtils {

  //3，图片；CollectionMessageImage
  static V2TimImage? collectionMessageImage(BuildContext context,{required String value}) {
    if(value==''){
      return null;
    }
    V2TimImage result = V2TimImage.fromJson(json.decode(value));
    return result;
  }

  //5，语音；CollectionMessageSound
  static V2TimSoundElem? collectionMessageSound(BuildContext context,{required String value}) {
    if(value==''){
      return null;
    }
    V2TimSoundElem result = V2TimSoundElem.fromJson(json.decode(value));
    return result;
  }

  //6，视频；CollectionMessageVideo
  static V2TimVideoElem? collectionMessageVideo(BuildContext context,{required String value}) {
    if(value==''){
      return null;
    }
    V2TimVideoElem result = V2TimVideoElem.fromJson(json.decode(value));
    return result;
  }
  //7，文件；CollectionMessageVideo
  static V2TimFileElem? collectionMessageFile(BuildContext context,{required String value}) {
    if(value==''){
      return null;
    }
    V2TimFileElem result = V2TimFileElem.fromJson(json.decode(value));
    return result;
  }
}


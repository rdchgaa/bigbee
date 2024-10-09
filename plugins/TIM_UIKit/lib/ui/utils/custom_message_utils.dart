import 'dart:convert';

import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/collection_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/custom_group_tip_message_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/red_envelope_data_provider.dart';

import 'calling_message_data_provider.dart';
import 'dynamic_data_provider.dart';
import 'logger.dart';

const String multiImageBusinessID = "multiImageBusinessID";

class CustomMessageUtils {

  // 获取消息的展示内容
  static String messageShowContent(V2TimMessage message) {
    final rp = RedEnvelopeDataProvider(message);
    if (rp.isRedEnvelopeMessage) {
      return rp.content;
    }
    final co = CollectionDataProvider(message);
    if (co.isCollectionMessage) {
      return co.content;
    }
    final cp = CallingMessageDataProvider(message);
    if (cp.isCallingSignal) {
      return cp.content;
    }
    final cup = CustomGroupTipMessageDataProvider(message);
    if (cup.isCustomGroupTipMessage) {
      return cup.content;
    }
    final dp = DynamicDataProvider(message);
    if (dp.isDynamicMessage) {
      return TIM_getCurrentDeviceLocale().contains("zh") ? "[动态消息]" : "[Dynamic]";
    }

    final images = getMultiImageUrls(message);
    if (images != null && images.isNotEmpty) {
      return TIM_getCurrentDeviceLocale().contains("zh") ? "[合并图片]：${images.length.toString()}" : "[Photos]：${images.length.toString()}";
    }

    return TIM_t("[自定义]");
  }

  // 获取最后一条消息的展示内容
  static String messageShowLastMessageDesc(V2TimMessage message) {
    print(message.elemType.toString() +'--------------------'+ message.toString()+'--------------------');
    final rp = RedEnvelopeDataProvider(message);
    if (rp.isRedEnvelopeMessage) {
      return rp.lastMessageDesc;
    }

    final co = CollectionDataProvider(message);
    if (co.isCollectionMessage) {
      return co.lastMessageDesc;
    }
    final cp = CallingMessageDataProvider(message);
    if (cp.isCallingSignal) {
      return cp.lastMessageDesc ?? TIM_t("[自定义]");
    }
    final cup = CustomGroupTipMessageDataProvider(message);
    if (cup.isCustomGroupTipMessage) {
      return cup.lastMessageDesc;
    }
    final dp = DynamicDataProvider(message);
    if (dp.isDynamicMessage) {
      return TIM_getCurrentDeviceLocale().contains("zh") ? "[动态消息]" : "[Dynamic]";
    }

    final images = getMultiImageUrls(message);
    if (images != null && images.isNotEmpty) {
      return TIM_getCurrentDeviceLocale().contains("zh") ? "[合并图片]：${images.length.toString()}" : "[Photos]：${images.length.toString()}";
    }
    return TIM_t("[自定义]");
  }


  // 是否是通话信息
  static bool isCallingMessage(V2TimMessage message) {
    return CallingMessageDataProvider(message).isCallingSignal;
  }

  // 是否是红包信息
  static bool isRedEnvelopeMessage(V2TimMessage message) {
    return RedEnvelopeDataProvider(message).isRedEnvelopeMessage;
  }

  // 是否是多图信息
  static bool isMultiImagesMessage(V2TimMessage message) {
    if (message.customElem?.data != null) {
      try {
        final data = jsonDecode(message.customElem!.data!) as Map<String, dynamic>;
        return data.containsKey("businessID") && data["businessID"] == multiImageBusinessID ;
      } catch (_){
        return false;
      }
    }
    return false;
  }

  // 是否是收藏信息
  static bool isCollectionMessage(V2TimMessage message) {
    if (message.customElem?.data != null) {
      try {
        final data = jsonDecode(message.customElem!.data!) as Map<String, dynamic>;
        return data.containsKey("businessID") && data["businessID"] == collectionBusinessID ;
      } catch (_){
        return false;
      }
    }
    return false;
  }

  // 获取多图urls
  static List<String>? getMultiImageUrls(V2TimMessage message) {
    if (message.customElem?.data != null) {
      try {
        final data = jsonDecode(message.customElem!.data!) as Map<String, dynamic>;

        if (data.containsKey("businessID") && data["businessID"] == multiImageBusinessID) {
          if (data["content"] == null) {
            return null;
          }
          final List<dynamic>? urls = data["content"];
          // print("多图数据 - ${urls?.map((e) => e.toString()).toList()}");
          return urls?.map((e) => e.toString()).toList();
        } else {
          return null;
        }
      } catch (e){
        print("多图数据解析错误 - ${e.toString()}");
        return null;
      }

    }
    return null;
  }

  // 是否是群组TRTC信息
  static isGroupCallingMessage(V2TimMessage message) {
    final isGroup = message.groupID != null;
    final isCustomMessage =
        message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM;
    if (isCustomMessage) {
      final customElemData = message.customElem?.data ?? "";
      return _isCallingData(customElemData) && isGroup;
    }
    return false;
  }

  // 判断CallingData的方式和Trtc的方法一致
  static _isCallingData(String data) {
    try {
      Map<String, dynamic> customMap = jsonDecode(data);

      if (customMap.containsKey('businessID') && customMap['businessID'] == 1) {
        return true;
      }
    } catch (e) {
      outputLogger.i("isCallingData json parse error");
      return false;
    }
    return false;
  }

}
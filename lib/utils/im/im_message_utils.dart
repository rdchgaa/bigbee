import 'dart:convert';
import 'dart:core';

import 'package:bee_chat/models/mine/collection_message_list_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/calling_message_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/custom_group_tip_message_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/custom_message_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/red_envelope_data_provider.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import '../../models/dynamic/posts_hot_recommend_list_model.dart';
import '../../pages/chat/red_bag/red_bag_send_page.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/collection_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/dynamic_data_provider.dart';

const String kBeeChatImVersion = "1.0.0";

class ImMessageUtils {
  /*  发送加入群通话消息
  *  groupId: 群组id
  *  groupId: 群组id
  *  roomId: 房间id
  * */
  static Future<V2TimMessage?> sendJoinToGroupCallMessage({required String groupId, required String roomId}) {
    print("发送加入群通话消息");
    return sendGroupTransparentMessage(
      groupId: groupId,
      data:
          '{"businessID":"groupCallAction","type":${TransparentMessageType.joinCall.value}, "groupId":"$groupId", "roomId":"$roomId"}',
      desc: 'join to group call',
    );
  }

  /*  发送离开群通话消息
  *  groupId: 群组id
  *  roomId: 房间id
  * */
  static Future<V2TimMessage?> sendLeaveGroupCallMessage({required String groupId, required String roomId}) {
    return sendGroupTransparentMessage(
      groupId: groupId,
      data:
          '{"businessID":"groupCallAction","type":${TransparentMessageType.leaveCall.value},"groupId":"$groupId","roomId":"$roomId"}',
      desc: 'leave to group call',
    );
  }

  /*  发送单聊透传消息
  *  userId: 用户id
  *  data: 消息内容
  *  desc: 消息描述
  *  extension: 消息扩展
  * */
  static Future<V2TimMessage?> sendC2CTransparentMessage({
    required String userId,
    required String data,
    String? desc,
    Map<String, dynamic>? extension,
  }) async {
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    if (extension != null) {
      extension["version"] = kBeeChatImVersion;
      try {
        extensionStr = jsonEncode(extension);
      } catch (e) {
        debugPrint("extension error: $e");
        return Future.value(null);
      }
    }
    // 创建自定义消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
              data: data,
              desc: desc ?? '',
              extension: extensionStr,
            );
    if (createCustomMessageRes.code == 0) {
      String id = createCustomMessageRes.data?.id ?? '';
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes =
          await TIMUIKitCore.getSDKInstance().getMessageManager().sendMessage(
                id: id,
                receiver: userId,
                groupID: '',
                onlineUserOnly: true,
                // 是否只有在线用户才能收到，如果设置为 true ，接收方历史消息拉取不到，常被用于实现“对方正在输入”或群组里的非重要提示等弱提示功能，该字段不支持 AVChatRoom。
                isExcludedFromUnreadCount: false,
                // 发送消息是否排除会话未读数
                isExcludedFromLastMessage: false, // 发送消息是否排除会话 lastMessage
              );
      return Future.value(sendMessageRes.data);
    }
    return Future.value(null);
  }

  /*  发送群组透传消息
  *  groupId: 群组id
  *  data: 消息内容
  *  desc: 消息描述
  *  extension: 消息扩展
  * */
  static Future<V2TimMessage?> sendGroupTransparentMessage({
    required String groupId,
    required String data,
    String? desc,
    Map<String, dynamic>? extension,
  }) async {
    print("发送群组透传消息");
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    if (extension != null) {
      extension["version"] = kBeeChatImVersion;
      try {
        extensionStr = jsonEncode(extension);
      } catch (e) {
        debugPrint("extension error: $e");
        return Future.value(null);
      }
    }

    // 创建自定义消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
              data: data,
              desc: desc ?? '',
              extension: extensionStr,
            );
    if (createCustomMessageRes.code == 0) {
      String id = createCustomMessageRes.data?.id ?? '';
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes =
          await TIMUIKitCore.getSDKInstance().getMessageManager().sendMessage(
                id: id,
                receiver: "",
                groupID: groupId,
                onlineUserOnly: true,
              );
      return Future.value(sendMessageRes.data);
    }
    return Future.value(null);
  }

  // 发送通话结束消息
  static sendCallEndMessage({required String groupId}) async {
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    Map<String, dynamic> cusData = {};
    cusData["cmd"] = "callEnd";
    String data = '{"businessID"：1,"data":${jsonEncode({"cmd": "callEnd"})}}';
    // 创建自定义消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
              data: data,
              desc: 'call end',
              extension: extensionStr,
            );
    if (createCustomMessageRes.code == 0) {
      String id = createCustomMessageRes.data?.id ?? '';
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes =
          await TIMUIKitCore.getSDKInstance().getMessageManager().sendMessage(
                id: id,
                receiver: "",
                groupID: groupId,
              );
      return Future.value(sendMessageRes.data);
    }
    return Future.value(null);
  }

  // 创建红包消息
  static Future<V2TimMessage?> createRedEnvelopeMessage({required SendRedResult sendRedResult}) async {
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    Map<String, dynamic> cusData = {};
    cusData["businessID"] = redEnvelopeBusinessID;
    cusData["redEnvelope"] = sendRedResult.toJsonString();
    // 创建自定义消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
              data: json.encode(cusData),
              desc: "RedEnvelopeMessage",
              extension: extensionStr,
            );
    if (createCustomMessageRes.code == 0) {
      // String id = createCustomMessageRes.data?.id ?? '';
      return Future.value(createCustomMessageRes.data?.messageInfo);
    }
    return Future.value(null);
  }

  // 发送红包消息
  static Future<V2TimMessage?> sendRedEnvelopeMessage(
      {String? groupId, String? userId, required SendRedResult sendRedResult}) async {
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    Map<String, dynamic> cusData = {};
    cusData["businessID"] = redEnvelopeBusinessID;
    cusData["redEnvelope"] = sendRedResult.toJsonString();
    // 创建自定义消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
              data: json.encode(cusData),
              desc: "RedEnvelopeMessage",
              extension: extensionStr,
            );
    if (createCustomMessageRes.code == 0) {
      String id = createCustomMessageRes.data?.id ?? '';
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes =
          await TIMUIKitCore.getSDKInstance().getMessageManager().sendMessage(
                id: id,
                receiver: userId ?? "",
                groupID: groupId ?? "",
              );
      return Future.value(sendMessageRes.data);
    }
    return Future.value(null);
  }

// 创建收藏消息
  static Future<V2TimMessage?> createCollectionMessage({required CollectionMessageListRecords collectionMessageListRecords}) async {
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    Map<String, dynamic> cusData = {};
    cusData["businessID"] = collectionBusinessID;
    cusData["collection"] = json.encode(collectionMessageListRecords.toJson());
    // 创建自定义消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
    await TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
      data: json.encode(cusData),
      desc: "CollectionMessage",
      extension: extensionStr,
    );
    if (createCustomMessageRes.code == 0) {
      // String id = createCustomMessageRes.data?.id ?? '';
      return Future.value(createCustomMessageRes.data?.messageInfo);
    }
    return Future.value(null);
  }

  // 发送收藏消息
  static Future<V2TimMessage?> sendCollectionMessage(
      {String? groupId, String? userId, required CollectionMessageListRecords collectionMessageListRecords}) async {
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    Map<String, dynamic> cusData = {};
    cusData["businessID"] = collectionBusinessID;
    cusData["collection"] = json.encode(collectionMessageListRecords.toJson());
    // 创建自定义消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
    await TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
      data: json.encode(cusData),
      desc: "CollectionMessage",
      extension: extensionStr,
    );
    if (createCustomMessageRes.code == 0) {
      String id = createCustomMessageRes.data?.id ?? '';
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes =
      await TIMUIKitCore.getSDKInstance().getMessageManager().sendMessage(
        id: id,
        receiver: userId ?? "",
        groupID: groupId ?? "",
      );
      return Future.value(sendMessageRes.data);
    }
    return Future.value(null);
  }

  // 创建动态消息
  static Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createDynamicMessage({required PostShareMsgModel model}) async {
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    Map<String, dynamic> cusData = {};
    cusData["businessID"] = dynamicBusinessID;
    cusData["dynamic"] = json.encode(model.toJson());
    // 创建自定义消息
    return await TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
      data: json.encode(cusData),
      desc: "DynamicMessage",
      extension: extensionStr,
    );
  }

  // 发送动态消息
  static Future<V2TimMessage?> sendDynamicMessage(
      {String? groupId, String? userId, required PostShareMsgModel model}) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
    await createDynamicMessage(model: model);
    if (createCustomMessageRes.code == 0) {
      String id = createCustomMessageRes.data?.id ?? '';
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes =
      await TIMUIKitCore.getSDKInstance().getMessageManager().sendMessage(
        id: id,
        receiver: userId ?? "",
        groupID: groupId ?? "",
      );
      return Future.value(sendMessageRes.data);
    }
    return Future.value(null);
  }



  // 发送群自定义提示消息
  static Future<V2TimMessage?> sendGroupCustomTipsMessage(
      {required String groupId, required CustomGroupTipMessageModel model}) async {
    // String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    // Map<String, dynamic> cusData = {};
    // cusData["businessID"] = customGroupTipBusinessID;
    // cusData["content"] = model.toJson();
    // 创建自定义消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
    await createGroupCustomTipsMessage(model: model);
    if (createCustomMessageRes.code == 0) {
      String id = createCustomMessageRes.data?.id ?? '';
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes =
      await TIMUIKitCore.getSDKInstance().getMessageManager().sendMessage(
        id: id,
        receiver: "",
        groupID: groupId,
        onlineUserOnly: false,
        // 是否只有在线用户才能收到，如果设置为 true ，接收方历史消息拉取不到，常被用于实现“对方正在输入”或群组里的非重要提示等弱提示功能，该字段不支持 AVChatRoom。
        isExcludedFromUnreadCount: false,
        // 发送消息是否计入会话未读数
        isExcludedFromLastMessage: false, // 发送消息是否计入会话 lastMessage
      );
      return Future.value(sendMessageRes.data);
    }
    return Future.value(null);
  }

  // 创建群自定义提示消息
  static Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createGroupCustomTipsMessage(
      {required CustomGroupTipMessageModel model}) async {
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    Map<String, dynamic> cusData = {};
    cusData["businessID"] = customGroupTipBusinessID;
    cusData["content"] = model.toJson();
    return TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
      data: json.encode(cusData),
      desc: "GroupCustomTipsMessage",
      extension: extensionStr,
    );
  }

  // 发送多图消息
  static Future<V2TimMessage?> sendMultiImageMessage(
      {String? groupId, String? userId, required List<String> imageList}) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes = await createMultiImageMessage(imageList: imageList);
    if (createCustomMessageRes.code == 0) {
      String id = createCustomMessageRes.data?.id ?? '';
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes =
      await TIMUIKitCore.getSDKInstance().getMessageManager().sendMessage(
        id: id,
        receiver: userId ?? "",
        groupID: groupId ?? "",
        onlineUserOnly: false,
        // 是否只有在线用户才能收到，如果设置为 true ，接收方历史消息拉取不到，常被用于实现“对方正在输入”或群组里的非重要提示等弱提示功能，该字段不支持 AVChatRoom。
        isExcludedFromUnreadCount: false,
        // 发送消息是否计入会话未读数
        isExcludedFromLastMessage: false, // 发送消息是否计入会话 lastMessage
      );
      return Future.value(sendMessageRes.data);
    }
    return Future.value(null);
  }

  // 创建多图自定义消息
  static Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createMultiImageMessage(
      {required List<String> imageList}) async {
    String extensionStr = jsonEncode({"version": kBeeChatImVersion});
    Map<String, dynamic> cusData = {};
    cusData["businessID"] = multiImageBusinessID;
    cusData["content"] = imageList;
    return TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
      data: json.encode(cusData),
      desc: "GroupCustomTipsMessage",
      extension: extensionStr,
    );
  }



  // 获取收藏消息数据
  static List<String> getCollectMessageData({required List<V2TimMessage> messageList}) {
    try {
      List<String> list = messageList.map((e) {
        return jsonEncode(e.toJson());
      }).toList();
      return list;
    } catch (e) {}
    return [];
  }

  // 判断消息是否可以被收藏
  static (bool, String) isMessageCanCollect({required V2TimMessage message}) {
    if (!MessageUtils.isMessageCanCollect(message: message)) {
      return (false, "${AB_S().notSupportCollection(message.elemType.messageElemTypeName)}");
    }
    return (true, "");
  }

  // 通过json字符串数组获取消息列表
  static List<V2TimMessage> getMessageListByJsonStringList({required List<String> messageList}) {
    try {
      List<V2TimMessage> list = messageList.map((e) {
        return V2TimMessage.fromJson(jsonDecode(e));
      }).toList();
      return list;
    } catch (e) {}
    return [];
  }

  static Future<String?> getMessageResourcesData({required V2TimMessage message}) async {
    switch (message.elemType) {
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        if (message.textElem?.text != null) {
          return message.textElem!.text!;
        }
        return null;
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        final imageModel = message.imageElem?.imageList?.firstOrNull;
        imageModel?.localUrl = null;
        Map<String, dynamic>? imageMap = imageModel?.toJson();
        if (imageMap == null) {
          return null;
        }
        try {
          return jsonEncode(imageMap);
        } catch (e) {
          return null;
        }
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        if (message.videoElem == null) {
          return null;
        }
        V2TimVideoElem videoElem = message.videoElem!;
        if (videoElem.videoUrl == null && videoElem.snapshotUrl == null) {
          final response =
              await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageOnlineUrl(msgID: message.msgID ?? "");
          if (response.data?.videoElem != null) {
            videoElem = response.data!.videoElem!;
          } else {
            return null;
          }
        }
        videoElem.localSnapshotUrl = null;
        videoElem.localVideoUrl = null;
        return jsonEncode(videoElem.toJson());
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        if (message.soundElem == null) {
          return null;
        }
        V2TimSoundElem soundElem = message.soundElem!;
        if (soundElem.url == null) {
          final response =
              await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageOnlineUrl(msgID: message.msgID ?? "");
          if (response.data?.soundElem != null) {
            soundElem = response.data!.soundElem!;
          } else {
            return null;
          }
        }
        soundElem.localUrl = null;
        return jsonEncode(soundElem.toJson());
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        if (message.fileElem == null) {
          return null;
        }
        V2TimFileElem fileElem = message.fileElem!;
        if (fileElem.url == null) {
          final response =
              await TencentImSDKPlugin.v2TIMManager.getMessageManager().getMessageOnlineUrl(msgID: message.msgID ?? "");
          if (response.data?.fileElem != null) {
            fileElem = response.data!.fileElem!;
          } else {
            return null;
          }
        }
        return jsonEncode(fileElem.toJson());
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        return null;
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        if (message.faceElem == null) {
          return null;
        }
        V2TimFaceElem faceElem = message.faceElem!;
        return jsonEncode(faceElem.toJson());
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return CustomMessageUtils.messageShowContent(message);
      default:
        return null;
    }
  }

  // 判断是否需要加载消息
  static bool isShouldLoad(V2TimMessage message) {
    if (MessageUtils.isDeleteMessage(message)) {
      return false;
    }

    if (isGroupCallActionMessage(message)) {
      return false;
    }
    final p = CallingMessageDataProvider(message);
    if (p.isCallingSignal) {
      switch (p.participantType) {
        case CallParticipantType.group:
          return p.newContent.isNotEmpty;
        case CallParticipantType.c2c:
          return p.content.isNotEmpty;
        case CallParticipantType.unknown:
          return false;
      }
    }
    return true;
  }

  // 判断是否是群组通话操作消息
  static bool isGroupCallActionMessage(V2TimMessage message) {
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM && message.customElem != null) {
      final String? data = message.customElem?.data;
      if (data != null) {
        try {
          final Map<String, dynamic> dataMap = jsonDecode(data);
          final businessID = dataMap["businessID"];
          if (businessID == "groupCallAction") {
            return true;
          }
        } catch (e) {
          debugPrint("parse group call action message error: $e");
        }
      }
    }
    return false;
  }
}

enum TransparentMessageType {
  joinCall(0),
  leaveCall(1),
  friend(100);

  final int value;

  const TransparentMessageType(this.value);
}

extension MessageElemTypeExt on int {
  String get messageElemTypeName {
    switch (this) {
      case MessageElemType.V2TIM_ELEM_TYPE_NONE:
        return "";
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return AB_S().textMessage;
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return AB_S().customMessage;
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return AB_S().imageMessage;
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return AB_S().soundMessage;
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        return AB_S().videoMessage;
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        return AB_S().file;
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        return AB_S().locationMessage;
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return AB_S().fileMessage;
      case MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS:
        return "";
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        return AB_S().mergerMessage;
      default:
        return "";
    }
    return "";
  }
}

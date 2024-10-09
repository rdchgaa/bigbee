import 'dart:convert';

import '../../tencent_cloud_chat_uikit.dart';

const String transparentlyBusinessID = "transparentlyBusinessID";

class TransparentlyMessageUtils {

  static bool isTransparentlyMessage(V2TimMessage message) {
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM && message.customElem != null) {
      final String? data = message.customElem?.data;
      if (data != null) {
        try {
          final Map<String, dynamic> dataMap = jsonDecode(data);
          final businessID = dataMap["businessID"];
          if (businessID == transparentlyBusinessID) {
            return true;
          }
        } catch (e) {
          return false;
        }
      }
    }
    return false;
  }

  // 发送透传消息
  static Future<V2TimMessage?> sendTransparentlyMessage({String? groupId, String? userId, Map<String, dynamic>? data}) async {
    String extensionStr = jsonEncode({"version": "1.0.0"});
    Map<String, dynamic> cusData = {};
    cusData["businessID"] = transparentlyBusinessID;
    cusData["data"] = data;
    // 创建自定义消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
    await TIMUIKitCore.getSDKInstance().getMessageManager().createCustomMessage(
      data: json.encode(cusData),
      desc: "TransparentlyMessage",
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
        onlineUserOnly: true, // 是否只有在线用户才能收到，如果设置为 true ，接收方历史消息拉取不到，常被用于实现“对方正在输入”或群组里的非重要提示等弱提示功能，该字段不支持 AVChatRoom。
        isExcludedFromUnreadCount: false, // 发送消息是否计入会话未读数
        isExcludedFromLastMessage: false, // 发送消息是否计入会话 lastMessage

      );
      return Future.value(sendMessageRes.data);
    }
    return Future.value(null);

  }

}
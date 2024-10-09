import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

extension V2TimConversationExtension on V2TimConversation {

  static V2TimConversation getC2CConversation({String userId = "", String userName = "", String userAvatar = ""}) {
    return V2TimConversation(
      conversationID: "c2c_$userId",
      type: 1,
      userID: userId,
      showName: userName,
      faceUrl: userAvatar,
      unreadCount: 0,
    );
  }
}
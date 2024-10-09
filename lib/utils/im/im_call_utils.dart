import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';

class ImCallUtils {

  static callUser({required BuildContext context, required String userId, ImCallUtilsType type = ImCallUtilsType.voice}) {
    switch (type) {
      case ImCallUtilsType.voice:
        _goToVoiceUI(context, userId);
        break;
      case ImCallUtilsType.video:
        _goToVideoUI(context, userId);
        break;
    }
  }


  static _goToVoiceUI(BuildContext context, String userId) async {
    final hasMicrophonePermission = await Permissions.checkPermission(
        context, Permission.microphone.value);
    if (!hasMicrophonePermission) {
      return;
    }
    TUICore().callService(TUICALLKIT_SERVICE_NAME, METHOD_NAME_CALL, {
      PARAM_NAME_TYPE: TYPE_AUDIO,
      PARAM_NAME_USERIDS: [userId],
      PARAM_NAME_GROUPID: ""
    });
  }

  static _goToVideoUI(BuildContext context, String userId) async {
    final hasCameraPermission = await Permissions.checkPermission(context, Permission.camera.value);
    final hasMicrophonePermission = await Permissions.checkPermission(context, Permission.microphone.value);
    if (!hasCameraPermission || !hasMicrophonePermission) {
      return;
    }
    TUICore().callService(TUICALLKIT_SERVICE_NAME, METHOD_NAME_CALL, {
      PARAM_NAME_TYPE: TYPE_VIDEO,
      PARAM_NAME_USERIDS: [userId],
      PARAM_NAME_GROUPID: ""
    });
  }


}

enum ImCallUtilsType {
  video,
  voice,
}
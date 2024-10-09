import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tencent_calls_engine/tencent_calls_engine.dart';
import 'package:tencent_calls_uikit/src/ui/widget/joiningroup/join_in_group_widget.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';

class CallUIExtension extends AbstractTUIExtension {
  static final CallUIExtension _instance = CallUIExtension();

  static CallUIExtension get instance => _instance;

  @override
  Future<Widget> onRaiseExtension(TUIExtensionID extensionID, Map<String, dynamic> param) {
    print("扩展 - onRaiseExtension - ${extensionID}");
    if (extensionID == TUIExtensionID.joinInGroup) {
      return _getGroupAttributes(param);
    }

    return Future<Widget>.value(const SizedBox());
  }

  Future<Widget> _getGroupAttributes(Map<String, dynamic> param) async {
    String groupId = param[GROUP_ID];
    if (groupId.isEmpty) {
      return Future<Widget>.value(const SizedBox());
    }

    final resultMap = await TencentImSDKPlugin.v2TIMManager.v2TIMGroupManager
        .getGroupAttributes(groupID: groupId);
    final groupAttAryString = resultMap.data?['inner_attr_kit_info'] ?? '{}';
    final groupAttAryMap = jsonDecode(groupAttAryString);
    final userList = groupAttAryMap['user_list'] ?? [];
    final businessType = groupAttAryMap['business_type'];
    final roomIDValue = (groupAttAryMap['room_id'] as String?) ?? "";
    final roomIDType = groupAttAryMap['room_id_type'];
    final mediaTypeString = groupAttAryMap['call_media_type'];
    final userListMap = List<Map<String, dynamic>>.from(userList);
    TUIRoomId? roomId;
    if (roomIDValue.isEmpty) {
      roomId = null;
    } else {
      if (roomIDType == 1 || roomIDType == 0) {
        roomId = TUIRoomId.intRoomId(intRoomId: int.parse(roomIDValue));
      } else {
        roomId = TUIRoomId.strRoomId(strRoomId: roomIDValue);
      }
    }


    TUICallMediaType mediaType;
    if (mediaTypeString == 'audio') {
      mediaType = TUICallMediaType.audio;
    } else {
      mediaType = TUICallMediaType.video;
    }

    List<String> userIds = [];
    for (var user in userListMap) {
      userIds.add(user['userid'] as String);
    }

    bool meIsInCall = false;
    final loginUserRes = await TencentImSDKPlugin.v2TIMManager.getLoginUser();
    if (loginUserRes.code == 0) {
      final loginUser = loginUserRes.data;
      if (loginUser != null && userIds.contains(loginUser)) {
        meIsInCall = true;
      }
    }

    if (businessType != 'callkit' ||
        userIds.isEmpty ||
        roomIDValue.isEmpty ||
        mediaTypeString.isEmpty ||
        roomId == null ||
        meIsInCall) {
      return JoinInGroupWidget(
          userIDs: const [], roomId: TUIRoomId.strRoomId(strRoomId: "0"), mediaType: mediaType, groupId: groupId, isNeedShow: false);
      // return Future<Widget>.value(const SizedBox());
    }
    return JoinInGroupWidget(
        userIDs: userIds, roomId: roomId, mediaType: mediaType, groupId: groupId);
  }
}

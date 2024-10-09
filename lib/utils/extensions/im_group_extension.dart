import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

extension GroupExtensions on V2TimGroupInfo? {
  //是否可以踢人
  bool get isManager {
    final isGroupOwner =
        this?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER;
    final isAdmin =
        this?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN;
    // if (_groupInfo?.groupType == GroupType.Work) {
    //   /// work 群主才能踢人
    //   return isGroupOwner;
    // }
    // if (_groupInfo?.groupType == GroupType.Public ||
    //     _groupInfo?.groupType == GroupType.Meeting) {
    //   /// public || meeting 群主和管理员可以踢人
    //   return isGroupOwner || isAdmin;
    // }

    return isGroupOwner || isAdmin;
  }

// 是否是群主
  bool get isGroupOwner {
    return this?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER;
  }

  // 是否是群主
  bool get isAdmin {
    return this?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN;
  }


  /// 是否开启了群消息免打扰
  bool get messageReceiveOption {
    if (this == null) {
      return false;
    }
    // ignore: unrelated_type_equality_checks
    return this!.recvOpt ==
        ReceiveMsgOptEnum.V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE.index;
  }


}



extension MemberFullInfoDisplayName on V2TimGroupMemberFullInfo? {

  // 显示名称
  String get displayName {
    if (this == null) return '';
    final friendRemark = this!.friendRemark ?? "";
    final nickName = this!.nickName ?? "";
    final userID = this!.userID;
    final showName = nickName != "" ? nickName : userID;
    return friendRemark != "" ? friendRemark : showName;
  }
}

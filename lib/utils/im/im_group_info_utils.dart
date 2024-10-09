import 'package:bee_chat/utils/ab_toast.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class ImGroupInfoUtils {

  // 设置是否显示群二维码
  static Future<V2TimCallback?> setGroupQRCodeVisible({required String groupID, required bool isShowQRCode}) async {
    V2TimCallback response = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .setGroupAttributes(
        groupID: groupID,// 需要设置属性的群组id
        attributes: {"isShowQRCode": isShowQRCode ? "1" : "0"} // 设置的属性
    );
    // if (response.code != 0) {
    //   ABToast.show("设置群属性失败");
    // } else {
    //   ABToast.show("设置群属性成功");
    // }
    return response;

  }

  // 设置是否是私密群
  static Future<V2TimCallback?> setGroupPrivate({required String groupID, required bool isPrivate}) async {
    V2TimCallback response = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .setGroupAttributes(
        groupID: groupID,// 需要设置属性的群组id
        attributes: {"isPrivate": isPrivate ? "1" : "0"} // 设置的属性
    );
    return response;
  }

  // 设置群名称
  static Future<V2TimCallback?> setGroupName({required String groupID, required String groupName}) async {
    V2TimCallback response = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .setGroupAttributes(
        groupID: groupID,// 需要设置属性的群组id
        attributes: {"groupName": groupName} // 设置的属性
    );
    return response;
  }

  // 设置是否仅群主与管理员修改群名称
  static Future<V2TimCallback?> setGroupOnlyAdminCanModifyGroupName({required String groupID, required bool isOnlyAdminCanModifyGroupName}) async {
    V2TimCallback response = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .setGroupAttributes(
        groupID: groupID,// 需要设置属性的群组id
        attributes: {"isOnlyAdminCanModifyGroupName": isOnlyAdminCanModifyGroupName ? "1" : "0"} // 设置的属性
    );
    return response;
  }

  // 设置是否允许群成员互加好友
  static Future<V2TimCallback?> setAllowGroupMemberAddFriend({required String groupID, required bool isAllowGroupMemberAddFriend}) async {
    V2TimCallback response = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .setGroupAttributes(
        groupID: groupID,// 需要设置属性的群组id
        attributes: {"isAllowGroupMemberAddFriend": isAllowGroupMemberAddFriend ? "1" : "0"} // 设置的属性
    );
    return response;
  }

  // 获取群自定义属性
  static Future<GroupCustomInfoModel> getGroupCustomInfoModel({required String groupID})  async {
     final res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupAttributes(groupID: groupID);
     return Future.value(GroupCustomInfoModel.fromJson(res.data ?? {}));
  }

}


class GroupCustomInfoModel {
  // 是否显示群二维码(针对普通群成员)
  String isShowQRCode;
  String isPrivate;
  String groupName;
  // 是否仅群主与管理员修改群名称
  String isOnlyAdminCanModifyGroupName;
  // 是否允许群成员互加好友
  String  isAllowGroupMemberAddFriend;

  GroupCustomInfoModel({this.isShowQRCode = "1", this.isPrivate = "0", this.groupName = "", this.isOnlyAdminCanModifyGroupName = "0", this.isAllowGroupMemberAddFriend = "1"});

  factory GroupCustomInfoModel.fromJson(Map<String, String> json) => GroupCustomInfoModel(
    isShowQRCode: json["isShowQRCode"] ?? "1",
    isPrivate: json["isPrivate"] ?? "0",
    groupName: json["groupName"] ?? "",
    isOnlyAdminCanModifyGroupName: json["isOnlyAdminCanModifyGroupName"] ?? "0",
    isAllowGroupMemberAddFriend: json["isAllowGroupMemberAddFriend"] ?? "1"
  );

  Map<String, String> toJson() => {
    "isShowQRCode": isShowQRCode,
    "isPrivate": isPrivate,
    "groupName": groupName,
    "isOnlyAdminCanModifyGroupName": isOnlyAdminCanModifyGroupName,
    "isAllowGroupMemberAddFriend": isAllowGroupMemberAddFriend
  };
}

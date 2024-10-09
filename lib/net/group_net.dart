import 'dart:async';

import 'package:bee_chat/models/common/empty_model.dart';
import 'package:bee_chat/models/group/group_list_model.dart';
import 'package:bee_chat/models/group/group_member_list_model.dart';

import '../models/group/group_member_invite_model.dart';
import '../utils/net/ab_Net.dart';
import '../utils/net/net_model.dart';
import 'api.dart';

class GroupNet {

  // 搜索群列表
  static Future<RequestResult<PageModel<GroupListModel>>> searchGroup({int page = 1, int pageSize = 20, String groupName = ''} ) async {
    return ABNet.requestPage<GroupListModel>(path: searchGroupApi, method: HttpMethod.get, params: {
      'pageNum': page,
      'pageSize': pageSize,
      'groupName': groupName
    }
    );
  }

  // 搜索群组成员
  // excludeMemberIds 需要排除的成员id
  static Future<RequestResult<PageModel<GroupMemberListModel>>> searchGroupMember({required String groupID, int page = 1, int pageSize = 20, String memberName = '', List<String> excludeMemberIds = const []}) async {
    Map<String, dynamic> params = {
      'pageNum': page,
      'pageSize': pageSize,
      'memberName': memberName,
      "groupUuid": groupID,
    };
    if (excludeMemberIds.isNotEmpty) {
      params["memberUuids"] = excludeMemberIds;
    }
    return ABNet.requestPage<GroupMemberListModel>(path: searchGroupMemberApi, method: HttpMethod.post, params: params);
  }

  // 获取群管理员列表
  static Future<List<GroupMemberListModel>> getGroupManagerList({required String groupID}) async {
    Map<String, dynamic> params = {
      'pageNum': 1,
      'pageSize': 100,
      "groupUuid": groupID,
      "isAdministrators": 1, // 只要管理员
    };
    final result = await ABNet.requestPage<GroupMemberListModel>(path: searchGroupMemberApi, method: HttpMethod.post, params: params);
    return Future.value((result.data?.records ?? []));
  }

  // 获取普通群成员
  static Future<RequestResult<PageModel<GroupMemberListModel>>> getOrdinaryGroupMemberList({required String groupID, int page = 1, int pageSize = 20, String memberName = '', List<String> excludeMemberIds = const []}) async {
    Map<String, dynamic> params = {
      'pageNum': page,
      'pageSize': pageSize,
      'memberName': memberName,
      "groupUuid": groupID,
      "isAdministrators": 2, // 排除管理员与群组
    };
    if (excludeMemberIds.isNotEmpty) {
      params["memberUuids"] = excludeMemberIds;
    }
    return ABNet.requestPage<GroupMemberListModel>(path: searchGroupMemberApi, method: HttpMethod.post, params: params);
  }

  // 可以邀请成员入群的用户列表
  static Future<RequestResult<PageModel<GroupMemberInviteModel>>> inviteUserList({required String groupID, int page = 1, int pageSize = 20, String memberName = ''}) async {
    return ABNet.requestPage<GroupMemberInviteModel>(path: searchFriendNotInGroupApi, method: HttpMethod.post, params: {
      'pageNum': page,
      'pageSize': pageSize,
      'memberName': memberName,
      "groupUuid": groupID,
    }
    );
  }

  // 邀请成员入群
  static Future<RequestResult<EmptyModel>> inviteIntoGroup({required String groupID, required List<String> userIds}) async {
    return ABNet.request<EmptyModel>(path: inviteGroupApi, method: HttpMethod.post, params: {
      "groupId": groupID,
      "userIds": userIds,
    });
  }

  // 群组-判断当前用户是否在指定群组中
  static Future<RequestResult<bool>> isInGroup({required String groupID}) async {
    return ABNet.request<bool>(path: isInGroupApi, method: HttpMethod.post, params: {
      "groupUuid": groupID,
    }, isShowTip: false);
  }



  // 邀请成员入群
  static Future<RequestResult<EmptyModel>> muteMembers({required String groupID, required List<String> userIds, bool isMute = true}) async {
    return ABNet.request<EmptyModel>(path: muteMemberApi, method: HttpMethod.post, params: {
      "groupId": groupID,
      "userIds": userIds,
      "isSilence": isMute,
    });
  }



  // 禁言-群组禁言列表
  static Future<RequestResult<List<GroupMemberListModel>>> getMuteMemberList({required String groupID,}) async {
    Map<String, dynamic> params = {
      "groupId": groupID,
    };
    return ABNet.request<List<GroupMemberListModel>>(path: getMuteMemberListApi, method: HttpMethod.get, params: params);
  }



}
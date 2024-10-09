import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_model.dart';

PostsHotRecommendModel $PostsHotRecommendModelFromJson(Map<String, dynamic> json) {
  final PostsHotRecommendModel postsHotRecommendModel = PostsHotRecommendModel();
  final dynamic createBy = json['createBy'];
  if (createBy != null) {
    postsHotRecommendModel.createBy = createBy;
  }
  final dynamic createTime = json['createTime'];
  if (createTime != null) {
    postsHotRecommendModel.createTime = createTime;
  }
  final dynamic updateBy = json['updateBy'];
  if (updateBy != null) {
    postsHotRecommendModel.updateBy = updateBy;
  }
  final dynamic updateTime = json['updateTime'];
  if (updateTime != null) {
    postsHotRecommendModel.updateTime = updateTime;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    postsHotRecommendModel.remark = remark;
  }
  final dynamic id = json['id'];
  if (id != null) {
    postsHotRecommendModel.id = id;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    postsHotRecommendModel.nickName = nickName;
  }
  final dynamic memberNum = json['memberNum'];
  if (memberNum != null) {
    postsHotRecommendModel.memberNum = memberNum;
  }
  final dynamic memberName = json['memberName'];
  if (memberName != null) {
    postsHotRecommendModel.memberName = memberName;
  }
  final dynamic password = json['password'];
  if (password != null) {
    postsHotRecommendModel.password = password;
  }
  final dynamic memberAddress = json['memberAddress'];
  if (memberAddress != null) {
    postsHotRecommendModel.memberAddress = memberAddress;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    postsHotRecommendModel.avatarUrl = avatarUrl;
  }
  final dynamic inviteCode = json['inviteCode'];
  if (inviteCode != null) {
    postsHotRecommendModel.inviteCode = inviteCode;
  }
  final dynamic status = json['status'];
  if (status != null) {
    postsHotRecommendModel.status = status;
  }
  final dynamic profile = json['profile'];
  if (profile != null) {
    postsHotRecommendModel.profile = profile;
  }
  final dynamic loginIp = json['loginIp'];
  if (loginIp != null) {
    postsHotRecommendModel.loginIp = loginIp;
  }
  final dynamic loginDate = json['loginDate'];
  if (loginDate != null) {
    postsHotRecommendModel.loginDate = loginDate;
  }
  final dynamic delFlag = json['delFlag'];
  if (delFlag != null) {
    postsHotRecommendModel.delFlag = delFlag;
  }
  final dynamic friendNickname = json['friendNickname'];
  if (friendNickname != null) {
    postsHotRecommendModel.friendNickname = friendNickname;
  }
  final dynamic isAdministrators = json['isAdministrators'];
  if (isAdministrators != null) {
    postsHotRecommendModel.isAdministrators = isAdministrators;
  }
  final dynamic isGroupLeader = json['isGroupLeader'];
  if (isGroupLeader != null) {
    postsHotRecommendModel.isGroupLeader = isGroupLeader;
  }
  final dynamic groupMemberNickname = json['groupMemberNickname'];
  if (groupMemberNickname != null) {
    postsHotRecommendModel.groupMemberNickname = groupMemberNickname;
  }
  return postsHotRecommendModel;
}

Map<String, dynamic> $PostsHotRecommendModelToJson(PostsHotRecommendModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createBy'] = entity.createBy;
  data['createTime'] = entity.createTime;
  data['updateBy'] = entity.updateBy;
  data['updateTime'] = entity.updateTime;
  data['remark'] = entity.remark;
  data['id'] = entity.id;
  data['nickName'] = entity.nickName;
  data['memberNum'] = entity.memberNum;
  data['memberName'] = entity.memberName;
  data['password'] = entity.password;
  data['memberAddress'] = entity.memberAddress;
  data['avatarUrl'] = entity.avatarUrl;
  data['inviteCode'] = entity.inviteCode;
  data['status'] = entity.status;
  data['profile'] = entity.profile;
  data['loginIp'] = entity.loginIp;
  data['loginDate'] = entity.loginDate;
  data['delFlag'] = entity.delFlag;
  data['friendNickname'] = entity.friendNickname;
  data['isAdministrators'] = entity.isAdministrators;
  data['isGroupLeader'] = entity.isGroupLeader;
  data['groupMemberNickname'] = entity.groupMemberNickname;
  return data;
}

extension PostsHotRecommendModelExtension on PostsHotRecommendModel {
  PostsHotRecommendModel copyWith({
    dynamic createBy,
    dynamic createTime,
    dynamic updateBy,
    dynamic updateTime,
    dynamic remark,
    dynamic id,
    String? nickName,
    dynamic memberNum,
    dynamic memberName,
    dynamic password,
    dynamic memberAddress,
    String? avatarUrl,
    dynamic inviteCode,
    dynamic status,
    dynamic profile,
    dynamic loginIp,
    dynamic loginDate,
    dynamic delFlag,
    dynamic friendNickname,
    dynamic isAdministrators,
    dynamic isGroupLeader,
    dynamic groupMemberNickname,
  }) {
    return PostsHotRecommendModel()
      ..createBy = createBy ?? this.createBy
      ..createTime = createTime ?? this.createTime
      ..updateBy = updateBy ?? this.updateBy
      ..updateTime = updateTime ?? this.updateTime
      ..remark = remark ?? this.remark
      ..id = id ?? this.id
      ..nickName = nickName ?? this.nickName
      ..memberNum = memberNum ?? this.memberNum
      ..memberName = memberName ?? this.memberName
      ..password = password ?? this.password
      ..memberAddress = memberAddress ?? this.memberAddress
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..inviteCode = inviteCode ?? this.inviteCode
      ..status = status ?? this.status
      ..profile = profile ?? this.profile
      ..loginIp = loginIp ?? this.loginIp
      ..loginDate = loginDate ?? this.loginDate
      ..delFlag = delFlag ?? this.delFlag
      ..friendNickname = friendNickname ?? this.friendNickname
      ..isAdministrators = isAdministrators ?? this.isAdministrators
      ..isGroupLeader = isGroupLeader ?? this.isGroupLeader
      ..groupMemberNickname = groupMemberNickname ?? this.groupMemberNickname;
  }
}
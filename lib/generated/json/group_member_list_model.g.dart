import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/group/group_member_list_model.dart';

GroupMemberListModel $GroupMemberListModelFromJson(Map<String, dynamic> json) {
  final GroupMemberListModel groupMemberListModel = GroupMemberListModel();
  final String? memberNum = jsonConvert.convert<String>(json['memberNum']);
  if (memberNum != null) {
    groupMemberListModel.memberNum = memberNum;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    groupMemberListModel.nickName = nickName;
  }
  final String? displayName = jsonConvert.convert<String>(json['displayName']);
  if (displayName != null) {
    groupMemberListModel.displayName = displayName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    groupMemberListModel.avatarUrl = avatarUrl;
  }
  final String? isOnline = jsonConvert.convert<String>(json['isOnline']);
  if (isOnline != null) {
    groupMemberListModel.isOnline = isOnline;
  }
  final int? isGroupLeader = jsonConvert.convert<int>(json['isGroupLeader']);
  if (isGroupLeader != null) {
    groupMemberListModel.isGroupLeader = isGroupLeader;
  }
  final int? isAdministrators = jsonConvert.convert<int>(json['isAdministrators']);
  if (isAdministrators != null) {
    groupMemberListModel.isAdministrators = isAdministrators;
  }
  final int? isForbiddenSpeech = jsonConvert.convert<int>(json['isForbiddenSpeech']);
  if (isForbiddenSpeech != null) {
    groupMemberListModel.isForbiddenSpeech = isForbiddenSpeech;
  }
  return groupMemberListModel;
}

Map<String, dynamic> $GroupMemberListModelToJson(GroupMemberListModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['memberNum'] = entity.memberNum;
  data['nickName'] = entity.nickName;
  data['displayName'] = entity.displayName;
  data['avatarUrl'] = entity.avatarUrl;
  data['isOnline'] = entity.isOnline;
  data['isGroupLeader'] = entity.isGroupLeader;
  data['isAdministrators'] = entity.isAdministrators;
  data['isForbiddenSpeech'] = entity.isForbiddenSpeech;
  return data;
}

extension GroupMemberListModelExtension on GroupMemberListModel {
  GroupMemberListModel copyWith({
    String? memberNum,
    String? nickName,
    String? displayName,
    String? avatarUrl,
    String? isOnline,
    int? isGroupLeader,
    int? isAdministrators,
    int? isForbiddenSpeech,
  }) {
    return GroupMemberListModel()
      ..memberNum = memberNum ?? this.memberNum
      ..nickName = nickName ?? this.nickName
      ..displayName = displayName ?? this.displayName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..isOnline = isOnline ?? this.isOnline
      ..isGroupLeader = isGroupLeader ?? this.isGroupLeader
      ..isAdministrators = isAdministrators ?? this.isAdministrators
      ..isForbiddenSpeech = isForbiddenSpeech ?? this.isForbiddenSpeech;
  }
}
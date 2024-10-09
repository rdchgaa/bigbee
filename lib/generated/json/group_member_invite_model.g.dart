import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/group/group_member_invite_model.dart';

GroupMemberInviteModel $GroupMemberInviteModelFromJson(Map<String, dynamic> json) {
  final GroupMemberInviteModel groupMemberInviteModel = GroupMemberInviteModel();
  final String? memberNum = jsonConvert.convert<String>(json['memberNum']);
  if (memberNum != null) {
    groupMemberInviteModel.memberNum = memberNum;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    groupMemberInviteModel.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    groupMemberInviteModel.avatarUrl = avatarUrl;
  }
  return groupMemberInviteModel;
}

Map<String, dynamic> $GroupMemberInviteModelToJson(GroupMemberInviteModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['memberNum'] = entity.memberNum;
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  return data;
}

extension GroupMemberInviteModelExtension on GroupMemberInviteModel {
  GroupMemberInviteModel copyWith({
    String? memberNum,
    String? nickName,
    String? avatarUrl,
  }) {
    return GroupMemberInviteModel()
      ..memberNum = memberNum ?? this.memberNum
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl;
  }
}
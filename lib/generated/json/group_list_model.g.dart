import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/group/group_list_model.dart';

GroupListModel $GroupListModelFromJson(Map<String, dynamic> json) {
  final GroupListModel groupListModel = GroupListModel();
  final String? groupId = jsonConvert.convert<String>(json['groupId']);
  if (groupId != null) {
    groupListModel.groupId = groupId;
  }
  final String? groupName = jsonConvert.convert<String>(json['groupName']);
  if (groupName != null) {
    groupListModel.groupName = groupName;
  }
  final String? groupAvatarUrl = jsonConvert.convert<String>(json['groupAvatarUrl']);
  if (groupAvatarUrl != null) {
    groupListModel.groupAvatarUrl = groupAvatarUrl;
  }
  final int? groupPersonNum = jsonConvert.convert<int>(json['groupPersonNum']);
  if (groupPersonNum != null) {
    groupListModel.groupPersonNum = groupPersonNum;
  }
  final String? groupDescription = jsonConvert.convert<String>(json['groupDescription']);
  if (groupDescription != null) {
    groupListModel.groupDescription = groupDescription;
  }
  final int? isInto = jsonConvert.convert<int>(json['isInto']);
  if (isInto != null) {
    groupListModel.isInto = isInto;
  }
  return groupListModel;
}

Map<String, dynamic> $GroupListModelToJson(GroupListModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['groupId'] = entity.groupId;
  data['groupName'] = entity.groupName;
  data['groupAvatarUrl'] = entity.groupAvatarUrl;
  data['groupPersonNum'] = entity.groupPersonNum;
  data['groupDescription'] = entity.groupDescription;
  data['isInto'] = entity.isInto;
  return data;
}

extension GroupListModelExtension on GroupListModel {
  GroupListModel copyWith({
    String? groupId,
    String? groupName,
    String? groupAvatarUrl,
    int? groupPersonNum,
    String? groupDescription,
    int? isInto,
  }) {
    return GroupListModel()
      ..groupId = groupId ?? this.groupId
      ..groupName = groupName ?? this.groupName
      ..groupAvatarUrl = groupAvatarUrl ?? this.groupAvatarUrl
      ..groupPersonNum = groupPersonNum ?? this.groupPersonNum
      ..groupDescription = groupDescription ?? this.groupDescription
      ..isInto = isInto ?? this.isInto;
  }
}
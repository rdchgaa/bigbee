import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/im/system_message_model.dart';

SystemMessageModel $SystemMessageModelFromJson(Map<String, dynamic> json) {
  final SystemMessageModel systemMessageModel = SystemMessageModel();
  final int? messageId = jsonConvert.convert<int>(json['messageId']);
  if (messageId != null) {
    systemMessageModel.messageId = messageId;
  }
  final int? invitationMemberId = jsonConvert.convert<int>(json['invitationMemberId']);
  if (invitationMemberId != null) {
    systemMessageModel.invitationMemberId = invitationMemberId;
  }
  final String? invitationMemberAvatar = jsonConvert.convert<String>(json['invitationMemberAvatar']);
  if (invitationMemberAvatar != null) {
    systemMessageModel.invitationMemberAvatar = invitationMemberAvatar;
  }
  final String? invitationMemberName = jsonConvert.convert<String>(json['invitationMemberName']);
  if (invitationMemberName != null) {
    systemMessageModel.invitationMemberName = invitationMemberName;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    systemMessageModel.type = type;
  }
  final int? groupInfoId = jsonConvert.convert<int>(json['groupInfoId']);
  if (groupInfoId != null) {
    systemMessageModel.groupInfoId = groupInfoId;
  }
  final String? groupId = jsonConvert.convert<String>(json['groupId']);
  if (groupId != null) {
    systemMessageModel.groupId = groupId;
  }
  final String? leaveMessage = jsonConvert.convert<String>(json['leaveMessage']);
  if (leaveMessage != null) {
    systemMessageModel.leaveMessage = leaveMessage;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    systemMessageModel.status = status;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    systemMessageModel.createTime = createTime;
  }
  final String? groupInfoName = jsonConvert.convert<String>(json['groupInfoName']);
  if (groupInfoName != null) {
    systemMessageModel.groupInfoName = groupInfoName;
  }
  return systemMessageModel;
}

Map<String, dynamic> $SystemMessageModelToJson(SystemMessageModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['messageId'] = entity.messageId;
  data['invitationMemberId'] = entity.invitationMemberId;
  data['invitationMemberAvatar'] = entity.invitationMemberAvatar;
  data['invitationMemberName'] = entity.invitationMemberName;
  data['type'] = entity.type;
  data['groupInfoId'] = entity.groupInfoId;
  data['groupId'] = entity.groupId;
  data['leaveMessage'] = entity.leaveMessage;
  data['status'] = entity.status;
  data['createTime'] = entity.createTime;
  data['groupInfoName'] = entity.groupInfoName;
  return data;
}

extension SystemMessageModelExtension on SystemMessageModel {
  SystemMessageModel copyWith({
    int? messageId,
    int? invitationMemberId,
    String? invitationMemberAvatar,
    String? invitationMemberName,
    int? type,
    int? groupInfoId,
    String? groupId,
    String? leaveMessage,
    int? status,
    String? createTime,
    String? groupInfoName,
  }) {
    return SystemMessageModel()
      ..messageId = messageId ?? this.messageId
      ..invitationMemberId = invitationMemberId ?? this.invitationMemberId
      ..invitationMemberAvatar = invitationMemberAvatar ?? this.invitationMemberAvatar
      ..invitationMemberName = invitationMemberName ?? this.invitationMemberName
      ..type = type ?? this.type
      ..groupInfoId = groupInfoId ?? this.groupInfoId
      ..groupId = groupId ?? this.groupId
      ..leaveMessage = leaveMessage ?? this.leaveMessage
      ..status = status ?? this.status
      ..createTime = createTime ?? this.createTime
      ..groupInfoName = groupInfoName ?? this.groupInfoName;
  }
}
import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/user/follow_user_list_model.dart';

FollowUserListModel $FollowUserListModelFromJson(Map<String, dynamic> json) {
  final FollowUserListModel followUserListModel = FollowUserListModel();
  final String? memberNum = jsonConvert.convert<String>(json['memberNum']);
  if (memberNum != null) {
    followUserListModel.memberNum = memberNum;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    followUserListModel.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    followUserListModel.avatarUrl = avatarUrl;
  }
  final String? online = jsonConvert.convert<String>(json['online']);
  if (online != null) {
    followUserListModel.online = online;
  }
  final int? isFocus = jsonConvert.convert<int>(json['isFocus']);
  if (isFocus != null) {
    followUserListModel.isFocus = isFocus;
  }
  return followUserListModel;
}

Map<String, dynamic> $FollowUserListModelToJson(FollowUserListModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['memberNum'] = entity.memberNum;
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['online'] = entity.online;
  data['isFocus'] = entity.isFocus;
  return data;
}

extension FollowUserListModelExtension on FollowUserListModel {
  FollowUserListModel copyWith({
    String? memberNum,
    String? nickName,
    String? avatarUrl,
    String? online,
    int? isFocus,
  }) {
    return FollowUserListModel()
      ..memberNum = memberNum ?? this.memberNum
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..online = online ?? this.online
      ..isFocus = isFocus ?? this.isFocus;
  }
}
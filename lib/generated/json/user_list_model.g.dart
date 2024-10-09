import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/user/user_list_model.dart';

UserListModel $UserListModelFromJson(Map<String, dynamic> json) {
  final UserListModel userListModel = UserListModel();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    userListModel.id = id;
  }
  final String? memberNum = jsonConvert.convert<String>(json['memberNum']);
  if (memberNum != null) {
    userListModel.memberNum = memberNum;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    userListModel.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    userListModel.avatarUrl = avatarUrl;
  }
  final String? profile = jsonConvert.convert<String>(json['profile']);
  if (profile != null) {
    userListModel.profile = profile;
  }
  final bool? isFriend = jsonConvert.convert<bool>(json['isFriend']);
  if (isFriend != null) {
    userListModel.isFriend = isFriend;
  }
  return userListModel;
}

Map<String, dynamic> $UserListModelToJson(UserListModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['memberNum'] = entity.memberNum;
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['profile'] = entity.profile;
  data['isFriend'] = entity.isFriend;
  return data;
}

extension UserListModelExtension on UserListModel {
  UserListModel copyWith({
    String? id,
    String? memberNum,
    String? nickName,
    String? avatarUrl,
    String? profile,
    bool? isFriend,
  }) {
    return UserListModel()
      ..id = id ?? this.id
      ..memberNum = memberNum ?? this.memberNum
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..profile = profile ?? this.profile
      ..isFriend = isFriend ?? this.isFriend;
  }
}
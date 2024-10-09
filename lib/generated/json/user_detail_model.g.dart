import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/user/user_detail_model.dart';

UserDetailModel $UserDetailModelFromJson(Map<String, dynamic> json) {
  final UserDetailModel userDetailModel = UserDetailModel();
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    userDetailModel.avatarUrl = avatarUrl;
  }
  final String? memberName = jsonConvert.convert<String>(json['memberName']);
  if (memberName != null) {
    userDetailModel.memberName = memberName;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    userDetailModel.nickName = nickName;
  }
  final String? friendNickName = jsonConvert.convert<String>(json['friendNickName']);
  if (friendNickName != null) {
    userDetailModel.friendNickName = friendNickName;
  }
  final int? level = jsonConvert.convert<int>(json['level']);
  if (level != null) {
    userDetailModel.level = level;
  }
  final int? focusNumber = jsonConvert.convert<int>(json['focusNumber']);
  if (focusNumber != null) {
    userDetailModel.focusNumber = focusNumber;
  }
  final int? fansNumber = jsonConvert.convert<int>(json['fansNumber']);
  if (fansNumber != null) {
    userDetailModel.fansNumber = fansNumber;
  }
  final String? profile = jsonConvert.convert<String>(json['profile']);
  if (profile != null) {
    userDetailModel.profile = profile;
  }
  final int? onlineTime = jsonConvert.convert<int>(json['onlineTime']);
  if (onlineTime != null) {
    userDetailModel.onlineTime = onlineTime;
  }
  final bool? isFriend = jsonConvert.convert<bool>(json['isFriend']);
  if (isFriend != null) {
    userDetailModel.isFriend = isFriend;
  }
  final String? onlineStatus = jsonConvert.convert<String>(json['onlineStatus']);
  if (onlineStatus != null) {
    userDetailModel.onlineStatus = onlineStatus;
  }
  final String? userId = jsonConvert.convert<String>(json['userId']);
  if (userId != null) {
    userDetailModel.userId = userId;
  }
  final int? postsNumber = jsonConvert.convert<int>(json['postsNumber']);
  if (postsNumber != null) {
    userDetailModel.postsNumber = postsNumber;
  }
  final int? lookMeNumber = jsonConvert.convert<int>(json['lookMeNumber']);
  if (lookMeNumber != null) {
    userDetailModel.lookMeNumber = lookMeNumber;
  }
  return userDetailModel;
}

Map<String, dynamic> $UserDetailModelToJson(UserDetailModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['avatarUrl'] = entity.avatarUrl;
  data['memberName'] = entity.memberName;
  data['nickName'] = entity.nickName;
  data['friendNickName'] = entity.friendNickName;
  data['level'] = entity.level;
  data['focusNumber'] = entity.focusNumber;
  data['fansNumber'] = entity.fansNumber;
  data['profile'] = entity.profile;
  data['onlineTime'] = entity.onlineTime;
  data['isFriend'] = entity.isFriend;
  data['onlineStatus'] = entity.onlineStatus;
  data['userId'] = entity.userId;
  data['postsNumber'] = entity.postsNumber;
  data['lookMeNumber'] = entity.lookMeNumber;
  return data;
}

extension UserDetailModelExtension on UserDetailModel {
  UserDetailModel copyWith({
    String? avatarUrl,
    String? memberName,
    String? nickName,
    String? friendNickName,
    int? level,
    int? focusNumber,
    int? fansNumber,
    String? profile,
    int? onlineTime,
    bool? isFriend,
    String? onlineStatus,
    String? userId,
    int? postsNumber,
    int? lookMeNumber,
  }) {
    return UserDetailModel()
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..memberName = memberName ?? this.memberName
      ..nickName = nickName ?? this.nickName
      ..friendNickName = friendNickName ?? this.friendNickName
      ..level = level ?? this.level
      ..focusNumber = focusNumber ?? this.focusNumber
      ..fansNumber = fansNumber ?? this.fansNumber
      ..profile = profile ?? this.profile
      ..onlineTime = onlineTime ?? this.onlineTime
      ..isFriend = isFriend ?? this.isFriend
      ..onlineStatus = onlineStatus ?? this.onlineStatus
      ..userId = userId ?? this.userId
      ..postsNumber = postsNumber ?? this.postsNumber
      ..lookMeNumber = lookMeNumber ?? this.lookMeNumber;
  }
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/user_detail_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/user_detail_model.g.dart';

@JsonSerializable()
class UserDetailModel {
	String? avatarUrl;
	String? memberName;
	String? nickName;
	String? friendNickName;
	int? level;
	int? focusNumber;
	int? fansNumber;
	String? profile;
	int? onlineTime;
	bool? isFriend;
	// 在线状态（Online：在线、PushOnline：离线、Offline：未登录）
	String? onlineStatus;
	// 本地加的，接口未返回该字段。如需使用请务必提前设置
	String? userId;
	int? postsNumber; //发布帖子数量
	int? lookMeNumber; //看过我的数量

	UserDetailModel();

	bool get isOnline => onlineStatus == 'Online';


	factory UserDetailModel.fromJson(Map<String, dynamic> json) => $UserDetailModelFromJson(json);

	Map<String, dynamic> toJson() => $UserDetailModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}

	String get showName {
		return friendNickName ?? nickName ?? memberName ?? '';
	}
}
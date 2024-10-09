import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/follow_user_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/follow_user_list_model.g.dart';

@JsonSerializable()
class FollowUserListModel {
	String? memberNum;
	String? nickName;
	String? avatarUrl;
	String? online;
	// 1,已关注 2,回关 3，相互关注
	int? isFocus;

	FollowUserListModel();

	factory FollowUserListModel.fromJson(Map<String, dynamic> json) => $FollowUserListModelFromJson(json);

	Map<String, dynamic> toJson() => $FollowUserListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/posts_hot_recommend_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/posts_hot_recommend_model.g.dart';

@JsonSerializable()
class PostsHotRecommendModel {
	dynamic createBy;
	dynamic createTime;
	dynamic updateBy;
	dynamic updateTime;
	dynamic remark;
	dynamic id;
	String? nickName;
	dynamic memberNum;
	dynamic memberName;
	dynamic password;
	dynamic memberAddress;
	String? avatarUrl;
	dynamic inviteCode;
	dynamic status;
	dynamic profile;
	dynamic loginIp;
	dynamic loginDate;
	dynamic delFlag;
	dynamic friendNickname;
	dynamic isAdministrators;
	dynamic isGroupLeader;
	dynamic groupMemberNickname;

	PostsHotRecommendModel();

	factory PostsHotRecommendModel.fromJson(Map<String, dynamic> json) => $PostsHotRecommendModelFromJson(json);

	Map<String, dynamic> toJson() => $PostsHotRecommendModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
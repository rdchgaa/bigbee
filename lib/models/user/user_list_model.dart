import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/user_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/user_list_model.g.dart';

@JsonSerializable()
class UserListModel {
	String? id;
	String? memberNum;
	String? nickName;
	String? avatarUrl;
	String? profile;
	bool? isFriend;

	UserListModel();

	factory UserListModel.fromJson(Map<String, dynamic> json) => $UserListModelFromJson(json);

	Map<String, dynamic> toJson() => $UserListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
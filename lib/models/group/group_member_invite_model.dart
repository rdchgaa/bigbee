import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/group_member_invite_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/group_member_invite_model.g.dart';

@JsonSerializable()
class GroupMemberInviteModel {
	String? memberNum;
	String? nickName;
	String? avatarUrl;

	GroupMemberInviteModel();

	factory GroupMemberInviteModel.fromJson(Map<String, dynamic> json) => $GroupMemberInviteModelFromJson(json);

	Map<String, dynamic> toJson() => $GroupMemberInviteModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/system_message_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/system_message_model.g.dart';

@JsonSerializable()
class SystemMessageModel {
	int? messageId;
	int? invitationMemberId;
	String? invitationMemberAvatar;
	String? invitationMemberName;
	/// 消息类型（1：邀请加为好友、2：邀请加入群组）
	int? type;
	int? groupInfoId;
	String? groupId;
	String? leaveMessage;
	/// 状态（1：待确认、2：同意、3：拒绝）
	int? status;
	String? createTime;
	String? groupInfoName;

	SystemMessageModel();

	factory SystemMessageModel.fromJson(Map<String, dynamic> json) => $SystemMessageModelFromJson(json);

	Map<String, dynamic> toJson() => $SystemMessageModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
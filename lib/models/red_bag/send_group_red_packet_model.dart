import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/send_group_red_packet_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/send_group_red_packet_model.g.dart';

@JsonSerializable()
class SendGroupRedPacketModel {
	dynamic createBy;
	late String createTime;
	dynamic updateBy;
	dynamic updateTime;
	dynamic remark;
	late int id;
	late int memberId;
	dynamic toMemberNum;
	late String groupId;
	late String title;
	late int coinId;
	late int qty;
	late int number;
	late int receiveNumber;
	late int receiveQty;
	dynamic backQty;
	late int status;
	late int level;
	late int type;

	SendGroupRedPacketModel();

	factory SendGroupRedPacketModel.fromJson(Map<String, dynamic> json) => $SendGroupRedPacketModelFromJson(json);

	Map<String, dynamic> toJson() => $SendGroupRedPacketModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
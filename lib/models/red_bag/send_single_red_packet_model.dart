import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/send_single_red_packet_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/send_single_red_packet_model.g.dart';

@JsonSerializable()
class SendSingleRedPacketModel {
	dynamic createBy;
	late String createTime;
	dynamic updateBy;
	dynamic updateTime;
	dynamic remark;
	late int id;
	late int memberId;
	late String toMemberNum;
	dynamic groupId;
	late String title;
	late int coinId;
	late int qty;
	late int number;
	late int receiveNumber;
	late int receiveQty;
	dynamic backQty;
	late int status;
	late int level;
	dynamic type;

	SendSingleRedPacketModel();

	factory SendSingleRedPacketModel.fromJson(Map<String, dynamic> json) => $SendSingleRedPacketModelFromJson(json);

	Map<String, dynamic> toJson() => $SendSingleRedPacketModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
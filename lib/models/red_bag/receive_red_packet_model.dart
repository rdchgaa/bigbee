import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/receive_red_packet_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/receive_red_packet_model.g.dart';

@JsonSerializable()
class ReceiveRedPacketModel {
	String? coinName;
	int? coinId;
	int? redPacketId;
	int? formMemberId;
	int? receiveMemberId;
	double? receiveQty;

	ReceiveRedPacketModel();

	factory ReceiveRedPacketModel.fromJson(Map<String, dynamic> json) => $ReceiveRedPacketModelFromJson(json);

	Map<String, dynamic> toJson() => $ReceiveRedPacketModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
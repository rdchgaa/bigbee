import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/is_receive_red_packet_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/is_receive_red_packet_model.g.dart';

@JsonSerializable()
class IsReceiveRedPacketModel {
	late int status;

	IsReceiveRedPacketModel();

	factory IsReceiveRedPacketModel.fromJson(Map<String, dynamic> json) => $IsReceiveRedPacketModelFromJson(json);

	Map<String, dynamic> toJson() => $IsReceiveRedPacketModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/get_red_packet_total_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/get_red_packet_total_model.g.dart';

@JsonSerializable()
class GetRedPacketTotalModel {
	late String nickName;
	late String avatarUrl;
	late double qty;
	dynamic memberSearchRedPacketVoList;

	GetRedPacketTotalModel();

	factory GetRedPacketTotalModel.fromJson(Map<String, dynamic> json) => $GetRedPacketTotalModelFromJson(json);

	Map<String, dynamic> toJson() => $GetRedPacketTotalModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
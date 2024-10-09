import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/red_packet_detail_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/red_packet_detail_model.g.dart';

@JsonSerializable()
class RedPacketDetailModel {
	late String nickName;
	late String avatarUrl;
	late String title;
	late int number;
	late String qty;
	late String coinName;
	late int receiveNumber;
	late int status;
	late int redPacketId;

	RedPacketDetailModel();

	factory RedPacketDetailModel.fromJson(Map<String, dynamic> json) => $RedPacketDetailModelFromJson(json);

	Map<String, dynamic> toJson() => $RedPacketDetailModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
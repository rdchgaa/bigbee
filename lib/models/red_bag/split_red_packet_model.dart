import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/split_red_packet_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/split_red_packet_model.g.dart';

@JsonSerializable()
class SplitRedPacketModel {
	late int redPacketId;
	late String nickName;
	late String avatarUrl;
	late String title;

	SplitRedPacketModel();

	factory SplitRedPacketModel.fromJson(Map<String, dynamic> json) => $SplitRedPacketModelFromJson(json);

	Map<String, dynamic> toJson() => $SplitRedPacketModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
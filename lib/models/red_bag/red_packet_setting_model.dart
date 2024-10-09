import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/red_packet_setting_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/red_packet_setting_model.g.dart';

@JsonSerializable()
class RedPacketSettingModel {
	dynamic createBy;
	late String createTime;
	dynamic updateBy;
	late String updateTime;
	dynamic remark;
	late int id;
	late int type;
	late int level;
	late int status;
	late int coinId;
	late double max;
	late double min;

	RedPacketSettingModel();

	factory RedPacketSettingModel.fromJson(Map<String, dynamic> json) => $RedPacketSettingModelFromJson(json);

	Map<String, dynamic> toJson() => $RedPacketSettingModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/red_packet_get_receivers_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/red_packet_get_receivers_model.g.dart';

@JsonSerializable()
class RedPacketGetReceiversModel {
	late List<RedPacketGetReceiversRecords> records;
	late int total;
	late int size;
	late int current;
	late List<dynamic> orders;
	late bool optimizeCountSql;
	late bool searchCount;
	dynamic countId;
	dynamic maxLimit;
	late int pages;

	RedPacketGetReceiversModel();

	factory RedPacketGetReceiversModel.fromJson(Map<String, dynamic> json) => $RedPacketGetReceiversModelFromJson(json);

	Map<String, dynamic> toJson() => $RedPacketGetReceiversModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class RedPacketGetReceiversRecords {
	late String nickName;
	late String avatarUrl;
	late String qty;
	dynamic coinName;
	late String receiveTime;

	RedPacketGetReceiversRecords();

	factory RedPacketGetReceiversRecords.fromJson(Map<String, dynamic> json) => $RedPacketGetReceiversRecordsFromJson(json);

	Map<String, dynamic> toJson() => $RedPacketGetReceiversRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/get_red_packet_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/get_red_packet_list_model.g.dart';

@JsonSerializable()
class GetRedPacketListModel {
	late List<GetRedPacketListRecords> records;
	late int total;
	late int size;
	late int current;
	late List<dynamic> orders;
	late bool optimizeCountSql;
	late bool searchCount;
	dynamic countId;
	dynamic maxLimit;
	late int pages;

	GetRedPacketListModel();

	factory GetRedPacketListModel.fromJson(Map<String, dynamic> json) => $GetRedPacketListModelFromJson(json);

	Map<String, dynamic> toJson() => $GetRedPacketListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class GetRedPacketListRecords {
	late String nickName;
	late double qty;
	late String createTime;
	late String avatarUrl;
	late int level;

	GetRedPacketListRecords();

	factory GetRedPacketListRecords.fromJson(Map<String, dynamic> json) => $GetRedPacketListRecordsFromJson(json);

	Map<String, dynamic> toJson() => $GetRedPacketListRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/invite_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/invite_list_model.g.dart';

@JsonSerializable()
class InviteListModel {
	late List<InviteListRecords> records;
	late int total;
	late int size;
	late int current;
	late List<dynamic> orders;
	late bool optimizeCountSql;
	late bool searchCount;
	dynamic countId;
	dynamic maxLimit;
	late int pages;

	InviteListModel();

	factory InviteListModel.fromJson(Map<String, dynamic> json) => $InviteListModelFromJson(json);

	Map<String, dynamic> toJson() => $InviteListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class InviteListRecords {
	late String nickName;
	late String avatarUrl;
	late String inviteTime;
	late String onlineStatus;

	InviteListRecords();

	factory InviteListRecords.fromJson(Map<String, dynamic> json) => $InviteListRecordsFromJson(json);

	Map<String, dynamic> toJson() => $InviteListRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
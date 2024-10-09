import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/collection_message_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/collection_message_list_model.g.dart';

@JsonSerializable()
class CollectionMessageListModel {
	List<CollectionMessageListRecords>? records;
	int? total;
	int? size;
	int? current;
	List<dynamic>? orders;
	bool? optimizeCountSql;
	bool? searchCount;
	dynamic countId;
	dynamic maxLimit;
	int? pages;

	CollectionMessageListModel();

	factory CollectionMessageListModel.fromJson(Map<String, dynamic> json) => $CollectionMessageListModelFromJson(json);

	Map<String, dynamic> toJson() => $CollectionMessageListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CollectionMessageListRecords {
	String? formNickName;
	String? formAvatar;
	dynamic groupInfoId;
	int? collectId;
	List<CollectionMessageListRecordsSearchMessageList>? searchMessageList;

	CollectionMessageListRecords();

	factory CollectionMessageListRecords.fromJson(Map<String, dynamic> json) => $CollectionMessageListRecordsFromJson(json);

	Map<String, dynamic> toJson() => $CollectionMessageListRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CollectionMessageListRecordsSearchMessageList {
	dynamic createBy;
	String? createTime;
	String? messageTime;
	dynamic updateBy;
	String? updateTime;
	dynamic remark;
	int? id;
	int? memberId;
	int? collectId;
	int? type;
	String? value;
	dynamic nickName;
	dynamic avatar;

	CollectionMessageListRecordsSearchMessageList();

	factory CollectionMessageListRecordsSearchMessageList.fromJson(Map<String, dynamic> json) => $CollectionMessageListRecordsSearchMessageListFromJson(json);

	Map<String, dynamic> toJson() => $CollectionMessageListRecordsSearchMessageListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/collection_details_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/collection_details_model.g.dart';

@JsonSerializable()
class CollectionDetailsModel {
	List<CollectionDetailsRecords>? records;
	int? total;
	int? size;
	int? current;
	List<dynamic>? orders;
	bool? optimizeCountSql;
	bool? searchCount;
	dynamic countId;
	dynamic maxLimit;
	int? pages;

	CollectionDetailsModel();

	factory CollectionDetailsModel.fromJson(Map<String, dynamic> json) => $CollectionDetailsModelFromJson(json);

	Map<String, dynamic> toJson() => $CollectionDetailsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CollectionDetailsRecords {
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
	String? nickName;
	String? avatar;

	CollectionDetailsRecords();

	factory CollectionDetailsRecords.fromJson(Map<String, dynamic> json) => $CollectionDetailsRecordsFromJson(json);

	Map<String, dynamic> toJson() => $CollectionDetailsRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
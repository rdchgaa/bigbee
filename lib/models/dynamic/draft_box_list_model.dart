import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/draft_box_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/draft_box_list_model.g.dart';

@JsonSerializable()
class DraftBoxListModel {
	List<DraftBoxListRecords>? records;
	int? total;
	int? size;
	int? current;
	List<dynamic>? orders;
	bool? optimizeCountSql;
	bool? searchCount;
	dynamic countId;
	dynamic maxLimit;
	int? pages;

	DraftBoxListModel();

	factory DraftBoxListModel.fromJson(Map<String, dynamic> json) => $DraftBoxListModelFromJson(json);

	Map<String, dynamic> toJson() => $DraftBoxListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DraftBoxListRecords {
	String? id;
	int? trendsType;
	String? textContent;
	String? imgeUrls;
	String? videoUrl;
	String? createTime;

	DraftBoxListRecords();

	factory DraftBoxListRecords.fromJson(Map<String, dynamic> json) => $DraftBoxListRecordsFromJson(json);

	Map<String, dynamic> toJson() => $DraftBoxListRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
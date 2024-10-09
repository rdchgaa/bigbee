import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/hot_top_posts_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/hot_top_posts_list_model.g.dart';

@JsonSerializable()
class HotTopPostsListModel {
	List<HotTopPostsListRecords>? records;
	int? total;
	int? size;
	int? current;
	List<dynamic>? orders;
	bool? optimizeCountSql;
	bool? searchCount;
	dynamic countId;
	dynamic maxLimit;
	int? pages;

	HotTopPostsListModel();

	factory HotTopPostsListModel.fromJson(Map<String, dynamic> json) => $HotTopPostsListModelFromJson(json);

	Map<String, dynamic> toJson() => $HotTopPostsListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HotTopPostsListRecords {
	int? postsId;
	String? textContent;
	int? commendCount;
	int? readCount;

	HotTopPostsListRecords();

	factory HotTopPostsListRecords.fromJson(Map<String, dynamic> json) => $HotTopPostsListRecordsFromJson(json);

	Map<String, dynamic> toJson() => $HotTopPostsListRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/look_history_posts_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/look_history_posts_model.g.dart';

@JsonSerializable()
class LookHistoryPostsModel {
	List<LookHistoryPostsRecords>? records;
	int? total;
	int? size;
	int? current;
	List<dynamic>? orders;
	bool? optimizeCountSql;
	bool? searchCount;
	dynamic countId;
	dynamic maxLimit;
	int? pages;

	LookHistoryPostsModel();

	factory LookHistoryPostsModel.fromJson(Map<String, dynamic> json) => $LookHistoryPostsModelFromJson(json);

	Map<String, dynamic> toJson() => $LookHistoryPostsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class LookHistoryPostsRecords {
	int? postsId;
	int? trendsType;
	String? avatarUrl;
	String? nickName;
	String? content;
	String? imagesUrl;
	String? videoUrl;
	String? lookTime;

	LookHistoryPostsRecords();

	factory LookHistoryPostsRecords.fromJson(Map<String, dynamic> json) => $LookHistoryPostsRecordsFromJson(json);

	Map<String, dynamic> toJson() => $LookHistoryPostsRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
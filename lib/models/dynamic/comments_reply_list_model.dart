import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/comments_reply_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/comments_reply_list_model.g.dart';

@JsonSerializable()
class CommentsReplyListModel {
	List<CommentsReplyListRecords>? records;
	int? total;
	int? size;
	int? current;
	List<dynamic>? orders;
	bool? optimizeCountSql;
	bool? searchCount;
	dynamic countId;
	dynamic maxLimit;
	int? pages;

	CommentsReplyListModel();

	factory CommentsReplyListModel.fromJson(Map<String, dynamic> json) => $CommentsReplyListModelFromJson(json);

	Map<String, dynamic> toJson() => $CommentsReplyListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CommentsReplyListRecords {
	int? replyId;
	int? fromMemberId;
	String? contentInfo;
	String? fromMemberNickName;
	String? toMemberNickName;
	int? type;

	CommentsReplyListRecords();

	factory CommentsReplyListRecords.fromJson(Map<String, dynamic> json) => $CommentsReplyListRecordsFromJson(json);

	Map<String, dynamic> toJson() => $CommentsReplyListRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/posts_details_comments_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/posts_details_comments_model.g.dart';

@JsonSerializable()
class PostsDetailsCommentsModel {
	List<PostsDetailsCommentsRecords>? records;
	int? total;
	int? size;
	int? current;
	List<dynamic>? orders;
	bool? optimizeCountSql;
	bool? searchCount;
	dynamic countId;
	dynamic maxLimit;
	int? pages;

	PostsDetailsCommentsModel();

	factory PostsDetailsCommentsModel.fromJson(Map<String, dynamic> json) => $PostsDetailsCommentsModelFromJson(json);

	Map<String, dynamic> toJson() => $PostsDetailsCommentsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class PostsDetailsCommentsRecords {
	int? id;
	int? memberId;
	String? nickName;
	String? avatarUrl;
	String? content;
	String? createTime;
	List<PostsDetailsCommentsRecordsCommentsReplyList>? commentsReplyList;
	bool? isLike;

	PostsDetailsCommentsRecords();

	factory PostsDetailsCommentsRecords.fromJson(Map<String, dynamic> json) => $PostsDetailsCommentsRecordsFromJson(json);

	Map<String, dynamic> toJson() => $PostsDetailsCommentsRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class PostsDetailsCommentsRecordsCommentsReplyList {
	String? contentInfo;
	String? fromMemberNickName;
	dynamic toMemberNickName;
	int? type;

	PostsDetailsCommentsRecordsCommentsReplyList();

	factory PostsDetailsCommentsRecordsCommentsReplyList.fromJson(Map<String, dynamic> json) => $PostsDetailsCommentsRecordsCommentsReplyListFromJson(json);

	Map<String, dynamic> toJson() => $PostsDetailsCommentsRecordsCommentsReplyListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
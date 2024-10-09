import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/posts_hot_recommend_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/posts_hot_recommend_list_model.g.dart';

@JsonSerializable()
class PostsHotRecommendListModel {
	List<PostsHotRecommendListRecords>? records;
	int? total;
	int? size;
	int? current;
	List<dynamic>? orders;
	bool? optimizeCountSql;
	bool? searchCount;
	dynamic countId;
	dynamic maxLimit;
	int? pages;

	PostsHotRecommendListModel();

	factory PostsHotRecommendListModel.fromJson(Map<String, dynamic> json) => $PostsHotRecommendListModelFromJson(json);

	Map<String, dynamic> toJson() => $PostsHotRecommendListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class PostsHotRecommendListRecords {
	int? postId;
	String? memberNum;
	String? nickName;
	String? avatarUrl;
	String? publishTime;
	String? textContent;
	String? imgeUrls;
	String? videoUrl;
	int? isPositionInfo;
	String? addName;
	String? addrLongitude;
	String? addrLatitude;
	int? isFocus;
	int? shareCount;
	int? likeCount;
	int? commentCount;
	int? lookCount;
	bool? isCanShare;
	bool? isCanComment;
	bool? isLike;
	bool? isCollect;

	PostsHotRecommendListRecords();

	factory PostsHotRecommendListRecords.fromJson(Map<String, dynamic> json) => $PostsHotRecommendListRecordsFromJson(json);

	Map<String, dynamic> toJson() => $PostsHotRecommendListRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

class PostShareMsgModel {
	int postId;
	String nickName;
	String textContent;
	String imageUrls;
	String videoUrl;

	PostShareMsgModel({
		required this.postId,
		required this.nickName,
		this.textContent = '',
		this.imageUrls = '',
		this.videoUrl = '',
  });


	Map<String, dynamic> toJson() => <String, dynamic>{
		'postId': postId,
		'nickName': nickName,
		'textContent': textContent,
		'imageUrls': imageUrls,
		'videoUrl': videoUrl,
	};

	factory PostShareMsgModel.fromJson(Map<String, dynamic> json) {
		return PostShareMsgModel(
			postId: json['postId'] as int,
			nickName: json['nickName'] as String,
			textContent: json['textContent'] as String,
			imageUrls: json['imageUrls'] as String,
			videoUrl: json['videoUrl'] as String,
		);
	}

}

import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/posts_details_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/posts_details_model.g.dart';

@JsonSerializable()
class PostsDetailsModel {
	String? nickName;
	String? avatarUrl;
	String? publishTime;
	int? trendsType;
	String? textContent;
	String? imgeUrls;
	String? videoUrl;
	int? isPositionInfo;
	String? addrName;
	String? addrAddress;
	String? addrLongitude;
	String? addrLatitude;
	int? isFocus;
	int? shareCount;
	int? likeCount;
	int? commentCount;
	int? collectNum;
	String? tippingTotalAmount;
	int? isMyself;
	bool? isLike;
	String? memberNum;
	bool? isCanShare;
	bool? isCanComment;
	bool? isCollect;


	PostsDetailsModel();

	factory PostsDetailsModel.fromJson(Map<String, dynamic> json) => $PostsDetailsModelFromJson(json);

	Map<String, dynamic> toJson() => $PostsDetailsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
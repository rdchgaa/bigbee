import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/get_posts_count_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/get_posts_count_model.g.dart';

@JsonSerializable()
class GetPostsCountModel {
	dynamic createBy;
	String? createTime;
	dynamic updateBy;
	String? updateTime;
	dynamic remark;
	int? id;
	int? infoId;
	int? sharesNum;
	int? commentNum;
	int? giveNum;
	int? readNum;
	int? collectionNum;
	int? rewardQty;
	bool? like;

	GetPostsCountModel();

	factory GetPostsCountModel.fromJson(Map<String, dynamic> json) => $GetPostsCountModelFromJson(json);

	Map<String, dynamic> toJson() => $GetPostsCountModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
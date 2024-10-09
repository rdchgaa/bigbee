import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/posts_reward_options_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/posts_reward_options_model.g.dart';

@JsonSerializable()
class PostsRewardOptionsModel {
	dynamic createBy;
	String? createTime;
	dynamic updateBy;
	String? updateTime;
	dynamic remark;
	int? id;
	int? type;
	int? payCoinId;
	double? payQty;
	double? durationNum;
	double? price;

	PostsRewardOptionsModel();

	factory PostsRewardOptionsModel.fromJson(Map<String, dynamic> json) => $PostsRewardOptionsModelFromJson(json);

	Map<String, dynamic> toJson() => $PostsRewardOptionsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
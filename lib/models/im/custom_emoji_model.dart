import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/custom_emoji_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/custom_emoji_model.g.dart';

@JsonSerializable()
class CustomEmojiModel {
	int? id;
	String? identification;
	String? name;
	String? imgUrl;
	List<CustomEmojiEmoticonsInfoList>? emoticonsInfoList;

	CustomEmojiModel();

	factory CustomEmojiModel.fromJson(Map<String, dynamic> json) => $CustomEmojiModelFromJson(json);

	Map<String, dynamic> toJson() => $CustomEmojiModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CustomEmojiEmoticonsInfoList {
	int? id;
	String? identification;
	String? name;
	String? imgUrl;

	CustomEmojiEmoticonsInfoList();

	factory CustomEmojiEmoticonsInfoList.fromJson(Map<String, dynamic> json) => $CustomEmojiEmoticonsInfoListFromJson(json);

	Map<String, dynamic> toJson() => $CustomEmojiEmoticonsInfoListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
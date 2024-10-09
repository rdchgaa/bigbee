import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/notice_details_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/notice_details_model.g.dart';

@JsonSerializable()
class NoticeDetailsModel {
	String? createTime;
	int? id;
	int? noticeId;
	String? languageType;
	String? title;
	String? profile;
	String? imgUrl;
	String? noticeContent;

	NoticeDetailsModel();

	factory NoticeDetailsModel.fromJson(Map<String, dynamic> json) => $NoticeDetailsModelFromJson(json);

	Map<String, dynamic> toJson() => $NoticeDetailsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
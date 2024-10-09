import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/notice_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/notice_list_model.g.dart';

@JsonSerializable()
class NoticeListModel {
	int? noticeId;
	String? title;
	String? cover;
	String? createTime;
	String? profile;

	NoticeListModel();

	factory NoticeListModel.fromJson(Map<String, dynamic> json) => $NoticeListModelFromJson(json);

	Map<String, dynamic> toJson() => $NoticeListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
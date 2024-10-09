import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/group_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/group_list_model.g.dart';

@JsonSerializable()
class GroupListModel {
	String? groupId;
	String? groupName;
	String? groupAvatarUrl;
	int? groupPersonNum;
	String? groupDescription;
	int? isInto;

	GroupListModel();

	factory GroupListModel.fromJson(Map<String, dynamic> json) => $GroupListModelFromJson(json);

	Map<String, dynamic> toJson() => $GroupListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
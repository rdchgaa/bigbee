import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/version_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/version_list_model.g.dart';

@JsonSerializable()
class VersionListModel {
	String? createTime;
	String? updateTime;
	String? remark;
	int? id;
	String? versionNum;
	int? osVersion;
	int? isForceUpdates;
	String? languageMsgCn;
	String? languageMsgUs;
	String? downloadAddr;

	VersionListModel();

	factory VersionListModel.fromJson(Map<String, dynamic> json) => $VersionListModelFromJson(json);

	Map<String, dynamic> toJson() => $VersionListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/upload_sign_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/upload_sign_model.g.dart';

@JsonSerializable()
class UploadSignModel {
	String? accessKeyId;
	String? policy;
	String? signature;
	String? fileDir;
	String? fileName;
	String? host;
	String? expire;

	UploadSignModel();

	factory UploadSignModel.fromJson(Map<String, dynamic> json) => $UploadSignModelFromJson(json);

	Map<String, dynamic> toJson() => $UploadSignModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/google_is_bind_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/google_is_bind_model.g.dart';

@JsonSerializable()
class GoogleIsBindModel {
	late String androidUrl;
	late String iosUrl;
	late bool isBind;

	GoogleIsBindModel();

	factory GoogleIsBindModel.fromJson(Map<String, dynamic> json) => $GoogleIsBindModelFromJson(json);

	Map<String, dynamic> toJson() => $GoogleIsBindModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/test_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/test_model.g.dart';

@JsonSerializable()
class TestModel {
	String? username;
	String? password;
	String? code;
	String? uuid;

	TestModel();

	factory TestModel.fromJson(Map<String, dynamic> json) => $TestModelFromJson(json);

	Map<String, dynamic> toJson() => $TestModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
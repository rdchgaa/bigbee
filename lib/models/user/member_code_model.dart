import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/member_code_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/member_code_model.g.dart';

@JsonSerializable()
class MemberCodeModel {
	late String code;
	late String url;

	MemberCodeModel();

	factory MemberCodeModel.fromJson(Map<String, dynamic> json) => $MemberCodeModelFromJson(json);

	Map<String, dynamic> toJson() => $MemberCodeModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
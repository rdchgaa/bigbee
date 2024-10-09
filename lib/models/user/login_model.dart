import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/login_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/login_model.g.dart';

/// 登陆模型
@JsonSerializable()
class LoginModel {
	String? userSig;
	String? userId;
	String? token;

	LoginModel();

	factory LoginModel.fromJson(Map<String, dynamic> json) => $LoginModelFromJson(json);

	Map<String, dynamic> toJson() => $LoginModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
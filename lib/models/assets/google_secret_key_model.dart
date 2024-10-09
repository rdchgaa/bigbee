import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/google_secret_key_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/google_secret_key_model.g.dart';

@JsonSerializable()
class GoogleSecretKeyModel {
	late String secretKey;
	dynamic code;
	late String androidUrl;
	late String iosUrl;

	GoogleSecretKeyModel();

	factory GoogleSecretKeyModel.fromJson(Map<String, dynamic> json) => $GoogleSecretKeyModelFromJson(json);

	Map<String, dynamic> toJson() => $GoogleSecretKeyModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
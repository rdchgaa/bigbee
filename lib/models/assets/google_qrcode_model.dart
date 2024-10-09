import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/google_qrcode_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/google_qrcode_model.g.dart';

@JsonSerializable()
class GoogleQrcodeModel {
	late String secretKey;
	dynamic code;
	dynamic androidUrl;
	dynamic iosUrl;
	late String base64Image;

	GoogleQrcodeModel();

	factory GoogleQrcodeModel.fromJson(Map<String, dynamic> json) => $GoogleQrcodeModelFromJson(json);

	Map<String, dynamic> toJson() => $GoogleQrcodeModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
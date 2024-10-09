import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/captcha_image_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/captcha_image_model.g.dart';

/// 图形验证码模型
@JsonSerializable()
class CaptchaImageModel {
	String? img;
	bool? captchaEnabledLogin;
	bool? captchaEnabledRegister;
	String? uuid;

	CaptchaImageModel();

	factory CaptchaImageModel.fromJson(Map<String, dynamic> json) => $CaptchaImageModelFromJson(json);

	Map<String, dynamic> toJson() => $CaptchaImageModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
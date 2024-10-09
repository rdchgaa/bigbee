import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/launch_splash_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/launch_splash_model.g.dart';

@JsonSerializable()
class LaunchSplashModel {
	int? id;
	int? type;
	String? url;
	double? displayDuration;
	int? status;
	// 1：关注、2：热帖、3：广场
	int? index;

	LaunchSplashModel();

	factory LaunchSplashModel.fromJson(Map<String, dynamic> json) => $LaunchSplashModelFromJson(json);

	Map<String, dynamic> toJson() => $LaunchSplashModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
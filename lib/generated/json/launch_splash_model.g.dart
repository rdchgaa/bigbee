import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/common/launch_splash_model.dart';

LaunchSplashModel $LaunchSplashModelFromJson(Map<String, dynamic> json) {
  final LaunchSplashModel launchSplashModel = LaunchSplashModel();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    launchSplashModel.id = id;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    launchSplashModel.type = type;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    launchSplashModel.url = url;
  }
  final double? displayDuration = jsonConvert.convert<double>(json['displayDuration']);
  if (displayDuration != null) {
    launchSplashModel.displayDuration = displayDuration;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    launchSplashModel.status = status;
  }
  final int? index = jsonConvert.convert<int>(json['index']);
  if (index != null) {
    launchSplashModel.index = index;
  }
  return launchSplashModel;
}

Map<String, dynamic> $LaunchSplashModelToJson(LaunchSplashModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['type'] = entity.type;
  data['url'] = entity.url;
  data['displayDuration'] = entity.displayDuration;
  data['status'] = entity.status;
  data['index'] = entity.index;
  return data;
}

extension LaunchSplashModelExtension on LaunchSplashModel {
  LaunchSplashModel copyWith({
    int? id,
    int? type,
    String? url,
    double? displayDuration,
    int? status,
    int? index,
  }) {
    return LaunchSplashModel()
      ..id = id ?? this.id
      ..type = type ?? this.type
      ..url = url ?? this.url
      ..displayDuration = displayDuration ?? this.displayDuration
      ..status = status ?? this.status
      ..index = index ?? this.index;
  }
}
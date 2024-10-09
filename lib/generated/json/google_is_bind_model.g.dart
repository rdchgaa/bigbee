import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/google_is_bind_model.dart';

GoogleIsBindModel $GoogleIsBindModelFromJson(Map<String, dynamic> json) {
  final GoogleIsBindModel googleIsBindModel = GoogleIsBindModel();
  final String? androidUrl = jsonConvert.convert<String>(json['androidUrl']);
  if (androidUrl != null) {
    googleIsBindModel.androidUrl = androidUrl;
  }
  final String? iosUrl = jsonConvert.convert<String>(json['iosUrl']);
  if (iosUrl != null) {
    googleIsBindModel.iosUrl = iosUrl;
  }
  final bool? isBind = jsonConvert.convert<bool>(json['isBind']);
  if (isBind != null) {
    googleIsBindModel.isBind = isBind;
  }
  return googleIsBindModel;
}

Map<String, dynamic> $GoogleIsBindModelToJson(GoogleIsBindModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['androidUrl'] = entity.androidUrl;
  data['iosUrl'] = entity.iosUrl;
  data['isBind'] = entity.isBind;
  return data;
}

extension GoogleIsBindModelExtension on GoogleIsBindModel {
  GoogleIsBindModel copyWith({
    String? androidUrl,
    String? iosUrl,
    bool? isBind,
  }) {
    return GoogleIsBindModel()
      ..androidUrl = androidUrl ?? this.androidUrl
      ..iosUrl = iosUrl ?? this.iosUrl
      ..isBind = isBind ?? this.isBind;
  }
}
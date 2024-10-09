import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/google_qrcode_model.dart';

GoogleQrcodeModel $GoogleQrcodeModelFromJson(Map<String, dynamic> json) {
  final GoogleQrcodeModel googleQrcodeModel = GoogleQrcodeModel();
  final String? secretKey = jsonConvert.convert<String>(json['secretKey']);
  if (secretKey != null) {
    googleQrcodeModel.secretKey = secretKey;
  }
  final dynamic code = json['code'];
  if (code != null) {
    googleQrcodeModel.code = code;
  }
  final dynamic androidUrl = json['androidUrl'];
  if (androidUrl != null) {
    googleQrcodeModel.androidUrl = androidUrl;
  }
  final dynamic iosUrl = json['iosUrl'];
  if (iosUrl != null) {
    googleQrcodeModel.iosUrl = iosUrl;
  }
  final String? base64Image = jsonConvert.convert<String>(json['base64Image']);
  if (base64Image != null) {
    googleQrcodeModel.base64Image = base64Image;
  }
  return googleQrcodeModel;
}

Map<String, dynamic> $GoogleQrcodeModelToJson(GoogleQrcodeModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['secretKey'] = entity.secretKey;
  data['code'] = entity.code;
  data['androidUrl'] = entity.androidUrl;
  data['iosUrl'] = entity.iosUrl;
  data['base64Image'] = entity.base64Image;
  return data;
}

extension GoogleQrcodeModelExtension on GoogleQrcodeModel {
  GoogleQrcodeModel copyWith({
    String? secretKey,
    dynamic code,
    dynamic androidUrl,
    dynamic iosUrl,
    String? base64Image,
  }) {
    return GoogleQrcodeModel()
      ..secretKey = secretKey ?? this.secretKey
      ..code = code ?? this.code
      ..androidUrl = androidUrl ?? this.androidUrl
      ..iosUrl = iosUrl ?? this.iosUrl
      ..base64Image = base64Image ?? this.base64Image;
  }
}
import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/google_secret_key_model.dart';

GoogleSecretKeyModel $GoogleSecretKeyModelFromJson(Map<String, dynamic> json) {
  final GoogleSecretKeyModel googleSecretKeyModel = GoogleSecretKeyModel();
  final String? secretKey = jsonConvert.convert<String>(json['secretKey']);
  if (secretKey != null) {
    googleSecretKeyModel.secretKey = secretKey;
  }
  final dynamic code = json['code'];
  if (code != null) {
    googleSecretKeyModel.code = code;
  }
  final String? androidUrl = jsonConvert.convert<String>(json['androidUrl']);
  if (androidUrl != null) {
    googleSecretKeyModel.androidUrl = androidUrl;
  }
  final String? iosUrl = jsonConvert.convert<String>(json['iosUrl']);
  if (iosUrl != null) {
    googleSecretKeyModel.iosUrl = iosUrl;
  }
  return googleSecretKeyModel;
}

Map<String, dynamic> $GoogleSecretKeyModelToJson(GoogleSecretKeyModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['secretKey'] = entity.secretKey;
  data['code'] = entity.code;
  data['androidUrl'] = entity.androidUrl;
  data['iosUrl'] = entity.iosUrl;
  return data;
}

extension GoogleSecretKeyModelExtension on GoogleSecretKeyModel {
  GoogleSecretKeyModel copyWith({
    String? secretKey,
    dynamic code,
    String? androidUrl,
    String? iosUrl,
  }) {
    return GoogleSecretKeyModel()
      ..secretKey = secretKey ?? this.secretKey
      ..code = code ?? this.code
      ..androidUrl = androidUrl ?? this.androidUrl
      ..iosUrl = iosUrl ?? this.iosUrl;
  }
}
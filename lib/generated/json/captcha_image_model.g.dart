import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/common/captcha_image_model.dart';

CaptchaImageModel $CaptchaImageModelFromJson(Map<String, dynamic> json) {
  final CaptchaImageModel captchaImageModel = CaptchaImageModel();
  final String? img = jsonConvert.convert<String>(json['img']);
  if (img != null) {
    captchaImageModel.img = img;
  }
  final bool? captchaEnabledLogin = jsonConvert.convert<bool>(json['captchaEnabledLogin']);
  if (captchaEnabledLogin != null) {
    captchaImageModel.captchaEnabledLogin = captchaEnabledLogin;
  }
  final bool? captchaEnabledRegister = jsonConvert.convert<bool>(json['captchaEnabledRegister']);
  if (captchaEnabledRegister != null) {
    captchaImageModel.captchaEnabledRegister = captchaEnabledRegister;
  }
  final String? uuid = jsonConvert.convert<String>(json['uuid']);
  if (uuid != null) {
    captchaImageModel.uuid = uuid;
  }
  return captchaImageModel;
}

Map<String, dynamic> $CaptchaImageModelToJson(CaptchaImageModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['img'] = entity.img;
  data['captchaEnabledLogin'] = entity.captchaEnabledLogin;
  data['captchaEnabledRegister'] = entity.captchaEnabledRegister;
  data['uuid'] = entity.uuid;
  return data;
}

extension CaptchaImageModelExtension on CaptchaImageModel {
  CaptchaImageModel copyWith({
    String? img,
    bool? captchaEnabledLogin,
    bool? captchaEnabledRegister,
    String? uuid,
  }) {
    return CaptchaImageModel()
      ..img = img ?? this.img
      ..captchaEnabledLogin = captchaEnabledLogin ?? this.captchaEnabledLogin
      ..captchaEnabledRegister = captchaEnabledRegister ?? this.captchaEnabledRegister
      ..uuid = uuid ?? this.uuid;
  }
}
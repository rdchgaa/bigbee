import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/user/login_model.dart';

LoginModel $LoginModelFromJson(Map<String, dynamic> json) {
  final LoginModel loginModel = LoginModel();
  final String? userSig = jsonConvert.convert<String>(json['userSig']);
  if (userSig != null) {
    loginModel.userSig = userSig;
  }
  final String? userId = jsonConvert.convert<String>(json['userId']);
  if (userId != null) {
    loginModel.userId = userId;
  }
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    loginModel.token = token;
  }
  return loginModel;
}

Map<String, dynamic> $LoginModelToJson(LoginModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['userSig'] = entity.userSig;
  data['userId'] = entity.userId;
  data['token'] = entity.token;
  return data;
}

extension LoginModelExtension on LoginModel {
  LoginModel copyWith({
    String? userSig,
    String? userId,
    String? token,
  }) {
    return LoginModel()
      ..userSig = userSig ?? this.userSig
      ..userId = userId ?? this.userId
      ..token = token ?? this.token;
  }
}
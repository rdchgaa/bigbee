import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/common/test_model.dart';

TestModel $TestModelFromJson(Map<String, dynamic> json) {
  final TestModel testModel = TestModel();
  final String? username = jsonConvert.convert<String>(json['username']);
  if (username != null) {
    testModel.username = username;
  }
  final String? password = jsonConvert.convert<String>(json['password']);
  if (password != null) {
    testModel.password = password;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    testModel.code = code;
  }
  final String? uuid = jsonConvert.convert<String>(json['uuid']);
  if (uuid != null) {
    testModel.uuid = uuid;
  }
  return testModel;
}

Map<String, dynamic> $TestModelToJson(TestModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['username'] = entity.username;
  data['password'] = entity.password;
  data['code'] = entity.code;
  data['uuid'] = entity.uuid;
  return data;
}

extension TestModelExtension on TestModel {
  TestModel copyWith({
    String? username,
    String? password,
    String? code,
    String? uuid,
  }) {
    return TestModel()
      ..username = username ?? this.username
      ..password = password ?? this.password
      ..code = code ?? this.code
      ..uuid = uuid ?? this.uuid;
  }
}
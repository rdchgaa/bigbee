import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/common/upload_sign_model.dart';

UploadSignModel $UploadSignModelFromJson(Map<String, dynamic> json) {
  final UploadSignModel uploadSignModel = UploadSignModel();
  final String? accessKeyId = jsonConvert.convert<String>(json['accessKeyId']);
  if (accessKeyId != null) {
    uploadSignModel.accessKeyId = accessKeyId;
  }
  final String? policy = jsonConvert.convert<String>(json['policy']);
  if (policy != null) {
    uploadSignModel.policy = policy;
  }
  final String? signature = jsonConvert.convert<String>(json['signature']);
  if (signature != null) {
    uploadSignModel.signature = signature;
  }
  final String? fileDir = jsonConvert.convert<String>(json['fileDir']);
  if (fileDir != null) {
    uploadSignModel.fileDir = fileDir;
  }
  final String? fileName = jsonConvert.convert<String>(json['fileName']);
  if (fileName != null) {
    uploadSignModel.fileName = fileName;
  }
  final String? host = jsonConvert.convert<String>(json['host']);
  if (host != null) {
    uploadSignModel.host = host;
  }
  final String? expire = jsonConvert.convert<String>(json['expire']);
  if (expire != null) {
    uploadSignModel.expire = expire;
  }
  return uploadSignModel;
}

Map<String, dynamic> $UploadSignModelToJson(UploadSignModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['accessKeyId'] = entity.accessKeyId;
  data['policy'] = entity.policy;
  data['signature'] = entity.signature;
  data['fileDir'] = entity.fileDir;
  data['fileName'] = entity.fileName;
  data['host'] = entity.host;
  data['expire'] = entity.expire;
  return data;
}

extension UploadSignModelExtension on UploadSignModel {
  UploadSignModel copyWith({
    String? accessKeyId,
    String? policy,
    String? signature,
    String? fileDir,
    String? fileName,
    String? host,
    String? expire,
  }) {
    return UploadSignModel()
      ..accessKeyId = accessKeyId ?? this.accessKeyId
      ..policy = policy ?? this.policy
      ..signature = signature ?? this.signature
      ..fileDir = fileDir ?? this.fileDir
      ..fileName = fileName ?? this.fileName
      ..host = host ?? this.host
      ..expire = expire ?? this.expire;
  }
}
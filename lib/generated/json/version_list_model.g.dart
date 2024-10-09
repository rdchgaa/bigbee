import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/common/version_list_model.dart';

VersionListModel $VersionListModelFromJson(Map<String, dynamic> json) {
  final VersionListModel versionListModel = VersionListModel();
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    versionListModel.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    versionListModel.updateTime = updateTime;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    versionListModel.remark = remark;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    versionListModel.id = id;
  }
  final String? versionNum = jsonConvert.convert<String>(json['versionNum']);
  if (versionNum != null) {
    versionListModel.versionNum = versionNum;
  }
  final int? osVersion = jsonConvert.convert<int>(json['osVersion']);
  if (osVersion != null) {
    versionListModel.osVersion = osVersion;
  }
  final int? isForceUpdates = jsonConvert.convert<int>(json['isForceUpdates']);
  if (isForceUpdates != null) {
    versionListModel.isForceUpdates = isForceUpdates;
  }
  final String? languageMsgCn = jsonConvert.convert<String>(json['languageMsgCn']);
  if (languageMsgCn != null) {
    versionListModel.languageMsgCn = languageMsgCn;
  }
  final String? languageMsgUs = jsonConvert.convert<String>(json['languageMsgUs']);
  if (languageMsgUs != null) {
    versionListModel.languageMsgUs = languageMsgUs;
  }
  final String? downloadAddr = jsonConvert.convert<String>(json['downloadAddr']);
  if (downloadAddr != null) {
    versionListModel.downloadAddr = downloadAddr;
  }
  return versionListModel;
}

Map<String, dynamic> $VersionListModelToJson(VersionListModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createTime'] = entity.createTime;
  data['updateTime'] = entity.updateTime;
  data['remark'] = entity.remark;
  data['id'] = entity.id;
  data['versionNum'] = entity.versionNum;
  data['osVersion'] = entity.osVersion;
  data['isForceUpdates'] = entity.isForceUpdates;
  data['languageMsgCn'] = entity.languageMsgCn;
  data['languageMsgUs'] = entity.languageMsgUs;
  data['downloadAddr'] = entity.downloadAddr;
  return data;
}

extension VersionListModelExtension on VersionListModel {
  VersionListModel copyWith({
    String? createTime,
    String? updateTime,
    String? remark,
    int? id,
    String? versionNum,
    int? osVersion,
    int? isForceUpdates,
    String? languageMsgCn,
    String? languageMsgUs,
    String? downloadAddr,
  }) {
    return VersionListModel()
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..remark = remark ?? this.remark
      ..id = id ?? this.id
      ..versionNum = versionNum ?? this.versionNum
      ..osVersion = osVersion ?? this.osVersion
      ..isForceUpdates = isForceUpdates ?? this.isForceUpdates
      ..languageMsgCn = languageMsgCn ?? this.languageMsgCn
      ..languageMsgUs = languageMsgUs ?? this.languageMsgUs
      ..downloadAddr = downloadAddr ?? this.downloadAddr;
  }
}
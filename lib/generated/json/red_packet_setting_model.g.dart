import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/red_bag/red_packet_setting_model.dart';

RedPacketSettingModel $RedPacketSettingModelFromJson(Map<String, dynamic> json) {
  final RedPacketSettingModel redPacketSettingModel = RedPacketSettingModel();
  final dynamic createBy = json['createBy'];
  if (createBy != null) {
    redPacketSettingModel.createBy = createBy;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    redPacketSettingModel.createTime = createTime;
  }
  final dynamic updateBy = json['updateBy'];
  if (updateBy != null) {
    redPacketSettingModel.updateBy = updateBy;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    redPacketSettingModel.updateTime = updateTime;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    redPacketSettingModel.remark = remark;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    redPacketSettingModel.id = id;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    redPacketSettingModel.type = type;
  }
  final int? level = jsonConvert.convert<int>(json['level']);
  if (level != null) {
    redPacketSettingModel.level = level;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    redPacketSettingModel.status = status;
  }
  final int? coinId = jsonConvert.convert<int>(json['coinId']);
  if (coinId != null) {
    redPacketSettingModel.coinId = coinId;
  }
  final double? max = jsonConvert.convert<double>(json['max']);
  if (max != null) {
    redPacketSettingModel.max = max;
  }
  final double? min = jsonConvert.convert<double>(json['min']);
  if (min != null) {
    redPacketSettingModel.min = min;
  }
  return redPacketSettingModel;
}

Map<String, dynamic> $RedPacketSettingModelToJson(RedPacketSettingModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createBy'] = entity.createBy;
  data['createTime'] = entity.createTime;
  data['updateBy'] = entity.updateBy;
  data['updateTime'] = entity.updateTime;
  data['remark'] = entity.remark;
  data['id'] = entity.id;
  data['type'] = entity.type;
  data['level'] = entity.level;
  data['status'] = entity.status;
  data['coinId'] = entity.coinId;
  data['max'] = entity.max;
  data['min'] = entity.min;
  return data;
}

extension RedPacketSettingModelExtension on RedPacketSettingModel {
  RedPacketSettingModel copyWith({
    dynamic createBy,
    String? createTime,
    dynamic updateBy,
    String? updateTime,
    dynamic remark,
    int? id,
    int? type,
    int? level,
    int? status,
    int? coinId,
    double? max,
    double? min,
  }) {
    return RedPacketSettingModel()
      ..createBy = createBy ?? this.createBy
      ..createTime = createTime ?? this.createTime
      ..updateBy = updateBy ?? this.updateBy
      ..updateTime = updateTime ?? this.updateTime
      ..remark = remark ?? this.remark
      ..id = id ?? this.id
      ..type = type ?? this.type
      ..level = level ?? this.level
      ..status = status ?? this.status
      ..coinId = coinId ?? this.coinId
      ..max = max ?? this.max
      ..min = min ?? this.min;
  }
}
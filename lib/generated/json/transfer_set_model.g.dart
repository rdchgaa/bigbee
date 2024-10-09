import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/transfer_set_model.dart';

TransferSetModel $TransferSetModelFromJson(Map<String, dynamic> json) {
  final TransferSetModel transferSetModel = TransferSetModel();
  final dynamic createBy = json['createBy'];
  if (createBy != null) {
    transferSetModel.createBy = createBy;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    transferSetModel.createTime = createTime;
  }
  final dynamic updateBy = json['updateBy'];
  if (updateBy != null) {
    transferSetModel.updateBy = updateBy;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    transferSetModel.updateTime = updateTime;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    transferSetModel.remark = remark;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    transferSetModel.id = id;
  }
  final int? coinId = jsonConvert.convert<int>(json['coinId']);
  if (coinId != null) {
    transferSetModel.coinId = coinId;
  }
  final double? transferFeeRatio = jsonConvert.convert<double>(json['transferFeeRatio']);
  if (transferFeeRatio != null) {
    transferSetModel.transferFeeRatio = transferFeeRatio;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    transferSetModel.status = status;
  }
  return transferSetModel;
}

Map<String, dynamic> $TransferSetModelToJson(TransferSetModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createBy'] = entity.createBy;
  data['createTime'] = entity.createTime;
  data['updateBy'] = entity.updateBy;
  data['updateTime'] = entity.updateTime;
  data['remark'] = entity.remark;
  data['id'] = entity.id;
  data['coinId'] = entity.coinId;
  data['transferFeeRatio'] = entity.transferFeeRatio;
  data['status'] = entity.status;
  return data;
}

extension TransferSetModelExtension on TransferSetModel {
  TransferSetModel copyWith({
    dynamic createBy,
    String? createTime,
    dynamic updateBy,
    String? updateTime,
    dynamic remark,
    int? id,
    int? coinId,
    double? transferFeeRatio,
    int? status,
  }) {
    return TransferSetModel()
      ..createBy = createBy ?? this.createBy
      ..createTime = createTime ?? this.createTime
      ..updateBy = updateBy ?? this.updateBy
      ..updateTime = updateTime ?? this.updateTime
      ..remark = remark ?? this.remark
      ..id = id ?? this.id
      ..coinId = coinId ?? this.coinId
      ..transferFeeRatio = transferFeeRatio ?? this.transferFeeRatio
      ..status = status ?? this.status;
  }
}
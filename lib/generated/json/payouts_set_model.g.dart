import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/payouts_set_model.dart';

PayoutsSetModel $PayoutsSetModelFromJson(Map<String, dynamic> json) {
  final PayoutsSetModel payoutsSetModel = PayoutsSetModel();
  final dynamic createBy = json['createBy'];
  if (createBy != null) {
    payoutsSetModel.createBy = createBy;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    payoutsSetModel.createTime = createTime;
  }
  final dynamic updateBy = json['updateBy'];
  if (updateBy != null) {
    payoutsSetModel.updateBy = updateBy;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    payoutsSetModel.updateTime = updateTime;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    payoutsSetModel.remark = remark;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    payoutsSetModel.id = id;
  }
  final int? coinId = jsonConvert.convert<int>(json['coinId']);
  if (coinId != null) {
    payoutsSetModel.coinId = coinId;
  }
  final double? minQty = jsonConvert.convert<double>(json['minQty']);
  if (minQty != null) {
    payoutsSetModel.minQty = minQty;
  }
  final double? maxQty = jsonConvert.convert<double>(json['maxQty']);
  if (maxQty != null) {
    payoutsSetModel.maxQty = maxQty;
  }
  final double? quotaQty = jsonConvert.convert<double>(json['quotaQty']);
  if (quotaQty != null) {
    payoutsSetModel.quotaQty = quotaQty;
  }
  final double? feeRatio = jsonConvert.convert<double>(json['feeRatio']);
  if (feeRatio != null) {
    payoutsSetModel.feeRatio = feeRatio;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    payoutsSetModel.status = status;
  }
  return payoutsSetModel;
}

Map<String, dynamic> $PayoutsSetModelToJson(PayoutsSetModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createBy'] = entity.createBy;
  data['createTime'] = entity.createTime;
  data['updateBy'] = entity.updateBy;
  data['updateTime'] = entity.updateTime;
  data['remark'] = entity.remark;
  data['id'] = entity.id;
  data['coinId'] = entity.coinId;
  data['minQty'] = entity.minQty;
  data['maxQty'] = entity.maxQty;
  data['quotaQty'] = entity.quotaQty;
  data['feeRatio'] = entity.feeRatio;
  data['status'] = entity.status;
  return data;
}

extension PayoutsSetModelExtension on PayoutsSetModel {
  PayoutsSetModel copyWith({
    dynamic createBy,
    String? createTime,
    dynamic updateBy,
    String? updateTime,
    dynamic remark,
    int? id,
    int? coinId,
    double? minQty,
    double? maxQty,
    double? quotaQty,
    double? feeRatio,
    int? status,
  }) {
    return PayoutsSetModel()
      ..createBy = createBy ?? this.createBy
      ..createTime = createTime ?? this.createTime
      ..updateBy = updateBy ?? this.updateBy
      ..updateTime = updateTime ?? this.updateTime
      ..remark = remark ?? this.remark
      ..id = id ?? this.id
      ..coinId = coinId ?? this.coinId
      ..minQty = minQty ?? this.minQty
      ..maxQty = maxQty ?? this.maxQty
      ..quotaQty = quotaQty ?? this.quotaQty
      ..feeRatio = feeRatio ?? this.feeRatio
      ..status = status ?? this.status;
  }
}
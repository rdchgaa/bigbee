import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/recharge_records_model.dart';

RechargeRecordsModel $RechargeRecordsModelFromJson(Map<String, dynamic> json) {
  final RechargeRecordsModel rechargeRecordsModel = RechargeRecordsModel();
  final List<RechargeRecordsRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<RechargeRecordsRecords>(e) as RechargeRecordsRecords).toList();
  if (records != null) {
    rechargeRecordsModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    rechargeRecordsModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    rechargeRecordsModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    rechargeRecordsModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    rechargeRecordsModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    rechargeRecordsModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    rechargeRecordsModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    rechargeRecordsModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    rechargeRecordsModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    rechargeRecordsModel.pages = pages;
  }
  return rechargeRecordsModel;
}

Map<String, dynamic> $RechargeRecordsModelToJson(RechargeRecordsModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['records'] = entity.records.map((v) => v.toJson()).toList();
  data['total'] = entity.total;
  data['size'] = entity.size;
  data['current'] = entity.current;
  data['orders'] = entity.orders;
  data['optimizeCountSql'] = entity.optimizeCountSql;
  data['searchCount'] = entity.searchCount;
  data['countId'] = entity.countId;
  data['maxLimit'] = entity.maxLimit;
  data['pages'] = entity.pages;
  return data;
}

extension RechargeRecordsModelExtension on RechargeRecordsModel {
  RechargeRecordsModel copyWith({
    List<RechargeRecordsRecords>? records,
    int? total,
    int? size,
    int? current,
    List<dynamic>? orders,
    bool? optimizeCountSql,
    bool? searchCount,
    dynamic countId,
    dynamic maxLimit,
    int? pages,
  }) {
    return RechargeRecordsModel()
      ..records = records ?? this.records
      ..total = total ?? this.total
      ..size = size ?? this.size
      ..current = current ?? this.current
      ..orders = orders ?? this.orders
      ..optimizeCountSql = optimizeCountSql ?? this.optimizeCountSql
      ..searchCount = searchCount ?? this.searchCount
      ..countId = countId ?? this.countId
      ..maxLimit = maxLimit ?? this.maxLimit
      ..pages = pages ?? this.pages;
  }
}

RechargeRecordsRecords $RechargeRecordsRecordsFromJson(Map<String, dynamic> json) {
  final RechargeRecordsRecords rechargeRecordsRecords = RechargeRecordsRecords();
  final int? memberRechargeId = jsonConvert.convert<int>(json['memberRechargeId']);
  if (memberRechargeId != null) {
    rechargeRecordsRecords.memberRechargeId = memberRechargeId;
  }
  final String? coinName = jsonConvert.convert<String>(json['coinName']);
  if (coinName != null) {
    rechargeRecordsRecords.coinName = coinName;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    rechargeRecordsRecords.status = status;
  }
  final String? rechargeAmount = jsonConvert.convert<String>(json['rechargeAmount']);
  if (rechargeAmount != null) {
    rechargeRecordsRecords.rechargeAmount = rechargeAmount;
  }
  final String? arrivedAmount = jsonConvert.convert<String>(json['arrivedAmount']);
  if (arrivedAmount != null) {
    rechargeRecordsRecords.arrivedAmount = arrivedAmount;
  }
  final String? rechargeTime = jsonConvert.convert<String>(json['rechargeTime']);
  if (rechargeTime != null) {
    rechargeRecordsRecords.rechargeTime = rechargeTime;
  }
  final String? payAmount = jsonConvert.convert<String>(json['payAmount']);
  if (payAmount != null) {
    rechargeRecordsRecords.payAmount = payAmount;
  }
  return rechargeRecordsRecords;
}

Map<String, dynamic> $RechargeRecordsRecordsToJson(RechargeRecordsRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['memberRechargeId'] = entity.memberRechargeId;
  data['coinName'] = entity.coinName;
  data['status'] = entity.status;
  data['rechargeAmount'] = entity.rechargeAmount;
  data['arrivedAmount'] = entity.arrivedAmount;
  data['rechargeTime'] = entity.rechargeTime;
  data['payAmount'] = entity.payAmount;
  return data;
}

extension RechargeRecordsRecordsExtension on RechargeRecordsRecords {
  RechargeRecordsRecords copyWith({
    int? memberRechargeId,
    String? coinName,
    int? status,
    String? rechargeAmount,
    String? arrivedAmount,
    String? rechargeTime,
    String? payAmount,
  }) {
    return RechargeRecordsRecords()
      ..memberRechargeId = memberRechargeId ?? this.memberRechargeId
      ..coinName = coinName ?? this.coinName
      ..status = status ?? this.status
      ..rechargeAmount = rechargeAmount ?? this.rechargeAmount
      ..arrivedAmount = arrivedAmount ?? this.arrivedAmount
      ..rechargeTime = rechargeTime ?? this.rechargeTime
      ..payAmount = payAmount ?? this.payAmount;
  }
}
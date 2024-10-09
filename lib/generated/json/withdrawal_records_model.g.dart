import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/withdrawal_records_model.dart';

WithdrawalRecordsModel $WithdrawalRecordsModelFromJson(Map<String, dynamic> json) {
  final WithdrawalRecordsModel withdrawalRecordsModel = WithdrawalRecordsModel();
  final List<WithdrawalRecordsRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<WithdrawalRecordsRecords>(e) as WithdrawalRecordsRecords).toList();
  if (records != null) {
    withdrawalRecordsModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    withdrawalRecordsModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    withdrawalRecordsModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    withdrawalRecordsModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    withdrawalRecordsModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    withdrawalRecordsModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    withdrawalRecordsModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    withdrawalRecordsModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    withdrawalRecordsModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    withdrawalRecordsModel.pages = pages;
  }
  return withdrawalRecordsModel;
}

Map<String, dynamic> $WithdrawalRecordsModelToJson(WithdrawalRecordsModel entity) {
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

extension WithdrawalRecordsModelExtension on WithdrawalRecordsModel {
  WithdrawalRecordsModel copyWith({
    List<WithdrawalRecordsRecords>? records,
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
    return WithdrawalRecordsModel()
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

WithdrawalRecordsRecords $WithdrawalRecordsRecordsFromJson(Map<String, dynamic> json) {
  final WithdrawalRecordsRecords withdrawalRecordsRecords = WithdrawalRecordsRecords();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    withdrawalRecordsRecords.id = id;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    withdrawalRecordsRecords.status = status;
  }
  final int? coinId = jsonConvert.convert<int>(json['coinId']);
  if (coinId != null) {
    withdrawalRecordsRecords.coinId = coinId;
  }
  final String? coinName = jsonConvert.convert<String>(json['coinName']);
  if (coinName != null) {
    withdrawalRecordsRecords.coinName = coinName;
  }
  final double? applyQty = jsonConvert.convert<double>(json['applyQty']);
  if (applyQty != null) {
    withdrawalRecordsRecords.applyQty = applyQty;
  }
  final double? toQty = jsonConvert.convert<double>(json['toQty']);
  if (toQty != null) {
    withdrawalRecordsRecords.toQty = toQty;
  }
  final double? fees = jsonConvert.convert<double>(json['fees']);
  if (fees != null) {
    withdrawalRecordsRecords.fees = fees;
  }
  final String? toAddress = jsonConvert.convert<String>(json['toAddress']);
  if (toAddress != null) {
    withdrawalRecordsRecords.toAddress = toAddress;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    withdrawalRecordsRecords.createTime = createTime;
  }
  return withdrawalRecordsRecords;
}

Map<String, dynamic> $WithdrawalRecordsRecordsToJson(WithdrawalRecordsRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['status'] = entity.status;
  data['coinId'] = entity.coinId;
  data['coinName'] = entity.coinName;
  data['applyQty'] = entity.applyQty;
  data['toQty'] = entity.toQty;
  data['fees'] = entity.fees;
  data['toAddress'] = entity.toAddress;
  data['createTime'] = entity.createTime;
  return data;
}

extension WithdrawalRecordsRecordsExtension on WithdrawalRecordsRecords {
  WithdrawalRecordsRecords copyWith({
    int? id,
    int? status,
    int? coinId,
    String? coinName,
    double? applyQty,
    double? toQty,
    double? fees,
    String? toAddress,
    String? createTime,
  }) {
    return WithdrawalRecordsRecords()
      ..id = id ?? this.id
      ..status = status ?? this.status
      ..coinId = coinId ?? this.coinId
      ..coinName = coinName ?? this.coinName
      ..applyQty = applyQty ?? this.applyQty
      ..toQty = toQty ?? this.toQty
      ..fees = fees ?? this.fees
      ..toAddress = toAddress ?? this.toAddress
      ..createTime = createTime ?? this.createTime;
  }
}
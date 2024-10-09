import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/funds_details_record_model.dart';

FundsDetailsRecordModel $FundsDetailsRecordModelFromJson(Map<String, dynamic> json) {
  final FundsDetailsRecordModel fundsDetailsRecordModel = FundsDetailsRecordModel();
  final List<FundsDetailsRecordRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<FundsDetailsRecordRecords>(e) as FundsDetailsRecordRecords).toList();
  if (records != null) {
    fundsDetailsRecordModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    fundsDetailsRecordModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    fundsDetailsRecordModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    fundsDetailsRecordModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    fundsDetailsRecordModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    fundsDetailsRecordModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    fundsDetailsRecordModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    fundsDetailsRecordModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    fundsDetailsRecordModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    fundsDetailsRecordModel.pages = pages;
  }
  return fundsDetailsRecordModel;
}

Map<String, dynamic> $FundsDetailsRecordModelToJson(FundsDetailsRecordModel entity) {
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

extension FundsDetailsRecordModelExtension on FundsDetailsRecordModel {
  FundsDetailsRecordModel copyWith({
    List<FundsDetailsRecordRecords>? records,
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
    return FundsDetailsRecordModel()
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

FundsDetailsRecordRecords $FundsDetailsRecordRecordsFromJson(Map<String, dynamic> json) {
  final FundsDetailsRecordRecords fundsDetailsRecordRecords = FundsDetailsRecordRecords();
  final int? flowType = jsonConvert.convert<int>(json['flowType']);
  if (flowType != null) {
    fundsDetailsRecordRecords.flowType = flowType;
  }
  final int? coinId = jsonConvert.convert<int>(json['coinId']);
  if (coinId != null) {
    fundsDetailsRecordRecords.coinId = coinId;
  }
  final String? coinName = jsonConvert.convert<String>(json['coinName']);
  if (coinName != null) {
    fundsDetailsRecordRecords.coinName = coinName;
  }
  final double? amount = jsonConvert.convert<double>(json['amount']);
  if (amount != null) {
    fundsDetailsRecordRecords.amount = amount;
  }
  final String? operationDir = jsonConvert.convert<String>(json['operationDir']);
  if (operationDir != null) {
    fundsDetailsRecordRecords.operationDir = operationDir;
  }
  final String? time = jsonConvert.convert<String>(json['time']);
  if (time != null) {
    fundsDetailsRecordRecords.time = time;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    fundsDetailsRecordRecords.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    fundsDetailsRecordRecords.avatarUrl = avatarUrl;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    fundsDetailsRecordRecords.status = status;
  }
  final double? refundQty = jsonConvert.convert<double>(json['refundQty']);
  if (refundQty != null) {
    fundsDetailsRecordRecords.refundQty = refundQty;
  }
  return fundsDetailsRecordRecords;
}

Map<String, dynamic> $FundsDetailsRecordRecordsToJson(FundsDetailsRecordRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['flowType'] = entity.flowType;
  data['coinId'] = entity.coinId;
  data['coinName'] = entity.coinName;
  data['amount'] = entity.amount;
  data['operationDir'] = entity.operationDir;
  data['time'] = entity.time;
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['status'] = entity.status;
  data['refundQty'] = entity.refundQty;
  return data;
}

extension FundsDetailsRecordRecordsExtension on FundsDetailsRecordRecords {
  FundsDetailsRecordRecords copyWith({
    int? flowType,
    int? coinId,
    String? coinName,
    double? amount,
    String? operationDir,
    String? time,
    String? nickName,
    String? avatarUrl,
    int? status,
    double? refundQty,
  }) {
    return FundsDetailsRecordRecords()
      ..flowType = flowType ?? this.flowType
      ..coinId = coinId ?? this.coinId
      ..coinName = coinName ?? this.coinName
      ..amount = amount ?? this.amount
      ..operationDir = operationDir ?? this.operationDir
      ..time = time ?? this.time
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..status = status ?? this.status
      ..refundQty = refundQty ?? this.refundQty;
  }
}
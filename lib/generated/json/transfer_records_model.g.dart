import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/transfer_records_model.dart';

TransferRecordsModel $TransferRecordsModelFromJson(Map<String, dynamic> json) {
  final TransferRecordsModel transferRecordsModel = TransferRecordsModel();
  final List<TransferRecordsRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<TransferRecordsRecords>(e) as TransferRecordsRecords).toList();
  if (records != null) {
    transferRecordsModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    transferRecordsModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    transferRecordsModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    transferRecordsModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    transferRecordsModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    transferRecordsModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    transferRecordsModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    transferRecordsModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    transferRecordsModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    transferRecordsModel.pages = pages;
  }
  return transferRecordsModel;
}

Map<String, dynamic> $TransferRecordsModelToJson(TransferRecordsModel entity) {
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

extension TransferRecordsModelExtension on TransferRecordsModel {
  TransferRecordsModel copyWith({
    List<TransferRecordsRecords>? records,
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
    return TransferRecordsModel()
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

TransferRecordsRecords $TransferRecordsRecordsFromJson(Map<String, dynamic> json) {
  final TransferRecordsRecords transferRecordsRecords = TransferRecordsRecords();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    transferRecordsRecords.id = id;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    transferRecordsRecords.status = status;
  }
  final int? coinId = jsonConvert.convert<int>(json['coinId']);
  if (coinId != null) {
    transferRecordsRecords.coinId = coinId;
  }
  final String? toAddress = jsonConvert.convert<String>(json['toAddress']);
  if (toAddress != null) {
    transferRecordsRecords.toAddress = toAddress;
  }
  final double? qty = jsonConvert.convert<double>(json['qty']);
  if (qty != null) {
    transferRecordsRecords.qty = qty;
  }
  final double? toQty = jsonConvert.convert<double>(json['toQty']);
  if (toQty != null) {
    transferRecordsRecords.toQty = toQty;
  }
  final double? txFee = jsonConvert.convert<double>(json['txFee']);
  if (txFee != null) {
    transferRecordsRecords.txFee = txFee;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    transferRecordsRecords.createTime = createTime;
  }
  final String? coinName = jsonConvert.convert<String>(json['coinName']);
  if (coinName != null) {
    transferRecordsRecords.coinName = coinName;
  }
  final String? toMemberName = jsonConvert.convert<String>(json['toMemberName']);
  if (toMemberName != null) {
    transferRecordsRecords.toMemberName = toMemberName;
  }
  return transferRecordsRecords;
}

Map<String, dynamic> $TransferRecordsRecordsToJson(TransferRecordsRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['status'] = entity.status;
  data['coinId'] = entity.coinId;
  data['toAddress'] = entity.toAddress;
  data['qty'] = entity.qty;
  data['toQty'] = entity.toQty;
  data['txFee'] = entity.txFee;
  data['createTime'] = entity.createTime;
  data['coinName'] = entity.coinName;
  data['toMemberName'] = entity.toMemberName;
  return data;
}

extension TransferRecordsRecordsExtension on TransferRecordsRecords {
  TransferRecordsRecords copyWith({
    int? id,
    int? status,
    int? coinId,
    String? toAddress,
    double? qty,
    double? toQty,
    double? txFee,
    String? createTime,
    String? coinName,
    String? toMemberName,
  }) {
    return TransferRecordsRecords()
      ..id = id ?? this.id
      ..status = status ?? this.status
      ..coinId = coinId ?? this.coinId
      ..toAddress = toAddress ?? this.toAddress
      ..qty = qty ?? this.qty
      ..toQty = toQty ?? this.toQty
      ..txFee = txFee ?? this.txFee
      ..createTime = createTime ?? this.createTime
      ..coinName = coinName ?? this.coinName
      ..toMemberName = toMemberName ?? this.toMemberName;
  }
}
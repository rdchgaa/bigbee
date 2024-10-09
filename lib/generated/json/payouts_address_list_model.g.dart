import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/payouts_address_list_model.dart';

PayoutsAddressListModel $PayoutsAddressListModelFromJson(Map<String, dynamic> json) {
  final PayoutsAddressListModel payoutsAddressListModel = PayoutsAddressListModel();
  final List<PayoutsAddressListRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<PayoutsAddressListRecords>(e) as PayoutsAddressListRecords).toList();
  if (records != null) {
    payoutsAddressListModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    payoutsAddressListModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    payoutsAddressListModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    payoutsAddressListModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    payoutsAddressListModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    payoutsAddressListModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    payoutsAddressListModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    payoutsAddressListModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    payoutsAddressListModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    payoutsAddressListModel.pages = pages;
  }
  return payoutsAddressListModel;
}

Map<String, dynamic> $PayoutsAddressListModelToJson(PayoutsAddressListModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['records'] = entity.records?.map((v) => v.toJson()).toList();
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

extension PayoutsAddressListModelExtension on PayoutsAddressListModel {
  PayoutsAddressListModel copyWith({
    List<PayoutsAddressListRecords>? records,
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
    return PayoutsAddressListModel()
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

PayoutsAddressListRecords $PayoutsAddressListRecordsFromJson(Map<String, dynamic> json) {
  final PayoutsAddressListRecords payoutsAddressListRecords = PayoutsAddressListRecords();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    payoutsAddressListRecords.id = id;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    payoutsAddressListRecords.address = address;
  }
  final String? addressRemark = jsonConvert.convert<String>(json['addressRemark']);
  if (addressRemark != null) {
    payoutsAddressListRecords.addressRemark = addressRemark;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    payoutsAddressListRecords.createTime = createTime;
  }
  return payoutsAddressListRecords;
}

Map<String, dynamic> $PayoutsAddressListRecordsToJson(PayoutsAddressListRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['address'] = entity.address;
  data['addressRemark'] = entity.addressRemark;
  data['createTime'] = entity.createTime;
  return data;
}

extension PayoutsAddressListRecordsExtension on PayoutsAddressListRecords {
  PayoutsAddressListRecords copyWith({
    int? id,
    String? address,
    String? addressRemark,
    String? createTime,
  }) {
    return PayoutsAddressListRecords()
      ..id = id ?? this.id
      ..address = address ?? this.address
      ..addressRemark = addressRemark ?? this.addressRemark
      ..createTime = createTime ?? this.createTime;
  }
}
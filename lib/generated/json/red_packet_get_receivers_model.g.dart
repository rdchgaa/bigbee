import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/red_bag/red_packet_get_receivers_model.dart';

RedPacketGetReceiversModel $RedPacketGetReceiversModelFromJson(Map<String, dynamic> json) {
  final RedPacketGetReceiversModel redPacketGetReceiversModel = RedPacketGetReceiversModel();
  final List<RedPacketGetReceiversRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<RedPacketGetReceiversRecords>(e) as RedPacketGetReceiversRecords).toList();
  if (records != null) {
    redPacketGetReceiversModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    redPacketGetReceiversModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    redPacketGetReceiversModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    redPacketGetReceiversModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    redPacketGetReceiversModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    redPacketGetReceiversModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    redPacketGetReceiversModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    redPacketGetReceiversModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    redPacketGetReceiversModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    redPacketGetReceiversModel.pages = pages;
  }
  return redPacketGetReceiversModel;
}

Map<String, dynamic> $RedPacketGetReceiversModelToJson(RedPacketGetReceiversModel entity) {
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

extension RedPacketGetReceiversModelExtension on RedPacketGetReceiversModel {
  RedPacketGetReceiversModel copyWith({
    List<RedPacketGetReceiversRecords>? records,
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
    return RedPacketGetReceiversModel()
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

RedPacketGetReceiversRecords $RedPacketGetReceiversRecordsFromJson(Map<String, dynamic> json) {
  final RedPacketGetReceiversRecords redPacketGetReceiversRecords = RedPacketGetReceiversRecords();
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    redPacketGetReceiversRecords.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    redPacketGetReceiversRecords.avatarUrl = avatarUrl;
  }
  final String? qty = jsonConvert.convert<String>(json['qty']);
  if (qty != null) {
    redPacketGetReceiversRecords.qty = qty;
  }
  final dynamic coinName = json['coinName'];
  if (coinName != null) {
    redPacketGetReceiversRecords.coinName = coinName;
  }
  final String? receiveTime = jsonConvert.convert<String>(json['receiveTime']);
  if (receiveTime != null) {
    redPacketGetReceiversRecords.receiveTime = receiveTime;
  }
  return redPacketGetReceiversRecords;
}

Map<String, dynamic> $RedPacketGetReceiversRecordsToJson(RedPacketGetReceiversRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['qty'] = entity.qty;
  data['coinName'] = entity.coinName;
  data['receiveTime'] = entity.receiveTime;
  return data;
}

extension RedPacketGetReceiversRecordsExtension on RedPacketGetReceiversRecords {
  RedPacketGetReceiversRecords copyWith({
    String? nickName,
    String? avatarUrl,
    String? qty,
    dynamic coinName,
    String? receiveTime,
  }) {
    return RedPacketGetReceiversRecords()
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..qty = qty ?? this.qty
      ..coinName = coinName ?? this.coinName
      ..receiveTime = receiveTime ?? this.receiveTime;
  }
}
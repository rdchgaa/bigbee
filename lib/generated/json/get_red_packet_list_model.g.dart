import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_list_model.dart';

GetRedPacketListModel $GetRedPacketListModelFromJson(Map<String, dynamic> json) {
  final GetRedPacketListModel getRedPacketListModel = GetRedPacketListModel();
  final List<GetRedPacketListRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<GetRedPacketListRecords>(e) as GetRedPacketListRecords).toList();
  if (records != null) {
    getRedPacketListModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    getRedPacketListModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    getRedPacketListModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    getRedPacketListModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    getRedPacketListModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    getRedPacketListModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    getRedPacketListModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    getRedPacketListModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    getRedPacketListModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    getRedPacketListModel.pages = pages;
  }
  return getRedPacketListModel;
}

Map<String, dynamic> $GetRedPacketListModelToJson(GetRedPacketListModel entity) {
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

extension GetRedPacketListModelExtension on GetRedPacketListModel {
  GetRedPacketListModel copyWith({
    List<GetRedPacketListRecords>? records,
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
    return GetRedPacketListModel()
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

GetRedPacketListRecords $GetRedPacketListRecordsFromJson(Map<String, dynamic> json) {
  final GetRedPacketListRecords getRedPacketListRecords = GetRedPacketListRecords();
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    getRedPacketListRecords.nickName = nickName;
  }
  final double? qty = jsonConvert.convert<double>(json['qty']);
  if (qty != null) {
    getRedPacketListRecords.qty = qty;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    getRedPacketListRecords.createTime = createTime;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    getRedPacketListRecords.avatarUrl = avatarUrl;
  }
  final int? level = jsonConvert.convert<int>(json['level']);
  if (level != null) {
    getRedPacketListRecords.level = level;
  }
  return getRedPacketListRecords;
}

Map<String, dynamic> $GetRedPacketListRecordsToJson(GetRedPacketListRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['nickName'] = entity.nickName;
  data['qty'] = entity.qty;
  data['createTime'] = entity.createTime;
  data['avatarUrl'] = entity.avatarUrl;
  data['level'] = entity.level;
  return data;
}

extension GetRedPacketListRecordsExtension on GetRedPacketListRecords {
  GetRedPacketListRecords copyWith({
    String? nickName,
    double? qty,
    String? createTime,
    String? avatarUrl,
    int? level,
  }) {
    return GetRedPacketListRecords()
      ..nickName = nickName ?? this.nickName
      ..qty = qty ?? this.qty
      ..createTime = createTime ?? this.createTime
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..level = level ?? this.level;
  }
}
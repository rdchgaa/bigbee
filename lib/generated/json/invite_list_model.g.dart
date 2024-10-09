import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/user/invite_list_model.dart';

InviteListModel $InviteListModelFromJson(Map<String, dynamic> json) {
  final InviteListModel inviteListModel = InviteListModel();
  final List<InviteListRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<InviteListRecords>(e) as InviteListRecords).toList();
  if (records != null) {
    inviteListModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    inviteListModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    inviteListModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    inviteListModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    inviteListModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    inviteListModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    inviteListModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    inviteListModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    inviteListModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    inviteListModel.pages = pages;
  }
  return inviteListModel;
}

Map<String, dynamic> $InviteListModelToJson(InviteListModel entity) {
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

extension InviteListModelExtension on InviteListModel {
  InviteListModel copyWith({
    List<InviteListRecords>? records,
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
    return InviteListModel()
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

InviteListRecords $InviteListRecordsFromJson(Map<String, dynamic> json) {
  final InviteListRecords inviteListRecords = InviteListRecords();
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    inviteListRecords.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    inviteListRecords.avatarUrl = avatarUrl;
  }
  final String? inviteTime = jsonConvert.convert<String>(json['inviteTime']);
  if (inviteTime != null) {
    inviteListRecords.inviteTime = inviteTime;
  }
  final String? onlineStatus = jsonConvert.convert<String>(json['onlineStatus']);
  if (onlineStatus != null) {
    inviteListRecords.onlineStatus = onlineStatus;
  }
  return inviteListRecords;
}

Map<String, dynamic> $InviteListRecordsToJson(InviteListRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['inviteTime'] = entity.inviteTime;
  data['onlineStatus'] = entity.onlineStatus;
  return data;
}

extension InviteListRecordsExtension on InviteListRecords {
  InviteListRecords copyWith({
    String? nickName,
    String? avatarUrl,
    String? inviteTime,
    String? onlineStatus,
  }) {
    return InviteListRecords()
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..inviteTime = inviteTime ?? this.inviteTime
      ..onlineStatus = onlineStatus ?? this.onlineStatus;
  }
}
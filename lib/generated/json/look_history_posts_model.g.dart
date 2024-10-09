import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/look_history_posts_model.dart';

LookHistoryPostsModel $LookHistoryPostsModelFromJson(Map<String, dynamic> json) {
  final LookHistoryPostsModel lookHistoryPostsModel = LookHistoryPostsModel();
  final List<LookHistoryPostsRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<LookHistoryPostsRecords>(e) as LookHistoryPostsRecords).toList();
  if (records != null) {
    lookHistoryPostsModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    lookHistoryPostsModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    lookHistoryPostsModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    lookHistoryPostsModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    lookHistoryPostsModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    lookHistoryPostsModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    lookHistoryPostsModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    lookHistoryPostsModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    lookHistoryPostsModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    lookHistoryPostsModel.pages = pages;
  }
  return lookHistoryPostsModel;
}

Map<String, dynamic> $LookHistoryPostsModelToJson(LookHistoryPostsModel entity) {
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

extension LookHistoryPostsModelExtension on LookHistoryPostsModel {
  LookHistoryPostsModel copyWith({
    List<LookHistoryPostsRecords>? records,
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
    return LookHistoryPostsModel()
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

LookHistoryPostsRecords $LookHistoryPostsRecordsFromJson(Map<String, dynamic> json) {
  final LookHistoryPostsRecords lookHistoryPostsRecords = LookHistoryPostsRecords();
  final int? postsId = jsonConvert.convert<int>(json['postsId']);
  if (postsId != null) {
    lookHistoryPostsRecords.postsId = postsId;
  }
  final int? trendsType = jsonConvert.convert<int>(json['trendsType']);
  if (trendsType != null) {
    lookHistoryPostsRecords.trendsType = trendsType;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    lookHistoryPostsRecords.avatarUrl = avatarUrl;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    lookHistoryPostsRecords.nickName = nickName;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    lookHistoryPostsRecords.content = content;
  }
  final String? imagesUrl = jsonConvert.convert<String>(json['imagesUrl']);
  if (imagesUrl != null) {
    lookHistoryPostsRecords.imagesUrl = imagesUrl;
  }
  final String? videoUrl = jsonConvert.convert<String>(json['videoUrl']);
  if (videoUrl != null) {
    lookHistoryPostsRecords.videoUrl = videoUrl;
  }
  final String? lookTime = jsonConvert.convert<String>(json['lookTime']);
  if (lookTime != null) {
    lookHistoryPostsRecords.lookTime = lookTime;
  }
  return lookHistoryPostsRecords;
}

Map<String, dynamic> $LookHistoryPostsRecordsToJson(LookHistoryPostsRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['postsId'] = entity.postsId;
  data['trendsType'] = entity.trendsType;
  data['avatarUrl'] = entity.avatarUrl;
  data['nickName'] = entity.nickName;
  data['content'] = entity.content;
  data['imagesUrl'] = entity.imagesUrl;
  data['videoUrl'] = entity.videoUrl;
  data['lookTime'] = entity.lookTime;
  return data;
}

extension LookHistoryPostsRecordsExtension on LookHistoryPostsRecords {
  LookHistoryPostsRecords copyWith({
    int? postsId,
    int? trendsType,
    String? avatarUrl,
    String? nickName,
    String? content,
    String? imagesUrl,
    String? videoUrl,
    String? lookTime,
  }) {
    return LookHistoryPostsRecords()
      ..postsId = postsId ?? this.postsId
      ..trendsType = trendsType ?? this.trendsType
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..nickName = nickName ?? this.nickName
      ..content = content ?? this.content
      ..imagesUrl = imagesUrl ?? this.imagesUrl
      ..videoUrl = videoUrl ?? this.videoUrl
      ..lookTime = lookTime ?? this.lookTime;
  }
}
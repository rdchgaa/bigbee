import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/hot_top_posts_list_model.dart';

HotTopPostsListModel $HotTopPostsListModelFromJson(Map<String, dynamic> json) {
  final HotTopPostsListModel hotTopPostsListModel = HotTopPostsListModel();
  final List<HotTopPostsListRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<HotTopPostsListRecords>(e) as HotTopPostsListRecords).toList();
  if (records != null) {
    hotTopPostsListModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    hotTopPostsListModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    hotTopPostsListModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    hotTopPostsListModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    hotTopPostsListModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    hotTopPostsListModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    hotTopPostsListModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    hotTopPostsListModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    hotTopPostsListModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    hotTopPostsListModel.pages = pages;
  }
  return hotTopPostsListModel;
}

Map<String, dynamic> $HotTopPostsListModelToJson(HotTopPostsListModel entity) {
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

extension HotTopPostsListModelExtension on HotTopPostsListModel {
  HotTopPostsListModel copyWith({
    List<HotTopPostsListRecords>? records,
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
    return HotTopPostsListModel()
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

HotTopPostsListRecords $HotTopPostsListRecordsFromJson(Map<String, dynamic> json) {
  final HotTopPostsListRecords hotTopPostsListRecords = HotTopPostsListRecords();
  final int? postsId = jsonConvert.convert<int>(json['postsId']);
  if (postsId != null) {
    hotTopPostsListRecords.postsId = postsId;
  }
  final String? textContent = jsonConvert.convert<String>(json['textContent']);
  if (textContent != null) {
    hotTopPostsListRecords.textContent = textContent;
  }
  final int? commendCount = jsonConvert.convert<int>(json['commendCount']);
  if (commendCount != null) {
    hotTopPostsListRecords.commendCount = commendCount;
  }
  final int? readCount = jsonConvert.convert<int>(json['readCount']);
  if (readCount != null) {
    hotTopPostsListRecords.readCount = readCount;
  }
  return hotTopPostsListRecords;
}

Map<String, dynamic> $HotTopPostsListRecordsToJson(HotTopPostsListRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['postsId'] = entity.postsId;
  data['textContent'] = entity.textContent;
  data['commendCount'] = entity.commendCount;
  data['readCount'] = entity.readCount;
  return data;
}

extension HotTopPostsListRecordsExtension on HotTopPostsListRecords {
  HotTopPostsListRecords copyWith({
    int? postsId,
    String? textContent,
    int? commendCount,
    int? readCount,
  }) {
    return HotTopPostsListRecords()
      ..postsId = postsId ?? this.postsId
      ..textContent = textContent ?? this.textContent
      ..commendCount = commendCount ?? this.commendCount
      ..readCount = readCount ?? this.readCount;
  }
}
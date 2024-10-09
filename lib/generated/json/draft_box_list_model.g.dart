import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/draft_box_list_model.dart';

DraftBoxListModel $DraftBoxListModelFromJson(Map<String, dynamic> json) {
  final DraftBoxListModel draftBoxListModel = DraftBoxListModel();
  final List<DraftBoxListRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<DraftBoxListRecords>(e) as DraftBoxListRecords).toList();
  if (records != null) {
    draftBoxListModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    draftBoxListModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    draftBoxListModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    draftBoxListModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    draftBoxListModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    draftBoxListModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    draftBoxListModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    draftBoxListModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    draftBoxListModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    draftBoxListModel.pages = pages;
  }
  return draftBoxListModel;
}

Map<String, dynamic> $DraftBoxListModelToJson(DraftBoxListModel entity) {
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

extension DraftBoxListModelExtension on DraftBoxListModel {
  DraftBoxListModel copyWith({
    List<DraftBoxListRecords>? records,
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
    return DraftBoxListModel()
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

DraftBoxListRecords $DraftBoxListRecordsFromJson(Map<String, dynamic> json) {
  final DraftBoxListRecords draftBoxListRecords = DraftBoxListRecords();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    draftBoxListRecords.id = id;
  }
  final int? trendsType = jsonConvert.convert<int>(json['trendsType']);
  if (trendsType != null) {
    draftBoxListRecords.trendsType = trendsType;
  }
  final String? textContent = jsonConvert.convert<String>(json['textContent']);
  if (textContent != null) {
    draftBoxListRecords.textContent = textContent;
  }
  final String? imgeUrls = jsonConvert.convert<String>(json['imgeUrls']);
  if (imgeUrls != null) {
    draftBoxListRecords.imgeUrls = imgeUrls;
  }
  final String? videoUrl = jsonConvert.convert<String>(json['videoUrl']);
  if (videoUrl != null) {
    draftBoxListRecords.videoUrl = videoUrl;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    draftBoxListRecords.createTime = createTime;
  }
  return draftBoxListRecords;
}

Map<String, dynamic> $DraftBoxListRecordsToJson(DraftBoxListRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['trendsType'] = entity.trendsType;
  data['textContent'] = entity.textContent;
  data['imgeUrls'] = entity.imgeUrls;
  data['videoUrl'] = entity.videoUrl;
  data['createTime'] = entity.createTime;
  return data;
}

extension DraftBoxListRecordsExtension on DraftBoxListRecords {
  DraftBoxListRecords copyWith({
    String? id,
    int? trendsType,
    String? textContent,
    String? imgeUrls,
    String? videoUrl,
    String? createTime,
  }) {
    return DraftBoxListRecords()
      ..id = id ?? this.id
      ..trendsType = trendsType ?? this.trendsType
      ..textContent = textContent ?? this.textContent
      ..imgeUrls = imgeUrls ?? this.imgeUrls
      ..videoUrl = videoUrl ?? this.videoUrl
      ..createTime = createTime ?? this.createTime;
  }
}
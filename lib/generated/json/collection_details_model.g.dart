import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/mine/collection_details_model.dart';

CollectionDetailsModel $CollectionDetailsModelFromJson(Map<String, dynamic> json) {
  final CollectionDetailsModel collectionDetailsModel = CollectionDetailsModel();
  final List<CollectionDetailsRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<CollectionDetailsRecords>(e) as CollectionDetailsRecords).toList();
  if (records != null) {
    collectionDetailsModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    collectionDetailsModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    collectionDetailsModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    collectionDetailsModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    collectionDetailsModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    collectionDetailsModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    collectionDetailsModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    collectionDetailsModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    collectionDetailsModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    collectionDetailsModel.pages = pages;
  }
  return collectionDetailsModel;
}

Map<String, dynamic> $CollectionDetailsModelToJson(CollectionDetailsModel entity) {
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

extension CollectionDetailsModelExtension on CollectionDetailsModel {
  CollectionDetailsModel copyWith({
    List<CollectionDetailsRecords>? records,
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
    return CollectionDetailsModel()
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

CollectionDetailsRecords $CollectionDetailsRecordsFromJson(Map<String, dynamic> json) {
  final CollectionDetailsRecords collectionDetailsRecords = CollectionDetailsRecords();
  final dynamic createBy = json['createBy'];
  if (createBy != null) {
    collectionDetailsRecords.createBy = createBy;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    collectionDetailsRecords.createTime = createTime;
  }
  final String? messageTime = jsonConvert.convert<String>(json['messageTime']);
  if (messageTime != null) {
    collectionDetailsRecords.messageTime = messageTime;
  }
  final dynamic updateBy = json['updateBy'];
  if (updateBy != null) {
    collectionDetailsRecords.updateBy = updateBy;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    collectionDetailsRecords.updateTime = updateTime;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    collectionDetailsRecords.remark = remark;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    collectionDetailsRecords.id = id;
  }
  final int? memberId = jsonConvert.convert<int>(json['memberId']);
  if (memberId != null) {
    collectionDetailsRecords.memberId = memberId;
  }
  final int? collectId = jsonConvert.convert<int>(json['collectId']);
  if (collectId != null) {
    collectionDetailsRecords.collectId = collectId;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    collectionDetailsRecords.type = type;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    collectionDetailsRecords.value = value;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    collectionDetailsRecords.nickName = nickName;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    collectionDetailsRecords.avatar = avatar;
  }
  return collectionDetailsRecords;
}

Map<String, dynamic> $CollectionDetailsRecordsToJson(CollectionDetailsRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createBy'] = entity.createBy;
  data['createTime'] = entity.createTime;
  data['messageTime'] = entity.messageTime;
  data['updateBy'] = entity.updateBy;
  data['updateTime'] = entity.updateTime;
  data['remark'] = entity.remark;
  data['id'] = entity.id;
  data['memberId'] = entity.memberId;
  data['collectId'] = entity.collectId;
  data['type'] = entity.type;
  data['value'] = entity.value;
  data['nickName'] = entity.nickName;
  data['avatar'] = entity.avatar;
  return data;
}

extension CollectionDetailsRecordsExtension on CollectionDetailsRecords {
  CollectionDetailsRecords copyWith({
    dynamic createBy,
    String? createTime,
    String? messageTime,
    dynamic updateBy,
    String? updateTime,
    dynamic remark,
    int? id,
    int? memberId,
    int? collectId,
    int? type,
    String? value,
    String? nickName,
    String? avatar,
  }) {
    return CollectionDetailsRecords()
      ..createBy = createBy ?? this.createBy
      ..createTime = createTime ?? this.createTime
      ..messageTime = messageTime ?? this.messageTime
      ..updateBy = updateBy ?? this.updateBy
      ..updateTime = updateTime ?? this.updateTime
      ..remark = remark ?? this.remark
      ..id = id ?? this.id
      ..memberId = memberId ?? this.memberId
      ..collectId = collectId ?? this.collectId
      ..type = type ?? this.type
      ..value = value ?? this.value
      ..nickName = nickName ?? this.nickName
      ..avatar = avatar ?? this.avatar;
  }
}
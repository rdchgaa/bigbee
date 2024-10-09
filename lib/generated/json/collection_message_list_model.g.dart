import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/mine/collection_message_list_model.dart';

CollectionMessageListModel $CollectionMessageListModelFromJson(Map<String, dynamic> json) {
  final CollectionMessageListModel collectionMessageListModel = CollectionMessageListModel();
  final List<CollectionMessageListRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<CollectionMessageListRecords>(e) as CollectionMessageListRecords).toList();
  if (records != null) {
    collectionMessageListModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    collectionMessageListModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    collectionMessageListModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    collectionMessageListModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    collectionMessageListModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    collectionMessageListModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    collectionMessageListModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    collectionMessageListModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    collectionMessageListModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    collectionMessageListModel.pages = pages;
  }
  return collectionMessageListModel;
}

Map<String, dynamic> $CollectionMessageListModelToJson(CollectionMessageListModel entity) {
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

extension CollectionMessageListModelExtension on CollectionMessageListModel {
  CollectionMessageListModel copyWith({
    List<CollectionMessageListRecords>? records,
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
    return CollectionMessageListModel()
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

CollectionMessageListRecords $CollectionMessageListRecordsFromJson(Map<String, dynamic> json) {
  final CollectionMessageListRecords collectionMessageListRecords = CollectionMessageListRecords();
  final String? formNickName = jsonConvert.convert<String>(json['formNickName']);
  if (formNickName != null) {
    collectionMessageListRecords.formNickName = formNickName;
  }
  final String? formAvatar = jsonConvert.convert<String>(json['formAvatar']);
  if (formAvatar != null) {
    collectionMessageListRecords.formAvatar = formAvatar;
  }
  final dynamic groupInfoId = json['groupInfoId'];
  if (groupInfoId != null) {
    collectionMessageListRecords.groupInfoId = groupInfoId;
  }
  final int? collectId = jsonConvert.convert<int>(json['collectId']);
  if (collectId != null) {
    collectionMessageListRecords.collectId = collectId;
  }
  final List<CollectionMessageListRecordsSearchMessageList>? searchMessageList = (json['searchMessageList'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<CollectionMessageListRecordsSearchMessageList>(
          e) as CollectionMessageListRecordsSearchMessageList).toList();
  if (searchMessageList != null) {
    collectionMessageListRecords.searchMessageList = searchMessageList;
  }
  return collectionMessageListRecords;
}

Map<String, dynamic> $CollectionMessageListRecordsToJson(CollectionMessageListRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['formNickName'] = entity.formNickName;
  data['formAvatar'] = entity.formAvatar;
  data['groupInfoId'] = entity.groupInfoId;
  data['collectId'] = entity.collectId;
  data['searchMessageList'] = entity.searchMessageList?.map((v) => v.toJson()).toList();
  return data;
}

extension CollectionMessageListRecordsExtension on CollectionMessageListRecords {
  CollectionMessageListRecords copyWith({
    String? formNickName,
    String? formAvatar,
    dynamic groupInfoId,
    int? collectId,
    List<CollectionMessageListRecordsSearchMessageList>? searchMessageList,
  }) {
    return CollectionMessageListRecords()
      ..formNickName = formNickName ?? this.formNickName
      ..formAvatar = formAvatar ?? this.formAvatar
      ..groupInfoId = groupInfoId ?? this.groupInfoId
      ..collectId = collectId ?? this.collectId
      ..searchMessageList = searchMessageList ?? this.searchMessageList;
  }
}

CollectionMessageListRecordsSearchMessageList $CollectionMessageListRecordsSearchMessageListFromJson(
    Map<String, dynamic> json) {
  final CollectionMessageListRecordsSearchMessageList collectionMessageListRecordsSearchMessageList = CollectionMessageListRecordsSearchMessageList();
  final dynamic createBy = json['createBy'];
  if (createBy != null) {
    collectionMessageListRecordsSearchMessageList.createBy = createBy;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    collectionMessageListRecordsSearchMessageList.createTime = createTime;
  }
  final String? messageTime = jsonConvert.convert<String>(json['messageTime']);
  if (messageTime != null) {
    collectionMessageListRecordsSearchMessageList.messageTime = messageTime;
  }
  final dynamic updateBy = json['updateBy'];
  if (updateBy != null) {
    collectionMessageListRecordsSearchMessageList.updateBy = updateBy;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    collectionMessageListRecordsSearchMessageList.updateTime = updateTime;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    collectionMessageListRecordsSearchMessageList.remark = remark;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    collectionMessageListRecordsSearchMessageList.id = id;
  }
  final int? memberId = jsonConvert.convert<int>(json['memberId']);
  if (memberId != null) {
    collectionMessageListRecordsSearchMessageList.memberId = memberId;
  }
  final int? collectId = jsonConvert.convert<int>(json['collectId']);
  if (collectId != null) {
    collectionMessageListRecordsSearchMessageList.collectId = collectId;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    collectionMessageListRecordsSearchMessageList.type = type;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    collectionMessageListRecordsSearchMessageList.value = value;
  }
  final dynamic nickName = json['nickName'];
  if (nickName != null) {
    collectionMessageListRecordsSearchMessageList.nickName = nickName;
  }
  final dynamic avatar = json['avatar'];
  if (avatar != null) {
    collectionMessageListRecordsSearchMessageList.avatar = avatar;
  }
  return collectionMessageListRecordsSearchMessageList;
}

Map<String, dynamic> $CollectionMessageListRecordsSearchMessageListToJson(
    CollectionMessageListRecordsSearchMessageList entity) {
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

extension CollectionMessageListRecordsSearchMessageListExtension on CollectionMessageListRecordsSearchMessageList {
  CollectionMessageListRecordsSearchMessageList copyWith({
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
    dynamic nickName,
    dynamic avatar,
  }) {
    return CollectionMessageListRecordsSearchMessageList()
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
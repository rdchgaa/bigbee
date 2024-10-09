import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/comments_reply_list_model.dart';

CommentsReplyListModel $CommentsReplyListModelFromJson(Map<String, dynamic> json) {
  final CommentsReplyListModel commentsReplyListModel = CommentsReplyListModel();
  final List<CommentsReplyListRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<CommentsReplyListRecords>(e) as CommentsReplyListRecords).toList();
  if (records != null) {
    commentsReplyListModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    commentsReplyListModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    commentsReplyListModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    commentsReplyListModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    commentsReplyListModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    commentsReplyListModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    commentsReplyListModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    commentsReplyListModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    commentsReplyListModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    commentsReplyListModel.pages = pages;
  }
  return commentsReplyListModel;
}

Map<String, dynamic> $CommentsReplyListModelToJson(CommentsReplyListModel entity) {
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

extension CommentsReplyListModelExtension on CommentsReplyListModel {
  CommentsReplyListModel copyWith({
    List<CommentsReplyListRecords>? records,
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
    return CommentsReplyListModel()
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

CommentsReplyListRecords $CommentsReplyListRecordsFromJson(Map<String, dynamic> json) {
  final CommentsReplyListRecords commentsReplyListRecords = CommentsReplyListRecords();
  final int? replyId = jsonConvert.convert<int>(json['replyId']);
  if (replyId != null) {
    commentsReplyListRecords.replyId = replyId;
  }
  final int? fromMemberId = jsonConvert.convert<int>(json['fromMemberId']);
  if (fromMemberId != null) {
    commentsReplyListRecords.fromMemberId = fromMemberId;
  }
  final String? contentInfo = jsonConvert.convert<String>(json['contentInfo']);
  if (contentInfo != null) {
    commentsReplyListRecords.contentInfo = contentInfo;
  }
  final String? fromMemberNickName = jsonConvert.convert<String>(json['fromMemberNickName']);
  if (fromMemberNickName != null) {
    commentsReplyListRecords.fromMemberNickName = fromMemberNickName;
  }
  final String? toMemberNickName = jsonConvert.convert<String>(json['toMemberNickName']);
  if (toMemberNickName != null) {
    commentsReplyListRecords.toMemberNickName = toMemberNickName;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    commentsReplyListRecords.type = type;
  }
  return commentsReplyListRecords;
}

Map<String, dynamic> $CommentsReplyListRecordsToJson(CommentsReplyListRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['replyId'] = entity.replyId;
  data['fromMemberId'] = entity.fromMemberId;
  data['contentInfo'] = entity.contentInfo;
  data['fromMemberNickName'] = entity.fromMemberNickName;
  data['toMemberNickName'] = entity.toMemberNickName;
  data['type'] = entity.type;
  return data;
}

extension CommentsReplyListRecordsExtension on CommentsReplyListRecords {
  CommentsReplyListRecords copyWith({
    int? replyId,
    int? fromMemberId,
    String? contentInfo,
    String? fromMemberNickName,
    String? toMemberNickName,
    int? type,
  }) {
    return CommentsReplyListRecords()
      ..replyId = replyId ?? this.replyId
      ..fromMemberId = fromMemberId ?? this.fromMemberId
      ..contentInfo = contentInfo ?? this.contentInfo
      ..fromMemberNickName = fromMemberNickName ?? this.fromMemberNickName
      ..toMemberNickName = toMemberNickName ?? this.toMemberNickName
      ..type = type ?? this.type;
  }
}
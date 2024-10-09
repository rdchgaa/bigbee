import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/posts_details_comments_model.dart';

PostsDetailsCommentsModel $PostsDetailsCommentsModelFromJson(Map<String, dynamic> json) {
  final PostsDetailsCommentsModel postsDetailsCommentsModel = PostsDetailsCommentsModel();
  final List<PostsDetailsCommentsRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<PostsDetailsCommentsRecords>(e) as PostsDetailsCommentsRecords).toList();
  if (records != null) {
    postsDetailsCommentsModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    postsDetailsCommentsModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    postsDetailsCommentsModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    postsDetailsCommentsModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    postsDetailsCommentsModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    postsDetailsCommentsModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    postsDetailsCommentsModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    postsDetailsCommentsModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    postsDetailsCommentsModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    postsDetailsCommentsModel.pages = pages;
  }
  return postsDetailsCommentsModel;
}

Map<String, dynamic> $PostsDetailsCommentsModelToJson(PostsDetailsCommentsModel entity) {
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

extension PostsDetailsCommentsModelExtension on PostsDetailsCommentsModel {
  PostsDetailsCommentsModel copyWith({
    List<PostsDetailsCommentsRecords>? records,
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
    return PostsDetailsCommentsModel()
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

PostsDetailsCommentsRecords $PostsDetailsCommentsRecordsFromJson(Map<String, dynamic> json) {
  final PostsDetailsCommentsRecords postsDetailsCommentsRecords = PostsDetailsCommentsRecords();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    postsDetailsCommentsRecords.id = id;
  }
  final int? memberId = jsonConvert.convert<int>(json['memberId']);
  if (memberId != null) {
    postsDetailsCommentsRecords.memberId = memberId;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    postsDetailsCommentsRecords.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    postsDetailsCommentsRecords.avatarUrl = avatarUrl;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    postsDetailsCommentsRecords.content = content;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    postsDetailsCommentsRecords.createTime = createTime;
  }
  final List<PostsDetailsCommentsRecordsCommentsReplyList>? commentsReplyList = (json['commentsReplyList'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<PostsDetailsCommentsRecordsCommentsReplyList>(
          e) as PostsDetailsCommentsRecordsCommentsReplyList).toList();
  if (commentsReplyList != null) {
    postsDetailsCommentsRecords.commentsReplyList = commentsReplyList;
  }
  final bool? isLike = jsonConvert.convert<bool>(json['isLike']);
  if (isLike != null) {
    postsDetailsCommentsRecords.isLike = isLike;
  }
  return postsDetailsCommentsRecords;
}

Map<String, dynamic> $PostsDetailsCommentsRecordsToJson(PostsDetailsCommentsRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['memberId'] = entity.memberId;
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['content'] = entity.content;
  data['createTime'] = entity.createTime;
  data['commentsReplyList'] = entity.commentsReplyList?.map((v) => v.toJson()).toList();
  data['isLike'] = entity.isLike;
  return data;
}

extension PostsDetailsCommentsRecordsExtension on PostsDetailsCommentsRecords {
  PostsDetailsCommentsRecords copyWith({
    int? id,
    int? memberId,
    String? nickName,
    String? avatarUrl,
    String? content,
    String? createTime,
    List<PostsDetailsCommentsRecordsCommentsReplyList>? commentsReplyList,
    bool? isLike,
  }) {
    return PostsDetailsCommentsRecords()
      ..id = id ?? this.id
      ..memberId = memberId ?? this.memberId
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..content = content ?? this.content
      ..createTime = createTime ?? this.createTime
      ..commentsReplyList = commentsReplyList ?? this.commentsReplyList
      ..isLike = isLike ?? this.isLike;
  }
}

PostsDetailsCommentsRecordsCommentsReplyList $PostsDetailsCommentsRecordsCommentsReplyListFromJson(
    Map<String, dynamic> json) {
  final PostsDetailsCommentsRecordsCommentsReplyList postsDetailsCommentsRecordsCommentsReplyList = PostsDetailsCommentsRecordsCommentsReplyList();
  final String? contentInfo = jsonConvert.convert<String>(json['contentInfo']);
  if (contentInfo != null) {
    postsDetailsCommentsRecordsCommentsReplyList.contentInfo = contentInfo;
  }
  final String? fromMemberNickName = jsonConvert.convert<String>(json['fromMemberNickName']);
  if (fromMemberNickName != null) {
    postsDetailsCommentsRecordsCommentsReplyList.fromMemberNickName = fromMemberNickName;
  }
  final dynamic toMemberNickName = json['toMemberNickName'];
  if (toMemberNickName != null) {
    postsDetailsCommentsRecordsCommentsReplyList.toMemberNickName = toMemberNickName;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    postsDetailsCommentsRecordsCommentsReplyList.type = type;
  }
  return postsDetailsCommentsRecordsCommentsReplyList;
}

Map<String, dynamic> $PostsDetailsCommentsRecordsCommentsReplyListToJson(
    PostsDetailsCommentsRecordsCommentsReplyList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['contentInfo'] = entity.contentInfo;
  data['fromMemberNickName'] = entity.fromMemberNickName;
  data['toMemberNickName'] = entity.toMemberNickName;
  data['type'] = entity.type;
  return data;
}

extension PostsDetailsCommentsRecordsCommentsReplyListExtension on PostsDetailsCommentsRecordsCommentsReplyList {
  PostsDetailsCommentsRecordsCommentsReplyList copyWith({
    String? contentInfo,
    String? fromMemberNickName,
    dynamic toMemberNickName,
    int? type,
  }) {
    return PostsDetailsCommentsRecordsCommentsReplyList()
      ..contentInfo = contentInfo ?? this.contentInfo
      ..fromMemberNickName = fromMemberNickName ?? this.fromMemberNickName
      ..toMemberNickName = toMemberNickName ?? this.toMemberNickName
      ..type = type ?? this.type;
  }
}
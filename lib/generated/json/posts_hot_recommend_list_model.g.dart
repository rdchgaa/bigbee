import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';

PostsHotRecommendListModel $PostsHotRecommendListModelFromJson(Map<String, dynamic> json) {
  final PostsHotRecommendListModel postsHotRecommendListModel = PostsHotRecommendListModel();
  final List<PostsHotRecommendListRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<PostsHotRecommendListRecords>(e) as PostsHotRecommendListRecords).toList();
  if (records != null) {
    postsHotRecommendListModel.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    postsHotRecommendListModel.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    postsHotRecommendListModel.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    postsHotRecommendListModel.current = current;
  }
  final List<dynamic>? orders = (json['orders'] as List<dynamic>?)?.map(
          (e) => e).toList();
  if (orders != null) {
    postsHotRecommendListModel.orders = orders;
  }
  final bool? optimizeCountSql = jsonConvert.convert<bool>(json['optimizeCountSql']);
  if (optimizeCountSql != null) {
    postsHotRecommendListModel.optimizeCountSql = optimizeCountSql;
  }
  final bool? searchCount = jsonConvert.convert<bool>(json['searchCount']);
  if (searchCount != null) {
    postsHotRecommendListModel.searchCount = searchCount;
  }
  final dynamic countId = json['countId'];
  if (countId != null) {
    postsHotRecommendListModel.countId = countId;
  }
  final dynamic maxLimit = json['maxLimit'];
  if (maxLimit != null) {
    postsHotRecommendListModel.maxLimit = maxLimit;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    postsHotRecommendListModel.pages = pages;
  }
  return postsHotRecommendListModel;
}

Map<String, dynamic> $PostsHotRecommendListModelToJson(PostsHotRecommendListModel entity) {
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

extension PostsHotRecommendListModelExtension on PostsHotRecommendListModel {
  PostsHotRecommendListModel copyWith({
    List<PostsHotRecommendListRecords>? records,
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
    return PostsHotRecommendListModel()
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

PostsHotRecommendListRecords $PostsHotRecommendListRecordsFromJson(Map<String, dynamic> json) {
  final PostsHotRecommendListRecords postsHotRecommendListRecords = PostsHotRecommendListRecords();
  final int? postId = jsonConvert.convert<int>(json['postId']);
  if (postId != null) {
    postsHotRecommendListRecords.postId = postId;
  }
  final String? memberNum = jsonConvert.convert<String>(json['memberNum']);
  if (memberNum != null) {
    postsHotRecommendListRecords.memberNum = memberNum;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    postsHotRecommendListRecords.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    postsHotRecommendListRecords.avatarUrl = avatarUrl;
  }
  final String? publishTime = jsonConvert.convert<String>(json['publishTime']);
  if (publishTime != null) {
    postsHotRecommendListRecords.publishTime = publishTime;
  }
  final String? textContent = jsonConvert.convert<String>(json['textContent']);
  if (textContent != null) {
    postsHotRecommendListRecords.textContent = textContent;
  }
  final String? imgeUrls = jsonConvert.convert<String>(json['imgeUrls']);
  if (imgeUrls != null) {
    postsHotRecommendListRecords.imgeUrls = imgeUrls;
  }
  final String? videoUrl = jsonConvert.convert<String>(json['videoUrl']);
  if (videoUrl != null) {
    postsHotRecommendListRecords.videoUrl = videoUrl;
  }
  final int? isPositionInfo = jsonConvert.convert<int>(json['isPositionInfo']);
  if (isPositionInfo != null) {
    postsHotRecommendListRecords.isPositionInfo = isPositionInfo;
  }
  final String? addName = jsonConvert.convert<String>(json['addName']);
  if (addName != null) {
    postsHotRecommendListRecords.addName = addName;
  }
  final String? addrLongitude = jsonConvert.convert<String>(json['addrLongitude']);
  if (addrLongitude != null) {
    postsHotRecommendListRecords.addrLongitude = addrLongitude;
  }
  final String? addrLatitude = jsonConvert.convert<String>(json['addrLatitude']);
  if (addrLatitude != null) {
    postsHotRecommendListRecords.addrLatitude = addrLatitude;
  }
  final int? isFocus = jsonConvert.convert<int>(json['isFocus']);
  if (isFocus != null) {
    postsHotRecommendListRecords.isFocus = isFocus;
  }
  final int? shareCount = jsonConvert.convert<int>(json['shareCount']);
  if (shareCount != null) {
    postsHotRecommendListRecords.shareCount = shareCount;
  }
  final int? likeCount = jsonConvert.convert<int>(json['likeCount']);
  if (likeCount != null) {
    postsHotRecommendListRecords.likeCount = likeCount;
  }
  final int? commentCount = jsonConvert.convert<int>(json['commentCount']);
  if (commentCount != null) {
    postsHotRecommendListRecords.commentCount = commentCount;
  }
  final int? lookCount = jsonConvert.convert<int>(json['lookCount']);
  if (lookCount != null) {
    postsHotRecommendListRecords.lookCount = lookCount;
  }
  final bool? isCanShare = jsonConvert.convert<bool>(json['isCanShare']);
  if (isCanShare != null) {
    postsHotRecommendListRecords.isCanShare = isCanShare;
  }
  final bool? isCanComment = jsonConvert.convert<bool>(json['isCanComment']);
  if (isCanComment != null) {
    postsHotRecommendListRecords.isCanComment = isCanComment;
  }
  final bool? isLike = jsonConvert.convert<bool>(json['isLike']);
  if (isLike != null) {
    postsHotRecommendListRecords.isLike = isLike;
  }
  final bool? isCollect = jsonConvert.convert<bool>(json['isCollect']);
  if (isCollect != null) {
    postsHotRecommendListRecords.isCollect = isCollect;
  }
  return postsHotRecommendListRecords;
}

Map<String, dynamic> $PostsHotRecommendListRecordsToJson(PostsHotRecommendListRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['postId'] = entity.postId;
  data['memberNum'] = entity.memberNum;
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['publishTime'] = entity.publishTime;
  data['textContent'] = entity.textContent;
  data['imgeUrls'] = entity.imgeUrls;
  data['videoUrl'] = entity.videoUrl;
  data['isPositionInfo'] = entity.isPositionInfo;
  data['addName'] = entity.addName;
  data['addrLongitude'] = entity.addrLongitude;
  data['addrLatitude'] = entity.addrLatitude;
  data['isFocus'] = entity.isFocus;
  data['shareCount'] = entity.shareCount;
  data['likeCount'] = entity.likeCount;
  data['commentCount'] = entity.commentCount;
  data['lookCount'] = entity.lookCount;
  data['isCanShare'] = entity.isCanShare;
  data['isCanComment'] = entity.isCanComment;
  data['isLike'] = entity.isLike;
  data['isCollect'] = entity.isCollect;
  return data;
}

extension PostsHotRecommendListRecordsExtension on PostsHotRecommendListRecords {
  PostsHotRecommendListRecords copyWith({
    int? postId,
    String? memberNum,
    String? nickName,
    String? avatarUrl,
    String? publishTime,
    String? textContent,
    String? imgeUrls,
    String? videoUrl,
    int? isPositionInfo,
    String? addName,
    String? addrLongitude,
    String? addrLatitude,
    int? isFocus,
    int? shareCount,
    int? likeCount,
    int? commentCount,
    int? lookCount,
    bool? isCanShare,
    bool? isCanComment,
    bool? isLike,
    bool? isCollect,
  }) {
    return PostsHotRecommendListRecords()
      ..postId = postId ?? this.postId
      ..memberNum = memberNum ?? this.memberNum
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..publishTime = publishTime ?? this.publishTime
      ..textContent = textContent ?? this.textContent
      ..imgeUrls = imgeUrls ?? this.imgeUrls
      ..videoUrl = videoUrl ?? this.videoUrl
      ..isPositionInfo = isPositionInfo ?? this.isPositionInfo
      ..addName = addName ?? this.addName
      ..addrLongitude = addrLongitude ?? this.addrLongitude
      ..addrLatitude = addrLatitude ?? this.addrLatitude
      ..isFocus = isFocus ?? this.isFocus
      ..shareCount = shareCount ?? this.shareCount
      ..likeCount = likeCount ?? this.likeCount
      ..commentCount = commentCount ?? this.commentCount
      ..lookCount = lookCount ?? this.lookCount
      ..isCanShare = isCanShare ?? this.isCanShare
      ..isCanComment = isCanComment ?? this.isCanComment
      ..isLike = isLike ?? this.isLike
      ..isCollect = isCollect ?? this.isCollect;
  }
}
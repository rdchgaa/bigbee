import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/posts_details_model.dart';

PostsDetailsModel $PostsDetailsModelFromJson(Map<String, dynamic> json) {
  final PostsDetailsModel postsDetailsModel = PostsDetailsModel();
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    postsDetailsModel.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    postsDetailsModel.avatarUrl = avatarUrl;
  }
  final String? publishTime = jsonConvert.convert<String>(json['publishTime']);
  if (publishTime != null) {
    postsDetailsModel.publishTime = publishTime;
  }
  final int? trendsType = jsonConvert.convert<int>(json['trendsType']);
  if (trendsType != null) {
    postsDetailsModel.trendsType = trendsType;
  }
  final String? textContent = jsonConvert.convert<String>(json['textContent']);
  if (textContent != null) {
    postsDetailsModel.textContent = textContent;
  }
  final String? imgeUrls = jsonConvert.convert<String>(json['imgeUrls']);
  if (imgeUrls != null) {
    postsDetailsModel.imgeUrls = imgeUrls;
  }
  final String? videoUrl = jsonConvert.convert<String>(json['videoUrl']);
  if (videoUrl != null) {
    postsDetailsModel.videoUrl = videoUrl;
  }
  final int? isPositionInfo = jsonConvert.convert<int>(json['isPositionInfo']);
  if (isPositionInfo != null) {
    postsDetailsModel.isPositionInfo = isPositionInfo;
  }
  final String? addrName = jsonConvert.convert<String>(json['addrName']);
  if (addrName != null) {
    postsDetailsModel.addrName = addrName;
  }
  final String? addrAddress = jsonConvert.convert<String>(json['addrAddress']);
  if (addrAddress != null) {
    postsDetailsModel.addrAddress = addrAddress;
  }
  final String? addrLongitude = jsonConvert.convert<String>(json['addrLongitude']);
  if (addrLongitude != null) {
    postsDetailsModel.addrLongitude = addrLongitude;
  }
  final String? addrLatitude = jsonConvert.convert<String>(json['addrLatitude']);
  if (addrLatitude != null) {
    postsDetailsModel.addrLatitude = addrLatitude;
  }
  final int? isFocus = jsonConvert.convert<int>(json['isFocus']);
  if (isFocus != null) {
    postsDetailsModel.isFocus = isFocus;
  }
  final int? shareCount = jsonConvert.convert<int>(json['shareCount']);
  if (shareCount != null) {
    postsDetailsModel.shareCount = shareCount;
  }
  final int? likeCount = jsonConvert.convert<int>(json['likeCount']);
  if (likeCount != null) {
    postsDetailsModel.likeCount = likeCount;
  }
  final int? commentCount = jsonConvert.convert<int>(json['commentCount']);
  if (commentCount != null) {
    postsDetailsModel.commentCount = commentCount;
  }
  final int? collectNum = jsonConvert.convert<int>(json['collectNum']);
  if (collectNum != null) {
    postsDetailsModel.collectNum = collectNum;
  }
  final String? tippingTotalAmount = jsonConvert.convert<String>(json['tippingTotalAmount']);
  if (tippingTotalAmount != null) {
    postsDetailsModel.tippingTotalAmount = tippingTotalAmount;
  }
  final int? isMyself = jsonConvert.convert<int>(json['isMyself']);
  if (isMyself != null) {
    postsDetailsModel.isMyself = isMyself;
  }
  final bool? isLike = jsonConvert.convert<bool>(json['isLike']);
  if (isLike != null) {
    postsDetailsModel.isLike = isLike;
  }
  final String? memberNum = jsonConvert.convert<String>(json['memberNum']);
  if (memberNum != null) {
    postsDetailsModel.memberNum = memberNum;
  }
  final bool? isCanShare = jsonConvert.convert<bool>(json['isCanShare']);
  if (isCanShare != null) {
    postsDetailsModel.isCanShare = isCanShare;
  }
  final bool? isCanComment = jsonConvert.convert<bool>(json['isCanComment']);
  if (isCanComment != null) {
    postsDetailsModel.isCanComment = isCanComment;
  }
  final bool? isCollect = jsonConvert.convert<bool>(json['isCollect']);
  if (isCollect != null) {
    postsDetailsModel.isCollect = isCollect;
  }
  return postsDetailsModel;
}

Map<String, dynamic> $PostsDetailsModelToJson(PostsDetailsModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['publishTime'] = entity.publishTime;
  data['trendsType'] = entity.trendsType;
  data['textContent'] = entity.textContent;
  data['imgeUrls'] = entity.imgeUrls;
  data['videoUrl'] = entity.videoUrl;
  data['isPositionInfo'] = entity.isPositionInfo;
  data['addrName'] = entity.addrName;
  data['addrAddress'] = entity.addrAddress;
  data['addrLongitude'] = entity.addrLongitude;
  data['addrLatitude'] = entity.addrLatitude;
  data['isFocus'] = entity.isFocus;
  data['shareCount'] = entity.shareCount;
  data['likeCount'] = entity.likeCount;
  data['commentCount'] = entity.commentCount;
  data['collectNum'] = entity.collectNum;
  data['tippingTotalAmount'] = entity.tippingTotalAmount;
  data['isMyself'] = entity.isMyself;
  data['isLike'] = entity.isLike;
  data['memberNum'] = entity.memberNum;
  data['isCanShare'] = entity.isCanShare;
  data['isCanComment'] = entity.isCanComment;
  data['isCollect'] = entity.isCollect;
  return data;
}

extension PostsDetailsModelExtension on PostsDetailsModel {
  PostsDetailsModel copyWith({
    String? nickName,
    String? avatarUrl,
    String? publishTime,
    int? trendsType,
    String? textContent,
    String? imgeUrls,
    String? videoUrl,
    int? isPositionInfo,
    String? addrName,
    String? addrAddress,
    String? addrLongitude,
    String? addrLatitude,
    int? isFocus,
    int? shareCount,
    int? likeCount,
    int? commentCount,
    int? collectNum,
    String? tippingTotalAmount,
    int? isMyself,
    bool? isLike,
    String? memberNum,
    bool? isCanShare,
    bool? isCanComment,
    bool? isCollect,
  }) {
    return PostsDetailsModel()
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..publishTime = publishTime ?? this.publishTime
      ..trendsType = trendsType ?? this.trendsType
      ..textContent = textContent ?? this.textContent
      ..imgeUrls = imgeUrls ?? this.imgeUrls
      ..videoUrl = videoUrl ?? this.videoUrl
      ..isPositionInfo = isPositionInfo ?? this.isPositionInfo
      ..addrName = addrName ?? this.addrName
      ..addrAddress = addrAddress ?? this.addrAddress
      ..addrLongitude = addrLongitude ?? this.addrLongitude
      ..addrLatitude = addrLatitude ?? this.addrLatitude
      ..isFocus = isFocus ?? this.isFocus
      ..shareCount = shareCount ?? this.shareCount
      ..likeCount = likeCount ?? this.likeCount
      ..commentCount = commentCount ?? this.commentCount
      ..collectNum = collectNum ?? this.collectNum
      ..tippingTotalAmount = tippingTotalAmount ?? this.tippingTotalAmount
      ..isMyself = isMyself ?? this.isMyself
      ..isLike = isLike ?? this.isLike
      ..memberNum = memberNum ?? this.memberNum
      ..isCanShare = isCanShare ?? this.isCanShare
      ..isCanComment = isCanComment ?? this.isCanComment
      ..isCollect = isCollect ?? this.isCollect;
  }
}
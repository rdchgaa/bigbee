import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/im/notice_details_model.dart';

NoticeDetailsModel $NoticeDetailsModelFromJson(Map<String, dynamic> json) {
  final NoticeDetailsModel noticeDetailsModel = NoticeDetailsModel();
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    noticeDetailsModel.createTime = createTime;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    noticeDetailsModel.id = id;
  }
  final int? noticeId = jsonConvert.convert<int>(json['noticeId']);
  if (noticeId != null) {
    noticeDetailsModel.noticeId = noticeId;
  }
  final String? languageType = jsonConvert.convert<String>(json['languageType']);
  if (languageType != null) {
    noticeDetailsModel.languageType = languageType;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    noticeDetailsModel.title = title;
  }
  final String? profile = jsonConvert.convert<String>(json['profile']);
  if (profile != null) {
    noticeDetailsModel.profile = profile;
  }
  final String? imgUrl = jsonConvert.convert<String>(json['imgUrl']);
  if (imgUrl != null) {
    noticeDetailsModel.imgUrl = imgUrl;
  }
  final String? noticeContent = jsonConvert.convert<String>(json['noticeContent']);
  if (noticeContent != null) {
    noticeDetailsModel.noticeContent = noticeContent;
  }
  return noticeDetailsModel;
}

Map<String, dynamic> $NoticeDetailsModelToJson(NoticeDetailsModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createTime'] = entity.createTime;
  data['id'] = entity.id;
  data['noticeId'] = entity.noticeId;
  data['languageType'] = entity.languageType;
  data['title'] = entity.title;
  data['profile'] = entity.profile;
  data['imgUrl'] = entity.imgUrl;
  data['noticeContent'] = entity.noticeContent;
  return data;
}

extension NoticeDetailsModelExtension on NoticeDetailsModel {
  NoticeDetailsModel copyWith({
    String? createTime,
    int? id,
    int? noticeId,
    String? languageType,
    String? title,
    String? profile,
    String? imgUrl,
    String? noticeContent,
  }) {
    return NoticeDetailsModel()
      ..createTime = createTime ?? this.createTime
      ..id = id ?? this.id
      ..noticeId = noticeId ?? this.noticeId
      ..languageType = languageType ?? this.languageType
      ..title = title ?? this.title
      ..profile = profile ?? this.profile
      ..imgUrl = imgUrl ?? this.imgUrl
      ..noticeContent = noticeContent ?? this.noticeContent;
  }
}
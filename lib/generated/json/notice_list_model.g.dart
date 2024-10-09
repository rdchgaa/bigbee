import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/im/notice_list_model.dart';

NoticeListModel $NoticeListModelFromJson(Map<String, dynamic> json) {
  final NoticeListModel noticeListModel = NoticeListModel();
  final int? noticeId = jsonConvert.convert<int>(json['noticeId']);
  if (noticeId != null) {
    noticeListModel.noticeId = noticeId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    noticeListModel.title = title;
  }
  final String? cover = jsonConvert.convert<String>(json['cover']);
  if (cover != null) {
    noticeListModel.cover = cover;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    noticeListModel.createTime = createTime;
  }
  final String? profile = jsonConvert.convert<String>(json['profile']);
  if (profile != null) {
    noticeListModel.profile = profile;
  }
  return noticeListModel;
}

Map<String, dynamic> $NoticeListModelToJson(NoticeListModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['noticeId'] = entity.noticeId;
  data['title'] = entity.title;
  data['cover'] = entity.cover;
  data['createTime'] = entity.createTime;
  data['profile'] = entity.profile;
  return data;
}

extension NoticeListModelExtension on NoticeListModel {
  NoticeListModel copyWith({
    int? noticeId,
    String? title,
    String? cover,
    String? createTime,
    String? profile,
  }) {
    return NoticeListModel()
      ..noticeId = noticeId ?? this.noticeId
      ..title = title ?? this.title
      ..cover = cover ?? this.cover
      ..createTime = createTime ?? this.createTime
      ..profile = profile ?? this.profile;
  }
}
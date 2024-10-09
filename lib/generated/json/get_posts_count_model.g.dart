import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/get_posts_count_model.dart';

GetPostsCountModel $GetPostsCountModelFromJson(Map<String, dynamic> json) {
  final GetPostsCountModel getPostsCountModel = GetPostsCountModel();
  final dynamic createBy = json['createBy'];
  if (createBy != null) {
    getPostsCountModel.createBy = createBy;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    getPostsCountModel.createTime = createTime;
  }
  final dynamic updateBy = json['updateBy'];
  if (updateBy != null) {
    getPostsCountModel.updateBy = updateBy;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    getPostsCountModel.updateTime = updateTime;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    getPostsCountModel.remark = remark;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    getPostsCountModel.id = id;
  }
  final int? infoId = jsonConvert.convert<int>(json['infoId']);
  if (infoId != null) {
    getPostsCountModel.infoId = infoId;
  }
  final int? sharesNum = jsonConvert.convert<int>(json['sharesNum']);
  if (sharesNum != null) {
    getPostsCountModel.sharesNum = sharesNum;
  }
  final int? commentNum = jsonConvert.convert<int>(json['commentNum']);
  if (commentNum != null) {
    getPostsCountModel.commentNum = commentNum;
  }
  final int? giveNum = jsonConvert.convert<int>(json['giveNum']);
  if (giveNum != null) {
    getPostsCountModel.giveNum = giveNum;
  }
  final int? readNum = jsonConvert.convert<int>(json['readNum']);
  if (readNum != null) {
    getPostsCountModel.readNum = readNum;
  }
  final int? collectionNum = jsonConvert.convert<int>(json['collectionNum']);
  if (collectionNum != null) {
    getPostsCountModel.collectionNum = collectionNum;
  }
  final int? rewardQty = jsonConvert.convert<int>(json['rewardQty']);
  if (rewardQty != null) {
    getPostsCountModel.rewardQty = rewardQty;
  }
  final bool? like = jsonConvert.convert<bool>(json['like']);
  if (like != null) {
    getPostsCountModel.like = like;
  }
  return getPostsCountModel;
}

Map<String, dynamic> $GetPostsCountModelToJson(GetPostsCountModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createBy'] = entity.createBy;
  data['createTime'] = entity.createTime;
  data['updateBy'] = entity.updateBy;
  data['updateTime'] = entity.updateTime;
  data['remark'] = entity.remark;
  data['id'] = entity.id;
  data['infoId'] = entity.infoId;
  data['sharesNum'] = entity.sharesNum;
  data['commentNum'] = entity.commentNum;
  data['giveNum'] = entity.giveNum;
  data['readNum'] = entity.readNum;
  data['collectionNum'] = entity.collectionNum;
  data['rewardQty'] = entity.rewardQty;
  data['like'] = entity.like;
  return data;
}

extension GetPostsCountModelExtension on GetPostsCountModel {
  GetPostsCountModel copyWith({
    dynamic createBy,
    String? createTime,
    dynamic updateBy,
    String? updateTime,
    dynamic remark,
    int? id,
    int? infoId,
    int? sharesNum,
    int? commentNum,
    int? giveNum,
    int? readNum,
    int? collectionNum,
    int? rewardQty,
    bool? like,
  }) {
    return GetPostsCountModel()
      ..createBy = createBy ?? this.createBy
      ..createTime = createTime ?? this.createTime
      ..updateBy = updateBy ?? this.updateBy
      ..updateTime = updateTime ?? this.updateTime
      ..remark = remark ?? this.remark
      ..id = id ?? this.id
      ..infoId = infoId ?? this.infoId
      ..sharesNum = sharesNum ?? this.sharesNum
      ..commentNum = commentNum ?? this.commentNum
      ..giveNum = giveNum ?? this.giveNum
      ..readNum = readNum ?? this.readNum
      ..collectionNum = collectionNum ?? this.collectionNum
      ..rewardQty = rewardQty ?? this.rewardQty
      ..like = like ?? this.like;
  }
}
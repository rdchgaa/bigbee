import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/dynamic/posts_reward_options_model.dart';

PostsRewardOptionsModel $PostsRewardOptionsModelFromJson(Map<String, dynamic> json) {
  final PostsRewardOptionsModel postsRewardOptionsModel = PostsRewardOptionsModel();
  final dynamic createBy = json['createBy'];
  if (createBy != null) {
    postsRewardOptionsModel.createBy = createBy;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    postsRewardOptionsModel.createTime = createTime;
  }
  final dynamic updateBy = json['updateBy'];
  if (updateBy != null) {
    postsRewardOptionsModel.updateBy = updateBy;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    postsRewardOptionsModel.updateTime = updateTime;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    postsRewardOptionsModel.remark = remark;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    postsRewardOptionsModel.id = id;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    postsRewardOptionsModel.type = type;
  }
  final int? payCoinId = jsonConvert.convert<int>(json['payCoinId']);
  if (payCoinId != null) {
    postsRewardOptionsModel.payCoinId = payCoinId;
  }
  final double? payQty = jsonConvert.convert<double>(json['payQty']);
  if (payQty != null) {
    postsRewardOptionsModel.payQty = payQty;
  }
  final double? durationNum = jsonConvert.convert<double>(json['durationNum']);
  if (durationNum != null) {
    postsRewardOptionsModel.durationNum = durationNum;
  }
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    postsRewardOptionsModel.price = price;
  }
  return postsRewardOptionsModel;
}

Map<String, dynamic> $PostsRewardOptionsModelToJson(PostsRewardOptionsModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createBy'] = entity.createBy;
  data['createTime'] = entity.createTime;
  data['updateBy'] = entity.updateBy;
  data['updateTime'] = entity.updateTime;
  data['remark'] = entity.remark;
  data['id'] = entity.id;
  data['type'] = entity.type;
  data['payCoinId'] = entity.payCoinId;
  data['payQty'] = entity.payQty;
  data['durationNum'] = entity.durationNum;
  data['price'] = entity.price;
  return data;
}

extension PostsRewardOptionsModelExtension on PostsRewardOptionsModel {
  PostsRewardOptionsModel copyWith({
    dynamic createBy,
    String? createTime,
    dynamic updateBy,
    String? updateTime,
    dynamic remark,
    int? id,
    int? type,
    int? payCoinId,
    double? payQty,
    double? durationNum,
    double? price,
  }) {
    return PostsRewardOptionsModel()
      ..createBy = createBy ?? this.createBy
      ..createTime = createTime ?? this.createTime
      ..updateBy = updateBy ?? this.updateBy
      ..updateTime = updateTime ?? this.updateTime
      ..remark = remark ?? this.remark
      ..id = id ?? this.id
      ..type = type ?? this.type
      ..payCoinId = payCoinId ?? this.payCoinId
      ..payQty = payQty ?? this.payQty
      ..durationNum = durationNum ?? this.durationNum
      ..price = price ?? this.price;
  }
}
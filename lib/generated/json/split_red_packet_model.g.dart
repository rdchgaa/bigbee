import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/red_bag/split_red_packet_model.dart';

SplitRedPacketModel $SplitRedPacketModelFromJson(Map<String, dynamic> json) {
  final SplitRedPacketModel splitRedPacketModel = SplitRedPacketModel();
  final int? redPacketId = jsonConvert.convert<int>(json['redPacketId']);
  if (redPacketId != null) {
    splitRedPacketModel.redPacketId = redPacketId;
  }
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    splitRedPacketModel.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    splitRedPacketModel.avatarUrl = avatarUrl;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    splitRedPacketModel.title = title;
  }
  return splitRedPacketModel;
}

Map<String, dynamic> $SplitRedPacketModelToJson(SplitRedPacketModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['redPacketId'] = entity.redPacketId;
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['title'] = entity.title;
  return data;
}

extension SplitRedPacketModelExtension on SplitRedPacketModel {
  SplitRedPacketModel copyWith({
    int? redPacketId,
    String? nickName,
    String? avatarUrl,
    String? title,
  }) {
    return SplitRedPacketModel()
      ..redPacketId = redPacketId ?? this.redPacketId
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..title = title ?? this.title;
  }
}
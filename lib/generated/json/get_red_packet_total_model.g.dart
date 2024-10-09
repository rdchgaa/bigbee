import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_total_model.dart';

GetRedPacketTotalModel $GetRedPacketTotalModelFromJson(Map<String, dynamic> json) {
  final GetRedPacketTotalModel getRedPacketTotalModel = GetRedPacketTotalModel();
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    getRedPacketTotalModel.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    getRedPacketTotalModel.avatarUrl = avatarUrl;
  }
  final double? qty = jsonConvert.convert<double>(json['qty']);
  if (qty != null) {
    getRedPacketTotalModel.qty = qty;
  }
  final dynamic memberSearchRedPacketVoList = json['memberSearchRedPacketVoList'];
  if (memberSearchRedPacketVoList != null) {
    getRedPacketTotalModel.memberSearchRedPacketVoList = memberSearchRedPacketVoList;
  }
  return getRedPacketTotalModel;
}

Map<String, dynamic> $GetRedPacketTotalModelToJson(GetRedPacketTotalModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['qty'] = entity.qty;
  data['memberSearchRedPacketVoList'] = entity.memberSearchRedPacketVoList;
  return data;
}

extension GetRedPacketTotalModelExtension on GetRedPacketTotalModel {
  GetRedPacketTotalModel copyWith({
    String? nickName,
    String? avatarUrl,
    double? qty,
    dynamic memberSearchRedPacketVoList,
  }) {
    return GetRedPacketTotalModel()
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..qty = qty ?? this.qty
      ..memberSearchRedPacketVoList = memberSearchRedPacketVoList ?? this.memberSearchRedPacketVoList;
  }
}
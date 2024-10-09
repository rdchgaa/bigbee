import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/red_bag/red_packet_detail_model.dart';

RedPacketDetailModel $RedPacketDetailModelFromJson(Map<String, dynamic> json) {
  final RedPacketDetailModel redPacketDetailModel = RedPacketDetailModel();
  final String? nickName = jsonConvert.convert<String>(json['nickName']);
  if (nickName != null) {
    redPacketDetailModel.nickName = nickName;
  }
  final String? avatarUrl = jsonConvert.convert<String>(json['avatarUrl']);
  if (avatarUrl != null) {
    redPacketDetailModel.avatarUrl = avatarUrl;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    redPacketDetailModel.title = title;
  }
  final int? number = jsonConvert.convert<int>(json['number']);
  if (number != null) {
    redPacketDetailModel.number = number;
  }
  final String? qty = jsonConvert.convert<String>(json['qty']);
  if (qty != null) {
    redPacketDetailModel.qty = qty;
  }
  final String? coinName = jsonConvert.convert<String>(json['coinName']);
  if (coinName != null) {
    redPacketDetailModel.coinName = coinName;
  }
  final int? receiveNumber = jsonConvert.convert<int>(json['receiveNumber']);
  if (receiveNumber != null) {
    redPacketDetailModel.receiveNumber = receiveNumber;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    redPacketDetailModel.status = status;
  }
  final int? redPacketId = jsonConvert.convert<int>(json['redPacketId']);
  if (redPacketId != null) {
    redPacketDetailModel.redPacketId = redPacketId;
  }
  return redPacketDetailModel;
}

Map<String, dynamic> $RedPacketDetailModelToJson(RedPacketDetailModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['nickName'] = entity.nickName;
  data['avatarUrl'] = entity.avatarUrl;
  data['title'] = entity.title;
  data['number'] = entity.number;
  data['qty'] = entity.qty;
  data['coinName'] = entity.coinName;
  data['receiveNumber'] = entity.receiveNumber;
  data['status'] = entity.status;
  data['redPacketId'] = entity.redPacketId;
  return data;
}

extension RedPacketDetailModelExtension on RedPacketDetailModel {
  RedPacketDetailModel copyWith({
    String? nickName,
    String? avatarUrl,
    String? title,
    int? number,
    String? qty,
    String? coinName,
    int? receiveNumber,
    int? status,
    int? redPacketId,
  }) {
    return RedPacketDetailModel()
      ..nickName = nickName ?? this.nickName
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..title = title ?? this.title
      ..number = number ?? this.number
      ..qty = qty ?? this.qty
      ..coinName = coinName ?? this.coinName
      ..receiveNumber = receiveNumber ?? this.receiveNumber
      ..status = status ?? this.status
      ..redPacketId = redPacketId ?? this.redPacketId;
  }
}
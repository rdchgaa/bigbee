import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/red_bag/receive_red_packet_model.dart';

ReceiveRedPacketModel $ReceiveRedPacketModelFromJson(Map<String, dynamic> json) {
  final ReceiveRedPacketModel receiveRedPacketModel = ReceiveRedPacketModel();
  final String? coinName = jsonConvert.convert<String>(json['coinName']);
  if (coinName != null) {
    receiveRedPacketModel.coinName = coinName;
  }
  final int? coinId = jsonConvert.convert<int>(json['coinId']);
  if (coinId != null) {
    receiveRedPacketModel.coinId = coinId;
  }
  final int? redPacketId = jsonConvert.convert<int>(json['redPacketId']);
  if (redPacketId != null) {
    receiveRedPacketModel.redPacketId = redPacketId;
  }
  final int? formMemberId = jsonConvert.convert<int>(json['formMemberId']);
  if (formMemberId != null) {
    receiveRedPacketModel.formMemberId = formMemberId;
  }
  final int? receiveMemberId = jsonConvert.convert<int>(json['receiveMemberId']);
  if (receiveMemberId != null) {
    receiveRedPacketModel.receiveMemberId = receiveMemberId;
  }
  final double? receiveQty = jsonConvert.convert<double>(json['receiveQty']);
  if (receiveQty != null) {
    receiveRedPacketModel.receiveQty = receiveQty;
  }
  return receiveRedPacketModel;
}

Map<String, dynamic> $ReceiveRedPacketModelToJson(ReceiveRedPacketModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['coinName'] = entity.coinName;
  data['coinId'] = entity.coinId;
  data['redPacketId'] = entity.redPacketId;
  data['formMemberId'] = entity.formMemberId;
  data['receiveMemberId'] = entity.receiveMemberId;
  data['receiveQty'] = entity.receiveQty;
  return data;
}

extension ReceiveRedPacketModelExtension on ReceiveRedPacketModel {
  ReceiveRedPacketModel copyWith({
    String? coinName,
    int? coinId,
    int? redPacketId,
    int? formMemberId,
    int? receiveMemberId,
    double? receiveQty,
  }) {
    return ReceiveRedPacketModel()
      ..coinName = coinName ?? this.coinName
      ..coinId = coinId ?? this.coinId
      ..redPacketId = redPacketId ?? this.redPacketId
      ..formMemberId = formMemberId ?? this.formMemberId
      ..receiveMemberId = receiveMemberId ?? this.receiveMemberId
      ..receiveQty = receiveQty ?? this.receiveQty;
  }
}
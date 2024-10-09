import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/red_bag/is_receive_red_packet_model.dart';

IsReceiveRedPacketModel $IsReceiveRedPacketModelFromJson(Map<String, dynamic> json) {
  final IsReceiveRedPacketModel isReceiveRedPacketModel = IsReceiveRedPacketModel();
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    isReceiveRedPacketModel.status = status;
  }
  return isReceiveRedPacketModel;
}

Map<String, dynamic> $IsReceiveRedPacketModelToJson(IsReceiveRedPacketModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['status'] = entity.status;
  return data;
}

extension IsReceiveRedPacketModelExtension on IsReceiveRedPacketModel {
  IsReceiveRedPacketModel copyWith({
    int? status,
  }) {
    return IsReceiveRedPacketModel()
      ..status = status ?? this.status;
  }
}
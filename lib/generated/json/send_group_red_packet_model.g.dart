import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/red_bag/send_group_red_packet_model.dart';

SendGroupRedPacketModel $SendGroupRedPacketModelFromJson(Map<String, dynamic> json) {
  final SendGroupRedPacketModel sendGroupRedPacketModel = SendGroupRedPacketModel();
  final dynamic createBy = json['createBy'];
  if (createBy != null) {
    sendGroupRedPacketModel.createBy = createBy;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    sendGroupRedPacketModel.createTime = createTime;
  }
  final dynamic updateBy = json['updateBy'];
  if (updateBy != null) {
    sendGroupRedPacketModel.updateBy = updateBy;
  }
  final dynamic updateTime = json['updateTime'];
  if (updateTime != null) {
    sendGroupRedPacketModel.updateTime = updateTime;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    sendGroupRedPacketModel.remark = remark;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    sendGroupRedPacketModel.id = id;
  }
  final int? memberId = jsonConvert.convert<int>(json['memberId']);
  if (memberId != null) {
    sendGroupRedPacketModel.memberId = memberId;
  }
  final dynamic toMemberNum = json['toMemberNum'];
  if (toMemberNum != null) {
    sendGroupRedPacketModel.toMemberNum = toMemberNum;
  }
  final String? groupId = jsonConvert.convert<String>(json['groupId']);
  if (groupId != null) {
    sendGroupRedPacketModel.groupId = groupId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    sendGroupRedPacketModel.title = title;
  }
  final int? coinId = jsonConvert.convert<int>(json['coinId']);
  if (coinId != null) {
    sendGroupRedPacketModel.coinId = coinId;
  }
  final int? qty = jsonConvert.convert<int>(json['qty']);
  if (qty != null) {
    sendGroupRedPacketModel.qty = qty;
  }
  final int? number = jsonConvert.convert<int>(json['number']);
  if (number != null) {
    sendGroupRedPacketModel.number = number;
  }
  final int? receiveNumber = jsonConvert.convert<int>(json['receiveNumber']);
  if (receiveNumber != null) {
    sendGroupRedPacketModel.receiveNumber = receiveNumber;
  }
  final int? receiveQty = jsonConvert.convert<int>(json['receiveQty']);
  if (receiveQty != null) {
    sendGroupRedPacketModel.receiveQty = receiveQty;
  }
  final dynamic backQty = json['backQty'];
  if (backQty != null) {
    sendGroupRedPacketModel.backQty = backQty;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    sendGroupRedPacketModel.status = status;
  }
  final int? level = jsonConvert.convert<int>(json['level']);
  if (level != null) {
    sendGroupRedPacketModel.level = level;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    sendGroupRedPacketModel.type = type;
  }
  return sendGroupRedPacketModel;
}

Map<String, dynamic> $SendGroupRedPacketModelToJson(SendGroupRedPacketModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createBy'] = entity.createBy;
  data['createTime'] = entity.createTime;
  data['updateBy'] = entity.updateBy;
  data['updateTime'] = entity.updateTime;
  data['remark'] = entity.remark;
  data['id'] = entity.id;
  data['memberId'] = entity.memberId;
  data['toMemberNum'] = entity.toMemberNum;
  data['groupId'] = entity.groupId;
  data['title'] = entity.title;
  data['coinId'] = entity.coinId;
  data['qty'] = entity.qty;
  data['number'] = entity.number;
  data['receiveNumber'] = entity.receiveNumber;
  data['receiveQty'] = entity.receiveQty;
  data['backQty'] = entity.backQty;
  data['status'] = entity.status;
  data['level'] = entity.level;
  data['type'] = entity.type;
  return data;
}

extension SendGroupRedPacketModelExtension on SendGroupRedPacketModel {
  SendGroupRedPacketModel copyWith({
    dynamic createBy,
    String? createTime,
    dynamic updateBy,
    dynamic updateTime,
    dynamic remark,
    int? id,
    int? memberId,
    dynamic toMemberNum,
    String? groupId,
    String? title,
    int? coinId,
    int? qty,
    int? number,
    int? receiveNumber,
    int? receiveQty,
    dynamic backQty,
    int? status,
    int? level,
    int? type,
  }) {
    return SendGroupRedPacketModel()
      ..createBy = createBy ?? this.createBy
      ..createTime = createTime ?? this.createTime
      ..updateBy = updateBy ?? this.updateBy
      ..updateTime = updateTime ?? this.updateTime
      ..remark = remark ?? this.remark
      ..id = id ?? this.id
      ..memberId = memberId ?? this.memberId
      ..toMemberNum = toMemberNum ?? this.toMemberNum
      ..groupId = groupId ?? this.groupId
      ..title = title ?? this.title
      ..coinId = coinId ?? this.coinId
      ..qty = qty ?? this.qty
      ..number = number ?? this.number
      ..receiveNumber = receiveNumber ?? this.receiveNumber
      ..receiveQty = receiveQty ?? this.receiveQty
      ..backQty = backQty ?? this.backQty
      ..status = status ?? this.status
      ..level = level ?? this.level
      ..type = type ?? this.type;
  }
}
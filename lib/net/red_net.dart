import 'package:bee_chat/models/red_bag/get_red_packet_list_model.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_total_model.dart';
import 'package:bee_chat/models/red_bag/is_receive_red_packet_model.dart';
import 'package:bee_chat/models/red_bag/receive_red_packet_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_detail_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_get_receivers_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_setting_model.dart';
import 'package:bee_chat/models/red_bag/send_group_red_packet_model.dart';
import 'package:bee_chat/models/red_bag/send_single_red_packet_model.dart';
import 'package:bee_chat/models/red_bag/split_red_packet_model.dart';

import '../utils/net/ab_Net.dart';
import '../utils/net/net_model.dart';
import 'api.dart';

class RedNet {
  /* 红包设置-查询指定币种指定类型的红包设置
  * */
  static Future<RequestResult<RedPacketSettingModel>> redGetRedPacketSetting(
      {required String type, required String level, required String coinId}) {
    return ABNet.request(path: getRedPacketSetting, method: HttpMethod.post, params: {
      "type": type,
      "level": level,
      "coinId": coinId,
    });
  }

  /* 单聊-发起红包
  * */
  static Future<RequestResult<SendSingleRedPacketModel>> redSendSingleRedPacket(
      {required String title, required String toMemberNum, required double qty, required int coinId}) {
    return ABNet.request(path: sendSingleRedPacket, method: HttpMethod.post, params: {
      "coinId": coinId,
      "qty": qty,
      "toMemberNum": toMemberNum,
      "title": title,
    });
  }

  /* 群组-发起红包
  * */
  static Future<RequestResult<SendGroupRedPacketModel>> redSendGroupRedPacket({
    required String title,
    String? toMemberNum,
    required double qty,
    required int coinId,
    required int type,
    required int peopleNumber,
    required String groupId,
  }) {
    return ABNet.request(path: sendGroupRedPacket, method: HttpMethod.post, params: {
      "coinId": coinId,
      "qty": qty,
      "toMemberNum": toMemberNum,
      "title": title,
      "type": type,
      "peopleNumber": peopleNumber,
      "groupId": groupId,
    });
  }

  /* 获取用户统计收发红包
  * */
  static Future<RequestResult<GetRedPacketTotalModel>> redGetRedPacket(
      {required int type, required String years, required int coinId}) {
    return ABNet.request(path: getRedPacket, method: HttpMethod.post, params: {
      "type": type,
      "coinId": coinId,
      "years": years,
    });
  }

  /* 获取红包列表
  * */
  static Future<RequestResult<GetRedPacketListModel>> redGetRedPacketList(
      {required int type, required String years, required int coinId, required int pageNum, int? pageSize = 10}) {
    return ABNet.request(path: getRedPacketList, method: HttpMethod.post, params: {
      "type": type,
      "coinId": coinId,
      "years": years,
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
  }

  /* 拆红包
  * */
  static Future<RequestResult<SplitRedPacketModel>> redSplitRedPacket({required int redPacketId}) {
    return ABNet.request(path: splitRedPacket, method: HttpMethod.get, params: {
      "redPacketId": redPacketId,
    });
  }

  /* 单聊-领取红包
  * */
  static Future<RequestResult<ReceiveRedPacketModel>> redReceiveSingleRedPacket({required int redPacketId}) {
    return ABNet.request(path: receiveSingleRedPacket, method: HttpMethod.get, params: {
      "redPacketId": redPacketId,
    });
  }

  /* 群组-领取红包
  * */
  static Future<RequestResult<ReceiveRedPacketModel>> redReceiveGroupRedPacket(
      {required int redPacketId, required String groupId}) {
    return ABNet.request(path: receiveGroupRedPacket, method: HttpMethod.post, params: {
      "redPacketId": redPacketId,
      "groupId": groupId,
    });
  }

  /* 用户-查看红包详情
  * */
  static Future<RequestResult<RedPacketDetailModel>> redRedPacketDetail({required int redPacketId}) {
    return ABNet.request(path: redPacketDetail, method: HttpMethod.get, params: {
      "redPacketId": redPacketId,
    });
  }

  /* 用户-获取红包接收人列表
  * */
  static Future<RequestResult<RedPacketGetReceiversModel>> redGetReceivers({required int redPacketId,required int pageNum, int? pageSize = 10}) {
    return ABNet.request(path: getReceivers, method: HttpMethod.get, params: {
      "redPacketId": redPacketId,
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
  }

  /* 用户-查询用户红包状态
  * */
  static Future<RequestResult<IsReceiveRedPacketModel>> redIsReceiveRedPacket({required int redPacketId}) {
    return ABNet.request(path: isReceiveRedPacket, method: HttpMethod.get, params: {
      "redPacketId": redPacketId,
    });
  }
}

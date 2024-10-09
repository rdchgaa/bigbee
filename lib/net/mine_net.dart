import 'dart:convert';

import 'package:bee_chat/models/common/empty_model.dart';
import 'package:bee_chat/models/mine/collection_details_model.dart';
import 'package:bee_chat/models/mine/collection_message_list_model.dart';
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
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/im/im_message_utils.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../models/user/follow_user_list_model.dart';
import '../utils/net/ab_Net.dart';
import '../utils/net/net_model.dart';
import 'api.dart';

class MineNet {
  /* 收藏消息-收藏消息列表
  * */
  static Future<RequestResult<CollectionMessageListModel>> mineMessageGetList(
      {required int pageNum, int? pageSize = 10}) {
    return ABNet.request(path: messageGetList, method: HttpMethod.get, params: {
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
  }

  // /*收藏消息-收藏消息
  //  */
  // static Future<RequestResult<EmptyModel>> collectMessages(
  //     {required List<String> messageData, String? groupId}) {
  //   List<String> paraData = messageData.map((e) {
  //     Map<String, dynamic> map = {
  //       "level": groupId == null ? 1 : 2,
  //       "value": e,
  //       "groupId": groupId ?? "",
  //       "fromMemberId": "10124400",
  //       "type": 1,
  //     };
  //     return jsonEncode(map);
  //   }).toList();
  //   return ABNet.request(path: messageCollectApi, method: HttpMethod.post, params: {
  //     "messageCollectDtoList": paraData,
  //   });
  // }

  /*收藏消息-收藏消息
   */
  static Future<RequestResult<EmptyModel>> collectMessages(
      {required List<V2TimMessage> messageList, String? groupId}) async {
    List<String> paraData = [];
    for (var e in messageList) {
      final value = await ImMessageUtils.getMessageResourcesData(message: e);
      if (value == null) {
        ABToast.show("消息解析失败");
        return Future.value(RequestResult(null, ErrorMessageModel(code: 5000, message: "消息解析失败")));
      }
      int type = 0;
      switch (e.elemType) {
        case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
          type = 1;
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
          type = 0;
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
          type = 3;
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
          type = 5;
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
          type = 6;
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_FILE:
          type = 7;
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
          type = 4;
          break;
        case MessageElemType.V2TIM_ELEM_TYPE_FACE:
          type = 2;
          break;
        default:
          type = 0;
      }
      Map<String, dynamic> map = {
        "level": groupId == null ? 1 : 2,
        "value": value,
        "groupId": groupId ?? "",
        "fromMemberId": e.sender,
        "type": type,
        "messageTime": e.timestamp ?? 0,
      };
      paraData.add(jsonEncode(map));
    }
    return ABNet.request(path: messageCollectApi, method: HttpMethod.post, params: {
      "messageCollectDtoList": paraData,
    });
  }

  /* 收藏消息-收藏消息详情
  * */
  static Future<RequestResult<CollectionDetailsModel>> mineMessageGetDetails(
      {required int collectId, required int pageNum, int? pageSize = 10}) {
    return ABNet.request(path: messageGetDetails, method: HttpMethod.get, params: {
      "collectId": collectId,
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
  }

  /* 收藏消息-取消该次收藏
  * */
  static Future<RequestResult<EmptyModel>> mineCancelCollect({required int collectId}) {
    return ABNet.request(path: cancelCollect, method: HttpMethod.get, params: {
      "collectId": collectId,
    });
  }

  /* 收藏消息-取消该收藏消息
  * */
  static Future<RequestResult<EmptyModel>> mineCancelMessage({required int collectId, required int messageId}) {
    return ABNet.request(path: cancelMessage, method: HttpMethod.get, params: {
      "collectId": collectId,
      "messageId": messageId,
    });
  }

  // 获取我的关注粉丝列表
  // type: 1,关注列表 2,粉丝列表
  static Future<RequestResult<PageModel<FollowUserListModel>>> getMyFollowFansList({required int pageNum, int? pageSize = 10, int type = 1}) {
    return ABNet.requestPage(path: getFocusListApi, method: HttpMethod.get, params: {
      "pageNum": pageNum,
      "pageSize": pageSize,
      "type": type,
    },
      isShowTip: false
    );
  }

  // 关注用户
  // isFocus：true 关注 false 取消关注
  static Future<RequestResult<EmptyModel>> followUser({required String userId, required bool isFollow}) {
    return ABNet.request(path: focusApi, method: HttpMethod.get, params: {
      "memberNum": userId,
      "type": isFollow ? "focus" : "notFocus",
    });
  }

  // 获取我的关注粉丝列表
  // type: 1-昨日列表；2-我的访问
  static Future<RequestResult<PageModel<FollowUserListModel>>> mineGetLookMeList({required int pageNum, int? pageSize
  = 10, int type
  = 1}) {
    return ABNet.requestPage(path: getLookMeList, method: HttpMethod.get, params: {
      "pageNum": pageNum,
      "pageSize": pageSize,
      "type": type,
    },
        isShowTip: false
    );
  }

}

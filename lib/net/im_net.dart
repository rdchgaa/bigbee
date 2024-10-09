import 'package:bee_chat/models/im/notice_details_model.dart';
import 'package:bee_chat/models/im/system_message_model.dart';
import 'package:bee_chat/net/api.dart';

import '../models/common/empty_model.dart';
import '../models/im/custom_emoji_model.dart';
import '../models/im/notice_list_model.dart';
import '../utils/net/ab_Net.dart';
import '../utils/net/net_model.dart';

class ImNet {

  // 获取系统消息列表
  static Future<RequestResult<PageModel<SystemMessageModel>>> systemMessageList({int page = 1, int pageSize = 20}) async {
    return ABNet.requestPage<SystemMessageModel>(path: getSystemMessageListApi, method: HttpMethod.get, params: {
      "pageNum": page,
      "pageSize": pageSize
    }, isShowTip: false);
  }

  // 确定消息
  static Future<RequestResult<EmptyModel>> confirmMessage({required int messageId, required int status}) async {
    return ABNet.request<EmptyModel>(path: confirmMessageApi, method: HttpMethod.post, params: {
      "messageId": messageId,
      "status": status
    });
  }

  // 公告-公告列表
  static Future<RequestResult<PageModel<NoticeListModel>>> noticeList({int page = 1, int pageSize = 20}) async {
    return ABNet.requestPage<NoticeListModel>(path: getNoticeListApi, method: HttpMethod.get, params: {
      "pageNum": page,
      "pageSize": pageSize
    }, isShowTip: false);
  }

  // 公告-公告详情
  static Future<RequestResult<NoticeDetailsModel>> noticeDetails({required int noticeId}) async {
    return ABNet.request<NoticeDetailsModel>(path: getNoticeDetailApi, method: HttpMethod.get, params: {
      "noticeId": noticeId
    });
  }



  // 自定义表情列表
  static Future<RequestResult<List<CustomEmojiModel>>> customEmojiList() async {
    return ABNet.request<List<CustomEmojiModel>>(path: getCustomEmojiListApi, method: HttpMethod.get);
  }

  // 删除消息
  static Future<RequestResult<EmptyModel>> deleteMessage({required int messageId}) async {
    return ABNet.request<EmptyModel>(path: deleteMessageApi, method: HttpMethod.get, params: {
      "id": messageId
    });
  }



}
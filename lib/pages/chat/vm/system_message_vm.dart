import 'package:bee_chat/models/im/system_message_model.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../net/im_net.dart';
import '../../../utils/ab_loading.dart';
import '../../../utils/ab_toast.dart';

class SystemMessageVm  extends ChangeNotifier {
  List<SystemMessageModel> get resultList => _resultList;
  List<SystemMessageModel> _resultList = [];
  int _page = 1;
  int _pageSize = 20;
  bool hasMore = false;

  SystemMessageVm();

  Future<List<SystemMessageModel>> refresh() async {
    _page = 1;
    _resultList = [];
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<SystemMessageModel>> loadMore() async {
    _page++;
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }

  deleteMessage(int messageId) async {
    _resultList.removeWhere((e) {
      return e.messageId == messageId;
    });
    notifyListeners();
  }



  Future<List<SystemMessageModel>> _requestData() async {
    final result = await ImNet.systemMessageList(page: _page, pageSize: _pageSize);
    return Future.value(result.data?.records ?? []);
  }

  Future<void> confirmMessage({required SystemMessageModel model, required bool isAgree}) async {
    final result = await ImNet.confirmMessage(messageId: model.messageId ?? 0, status: (isAgree? 2 : 3));
    if (result.data != null) {
      _resultList = _resultList.map((e) {
        if (e.messageId == model.messageId) {
          e.status = isAgree? 2 : 3;
        }
        return e;
      }).toList();
      if (isAgree) {
        _joinToGroup(model.groupId ?? '', num: 3);
      }
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> _joinToGroup(String groupID, {int num = 0}) async {
    ABLoading.show();
    final result = await TIMUIKitCore.getSDKInstance().joinGroup(groupID: groupID, message: '');
    await ABLoading.dismiss();
    if (result.code != 0) {
      if (num > 0) {
        _joinToGroup(groupID, num: num-1);
        return;
      } else {
        ABToast.show(result.desc);
      }
      return;
    }
  }

}
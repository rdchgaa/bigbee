
import 'package:bee_chat/net/mine_net.dart';
import 'package:flutter/cupertino.dart';

import '../../../models/user/follow_user_list_model.dart';

class MineLookListVm extends ChangeNotifier  {

  MineLookListType type;
  List<FollowUserListModel> get resultList => _resultList;
  List<FollowUserListModel> _resultList = [];
  int _page = 1;
  final int _pageSize = 10;
  bool hasMore = false;
  int totalCount = 0;

  MineLookListVm({this.type = MineLookListType.lookMe});


  Future<List<FollowUserListModel>> refreshData() async {
    _page = 1;
    _resultList = [];
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<FollowUserListModel>> loadMore() async {
    _page++;
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<FollowUserListModel>> _requestData() async {
    var result = await MineNet.mineGetLookMeList(pageNum: _page, pageSize: _pageSize, type: type.typeValue);
    if (result.data != null) {
      totalCount = result.data?.total ?? 0;
    }
    return Future.value(result.data?.records ?? []);

  }


  // 关注/取消关注
  Future<bool> changeFollowStatus(String memberNum,{int? oldFollow}) async {
    var toFollow = (oldFollow==0||oldFollow==2);
    var result = await MineNet.followUser(userId: memberNum, isFollow: toFollow);
    if (result.data != null) {
      if (!toFollow && type == MineLookListType.lookMe) {
        _resultList.removeWhere((element) => element.memberNum == memberNum);
        notifyListeners();
      }
      // 设置对应的关注状态
      if (type == MineLookListType.lookHe)  {
        int value = oldFollow==0?1:oldFollow==1?0:oldFollow==2?3:oldFollow==3?2:0;
        _resultList.firstWhere((element) => element.memberNum == memberNum).isFocus = value;
        notifyListeners();
      }

    }
    return Future.value(result.data != null);
  }



}

enum MineLookListType {
  lookMe,
  lookHe,
}

extension MineFollowFansListTypeExtension on MineLookListType {
  int get typeValue {
    int typeNum = 1;
    switch (this) {
      case MineLookListType.lookMe:
        typeNum = 1;
        break;
      case MineLookListType.lookHe:
        typeNum = 2;
        break;
    }
    return typeNum;
  }
}
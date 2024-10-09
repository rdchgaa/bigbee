
import 'package:bee_chat/net/mine_net.dart';
import 'package:flutter/cupertino.dart';

import '../../../models/user/follow_user_list_model.dart';

class MineFollowFansListVM extends ChangeNotifier  {

  MineFollowFansListType type;
  List<FollowUserListModel> get resultList => _resultList;
  List<FollowUserListModel> _resultList = [];
  int _page = 1;
  final int _pageSize = 10;
  bool hasMore = false;
  int totalCount = 0;

  MineFollowFansListVM({this.type = MineFollowFansListType.follow});


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
    var result = await MineNet.getMyFollowFansList(pageNum: _page, pageSize: _pageSize, type: type.typeValue);
    if (result.data != null) {
      totalCount = result.data?.total ?? 0;
    }
    return Future.value(result.data?.records ?? []);

  }


  // 关注/取消关注
  Future<bool> changeFollowStatus(String memberNum, bool isFollow) async {
    var result = await MineNet.followUser(userId: memberNum, isFollow: isFollow);
    if (result.data != null) {
      if (!isFollow && type == MineFollowFansListType.follow) {
        _resultList.removeWhere((element) => element.memberNum == memberNum);
        notifyListeners();
      }
      // 设置对应的关注状态
      if (type == MineFollowFansListType.fans) {
        _resultList.firstWhere((element) => element.memberNum == memberNum).isFocus = isFollow ? 3 : 2;
        notifyListeners();
      }

    }
    return Future.value(result.data != null);
  }



}

enum MineFollowFansListType {
  follow,
  fans,
}

extension MineFollowFansListTypeExtension on MineFollowFansListType {
  int get typeValue {
    int typeNum = 1;
    switch (this) {
      case MineFollowFansListType.follow:
        typeNum = 1;
        break;
      case MineFollowFansListType.fans:
        typeNum = 2;
        break;
    }
    return typeNum;
  }
}
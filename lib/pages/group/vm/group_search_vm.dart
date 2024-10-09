import 'package:bee_chat/models/group/group_list_model.dart';
import 'package:bee_chat/net/group_net.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class GroupSearchVm extends ChangeNotifier {
  List<GroupListModel> get resultList => _resultList;
  List<GroupListModel> _resultList = [];
  String _searchText = "";
  int _page = 1;
  int _pageSize = 20;
  bool hasMore = false;

  GroupSearchVm();

  Future<List<GroupListModel>> search(String text) async {
    _page = 1;
    _searchText = text;
    _resultList = [];
    if (text.isEmpty) {
      hasMore = false;
      notifyListeners();
      return _resultList;
    }
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    print("搜索完毕");
    return _resultList;
  }


  Future<List<GroupListModel>> loadMore() async {
    _page++;
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<GroupListModel>> _requestData() async {
    final result = await GroupNet.searchGroup(groupName: _searchText, page: _page, pageSize: _pageSize);
    return Future.value(result.data?.records ?? []);

  }
}
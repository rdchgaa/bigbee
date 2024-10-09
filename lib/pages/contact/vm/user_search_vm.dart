import 'package:bee_chat/models/user/user_list_model.dart';
import 'package:flutter/material.dart';

import '../../../net/user_net.dart';
import '../contact_page.dart';

class UserSearchVm extends ChangeNotifier {
  List<UserListModel> get resultList => _resultList;
  List<UserListModel> _resultList = [];
  String _searchText = "";
  int _page = 1;
  int _pageSize = 20;
  bool hasMore = false;

  UserSearchVm();

  Future<List<UserListModel>> search(String text) async {
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


  Future<List<UserListModel>> loadMore() async {
    _page++;
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<UserListModel>> _requestData() async {
    final result = await UserNet.userList(nickName: _searchText, page: _page, pageSize: _pageSize);
    return Future.value(result.data?.records ?? []);

  }

}
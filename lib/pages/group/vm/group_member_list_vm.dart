import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import '../../../models/group/group_list_model.dart';
import '../../../models/group/group_member_list_model.dart';
import '../../../net/group_net.dart';

class GroupMemberListVm  extends ChangeNotifier {
  List<GroupMemberListModel> get resultList => _resultList;
  List<GroupMemberListModel> _resultList = [];
  String _searchText = "";
  int _page = 1;
  int _pageSize = 20;
  bool hasMore = false;
  String groupID;
  bool isShowMe;
  bool isOnlyOrdinaryGroupMemberList;
  // 排除成员Id列表
  final List<String> excludeMemberIds;

  GroupMemberListVm({required this.groupID, this.isShowMe = true, this.excludeMemberIds = const [], this.isOnlyOrdinaryGroupMemberList = false});

  Future<List<GroupMemberListModel>> search(String text) async {
    _page = 1;
    _searchText = text;
    _resultList = [];
    // if (text.isEmpty) {
    //   hasMore = false;
    //   notifyListeners();
    //   return _resultList;
    // }
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re.where((e){
      return isShowMe || e.memberNum != ABSharedPreferences.getUserIdSync();
    }).toList();
    notifyListeners();
    return _resultList;
  }


  Future<List<GroupMemberListModel>> loadMore() async {
    _page++;
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<GroupMemberListModel>> _requestData() async {
    if (isOnlyOrdinaryGroupMemberList) {
      final result = await GroupNet.getOrdinaryGroupMemberList(groupID: groupID, memberName: _searchText, page: _page, pageSize: _pageSize, excludeMemberIds: excludeMemberIds);
      return Future.value(result.data?.records ?? []);
    }
    final result = await GroupNet.searchGroupMember(groupID: groupID, memberName: _searchText, page: _page, pageSize: _pageSize, excludeMemberIds: excludeMemberIds);
    return Future.value(result.data?.records ?? []);

  }
}
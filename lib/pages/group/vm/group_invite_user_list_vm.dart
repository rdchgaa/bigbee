import 'package:flutter/cupertino.dart';

import '../../../models/group/group_member_invite_model.dart';
import '../../../net/group_net.dart';

class GroupInviteUserListVm  extends ChangeNotifier {
  List<GroupMemberInviteModel> get resultList => _resultList;
  List<GroupMemberInviteModel> _resultList = [];
  String _searchText = "";
  int _page = 1;
  int _pageSize = 20;
  bool hasMore = false;
  String groupID;

  GroupInviteUserListVm({required this.groupID});

  Future<List<GroupMemberInviteModel>> search(String text) async {
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
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<GroupMemberInviteModel>> loadMore() async {
    _page++;
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<GroupMemberInviteModel>> _requestData() async {
    final result = await GroupNet.inviteUserList(groupID: groupID, memberName: _searchText, page: _page, pageSize: _pageSize);
    return Future.value(result.data?.records ?? []);

  }
}
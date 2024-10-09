import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:flutter/cupertino.dart';

class DynamicListVM extends ChangeNotifier  {
  DynamicListType type;
  // 是否是自己
  bool isMine;
  String? memberNum;
  List<PostsHotRecommendListRecords> get resultList => _resultList;
  List<PostsHotRecommendListRecords> _resultList = [];
  int _page = 1;
  final int _pageSize = 10;
  bool hasMore = false;
  int totalCount = 0;

  DynamicListVM({this.type = DynamicListType.all, this.isMine = false, this.memberNum});

  //删除
  Future<void> deletePost(String postId) async {
    _resultList.removeWhere((element) => element.postId.toString() == postId);
    notifyListeners();
  }

  Future<List<PostsHotRecommendListRecords>> refreshData() async {
    _page = 1;
    _resultList = [];
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<PostsHotRecommendListRecords>> loadMore() async {
    _page++;
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<PostsHotRecommendListRecords>> _requestData() async {
    if (isMine) {
      var result = await DynamicsNet.getMyPostsList(pageNum: _page, pageSize: _pageSize, type: type.typeValue);
      if (result.data != null) {
        totalCount = result.data?.total ?? 0;
      }
      return Future.value(result.data?.records ?? []);
    } else {
      var result = await DynamicsNet.getUserPostsLists(pageNum: _page, pageSize: _pageSize, memberNum: memberNum ?? "");
      if (result.data != null) {
        totalCount = result.data?.total ?? 0;
      }
      return Future.value(result.data?.records ?? []);
    }

  }



}

enum DynamicListType {
  all,
  video,
  image,
  text,
}
extension DynamicListTypeExtension on DynamicListType {
  int get typeValue {
    int typeNum = 0;
    switch (this) {
      case DynamicListType.all:
        typeNum = 0;
        break;
      case DynamicListType.video:
        typeNum = 1;
        break;
      case DynamicListType.image:
        typeNum = 2;
        break;
      case DynamicListType.text:
        typeNum = 3;
        break;
    }
    return typeNum;
  }
}
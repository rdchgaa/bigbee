import 'package:flutter/cupertino.dart';

import '../../../models/im/notice_list_model.dart';
import '../../../net/im_net.dart';


class NoticeListVM   extends ChangeNotifier {
  List<NoticeListModel> get resultList => _resultList;
  List<NoticeListModel> _resultList = [];
  int _page = 1;
  int _pageSize = 20;
  bool hasMore = false;

  NoticeListVM();

  Future<List<NoticeListModel>> refresh() async {
    _page = 1;
    _resultList = [];
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<NoticeListModel>> loadMore() async {
    _page++;
    final re = await _requestData();
    hasMore = re.length >= _pageSize;
    _resultList += re;
    notifyListeners();
    return _resultList;
  }


  Future<List<NoticeListModel>> _requestData() async {
    final result = await ImNet.noticeList(page: _page, pageSize: _pageSize);
    return Future.value(result.data?.records ?? []);
  }
}
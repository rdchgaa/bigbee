import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dynamic/search/widget/dynamic_search_history_widget.dart';
import 'package:bee_chat/pages/dynamic/search/widget/search_bar_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_item.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../../widget/search_history_widget.dart';

class DynamicSearchPage extends StatefulWidget {
  const DynamicSearchPage({super.key});

  @override
  State<DynamicSearchPage> createState() => _DynamicSearchPageState();
}

class _DynamicSearchPageState extends State<DynamicSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  /// 是否显示历史记录
  bool isShowHistory = true;

  /// 是否需要刷新历史记录
  bool isneedRefreshHistory = true;

  /// 是否需要取消输入
  bool isNeedCancelInput = true;

  int pageNum = 1;
  bool hasMore = false;

  List<PostsHotRecommendListRecords> hotRecommendList = [];

  @override
  void initState() {
    super.initState();
  }

  getHotRecommendListData(String searchKey) async {
    pageNum = 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsSearchPosts(pageNum: pageNum, searchKey: searchKey);
    if (resultRecords.data != null) {
      hotRecommendList = resultRecords.data?.records ?? [];
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  onMore(String searchKey) async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsSearchPosts(pageNum: pageNum, searchKey: searchKey);
    if (resultRecords.data != null) {
      hotRecommendList.addAll(resultRecords.data?.records ?? []);
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  void _showHistoryWidget() {
    print("显示历史记录");
    setState(() {
      isShowHistory = true;
    });
  }

  /// 隐藏历史记录界面
  void _hiddentHistoryWidget() {
    print("隐藏历史记录");
    setState(() {
      isShowHistory = false;
    });
  }

  // 保存搜索历史
  Future<void> _saveHistory(String text) async {
    print("保存搜索历史");
    await ABSharedPreferences.addSearchHistory(text);
    setState(() {
      isneedRefreshHistory = true;
    });
  }

  /// 搜索
  void _doSearch(String text) {
    _searchController.text = text;
    isNeedCancelInput = true;
    _hiddentHistoryWidget();
    setState(() {});
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    getHotRecommendListData(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: AppBarSearch(
        backgroundColor: theme.backgroundColor,
        textFieldHeight: 48,
        controller: _searchController,
        borderRadius: 6,
        onSearch: (String text) {
          _hiddentHistoryWidget();
          _saveHistory(text);
          _doSearch(text);
          setState(() {});
        },
        onFocusStatus: (bool isFocus) {
          if (isFocus) {
            _showHistoryWidget();
          }
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: searchResultWidget(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Offstage(
              offstage: !isShowHistory,
              child: Container(
                  color: Colors.white,
                  child: DynamicSearchHistoryWidget(
                    isNeedRefreshHistory: isneedRefreshHistory,
                    onSearch: (text) {
                      _saveHistory(text);
                      _doSearch(text);
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchResultWidget() {
    final theme = AB_theme(context);
    return EasyRefresh(
      header: CustomizeBallPulseHeader(color: theme.primaryColor),
      onRefresh: () async {
        getHotRecommendListData(_searchController.text);
      },
      onLoad: !hasMore
          ? null
          : () async {
              onMore(_searchController.text);
            },
      child: hotRecommendList.length == 0
          ? Center(
              child: Image.asset(ABAssets.emptyIcon(context)),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                var item = hotRecommendList[index];
                return DynamicListItem(
                  key:ValueKey(item.postId),
                  model: item,
                  deleteCall: (){
                    hotRecommendList.removeAt(index);
                    setState(() {});
                  },
                );
              },
              itemCount: hotRecommendList.length,
            ),
    );
  }
}

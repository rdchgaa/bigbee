import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_item.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class LikeListWidget extends StatefulWidget {
  const LikeListWidget({
    super.key,
  });

  @override
  State<LikeListWidget> createState() => _LikeListWidgetState();
}

class _LikeListWidgetState extends State<LikeListWidget> with AutomaticKeepAliveClientMixin {
  String _searchText = "";

  int pageNum = 1;
  bool hasMore = false;

  List<PostsHotRecommendListRecords> hotRecommendList = [];
  List<PostsHotRecommendListRecords> hotRecommendListSearch = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    getDynamicListData();
  }

  getDynamicListData() async {
    pageNum = 1;
    hasMore = false;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsLikePostsList(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList = resultRecords.data?.records ?? [];
      _doSearch();
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  onDynamicMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsLikePostsList(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList.addAll(resultRecords.data?.records ?? []);
      _doSearch();
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return SizedBox(
      child: Column(
        children: [
          Row(children: [
            _searchWidget().expanded(),
            SizedBox(
              width: 16.px,
            )
          ]).addPadding(padding: EdgeInsets.only(top: 16.px, bottom: 16.px, left: 16.px)),
          SizedBox(
            height: 10.px,
          ),
          Expanded(child: dynamicView())
        ],
      ),
    );
  }

  Widget dynamicView() {
    final theme = AB_theme(context);
    return EasyRefresh(
      header: CustomizeBallPulseHeader(color: theme.primaryColor),
      onRefresh: () async {
        getDynamicListData();
      },
      onLoad: !hasMore
          ? null
          : () async {
              onDynamicMore();
            },
      child: hotRecommendListSearch.length == 0
          ? Center(
              child: Image.asset(ABAssets.emptyIcon(context)),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                var item = hotRecommendListSearch[index];
                return DynamicListItem(
                  key:ValueKey(item.postId),
                  model: item,
                  deleteCall: () {
                    hotRecommendList.removeAt(index);
                    setState(() {});
                  },
                );
              },
              itemCount: hotRecommendListSearch.length,
            ),
    );
  }

  Widget _searchWidget() {
    final theme = AB_theme(context);
    return Container(
      height: 48.px,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.px),
          // 边框
          border: Border.all(
            color: theme.f4f4f4,
            width: 1.px,
          ),
          color: theme.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ABAssets.homeSearchIcon(context),
            width: 20.px,
            height: 20.px,
          ),
          SizedBox(
            width: 10.px,
          ),
          ABTextField(
            text: _searchText,
            hintText: AB_getS(context).search,
            hintColor: theme.textGrey,
            contentPadding: EdgeInsets.only(bottom: 12.px),
            onChanged: (text) {
              _searchText = text;
              _doSearch();
            },
          ).expanded(),
        ],
      ).addPadding(padding: EdgeInsets.symmetric(horizontal: 12.px)),
    );
  }

  void _doSearch() {
    if (_searchText.isEmpty) {
      setState(() {
        hotRecommendListSearch = hotRecommendList;
      });
      return;
    }
//动态记录
    hotRecommendListSearch = hotRecommendList.where((element) {
      var value = (element.nickName ?? '').contains(_searchText);
      if (value == false) {
        value = (element.textContent ?? '').contains(_searchText);
      }
      return value;
    }).toList();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

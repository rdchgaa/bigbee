import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/models/mine/collection_message_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/net/mine_net.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_item.dart';
import 'package:bee_chat/pages/mine/collection/widget/collection_message_item_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class CollectionListWidgetView extends StatefulWidget {
  const CollectionListWidgetView({
    super.key,
  });

  @override
  State<CollectionListWidgetView> createState() => _CollectionListWidgetViewState();
}

class _CollectionListWidgetViewState extends State<CollectionListWidgetView> with AutomaticKeepAliveClientMixin {
  String _searchText = "";

  int collectionType = 0; //0:动态  1 消息

  List<CollectionMessageListRecords> recordsList = [];
  List<CollectionMessageListRecords> recordsListSearch = [];
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
    // onMessageFresh();
    getDynamicListData();
  }

  onMessageFresh() async {
    pageNum = 1;
    hasMore = false;
    setState(() {});
    if (collectionType == 1) {
      var resultRecords = await MineNet.mineMessageGetList(pageNum: pageNum);
      if (resultRecords.data != null) {
        recordsList = resultRecords.data?.records ?? [];
        _doSearch();
        hasMore = recordsList.length < (resultRecords.data?.total ?? 0);
        setState(() {});
      }
    }
  }

  onMessageMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await MineNet.mineMessageGetList(pageNum: pageNum);
    if (resultRecords.data != null) {
      recordsList.addAll(resultRecords.data?.records ?? []);
      _doSearch();
      hasMore = recordsList.length < (resultRecords.data?.total ?? 0);
    }
    setState(() {});
  }

  getDynamicListData() async {
    pageNum = 1;
    hasMore = false;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsGetCollectPostsList(pageNum: pageNum);
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
    var resultRecords = await DynamicsNet.dynamicsGetCollectPostsList(pageNum: pageNum);
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
          typeWidget(),
          SizedBox(
            height: 10.px,
          ),
          Expanded(child: collectionType == 0 ? dynamicView() : messageView())
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
                  deleteCall: (){
                    hotRecommendList.removeAt(index);
                    setState(() {});
                  },
                );
              },
              itemCount: hotRecommendListSearch.length,
            ),
    );
  }

  Widget messageView() {
    final theme = AB_theme(context);
    return EasyRefresh(
      header: CustomizeBallPulseHeader(color: theme.primaryColor),
      onRefresh: () async {
        onMessageFresh();
      },
      onLoad: !hasMore
          ? null
          : () async {
              onMessageMore();
            },
      child: recordsListSearch.isEmpty
          ? Container(
              alignment: Alignment.center,
              color: theme.backgroundColor,
              child: Image.asset(ABAssets.emptyIcon(context)),
            )
          : ListView.separated(
              padding: EdgeInsets.only(bottom: 20.px),
              itemBuilder: (context, index) {
                CollectionMessageListRecords item = recordsListSearch[index];
                return CollectionMessageItemWidget(
                  item: item,
                  cancelCollectionCallback: () {
                    onMessageFresh();
                  },
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10.px,
                );
              },
              itemCount: recordsListSearch.length),
    );
  }

  Widget typeWidget() {
    final theme = AB_theme(context);
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0.px),
          child: InkWell(
            onTap: () {
              collectionType = 0;
              setState(() {});
              getDynamicListData();
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: collectionType == 0 ? theme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20.px),
              ),
              child: SizedBox(
                height: 32.px,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.px,
                  ),
                  child: ABText(
                    AB_S().dynamic,
                    textColor: theme.textColor,
                    fontSize: 14.px,
                    fontWeight: collectionType == 0 ? FontWeight.w600 : FontWeight.normal,
                  ).center,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0.px),
          child: InkWell(
            onTap: () {
              collectionType = 1;
              setState(() {});
              onMessageFresh();
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: collectionType == 1 ? theme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20.px),
              ),
              child: SizedBox(
                height: 32.px,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.px,
                  ),
                  child: ABText(
                    AB_S().message,
                    textColor: theme.textColor,
                    fontSize: 14.px,
                    fontWeight: collectionType == 1 ? FontWeight.w600 : FontWeight.normal,
                  ).center,
                ),
              ),
            ),
          ),
        ),
      ],
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
        recordsListSearch = recordsList;
      });
      return;
    }

    if (collectionType == 0) {
      //动态记录
      hotRecommendListSearch = hotRecommendList.where((element) {
        var value = (element.nickName ?? '').contains(_searchText);
        if (value == false) {
          value = (element.textContent ?? '').contains(_searchText);
        }
        return value;
      }).toList();
    } else if (collectionType == 0) {
      // 消息记录
      recordsListSearch = recordsList.where((element) {
        var value = (element.formNickName ?? '').contains(_searchText);
        if (value == false) {
          for (var i = 0; i < (element.searchMessageList?.length ?? 0); i++) {
            var item = element.searchMessageList?[i];
            if (item?.type == 1 || item?.type == 2) {
              //1，文字；2，表情；
              if ((item?.value ?? '').contains(_searchText)) {
                value = true;
              }
            }
          }
        }

        return value;
      }).toList();
    }
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

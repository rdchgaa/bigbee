import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dynamic/dynamic_details_page.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_hot_user_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_item.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class DynamicHotWidget extends StatefulWidget {
  const DynamicHotWidget({super.key});

  @override
  State<DynamicHotWidget> createState() => DynamicHotWidgetState();
}

class DynamicHotWidgetState extends State<DynamicHotWidget> {
  int pageNum = 1;
  List<PostsHotRecommendModel> hotUserList = [];
  bool hasMore = false;

  List<PostsHotRecommendListRecords> hotRecommendList = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    getHotUserData();
    getHotRecommendListData();
  }

  getHotUserData() async {
    var resultRecords = await DynamicsNet.dynamicsPostsHotRecommend(pageNum: 1);
    if (resultRecords.data != null) {
      hotUserList = resultRecords.data ?? [];
      setState(() {});
    }
  }

  getHotRecommendListData() async {
    pageNum = 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsHotRecommendList(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList = resultRecords.data?.records ?? [];
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  onMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsHotRecommendList(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList.addAll(resultRecords.data?.records ?? []);
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return EasyRefresh(
      header: CustomizeBallPulseHeader(color: theme.primaryColor),
      onRefresh: () async {
        initData();
      },
      onLoad: !hasMore
          ? null
          : () async {
              onMore();
            },
      child: hotRecommendList.length == 0
          ? Center(
              child: Image.asset(ABAssets.emptyIcon(context)),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return DynamicHotUserWidget(userAvatarUrls: hotUserList);
                }
                var item = hotRecommendList[index - 1];
                return DynamicListItem(
                  key:ValueKey(item.postId),
                  model: item,
                  deleteCall: (){
                    hotRecommendList.removeAt(index- 1);
                    setState(() {});
                  },
                );
              },
              itemCount: hotRecommendList.length + 1,
            ),
    );
  }
}

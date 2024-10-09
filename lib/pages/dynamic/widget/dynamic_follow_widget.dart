import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_item.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import 'dynamic_list_widget.dart';

class DynamicFollowWidget extends StatefulWidget {
  final isSquare;
  const DynamicFollowWidget({super.key, this.isSquare = false});

  @override
  State<DynamicFollowWidget> createState() => DynamicFollowWidgetState();
}

class DynamicFollowWidgetState extends State<DynamicFollowWidget> {
  int pageNum = 1;
  bool hasMore = false;

  List<PostsHotRecommendListRecords> hotRecommendList = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    getHotRecommendListData();
  }

  getHotRecommendListData() async {
    pageNum = 1;
    setState(() {});
    if (widget.isSquare) {
      var resultRecords = await DynamicsNet.dynamicsSquareRecommendList(pageNum: pageNum);
      if (resultRecords.data != null) {
        hotRecommendList = resultRecords.data?.records ?? [];
        hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
        setState(() {});
      }
      return;
    }
    var resultRecords = await DynamicsNet.dynamicsFocusRecommendList(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList = resultRecords.data?.records ?? [];
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  onMore() async {
    pageNum += 1;
    setState(() {});
    if (widget.isSquare) {
      var resultRecords = await DynamicsNet.dynamicsSquareRecommendList(pageNum: pageNum);
      if (resultRecords.data != null) {
        hotRecommendList.addAll(resultRecords.data?.records ?? []);
        hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
        setState(() {});
      }
      return;
    }
    var resultRecords = await DynamicsNet.dynamicsFocusRecommendList(pageNum: pageNum);
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

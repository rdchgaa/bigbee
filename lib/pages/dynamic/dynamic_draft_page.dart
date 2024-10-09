import 'package:bee_chat/models/dynamic/draft_box_list_model.dart';
import 'package:bee_chat/models/dynamic/look_history_posts_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dynamic/dynamic_details_page.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_draft_item.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_hot_user_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_item.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_views_item.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';
import 'package:collection/collection.dart';

class DynamicDraftPage extends StatefulWidget {
  const DynamicDraftPage({super.key});

  @override
  State<DynamicDraftPage> createState() => _DynamicDraftPageState();
}

class _DynamicDraftPageState extends State<DynamicDraftPage> {
  int pageNum = 1;
  bool hasMore = false;

  List<DraftBoxListRecords> hotRecommendList = [];

  List<DraftBoxListRecords> selectList = [];
  bool isChoice = false;

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
    selectList = [];
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsDraftBoxList(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList = resultRecords.data?.records ?? [];
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  onMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsDraftBoxList(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList.addAll(resultRecords.data?.records ?? []);
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  toDelete() async {
    List<String> postsId = [];
    for (var i = 0; i < selectList.length; i++) {
      if (selectList[i].id != null) {
        postsId.add(selectList[i].id .toString());
      }
    }
    var resultRecords = await DynamicsNet.dynamicsRemovePosts(postsId: postsId);
    if (resultRecords.success == true) {
      ABToast.show(AB_S().deleteSuccess, toastType: ToastType.success);
      selectList = [];
      isChoice = false;
      setState(() {});
      initData();
    } else {
      ABToast.show(AB_S().deleteFailed, toastType: ToastType.fail);
    }
  }

  tuPush(DraftBoxListRecords item) async{
    var resultRecords = await DynamicsNet.dynamicsDraftBoxOPublish(postsId: int.tryParse(item.id??'')??0);
    if (resultRecords.success == true) {
      ABToast.show(AB_S().success, toastType: ToastType.success);
      initData();
    } else {
      ABToast.show(AB_S().fail, toastType: ToastType.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);

    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).draftBox,
        backgroundWidget: Container(
          // 渐变色
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                HexColor("#FFDC79"),
                HexColor("#FFCB32"),
              ],
            ),
          ),
        ),
        rightWidget: InkWell(
          onTap: () {
            isChoice = !isChoice;
            setState(() {});
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16.px, right: 16.px),
            child: Center(
                child: ABText(
              isChoice ? AB_getS(context).cancel : AB_getS(context).choice,
              fontSize: 16.px,
              textColor: theme.text282109,
            )),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: EasyRefresh(
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
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        var item = hotRecommendList[index];
                        var isSelect = false;
                        if (selectList.contains(item)) {
                          isSelect = true;
                        }
                        return InkWell(
                          onTap: () {
                            if (isChoice) {
                              if (item.id == null) return;
                              if (isSelect) {
                                selectList.remove(item);
                              } else {
                                selectList.add(item);
                              }
                              setState(() {});
                            } else {
                              // ABRoute.push(DynamicDetailsPage(
                              //   postsId: item.postsId!,
                              // ));
                            }
                          },
                          child: Stack(
                            children: [
                              DynamicDraftItem(
                                model: item,
                              ),
                              (isChoice)
                                  ? Positioned(
                                right: 16.px,
                                top: 16.px,
                                      child: Image.asset(
                                        isSelect ? ABAssets.assetsSelect(context) : ABAssets.assetsUnSelect(context),
                                        width: 24.px,
                                        height: 24.px,
                                      ),
                                    )
                                  : Positioned(
                                      right: 16.px,
                                      top: 16.px,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: ABButton(
                                          text: "${AB_S().push}",
                                          backgroundColor: theme.primaryColor,
                                          cornerRadius: 6,
                                          height: 33.px,
                                          width: 68.px,
                                          textColor: theme.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          onPressed: () async {
                                            tuPush(item);
                                          },
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                      itemCount: hotRecommendList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 16.px, right: 16.px),
                          child: Divider(
                            height: 1,
                            color: theme.f4f4f4,
                          ),
                        );
                      },
                    ),
            ),
          ),
          if (isChoice)
            ColoredBox(
              color: theme.white,
              child: Column(
                children: [
                  Divider(
                    height: 1,
                    color: theme.f4f4f4,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 20.px, bottom: 24.px),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (hotRecommendList.length == selectList.length) {
                              selectList = [];
                            } else {
                              selectList = hotRecommendList;
                            }
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                hotRecommendList.length == selectList.length
                                    ? ABAssets.assetsSelect(context)
                                    : ABAssets.assetsUnSelect(context),
                                width: 24.px,
                                height: 24.px,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16.px, right: 16.px),
                                child: ABText(
                                  AB_getS(context).selectAll,
                                  fontSize: 16.px,
                                  textColor: theme.text282109,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 24.px,
                            ),
                            child: ABButton.gradientColorButton(
                              colors: selectList.length > 0
                                  ? [theme.primaryColor, theme.secondaryColor]
                                  : [theme.textGrey, theme.textGrey],
                              cornerRadius: 12,
                              height: 48.px,
                              text: '${AB_getS(context).delete} (${selectList.length})',
                              onPressed: () {
                                if (selectList.isNotEmpty) {
                                  toDelete();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

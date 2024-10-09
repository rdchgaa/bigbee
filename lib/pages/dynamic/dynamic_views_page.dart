import 'package:bee_chat/models/dynamic/look_history_posts_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dynamic/dynamic_details_page.dart';
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

class DynamicViewsPage extends StatefulWidget {
  const DynamicViewsPage({super.key});

  @override
  State<DynamicViewsPage> createState() => _DynamicViewsPageState();
}

class _DynamicViewsPageState extends State<DynamicViewsPage> {
  int pageNum = 1;
  bool hasMore = false;

  List<LookHistoryPostsRecords> hotRecommendList = [];

  List<LookHistoryPostsRecords> selectList = [];
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
    var resultRecords = await DynamicsNet.dynamicsLookHistoryPosts(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList = resultRecords.data?.records ?? [];
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  onMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsLookHistoryPosts(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList.addAll(resultRecords.data?.records ?? []);
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  toDelete() async{
    List<String> postsId = [];
    for(var i = 0 ; i<selectList.length;i++){
      if(selectList[i].postsId != null){
        postsId.add(selectList[i].postsId.toString());
      }
    }
    var resultRecords = await DynamicsNet.dynamicsDeleteHistoryPosts(postsId: postsId);
    if(resultRecords.success==true){
      ABToast.show(AB_S().deleteSuccess,toastType: ToastType.success);
      selectList= [];
      isChoice = false;
      setState(() {
      });
      initData();
    }else{
      ABToast.show(AB_S().deleteFailed,toastType: ToastType.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);

    List<LookHistoryPostsRecords> listResult = hotRecommendList;
    List<List<LookHistoryPostsRecords>> dayList = [];
    dayList = groupBy(listResult, (element) {
      if (element.lookTime == null) {
        return '';
      }
      // var time = DateTime.fromMillisecondsSinceEpoch((element.lookTime ?? 0) * 1000);
      var time = DateTime.tryParse(element.lookTime ?? '') ?? DateTime.now();
      var year = time.year;
      var month = time.month;
      var day = time.day;
      var value = '$year-$month-$day';
      return value;
    }).values.map((list) => list.toList()).toList();

    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).viewsRecord,
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
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        List<Widget> listBuild = [];
                        for (var i = 0; i < dayList[index].length; i++) {
                          var item = dayList[index][i];
                          var isSelect = false;
                          if (selectList.contains(item)) {
                            isSelect = true;
                          }
                          // for (LookHistoryPostsRecords item in selectList) {
                          //   if (item.msgID == selectItem.msgID) {
                          //     isSelect = true;
                          //     break;
                          //   }
                          // }
                          listBuild.add(Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (isChoice) {
                                    if (item.postsId == null) return;
                                    if (isSelect) {
                                      selectList.remove(item);
                                    } else {
                                      selectList.add(item);
                                    }
                                    setState(() {});
                                  } else {
                                    ABRoute.push(DynamicDetailsPage(
                                      postsId: item.postsId!,
                                    ));
                                  }
                                },
                                child: Stack(
                                  children: [
                                    DynamicViewsItem(
                                      model: item,
                                    ),
                                    if (isChoice)
                                      Positioned(
                                        right: 16.px,
                                        top: 18.px,
                                        child: Image.asset(
                                          isSelect ? ABAssets.assetsSelect(context) : ABAssets.assetsUnSelect(context),
                                          width: 24.px,
                                          height: 24.px,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (i < dayList[index].length - 1)
                                Padding(
                                  padding: EdgeInsets.only(left: 16.px, right: 16.px),
                                  child: Divider(
                                    height: 1,
                                    color: theme.f4f4f4,
                                  ),
                                )
                            ],
                          ));
                        }
                        var time = DateTime.tryParse(dayList[index][0].lookTime ?? '') ?? DateTime.now();
                        var isToday = time.year == DateTime.now().year &&
                            time.month == DateTime.now().month &&
                            time.day == DateTime.now().day;
                        var timeText = isToday
                            ? AB_S().today
                            : '${time.year}${AB_S().year}${time.month}${AB_S().month}${time.day}${AB_S().day}';
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16.0.px, top: 12.px, bottom: 12.px),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(timeText, style: TextStyle(color: theme.textGrey, fontSize: 14.px)),
                              ),
                            ),
                            ...listBuild,
                          ],
                        );
                      },
                      itemCount: dayList.length,
                    ),
              // ListView.separated(
              //         itemBuilder: (context, index) {
              //           var item = hotRecommendList[index];
              //           return DynamicViewsItem(
              //             model: item,
              //           );
              //         },
              //         itemCount: hotRecommendList.length,
              //         separatorBuilder: (BuildContext context, int index) {
              //           return Padding(
              //             padding: EdgeInsets.only(left: 16.px,right: 16.px),
              //             child: Divider(height: 1,color: theme.f4f4f4,),
              //           );
              //         },
              //       ),
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
                            if(hotRecommendList.length == selectList.length){
                              selectList = [];
                            }else{
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
                            padding: EdgeInsets.only(left: 24.px,),
                            child: ABButton.gradientColorButton( 
                              colors: selectList.length>0?[theme.primaryColor, theme.secondaryColor]:[theme.textGrey, theme
                                  .textGrey],
                              cornerRadius: 12,
                              height: 48.px,
                              text: '${AB_getS(context).delete} (${selectList.length})',
                              onPressed: () {
                                if(selectList.isNotEmpty){
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

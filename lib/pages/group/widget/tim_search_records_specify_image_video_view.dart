import 'dart:io';

import 'package:bee_chat/pages/chat/c2c_chat_page.dart';
import 'package:bee_chat/pages/chat/group_chat_page.dart';
import 'package:bee_chat/pages/group/tim_search_records_specify_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_search_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class TimSearchRecordsSpecifyImageVideoView extends StatefulWidget {
  final V2TimConversation conversation;
  const TimSearchRecordsSpecifyImageVideoView({
    super.key,
    required this.conversation, 
  });

  @override
  State<TimSearchRecordsSpecifyImageVideoView> createState() => TimSearchRecordsSpecifyImageVideoViewState();
}

class TimSearchRecordsSpecifyImageVideoViewState extends State<TimSearchRecordsSpecifyImageVideoView>
    with AutomaticKeepAliveClientMixin {
  final model = serviceLocator<TUISearchViewModel>();
  int currentPage = 0;
  bool hasMore = false;

  bool isChoice= false;
  List<V2TimMessage> selectList = [];

  // 主要用来发送消息以及清空聊天记录之类的
  TUIChatSeparateViewModel separateModel = TUIChatSeparateViewModel();
  
  @override
  void initState() {
    super.initState();
    updateMsgResult(true);
  }

  toChoice(bool value){
    isChoice = value;
    setState(() {

    });
  }

  updateMsgResult(bool isNewSearch) async {
    if (isNewSearch) {
      setState(() {
        currentPage = 0;
      });
    }

    await model.getMsgForDate(widget.conversation.conversationID, currentPage, messageTypeList: [3, 5]);
    hasMore = model.totalMsgInConversationCount > model.currentMsgListForConversation.length;
    setState(() {
      currentPage = currentPage + 1;
    });
  }

  doSelect(V2TimMessage item,bool isSelect){
    if (isSelect) {
      selectList.remove(item);
    } else {
      selectList.add(item);
    }
    setState(() {});

    if(separateModel!=null){
      final checked = separateModel!.multiSelectedMessageList.contains(item);
      if (checked) {
        separateModel!.removeFromMultiSelectedMessageList(item);
      } else {
        if (item.status == MessageStatus.V2TIM_MSG_STATUS_SENDING || item.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL) {
          return;
        }
        separateModel!.addToMultiSelectedMessageList(item);
      }
    }
  }

  toChatPage( V2TimConversation con,
   V2TimMessage message){
    if (con.groupID != null) {
      // 群聊
      ABRoute.push(GroupChatPage(selectedConversation: con,v2TimMessage: message,));
      return;
    }else if (con.userID != null) {
      // 单聊
      ABRoute.push(C2cChatPage(selectedConversation: con,v2TimMessage: message,));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);

    var listResult = model.currentMsgListForConversation;
    List<List<V2TimMessage>> dayList = [];
    dayList = groupBy(listResult, (element) {
      if (element.timestamp == null) {
        return '';
      }
      var time = DateTime.fromMillisecondsSinceEpoch((element.timestamp ?? 0) * 1000);
      var year = time.year;
      var month = time.month;
      var value = '$year-$month';
      return value;
    }).values.map((list) => list.toList()).toList();

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(builder: (context, con) {
            return EasyRefresh(
              header: CustomizeBallPulseHeader(color: theme.primaryColor),
              onRefresh: () async {
                updateMsgResult(true);
              },
              onLoad: !hasMore
                  ? null
                  : () async {
                      updateMsgResult(false);
                    },
              child: dayList.isEmpty
                  ? Center(
                      child: Image.asset(ABAssets.emptyIcon(context)),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        var items = dayList[index];
                        var time = DateTime.fromMillisecondsSinceEpoch((items[0].timestamp ?? 0) * 1000);
                        var year = time.year;
                        var month = time.month;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 8.px,
                                  ),
                                  child: Image.asset(
                                    ABAssets.assetsPeopleNum(context),
                                    width: 24.px,
                                    height: 24.px,
                                  ),
                                ),
                                ABText(
                                  year.toString() + '${AB_S().year}' + month.toString() + '${AB_S().month}',
                                  fontSize: 14.px,
                                  textColor: theme.text999,
                                ),
                              ],
                            ).padding(left: 16.px, right: 16.px, top: 8.px, bottom: 8.px),
                            GridView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16.px),
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                //设置列数
                                crossAxisCount: 3,
                                //设置横向间距
                                crossAxisSpacing: 3.px,
                                //设置主轴间距
                                mainAxisSpacing: 3.px,
                                childAspectRatio: 110 / 90,
                              ),
                              shrinkWrap: true,
                              // 避免内部子项的尺寸影响外部容器的高度
                              itemCount: items.length,
                              // 总共20个项目
                              itemBuilder: (context, index) {
                                V2TimMessage item = items[index];
                                var isSelect = false;
                                for (V2TimMessage selectItem in selectList) {
                                  if (item.msgID == selectItem.msgID) {
                                    isSelect = true;
                                    break;
                                  }
                                }
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: theme.f4f4f4
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (isChoice) {
                                        doSelect(item,isSelect);
                                      } else {
                                        // 跳转聊天页面
                                        toChatPage(widget.conversation,item);
                                      }

                                    },
                                    child: Stack(
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            if (item.imageElem != null) {
                                              return imageItemWidget(item);
                                            } else if (item.videoElem != null) {
                                              return videoItemWidget(item);
                                            }
                                            return SizedBox();
                                          }
                                        ),
                                        if (isChoice)
                                          Positioned(
                                            right: 6.px,
                                            top: 6.px,
                                            child: Image.asset(
                                              isSelect ? ABAssets.assetsSelect(context) : ABAssets.assetsUnSelect(context),
                                              width: 24.px,
                                              height: 24.px,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 5.px);
                      },
                      itemCount: dayList.length,
                    ),
            );
          }),
        ),
        if (isChoice)
          TimSearchChoiceButton(
            forward: () async{
              setState(() {
                selectList = [];
              });
              await Future.delayed(Duration(milliseconds: 200));
              updateMsgResult(true);
            },
            collect: () {
              setState(() {
                selectList = [];
              });
            },
            delete: () async{
              setState(() {
                selectList = [];
              });
              await Future.delayed(Duration(milliseconds: 400));
              updateMsgResult(true);
            },
            msgList: selectList,
            conversation: widget.conversation,
            model: separateModel,
          )
      ],
    );
  }

  Widget imageItemWidget(V2TimMessage item) {
    var imagePath = item.imageElem?.path;
    var imageUrl = item.imageElem?.imageList?.first?.url;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: (imagePath != null && imagePath != '')
          ? Image.file(File(imagePath), fit: BoxFit.cover)
          : Image.network(imageUrl!, fit: BoxFit.cover),
    );
  }

  Widget videoItemWidget(V2TimMessage item) {
    V2TimVideoElem videoElem = item.videoElem!;
    return Stack(
      children: [
        SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: (videoElem.snapshotUrl == null || item.status == MessageStatus.V2TIM_MSG_STATUS_SENDING)
                ? ((videoElem.snapshotPath != null && videoElem.snapshotPath != '')
                    ? Image.file(File(videoElem.snapshotPath!), fit: BoxFit.cover)
                    : Image.file(File(videoElem.localSnapshotUrl!), fit: BoxFit.cover))
                : (PlatformUtils().isWeb || videoElem.localSnapshotUrl == null || videoElem.localSnapshotUrl == "")
                    ? Image.network(videoElem.snapshotUrl!, fit: BoxFit.cover)
                    : Image.file(File(videoElem.localSnapshotUrl!), fit: BoxFit.cover)),
        Positioned.fill(
          // alignment: Alignment.center,
          child: Center(child: Image.asset('images/play.png', package: 'tencent_cloud_chat_uikit', height: 64.px)),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

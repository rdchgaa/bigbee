import 'dart:io';

import 'package:bee_chat/models/group/group_member_invite_model.dart';
import 'package:bee_chat/models/group/group_member_list_model.dart';
import 'package:bee_chat/pages/chat/c2c_chat_page.dart';
import 'package:bee_chat/pages/chat/group_chat_page.dart';
import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/pages/group/group_invite_page.dart';
import 'package:bee_chat/pages/group/group_member_choose_page.dart';
import 'package:bee_chat/pages/group/tim_search_records_specify_details_page.dart';
import 'package:bee_chat/pages/group/tim_search_records_specify_page.dart';
import 'package:bee_chat/pages/group/vm/group_member_list_vm.dart';
import 'package:bee_chat/pages/group/widget/group_member_list_item.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:bee_chat/widget/alert_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_search_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_input.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import 'package:collection/collection.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';

class TimSearchRecordsSpecifyLinkView extends StatefulWidget {
  final V2TimConversation conversation;
// 主要用来发送消息以及清空聊天记录之类的
  const TimSearchRecordsSpecifyLinkView({
    super.key,
    required this.conversation,
  });

  @override
  State<TimSearchRecordsSpecifyLinkView> createState() => TimSearchRecordsSpecifyLinkViewState();
}

class TimSearchRecordsSpecifyLinkViewState extends State<TimSearchRecordsSpecifyLinkView>
    with AutomaticKeepAliveClientMixin {
  final model = serviceLocator<TUISearchViewModel>();
  int currentPage = 0;
  bool hasMore = false;
  TextEditingController textEditingController = TextEditingController(text: '');
  final FocusNode focusNode = FocusNode();

  List<V2TimMessage> linkList = [];

  bool isChoice = false;

  List<V2TimMessage> selectList = [];

  // 主要用来发送消息以及清空聊天记录之类的
  TUIChatSeparateViewModel separateModel = TUIChatSeparateViewModel();

  @override
  void initState() {
    super.initState();
    updateMsgResult(true);
  }

  toChoice(bool value) {
    isChoice = value;
    setState(() {});
  }

  updateMsgResult(bool isNewSearch) async {
    if (isNewSearch) {
      setState(() {
        currentPage = 0;
      });
    }

    await model.getMsgForDate(widget.conversation.conversationID, currentPage,
        messageTypeList: [1], keywordList: textEditingController.text.isEmpty ? null : [textEditingController.text]);
    hasMore = model.totalMsgInConversationCount > model.currentMsgListForConversation.length;
    setState(() {
      currentPage = currentPage + 1;
    });
    handleLinkList(model.currentMsgListForConversation);
  }

  handleLinkList(List<V2TimMessage> list) {
    linkList.clear();
    for (var i = 0; i < list.length; i++) {
      V2TimMessage item = list[i];
      if (item.textElem == null) {
        continue;
      }
      final List<String> urlMatches = LinkUtils.getURLMatches(item.textElem?.text ?? '');
      if (urlMatches.isEmpty) {
        continue;
      } else {
        linkList.add(item);
      }
    }
    setState(() {});
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

    var listResult = linkList;
    List<List<V2TimMessage>> monthList = [];
    monthList = groupBy(listResult, (element) {
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
        getSearchWidget(),
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
              child: monthList.isEmpty
                  ? Center(
                      child: Image.asset(ABAssets.emptyIcon(context)),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        var items = monthList[index];
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
                            Column(
                              children: [for (var i = 0; i < items.length; i++) linkItemWidget(items[i])],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 5.px);
                      },
                      itemCount: monthList.length,
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
              await Future.delayed(Duration(milliseconds: 500));
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

  Widget linkItemWidget(V2TimMessage item) {
    final theme = AB_theme(context);
    var imagePath = null;
    if (item.textElem == null) {
      return SizedBox();
    }
    var linkText = '';
    final List<String> urlMatches = LinkUtils.getURLMatches(item.textElem?.text ?? '');
    if (urlMatches.isEmpty) {
      return SizedBox();
    } else {
      linkText = urlMatches[0];
    }

    var isSelect = false;
    for (V2TimMessage selectItem in selectList) {
      if (item.msgID == selectItem.msgID) {
        isSelect = true;
        break;
      }
    }
    return InkWell(
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
          ColoredBox(
            color: theme.white,
            child: SizedBox(
              width: double.infinity,
              height: 80.px,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: theme.f4f4f4.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(12.px))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.px)),
                      child: SizedBox(
                        width: 54.px,
                        height: 54.px,
                        child: Center(
                            child: Image.asset(ABAssets.iconLink(context),
                                fit: BoxFit.cover, width: 32.px, height: 36.px)),
                      ),
                    ),
                  ).padding(left: 16.px, right: 14.px),
                  Builder(builder: (context) {
                    var time = DateTime.fromMillisecondsSinceEpoch((item.timestamp ?? 0) * 1000);
                    var year = time.year;
                    var month = time.month;
                    var day = time.day;
                    var timeS =
                        '$year-${time.month < 10 ? '0${time.month}' : '${time.month}'}-${time.day < 10 ? '0${time.day}' : '${time.day}'}';

                    var value = '$timeS ${AB_S().from}${item.nickName ?? ''}';
                    return FutureBuilder(
                      builder: (context, snapshot) {
                        var text = linkText;
                        if (snapshot.hasData) {
                          // 图片加载成功
                          text = snapshot.data ?? linkText;
                        } else if (snapshot.hasError) {
                          text = linkText;
                        }

                        return SizedBox(
                          width: MediaQuery.of(context).size.width - 110.px,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ABText(
                                text,
                                fontSize: 16.px,
                                textColor: theme.text282109,
                              ).padding(bottom: 1.px),
                              ABText(
                                value,
                                fontSize: 12.px,
                                textColor: theme.text999,
                              ),
                            ],
                          ),
                        );
                      },
                      future: getLinkInfo(linkText),
                    );
                  }),
                ],
              ),
            ),
          ),
          if (isChoice)
            Positioned(
              right: 16.px,
              top: 0.px,
              bottom: 0.px,
              child: Image.asset(
                isSelect ? ABAssets.assetsSelect(context) : ABAssets.assetsUnSelect(context),
                width: 24.px,
                height: 24.px,
              ),
            ),
        ],
      ),
    );
  }

  Future<String?> getLinkInfo(String link) async {
    // 将base64字符串转换为Uint8List
    List<LocalCustomDataModel> info = await LinkUtils.getURLPreview([link]);
    if (info.isEmpty) {
      return null;
    }
    if (info[0].title == null || info[0].title == '') {
      return null;
    }
    return info[0].title;
  }

  Widget getSearchWidget() {
    return SizedBox(
      child: TIMUIKitSearchInput(
        isAutoFocus: false,
        controller: textEditingController,
        onChange: (String value) {
          updateMsgResult(true);
        },
        // prefixIcon: Icon(
        //   Icons.search,
        //   size: 16,
        //   color: hexToColor("979797"),
        // ),
        hintText: AB_S().searchLinkName,
        prefixIcon: SizedBox(
          width: 16.px,
          height: 16.px,
          child: Center(
            child: Image.asset(
              ABAssets.homeSearchIcon(context),
              width: 16.px,
              height: 16.px,
            ),
          ),
        ),
        focusNode: focusNode,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

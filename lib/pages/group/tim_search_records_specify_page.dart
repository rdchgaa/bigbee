// ignore_for_file: avoid_print, file_names, deprecated_member_use

import 'package:bee_chat/net/mine_net.dart';
import 'package:bee_chat/pages/group/tim_search_msg_details_page.dart';
import 'package:bee_chat/pages/group/widget/tim_search_records_specify_date_view.dart';
import 'package:bee_chat/pages/group/widget/tim_search_records_specify_file_view.dart';
import 'package:bee_chat/pages/group/widget/tim_search_records_specify_image_video_view.dart';
import 'package:bee_chat/pages/group/widget/tim_search_records_specify_link_view.dart';
import 'package:bee_chat/pages/group/widget/tim_search_records_specify_member_view.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/im/im_message_utils.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_search_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/forward_message_screen.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';

class TimSearchRecordsSpecify extends StatefulWidget {
  final V2TimConversation con;

  final int? pageIndex;

  const TimSearchRecordsSpecify({
    super.key,
    required this.con,
    this.pageIndex,
  });

  @override
  State<TimSearchRecordsSpecify> createState() => _TimSearchRecordsSpecifyState();
}

class _TimSearchRecordsSpecifyState extends State<TimSearchRecordsSpecify> {
  MessageType messageType = MessageType.date;

  late PageController controller;

  GlobalKey<TimSearchRecordsSpecifyImageVideoViewState> imageVideoViewKey = GlobalKey();
  GlobalKey<TimSearchRecordsSpecifyFileViewState> fileViewKey = GlobalKey();
  GlobalKey<TimSearchRecordsSpecifyLinkViewState> linkViewKey = GlobalKey();

  bool isChoice = false;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.pageIndex ?? 0);
    messageType = widget.pageIndex == 0 ? MessageType.date : MessageType.date;
    switch (widget.pageIndex) {
      case 0:
        messageType = MessageType.date;
        break;
      case 1:
        messageType = MessageType.user;
        break;
      case 2:
        messageType = MessageType.image;
        break;
      case 3:
        messageType = MessageType.file;
        break;
      case 4:
        messageType = MessageType.link;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).categorySearch,
        backgroundWidget: Container(
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
            imageVideoViewKey.currentState?.toChoice(isChoice);
            fileViewKey.currentState?.toChoice(isChoice);
            linkViewKey.currentState?.toChoice(isChoice);
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
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          typeButtonView(),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                TimSearchRecordsSpecifyDateView(conversation: widget.con),
                TimSearchRecordsSpecifyMemberView(conversation: widget.con, groupID: widget.con.groupID ?? ""),
                TimSearchRecordsSpecifyImageVideoView(
                  key: imageVideoViewKey,
                  conversation: widget.con,
                ),
                TimSearchRecordsSpecifyFileView(
                  key: fileViewKey,
                  conversation: widget.con,
                ),
                TimSearchRecordsSpecifyLinkView(
                  key: linkViewKey,
                  conversation: widget.con,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  typeButtonView() {
    var typeList = [MessageType.date, MessageType.image, MessageType.file, MessageType.link];
    if(widget.con.groupID!=null){
      typeList = [MessageType.date, MessageType.user, MessageType.image, MessageType.file, MessageType.link];
    }
    List<Widget> flowList = typeList.map((e) {
      return _getTypeWidget(context, e);
    }).toList();
    return Padding(
      padding: EdgeInsets.all(16.px),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...flowList,
            ],
          ),
        ],
      ),
    );
  }

  Widget _getTypeWidget(BuildContext context, MessageType type) {
    String title = "";
    final S = AB_getS(context);
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");

    switch (type) {
      case MessageType.date:
        title = S.date;
        break;
      case MessageType.user:
        title = S.groupMember.replaceAll('Group', '');
        break;
      case MessageType.image:
        title = S.picture + '/' + S.video;
        break;
      case MessageType.file:
        title = S.file;
        break;
      case MessageType.link:
        title = S.link;
        break;
    }

    return InkWell(
      onTap: () {
        if (isChoice) {
          return;
        }
        messageType = type;
        switch (type) {
          case MessageType.date:
            controller.jumpToPage(0);
            break;
          case MessageType.user:
            controller.jumpToPage(1);
            break;
          case MessageType.image:
            controller.jumpToPage(2);
            imageVideoViewKey.currentState?.updateMsgResult(true);
            break;
          case MessageType.file:
            controller.jumpToPage(3);
            fileViewKey.currentState?.updateMsgResult(true);
            break;
          case MessageType.link:
            controller.jumpToPage(4);
            linkViewKey.currentState?.updateMsgResult(true);
            break;
        }
        setState(() {});
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: type == messageType ? theme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.px),
        ),
        child: SizedBox(
          height: 32.px,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isZh ? 12.px : 4.px,
            ),
            child: ABText(
              title,
              textColor: theme.textColor,
              fontSize: 14.px,
              fontWeight: type == messageType ? FontWeight.w600 : FontWeight.normal,
            ).center,
          ),
        ),
      ),
    );
  }
}

///0:日期 1:成员 2:图片/视频 3:文件 4:链接
enum MessageType {
  // 日期
  date,
  // 成员
  user,
  // 图片/视频
  image,
  // 文件
  file,
  // 链接
  link,
}

class TimSearchChoiceButton extends StatefulWidget {
  final V2TimConversation conversation;
  final List<V2TimMessage> msgList;
  final TUIChatSeparateViewModel model;

  final Function forward;

  final Function collect;
  final Function delete;

  const TimSearchChoiceButton({
    super.key,
    required this.forward,
    required this.collect,
    required this.delete,
    required this.msgList,
    required this.conversation,
    required this.model,
  });

  @override
  State<TimSearchChoiceButton> createState() => _TimSearchChoiceButtonState();
}

class _TimSearchChoiceButtonState extends State<TimSearchChoiceButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff4B3E52).withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 90.px,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Image.asset('images/merge_forward.png',
                      package: 'tencent_cloud_chat_uikit', color: theme.textColor, width: 24, height: 24),
                  iconSize: 40,
                  onPressed: () {
                    showCupertinoModalPopup<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoActionSheet(
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                "cancel",
                              );
                            },
                            child: Text(TIM_t("取消")),
                            isDefaultAction: false,
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                Navigator.pop(
                                  context,
                                  "cancel",
                                );
                                await _handleForwardMessage(context, false);
                                widget.forward();
                              },
                              child: Text(
                                TIM_t("逐条转发"),
                                style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              isDefaultAction: false,
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                Navigator.pop(
                                  context,
                                  "cancel",
                                );
                                await _handleForwardMessage(context, true);
                                widget.forward();
                              },
                              child: Text(
                                TIM_t("合并转发"),
                                style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              isDefaultAction: false,
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
                Text(
                  TIM_t("转发"),
                  style: TextStyle(color: theme.textColor, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Image.asset('images/collect.png',
                      package: 'tencent_cloud_chat_uikit', color: theme.textColor, width: 24, height: 24),
                  iconSize: 40,
                  onPressed: () async {
                    await _handleCollectMessage(context);
                    widget.collect();
                  },
                ),
                Text(
                  TIM_getCurrentDeviceLocale().contains("zh") ? "收藏" : "Collection",
                  style: TextStyle(color: theme.textColor, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Image.asset('images/delete.png',
                      package: 'tencent_cloud_chat_uikit', color: theme.textColor, width: 24, height: 24),
                  iconSize: 40,
                  onPressed: () {
                    showCupertinoModalPopup<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoActionSheet(
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                "cancel",
                              );
                            },
                            child: Text(TIM_t("取消")),
                            isDefaultAction: false,
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                await _handleDeleteMessage(context, false);
                                widget.delete();
                              },
                              child: Text(
                                (TIM_getCurrentDeviceLocale().contains("zh")
                                    ? "同时删除对方"
                                    : "Delete each other at the same time"),
                                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              isDefaultAction: false,
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                await _handleDeleteMessage(context, true);
                                widget.delete();
                              },
                              child: Text(
                                (TIM_getCurrentDeviceLocale().contains("zh") ? "只删除自己" : "Delete only myself"),
                                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              isDefaultAction: false,
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
                Text(TIM_t("删除"), style: TextStyle(color: theme.textColor, fontSize: 12))
              ],
            )
          ],
        ),
      ),
    );
  }

  _handleForwardMessage(BuildContext context, bool isMergerForward) async {
    bool hasUnSendMsg = false;

    for (var message in widget.model.multiSelectedMessageList) {
      if (message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL ||
          message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL) {
        hasUnSendMsg = true;
        break;
      }
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForwardMessageScreen(
                  model: widget.model,
                  isMergerForward: isMergerForward,
                  conversationType: ConvType.group,
                )));
  }

  _handleCollectMessage(
    BuildContext context,
  ) async {
    if (widget.msgList.isEmpty) {
      return false;
    }
    for (var element in widget.msgList) {
      final re = ImMessageUtils.isMessageCanCollect(message: element);
      if (!re.$1) {
        ABToast.show(re.$2);
        return false;
      }
    }
    ABLoading.show();
    final res = await MineNet.collectMessages(messageList: widget.msgList, groupId: widget.conversation.groupID);
    ABLoading.dismiss();
    if (res.data != null) {
      ABToast.show(AB_S().collectSuccess);
      return true;
    }
    return false;
  }

  _handleDeleteMessage(BuildContext context, bool onlySelf) {
    if (onlySelf) {
      widget.model.deleteSelectedMsg(false);
      widget.model.updateMultiSelectStatus(false);
      Navigator.pop(
        context,
        "cancel",
      );
    } else {
      widget.model.deleteSelectedMsg(true);
      widget.model.updateMultiSelectStatus(false);
      Navigator.pop(
        context,
        "cancel",
      );
    }
  }
}

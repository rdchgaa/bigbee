import 'dart:async';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/pages/chat/group_chat_page.dart';
import 'package:bee_chat/pages/conversation/widget/conversation_last_msg_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/conversation_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/time_ago.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation.dart';

import '../../utils/ab_event_bus.dart';
import '../chat/c2c_chat_page.dart';
import '../chat/system_chat_page.dart';
import '../contact/contact_setting_page.dart';
import '../group/group_info_page.dart';


const String systemUserId = "10124400";

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with AutomaticKeepAliveClientMixin{
  late StreamSubscription _subscription;
  bool _refreshValue = false;
  GlobalKey<TIMUIKitConversationState> conversationKey = GlobalKey();


  @override
  void initState() {
    //订阅：
    _subscription = ABEventBus.on<ABEvent>((event) {
      if (event.name == friendRemarkChangedEventName || event.name == friendDidDeleteEventName || event.name == quiteGroupEventName) {
        conversationKey.currentState?.refreshAction();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // 取消订阅：
    _subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = AB_theme(context);
    final imTheme = AB_themeProvider(context).imTheme;
    return TIMUIKitConversation(
      key: conversationKey,
      itemContentBuilder: _itemWidget,
      onTapItem: (value) {
        if (value.type == 1) {
          if (value.isSystem) {
            ABRoute.push(const SystemChatPage());
            TencentImSDKPlugin.v2TIMManager.getMessageManager().markC2CMessageAsRead(userID: systemUserId);
            return;
          }
          ABRoute.push(C2cChatPage(selectedConversation: value,));
        } else if (value.type == 2) {
          ABRoute.push(GroupChatPage(selectedConversation: value,));
        } else {
          ABToast.show("异常会话");
        }
      },
      itemSlideBuilder: (V2TimConversation conversationItem){
        return conversationItem.isSystem ? [
          ConversationItemSlidePanel(
            onPressed: (context) {
              conversationKey.currentState?.pinConversation(conversationItem);
            },
            backgroundColor: imTheme.conversationItemSliderPinBgColor ?? CommonColor.infoColor,
            foregroundColor: imTheme.conversationItemSliderTextColor,
            label: conversationItem.isPinned! ? TIM_t("取消置顶") : TIM_t("置顶"),
          )
        ] : null;
      },
      lifeCycle: ConversationLifeCycle(
          conversationListWillMount: (List<V2TimConversation?> list){
            // 排除“10124410”，收藏消息
            return Future.value(list.where((e) => e?.userID != "10124410").toList());
          },
      ),
    );
  }


  Widget _itemWidget(V2TimConversation conversationItem, [V2TimUserStatus? onlineStatus]) {
    final theme = AB_theme(context);
    final provider = AB_themeProvider(context);
    final topColor = provider.isDark ? imDarkTheme.conversationItemPinedBgColor : imLightTheme.conversationItemPinedBgColor;
    int showUnreadCount = conversationItem.unreadCount ?? 0;
    if ((conversationItem.recvOpt ?? 0) > 0) {
      showUnreadCount = 0;
    }
    return Container(
      height: 72,
      width: ABScreen.width,
      color: conversationItem.isPinned == true ? topColor : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 16.px,),
          // 头像
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                Positioned.fill(child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                    child: conversationItem.isSystem ? Image.asset(ABAssets.imSystemIcon(context)) : ABImage.avatarUser(conversationItem.faceUrl ?? "", isGroup: conversationItem.type == 2,)
                )),
                if (onlineStatus?.statusType == 1) Positioned(
                  bottom: 1,
                  right: 6,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: HexColor("#00FF47"),
                      borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.px,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 会话标题
                ABText(conversationItem.showTitle, textColor: theme.textColor, fontSize: 16.px, fontWeight: FontWeight.bold,),
                SizedBox(height: 6.px,),
                // 会话内容
                ConversationLastMsgWidget(
                  fontSize: 14,
                  groupAtInfoList: conversationItem.groupAtInfoList ?? [],
                  lastMsg: conversationItem.lastMessage,
                  context: context,
                )
              ]
            )
          ),
          SizedBox(width: 10.px,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 时间
              _getTimeStringForChatWidget(conversationItem.lastMessage?.timestamp ?? 0),
              if ((showUnreadCount ?? 0) > 0) SizedBox(height: 6.px,),
              // 未读消息数
              if ((showUnreadCount ?? 0) > 0) Container(
                width: 20,
               height: 20,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Builder(
                    builder: (context) {
                      String num = conversationItem.unreadCount.toString();
                      if((conversationItem.unreadCount??0)>99){
                        num = '99+';
                      }
                      return ABText("${num}", textColor: theme.white, fontSize: ((conversationItem.unreadCount??0)>99)?10:12,);
                    }
                  ),
                )
              ),
              if (conversationItem.recvOpt == 2 && ((conversationItem.unreadCount ?? 0) > 0)) SizedBox(height: 11.px,),
              if (conversationItem.recvOpt == 2 && ((conversationItem.unreadCount ?? 0) > 0)) Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(5)
                ),
              ),
              if (conversationItem.recvOpt == 1 || (conversationItem.recvOpt == 2 && (conversationItem.unreadCount ?? 0) == 0)) SizedBox(height: 8.px,),
              if (conversationItem.recvOpt == 1 || (conversationItem.recvOpt == 2 && (conversationItem.unreadCount ?? 0) == 0)) Icon(CupertinoIcons.bell_slash, size: 16.px, color: theme.textGrey,),
            ]
          ),
          SizedBox(width: 16.px,)
        ]
      )
    );

}
  Widget _getTimeStringForChatWidget(int timeStamp) {
    final theme = AB_theme(context);
    return ABText(TimeAgo().getTimeStringForChat(timeStamp) ?? "", textColor: theme.textGrey, fontSize: 12,);
  }


  @override
  bool get wantKeepAlive => true;
}


extension V2TimConversationExt on V2TimConversation {
  String get showTitle {
    if (isSystem) {
      return AB_getS(MyApp.context).systemMsg;
    }
    return showName ?? userID ?? "";
  }

  bool get isSystem {
    return userID == systemUserId;
  }
}
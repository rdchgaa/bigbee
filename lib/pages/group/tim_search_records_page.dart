// ignore_for_file: avoid_print, file_names, deprecated_member_use

import 'package:bee_chat/pages/chat/c2c_chat_page.dart';
import 'package:bee_chat/pages/chat/group_chat_page.dart';
import 'package:bee_chat/pages/group/tim_search_msg_details_page.dart';
import 'package:bee_chat/pages/group/tim_search_records_specify_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_search_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class TimSearchRecords extends StatelessWidget {
  final V2TimConversation conversation;

  const TimSearchRecords({Key? key, required this.conversation,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).findChats,
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
      ),
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          getSearchBuild(context),
          specifyContent(context),
        ],
      ),
    );
  }

  Widget specifyContent(BuildContext context) {
    final theme = AB_theme(context);
    return LayoutBuilder(
      builder: (context,con) {
        var itemWidth = (con.maxWidth-32.px-12.px)/3;
        var itemHeight = 39.px;
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60.px,bottom: 26.px),
              child: ABText(
                AB_getS(context).searchSpecifiedContent,
                fontSize: 14.px,
                textColor: theme.text999,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    toSpecifyPage(0);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: theme.white, borderRadius: BorderRadius.all(Radius.circular(6.px))),
                  child: SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: Center(
                      child: ABText(
                        AB_getS(context).date,
                        fontSize: 16.px,
                        textColor: theme.text282109,
                      ),
                    ),
                  ),
                  ),
                ),
                SizedBox(width: 6.px),
                if(conversation.groupID!=null)InkWell(
                  onTap: (){
                    toSpecifyPage(1);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: theme.white, borderRadius: BorderRadius.all(Radius.circular(6.px))),
                    child: SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: Center(
                        child: ABText(
                          AB_getS(context).groupMember.replaceAll('Group', ''),
                          fontSize: 16.px,
                          textColor: theme.text282109,
                        ),
                      ),
                    ),
                  ),
                ),
                if(conversation.groupID!=null)SizedBox(width: 6.px),
                InkWell(
                  onTap: (){
                    toSpecifyPage(2);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: theme.white, borderRadius: BorderRadius.all(Radius.circular(6.px))),
                    child: SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: Center(
                        child: ABText(
                          '${AB_getS(context).picture}/${AB_getS(context).video}',
                          fontSize: 16.px,
                          textColor: theme.text282109,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    toSpecifyPage(3);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: theme.white, borderRadius: BorderRadius.all(Radius.circular(6.px))),
                    child: SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: Center(
                        child: ABText(
                          AB_getS(context).file,
                          fontSize: 16.px,
                          textColor: theme.text282109,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.px),
                InkWell(
                  onTap: (){
                    toSpecifyPage(4);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: theme.white, borderRadius: BorderRadius.all(Radius.circular(6.px))),
                    child: SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: Center(
                        child: ABText(
                          AB_getS(context).link,
                          fontSize: 16.px,
                          textColor: theme.text282109,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      }
    );
  }
  toSpecifyPage(int index){
    ABRoute.push(TimSearchRecordsSpecify(con: conversation,pageIndex: index));
  }

  Widget getSearchBuild(BuildContext context) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: () {
        ABRoute.push(TimSearchMsgDetails(
          currentConversation: conversation,
          keyword: '',
          onTapConversation: (v2TimConversation, v2TimMessage) {
            if (v2TimConversation.groupID != null) {
              // 群聊
              ABRoute.push(GroupChatPage(selectedConversation: v2TimConversation,v2TimMessage: v2TimMessage,));
              return;
            }else if (v2TimConversation.userID != null) {
              // 单聊
              ABRoute.push(C2cChatPage(selectedConversation: v2TimConversation,v2TimMessage: v2TimMessage,));
              return;
            }

          },
        ));
      },
      child: Container(
        height: 46.px,
        margin: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px),
        decoration: BoxDecoration(
          color: theme.white,
          borderRadius: BorderRadius.circular(6.px),
        ),
        child: Row(
          children: [
            // 搜索图标
            Padding(
              padding: EdgeInsets.only(left: 16.px, right: 6.px),
              child: Image.asset(
                ABAssets.homeSearchIcon(context),
                width: 16.px,
                height: 16.px,
              ),
            ),
            SizedBox(width: 8.px),
            ABText(
              AB_getS(context).search,
              textColor: HexColor("#B4B5B5"),
              fontSize: 14.px,
            )
          ],
        ),
      ),
    );
  }
}

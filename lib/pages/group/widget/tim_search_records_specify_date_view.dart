// ignore_for_file: avoid_print, file_names, deprecated_member_use

import 'package:bee_chat/pages/chat/c2c_chat_page.dart';
import 'package:bee_chat/pages/chat/group_chat_page.dart';
import 'package:bee_chat/pages/group/tim_search_msg_details_page.dart';
import 'package:bee_chat/pages/group/tim_search_records_specify_details_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/date_time_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_search_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';



class TimSearchRecordsSpecifyDateView extends StatefulWidget {
  final V2TimConversation conversation;
  const TimSearchRecordsSpecifyDateView({super.key, required this.conversation});

  @override
  State<TimSearchRecordsSpecifyDateView> createState() => _TimSearchRecordsSpecifyDateViewState();
}

class _TimSearchRecordsSpecifyDateViewState extends State<TimSearchRecordsSpecifyDateView> with AutomaticKeepAliveClientMixin {

  final model = serviceLocator<TUISearchViewModel>();

  List<DateTime> hasDataDayList = [];

  GlobalKey<DatePickerWidgetState> datePickerWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getMonthData(DateTime.now());
  }
  getMonthData(DateTime date) async {
    var year = date.year;
    var month = date.month;

    for(var i = 1 ;i<=31;i++){
      DateTime day = DateTime(year, month, i);
      var num = await getDayMessageData(day);
      if(num!=null&&num>0){
        hasDataDayList.add(day);
      }
    }
    setState(() {
    });
    datePickerWidgetKey.currentState?.loadAttendanceMonthRecord(listData: hasDataDayList);
  }

  Future<int?> getDayMessageData(DateTime date) async{
    MessageService messageService = serviceLocator<MessageService>();
    final searchResult = await messageService.searchLocalMessages(
        searchParam: V2TimMessageSearchParam(
          keywordList: [],
          messageTypeList: [1, 2, 3, 4, 5, 6, 7, 10],
          pageIndex: 0,
          pageSize: 1,
          searchTimePeriod: 24*60*60,
          searchTimePosition: date.secondsSinceEpoch()+24*60*60,
          conversationID: widget.conversation.conversationID,
          type: KeywordListMatchType.V2TIM_KEYWORD_LIST_MATCH_TYPE_OR.index,
        ));
    if(searchResult.code == 0 && searchResult.data != null) {
      int totalCount = searchResult.data?.totalCount ?? 0;
      if(totalCount>0){
        return totalCount;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return DatePickerWidget(
      key: datePickerWidgetKey,
      initListData: hasDataDayList,
      onChangeMonth: (date){
        getMonthData(date);
      },
      onChoice: (DateTime date) async {

      DateTime time = date.add(Duration(hours: 24));
      ABRoute.push(TimSearchRecordsSpecifyDetailsPage(
        title: '${date.year}${AB_S().year}${date.month}${AB_S().month}${date.day}${AB_S().day}',
        currentConversation: widget.conversation,
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
        searchTimePosition: time.secondsSinceEpoch(),
      ));
    },);
  }

  @override
  bool get wantKeepAlive => true;


}

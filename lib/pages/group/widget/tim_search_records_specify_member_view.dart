import 'package:bee_chat/models/group/group_member_invite_model.dart';
import 'package:bee_chat/models/group/group_member_list_model.dart';
import 'package:bee_chat/pages/chat/c2c_chat_page.dart';
import 'package:bee_chat/pages/chat/group_chat_page.dart';
import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/pages/group/group_invite_page.dart';
import 'package:bee_chat/pages/group/group_member_choose_page.dart';
import 'package:bee_chat/pages/group/tim_search_records_specify_details_page.dart';
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
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:bee_chat/widget/alert_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';


class TimSearchRecordsSpecifyMemberView extends StatefulWidget {
  final V2TimConversation conversation;
  final String groupID;

  const TimSearchRecordsSpecifyMemberView(
      {super.key, required this.groupID, required this.conversation,});

  @override
  State<TimSearchRecordsSpecifyMemberView> createState() => _TimSearchRecordsSpecifyMemberViewState();
}

class _TimSearchRecordsSpecifyMemberViewState extends State<TimSearchRecordsSpecifyMemberView> with AutomaticKeepAliveClientMixin{
  String _searchText = "";
  late GroupMemberListVm _vm;

  @override
  void initState() {
    _vm = GroupMemberListVm(groupID: widget.groupID);
    super.initState();
    _doSearch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Column(
      children: [
        _searchWidget().addPadding(
            padding:
            EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px)),
        ChangeNotifierProvider(
          create: (_) => _vm,
          builder: (context, child) {
            var vm = context.watch<GroupMemberListVm>();
            return EasyRefresh(
              header: CustomizeBallPulseHeader(color: theme.primaryColor),
              onRefresh: () async {
                await _doSearch();
              },
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final model = vm.resultList[index];
                  return InkWell(onTap: () {
                    ABRoute.push(TimSearchRecordsSpecifyDetailsPage(
                      title: model.nickName??'',
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
                      userId: model.memberNum,
                    ));
                    // ABRoute.push(UserDetailsPage(userId: model.memberNum ?? ""));
                  },
                    child: GroupMemberListItem(model: model,),
                  );
                },
                itemCount: vm.resultList.length,
              ),
            );
          },
        ).expanded(),
      ],
    );
  }

  // 搜索框
  Widget _searchWidget() {
    final theme = AB_theme(context);
    return Container(
      alignment: Alignment.centerLeft,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.px),
        // 边框
        border: Border.all(
          color: theme.f4f4f4,
          width: 1.px,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ABAssets.homeSearchIcon(context),
            width: 14.px,
            height: 14.px,
          ),
          SizedBox(
            width: 14.px,
          ),
          ABTextField(
            text: _searchText,
            textSize: 14.px,
            maxLines: 1,
            hintText: AB_getS(context).searchName,
            hintColor: theme.textGrey,
            contentPadding: EdgeInsets.only(bottom: 12.px),
            onChanged: (text) {
              _searchText = text;
            },
            onSubmitted: (text) {
              _searchText = text;
              _doSearch();
            },
          ).expanded(),
        ],
      ).addPadding(padding: EdgeInsets.symmetric(horizontal: 12.px)),
    );
  }

  Future<void> _doSearch() async {
    print("object");
    await _vm.search(_searchText);
  }


  // 邀请好友
  void _inviteMember() async {
    final result = await ABRoute.push(GroupInvitePage(groupID: widget.groupID ?? "",)) as List<GroupMemberInviteModel>?;
    if (result != null && result.isNotEmpty) {
      _doSearch();
    }
  }
  // 移除好友
  void _removeMember() async {
    final result = await ABRoute.push(GroupMemberChoosePage(groupID: widget.groupID, checkComplete: (models) async {
      final isConfirmed = await AlertPopWidget.show(title: AB_getS(context, listen: false).removeGroupMember, content: AB_getS(context, listen: false).removeGroupMemberTip);
      return isConfirmed ?? false;
    },),) as List<GroupMemberListModel>?;
    if (result != null && result.isNotEmpty) {
      ABLoading.show();
      final res = await TencentImSDKPlugin.v2TIMManager.getGroupManager().kickGroupMember(groupID: widget.groupID ?? "", memberList: result.map((e)=> e.memberNum ?? "").toList());
      ABLoading.dismiss();
      if (res.code == 0) {
        ABToast.show(AB_getS(context, listen: false).removeGroupMemberSuccess);
        _doSearch();
      } else {
        ABToast.show(res.desc);
      }
    }
  }

  @override
  bool get wantKeepAlive => true;


}

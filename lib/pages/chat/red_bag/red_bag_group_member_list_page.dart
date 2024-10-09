import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/group/group_member_invite_model.dart';
import 'package:bee_chat/models/group/group_member_list_model.dart';
import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/pages/group/group_invite_page.dart';
import 'package:bee_chat/pages/group/group_member_choose_page.dart';
import 'package:bee_chat/pages/group/vm/group_member_list_vm.dart';
import 'package:bee_chat/pages/group/widget/group_member_list_item.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
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

class RedBagGroupMemberListPage extends StatefulWidget {
  final String groupID;

  const RedBagGroupMemberListPage(
      {super.key, required this.groupID,});

  @override
  State<RedBagGroupMemberListPage> createState() => _RedBagGroupMemberListPageState();
}

class _RedBagGroupMemberListPageState extends State<RedBagGroupMemberListPage> {
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
    return Scaffold(
      appBar: ABAppBar(
        title: "${AB_getS(context).groupMember}",
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
        // rightWidget: ABButton.textButton(text: AB_getS(context).start, textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600, width: 60.px, height: 44, onPressed: (){
        //   // 点击开始
        //
        // }),
      ),
      backgroundColor: theme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          _searchWidget().addPadding(
              padding:
              EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px)),
          ChangeNotifierProvider(
            create: (_) => _vm,
            builder: (context, child) {
              var vm = context.watch<GroupMemberListVm>();
              UserProvider provider =
              Provider.of<UserProvider>(MyApp.context, listen: false);
              return EasyRefresh(
                header: CustomizeBallPulseHeader(color: theme.primaryColor),
                onRefresh: () async {
                  await _doSearch();
                },
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final model = vm.resultList[index];
                    final userId = ABSharedPreferences.getUserIdSync();
                    if(model.memberNum==userId){
                      return SizedBox();
                    }
                    return InkWell(onTap: () {
                      ABRoute.pop(context: context,result: model);
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
          // Container(
          //   height: 74 + ABScreen.bottomHeight,
          //   width: ABScreen.width,
          //   decoration: BoxDecoration(
          //     color: theme.white,
          //     // 部分圆角
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(12.px),
          //       topRight: Radius.circular(12.px),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       const SizedBox(
          //         width: 24,
          //       ),
          //       // if (widget.isManager) ABButton(
          //       //   text: AB_getS(context).remove,
          //       //   textColor: Colors.white,
          //       //   backgroundColor: HexColor("#989897"),
          //       //   fontSize: 16,
          //       //   fontWeight: FontWeight.w600,
          //       //   height: 48,
          //       //   cornerRadius: 12.px,
          //       //   onPressed: () {
          //       //     _removeMember();
          //       //   },
          //       // ).expanded(),
          //       // if (widget.isManager) const SizedBox(
          //       //   width: 20,
          //       // ),
          //       ABButton.gradientColorButton(
          //           colors: [theme.primaryColor, theme.secondaryColor],
          //           text: AB_getS(context).invited,
          //           textColor: theme.textColor,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //           height: 48,
          //           cornerRadius: 12.px,
          //           onPressed: () {
          //             _inviteMember();
          //           }).expanded(),
          //       SizedBox(
          //         width: 24,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
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


}

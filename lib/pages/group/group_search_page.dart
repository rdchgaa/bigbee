import 'package:bee_chat/models/group/group_list_model.dart';
import 'package:bee_chat/pages/group/group_info_page.dart';
import 'package:bee_chat/pages/group/vm/group_search_vm.dart';
import 'package:bee_chat/pages/contact/vm/user_search_vm.dart';
import 'package:bee_chat/pages/group/widget/group_search_item_widget.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_screen.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text_field.dart';
import '../chat/group_chat_page.dart';

class GroupSearchPage extends StatefulWidget {
  const GroupSearchPage({super.key});

  @override
  State<GroupSearchPage> createState() => _GroupSearchPageState();
}

class _GroupSearchPageState extends State<GroupSearchPage> {
  String _searchText = "";
  final GroupSearchVm _vm = GroupSearchVm();
  List<String> _sendGroupIds = [];

  @override
  void initState() {
    super.initState();
    _doSearch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          SizedBox(height: ABScreen.statusHeight + 16.px,),
          Row(
              children: [
                _searchWidget().expanded(),
                ABButton.textButton(text: AB_getS(context).cancel, textColor: theme.primaryColor, fontSize: 16, fontWeight: FontWeight.w600, height: 48, width: 66, onPressed: () {
                  ABRoute.pop();
                }),
              ]
          ).addPadding(padding: EdgeInsets.only(left: 16.px)),
          SizedBox(height: 12.px,),
          ChangeNotifierProvider(
            create: (_) => _vm,
            builder: (context, child) {
              var vm = context.watch<GroupSearchVm>();
              return EasyRefresh(
                header: CustomizeBallPulseHeader(color: theme.primaryColor),
                onRefresh: () async {
                  await _doSearch();
                },
                child: ListView.builder(itemBuilder: (BuildContext context, int index){
                  final model = vm.resultList[index];
                  return InkWell(
                    onTap: () {
                      ABRoute.push(GroupInfoPage(groupID: model.groupId ?? ""));
                    },
                    child: GroupSearchItemWidget(
                        groupInfo: model,
                        onJoinGroup: (_sendGroupIds.contains(model.groupId)) ? null : () {
                          _joinGroup(model);
                        },
                        onChatGroup: () {
                          _chatGroup(model);
                        }
                    ),
                  );
                },
                  itemCount: vm.resultList.length,
                ),
              );
            },
          ).expanded(),
        ],
      ),
    );
  }

  Widget _searchWidget() {
    final theme = AB_theme(context);
    return Container(
      height: 48.px,
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
          Image.asset(ABAssets.homeSearchIcon(context), width: 20.px, height: 20.px,),
          SizedBox(width: 10.px,),
          ABTextField(
            text: _searchText,
            hintText: AB_getS(context).searchName,
            hintColor: theme.textGrey,
            contentPadding: EdgeInsets.only(bottom: 12.px),
            onChanged: (text) {
              _searchText = text;
            },
            onSubmitted: (text){
              _searchText = text;
              _doSearch();
            },
            textInputAction: TextInputAction.search,
          ).expanded(),
        ],
      ).addPadding(padding: EdgeInsets.symmetric(horizontal: 12.px)),
    );
  }

  Future<void> _doSearch() async {
    await _vm.search(_searchText);
  }


  Future<void> _joinGroup(GroupListModel groupInfo) async {
    if ((groupInfo.groupId ?? "").isEmpty) {return;}
    ABLoading.show();
    // 加入群组
    final joinRes = await TencentImSDKPlugin.v2TIMManager.joinGroup(groupID: groupInfo.groupId ?? "", message: "hello", groupType: GroupType.Public);
    await ABLoading.dismiss();
    if (joinRes.code != 0) {
      ABToast.show(joinRes.desc);
    } else {
      ABToast.show(AB_getS(context, listen: false).sendJoinSuccess);
      setState(() {
        _sendGroupIds.add(groupInfo.groupId ?? "");
      });
    }


  }

  Future<void> _chatGroup(GroupListModel groupInfo) async {
    if ((groupInfo.groupId ?? "").isEmpty) {return;}
    final conversationID = "group_${groupInfo.groupId}";
    final convRes = await TIMUIKitCore.getSDKInstance()
        .getConversationManager()
        .getConversation(conversationID: conversationID);
    if (convRes.code == 0) {
      final conversation = convRes.data ??
          V2TimConversation(
              conversationID: conversationID,
              type: 2,
              showName: groupInfo.groupName ?? "",
              groupType: GroupType.Public,
              groupID: groupInfo.groupId ?? ""
          );
      ABRoute.push(
          GroupChatPage(selectedConversation: conversation,));
    }
  }


}

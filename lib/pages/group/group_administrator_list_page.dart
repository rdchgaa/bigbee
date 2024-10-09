import 'package:bee_chat/models/group/group_member_list_model.dart';
import 'package:bee_chat/net/group_net.dart';
import 'package:bee_chat/pages/group/group_member_choose_page.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/alert_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../provider/language_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/ab_route.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_app_bar.dart';
import '../contact/user_details_page.dart';
import 'widget/group_administrator_list_item.dart';

class GroupAdministratorListPage extends StatefulWidget {
  final String groupID;
  const GroupAdministratorListPage({super.key, required this.groupID});

  @override
  State<GroupAdministratorListPage> createState() => _GroupAdministratorListPageState();
}

class _GroupAdministratorListPageState extends State<GroupAdministratorListPage> {

  List<GroupMemberListModel> _administratorList = [];

  @override
  void initState() {
    super.initState();
    _requestAdministratorList();
  }


  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).setGroupManagers,
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
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(AB_getS(context).setGroupManagersTip, style: TextStyle(color: theme.textGrey, fontSize: 14, height: 1.5,),),
          ),
          Expanded(
            child: ListView(
              children: [
                ..._administratorList.map((model) {
                  return InkWell(
                    onTap: () async {
                      _deleteAction(context, model);
                    },
                    child: GroupAdministratorListItem(model: model, onSelect: (){
                      _deleteAction(context, model);
                    },),
                  );
                }).toList(),
                if (_administratorList.length < 5) SizedBox(height: 16),
                if (_administratorList.length < 5) InkWell(
                  onTap: (){
                    _addAction(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: theme.white,
                    height: 56,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AB_getS(context).addGroupManagers, style: TextStyle(color: theme.textColor, fontSize: 16),),
                          Container(
                            width: 40,
                            height: 40,
                            child: Image.asset(ABAssets.addIcon(context), width: 24, height: 24,).center,
                          )
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _requestAdministratorList() async {
    final result = await GroupNet.getGroupManagerList(groupID: widget.groupID);
    setState(() {
      _administratorList = result;
    });
  }

  _deleteAction(BuildContext context, GroupMemberListModel model) async {
    final result = await AlertPopWidget.show(content: AB_S().setGroupManagersTip1(model.displayName ?? ""));
    if (result != true) {
      return;
    }
    final res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager().setGroupMemberRole(groupID: widget.groupID, userID: model.memberNum ?? "", role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER);
    if (res.code == 0) {
      setState(() {
        _administratorList.removeWhere((element) => element.memberNum == model.memberNum);
      });
    }
  }

  _addAction(BuildContext context) async {
    final _ = await ABRoute.push(GroupMemberChoosePage(groupID: widget.groupID, isNormalMemberOnly: true, excludeMemberIds: [..._administratorList.map((e) => e.memberNum ?? ""), UserProvider.getCurrentUser().userId ?? ""], checkComplete: (List<GroupMemberListModel> list) {
      if (list.isEmpty) {
        return Future.value(false);
      }
      if (list.length + _administratorList.length > 5) {
        ABToast.show(AB_S().addGroupManagersTip);
        return Future.value(false);
      }
      ABLoading.show();
      list.forEach((model) async {
        final res = await TencentImSDKPlugin.v2TIMManager
            .getGroupManager().setGroupMemberRole(groupID: widget.groupID, userID: model.memberNum ?? "", role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_ADMIN);
        if (res.code == 0) {
          setState(() {
            _administratorList.add(model);
          });
        }
      });
      ABLoading.dismiss();
      return Future.value(true);
    },));

  }



  // Future<V2TimCallback> setMemberToAdmin(String userID) async {
  //   final res = await _groupServices.setGroupMemberRole(groupID: _groupID, userID: userID, role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_ADMIN);
  //   if (res.code == 0) {
  //     final targetIndex = _groupMemberList!.indexWhere((e) => e!.userID == userID);
  //     if (targetIndex != -1) {
  //       final targetElem = _groupMemberList![targetIndex];
  //       targetElem?.role = GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN;
  //       _groupMemberList![targetIndex] = targetElem;
  //     }
  //     notifyListeners();
  //   }
  //   return res;
  // }


}

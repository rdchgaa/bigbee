import 'package:bee_chat/net/group_net.dart';
import 'package:bee_chat/pages/group/vm/group_invite_user_list_vm.dart';
import 'package:bee_chat/pages/group/vm/group_member_list_vm.dart';
import 'package:bee_chat/pages/group/widget/group_invite_user_list_item.dart';
import 'package:bee_chat/pages/group/widget/group_member_list_item.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../models/group/group_member_invite_model.dart';
import '../../models/group/group_member_list_model.dart';
import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/ab_route.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text_field.dart';
import '../contact/user_details_page.dart';

class GroupInvitePage extends StatefulWidget {
  final String groupID;

  const GroupInvitePage({super.key, required this.groupID});

  @override
  State<GroupInvitePage> createState() => _GroupInvitePageState();
}

class _GroupInvitePageState extends State<GroupInvitePage> {
  String _searchText = "";
  late GroupInviteUserListVm _vm;
  List<GroupMemberInviteModel> _selectMembers = [];

  @override
  void initState() {
    _vm = GroupInviteUserListVm(groupID: widget.groupID);
    super.initState();
    _doSearch();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = ABScreen.bottomHeight;
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).invitedNewMember,
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
        // rightWidget: ABButton.textButton(text: AB_getS(context).completed, textColor: theme.textColor, fontSize: 14, fontWeight: FontWeight.w600, width: 60.px, height: 44, onPressed: () async {
        // }),
      ),
      backgroundColor: theme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          _searchWidget().addPadding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          ChangeNotifierProvider(
            create: (_) => _vm,
            builder: (context, child) {
              var vm = context.watch<GroupInviteUserListVm>();
              return EasyRefresh(
                header: CustomizeBallPulseHeader(color: theme.primaryColor),
                onRefresh: () async {
                  await _doSearch();
                },
                onLoad: !vm.hasMore
                    ? null
                    : () async {
                        await vm.loadMore();
                      },
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final model = vm.resultList[index];
                    final isSelect = _selectMembers.contains(model);
                    return InkWell(
                      onTap: () {
                        ABRoute.push(UserDetailsPage(userId: model.memberNum ?? ""));
                      },
                      child: GroupInviteUserListItem(
                        model: model,
                        isSelected: _selectMembers.contains(model),
                        onSelect: () {
                          if (_selectMembers.contains(model)) {
                            _selectMembers.remove(model);
                          } else {
                            _selectMembers.add(model);
                          }
                          setState(() {});
                        },
                      ),
                    );
                  },
                  itemCount: vm.resultList.length,
                ),
              );
            },
          ).expanded(),
          ABButton.gradientColorButton(
              colors: [theme.primaryColor, theme.secondaryColor],
              text: _selectMembers.isNotEmpty
                  ? "${AB_getS(context).completed}(${_selectMembers.length})"
                  : AB_getS(context).invited,
              textColor: theme.textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 48,
              onPressed: () async {
                _doInvite();
              }).addPadding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
          SizedBox(
            height: bottom,
          ),
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
              // _doSearch();
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
    setState(() {
      _selectMembers = [];
    });
    await _vm.search(_searchText);
  }

  Future<void> _doInvite() async {
    if (_selectMembers.isEmpty) {
      return;
    }
    final userIds = _selectMembers.map((e) => e.memberNum ?? "").toList();
    // ABLoading.show();
    // final result = await TencentImSDKPlugin.v2TIMManager
    //     .getGroupManager()
    //     .inviteUserToGroup(groupID: widget.groupID, userList: userIds);
    // await ABLoading.dismiss();
    // if (result.code != 0) {
    //   ABToast.show(result.desc);
    //   return;
    // }
    ABLoading.show();
    final res = await GroupNet.inviteIntoGroup(groupID: widget.groupID, userIds: userIds);
    await ABLoading.dismiss();
    if (res.error != null) {
      ABToast.show(res.error?.message ?? AB_getS(context, listen: false).invitedError);
      return;
    }
    ABToast.show(AB_getS(context, listen: false).invitedSuccess);
    ABRoute.pop(result: _selectMembers);
  }
}

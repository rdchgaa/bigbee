import 'package:bee_chat/net/group_net.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../models/group/group_member_list_model.dart';
import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/ab_loading.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_toast.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_text.dart';
import '../../widget/alert_pop_widget.dart';
import 'group_member_choose_page.dart';
import 'group_mute_member_choose_page.dart';

/// 禁言设置界面
class GroupMuteSettingPage extends StatefulWidget {
  final String groupID;
  const GroupMuteSettingPage({super.key, required this.groupID});

  @override
  State<GroupMuteSettingPage> createState() => _GroupMuteSettingPageState();
}

class _GroupMuteSettingPageState extends State<GroupMuteSettingPage> {
  final model = TUIGroupProfileModel();
  List<GroupMemberListModel> _muteMemberList = [];


  @override
  void initState() {
    model.loadData(widget.groupID);
    _requestMuteMemberList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: "${AB_getS(context).muteSetting}",
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
      body: ChangeNotifierProvider(
        create: (context) => model,
        builder: (context, _) {
          var m = context.watch<TUIGroupProfileModel>();
          return Column(
            children: [
              SizedBox(height: 10.px,),
              _getSwitchRowWidget(title: AB_S().muteGroupAll, tips: AB_S().muteGroupAllTip, value: m.groupInfo?.isAllMuted ?? false, onSwitchChange: (value) async {
                _muteGroup(value);
              }),
              SizedBox(height: 10.px,),
              InkWell(
                onTap: () async {
                  _muteGroupMember();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: theme.white,
                  height: 56,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AB_getS(context).addMuteMembers, style: TextStyle(color: theme.textColor, fontSize: 16),),
                        Container(
                          width: 40,
                          height: 40,
                          child: Image.asset(ABAssets.addIcon(context), width: 24, height: 24,).center,
                        )
                      ]
                  ),
                ),
              ),
              SizedBox(height: 10.px,),
              Expanded(
                child: EasyRefresh(
                  header: CustomizeBallPulseHeader(color: theme.primaryColor),
                  onRefresh: () async {
                    await _requestMuteMemberList();
                  },
                  child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                    final model  = _muteMemberList[index];
                    return Container(
                      color: theme.white,
                      height: 56,
                      child: Row(
                        children: [
                          SizedBox(width: 16.px,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                              child: ABImage.imageWithUrl(model.avatarUrl ?? "", width: 40, height: 40)
                          ),
                          SizedBox(width: 10.px,),
                          Expanded(child: Text(model.nickName ?? "")),
                          SizedBox(width: 10.px,),
                          InkWell(
                            onTap: () async {
                              ABLoading.show();
                              final re = await TencentImSDKPlugin.v2TIMManager.getGroupManager().muteGroupMember(groupID: widget.groupID ?? "", userID: model.memberNum ?? "", seconds: 0);
                              if (re.code != 0) {
                                ABLoading.dismiss();
                                return;
                              }
                              final res = await GroupNet.muteMembers(groupID: widget.groupID ?? "", userIds: [model.memberNum ?? ""], isMute: false);
                              ABLoading.dismiss();
                              if (res.data != null) {
                                setState(() {
                                  _muteMemberList.removeWhere((e){
                                    return e.memberNum == model.memberNum;
                                  });
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              // 圆角边框
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.primaryColor, width: 1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text("解除", style: TextStyle(color: theme.primaryColor, fontSize: 12),),
                            ),
                          ),
                          SizedBox(width: 16.px,),
                        ],
                      ),
                    );
                  },
                    itemCount: _muteMemberList.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // switch row
  Widget _getSwitchRowWidget({required String title, required bool value, String? tips, bool isLast = false, Function(bool)? onSwitchChange}) {
    final theme = AB_theme(context);
    return ColoredBox(
      color: theme.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.px, bottom: 10.px),
            child: SizedBox(
              width: double.infinity,
              // height: 56,
              child: Padding(
                padding: EdgeInsets.only(left: 16.px, right: 16.px),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(title,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: theme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 5.px),
                          child: CupertinoSwitch(
                            value: value,
                            onChanged: (value) {
                              onSwitchChange?.call(value);
                            },
                            activeColor: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    if (tips != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(tips,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: theme.text999,
                              fontSize: 12,
                            )),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              color: theme.backgroundColor,
            ).addPadding(padding: const EdgeInsets.only(left: 16, right: 16)),
        ],
      ),
    );
  }


  // 禁言群成员
  void _muteGroupMember() async {
    ABRoute.push(GroupMuteMemberChoosePage(groupID: widget.groupID, completeCallback: (List<GroupMemberListModel> members) async {
      final isConfirmed = await AlertPopWidget.show(title: "禁言", content: "是否禁言群成员？") as bool?;
      if (isConfirmed == true) {
        ABLoading.show();
        List<String> userIDList = [];
        for (var e in members) {
          final res = await TencentImSDKPlugin.v2TIMManager.getGroupManager().muteGroupMember(groupID: widget.groupID ?? "", userID: e.memberNum ?? "", seconds: 10*365*24*3600);
          if (res.code == 0) {
            userIDList.add(e.memberNum ?? "");
          }
        }
        if (userIDList.isNotEmpty) {
          await GroupNet.muteMembers(groupID: widget.groupID ?? "", userIds: userIDList);
          await _requestMuteMemberList();
        }
        ABLoading.dismiss();
        return true;
      } else {
        return false;
      }
    }));
  }

  // 禁言整个群
  void _muteGroup(bool isMute) async {
    ABLoading.show();
    final result = await model.setMuteAll(isMute);
    ABLoading.dismiss();
    if (result != null) {
      if (result.code == 0) {
        ABToast.show(AB_S().muteGroupSuccess);
        setState(() {
          model.groupInfo?.isAllMuted = isMute;
        });
      } else {
        ABToast.show(result.desc);
      }
    } else {
      ABToast.show(AB_S().muteGroupFailed);
    }
  }


  Future<void> _requestMuteMemberList() async {
    var result = await GroupNet.getMuteMemberList(groupID: widget.groupID);
    if (result.data != null) {
      setState(() {
        _muteMemberList = result.data!;
      });

    }
  }

}

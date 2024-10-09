import 'package:bee_chat/pages/group/dialog/select_clear_message_type_dialog.dart';
import 'package:bee_chat/pages/group/group_administrator_list_page.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_event_bus.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/im/im_group_info_utils.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../models/group/group_member_list_model.dart';
import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_loading.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_toast.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/alert_pop_widget.dart';
import 'group_member_choose_page.dart';

const String groupCustomInfoNoticeName = 'groupCustomInfoNoticeName';

class GroupManagerPage extends StatefulWidget {
  final String groupID;
  final Function(GroupCustomInfoModel)? onGroupCustomInfoChange;
  final Function()? onGroupOwnerTransfer;

  const GroupManagerPage({super.key, required this.groupID, this.onGroupCustomInfoChange, this.onGroupOwnerTransfer});

  @override
  State<GroupManagerPage> createState() => _GroupManagerPageState();
}

class _GroupManagerPageState extends State<GroupManagerPage> {
  bool inviteConfirmation = false;
  bool onlyManagerEditName = false;
  bool enterConfirm = false;
  final model = TUIGroupProfileModel();
  GroupCustomInfoModel _groupCustomInfo = GroupCustomInfoModel();
  ClearMessageType? clearType;

  @override
  void initState() {
    super.initState();
    model.loadData(widget.groupID);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData() {
    ImGroupInfoUtils.getGroupCustomInfoModel(groupID: widget.groupID).then((model){
      _groupCustomInfo = model;
      setState(() {});
    });


  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    inviteConfirmation = _groupCustomInfo.isShowQRCode != "1";
    enterConfirm = model.groupInfo?.groupAddOpt == 1;
    final isAllMuted = model.groupInfo?.isAllMuted ?? false;
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).groupManager,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 18.px,
            ),
            // 邀请确认
            _getSwitchRowWidget(
                title: AB_getS(context).groupInviteConfirmed,
                tips: AB_S().groupInviteConfirmedTip,
                value: inviteConfirmation,
                onSwitchChange: (value) async {
                  final res = await ImGroupInfoUtils.setGroupQRCodeVisible(groupID: widget.groupID, isShowQRCode: !value);
                  if (res?.code == 0) {
                    _groupCustomInfo.isShowQRCode = value ? "0" : "1";
                    widget.onGroupCustomInfoChange?.call(_groupCustomInfo);
                  }
                  setState(() {
                  });
                },
                isLast: false),
            // 管理员修改群名
            _getSwitchRowWidget(
                title: AB_getS(context).onlyManagerChangeGroupName,
                value: _groupCustomInfo.isOnlyAdminCanModifyGroupName == "1",
                onSwitchChange: (value) async {
                  final res = await ImGroupInfoUtils.setGroupOnlyAdminCanModifyGroupName(groupID: widget.groupID, isOnlyAdminCanModifyGroupName: value);
                  if (res?.code == 0) {
                    _groupCustomInfo.isOnlyAdminCanModifyGroupName = value ? "1" : "0";
                    widget.onGroupCustomInfoChange?.call(_groupCustomInfo);
                  }
                  setState(() {
                  });
                }),
            // 群主转让
            setButtonItem(
              null,
              AB_getS(context).groupOwnerTransfer,
              () async {
                // await ABRoute.push(AssetsVoicesPage());
                _transferGroupOwner();
              },
            ),
            // 群管理员
            setButtonItem(
              null,
              AB_getS(context).groupManagers,
              () async {
                _setGroupManagers();
              },
            ),
            // 加群确认
            _getSwitchRowWidget(
                title: AB_getS(context).groupJoinConfirmation,
                value: enterConfirm,
                tips: AB_S().groupJoinConfirmationTip,
                onSwitchChange: (value) {
                  model.setGroupAddOpt(value ? 1 : 2);
                  setState(() {
                  });
                }),
            // 私密群
            _getSwitchRowWidget(
                title: AB_getS(context).groupPrivate,
                tips: AB_getS(context).groupPrivateTip,
                value: _groupCustomInfo.isPrivate == "1",
                onSwitchChange: (value) async {
                  final res = await ImGroupInfoUtils.setGroupPrivate(groupID: widget.groupID, isPrivate: value);
                  if (res?.code == 0) {
                    _groupCustomInfo.isPrivate = value ? "1" : "0";
                    widget.onGroupCustomInfoChange?.call(_groupCustomInfo);
                  }
                  setState(() {
                  });
                }),
            if (!isAllMuted) setButtonItem(
              null,
              AB_getS(context).muteGroup,
                  () async {
                    _muteGroupMember();
              },
            ),
            // _getSwitchRowWidget(
            //     title: AB_getS(context).muteGroupAll,
            //     tips: AB_getS(context).muteGroupAllTip,
            //     value: isAllMuted,
            //     onSwitchChange: (value) async {
            //       _muteGroup(value);
            //     }),
            // setButtonItem(null, AB_getS(context).alertSounds, tips: '系统定期清空所有人的历史消息', () async {
            //   var list = [
            //     ClearMessageType(value: 0, text: isZh ? '不清空' : 'Not Clear'),
            //     ClearMessageType(value: 1, text: '24' + (isZh ? '小时' : 'Hour')),
            //     ClearMessageType(value: 2, text: '72' + (isZh ? '小时' : 'Hour')),
            //     ClearMessageType(value: 3, text: '1' + (isZh ? '周' : 'Week')),
            //     ClearMessageType(value: 4, text: '1' + (isZh ? '个月' : 'Month')),
            //     ClearMessageType(value: 5, text: '3' + (isZh ? '个月' : 'Month')),
            //     ClearMessageType(value: 6, text: (isZh ? '半年' : 'Half A Year')),
            //     ClearMessageType(value: 7, text: (isZh ? '一年' : 'A Year')),
            //   ];
            //   ClearMessageType? value = await showSelectClearMessageTypeDialog(context, list: clearTypeList);
            //   clearType = value;
            //   setState(() {});
            // }, rightText: clearType == null ? null : clearType!.text),
          ],
        ),
      ),
    );
  }

  // switch row
  Widget _getSwitchRowWidget(
      {required String title, required bool value, String? tips, bool isLast = false, Function(bool)? onSwitchChange}) {
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

  Widget setButtonItem(String? assets, String title, Function onTap,
      {String? tips, String? rightText, bool showLine = true}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        child: ColoredBox(
          color: theme.backgroundColorWhite,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12.px, bottom: 12.px, left: 16.px, right: 16.px),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              assets == null
                                  ? SizedBox(width: 0.px)
                                  : Padding(
                                      padding: EdgeInsets.only(right: 12.px),
                                      child: SizedBox(
                                        width: 24.px,
                                        height: 24.px,
                                        child: Image.asset(
                                          assets,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              ABText(
                                title,
                                fontSize: 16.px,
                                textColor: theme.textColor,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              //13.68+4.1+7.8=25.58
                              if (rightText != null)
                                ABText(
                                  rightText,
                                  fontSize: 14,
                                  textColor: theme.text999,
                                ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.px, right: 16.px),
                                child: Image.asset(
                                  ABAssets.assetsRight(context),
                                  width: 9.px,
                                  height: 15.px,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      if (tips != null)
                        Padding(
                          padding: EdgeInsets.only(top: 8.px),
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
              if (showLine)
                Padding(
                  padding: EdgeInsets.only(left: 10.0.px),
                  child: Divider(
                    height: 1,
                    color: theme.backgroundColor,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // 转让群主
  _transferGroupOwner() async {
    final result = await ABRoute.push(GroupMemberChoosePage(groupID: widget.groupID, isSingle: true, excludeMemberIds: [UserProvider.getCurrentUser().userId ?? ""], title: AB_getS(context, listen: false).chooseMember, checkComplete: (List<GroupMemberListModel> models) async {
      if (models.isEmpty) {
        return false;
      }
      final model = models.first;
      final isConfirmed = await AlertPopWidget.show(title: AB_getS(context, listen: false).groupOwnerTransfer, content: AB_getS(context, listen: false).groupOwnerTransferTip(model.displayName ?? ""));
      return isConfirmed ?? false;
    },),) as List<GroupMemberListModel>?;
    if (result != null && result.isNotEmpty) {
      final res = await TencentImSDKPlugin.v2TIMManager.getGroupManager().transferGroupOwner(groupID: widget.groupID, userID: result.first.memberNum ?? "");
      if (res.code == 0) {
        widget.onGroupOwnerTransfer?.call();
        ABRoute.pop();
      }
    }
  }

  // 设置群管理员
  _setGroupManagers() {
    ABRoute.push(GroupAdministratorListPage(groupID: widget.groupID,));
  }




  // 禁言群成员
  void _muteGroupMember() async {
    final result = await ABRoute.push(GroupMemberChoosePage(groupID: widget.groupID, checkComplete: (List<GroupMemberListModel> models) async {
      final isConfirmed = await AlertPopWidget.show(title: "禁言", content: "是否禁言群成员？");
      return isConfirmed ?? false;
    },),) as List<GroupMemberListModel>?;
    if (result != null && result.isNotEmpty) {
      ABLoading.show();
      for (var e in result) {
        TencentImSDKPlugin.v2TIMManager.getGroupManager().muteGroupMember(groupID: widget.groupID ?? "", userID: e.memberNum ?? "", seconds: 10*365*24*3600);
      }
      ABLoading.dismiss();
    }
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

}

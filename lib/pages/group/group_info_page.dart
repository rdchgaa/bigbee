
import 'dart:ui';

import 'package:bee_chat/net/group_net.dart';
import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/pages/dialog/bottom_select_dialog.dart';
import 'package:bee_chat/pages/group/tim_search_records_page.dart';
import 'package:bee_chat/pages/group/group_info_editor_page.dart';
import 'package:bee_chat/pages/group/group_member_list_page.dart';
import 'package:bee_chat/pages/group/group_manager_page.dart';
import 'package:bee_chat/pages/group/widget/group_member_info_widget.dart';
import 'package:bee_chat/pages/common/share_group_page.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_event_bus.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/im_group_extension.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/im/im_group_info_utils.dart';
import 'package:bee_chat/utils/im/im_message_utils.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/custom_group_tip_message_data_provider.dart';

import '../../models/group/group_member_invite_model.dart';
import '../../models/group/group_member_list_model.dart';
import '../../provider/language_provider.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_image.dart';
import '../../widget/alert_pop_widget.dart';
import '../common/text_input_page.dart';
import 'group_invite_page.dart';
import 'group_member_choose_page.dart';
import 'group_mute_setting_page.dart';
export 'package:tencent_cloud_chat_uikit/ui/widgets/transimit_group_owner_select.dart';

const String quiteGroupEventName = "quiteGroupEventName";


class GroupInfoPage extends StatefulWidget {
  final String groupID;
  final Function(GroupCustomInfoModel)? onGroupCustomInfoCallback;
  // 主要用来发送消息以及清空聊天记录之类的
  final TUIChatSeparateViewModel? model;
  const GroupInfoPage({super.key, required this.groupID, this.onGroupCustomInfoCallback, this.model});


  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {

  V2TimGroupInfo? _groupInfo;
  bool _isInGroup = false;
  // 群组是否存在
  bool _isGroupExist = true;
  GroupCustomInfoModel _groupCustomInfo = GroupCustomInfoModel();
  TUIGroupProfileModel _model = TUIGroupProfileModel();

  @override
  void initState() {
    _requestIsInGroup();
    _loadGroupCustomInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: ABAppBar(
        title: AB_getS(context).groupInfo,
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
        rightWidget: !_groupInfo.isGroupOwner ? null : IconButton(
          icon: Icon(Icons.settings_outlined, color: theme.textColor,),
          onPressed: () {
            ABRoute.push(GroupManagerPage(groupID: widget.groupID, onGroupCustomInfoChange: (model){
              _groupCustomInfo = model;
              widget.onGroupCustomInfoCallback?.call(_groupCustomInfo);
              setState(() {});
            }, onGroupOwnerTransfer: () async {
              Future.delayed(Duration(milliseconds: 200)).then((_) async {
                _groupInfo?.role = GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER;
                setState(() {});
              });

            },));
          },
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          TIMUIKitGroupProfile(
            groupID: widget.groupID ?? '',
            backGroundColor: theme.backgroundColor,
            builder: (BuildContext context1,
                V2TimGroupInfo groupInfo, List<V2TimGroupMemberFullInfo?> groupMemberList) {
              if (_groupInfo == null) {
                _groupInfo = groupInfo;
                Future.delayed(Duration(milliseconds: 100)).then((_){
                  setState(() {
                  });
                });
              }

              // final faceUrl = groupInfo.faceUrl ?? "";
              final groupID = groupInfo.groupID;
              final showName = _groupCustomInfo.groupName.isNotEmpty ? _groupCustomInfo.groupName : (groupInfo.groupName ?? groupID);
              final model = Provider.of<TUIGroupProfileModel>(context1);
              _model = model;
              return Column(
                children: [
                  const SizedBox(height: 16,),
                  // 群信息
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: theme.white,
                    // height: 92,
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 92),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16,),
                        InkWell(
                          onTap: (){
                            _groupInfoClick();
                          },
                          child: SizedBox(
                            width: 64,
                            height: 64,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: ABImage.avatarUser(groupInfo.faceUrl ?? "", isGroup: true)),
                          ),
                        ),
                        const SizedBox(width: 14,),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              _groupInfoClick();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  showName,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: theme.textColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text("${(groupInfo.introduction ?? "").isNotEmpty ? groupInfo.introduction : AB_getS(context).noIntroduction}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: theme.textGrey))
                              ],
                            ),
                          ),
                        ),
                        if (_groupCustomInfo.isShowQRCode == "1") InkWell(
                          onTap: (){
                            ABRoute.push(ShareGroupPage(groupInfo: groupInfo));
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            child: QrImageView(
                              padding: EdgeInsets.all(1),
                              data: widget.groupID ?? "",
                              size: 24.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                      ],
                    ),
                  ),
                  // 群成员标题
                  if (_isInGroup) SizedBox(
                    height: 47,
                    width: ABScreen.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: 16,),
                        Container(
                          height: 38,
                          alignment: Alignment.centerLeft,
                          child: ABText(AB_getS(context).groupMember, textColor: theme.textGrey, fontSize: 14,),
                        ),
                        const SizedBox(width: 10,),
                        Container().expanded(),
                        if (_groupCustomInfo.isAllowGroupMemberAddFriend == "1" || _groupInfo.isManager)InkWell(
                          onTap: (){
                            ABRoute.push(GroupMemberListPage(groupID: widget.groupID ?? "", memberCount: groupMemberList.length, isManager: groupInfo.isManager,));
                          },
                          child: Container(
                            height: 38,
                            alignment: Alignment.centerRight,
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 16,),
                                ABText("${AB_getS(context).look}${groupMemberList.length.toString()}${AB_getS(context).groupMember1}", textColor: theme.textGrey, fontSize: 14,),
                                const SizedBox(width: 4,),
                                Icon(CupertinoIcons.right_chevron, size: 14, color: theme.textGrey,),
                                const SizedBox(width: 10,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 群成员列表
                  if (_isInGroup) Container(
                    color: theme.white,
                    child: GroupMemberInfoWidget(
                      memberList: (_groupCustomInfo.isAllowGroupMemberAddFriend == "1" || groupInfo.isManager) ? groupMemberList : groupMemberList.map((e) {
                        V2TimGroupMemberFullInfo? member = V2TimGroupMemberFullInfo(userID: "", nickName: "...", faceUrl: e?.faceUrl ?? "", nameCard: "", friendRemark: "");
                        return member;
                      }).toList(),
                      isManager: groupInfo.isManager,
                      toUserProfile: (V2TimGroupMemberFullInfo? user){
                        if (_groupCustomInfo.isAllowGroupMemberAddFriend == "1" || groupInfo.isManager) {
                          ABRoute.push(UserDetailsPage(userId: user?.userID ?? ""));
                        }
                      },
                      onInviteOrRemoveMember: (int type){
                        if (type == 1) {
                          // 邀请
                          _inviteMember();
                        } else if (type == 2) {
                          // 删除
                          _removeMember();
                        }
                      },
                    ),
                  ),
                  // 群内成员标题
                  if (_isInGroup) SizedBox(
                      height: 47,
                      width: ABScreen.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: 16,),
                            Container(
                                height: 38,
                                alignment: Alignment.centerLeft,
                                child: ABText(AB_getS(context).groupInMember, textColor: theme.textGrey, fontSize: 14,)
                            )
                          ]
                      )
                  ),
                  if (_isInGroup && (_groupInfo.isManager || _groupCustomInfo.isOnlyAdminCanModifyGroupName == "0")) _getTextRowWidget(title: AB_getS(context).groupName, content: showName, isShowArrow: true, onTap: () async {
                    final name = await ABRoute.push(TextInputPage(title: AB_getS(context, listen: false).groupName, text: showName, maxLength: 16,)) as String?;
                    if (name != null) {
                      _changeGroupName(name, context1);
                    }
                  }),
                  if (_isInGroup) _getTextRowWidget(title: AB_getS(context).myGroupName, content: model.getSelfNameCard().isNotEmpty ? model.getSelfNameCard() : AB_getS(context).notSet, isShowArrow: true, onTap: () async {
                    final name = await ABRoute.push(TextInputPage(title: AB_getS(context, listen: false).myGroupName, text: model.getSelfNameCard(),maxLength: 8,)) as String?;
                    if (name != null) {
                      _changeGroupNickName(name, context1);
                    }
                  }),
                  // 聊天会话标题
                  if (_isInGroup) SizedBox(
                      height: 47,
                      width: ABScreen.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: 16,),
                            Container(
                                height: 38,
                                alignment: Alignment.centerLeft,
                                child: ABText(AB_getS(context).chatConversion, textColor: theme.textGrey, fontSize: 14,)
                            )
                          ]
                      )
                  ),
                  if (_isInGroup&&model.conversation!=null) _getTextRowWidget(title: AB_getS(context).findChats, content:
                  "${AB_S().picture},"
                      "${AB_S().video},${AB_S().file}", isShowArrow: true, onTap: () async {
                    // TODO: 查找聊天记录
                    ABRoute.push(TimSearchRecords(conversation: model.conversation!));
                  }),
                  if (_isInGroup) _getSwitchRowWidget(title: AB_getS(context).setTop1, value: (model.conversation?.isPinned ?? false), onSwitchChange: (value){
                    _setTopGroup(value, context1);
                  }),
                  if (_isInGroup) _getSwitchRowWidget(title: AB_getS(context).messageNotDisturb, value: model.conversation?.recvOpt != ReceiveMsgOptEnum.V2TIM_RECEIVE_MESSAGE.index, onSwitchChange: (value) async {
                    _setGroupNoDisturb(value, context1);
                  }),
                  if (_isInGroup && model.conversation?.recvOpt != ReceiveMsgOptEnum.V2TIM_RECEIVE_MESSAGE.index) _getTextRowWidget(title: AB_getS(context).messageReminderMethod, content: (model.conversation?.recvOpt == ReceiveMsgOptEnum.V2TIM_NOT_RECEIVE_MESSAGE.index) ? AB_getS(context).maskingMessage : AB_getS(context).onlyReceive, isShowArrow: true, onTap: () async {
                    _setGroupMessageRemindType(context1);
                  }),
                  // 是否允许成员加好友
                  if (_isInGroup && groupInfo.isManager) _getSwitchRowWidget(title: AB_S().allowMembersAddFriends, value: _groupCustomInfo.isAllowGroupMemberAddFriend == "1", onSwitchChange: (value) async {
                    // _setGroupNoDisturb(value, context1);
                    _setAllowGroupMemberAddFriend(value, context1);
                  }),
                  // 禁言
                  if (_isInGroup && groupInfo.isManager) _getTextRowWidget(title: AB_getS(context).muteGroup, content:
                  "", isShowArrow: true, onTap: () async {
                    ABRoute.push(GroupMuteSettingPage(groupID: groupID,));
                  }),

                  // 其他
                  if (_isInGroup) SizedBox(
                      height: 47,
                      width: ABScreen.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: 16,),
                            Container(
                                height: 38,
                                alignment: Alignment.centerLeft,
                                child: ABText(AB_getS(context).other, textColor: theme.textGrey, fontSize: 14,)
                            )
                          ]
                      )
                  ),
                  if (_isInGroup) _getTextRowWidget(title: AB_S().deleteChatHistory, isShowArrow: false, onTap: () async {
                    final isDelete = await AlertPopWidget.show(title: AB_S().deleteChatHistory, content: AB_S().deleteChatHistoryTip);
                    if (isDelete != true) return;
                    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().clearGroupHistoryMessage(groupID: widget.groupID);
                    if (res.code == 0) {
                      ABToast.show(AB_S().deleteChatHistorySuccessTip);
                      widget.model?.clearHistory();
                    } else {
                      ABToast.show(res.desc.isNotEmpty ? res.desc : AB_S().deleteChatHistoryFailedTip);
                    }
                  }),
                  if (_isInGroup) const SizedBox(height: 10,),
                ],
              );
            },
          ).expanded(),
          // 退出群聊按钮
          if (_getBtnTitle().isNotEmpty) const SizedBox(height: 10,),
          if (_getBtnTitle().isNotEmpty) ABButton(
            text: _getBtnTitle(),
            height: 48.px,
            backgroundColor: _getBtnBackgroundColor(),
            textColor: Colors.white,
            fontWeight: FontWeight.w600,
            onPressed: () {
              if (_groupInfo.isGroupOwner) {
              }
              _groupAction();
            },
          ).addMargin(margin: EdgeInsets.only(left: 24.px, right: 24.px)),
          SizedBox(height: 10.px + ABScreen.bottomHeight,),
        ],
      ),
    );
  }

  String _getBtnTitle() {
    // print("是否是群主 - ${_groupInfo.isGroupOwner}");
    if (!_isGroupExist) {
      return "";
    }
    if (_groupInfo.isGroupOwner) {
      return AB_getS(context).disbandGroup;
    }
    if (_isInGroup) {
      return AB_getS(context).exitGroup;
    }
    return AB_getS(context).joinGroup;
  }

  Color _getBtnBackgroundColor() {
    final theme = AB_theme(context);
    if (!_isGroupExist) {
      return Colors.transparent;
    }
    if (_groupInfo.isGroupOwner) {
      return Colors.grey;
    }
    if (_isInGroup) {
      return Colors.grey;
    }
    return theme.primaryColor;
  }


  // 文字row
  Widget _getTextRowWidget({required String title, String? content, bool isShowArrow = true, bool isLast = false, Function? onTap}) {
    final theme = AB_theme(context);
    return Container(
      color: theme.white,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              if(onTap != null){
                onTap();
              }
            },
            child: SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 16,),
                  ABText(title, textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,),
                  const SizedBox(width: 10,),
                  Expanded(child: Container(
                    alignment: Alignment.centerRight,
                    child: ABText(content ?? "", textColor: theme.textGrey, fontSize: 14,),
                  )),
                  if(isShowArrow) const SizedBox(width: 4,),
                  if(isShowArrow) Icon(CupertinoIcons.right_chevron, size: 14, color: theme.textGrey,),
                  const SizedBox(width: 16,),
                ],
              ),
            ),
          ),
          if(!isLast) Divider(height: 1, color: theme.backgroundColor,).addPadding(padding: const EdgeInsets.only(left: 16, right: 16)),
        ],
      ),
    );
  }

  // switch row
  Widget _getSwitchRowWidget({required String title, required bool value, bool isLast = false, Function(bool)? onSwitchChange}) {
    final theme = AB_theme(context);
    return Container(
      color: theme.white,
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16,),
                ABText(title, textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,),
                Expanded(child: Container()),
                const SizedBox(width: 4,),
                CupertinoSwitch(
                  value: value,
                  onChanged: (value){
                    onSwitchChange?.call(value);
                  },
                  activeColor: theme.primaryColor,
                ),
                const SizedBox(width: 16,),
              ],
            ),
          ),
          if(!isLast) Divider(height: 1, color: theme.backgroundColor,).addPadding(padding: const EdgeInsets.only(left: 16, right: 16)),
        ],
      ),
    );
  }


  // 群信息点击
  void _groupInfoClick() async {
    if (widget.groupID.isEmpty || !_groupInfo.isManager) {
      return;
    }
    ABRoute.push(GroupInfoEditorPage(groupID: widget.groupID, model: widget.model, onGroupCustomInfoCallback: (customInfo){
      setState(() {
        _groupCustomInfo = customInfo;
      });
      widget.onGroupCustomInfoCallback?.call(_groupCustomInfo);
    },));
  }


  // 修改群名称
  void _changeGroupName(String name, BuildContext context1) async {
    final success = AB_getS(context, listen: false).changeSuccess;
    final failed = AB_getS(context, listen: false).changeFail;

    ABLoading.show();
    final groupCustomRes = await ImGroupInfoUtils.getGroupCustomInfoModel(groupID: widget.groupID ?? "");
    setState(() {
      _groupCustomInfo = groupCustomRes;
    });
    widget.onGroupCustomInfoCallback?.call(_groupCustomInfo);
    if (_groupCustomInfo.isOnlyAdminCanModifyGroupName == "1" && !_groupInfo.isManager) {
      await ABLoading.dismiss();
      ABToast.show(AB_S().noPermission);
      return;
    }
    final result = await ImGroupInfoUtils.setGroupName(groupID: widget.groupID, groupName: name);
    ABLoading.dismiss();
    if (result?.code == 0) {
      setState(() {
        _groupCustomInfo.groupName = name;
      });
      widget.onGroupCustomInfoCallback?.call(_groupCustomInfo);
      CustomGroupTipMessageModel m = CustomGroupTipMessageModel(
        target: name,
        type: 1,
      );
      if (widget.model != null) {
        V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await ImMessageUtils.createGroupCustomTipsMessage(model: m);
        if (createCustomMessageRes.code == 0 && createCustomMessageRes.data?.id != null && createCustomMessageRes.data?.messageInfo != null) {}
        widget.model!.sendMessage(convID: widget.groupID, convType: ConvType.group, id: createCustomMessageRes.data!.id!, messageInfo: createCustomMessageRes.data!.messageInfo!);
      } else {
        ImMessageUtils.sendGroupCustomTipsMessage(groupId: widget.groupID, model: m);
      }
      ABToast.show(success);
    } else {
      ABToast.show((result?.desc ?? "").isNotEmpty ? result!.desc : failed);
    }

  }

  // 修改我的群昵称
  void _changeGroupNickName(String name, BuildContext context1) async {
    final success = AB_getS(context, listen: false).changeSuccess;
    final failed = AB_getS(context, listen: false).changeFail;

    ABLoading.show();
    final model = Provider.of<TUIGroupProfileModel>(context1, listen: false);
    final result = await model.setNameCard(name);
    ABLoading.dismiss();
    if (result != null) {
      if (result.code == 0) {
        ABToast.show(success);
      } else {
        ABToast.show(result.desc.isNotEmpty ? result.desc : failed);
      }
    } else {
      ABToast.show(failed);
    }
  }

  // 置顶群聊
  void _setTopGroup(bool isTop, BuildContext context1) async {
    ABLoading.show();
    final model = Provider.of<TUIGroupProfileModel>(context1, listen: false);
    await model.pinedConversation(isTop);
    ABLoading.dismiss();
  }

  // 免打扰设置
  void _setGroupNoDisturb(bool isNoDisturb, BuildContext context1) async {
    ABLoading.show();
    final model = Provider.of<TUIGroupProfileModel>(context1, listen: false);
    await model.setMessageDisturb(isNoDisturb);
    ABLoading.dismiss();
  }

  // 设置消息提醒方式
  void _setGroupMessageRemindType(BuildContext context1) async {
    final theme = AB_T();
    final model = Provider.of<TUIGroupProfileModel>(context1, listen: false);
    BottomSelectDialog.show(
        context,
        actions: [
          BottomSelectDialogAction(title: AB_S().onlyReceive, onTap: () async {
            ABLoading.show();
            await model.setMessageRemind(ReceiveMsgOptEnum.V2TIM_RECEIVE_NOT_NOTIFY_MESSAGE);
            ABLoading.dismiss();
          }),
          BottomSelectDialogAction(title: AB_S().maskingMessage, onTap: () async {
            ABLoading.show();
            await model.setMessageRemind(ReceiveMsgOptEnum.V2TIM_NOT_RECEIVE_MESSAGE);
            ABLoading.dismiss();
          })
        ],
        isShowCancel: true,
    );
  }

  // 设置是否允许成员添加好友
  void _setAllowGroupMemberAddFriend(bool isAllowGroupMemberAddFriend, BuildContext context1) async {
    final failed = AB_getS(context, listen: false).changeFail;
    ABLoading.show();
    final result = await ImGroupInfoUtils.setAllowGroupMemberAddFriend(groupID: widget.groupID, isAllowGroupMemberAddFriend: isAllowGroupMemberAddFriend);
    ABLoading.dismiss();
    if (result?.code == 0) {
      setState(() {
        _groupCustomInfo.isAllowGroupMemberAddFriend = isAllowGroupMemberAddFriend ? "1" : "0";
      });
      widget.onGroupCustomInfoCallback?.call(_groupCustomInfo);
      // CustomGroupTipMessageModel m = CustomGroupTipMessageModel(
      //   target: isAllowGroupMemberAddFriend ? "1" : "0",
      //   type: 2,
      // );
      // if (widget.model != null) {
      //   V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
      //   await ImMessageUtils.createGroupCustomTipsMessage(model: m);
      //   if (createCustomMessageRes.code == 0 && createCustomMessageRes.data?.id != null && createCustomMessageRes.data?.messageInfo != null) {}
      //   widget.model!.sendMessage(convID: widget.groupID, convType: ConvType.group, id: createCustomMessageRes.data!.id!, messageInfo: createCustomMessageRes.data!.messageInfo!);
      // } else {
      //   ImMessageUtils.sendGroupCustomTipsMessage(groupId: widget.groupID, model: m);
      // }
    } else {
      ABToast.show((result?.desc ?? "").isNotEmpty ? result!.desc : failed);
    }
  }

  // 邀请好友
  void _inviteMember() async {
    final result = await ABRoute.push(GroupInvitePage(groupID: widget.groupID ?? "",)) as List<GroupMemberInviteModel>?;
    if (result != null && result.isNotEmpty) {
    }
  }

  // 移除好友
  void _removeMember() async {
    final result = await ABRoute.push(GroupMemberChoosePage(groupID: widget.groupID, checkComplete: (List<GroupMemberListModel> models) async {
      final isConfirmed = await AlertPopWidget.show(title: AB_getS(context, listen: false).removeGroupMember, content: AB_getS(context, listen: false).removeGroupMemberTip);
      return isConfirmed ?? false;
    },),) as List<GroupMemberListModel>?;
    if (result != null && result.isNotEmpty) {
      ABLoading.show();
      final res = await TencentImSDKPlugin.v2TIMManager.getGroupManager().kickGroupMember(groupID: widget.groupID ?? "", memberList: result.map((e)=> e.memberNum ?? "").toList());
      ABLoading.dismiss();
      if (res.code == 0) {
        ABToast.show(AB_getS(context, listen: false).removeGroupMemberSuccess);
      } else {
        ABToast.show(res.desc);
      }
    }
  }

  void _groupAction() {
    if (!_isGroupExist) {
      return;
    }
    if (_groupInfo.isGroupOwner) {
      _disbandGroup();
      return;
    }
    if (_isInGroup) {
      _quitGroup();
      return;
    }
    _joinGroup();
    return;
  }

  // 加入群
  void _joinGroup() async {
    AlertPopWidget.show(title: AB_getS(context, listen: false).joinGroup, content: AB_getS(context, listen: false).joinGroupTip, onPressed: (bool isConfirm) async {
      if (isConfirm) {
        ABLoading.show();
        final res = await TIMUIKitCore.getSDKInstance().joinGroup(groupID: widget.groupID ?? "", message: '');
        ABLoading.dismiss();
        if (res.code == 0) {
          final _ = await TencentImSDKPlugin.v2TIMManager
              .getConversationManager()
              .deleteConversation(conversationID: "group_${widget.groupID}");
          ABEventBus.fire(ABEvent(name: quiteGroupEventName, data: "group_${widget.groupID}"));
          // _requestIsInGroup();
          setState(() {
            // _isInGroup = true;
            _groupInfo = null;
          });
          // ABRoute.popToRoot();
        } else {
          ABToast.show(res.desc);
        }
      }
    });
  }

  // 解散群
  void _disbandGroup() async {
    AlertPopWidget.show(title: AB_getS(context, listen: false).disbandGroup, content: AB_getS(context, listen: false).disbandGroupTip, onPressed: (bool isConfirm) async {
      if (isConfirm) {
        ABLoading.show();
        final res = await TIMUIKitCore.getSDKInstance().dismissGroup(groupID: widget.groupID ?? "");
        ABLoading.dismiss();
        if (res.code == 0) {
          setState(() {
            _isInGroup = false;
            _isGroupExist = false;
          });
        }
      }
    });
  }

  // 退出群聊
  void _quitGroup() async {
    AlertPopWidget.show(title: AB_getS(context, listen: false).exitGroup, content: AB_getS(context, listen: false).exitGroupTip, onPressed: (bool isConfirm) async {
      if (isConfirm) {
        ABLoading.show();
        final res = await TIMUIKitCore.getSDKInstance().quitGroup(groupID: widget.groupID ?? "");
        ABLoading.dismiss();
        if (res.code == 0) {
          final _ = await TencentImSDKPlugin.v2TIMManager
              .getConversationManager()
              .deleteConversation(conversationID: "group_${widget.groupID}");
          ABEventBus.fire(ABEvent(name: quiteGroupEventName, data: "group_${widget.groupID}"));
          setState(() {
            _isInGroup = false;
            _groupInfo = null;
          });
        } else {
          ABToast.show(res.desc);
        }
      }
    });
  }


  _requestIsInGroup() async {
    ABLoading.show();
    final result = await GroupNet.isInGroup(groupID: widget.groupID ?? "");
    ABLoading.dismiss();
    setState(() {
      _isGroupExist = !(result.code == 500);
      _isInGroup = result.data ?? false;
    });

  }

  _loadGroupCustomInfo() {
    ImGroupInfoUtils.getGroupCustomInfoModel(groupID: widget.groupID ?? "").then((value) {
      setState(() {
        _groupCustomInfo = value;
      });
    });
  }



}


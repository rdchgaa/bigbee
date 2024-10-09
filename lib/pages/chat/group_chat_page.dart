import 'dart:async';
import 'dart:convert';

import 'package:bee_chat/net/mine_net.dart';
import 'package:bee_chat/pages/chat/red_bag/red_bag_send_page.dart';
import 'package:bee_chat/pages/chat/widget/im_jump_to_unread.dart';
import 'package:bee_chat/pages/group/group_member_choose_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/im_group_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:provider/provider.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/chat_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/red_envelope_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/TIMUIKitTongue/tim_uikit_chat_history_message_list_tongue.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_multi_select_panel.dart';

import '../../main.dart';
import '../../models/group/group_member_list_model.dart';
import '../../models/im/custom_emoji_model.dart';
import '../../provider/custom_emoji_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_loading.dart';
import '../../utils/ab_toast.dart';
import '../../utils/im/im_group_info_utils.dart';
import '../../utils/im/im_message_utils.dart';
import '../../utils/oss_utils.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_text.dart';
import '../contact/user_details_page.dart';
import '../group/group_application_page.dart';
import '../group/group_info_page.dart';
import '../map/map_select_page.dart';
import 'c2c_chat_page.dart';

class GroupChatPage extends StatefulWidget {
  final V2TimConversation selectedConversation;
  final V2TimMessage? v2TimMessage;

  const GroupChatPage({super.key, required this.selectedConversation, this.v2TimMessage});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  // 会话
  late V2TimConversation _selectedConversation;
  final TIMUIKitChatController _imController = TIMUIKitChatController();
  GroupCustomInfoModel _groupCustomInfo = GroupCustomInfoModel();

  // 群聊在线人数
  int _onlineNum = 0;

  // 群组是否存在
  bool _isGroupExist = true;

  late TUICallObserver _observer;
  late V2TimAdvancedMsgListener _chatListener;
  GlobalKey<TUIChatState> imWidgetKey = GlobalKey();
  Timer? _timer;

  V2TimGroupInfo? _groupInfo;

  @override
  void initState() {
    _selectedConversation = widget.selectedConversation;
    _loadFroupInfo();
    _loadGroupCustomInfo();
    _getOnlineNum();
    _listennerAction();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // 每5秒执行一次
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        final _ = TUICallKit.state;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    TUICallEngine.instance.removeObserver(_observer);
    TencentImSDKPlugin.v2TIMManager.getMessageManager().removeAdvancedMsgListener(listener: _chatListener);
  }

  @override
  Widget build(BuildContext context) {
    print("群信息 - ${_groupInfo?.isManager} - ${_groupCustomInfo.isAllowGroupMemberAddFriend}");
    final theme = AB_theme(context);
    return TIMUIKitChat(
      key: imWidgetKey,
      controller: _imController,
      conversation: _selectedConversation,
      conversationID: _getConvID(),
      // 生命周期
      lifeCycle: ChatLifeCycle(
        messageShouldMount: (message) {
          if (!ImMessageUtils.isShouldLoad(message)) {
            return false;
          }
          return true;
        },
      ),
      // customStickerPanel: renderCustomStickerPanel,
      config: TIMUIKitChatConfig(
        // 仅供演示，非全部配置项，实际使用中，可只传和默认项不同的参数，无需传入所有开关
        isAllowClickAvatar: true,
        isShowOthersNameInGroup: (_groupCustomInfo.isAllowGroupMemberAddFriend == "1" || _groupInfo?.isManager == true),
        isUseDefaultEmoji: true,
        stickerPanelConfig: StickerPanelConfig(
          // useTencentCloudChatStickerPackage: true,
          useQQStickerPackage: true,
          unicodeEmojiList: [],
        ),
        isAllowLongPressMessage: true,
        // 不显示已读状态
        isShowReadingStatus: false,
        isShowGroupReadingStatus: false,
        isReportGroupReadingStatus: false,
        notificationTitle: "",
        isUseMessageReaction: false,
        groupReadReceiptPermissionList: [
          GroupReceiptAllowType.work,
          GroupReceiptAllowType.meeting,
          GroupReceiptAllowType.public
        ],
      ),
      morePanelConfig: MorePanelConfig(
          extraAction: [
            MorePanelItem(
                id: "location",
                title: AB_S().location,
                icon: Container(
                  height: 64,
                  width: 64,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                      color: AB_themeProvider(context).imTheme.weakBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Center(
                    child: Image.asset(
                      "assets/images/im/more_location.png",
                      height: 32,
                      width: 32,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                onTap: (context) async {
                  final result = await ABRoute.push(MapSelectPage(rightBtnTitle: AB_S().send,)) as BMFPoiInfo?;
                  if (result != null) {
                    final latitude = result.pt?.latitude ?? 0;
                    final longitude = result.pt?.longitude ?? 0;
                    final name = result.name ?? "";
                    final address = result.address ?? "";

                    Map<String, String> desc = {
                      "name": name,
                      "address": address,
                    };
                    final descStr = jsonEncode(desc);
                    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createLocationMessage(
                      latitude: latitude,
                      longitude: longitude,
                      desc: descStr,
                    );
                    if (res.data?.messageInfo != null) {
                      final message = res.data!.messageInfo!;
                      _imController.sendMessage(messageInfo: message);
                    }
                  }
                }
            )
          ]
      ),
      appBarConfig: ABAppBar(
        backgroundColor: theme.white,
        navigationBarHeight: 52,
        customTitle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _groupCustomInfo.groupName.isNotEmpty ? _groupCustomInfo.groupName : _selectedConversation.showName ?? "",
              style: TextStyle(
                fontSize: 16.px,
                color: theme.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            ABText(
              "$_onlineNum${AB_getS(context).presentNumOnline}",
              fontSize: 12.px,
              textColor: theme.primaryColor,
            ),
          ],
        ),
        rightWidget: _isGroupExist
            ? Container(
                alignment: Alignment.centerRight,
                width: 44 + 16.px,
                height: 44.0,
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () async {
                    ABRoute.push(GroupInfoPage(
                      groupID: _selectedConversation.groupID ?? "",
                      model: _imController.model,
                      onGroupCustomInfoCallback: (groupCustomInfo) {
                        setState(() {
                          _groupCustomInfo = groupCustomInfo;
                        });
                      },
                    ));
                  },
                  tooltip: 'info',
                  padding: EdgeInsets.only(right: 16.px),
                  icon: Icon(
                    CupertinoIcons.ellipsis,
                    color: theme.textColor,
                  ),
                ),
              )
            : null,
      ),
      // 消息气泡
      messageItemBuilder: ImageListUIHelper.getMessageItemBuilder(_selectedConversation, _imController),
      conversationType: ConvType.values[widget.selectedConversation.type ?? 1],
      // 小舌头（跳转维度消息， 跳转最新消息）
      tongueItemBuilder:
          (VoidCallback onClick, MessageListTongueType valueType, int unreadCount, String atNum, int previousCount) {
        return ImTongueItem(
            onClick: onClick,
            valueType: valueType,
            previousCount: previousCount,
            unreadCount: unreadCount,
            atNum: atNum);
      },
      customStickerPanel: _renderCustomStickerPanel,
      // 头像点击
      onTapAvatar: (String userID, TapDownDetails tapDetails) {
        if (_groupCustomInfo.isAllowGroupMemberAddFriend == "1" || _groupInfo?.isManager == true) {
          ABRoute.push(UserDetailsPage(userId: userID));
        }

      },
      // 群待处理回调
      onDealWithGroupApplication: (value) {
        ABRoute.push(GroupApplicationPage(
          groupID: value,
        ));
      },
      // 获取选择群成员
      getSelectMember: (groupID, selectedMemberIds, excludeMemberIds, maxNum) async {
        final memberList = await ABRoute.push(GroupMemberChoosePage(
          title: AB_getS(context, listen: false).chooseMember,
          groupID: groupID,
          selectedMemberIds: selectedMemberIds,
          excludeMemberIds: excludeMemberIds,
          checkComplete: (List<GroupMemberListModel> memberList) {
            if (maxNum == null || maxNum == 0) {
              return Future.value(true);
            }
            if (memberList.length <= maxNum) {
              return Future.value(true);
            } else {
              ABToast.show("${AB_getS(context, listen: false).maxNumTip}$maxNum");
              return Future.value(false);
            }
          },
        )) as List<GroupMemberListModel>?;
        if (memberList != null && memberList.isNotEmpty) {
          final memberIDList = memberList.map((e) => e.memberNum ?? "").toList().where((e) => e.isNotEmpty).toList();
          return Future.value(memberIDList);
        }
        return Future.value([]);
      },
      sendRedEnvelope: () {
        sendRedEnvelope();
      },
      collectionCallback: (List<V2TimMessage> messageList) async {
        // TODO: 点击收藏
        if (messageList.isEmpty) {
          return false;
        }
        for (var element in messageList) {
          final re = ImMessageUtils.isMessageCanCollect(message: element);
          if (!re.$1) {
            ABToast.show(re.$2);
            return false;
          }
        }
        ABLoading.show();
        final res = await MineNet.collectMessages(messageList: messageList, groupId: _selectedConversation.groupID ?? "");
        ABLoading.dismiss();
        if (res.data != null) {
          ABToast.show(AB_S().collectSuccess);
          return true;
        }
        return false;
      },
      mergePictureCallback: (List<String> paths ) async {
        ABLoading.show();
        final (List<String>, String) result = await OssUtils.uploadMultiFilesToOss(paths: paths);
        final urls = result.$1;
        if (urls.isEmpty) {
          await ABLoading.dismiss();
          ABToast.show(result.$2);
          return;
        }
        V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes = await ImMessageUtils.createMultiImageMessage(imageList: urls);
        await ABLoading.dismiss();
        if (createCustomMessageRes.code == 0 && createCustomMessageRes.data?.messageInfo != null) {
          String id = createCustomMessageRes.data?.id ?? '';
          // 发送自定义消息
          final res = await _imController.model?.sendMessage(convID: widget.selectedConversation.groupID ?? "", convType: ConvType.group, id: id, messageInfo: createCustomMessageRes.data!.messageInfo!);
          if (res?.code != 0) {
            ABToast.show(res?.desc ?? AB_S().sendFail);
          }
        }
      },
      initFindingMsg: widget.v2TimMessage,
    );
  }

  sendRedEnvelope() async {
    SendRedResult? value =
        await ABRoute.push(RedBagSendPage(isGroup: true, userOrGroupId: _selectedConversation.groupID ?? ""));
    if (value != null) {
      final msg = await ImMessageUtils.createRedEnvelopeMessage(sendRedResult: value);
      _imController.sendMessage(messageInfo: msg, convType: ConvType.group, groupID: _selectedConversation.groupID ?? "");
    }
  }

  _listennerAction() {
    // 创建listener
    _chatListener = V2TimAdvancedMsgListener(
      onRecvC2CReadReceipt: (List<V2TimMessageReceipt> receiptList) {},
      onRecvMessageModified: (V2TimMessage message) {},
      onRecvMessageReadReceipts: (List<V2TimMessageReceipt> receiptList) {},
      onRecvMessageRevoked: (String messageid) {},
      onRecvNewMessage: (V2TimMessage message) {
        // 使用自定义消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
          debugPrint("自定义消息 - ${message.customElem?.data ?? ""}");
          _onLoadCallWidget();
        }
      },
      onSendMessageProgress: (V2TimMessage message, int progress) {},
    );
// 注册listener
    TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(listener: _chatListener);

    _observer = TUICallObserver(onError: (int code, String message) {
      debugPrint("通话回调 error: $code, $message");
      _onLoadCallWidget();
    }, onCallBegin: (TUIRoomId roomId, TUICallMediaType callMediaType, TUICallRole callRole) {
      debugPrint("通话回调 begin: $roomId, $callMediaType, $callRole");
      _onLoadCallWidget();
    }, onCallEnd: (TUIRoomId roomId, TUICallMediaType callMediaType, TUICallRole callRole, double totalTime) {
      debugPrint("通话回调 end: $roomId, $callMediaType, $callRole, $totalTime");
      _onLoadCallWidget();
    }, onUserJoin: (String userId) {
      debugPrint("通话回调 join: $userId");
      _onLoadCallWidget();
    }, onUserLeave: (String userId) {
      debugPrint("通话回调 leave: $userId");
      _onLoadCallWidget();
    }, onCallReceived:
        (String callerId, List<String> calleeIdList, String groupId, TUICallMediaType callMediaType, String? userData) {
          debugPrint("通话回调 received: $callerId, $calleeIdList, $groupId, $callMediaType, $userData");
      _onLoadCallWidget();
    });
    TUICallEngine.instance.addObserver(_observer);
  }

  _onLoadCallWidget() {
    debugPrint("加载通话widget");
    Future.delayed(const Duration(milliseconds: 500), () {
      imWidgetKey.currentState?.updateJoinInGroupCallWidget();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      imWidgetKey.currentState?.updateJoinInGroupCallWidget();
    });
  }

  String? _getConvID() {
    return widget.selectedConversation.type == 1
        ? widget.selectedConversation.userID
        : widget.selectedConversation.groupID;
  }

  void _getOnlineNum() async {
    final groupID = _selectedConversation.groupID;
    if (groupID == null) return;
    final onlineNum =
        await TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupOnlineMemberCount(groupID: groupID);
    debugPrint("群在线人数 - ${onlineNum.toJson()}");
    setState(() {
      _isGroupExist = onlineNum.code != 10010;
      _onlineNum = onlineNum.data ?? 0;
    });
  }

  Widget _renderCustomStickerPanel({
    addCustomEmojiText,
    addText,
    List<CustomEmojiFaceData> defaultCustomEmojiStickerList = const [],
    deleteText,
    height,
    sendFaceMessage,
    sendTextMessage,
    width,
  }) {
    final theme = AB_theme(context);
    CustomEmojiProvider provider = Provider.of<CustomEmojiProvider>(
        MyApp.context,
        listen: false);
    List<CustomEmojiModel> customEmojiList = provider.customEmojiList.where((e){
      if (e.id == null || e.emoticonsInfoList?.isNotEmpty != true) {
        return false;
      }
      return true;
    }).toList();

    List<CustomStickerPackage> customStickerPackageList = customEmojiList.map((e) {
      List<CustomSticker> stickerList = e.emoticonsInfoList!.map((e1){
        return CustomSticker(
          name: e1.name ?? "",
          index: e1.id ?? 0,
          url: e1.imgUrl ?? "",
        );
      }).toList();
      return CustomStickerPackage(name: e.name ?? "", stickerList: stickerList, menuItem: CustomSticker(
          name: e.name ?? "",
          index: e.id ?? 0,
          url: e.imgUrl ?? ""));
    }).toList();
    final defaultEmojiList = defaultCustomEmojiStickerList
        .where((face) => face.name == 'tcc1')
        .map((CustomEmojiFaceData customEmojiFaceData) {
      return CustomStickerPackage(
        name: customEmojiFaceData.name,
        baseUrl: "assets/custom_face_resource/${customEmojiFaceData.name}",
        isEmoji: customEmojiFaceData.isEmoji,
        isDefaultEmoji: true,
        stickerList: customEmojiFaceData.list
            .asMap()
            .keys
            .map(
              (idx) => CustomSticker(
            index: idx,
            name: customEmojiFaceData.list[idx],
          ),
        )
            .toList(),
        menuItem: CustomSticker(
          index: 0,
          name: customEmojiFaceData.icon,
        ),
      );
    }).toList();
    final defaultEmojiList1 = defaultCustomEmojiStickerList
        .where((face) => face.name == '4349')
        .map((CustomEmojiFaceData customEmojiFaceData) {
      return CustomStickerPackage(
        name: customEmojiFaceData.name,
        baseUrl: "assets/custom_face_resource/${customEmojiFaceData.name}",
        isEmoji: customEmojiFaceData.isEmoji,
        isDefaultEmoji: true,
        stickerList: customEmojiFaceData.list
            .asMap()
            .keys
            .map(
              (idx) => CustomSticker(
            index: idx,
            name: customEmojiFaceData.list[idx],
          ),
        )
            .toList(),
        menuItem: CustomSticker(
          index: 0,
          name: customEmojiFaceData.icon,
        ),
      );
    }).toList();

    final defEmojiList = TUIKitStickerConstData.defaultUnicodeEmojiList.map((emojiItem) {
      return CustomSticker(index: 0, name: emojiItem.toString(), unicode: emojiItem);
    }).toList();
    final defEmoji = CustomStickerPackage(name: "defaultEmoji", stickerList: defEmojiList, menuItem: defEmojiList[0]);


    return StickerPanel(
      isWideScreen: false,
      width: width,
      height: height,
      panelPadding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
      showBottomContainer: true,
      backgroundColor: theme.white,
      sendTextMsg: sendTextMessage,
      sendFaceMsg: sendFaceMessage,
      showDeleteButton: false,
      deleteText: deleteText,
      addText: addText,
      addCustomEmojiText: addCustomEmojiText,
      customStickerPackageList: [
        ...defaultEmojiList,
        ...defaultEmojiList1,
        defEmoji,
        ...customStickerPackageList,
      ],
      lightPrimaryColor: theme.primaryColor,
      // lightPrimaryColor: AppTheme.current.colors0xFFFFFF,
    );
  }

  _loadFroupInfo() {
    TencentImSDKPlugin.v2TIMManager.getGroupManager().getGroupsInfo(
      groupIDList: [widget.selectedConversation.groupID ?? ""],
    ).then((value) {
      final data = value.data;
      if (data != null && data.isNotEmpty) {
        setState(() {
          _groupInfo = data.first.groupInfo;
        });
      }
    });
  }

  _loadGroupCustomInfo() {
    ImGroupInfoUtils.getGroupCustomInfoModel(groupID: widget.selectedConversation.groupID ?? "").then((value) {
      setState(() {
        _groupCustomInfo = value;
      });
    });
  }


}

import 'dart:async';
import 'dart:convert';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/net/mine_net.dart';
import 'package:bee_chat/pages/chat/dialog/red_open_dialog.dart';
import 'package:bee_chat/pages/chat/red_bag/red_bag_send_page.dart';
import 'package:bee_chat/pages/chat/widget/im_jump_to_unread.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_custom_message_item.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_file_message_item.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_image_message_item.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_location_message_item.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_merger_message_item.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_reply_message_item.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_sound_message_item.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_text_message_item.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_video_message_item1.dart';
import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/oss_utils.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/chat_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/TIMUIKitTongue/tim_uikit_chat_history_message_list_tongue.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';

import '../../models/im/custom_emoji_model.dart';
import '../../provider/custom_emoji_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_event_bus.dart';
import '../../utils/im/im_message_utils.dart';
import '../contact/contact_setting_page.dart';
import '../map/map_select_page.dart';

class C2cChatPage extends StatefulWidget {
  final V2TimConversation selectedConversation;
  final V2TimMessage? v2TimMessage;
  const C2cChatPage({super.key, required this.selectedConversation, this.v2TimMessage});

  @override
  State<C2cChatPage> createState() => _C2cChatPageState();
}

class _C2cChatPageState extends State<C2cChatPage> {
  // 会话
  late V2TimConversation _selectedConversation;
  GlobalKey<TUIChatState> imWidgetKey = GlobalKey();
  final TIMUIKitChatController _imController = TIMUIKitChatController();

  // 好友是否在线
  V2TimUserStatus _userStatus = V2TimUserStatus();
  late StreamSubscription _subscription;

  @override
  void initState() {
    _selectedConversation = widget.selectedConversation;
    _userStatus.userID = _selectedConversation.userID;
    _loadUserStatus();
    //订阅：
    _subscription = ABEventBus.on<ABEvent>((event) {
      if (event.name == friendRemarkChangedEventName) {
        final newRemark = event.data as String;
        setState(() {
          _selectedConversation.showName = newRemark;
        });
      }
      if (event.name == friendDidDeleteEventName) {
        Future.delayed(const Duration(milliseconds: 200), () {
          ABRoute.popToRoot();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // 取消订阅：
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return TIMUIKitChat(
      key: imWidgetKey,
      controller: _imController,
      conversation: _selectedConversation,
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
      // customStickerPanel: renderCustomStickerPanel,
      // 生命周期
      lifeCycle: ChatLifeCycle(
        messageShouldMount: (message) {
          if (!ImMessageUtils.isShouldLoad(message)) {
            return false;
          }
          return true;
        },
      ),
      config: TIMUIKitChatConfig(
        // 仅供演示，非全部配置项，实际使用中，可只传和默认项不同的参数，无需传入所有开关
        isAllowClickAvatar: true,
        isUseDefaultEmoji: true,
        stickerPanelConfig: StickerPanelConfig(
          // useTencentCloudChatStickerPackage: true,
          useQQStickerPackage: true,
          unicodeEmojiList: [],
        ),
        isAllowLongPressMessage: true,
        isAllowLongPressAvatarToAt: false,
        // 显示已读状态
        isShowReadingStatus: true,
        isShowGroupReadingStatus: true,
        notificationTitle: "",
        isUseMessageReaction: false,
        groupReadReceiptPermissionList: [
          GroupReceiptAllowType.work,
          GroupReceiptAllowType.meeting,
          GroupReceiptAllowType.public
        ],
      ),
      appBarConfig: ABAppBar(
        backgroundColor: theme.white,
        navigationBarHeight: 52,
        customTitle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _selectedConversation.showName ?? "",
              style: TextStyle(
                fontSize: 16.px,
                color: theme.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8.px,
                  height: 8.px,
                  decoration: BoxDecoration(
                    color: _getUserOnlineStatus(_userStatus) == TIMUserOnlineStatus.online
                        ? HexColor("#00FF47")
                        : theme.grey,
                    borderRadius: BorderRadius.circular(4.px),
                  ),
                ),
                SizedBox(
                  width: 6.px,
                ),
                ABText(
                  _getUserOnlineStatus(_userStatus) == TIMUserOnlineStatus.online
                      ? AB_getS(context).online
                      : AB_getS(context).offline,
                  fontSize: 12.px,
                  textColor: theme.grey,
                ),
              ],
            ),
          ],
        ),
        rightWidget: Container(
          alignment: Alignment.centerRight,
          width: 44 + 16.px,
          height: 44.0,
          color: Colors.transparent,
          child: IconButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (_selectedConversation.userID != null) {
                ABRoute.push(UserDetailsPage(userId: _selectedConversation.userID!, model: _imController.model,));
              }
            },
            tooltip: 'Back',
            padding: EdgeInsets.only(right: 16.px),
            icon: Icon(
              CupertinoIcons.ellipsis,
              color: theme.textColor,
            ),
          ),
        ),
      ),
      // 消息气泡
      messageItemBuilder: ImageListUIHelper.getMessageItemBuilder(_selectedConversation, _imController),
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
        ABRoute.push(UserDetailsPage(userId: userID));
      },
      sendRedEnvelope: () {
        // openRed();
        // return;
        sendRedEnvelope();
      },
      collectionCallback: (List<V2TimMessage> messageList) async {
        // TODO: 点击收藏
        debugPrint("选择的消息 - ${messageList.map((e) => e.msgID)}");

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
        final res = await MineNet.collectMessages(messageList: messageList);
        ABLoading.dismiss();
        if (res.data != null) {
          ABToast.show(AB_S().collectSuccess);
          return true;
        }
        return false;
      },
      mergePictureCallback: (List<String> paths ) async {
        debugPrint("合并图片 - $paths");
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
          final res = await _imController.model?.sendMessage(convID: widget.selectedConversation.userID ?? "", convType: ConvType.c2c, id: id, messageInfo: createCustomMessageRes.data!.messageInfo!);
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
        await ABRoute.push(RedBagSendPage(isGroup: false, userOrGroupId: _selectedConversation.userID ?? ""));
    if (value != null) {
      debugPrint("发红包 - ${value.bagNum}");
      final msg = await ImMessageUtils.createRedEnvelopeMessage(sendRedResult: value);
      _imController.sendMessage(messageInfo: msg, convType: ConvType.c2c, userID: _selectedConversation.userID ?? "");
    }
  }

  openRed(){
    showRedOpenDialog(context,redPacketId: 34,groupId: "@TGS#2MPYHXUO3");
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

  // 好友是否在线
  Future<void> _loadUserStatus() async {
    final userID = _selectedConversation.userID;
    if (userID == null) return;
    final infos = await TencentImSDKPlugin.v2TIMManager.getUserStatus(userIDList: [userID]);
    if (infos.data == null || infos.data!.isEmpty) return;
    final userStatus = infos.data!.first;
    setState(() {
      _userStatus = userStatus;
    });
  }

  TIMUserOnlineStatus _getUserOnlineStatus(V2TimUserStatus status) {
    switch (status.statusType) {
      case 1:
        return TIMUserOnlineStatus.online;
      case 2:
        return TIMUserOnlineStatus.offline;
      default:
        return TIMUserOnlineStatus.offline;
    }
  }
}

enum TIMUserOnlineStatus {
  /// 在线
  online,

  /// 离线
  offline,
}

class ImageListUIHelper {
  static MessageItemBuilder getMessageItemBuilder(V2TimConversation selectedConversation, TIMUIKitChatController imController) {
    return MessageItemBuilder(
      textMessageItemBuilder: (V2TimMessage message, bool isShowJump, VoidCallback clearJump) {
        return ImTextMessageItem(
          message: message,
          isFromSelf: message.isSelf ?? true,
          clearJump: clearJump,
          isShowJump: isShowJump,
          isShowMessageReaction: false,
          onLinkTap: (text){
            LinkUtils.launchURL(MyApp.context,text);
          },
        );
      },
      textReplyMessageItemBuilder: (V2TimMessage message, bool isShowJump, VoidCallback clearJump,
          Function scrollToIndex, TUIChatSeparateViewModel chatModel) {
        return ImReplyMessageItem(
          message: message,
          isFromSelf: message.isSelf ?? true,
          clearJump: clearJump,
          isShowJump: isShowJump,
          isShowMessageReaction: false,
          scrollToIndex: scrollToIndex,
          chatModel: chatModel,
        );
      },
      imageMessageItemBuilder:
          (V2TimMessage message, bool isShowJump, VoidCallback clearJump, TUIChatSeparateViewModel chatModel) {
        return ImImageMessageItem(
          message: message,
          isFromSelf: message.isSelf ?? true,
          clearJump: clearJump,
          isShowJump: isShowJump,
        );
      },
      soundMessageItemBuilder:
          (V2TimMessage message, bool isShowJump, VoidCallback clearJump, TUIChatSeparateViewModel chatModel) {
        return ImSoundMessageItem(
          message: message,
          clearJump: clearJump,
          isShowJump: isShowJump,
          chatModel: chatModel,
        );
      },
      videoMessageItemBuilder:
          (V2TimMessage message, bool isShowJump, VoidCallback clearJump, TUIChatSeparateViewModel chatModel) {
        return ImVideoMessageItem1(message, chatModel: chatModel, isFrom: "merger", isShowMessageReaction: false);
      },
      fileMessageItemBuilder:
          (V2TimMessage message, bool isShowJump, VoidCallback clearJump, TUIChatSeparateViewModel chatModel) {
        return ImFileMessageItem(
          chatModel: chatModel,
          isShowMessageReaction: false,
          message: message,
          messageID: message.msgID,
          fileElem: message.fileElem,
          isSelf: message.isSelf ?? true,
          isShowJump: isShowJump,
          clearJump: clearJump,
        );
      },
      customMessageItemBuilder: (V2TimMessage message, bool isShowJump, VoidCallback clearJump) {
        return ImCustomMessageItem(
          message: message,
          isFromSelf: message.isSelf ?? true,
          clearJump: clearJump,
          isShowJump: isShowJump,
          targetUserId: selectedConversation.userID ?? "",
          onRefresh: () {
            imController.updateMessage(msgID: message.msgID ?? "");
          },
          onModify: (msg) {
            imController.modifyMessage(msgID: message.msgID ?? "", modifiedMessage: msg);
          },
        );
      },
      mergerMessageItemBuilder:
          (V2TimMessage message, bool isShowJump, VoidCallback clearJump, TUIChatSeparateViewModel chatModel) {
        return ImMergerMessageItem(
          message: message,
          isSelf: message.isSelf ?? true,
          clearJump: clearJump,
          isShowJump: isShowJump,
          messageID: message.msgID ?? "",
          mergerElem: message.mergerElem ?? V2TimMergerElem(),
          model: chatModel,
          messageItemBuilder: ImageListUIHelper.getMessageItemBuilder(selectedConversation, imController),
        );
      },
      locationMessageItemBuilder: (V2TimMessage message, bool isShowJump, VoidCallback clearJump) {
        return ImLocationMessageItem(
          message: message,
          isFromSelf: message.isSelf ?? true,
          clearJump: clearJump,
          isShowJump: isShowJump,
        );
      },
    );
  }
}

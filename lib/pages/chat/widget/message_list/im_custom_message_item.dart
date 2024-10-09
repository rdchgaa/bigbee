import 'dart:async';
import 'dart:convert';

import 'package:bee_chat/models/mine/collection_message_list_model.dart';
import 'package:bee_chat/pages/chat/dialog/red_open_dialog.dart';
import 'package:bee_chat/pages/chat/red_bag/red_bag_send_page.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_collection_bubble_widget.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_multi_images_item_widget.dart';
import 'package:bee_chat/pages/dynamic/dynamic_details_page.dart';
import 'package:bee_chat/pages/mine/collection/widget/collection_message_item_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/im/im_call_utils.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:photo_browser/photo_browser.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/calling_message_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/collection_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/custom_message_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/dynamic_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/red_envelope_data_provider.dart';

import '../../../../models/dynamic/posts_hot_recommend_list_model.dart';
import '../../../../utils/ab_assets.dart';
import 'im_bubble_widget.dart';
import 'im_red_envelope_bubble_widget.dart';

class ImCustomMessageItem extends StatefulWidget {
  final V2TimMessage message;
  final bool isFromSelf;
  final bool isShowJump;
  final VoidCallback clearJump;
  final Function? onRefresh;
  final Function(V2TimMessage)? onModify;

  // 目标UserId
  final String targetUserId;

  const ImCustomMessageItem(
      {super.key,
      required this.message,
      required this.isFromSelf,
      required this.isShowJump,
      required this.clearJump,
      required this.targetUserId,
      this.onRefresh,
        this.onModify});

  @override
  State<ImCustomMessageItem> createState() => _ImCustomMessageItemState();
}

class _ImCustomMessageItemState extends State<ImCustomMessageItem> {
  bool isShowJumpState = false;
  bool isShining = false;

  _showJumpColor() {
    if (!widget.isShowJump) {
      return;
    }
    isShining = true;
    int shineAmount = 6;
    setState(() {
      isShowJumpState = true;
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          isShowJumpState = shineAmount.isOdd ? true : false;
        });
      }
      if (shineAmount == 0 || !mounted) {
        isShining = false;
        timer.cancel();
      }
      shineAmount--;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.clearJump();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        // widget.clearJump();
      }
    }

    return Container(
      padding: EdgeInsets.only(
        left: widget.isFromSelf ? 0 : 6,
        right: widget.isFromSelf ? 6 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // 边框
        border: Border.all(color: isShowJumpState ? theme.primaryColor : Colors.transparent, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          final p = CallingMessageDataProvider(widget.message);
          if (p.isCallingSignal) {
            _clickCallAction(p);
            return;
          }
          final rp = RedEnvelopeDataProvider(widget.message);
          if (rp.isRedEnvelopeMessage) {
            _clickRedEnvelopeAction(rp);
            return;
          }
          final dp = DynamicDataProvider(widget.message);
          if (dp.isDynamicMessage) {
            _clickDynamicAction(dp);
            return;
          }
          if (CustomMessageUtils.isMultiImagesMessage(widget.message)) {
            _clickMultiImagesAction();
            return;
          }
        },
        child: _getContentWidget(),
      ),
    );
  }

  Widget _getContentWidget() {
    final p = CallingMessageDataProvider(widget.message);
    if (p.isCallingSignal && p.participantType == CallParticipantType.c2c) {
      return _getC2CCallWidget();
    }
    final rp = RedEnvelopeDataProvider(widget.message);
    if (rp.isRedEnvelopeMessage) {
      return _getRedEnvelopeWidget();
    }
    final coll = CollectionDataProvider(widget.message);
    if (coll.isCollectionMessage) {
      return _getCollectionWidget();
    }

    final dp = DynamicDataProvider(widget.message);
    if (dp.isDynamicMessage) {
      return _getDynamicWidget();
    }

    if (CustomMessageUtils.isMultiImagesMessage(widget.message)) {
      return _getMultiImagesWidget();
    }
    return Text("自定义消息");
  }

  // 通话
  Widget _getC2CCallWidget() {
    final p = CallingMessageDataProvider(widget.message);
    final videoIcon = Icon(
      CupertinoIcons.video_camera_solid,
      color: widget.isFromSelf ? Colors.white : Colors.black,
      size: 20,
    );
    final audioIcon = Icon(
      CupertinoIcons.phone_down_fill,
      color: widget.isFromSelf ? Colors.white : Colors.black,
      size: 20,
    );
    return ImBubbleWidget(
      isFromSelf: widget.isFromSelf,
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            p.streamMediaType == CallStreamMediaType.video ? videoIcon : audioIcon,
            SizedBox(
              width: 6,
            ),
            Text(
              p.content,
              style: TextStyle(color: widget.isFromSelf ? Colors.white : Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // 红包
  Widget _getRedEnvelopeWidget() {
    final p = RedEnvelopeDataProvider(widget.message);
    if (p.redEnvelopeJsonString != null) {
      final model = SendRedResult.fromJsonString(p.redEnvelopeJsonString!);
      if (model != null) {
        final userId = UserProvider.getCurrentUser().userId ?? "-1";
        print("红包界面 - userId: ${userId}   localCustomData: ${widget.message.localCustomData}");
        return ImRedEnvelopeBubbleWidget(
          model: model,
          isFromSelf: widget.isFromSelf,
          isReceived: widget.message.localCustomData == userId,
        );
      }
    }
    return ImBubbleWidget(
      isFromSelf: widget.isFromSelf,
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        child: Text(
          p.content.isNotEmpty ? p.content : "红包",
        ),
      ),
    );
  }

  // 多图
  Widget _getMultiImagesWidget() {
    final maxWidth = MediaQuery.of(context).size.width * 0.6;
    final urls = CustomMessageUtils.getMultiImageUrls(widget.message);
    if (urls != null) {
      return ImBubbleWidget(
        isFromSelf: widget.isFromSelf,
        child: Container(
          padding: const EdgeInsets.all(14),
          width: maxWidth,
          child: ImMultiImagesItemWidget(images: urls, width: maxWidth - 28),
        ),
      );
    }

    return ImBubbleWidget(
      isFromSelf: widget.isFromSelf,
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        child: Text(TIM_t("[自定义]")),
      ),
    );
  }

  // 动态
  Widget _getDynamicWidget() {
    print("sssss");
    final theme = AB_theme(context);
    final maxWidth = MediaQuery.of(context).size.width * 0.6;
    final dp = DynamicDataProvider(widget.message);
    final jsonStr = dp.dynamicJsonString ?? "{}";
    try {
      final dynamicModel = PostShareMsgModel.fromJson(json.decode(jsonStr));
      return ImBubbleWidget(
        isFromSelf: widget.isFromSelf,
        child: Container(
          padding: const EdgeInsets.all(14),
          // constraints: BoxConstraints(maxWidth: maxWidth),
          width: maxWidth,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AB_S().publishDynamic(dynamicModel.nickName),
              style: TextStyle(fontSize: 16.px, color: theme.textColor, fontWeight: FontWeight.w600),
            ),
            if (dynamicModel.textContent.isNotEmpty || dynamicModel.imageUrls.isNotEmpty) SizedBox(height: 8.px),
            if (dynamicModel.textContent.isNotEmpty || dynamicModel.imageUrls.isNotEmpty)
              Dash(
                  direction: Axis.horizontal,
                  length: maxWidth - 28,
                  dashLength: 4.px,
                  dashColor: Color(0xFF888888),
                  dashThickness: 0.5.px),
            // Divider(height: 0.5, color: Color(0xFFAAAAAA)),
            if (dynamicModel.textContent.isNotEmpty) SizedBox(height: 4.px),
            if (dynamicModel.textContent.isNotEmpty)
              Text(
                dynamicModel.textContent,
                style: TextStyle(
                  fontSize: 14.px,
                  color: theme.textColor.withOpacity(0.6),
                ),
              ),
            if (dynamicModel.imageUrls.isNotEmpty) SizedBox(height: 4.px),
            if (dynamicModel.imageUrls.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: ABImage.imageWithUrl(dynamicModel.imageUrls.split(",").firstOrNull ?? "",
                    width: maxWidth - 28, height: (maxWidth - 28) * 60 / 80, fit: BoxFit.cover),
              ),
            if (dynamicModel.videoUrl.isNotEmpty) SizedBox(height: 4.px),
            if (dynamicModel.videoUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  color: Colors.grey,
                  width: maxWidth - 28,
                  height: (maxWidth - 28) * 60 / 80,
                  child: Stack(
                    children: [
                      Positioned.fill(child: VideoFrameWidget(url: dynamicModel.videoUrl)),
                      Center(
                        child: Image.asset(
                          ABAssets.videoPlay(context),
                          width: 24.px,
                          height: 24.px,
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ]),
        ),
      );
    } catch (e) {}
    return ImBubbleWidget(
      isFromSelf: widget.isFromSelf,
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        child: Text(TIM_t("[自定义]")),
      ),
    );
  }

  // 收藏
  Widget _getCollectionWidget() {
    final p = CollectionDataProvider(widget.message);
    if (p.collectionJsonString != null) {
      final model = CollectionMessageListRecords.fromJson(json.decode(p.collectionJsonString!));
      return ImCollectionBubbleWidget(model: model, isFromSelf: widget.isFromSelf);
    }
    return ImBubbleWidget(
      isFromSelf: widget.isFromSelf,
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        child: Text(
          p.content.isNotEmpty ? p.content : "收藏",
        ),
      ),
    );
  }

  // 点击通话
  void _clickCallAction(CallingMessageDataProvider p) {
    if (p.participantType == CallParticipantType.c2c) {
      ImCallUtils.callUser(
          context: context,
          userId: widget.targetUserId,
          type: (p.streamMediaType == CallStreamMediaType.video ? ImCallUtilsType.video : ImCallUtilsType.voice));
    }
  }

  // 点击红包
  void _clickRedEnvelopeAction(RedEnvelopeDataProvider p) {
    if (p.redEnvelopeJsonString != null) {
      final model = SendRedResult.fromJsonString(p.redEnvelopeJsonString ?? "{}");
      if (model != null) {
        showRedOpenDialog(context, redPacketId: model.redId, groupId: (model.isGroup) ? model.userOrGroupId : null,
            onReceive: () async { // 领取红包回调
              _refreshReceivedStateWithLocalData();
              _refreshReceivedStateWithCloud(p);
        }, onReceiveState: (state) async {//红包状态回调   0, 未领取; 1,已领取 ，2，已领完，3，已过期
          if (state == 1) {
            _refreshReceivedStateWithLocalData();
            _refreshReceivedStateWithCloud(p);
          }
          if (state == 2 && model.isOver != true) {
            _refreshIsOveredStateWithCloud(p);
          }
        });
      }
    }
  }

  // 点击多图
  void _clickMultiImagesAction() async {
    final imageUrls = CustomMessageUtils.getMultiImageUrls(widget.message);
    if (imageUrls == null || imageUrls.isEmpty) {
      return;
    }
    PhotoBrowser photoBrowser = PhotoBrowser(
      itemCount: imageUrls.length,
      initIndex: 0,
      controller: PhotoBrowserController(),
      allowTapToPop: true,
      allowSwipeDownToPop: true,
      heroTagBuilder: (int index) {
        return imageUrls[index];
      },
      // Large images setting.
      // 大图设置
      imageUrlBuilder: (int index) {
        return imageUrls[index];
      },
      // 缩略图设置
      thumbImageUrlBuilder: (int index) {
        return imageUrls[index] + "?x-oss-process=image/resize,m_lfit,h_160,w_160";
      },
      loadFailedChild: ColoredBox(color: Colors.grey),
    );

    photoBrowser.push(context);
  }

  // 动态点击
  void _clickDynamicAction(DynamicDataProvider p) async {
    final jsonStr = p.dynamicJsonString ?? "{}";
    try {
      final dynamicModel = PostShareMsgModel.fromJson(json.decode(jsonStr));
      ABRoute.push(DynamicDetailsPage(postsId: dynamicModel.postId));
    } catch (e) {
      return;
    }
  }

  // 刷新已领取状态(本地数据)
  void _refreshReceivedStateWithLocalData() async {
    final userId = UserProvider.getCurrentUser().userId ?? "";
    print("userId: ${userId}   localCustomData: ${widget.message.localCustomData}");
    if (userId.isNotEmpty && widget.message.localCustomData != userId) {
      await TencentImSDKPlugin.v2TIMManager.v2TIMMessageManager
          .setLocalCustomData(msgID: widget.message.msgID!, localCustomData: userId);
      widget.message.localCustomData = userId;
      widget.onModify?.call(widget.message);
    }
  }

  // 刷新已领取状态(云端数据)
  void _refreshReceivedStateWithCloud(RedEnvelopeDataProvider p) async {
    final model = SendRedResult.fromJsonString(p.redEnvelopeJsonString ?? "{}");
    if (model == null) {
      return;
    }
    final userId = UserProvider.getCurrentUser().userId ?? "";
    if (userId.isNotEmpty && !model.receiveList.contains(userId)) {
      final newRedEnvelopeData = model.copyWith(receiveList: [...model.receiveList, userId]);
      final originMapData = p.dataMap ?? {};
      originMapData["redEnvelope"] = newRedEnvelopeData.toJsonString();
      V2TimMessage newMsg = widget.message;
      newMsg.customElem?.data = json.encode(originMapData);
      V2TimValueCallback<V2TimMessageChangeInfo> modify = await TencentImSDKPlugin.v2TIMManager.getMessageManager().modifyMessage(message: newMsg);
      if(modify.code == 0){
        widget.onRefresh?.call();
      }
    }
  }

  // 刷新已领完状态(云端数据)
  void _refreshIsOveredStateWithCloud(RedEnvelopeDataProvider p) async {
    final model = SendRedResult.fromJsonString(p.redEnvelopeJsonString ?? "{}");
    if (model == null) {
      return;
    }
    final newRedEnvelopeData = model.copyWith(isOver: true);
    final originMapData = p.dataMap ?? {};
    originMapData["redEnvelope"] = newRedEnvelopeData.toJsonString();
    V2TimMessage newMsg = widget.message;
    newMsg.customElem?.data = json.encode(originMapData);
    V2TimValueCallback<V2TimMessageChangeInfo> modify = await TencentImSDKPlugin.v2TIMManager.getMessageManager().modifyMessage(message: newMsg);
    if(modify.code == 0){
      widget.onRefresh?.call();
    }
  }


}

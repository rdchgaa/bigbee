import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bee_chat/pages/chat/widget/message_list/im_file_message_item.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/calling_message_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/custom_message_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/TIMUIKitMessageReaction/tim_uikit_message_reaction_show_panel.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/tim_uikit_chat_face_elem.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/tim_uikit_chat_reply_elem.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_cloud_custom_data.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/link_preview_entry.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_preview.dart';

import '../../../../utils/extensions/color_extensions.dart';
import '../../../../utils/im/im_utils.dart';
import 'im_bubble_widget.dart';

class ImReplyMessageItem extends StatefulWidget {
  final V2TimMessage message;
  final bool isFromSelf;
  final bool isShowJump;
  final VoidCallback clearJump;
  final TextStyle? fontStyle;
  final bool? isShowMessageReaction;
  final List<CustomEmojiFaceData> customEmojiStickerList;
  final Function(String)? onLinkTap;
  final Function scrollToIndex;
  final TUIChatSeparateViewModel chatModel;

  const ImReplyMessageItem({
    super.key,
  required this.message,
  required this.isFromSelf,
  required this.isShowJump,
  required this.clearJump,
  this.fontStyle,
  this.isShowMessageReaction,
  this.customEmojiStickerList = const [],
  this.onLinkTap,
  required this.scrollToIndex, required this.chatModel,
  });

  @override
  State<ImReplyMessageItem> createState() => _ImReplyMessageItemState();
}

class _ImReplyMessageItemState extends TIMUIKitState<ImReplyMessageItem> {
  MessageRepliedData? repliedMessage;
  V2TimMessage? rawMessage;
  bool isShowJumpState = false;
  bool isShining = false;

  MessageRepliedData? _getRepliedMessage() {
    try {
      final CloudCustomData messageCloudCustomData = CloudCustomData.fromJson(
          json.decode(
              TencentUtils.checkString(widget.message.cloudCustomData) != null
                  ? widget.message.cloudCustomData!
                  : "{}"));
      if (messageCloudCustomData.messageReply != null) {
        final MessageRepliedData repliedMessage =
        MessageRepliedData.fromJson(messageCloudCustomData.messageReply!);
        return repliedMessage;
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  _getMessageByMessageID() async {
    final MessageRepliedData? cloudCustomData = _getRepliedMessage();
    if (cloudCustomData != null) {
      if (mounted) {
        setState(() {
          repliedMessage = cloudCustomData;
        });
      }

      final messageID = cloudCustomData.messageID;
      if(PlatformUtils().isWeb){
        return;
      }
      V2TimMessage? message = await ImUtils.findMessage(messageID);
      if (message == null) {
        try {
          final RepliedMessageAbstract repliedMessageAbstract =
          RepliedMessageAbstract.fromJson(
              jsonDecode(cloudCustomData.messageAbstract));
          if (repliedMessageAbstract.isNotEmpty) {
            message = V2TimMessage(
                elemType: 0,
                seq: repliedMessageAbstract.seq,
                timestamp: repliedMessageAbstract.timestamp,
                msgID: repliedMessageAbstract.msgID);
          }
        } catch (e) {
          print(e.toString());
        }
      }
      if (message != null) {
        if (mounted) {
          setState(() {
            rawMessage = message;
          });
        }
      }
    }
  }

  Widget _defaultRawMessageText(String text, TUITheme? theme) {
    return Text(text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 12,
            color: theme?.weakTextColor,
            fontWeight: FontWeight.w400));
  }

  _renderMessageSummary(TUITheme? theme) {
    try {
      final RepliedMessageAbstract repliedMessageAbstract =
      RepliedMessageAbstract.fromJson(
          jsonDecode(repliedMessage?.messageAbstract ?? ""));
      if (TencentUtils.checkString(repliedMessageAbstract.summary) != null) {
        return _defaultRawMessageText(repliedMessageAbstract.summary!, theme);
      }
      return _defaultRawMessageText(
          repliedMessage?.messageAbstract ?? TIM_t("[未知消息]"), theme);
    } catch (e) {
      return _defaultRawMessageText(
          repliedMessage?.messageAbstract ?? TIM_t("[未知消息]"), theme);
    }
  }

  (bool isRevoke, bool isRevokeByAdmin) isRevokeMessage(V2TimMessage message) {
    if (message.status == 6) {
      return (true, false);
    } else {
      try {
        final customData = jsonDecode(message.cloudCustomData ?? "{}");
        final isRevoke = customData["isRevoke"] ?? false;
        final revokeByAdmin = customData["revokeByAdmin"] ?? false;
        return (isRevoke, revokeByAdmin);
      } catch (e) {
        return (false, false);
      }
    }
  }

  _rawMessageBuilder(V2TimMessage? message, TUITheme? theme) {
    if (repliedMessage == null) {
      return const SizedBox(width: 0, height: 12);
    }
    if (message == null) {
      if (repliedMessage?.messageAbstract != null) {
        return _renderMessageSummary(theme);
      }
      return const SizedBox(width: 0, height: 12);
    }

    final revokeStatus = isRevokeMessage(message);
    final isRevokedMsg = revokeStatus.$1;
    final isAdminRevoke = revokeStatus.$2;

    if (isRevokedMsg) {
      return _defaultRawMessageText(
          isAdminRevoke ? TIM_t("[消息被管理员撤回]") : TIM_t("[消息被撤回]"), theme);
    }

    final messageType = message.elemType;
    final isSelf = message.isSelf ?? true;

    switch (messageType) {
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        return _defaultRawMessageText(CustomMessageUtils.messageShowContent(message), theme);
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return _defaultRawMessageText(TIM_t("[语音消息]"), theme);
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return _defaultRawMessageText(message.textElem?.text ?? "", theme);
      case MessageElemType.V2TIM_ELEM_TYPE_FACE:
        return _defaultRawMessageText(TIM_t("[表情消息]"), theme);
      case MessageElemType.V2TIM_ELEM_TYPE_FILE:
        return ImFileMessageItem(
            chatModel: widget.chatModel,
            isShowMessageReaction: false,
            message: message,
            messageID: message.msgID,
            fileElem: message.fileElem,
            isSelf: isSelf,
            isShowJump: false,
            isFromReply: true);
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        final imageElem = message.imageElem;
        final imageModel = imageElem?.imageList?.firstOrNull;
        if (imageElem?.path != null && imageElem?.path != "") {
          return _imageReplyWidget(Image.file(File(imageElem!.path!), fit: BoxFit.contain));

        }
        if (imageModel?.localUrl != null && imageModel?.localUrl != "") {
          return _imageReplyWidget(Image.file(File(imageModel!.localUrl!), fit: BoxFit.contain));
        }
        if (imageModel?.url != null && imageModel?.url != "") {
          double positionRadio = 1.0;
          if (imageModel!.width != null &&
              imageModel.height != null &&
              imageModel.width != 0 &&
              imageModel.height != 0) {
            positionRadio = (imageModel.width! / imageModel.height!);
          }
          return _imageReplyWidget(AspectRatio(
              aspectRatio: positionRadio,
              child: ABImage.imageWithUrl(imageModel.url!, )));
        }
        return _defaultRawMessageText(TIM_t("[图片消息]"), theme);
      case MessageElemType.V2TIM_ELEM_TYPE_VIDEO:
        return _defaultRawMessageText(TIM_t("[视频消息]"), theme);
      case MessageElemType.V2TIM_ELEM_TYPE_LOCATION:
        return _defaultRawMessageText(TIM_t("[位置]"), theme);
      case MessageElemType.V2TIM_ELEM_TYPE_MERGER:
        return _defaultRawMessageText(TIM_t("[合并消息]"), theme);
      default:
        return _renderMessageSummary(theme);
    }
  }

  @override
  void initState() {
    _getMessageByMessageID();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ImReplyMessageItem oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      super.didUpdateWidget(oldWidget);
      _getMessageByMessageID();
    });
  }

  Widget _imageReplyWidget(Widget child) {
    return ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 120,
          minWidth: 64,
          maxHeight: 256,
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: child));
  }

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

  void _jumpToRawMsg() {
    print("跳转到 - ${rawMessage?.timestamp}");
    if (rawMessage?.timestamp != null) { 
      try {
        widget.scrollToIndex(rawMessage!);
      } catch (e) {
        print("跳转到 - ${rawMessage?.timestamp} 失败");
        print("${e}");
      }
    } else {
      onTIMCallback(TIMCallback(
          type: TIMCallbackType.INFO,
          infoRecommendText: TIM_t("无法定位到原消息"),
          infoCode: 6660401));
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = AB_theme(context);
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        // widget.clearJump();
      }
    }
    final textWithLink = LinkPreviewEntry.getHyperlinksText(
        widget.message.textElem?.text ?? "",
        false,
        onLinkTap: (link){
          print("点击链接 - $link");
          widget.onLinkTap?.call(link);
        },
      isUseQQPackage: true,
      isUseTencentCloudChatPackage: true,
      customEmojiStickerList: widget.customEmojiStickerList,
      isEnableTextSelection: true,);

    return Container(
      padding: EdgeInsets.only(
        left: widget.isFromSelf ? 1 : 6,
        right: widget.isFromSelf ? 6 : 1,
        top: 1,
        bottom: 1,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // 边框
        border: Border.all(
            color: isShowJumpState ? theme.primaryColor : Colors.transparent,
            width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ImBubbleWidget(
        isFromSelf: widget.isFromSelf,
        child: Container(
          padding: const EdgeInsets.all(14),
          constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _jumpToRawMsg,
                child: Container(
                  // 这里是引用的部分
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  constraints: BoxConstraints(minWidth: ABScreen.width * 0.6),
                  decoration: BoxDecoration(
                      color: theme.white.withOpacity(0.8),
                      border: Border(
                          left: BorderSide(
                              color: theme.white, width: 2),
                      ),
                      borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repliedMessage != null
                            ? "${repliedMessage!.messageSender}:"
                            : "",
                        style: TextStyle(
                            fontSize: 12,
                            color: theme.textGrey,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _rawMessageBuilder(rawMessage, value.theme)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              textWithLink!(
                  style: widget.fontStyle ??
                      TextStyle(
                          color: widget.isFromSelf ? theme.white : HexColor("#333333"),
                          fontSize: isDesktopScreen ? 14 : 16,
                          textBaseline: TextBaseline.ideographic,
                          height: 1.3)),
            ],
          ),
        ),
      ),
    );
  }
}

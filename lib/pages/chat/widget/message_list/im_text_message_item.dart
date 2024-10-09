import 'dart:async';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/TIMUIKitMessageReaction/tim_uikit_message_reaction_show_panel.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/link_preview_entry.dart';

import '../../../../provider/theme_provider.dart';
import 'im_bubble_widget.dart';

class ImTextMessageItem extends StatefulWidget {
  final V2TimMessage message;
  final bool isFromSelf;
  final bool isShowJump;
  final VoidCallback clearJump;
  final TextStyle? fontStyle;
  final bool? isShowMessageReaction;
  final List<CustomEmojiFaceData> customEmojiStickerList;
  final Function(String)? onLinkTap;


  const ImTextMessageItem({super.key,
    required this.message,
    required this.isFromSelf,
    required this.isShowJump,
    required this.clearJump,
    this.fontStyle,
    this.isShowMessageReaction,
    this.customEmojiStickerList = const [],
    this.onLinkTap,
  });

  @override
  State<ImTextMessageItem> createState() => _C2cTextMessageItemState();
}

class _C2cTextMessageItemState extends TIMUIKitState<ImTextMessageItem> {

  bool isShowJumpState = false;
  bool isShining = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ImTextMessageItem oldWidget) {
    super.didUpdateWidget(oldWidget);
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


  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = AB_theme(context);
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
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
      isEnableTextSelection: true,
    );

    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      }
    }

    return Container(
      padding: EdgeInsets.only(
        left: widget.isFromSelf ? 0 : 6,
        right: widget.isFromSelf ? 6 : 0,),
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
              textWithLink!(
                  style: widget.fontStyle ??
                      TextStyle(
                          color: widget.isFromSelf ? theme.white : HexColor("#333333"),
                          fontSize: isDesktopScreen ? 14 : 16,
                          textBaseline: TextBaseline.ideographic,
                          height: 1.3)),
              if (widget.isShowMessageReaction ?? true)
                TIMUIKitMessageReactionShowPanel(message: widget.message)
            ],
          ),
        ),
      ),
    );
  }
}


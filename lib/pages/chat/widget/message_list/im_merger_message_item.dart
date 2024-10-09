import 'dart:async';

import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/merger_message_screen.dart';

import 'im_bubble_widget.dart';

class ImMergerMessageItem extends StatefulWidget {

  final V2TimMergerElem mergerElem;
  final String messageID;
  final bool isSelf;
  final bool isShowJump;
  final VoidCallback? clearJump;
  final V2TimMessage message;
  final TUIChatSeparateViewModel model;
  final MessageItemBuilder? messageItemBuilder;

  const ImMergerMessageItem({
    super.key,
    this.messageID = "",
    required this.mergerElem,
    this.isSelf = true,
    this.isShowJump = false,
    this.clearJump,
    required this.message,
    required this.model,
    this.messageItemBuilder});

  @override
  State<ImMergerMessageItem> createState() => _ImMergerMessageItemState();
}

class _ImMergerMessageItemState extends State<ImMergerMessageItem> {

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
      widget.clearJump?.call();
    });
  }


  @override
  Widget build(BuildContext context) {
    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        // widget.clearJump?.call();
      }
    }
    final theme = AB_theme(context);
    return Container(
      padding: EdgeInsets.only(
        left: widget.isSelf ? 0 : 6,
        right: widget.isSelf ? 6 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: isShowJumpState ? theme.primaryColor : Colors.transparent, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _handleTap(context, widget.model);
        },
        child: ImBubbleWidget(
          isFromSelf: widget.isSelf,
          selfBackgroundColor: const Color(0xFFF4F4F4),
          otherBackgroundColor: const Color(0xFFF4F4F4),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12,),
                  Text(
                    widget.mergerElem.title ?? "",
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFF282109),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ).padding(left: 14, right: 14),
                  SizedBox(height: 4,),
                  ..._getAbstractList().map((e){
                    return Text(
                      e,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(0xFF989897),
                        fontSize: 12,
                      ),
                    ).padding(left: 14, right: 14);
                  }),
                  SizedBox(height: 10,),
                  Container(
                    height: 1,
                    color: const Color(0xFFEBEBEB),
                  ),
                  const SizedBox(height: 6,),
                  Text(
                    AB_getS(context).chatRecord,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFF323333),
                      fontSize: 12,
                    ),
                  ).padding(left: 14, right: 14),
                  const SizedBox(height: 10,),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getAbstractList() {
    final length = widget.mergerElem.abstractList!.length;
    if (length <= 4) {
      return widget.mergerElem.abstractList ?? [];
    }
    return widget.mergerElem.abstractList!.getRange(0, 4).toList();
  }

  _handleTap(BuildContext context, TUIChatSeparateViewModel model) async {
    if (widget.messageID.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MergerMessageScreen(
                messageItemBuilder: widget.messageItemBuilder,
                model: model,
                msgID: widget.messageID),
          ));
    }
  }

}

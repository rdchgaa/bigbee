import 'dart:async';
import 'dart:io';

import 'package:bee_chat/widget/ab_image.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../../provider/theme_provider.dart';
import 'im_bubble_widget.dart';

class ImVideoMessageItem extends StatefulWidget {

  final V2TimMessage message;
  final bool isShowJump;
  final VoidCallback clearJump;

  const ImVideoMessageItem({super.key, required this.message, required this.isShowJump, required this.clearJump});

  @override
  State<ImVideoMessageItem> createState() => _ImVideoMessageItemState();
}

class _ImVideoMessageItemState extends State<ImVideoMessageItem> {
  bool isShowJumpState = false;
  bool isShining = false;

  String? _imageUrl;

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
    final isFromSelf = widget.message.isSelf ?? true;
    final element = widget.message.videoElem;
    return Container(
      padding: EdgeInsets.only(
        left: isFromSelf ? 0 : 6,
        right: isFromSelf ? 6 : 0,),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // 边框
        border: Border.all(
            color: isShowJumpState ? theme.primaryColor : Colors.transparent,
            width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ImBubbleWidget(
        isFromSelf: isFromSelf,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          constraints:
          BoxConstraints(maxWidth: 160),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imageUrl != null ? _imageFrameWidget(ABImage.imageWithUrl(_imageUrl!, fit: BoxFit.fitWidth)) : _bgImageWidget(),
            ],
          ),
        ),
      ),
    );
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

  Widget _bgImageWidget() {
    if (widget.message.videoElem?.snapshotPath != null && File(widget.message.videoElem!.snapshotPath!).existsSync()) {
      return _imageFrameWidget(Image.file(
        File(widget.message.videoElem!.snapshotPath!),
        fit: BoxFit.fitWidth,
      ));
    }

    if (widget.message.videoElem?.localSnapshotUrl != null && File(widget.message.videoElem!.localSnapshotUrl!).existsSync()) {
      return _imageFrameWidget(Image.file(File(widget.message.videoElem!.localSnapshotUrl!),
          fit: BoxFit.fitWidth)
          );
    }
    _loadImageUrl();
    return _imageFrameWidget(Container(color: Colors.grey,));
  }

  Widget _imageFrameWidget(Widget child) {
    double positionRadio = 1.0;
    if (widget.message.videoElem?.snapshotWidth != null &&
        widget.message.videoElem?.snapshotHeight != null &&
        widget.message.videoElem?.snapshotWidth != 0 &&
        widget.message.videoElem?.snapshotHeight != 0) {
      positionRadio = (widget.message.videoElem!.snapshotWidth! / widget.message.videoElem!.snapshotHeight!);
    }
    return AspectRatio(
      aspectRatio: positionRadio,
      child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 64,
            maxHeight: 160,
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: child)),
    );
  }


  void _loadImageUrl() async {
    // 获取多媒体消息URL
    V2TimValueCallback<V2TimMessageOnlineUrl> getMessageOnlineUrlRes =
        await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .getMessageOnlineUrl(
      msgID: widget.message.msgID ?? "", // 消息id
    );
    if (getMessageOnlineUrlRes.code == 0) {
      final url = getMessageOnlineUrlRes.data?.videoElem?.snapshotUrl;
      print("视频封面URL- ${url}");
      if (url != null) {
        setState(() {
          _imageUrl = url;
        });
      }
    }
  }


}

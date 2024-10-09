import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/message/message_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/history_message_constant.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/sound_record.dart';

import '../../../../provider/theme_provider.dart';
import 'im_bubble_widget.dart';

class ImSoundMessageItem extends StatefulWidget {

  final V2TimMessage message;
  final bool isShowJump;
  final VoidCallback clearJump;
  final TUIChatSeparateViewModel chatModel;

  const ImSoundMessageItem({super.key, required this.message, required this.isShowJump, required this.clearJump, required this.chatModel});

  @override
  State<ImSoundMessageItem> createState() => _ImSoundMessageItemState();
}

class _ImSoundMessageItemState extends State<ImSoundMessageItem> {


  bool isShowJumpState = false;
  bool isShining = false;
  final int charLen = 8;
  bool isPlaying = false;
  StreamSubscription<Object>? subscription;
  final TUIChatGlobalModel globalModel = serviceLocator<TUIChatGlobalModel>();
  final MessageService _messageService = serviceLocator<MessageService>();

  late V2TimSoundElem? stateElement;

  @override
  void initState() {
    stateElement = widget.message.soundElem;
    super.initState();
    subscription = SoundPlayer.playStateListener(listener: (PlayerState state) {
      if (state.processingState == ProcessingState.completed) {
        widget.chatModel.currentPlayedMsgId = "";
      }
      setState(() {
        isPlaying = widget.chatModel.currentPlayedMsgId != '' && widget.chatModel.currentPlayedMsgId == widget.message.msgID;
      });
    });

    downloadMessageDetailAndSave();
  }

  @override
  void dispose() {
    if (isPlaying) {
      SoundPlayer.stop();
      widget.chatModel.currentPlayedMsgId = "";
    }
    subscription?.cancel();
    // if (widget.message.localCustomData != null) {
    //   TencentImSDKPlugin.v2TIMManager.v2TIMMessageManager.setLocalCustomData(
    //       msgID: widget.message.msgID!, localCustomData: "{}");
    // }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LocalCustomDataModel localCustomModel = LocalCustomDataModel();
    try {
      localCustomModel = LocalCustomDataModel.fromMap(json.decode(widget.message.localCustomData ?? "{}"));
    } catch (_) {

    }

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

    final playImage = isPlaying
        ? Image.asset(
      ABAssets.imSoundPlayGif(context),
      width: 75,
      height: 32,
    )
        : Image.asset(
      ABAssets.imSoundPlayImage(context),
      width: 75,
      height: 32,
    ) ;

    final playIcon = isPlaying ? Icon(CupertinoIcons.pause_fill, size: 14, color: HexColor("#323333")) : Icon(CupertinoIcons.play_arrow_solid, size: 14, color: HexColor("#323333"),);


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
      child: Column(
        crossAxisAlignment: isFromSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ImBubbleWidget(
            isFromSelf: isFromSelf,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      // _convertVoiceToText();
                      _playSound();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: isFromSelf
                          ? [
                        playImage,
                        const SizedBox(width: 6),
                        Text(
                          "${_timeString(stateElement?.duration ?? 0)}",
                          style: TextStyle(color: HexColor("#323333"), fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        playIcon,
                      ]
                          : [
                        playIcon,
                        const SizedBox(width: 4),
                        Text(
                          _timeString(stateElement?.duration ?? 0),
                          style: TextStyle(color: HexColor("#323333"), fontSize: 12),
                        ),
                        const SizedBox(width: 6),
                        playImage,
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (localCustomModel.soundText?.isNotEmpty == true || localCustomModel.isLoading == true) const SizedBox(height: 10,),
          if (localCustomModel.soundText?.isNotEmpty == true || localCustomModel.isLoading == true) Container(
            padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
            decoration: BoxDecoration(
              color: isFromSelf ? const Color(0xFFEFA33D) : const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: (localCustomModel.isLoading == true) ? const CupertinoActivityIndicator(radius: 8,) : Text(
              localCustomModel.soundText ?? "",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _timeString(int duration) {
    final int minute = duration ~/ 60;
    final int second = duration % 60;
    return "$minute:${second.toString().padLeft(2, '0')}";
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

  _playSound() async {
    if (!SoundPlayer.isInit) {
      SoundPlayer.initSoundPlayer();
    }
    if (widget.message.localCustomInt == null || widget.message.localCustomInt != HistoryMessageDartConstant.read) {
      globalModel.setLocalCustomInt(widget.message.msgID ?? "", HistoryMessageDartConstant.read, widget.chatModel.conversationID);
    }
    if (isPlaying) {
      SoundPlayer.stop();
      widget.chatModel.currentPlayedMsgId = "";
    } else {
      final String? url = stateElement?.url;
      if (url == null || url == '') {
        return;
      }
      SoundPlayer.play(url: url);
      widget.chatModel.currentPlayedMsgId = widget.message.msgID ?? "";
    }
  }

  downloadMessageDetailAndSave() async {
    if (widget.message.msgID != null && widget.message.msgID != '') {
      if (stateElement!.url == null || stateElement!.url == '') {
        final response = await _messageService.getMessageOnlineUrl(msgID: widget.message.msgID!);
        if (response.data != null) {
          widget.message.soundElem = response.data!.soundElem;
          Future.delayed(const Duration(microseconds: 10), () {
            setState(() => stateElement = response.data!.soundElem!);
          });
        }
      }

    }
  }

  // _convertVoiceToText() async {
  //   print("语音转文字ID - ${widget.message.msgID}");
  //   final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().convertVoiceToText(msgID: widget.message.msgID ?? "", language: "zh");
  //   print("语音转文字结果 - ${res.toJson()}");
  //   if (res.code == 0) {
  //     setState(() {
  //       widget.message.localCustomData = res.data;
  //     });
  //   }
  // }


}

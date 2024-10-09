import 'package:flutter/material.dart';
import 'package:tencent_calls_engine/tencent_calls_engine.dart';
import 'package:tencent_calls_uikit/src/call_manager.dart';
import 'package:tencent_calls_uikit/src/call_state.dart';
import 'package:tencent_calls_uikit/src/data/constants.dart';
import 'package:tencent_calls_uikit/src/data/user.dart';
import 'package:tencent_calls_uikit/src/ui/widget/common/loading_animation.dart';
import 'package:tencent_calls_uikit/src/ui/widget/groupcall/group_call_user_widget_data.dart';
import 'package:tencent_calls_uikit/src/utils/string_stream.dart';
import 'package:tencent_calls_uikit/src/utils/tuple.dart';
import 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';


class GroupCallUserWidget1 extends StatefulWidget {
  final int index;
  final User user;


  const GroupCallUserWidget1({Key? key, required this.index, required this.user}) : super(key: key);

  @override
  State<GroupCallUserWidget1> createState() => _GroupCallUserWidget1State();
}

class _GroupCallUserWidget1State extends State<GroupCallUserWidget1> {
  ITUINotificationCallback? refreshCallback;
  final _duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    refreshCallback = (arg) {
      if (mounted) {
        setState(() {});
      }
    };
    TUICore.instance.registerEvent(setStateEventGroupCallUserWidgetRefresh, refreshCallback);
  }

  @override
  void dispose() {
    super.dispose();
    TUICore.instance.unregisterEvent(setStateEventGroupCallUserWidgetRefresh, refreshCallback);
  }

  @override
  Widget build(BuildContext context) {
    final smallW = (MediaQuery.of(context).size.width - 32 - 24)/4;
    final bigW = MediaQuery.of(context).size.width-32;
    final isBig = widget.index == GroupCallUserWidgetLayoutData.bigUserIndex;
    final double W = isBig ? bigW : smallW;
    final double H = isBig ? bigW : smallW;

    bool isAvatarImage =
        (widget.user.id == CallState.instance.selfUser.id && !CallState.instance.isCameraOpen) ||
            (widget.user.id != CallState.instance.selfUser.id && !widget.user.videoAvailable);
    bool isShowLoadingImage = (widget.user.callStatus == TUICallStatus.waiting) &&
        (widget.user.id != CallState.instance.selfUser.id);
    bool isShowSpeaking = widget.user.playOutVolume != 0 &&
        ((widget.user.id == CallState.instance.selfUser.id) ||
            (widget.user.id != CallState.instance.selfUser.id &&
                widget.user.callStatus == TUICallStatus.accept));
    bool isShowRemoteMute = (widget.user.callStatus == TUICallStatus.accept) &&
        (widget.user.id != CallState.instance.selfUser.id) &&
        !widget.user.audioAvailable;

    return AnimatedPositioned(
        width: W,
        height: H,
        top: _getTop(),
        left: _getLeft(),
        duration: _duration,
        child: InkWell(
            onTap: () {
               GroupCallUserWidgetLayoutData.bigUserIndex = widget.index;
               TUICore.instance.notifyEvent(setStateEventGroupCallUserWidgetRefresh);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(child: Container(color: Colors.grey,)),
                  Visibility(
                    visible: isAvatarImage,
                    child: Positioned.fill(
                      child: Image(
                        image: NetworkImage(
                            StringStream.makeNull(widget.user.avatar, Constants.defaultAvatar)),
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stackTrace) => Image.asset(
                          'assets/images/user_icon.png',
                          package: 'tencent_calls_uikit',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  TUIVideoView(
                    key: widget.user.key,
                    onPlatformViewCreated: (viewId) {
                      _onPlatformViewCreated(widget.user, viewId);
                    },
                  ),
                  Visibility(
                    visible: isShowLoadingImage,
                    child: Center(
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                        width: W,
                        height: H,
                        child: Image.asset(
                          "assets/images/user_loading.gif",
                          package: 'tencent_calls_uikit',
                          width: 80 ,
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isShowSpeaking,
                    child: Positioned(
                        left: 5,
                        bottom: 5,
                        width: 24,
                        height: 24,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              "assets/images/speaking.png",
                              package: 'tencent_calls_uikit',
                            ))),
                  ),
                  Visibility(
                    visible: isShowRemoteMute,
                    child: Positioned(
                        right: 5,
                        bottom: 5,
                        width: 24,
                        height: 24,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              "assets/images/audio_unavailable.png",
                              package: 'tencent_calls_uikit',
                            ))),
                  ),
                  Visibility(
                    visible: isBig,
                    child: Positioned(
                        left: (isShowSpeaking) ? 34 : 5,
                        bottom: 5,
                        width: (isShowSpeaking) ? bigW - 70 : bigW - 40,
                        height: 24,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(User.getUserDisplayName(widget.user), style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ))
                        )),
                  ),
                ],
              ),
            )));
  }


  double _getTop() {
    if (widget.index == GroupCallUserWidgetLayoutData.bigUserIndex) {
      return 0;
    }
    int calculationIndex = 0;
    final smallW = (MediaQuery.of(context).size.width - 32 - 24)/4;
    final bigH = MediaQuery.of(context).size.width-32;
    calculationIndex = widget.index;
    if (widget.index > GroupCallUserWidgetLayoutData.bigUserIndex) {
      calculationIndex = calculationIndex - 1;
    }
    return (calculationIndex / 4).floor() * (smallW + 8) + bigH + 8;
  }

  double _getLeft() {
    if (widget.index == GroupCallUserWidgetLayoutData.bigUserIndex) {
      return 16;
    }
    int calculationIndex = 0;
    final smallW = (MediaQuery.of(context).size.width - 32 - 24)/4;
    calculationIndex = widget.index;
    if (widget.index > GroupCallUserWidgetLayoutData.bigUserIndex) {
      calculationIndex = calculationIndex - 1;
    }
    return (calculationIndex % 4).floor() * (smallW + 8) + 16;
  }



  _onPlatformViewCreated(User user, int viewId) {
    debugPrint("_onPlatformViewCreated: user.id = ${user.id}, viewId = $viewId");
    if (user.id == CallState.instance.selfUser.id) {
      CallState.instance.selfUser.viewID = viewId;
      if (CallState.instance.isCameraOpen) {
        CallManager.instance.openCamera(CallState.instance.camera, viewId);
      }
    } else {
      CallManager.instance.startRemoteView(user.id, viewId);
    }
    user.viewID = viewId;
  }

  _handleSwitchCamera() async {
    if (TUICamera.front == CallState.instance.camera) {
      CallState.instance.camera = TUICamera.back;
    } else {
      CallState.instance.camera = TUICamera.front;
    }
    await CallManager.instance.switchCamera(CallState.instance.camera);
    TUICore.instance.notifyEvent(setStateEvent);
  }

  _handleVirtualBackgroubd() async {
    CallManager.instance.setBlurBackground(!CallState.instance.enableBlurBackground);
  }
}

class GroupCallUserWidgetLayoutData {
  static int bigUserIndex = 0;

}


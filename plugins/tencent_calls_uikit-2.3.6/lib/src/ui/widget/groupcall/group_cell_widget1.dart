import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tencent_calls_engine/tencent_calls_engine.dart';
import 'package:tencent_calls_uikit/src/call_manager.dart';
import 'package:tencent_calls_uikit/src/call_state.dart';
import 'package:tencent_calls_uikit/src/data/constants.dart';
import 'package:tencent_calls_uikit/src/data/user.dart';
import 'package:tencent_calls_uikit/src/i18n/i18n_utils.dart';
import 'package:tencent_calls_uikit/src/platform/tuicall_kit_platform_interface.dart';
import 'package:tencent_calls_uikit/src/ui/tuicall_navigator_observer.dart';
import 'package:tencent_calls_uikit/src/ui/widget/common/extent_button.dart';
import 'package:tencent_calls_uikit/src/ui/widget/common/timing_widget.dart';
import 'package:tencent_calls_uikit/src/ui/widget/groupcall/group_call_user_widget_data.dart';
import 'package:tencent_calls_uikit/src/utils/permission.dart';
import 'package:tencent_calls_uikit/src/utils/string_stream.dart';
import 'package:tencent_cloud_uikit_core/tencent_cloud_uikit_core.dart';

import '../../../../EventBus.dart';
import '../../../../tuicall_kit.dart';
import '../../tuicall_kit_widget.dart';
import 'group_call_user_widget.dart';
import 'group_call_user_widget1.dart';

class GroupCallWidget1 extends StatefulWidget {
  final Function close;

  const GroupCallWidget1({
    Key? key,
    required this.close,
  }) : super(key: key);

  @override
  State<GroupCallWidget1> createState() => _GroupCallWidget1State();
}

class _GroupCallWidget1State extends State<GroupCallWidget1> {
  ITUINotificationCallback? setSateCallBack;
  ITUINotificationCallback? groupCallUserWidgetRefreshCallback;
  late final List<GroupCallUserWidget1> _userViewWidgets = [];

  _initUsersViewWidget() {
    GroupCallUserWidgetData.initBlockCounter();
    GroupCallUserWidgetData.updateBlockBigger(CallState.instance.remoteUserList.length + 1);
    GroupCallUserWidgetData.initCanPlaceSquare(
        GroupCallUserWidgetData.blockBigger, CallState.instance.remoteUserList.length + 1);
    _userViewWidgets.clear();
    if (GroupCallUserWidgetLayoutData.bigUserIndex > CallState.instance.remoteUserList.length) {
      GroupCallUserWidgetLayoutData.bigUserIndex = 0;
    }
    int index = 0;
    GroupCallUserWidgetData.blockCount++;
    _userViewWidgets.add(GroupCallUserWidget1(user: CallState.instance.selfUser, index: index,));

    for (var remoteUser in CallState.instance.remoteUserList) {
      GroupCallUserWidgetData.blockCount++;
      index++;
      _userViewWidgets
          .add(GroupCallUserWidget1(user: remoteUser, index: index,));
    }
    setState(() {});
  }

// CallKit_t("waiting");

  @override
  void initState() {
    super.initState();
    setSateCallBack = (arg) {
      if (mounted) {
        final acceptNum = CallState.instance.remoteUserList.where((e) => e.callStatus==TUICallStatus.accept).toList().length;
        if (acceptNum > 0) {
        }
        setState(() {
          _initUsersViewWidget();
        });
      }
    };

    groupCallUserWidgetRefreshCallback = (arg) {
      print("群组聊天刷新");

    };

    TUICore.instance.registerEvent(setStateEvent, setSateCallBack);
    TUICore.instance
        .registerEvent(setStateEventGroupCallUserWidgetRefresh, groupCallUserWidgetRefreshCallback);

    GroupCallUserWidgetData.initBlockBigger();
    GroupCallUserWidgetData.blockCount = 0;
    _initUsersViewWidget();
  }


  @override
  void dispose() {
    super.dispose();
    TUICore.instance.unregisterEvent(setStateEvent, setSateCallBack);
    TUICore.instance.unregisterEvent(
        setStateEventGroupCallUserWidgetRefresh, groupCallUserWidgetRefreshCallback);
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.of(context).padding;
    final bigH = MediaQuery.of(context).size.width-32;
    final userListH = bigH + 8 + ((MediaQuery.of(context).size.width - 32 - 24)/4 + 8)*(CallState.instance.remoteUserList.length/4).ceil();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: screenPadding.top),
        color: Colors.white,
        child: Column(
          children: [
            _buildNavigationBar(),
            Expanded(child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: (TUICallStatus.waiting == CallState.instance.selfUser.callStatus &&
                    CallState.instance.selfUser.callRole == TUICallRole.called)
                    ? MediaQuery.of(context).size.height - 159 - MediaQuery.of(context).padding.top - 44
                    : userListH,
                child: Stack(
                  children: [
                    _buildUserVideoList()
                  ],
                ),
              ),
            )),
            _buildFunctionWidget(),
          ],
        ),
      ),
    );
  }

  _buildNavigationBar() {
    final timerWidget = (TUICallStatus.accept == CallState.instance.selfUser.callStatus)
        ? const TimingWidget(textColor: Color(0xFFFB8701),)
        : Text(CallKit_t("waiting"));
    return Container(
      height: 44,
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 4,),
          // 悬浮窗按钮
          Visibility(
            visible: CallState.instance.enableFloatWindow,
            child: InkWell(
                onTap: () => _openFloatWindow(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      'assets/images/floating_button.png',
                      package: 'tencent_calls_uikit',
                    ),
                  ),
                )),
          ),
          Expanded(child: Center(child: timerWidget,)),
          Visibility(
            visible: TUICallStatus.accept == CallState.instance.selfUser.callStatus ||
                TUICallRole.caller == CallState.instance.selfUser.callRole,
            child: InkWell(
                onTap: () => TUICallKitNavigatorObserver.getInstance().enterInviteUserPage(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      'assets/images/add_user.png',
                      package: 'tencent_calls_uikit',
                    ),
                  ),
                )),
          ),
          const SizedBox(width: 4,),
        ]
      )
    );
  }

  _buildUserVideoList() {
    return (TUICallStatus.waiting == CallState.instance.selfUser.callStatus &&
        CallState.instance.selfUser.callRole == TUICallRole.called)
        ? _buildReceivedGroupCallWaitting()
        : _buildGroupCallView();
  }

  _buildReceivedGroupCallWaitting() {
    return Positioned(
        top: 0,
        left: 0,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 150),
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Image(
                image: NetworkImage(StringStream.makeNull(
                    CallState.instance.caller.avatar, Constants.defaultAvatar)),
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stackTrace) => Image.asset(
                  'assets/images/user_icon.png',
                  package: 'tencent_calls_uikit',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                User.getUserDisplayName(CallState.instance.caller),
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Text(
              CallKit_t("invitedToGroupCall"),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              CallKit_t("theyAreAlsoThere"),
              style: const TextStyle(color: Colors.white),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: List.generate(CallState.instance.calleeList.length, ((index) {
                  return Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: Image(
                        image: NetworkImage(StringStream.makeNull(
                            CallState.instance.calleeList[index].avatar, Constants.defaultAvatar)),
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stackTrace) => Image.asset(
                          'assets/images/user_icon.png',
                          package: 'tencent_calls_uikit',
                        ),
                      ),
                    ),
                  );
                })),
              ),
            )
          ],
        ));
  }

  _buildGroupCallView() {
    final bigH = MediaQuery.of(context).size.width-32;
    final userListH = bigH + 8 + ((MediaQuery.of(context).size.width - 32 - 24)/4 + 8)*(CallState.instance.remoteUserList.length/4).ceil();
    return Positioned(
        top: 0,
        left: 0,
        width: MediaQuery.of(context).size.width,
        height: userListH,
        child: Stack(children: _userViewWidgets));
  }

  _buildFunctionWidget() {
    Widget functionWidget;
    if (TUICallStatus.waiting == CallState.instance.selfUser.callStatus &&
        TUICallRole.called == CallState.instance.selfUser.callRole) {
      functionWidget = _buildAudioAndVideoCalleeWaitingFunctionView();
    } else {
      functionWidget = _buildVideoCallerAndCalleeAcceptedFunctionView();
    }

    return functionWidget;
  }

  _buildAudioAndVideoCalleeWaitingFunctionView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ExtendButton(
              imgUrl: "assets/images/hangup.png",
              tips: CallKit_t("hangUp"),
              textColor: Colors.white,
              imgHeight: 64,
              onTap: () {
                _handleReject(widget.close);
              },
            ),
            ExtendButton(
              imgUrl: "assets/images/dialing.png",
              tips: CallKit_t("accept"),
              textColor: Colors.white,
              imgHeight: 64,
              onTap: () {
                _handleAccept();
              },
            ),
          ],
        ),
        const SizedBox(height: 80)
      ],
    );
  }





  _buildVideoCallerAndCalleeAcceptedFunctionView() {
    final screenPadding = MediaQuery.of(context).padding;
    return Container(
      // 部分圆角
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              // 麦克风
              Expanded(child: _buildFunctionBtnWidget(
                imgUrl: CallState.instance.isMicrophoneMute
                    ? "assets/images/mute_on.png"
                    : "assets/images/mute.png",
                text: (CallState.instance.isMicrophoneMute
                    ? CallKit_t("microphoneIsOff")
                    : CallKit_t("microphoneIsOn")),
                onTap: () {
                  _handleSwitchMic();
                },
              )),
              // 扬声器
              Expanded(child: _buildFunctionBtnWidget(
                imgUrl: CallState.instance.audioDevice == TUIAudioPlaybackDevice.speakerphone
                    ? "assets/images/handsfree_on.png"
                    : "assets/images/handsfree.png",
                text: (CallState.instance.audioDevice == TUIAudioPlaybackDevice.speakerphone
                    ? CallKit_t("speakerIsOn")
                    : CallKit_t("speakerIsOff")),
                onTap: () {
                  _handleSwitchAudioDevice();
                },
              )),
              // 摄像头
              Expanded(child: _buildFunctionBtnWidget(
                imgUrl: CallState.instance.isCameraOpen
                    ? "assets/images/camera_on.png"
                    : "assets/images/camera_off.png",
                text: (CallState.instance.isCameraOpen
                    ? CallKit_t("cameraIsOn")
                    : CallKit_t("cameraIsOff")),
                onTap: () {
                  _handleOpenCloseCamera();
                },
              )),
              //  切换摄像头
              Expanded(child: _buildFunctionBtnWidget(
                imgUrl: "assets/images/switch_camera_group.png",
                text: CallKit_t("switchCamera"),
                onTap: () {
                  _handleSwitchCamera();
                },
              )),
            ],
          ),
          const SizedBox(height: 16),
          // 挂断
          Center(child: _buildFunctionBtnWidget(
            imgUrl: "assets/images/hangup.png",
            text: CallKit_t("hangUp"),
            onTap: () {
              _handleHangUp(widget.close);
            },
          )),
          SizedBox(height: screenPadding.bottom + 20,),
        ],
      ),
    );

  }

  Widget _buildFunctionBtnWidget({required String imgUrl, required String text, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Image.asset(
              imgUrl,
              package: 'tencent_calls_uikit',
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF323333)),
          ),
        ],
      ),
    );
  }


  // _functionWidgetVerticalDragUpdate(DragUpdateDetails details) {
  //   if (details.delta.dy < 0 && !isFunctionExpand) {
  //     isFunctionExpand = true;
  //   } else if (details.delta.dy > 0 && isFunctionExpand) {
  //     isFunctionExpand = false;
  //   }
  //   setState(() {});
  // }

  _openFloatWindow() async {
    if (Platform.isAndroid) {
      bool result = await TUICallKitPlatform.instance.hasFloatPermission();
      if (!result) {
        return;
      }
    }
    CallManager.instance.openFloatWindow();
    TUICallKitNavigatorObserver.getInstance().exitCallingPage();
  }

  _handleSwitchMic() async {
    if (CallState.instance.isMicrophoneMute) {
      CallState.instance.isMicrophoneMute = false;
      await CallManager.instance.openMicrophone();
    } else {
      CallState.instance.isMicrophoneMute = true;
      await CallManager.instance.closeMicrophone();
    }
    setState(() {});
  }

  _handleSwitchAudioDevice() async {
    if (CallState.instance.audioDevice == TUIAudioPlaybackDevice.earpiece) {
      CallState.instance.audioDevice = TUIAudioPlaybackDevice.speakerphone;
    } else {
      CallState.instance.audioDevice = TUIAudioPlaybackDevice.earpiece;
    }
    await CallManager.instance.selectAudioPlaybackDevice(CallState.instance.audioDevice);
    setState(() {});
  }

  _handleHangUp(Function close) async {
    final groupId = CallState.instance.groupId;
    // StreamController.broadcast().add(ImCallEvent(name: "handleHangUpGroupCall", data: {"groupId": CallState.instance.groupId, "roomId": CallState.instance.roomId}));
    eventBus.fire(ImCallEvent(name: HANG_UP_CALL_EVENT_BUS_NAME, data: {"groupId": groupId, "roomId": "${CallState.instance.roomId.intRoomId}"}));
    print("挂断通话 - ${CallState.instance.roomId.strRoomId} - ${CallState.instance.roomId.intRoomId}");
    await CallManager.instance.hangup();
    close();
  }

  _handleReject(Function close) async {
    await CallManager.instance.reject();
    close();
  }

  _handleAccept() async {
    PermissionResult permissionRequestResult = PermissionResult.requesting;
    if (Platform.isAndroid) {
      permissionRequestResult = await Permission.request(CallState.instance.mediaType);
    }
    if (permissionRequestResult == PermissionResult.granted || Platform.isIOS) {
      await CallManager.instance.accept();
      CallState.instance.selfUser.callStatus = TUICallStatus.accept;
      print("接通通话 - ${CallState.instance.roomId.strRoomId} - ${CallState.instance.roomId.intRoomId}");
      // StreamController.broadcast().add(ImCallEvent(name: "acceptGroupCall", data: {"groupId": CallState.instance.groupId, "roomId": CallState.instance.roomId}));
      eventBus.fire(ImCallEvent(name: ACCEPT_CALL_EVENT_BUS_NAME, data: {"groupId": CallState.instance.groupId, "roomId": "${CallState.instance.roomId.intRoomId}"}));
    } else {
      CallManager.instance.showToast(CallKit_t("insufficientPermissions"));
    }
    setState(() {});
  }

  static void _handleSwitchCamera() async {
    if (TUICamera.front == CallState.instance.camera) {
      CallState.instance.camera = TUICamera.back;
    } else {
      CallState.instance.camera = TUICamera.front;
    }
    await CallManager.instance.switchCamera(CallState.instance.camera);
    TUICore.instance.notifyEvent(setStateEvent);
  }

  void _handleOpenCloseCamera() async {
    CallState.instance.isCameraOpen = !CallState.instance.isCameraOpen;
    if (CallState.instance.isCameraOpen) {
      await CallManager.instance
          .openCamera(CallState.instance.camera, CallState.instance.selfUser.viewID);
    } else {
      await CallManager.instance.closeCamera();
    }
    setState(() {});
  }
}

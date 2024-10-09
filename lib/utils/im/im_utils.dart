import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/user/login_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/im/im_message_utils.dart';
import 'package:bee_chat/widget/alert_pop_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:tencent_calls_uikit/EventBus.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import 'package:tencent_calls_uikit/tuicall_kit.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/custom_message_utils.dart';
import 'package:vibration/vibration.dart';

import '../../pages/assets/assets_voices_page.dart';
import '../../pages/login_regist/start_page.dart';
import '../../pages/main_page.dart';
import '../../pages/splash_page.dart';
import '../../provider/user_provider.dart';
import '../ab_loading.dart';
import '../ab_shared_preferences.dart';
import '../ab_toast.dart';

const imAppId = 1600043588;

class ImUtils {
  static Future<V2TimMessage?> findMessage(String msgID) async {
    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().findMessages(messageIDList: [msgID]);
    return res.data?.first;
  }

  static get listener {
    return _listener;
  }

  static TUICallObserver? _observer;
  static V2TimAdvancedMsgListener? _msgListener;

  static final V2TimSDKListener _listener = V2TimSDKListener(
      onConnectFailed: (int code, String error) {},
      onConnectSuccess: () {},
      onConnecting: () {},
      // 当前用户被踢下线，此时可以 UI 提示用户，并再次调用 V2TIMManager 的 login() 函数重新登录。
      onKickedOffline: () async {
        print("被挤下线");
        await ABSharedPreferences.setToken("");
        await ABSharedPreferences.setUserId("");
        await ABSharedPreferences.setUserSign("");
        AlertPopWidget.show(
            title: AB_getS(MyApp.context, listen: false).prompt,
            content: AB_getS(MyApp.context, listen: false).accountLogged,
            isShowCancelButton: false,
            onPressed: (bool isConfirmed) async {
              ABRoute.popToRoot();
              ABRoute.pushReplacement(const StartPage(), tag: "root");
            });
      },
      onUserStatusChanged: (List<V2TimUserStatus> userStatusList) {},
      onSelfInfoUpdated: (V2TimUserFullInfo info) {},
      onUserSigExpired: () {},
  );

  // 登陆IM
  static Future<bool> loginIm({required String userSign, required String userId, required String token}) async {
    LoginModel model = LoginModel();
    model.userId = userId;
    model.token = token;
    model.userSig = userSign;
    UserProvider.setCurrentUser(model);
    ABLoading.show();
    await ABSharedPreferences.setToken(token);
    await ABSharedPreferences.setUserId(userId);
    await ABSharedPreferences.setUserSign(userSign);
    var data = await TIMUIKitCore.getInstance().login(
      userID: userId,
      userSig: userSign,
    );
    await ABLoading.dismiss();
    if (data.code != 0) {
      final option1 = data.desc;
      debugPrint("登陆失败 - $option1");
      ABToast.show("登录失败 - $option1");
      return false;
    }
    print("登陆成功");
    _listenMessage();
    final result = await TUICallKit.instance.login(
        imAppId, // 请替换为第一步得到的SDKAppID
        userId, // 请替换为您的User ID
        userSign); // 您可以在控制台计算一个UserSig并填到该位置
    debugPrint("登陆视频通话 - ${result.toString()}");
    _listenCall();
    await ABRoute.popToRoot();
    await ABRoute.pushReplacement(const MainPage(), tag: "root");
    return true;
  }


  static _listenMessage() async {
    if (_msgListener != null) {
      await TencentImSDKPlugin.v2TIMManager.getMessageManager().removeAdvancedMsgListener(listener: _msgListener);
    }
    _msgListener = V2TimAdvancedMsgListener(
      // onRecvC2CReadReceipt: (List<V2TimMessageReceipt> receiptList) {},
      // onRecvMessageModified: (V2TimMessage message) {},
      // onRecvMessageReadReceipts: (List<V2TimMessageReceipt> receiptList) {},
      // onRecvMessageRevoked: (String messageid) {},
      onRecvNewMessage: (V2TimMessage message) async {
        print("收到消息");
        if (message.isSelf ?? false) {
          return;
        }
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
          return;
        }
        UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
        if (provider.noticeSetting.showSound ?? false) {
          FlutterRingtonePlayer().play(fromAsset: provider.noticeSetting.sound.soundsPath(), looping: false, volume: 1, asAlarm: true);
        }
        if (provider.noticeSetting.vibration ?? false) {
          // 震动
          _triggerLongVibration();
        }

      },
      // onSendMessageProgress: (V2TimMessage message, int progress) {},
    );

    TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(listener: _msgListener!);
  }

  static  _triggerLongVibration() {
    Vibration.vibrate(duration: 1000, amplitude: 128);
    // 避免有些手机不支持上面震动方式，增加下面震动
    const int vibrationDuration = 600; // 震动持续时间，单位为毫秒
    int interval = 20; // 两次震动之间的间隔时间
    int count = vibrationDuration ~/ (interval + 50); // 震动次数
    for (int i = 0; i < count; i++) {
      HapticFeedback.vibrate();
      Future.delayed(Duration(milliseconds: interval), () {
        if (i < count - 1) {
          HapticFeedback.vibrate();
        }
      });
    }
  }


  static _listenCall() async {
    final isLoadCall = await TUICore().getService(TUICALLKIT_SERVICE_NAME);
    if (!isLoadCall) {
      return;
    }
    // 订阅通话操作事件（接通，挂断，加入）
    eventBus.on<ImCallEvent>().listen((event) {
      if (event.name == ACCEPT_CALL_EVENT_BUS_NAME) {
        final groupId = event.data["groupId"] ?? "";
        final roomId = event.data["roomId"] ?? "";
        if (groupId.isNotEmpty && roomId.isNotEmpty) {
          ImMessageUtils.sendJoinToGroupCallMessage(groupId: groupId, roomId: roomId);
        }
      }
      if (event.name == HANG_UP_CALL_EVENT_BUS_NAME) {
        final groupId = event.data["groupId"] ?? "";
        final roomId = event.data["roomId"] ?? "";
        if (groupId.isNotEmpty && roomId.isNotEmpty) {
          ImMessageUtils.sendLeaveGroupCallMessage(groupId: groupId, roomId: roomId);
        }
      }
    });

    // 监听通话事件
    if (_observer != null) {
      TUICallEngine.instance.removeObserver(_observer!);
    }
    _observer = TUICallObserver(onError: (int code, String message) {
      //
    }, onCallBegin: (TUIRoomId roomId, TUICallMediaType callMediaType, TUICallRole callRole) {
      //您的回调处理逻辑
    }, onCallEnd: (TUIRoomId roomId, TUICallMediaType callMediaType, TUICallRole callRole, double totalTime) {
      //您的回调处理逻辑
    }, onUserNetworkQualityChanged: (List<TUINetworkQualityInfo> networkQualityList) {
      //您的回调处理逻辑
    });
    TUICallEngine.instance.addObserver(_observer!);
  }
}

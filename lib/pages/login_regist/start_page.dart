import 'dart:async';
import 'package:bee_chat/models/user/login_model.dart';
import 'package:bee_chat/net/common_net.dart';
import 'package:bee_chat/pages/login_regist/login_page.dart';
import 'package:bee_chat/pages/login_regist/regist_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/app_update_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_calls_uikit/tuicall_kit.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../models/common/version_list_model.dart';
import '../../utils/ab_loading.dart';
import '../../utils/ab_shared_preferences.dart';
import '../../utils/ab_toast.dart';
import '../../utils/im/im_utils.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text.dart';
import '../main_page.dart';
import '../splash_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  StreamSubscription? _subscription;

  // 网络是否正常
  bool? _isNetworkOk;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkNetwork();
      _authLogin();
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      body: Container(
        color: theme.backgroundColorWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ABScreen.statusHeight + 68.px),
            Container(
              width: 325.px,
              height: 341.px,
              child: Stack(
                children: [
                  // 背景
                  Positioned.fill(
                    child: Image.asset(
                      ABAssets.startBackground(context),
                      fit: BoxFit.contain,
                    ),
                  ),
                  // logo
                  Image.asset(
                    ABAssets.logoText(context),
                    width: 209.px,
                    height: 200.px,
                  ).center,
                ],
              ),
            ),
            Container().expanded(),
            // 注册按钮
            ABButton.gradientColorButton(
              text: AB_getS(context).register,
              colors: [theme.primaryColor, theme.secondaryColor],
              stops: [0.0, 1],
              height: 48.px,
              cornerRadius: 6.px,
              textColor: Colors.black,
              fontWeight: FontWeight.w600,
              onPressed: () {
                ABRoute.push(const RegisterPage());
              },
            ).addMargin(margin: EdgeInsets.only(left: 24.px, right: 24.px)),
            SizedBox(height: 30.px),
            // 登录按钮
            ABButton(
              text: AB_getS(context).login,
              height: 48.px,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontWeight: FontWeight.w600,
              onPressed: () {
                ABRoute.push(const LoginPage());
              },
            ).addMargin(margin: EdgeInsets.only(left: 24.px, right: 24.px)),
            SizedBox(height: 10.px + ABScreen.bottomHeight,),
            // SizedBox(height: _calculateBottomPadding()),
          ],
        ),
      ),
    );
  }

  /// 检查网络
  /// 如果没有网络，则显示网络提示
  void _checkNetwork() async {
    ABLoading.show();
    _subscription = Connectivity().onConnectivityChanged.listen((event) {
      print("网络状态回调 - ${event}");
      ABLoading.dismiss();
      setState(() {
        _isNetworkOk = !(event == ConnectivityResult.none);
      });
    });
  }

  // 自动登陆
  Future<void> _authLogin() async {
    ABLoading.show();
    final token = await ABSharedPreferences.getToken() ?? "";
    final userId = await ABSharedPreferences.getUserId() ?? "";
    final userSign = await ABSharedPreferences.getUserSign() ?? "";
    await ABLoading.dismiss();
    if (token.isEmpty || userId.isEmpty || userSign.isEmpty) {
      return;
    }
    // 登陆Im
    ImUtils.loginIm(userSign: userSign,
        userId: userId,
        token: token);

  }
}

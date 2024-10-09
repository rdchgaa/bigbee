import 'dart:convert';

import 'package:bee_chat/models/user/login_model.dart';
import 'package:bee_chat/net/common_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/account_security/mnemonic_input_page.dart';
import 'package:bee_chat/pages/conversation/conversation_page.dart';
import 'package:bee_chat/pages/login_regist/regist_page.dart';
import 'package:bee_chat/pages/main_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import 'package:tencent_calls_uikit/tuicall_kit.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../models/common/captcha_image_model.dart';
import '../../utils/GenerateUserSig.dart';
import '../../utils/ab_assets.dart';
import '../../utils/ab_loading.dart';
import '../../utils/ab_shared_preferences.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../utils/im/im_utils.dart';
import '../../widget/ab_text_field.dart';
import '../account_security/mnemonic_show_page.dart';
import '../splash_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 昵称
  String _nickName = "";

  // 密码
  String _password = ""; // 图形验证码
  String _captcha = "";

  // 图形验证码uuid
  String _captchaUuid = "";

  // 图形验证码
  ImageProvider? _captchaImage;

  // 是否需要图形验证码
  bool _needCaptcha = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final model = await _requestCaptcha();
      if (model != null) {
        _refreshCaptcha(model);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      backgroundColor: theme.backgroundColorWhite,
      // appBar: ABAppBar(title: "123"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: ABScreen.statusHeight,
          ),
          // 顶部导航栏
          Row(
            children: [
              Container(
                width: 24.0 + 16.px,
                height: 44.0,
                color: Colors.transparent,
                // 返回按钮
                child: (!Navigator.canPop(context))?SizedBox():IconButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final isBack = await Navigator.maybePop(context);
                    if (!isBack) {
                      ABRoute.pop();
                    }
                  },
                  padding: EdgeInsets.only(left: 16.px),
                  icon: Icon(CupertinoIcons.arrow_left, color: theme.black,),
                ),
              )
            ],
          ),
          ListView(
            children: [

              SizedBox(
                height: 20.px,
              ),
              // 带文字Logo
              Image.asset(
                ABAssets.logoText(context),
                width: 151.px,
                height: 146.px,
              ),
              SizedBox(height: 70.px,),
              // 昵称输入框
              _getInputWidget(ABAssets.loginNicknameIcon(
                  context, isSelect: _checkNickName()), ABTextField(
                text: _nickName,
                contentPadding: EdgeInsets.only(bottom: 12.px),
                textSize: 14.px,
                hintText: AB_getS(context).userAccountHintText,
                isPassword: false,
                onChanged: (text) {
                  setState(() {
                    _nickName = text;
                  });
                },
              ).expanded(), rightWidget: SizedBox(width: 14.px,)),
              SizedBox(height: 26.px,),
              // 密码输入框
              _getInputWidget(ABAssets.loginPasswordIcon(
                  context, isSelect: _checkPassword()), ABTextField(
                text: _password,
                contentPadding: EdgeInsets.only(bottom: 12.px),
                textSize: 14.px,
                hintText: AB_getS(context).inputPassword,
                isPassword: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (text) {
                  setState(() {
                    _password = text;
                  });
                },
              ).expanded(), rightWidget: SizedBox(width: 14.px,)),
              SizedBox(height: (_needCaptcha ? 26.px : 4.px),),
              // 图形验证码
              if (_needCaptcha) _getInputWidget(null, ABTextField(
                text: _captcha,
                textSize: 14.px,
                hintText: AB_getS(context).inputCaptcha,
                isPassword: false,
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  setState(() {
                    _captcha = text;
                  });
                },
              ).expanded(), rightWidget: _getCaptchaWidget()),
              if (_needCaptcha) SizedBox(height: 4.px,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildRegisterTextButton(),
                ],
              ).addPadding(padding: EdgeInsets.symmetric(horizontal: 26.px)),
            ],
          ).expanded(),
          // 忘记密码按钮
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              ABRoute.push(MnemonicInputPage());
            },
            child: ABText(AB_getS(context).forgetPassword,
                textColor: theme.secondaryColor, fontSize: 14.px),
          ),
          SizedBox(height: 10.px,),
          // 登陆按钮
          ABButton.gradientColorButton(text: AB_getS(context).login,
              textColor: theme.black,
              fontWeight: FontWeight.w600,
              colors: [theme.primaryColor, theme.secondaryColor],
              height: 48.px,
              cornerRadius: 6.px,
              onPressed: () {
                if (!_checkNickName()) {
                  ABToast.show(AB_getS(context, listen: false).loginAccountTip);
                  return;
                }
                if (!_checkPassword()) {
                  ABToast.show(AB_getS(context, listen: false).passwordTip);
                  return;
                }
                if (_needCaptcha && _captcha.isEmpty) {
                  ABToast.show(AB_getS(context, listen: false).inputCaptcha);
                  return;
                }
                // 关闭键盘
                FocusManager.instance.primaryFocus?.unfocus();
                _doLogin();
              }).addPadding(padding: EdgeInsets.symmetric(horizontal: 24.px)),
          SizedBox(
            height: 10.px + ABScreen.bottomHeight,
          ),
        ],
      ),
    );
  }

  /*输入框包装*/
  Widget _getInputWidget(String? iconName, Widget child,
      {Widget? rightWidget}) {
    final theme = AB_theme(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.inputFillColor,
        // 圆角
        borderRadius: BorderRadius.circular(8.px),
      ),
      height: 52.px,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 14.px,
          ),
          if (iconName != null) Image.asset(
            iconName, width: 24.px, height: 24.px,),
          if (iconName != null) SizedBox(width: 14.px,),
          child,
          if (rightWidget != null) rightWidget,
        ],
      ),
    ).addPadding(padding: EdgeInsets.symmetric(horizontal: 24.px));
  }

  /*获取图形验证码组件*/
  Widget _getCaptchaWidget() {
    // 比例2.5
    return SizedBox(
      height: 44.px,
      child: AspectRatio(
        aspectRatio: 2.5,
        child: GestureDetector(
          onTap: () async {
            ABLoading.show();
            final model = await _requestCaptcha();
            ABLoading.dismiss();
            if (model != null) {
              _refreshCaptcha(model);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: HexColor("#FEFEFE"),
              // 圆角
              borderRadius: BorderRadius.circular(8.px),
              image: (_captchaImage != null ? DecorationImage(
                  image: _captchaImage!, fit: BoxFit.cover) : null),
            ),
          ),
        ),
      ).addPadding(padding: EdgeInsets.only(left: 4.px, right: 4.px)),
    );
  }

  Widget _buildRegisterTextButton() {
    final theme = AB_theme(context);
    final noAccountStr = AB_getS(context).noAccount;
    final registerStr = AB_getS(context).goRegister;
    return CupertinoButton(
      padding: EdgeInsets.zero, // 移除按钮默认的内边距
      onPressed: () {
        ABRoute.push(RegisterPage());
      },
      child: EasyRichText(
        "${noAccountStr}${registerStr}",
        defaultStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14.px,
        ),
        patternList: [
          EasyRichTextPattern(
            targetString: registerStr,
            style: TextStyle(
              color: theme.secondaryColor,
              fontSize: 14.px,
            ),
          ),
        ],
      ),
    );
  }

  /*检查昵称*/
  bool _checkNickName() {
    // 账号为6-20英文或数字组成
    if (_nickName.length < 6 || _nickName.length > 20) {
      return false;
    }
    if (!_nickName.contains(RegExp(r'^[a-zA-Z0-9@#%.]+$'))) {
      return false;
    }
    return true;
  }

  /*检查密码*/
  bool _checkPassword() {
    // 密码要求8-20位，由数字、字母组成
    if (_password.length < 8 || _password.length > 20) {
      return false;
    }
    if (!_password.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
      return false;
    }
    return true;
  }

  void _refreshCaptcha(CaptchaImageModel model) {
    setState(() {
      _needCaptcha = model.captchaEnabledLogin ?? false;
    });
    if (model.img == null) {
      return;
    }
    setState(() {
      Uint8List imageBytes = base64Decode(model.img ?? "");
      _captchaImage = MemoryImage(imageBytes);
      _captchaUuid = model.uuid ?? "";
    });
  }

  Future<CaptchaImageModel?> _requestCaptcha() async {
    print("请求图形验证码");
    final result = await CommonNet.getCaptchaImage();
    return Future.value(result.data);
  }


  void _doLogin() async {
    final code = _needCaptcha ? _captcha : null;
    final uuid = _needCaptcha ? _captchaUuid : null;
    ABLoading.show();
    final result = await UserNet.login(
        username: _nickName, password: _password, code: code, uuid: uuid);
    UserProvider.setCurrentUser(result.data ?? LoginModel());
    await ABLoading.dismiss();
    if (result.data != null && result.data!.userSig != null &&
        result.data!.userId != null && result.data!.token != null) {
      // 登陆Im
      ImUtils.loginIm(userSign: result.data!.userSig!,
          userId: result.data!.userId!,
          token: result.data!.token!);
    }
  }

}

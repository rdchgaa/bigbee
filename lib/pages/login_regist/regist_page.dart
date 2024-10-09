import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:bee_chat/models/user/login_model.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/string_extensions.dart';
import 'package:bee_chat/utils/im/im_utils.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import '../../models/common/captcha_image_model.dart';
import '../../net/common_net.dart';
import '../../provider/theme_provider.dart';
import '../../utils/GenerateUserSig.dart';
import '../../utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';

import '../account_security/mnemonic_show_page.dart';
import '../main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 昵称
  String _nickName = "";

  // 密码
  String _password = "";
  // 确认密码
  String _confirmPassword = "";

  // 邀请码
  String _invitedCode = "";
  // 图形验证码
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
                child: IconButton(
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
              SizedBox(
                height: 40.px,
              ),
              // 昵称输入框
              _getInputWidget(ABAssets.loginNicknameIcon(context, isSelect: _checkNickName()), ABTextField(
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
              SizedBox(height: 4.px,),
              // 昵称提示词
              Container(
                  alignment: Alignment.centerLeft,
                  height: 33.px,
                  child: FittedBox(
                      child: ABText(
                        AB_getS(context).loginAccountTip,
                        textColor:
                        (_checkNickName() ? theme.textGrey : theme.errorColor),
                        fontSize: 12,
                        maxLines: 2,
                        softWrap: true,
                      ))).addPadding(padding: EdgeInsets.symmetric(horizontal: 26.px)),
              SizedBox(height: 20.px,),
              // 密码输入框
              _getInputWidget(ABAssets.loginPasswordIcon(context, isSelect: _checkPassword()), ABTextField(
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
              SizedBox(height: 4.px,),
              // 密码提示词
              Container(
                  alignment: Alignment.centerLeft,
                  height: 33.px,
                  child: ABText(
                    AB_getS(context).passwordTip,
                    textColor:
                    (_checkPassword() ? theme.textGrey : theme.errorColor),
                    fontSize: 12,
                    maxLines: 2,
                    softWrap: true,
                  )).addPadding(padding: EdgeInsets.symmetric(horizontal: 26.px)),
              SizedBox(height: 20.px,),
              // 确认密码
              _getInputWidget(ABAssets.loginPasswordIcon(context, isSelect: _checkConfirmPassword()), ABTextField(
                text: _confirmPassword,
                contentPadding: EdgeInsets.only(bottom: 12.px),
                textSize: 14.px,
                hintText: AB_getS(context).inputConfirmPassword,
                isPassword: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (text) {
                  setState(() {
                    _confirmPassword = text;
                  });
                },
              ).expanded(), rightWidget: SizedBox(width: 14.px,)),
              SizedBox(height: 26.px,),
              // 邀请码输入框
              _getInputWidget(ABAssets.loginInvitedIcon(context, isSelect: _checkInvitedCode()), ABTextField(
                text: _invitedCode,
                contentPadding: EdgeInsets.only(bottom: 12.px),
                textSize: 14.px,
                hintText: AB_getS(context).inputInvitedCode,
                isPassword: false,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (text) {
                  setState(() {
                    _invitedCode = text;
                  });
                },
              ).expanded(), rightWidget: SizedBox(width: 14.px,)),
              SizedBox(height: 26.px,),
              // 图形验证码
              if (_needCaptcha) _getInputWidget(null, ABTextField(
                text: _captcha,
                textSize: 14.px,
                hintText: AB_getS(context).inputCaptcha,
                isPassword: false,
                onChanged: (text) {
                  setState(() {
                    _captcha = text;
                  });
                },
              ).expanded(), rightWidget: _getCaptchaWidget()),
            ],
          ).expanded(),
          SizedBox(height: 10.px,),
          // 下一步按钮
          ABButton.gradientColorButton(text: AB_getS(context).next, textColor: theme.black, fontWeight: FontWeight.w600, colors: [theme.primaryColor, theme.secondaryColor], height: 48.px, cornerRadius: 6.px, onPressed: () {
            _doRegister();
          }).addPadding(padding: EdgeInsets.symmetric(horizontal: 24.px)),
          SizedBox(height: 10.px + ABScreen.bottomHeight,),
        ],
      ),
    );
  }

  /*输入框包装*/
  Widget _getInputWidget(String? iconName, Widget child, {Widget? rightWidget}) {
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
          if (iconName != null) Image.asset(iconName, width: 24.px, height: 24.px,),
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
              color: "#fefefe".hexColor,
              // 圆角
              borderRadius: BorderRadius.circular(8.px),
              image: (_captchaImage != null ? DecorationImage(image: _captchaImage!, fit: BoxFit.cover) : null),
            ),
          ),
        ),
      ).addPadding(padding: EdgeInsets.only(left: 4.px, right: 4.px)),
    );
  }

  /*检查昵称*/
  bool  _checkNickName() {
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

  bool _checkConfirmPassword() {
    if (_password != _confirmPassword || _confirmPassword.isEmpty) {
      return false;
    }
    return true;
  }

  /*检查邀请码*/
  bool _checkInvitedCode() {
    if (_invitedCode.isEmpty) {
      return true;
    }
    // 邀请码要求6位，由数字与字母组成
    if (_invitedCode.length != 6) {
      return false;
    }
    if (!_invitedCode.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
      return false;
    }
    return true;
  }

  void _refreshCaptcha(CaptchaImageModel model) {
    setState(() {
      _needCaptcha = model.captchaEnabledRegister ?? false;
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
    final result = await CommonNet.getCaptchaImage();
    return Future.value(result.data);
  }

  // 注册
  void _doRegister() async {
    if (!_checkNickName()) {
      ABToast.show(AB_getS(context, listen: false).loginAccountTip);
      return;
    }
    if (!_checkPassword()) {
      ABToast.show(AB_getS(context, listen: false).passwordTip);
      return;
    }
    if (_password != _confirmPassword) {
      ABToast.show(AB_getS(context, listen: false).confirmPasswordError);
      return;
    }
    if (_needCaptcha && _captcha.isEmpty) {
      ABToast.show(AB_getS(context, listen: false).inputCaptcha);
      return;
    }
    if(!_checkInvitedCode()) {
      ABToast.show(AB_getS(context, listen: false).invitedError);
      return;
    }
    final code = _needCaptcha ? _captcha : null;
    final uuid = _needCaptcha ? _captchaUuid : null;
    final inviteCode = _invitedCode.isEmpty ? null : _invitedCode;
    ABLoading.show();
    final result = await UserNet.register(username: _nickName, password: _password, code: code, uuid: uuid, inviteCode: inviteCode);
    UserProvider.setCurrentUser(result.data??LoginModel());
    await ABLoading.dismiss();
    if (result.data != null && result.data!.userSig != null && result.data!.userId != null && result.data!.token != null) {
      _doLogin(userSign: result.data!.userSig!, userId: result.data!.userId!, token: result.data!.token!);
    }

  }

  void _doLogin({required String userSign, required String userId, required String token}) async {
    // 登陆Im
    final suc = await ImUtils.loginIm(userSign: userSign,
        userId: userId,
        token: token)as bool;
    if (suc) {
      ABRoute.push(const MnemonicShowPage(isShowBackBtn: false, isCanSkip: true));
    }

  }

}

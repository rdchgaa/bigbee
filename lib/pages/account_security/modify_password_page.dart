import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text.dart';
import '../../widget/ab_text_field.dart';

class ModifyPasswordPage extends StatefulWidget {
  const ModifyPasswordPage({super.key});

  @override
  State<ModifyPasswordPage> createState() => _ModifyPasswordPageState();
}

class _ModifyPasswordPageState extends State<ModifyPasswordPage> {

  // 原密码
  String _originalPassword = "";
  // 密码
  String _password = "";
  // 确认密码
  String _confirmPassword = "";


  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).modifyPassword,
        backgroundWidget: Container(
          // 渐变色
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                HexColor("#FFDC79"),
                HexColor("#FFCB32"),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: ABScreen.statusHeight,
          ),
          ListView(
            children: [
              SizedBox(height: 10.px,),
              // 原密码输入框
              _getInputWidget(ABAssets.loginPasswordIcon(context, isSelect: _checkOriginalPassword()), ABTextField(
                text: _originalPassword,
                textSize: 14.px,
                hintText: AB_getS(context).inputOriginalPassword,
                isPassword: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (text) {
                  setState(() {
                    _originalPassword = text;
                  });
                },
              ).expanded(), rightWidget: SizedBox(width: 14.px,)),
              SizedBox(height: 20.px,),
              // 密码输入框
              _getInputWidget(ABAssets.loginPasswordIcon(context, isSelect: _checkPassword()), ABTextField(
                text: _password,
                textSize: 14.px,
                hintText: AB_getS(context).inputNewPassword,
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
            ],
          ).expanded(),
          SizedBox(height: 10.px,),
          // 确认按钮
          ABButton.gradientColorButton(text: AB_getS(context).confirm, textColor: theme.black, fontWeight: FontWeight.w600, colors: [theme.primaryColor, theme.secondaryColor], height: 48.px, cornerRadius: 6.px, onPressed: () {

          }).addPadding(padding: EdgeInsets.symmetric(horizontal: 24.px)),
          SizedBox(
            height: 10.px + ABScreen.bottomHeight,
          ),
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

  /*检查密码*/
  bool _checkOriginalPassword() {
    // 密码要求8-20位，由数字、字母组成
    if (_originalPassword.length < 8 || _originalPassword.length > 20) {
      return false;
    }
    if (!_originalPassword.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
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
}

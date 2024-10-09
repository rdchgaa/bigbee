import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/error_pop_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../net/user_net.dart';
import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/ab_loading.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_screen.dart';
import '../../utils/ab_toast.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text.dart';
import '../../widget/ab_text_field.dart';

/// 重置密码
class ResetPasswordPage extends StatefulWidget {
  final String mnemonic;
  const ResetPasswordPage({super.key, required this.mnemonic});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  // 密码
  String _password = "";
  // 确认密码
  String _confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      backgroundColor: theme.backgroundColorWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: ABScreen.statusHeight,
          ),
          // 顶部导航栏
          Row(
            children: [
              // 返回按钮
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
              ),
              // 中间标题
              ABText(AB_getS(context).resetPassword, textColor: theme.black, fontSize: 24.px, fontWeight: FontWeight.w600,).center.expanded(),
              SizedBox(width: 24.0 + 16.px,)
            ],
          ),
          ListView(
            children: [
              SizedBox(height: 70.px,),
              // 密码输入框
              _getInputWidget(ABAssets.loginPasswordIcon(context, isSelect: _checkPassword()), ABTextField(
                text: _password,
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
            _requestResetPassword();

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

  bool _checkConfirmPassword() {
    if (_password != _confirmPassword || _confirmPassword.isEmpty) {
      return false;
    }
    return true;
  }

  void _requestResetPassword() async {
    if (!_checkPassword()) {
      // // 跳转
      // ErrorPopWidget.show(title: AB_getS(context, listen: false).resetPassword, content: AB_getS(context, listen: false).passwordTip, buttonText: AB_getS(context, listen: false).confirm, onPressed: () {
      // });
      ABToast.show(AB_getS(context, listen: false).passwordTip);
      return;
    }
    if (!_checkConfirmPassword()) {
      ABToast.show(AB_getS(context, listen: false).confirmPasswordError);
      return;
    }
    ABLoading.show();
    final result = await UserNet.resetPassword(uuid: widget.mnemonic, password: _password);
    await ABLoading.dismiss();
    if (result.data != null) {
      ABRoute.popToRoot();
    }
  }

}

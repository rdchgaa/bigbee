import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/account_security/reset_password_page.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_screen.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text.dart';

class MnemonicInputPage extends StatefulWidget {
  const MnemonicInputPage({super.key});

  @override
  State<MnemonicInputPage> createState() => _MnemonicInputPageState();
}

class _MnemonicInputPageState extends State<MnemonicInputPage> {

  String _mnemonic = "";


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
              ABText(AB_getS(context).mnemonicFindAccount, textColor: theme.black, fontSize: 24.px, fontWeight: FontWeight.w600,).center.expanded(),
              SizedBox(width: 24.0 + 16.px,)
            ],
          ),
          ListView(
            children: [
              SizedBox(height: 70.px,),
              ABText(AB_getS(context).inputMnemonic, textColor: theme.textGrey,).center,
              Container(
                height: 200.px,
                padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 10.px),
                decoration: BoxDecoration(
                  color: theme.inputFillColor,
                  borderRadius: BorderRadius.circular(6.px),
                ),
                child: ABTextField(text: _mnemonic, hintText: AB_getS(context).inputMnemonic, textColor: theme.textColor, textSize: 16.px, maxLines: 150, onChanged: (text){
                  setState(() {
                    _mnemonic = text;
                  });
                },),
              ).addMargin(margin: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px)),
            ],
          ).expanded(),
          SizedBox(height: 10.px,),
          // 下一步按钮
          ABButton.gradientColorButton(text: AB_getS(context).next, textColor: theme.black, fontWeight: FontWeight.w600, colors: [theme.primaryColor, theme.secondaryColor], height: 48.px, cornerRadius: 6.px, onPressed: () {
            _requestCheckMnemonic();
          }).addPadding(padding: EdgeInsets.symmetric(horizontal: 24.px)),
          SizedBox(
            height: 10.px + ABScreen.bottomHeight,
          ),
        ],
      ),
    );
  }

  void _requestCheckMnemonic() async {
    if (_mnemonic.isEmpty) {
      ABToast.show(AB_getS(context, listen: false).inputMnemonic);
      return;
    }
    ABLoading.show();
    final result = await UserNet.checkMnemonicForget(mnemonic: _mnemonic);
    await ABLoading.dismiss();
    if (result.data != null && result.data!.mnemonic != null) {
      ABRoute.push(ResetPasswordPage(mnemonic: result.data!.mnemonic!,));
    }
  }


}

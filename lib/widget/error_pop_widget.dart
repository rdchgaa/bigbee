import 'package:bee_chat/main.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../provider/language_provider.dart';
import 'ab_button.dart';

/// 错误弹窗
class ErrorPopWidget extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback? onPressed;

  const ErrorPopWidget({super.key, this.title = '', this.content = '', this.buttonText = '', this.onPressed});


  static void show({ String title = '', String content = '', String buttonText = '', VoidCallback? onPressed}) {
    SmartDialog.show(
      builder: (_) => ErrorPopWidget(
        title: title,
        content: content,
        buttonText: (buttonText.isEmpty ? AB_getS(MyApp.context, listen: false).completed : buttonText),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      padding: EdgeInsets.only(top: 30.px, bottom: 26.px, left: 30.px, right: 30.px),
      // 圆角
      decoration: BoxDecoration(
        color: theme.white,
        borderRadius: BorderRadius.circular(18.px),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ABAssets.errorIcon(context), width: 64.px, height: 64.px,),
          SizedBox(height: 16.px,),
          // 标题
          FittedBox(child: ABText(title, textColor: theme.black, fontSize: 18, fontWeight: FontWeight.bold,)),
          SizedBox(height: 8.px,),
          // 内容
          ABText(content, textColor: theme.textGrey, fontSize: 16, softWrap: true, maxLines: 8,),
          // 按钮
          ABButton.gradientColorButton(
            text: buttonText,
            textColor: theme.black,
            fontWeight: FontWeight.w600,
            colors: [theme.primaryColor, theme.secondaryColor],
            height: 48.px,
            cornerRadius: 6.px,
            onPressed: (){
              SmartDialog.dismiss();
              onPressed?.call();
            },).addPadding(padding: EdgeInsets.only(top: 16.px)),
        ],
      ),
    ).addPadding(padding: EdgeInsets.symmetric(horizontal: 30.px));
  }
}

import 'package:bee_chat/main.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../provider/language_provider.dart';
import '../provider/theme_provider.dart';
import '../utils/ab_assets.dart';
import 'ab_button.dart';
import 'ab_text.dart';

class AlertPopWidget extends StatelessWidget {
  final String title;
  final String content;
  final String? cancelButtonText;
  final String? confirmedButtonText;
  final bool isShowCancelButton;
  final Function(bool)? onPressed;

  const AlertPopWidget({super.key, this.title = '', this.content = '', this.cancelButtonText, this.confirmedButtonText, this.isShowCancelButton = true, this.onPressed});

  static Future<bool?> show({ String title = '', String content = '', String? cancelButtonText, String? confirmedButtonText, bool isShowCancelButton = true, Function(bool)? onPressed}) {
    return SmartDialog.show(
      builder: (_) => AlertPopWidget(
        title: title,
        content: content,
        cancelButtonText: cancelButtonText,
        confirmedButtonText: confirmedButtonText,
        isShowCancelButton: isShowCancelButton,
        onPressed: onPressed,
      ),
        clickMaskDismiss: false,
        backDismiss: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      padding: EdgeInsets.only(top: 30.px, bottom: 26.px, left: 16.px, right: 16.px),
      // 圆角
      decoration: BoxDecoration(
        color: theme.white,
        borderRadius: BorderRadius.circular(18.px),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 标题
          if (title.isNotEmpty) FittedBox(child: ABText(title, textColor: theme.black, fontSize: 18, fontWeight: FontWeight.bold,)),
          if (title.isNotEmpty) SizedBox(height: 8.px,),
          // 内容
          if (content.isNotEmpty) ABText(content, textColor: theme.textGrey, fontSize: 16, softWrap: true, maxLines: 8, textAlign: TextAlign.center,),
          if (content.isNotEmpty) SizedBox(height: 20.px,),
          // 按钮
          Row(
            children: [
              if (isShowCancelButton) ABButton.gradientColorButton(
                text: cancelButtonText ?? AB_getS(context).cancel,
                textColor: theme.white,
                fontWeight: FontWeight.w600,
                colors: [HexColor("#989897"), HexColor("#989897")],
                height: 48.px,
                cornerRadius: 6.px,
                onPressed: (){
                  SmartDialog.dismiss(result: false);
                  onPressed?.call(false);
                },).expanded(),
              if (isShowCancelButton) SizedBox(width: 10.px,),
              ABButton.gradientColorButton(
                text: confirmedButtonText ?? AB_getS(context).confirm,
                textColor: theme.black,
                fontWeight: FontWeight.w600,
                colors: [theme.primaryColor, theme.secondaryColor],
                height: 48.px,
                cornerRadius: 6.px,
                onPressed: (){
                  SmartDialog.dismiss(result: true);
                  onPressed?.call(true);
                },).expanded(),
            ],
          ),
        ],
      ),
    ).addPadding(padding: EdgeInsets.symmetric(horizontal: 30.px));
  }
}

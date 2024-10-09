import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class TimAlertWidget {
  static show(BuildContext context, String text, TUITheme theme, {Function? onPressed}) {
    final W = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
              decoration: BoxDecoration(
                color: theme.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.black!.withOpacity(0.1),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30,),
                  Text(
                    text,
                    style: TextStyle(color: theme.darkTextColor, fontSize: 16),
                  ),
                  SizedBox(height: 26,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 20),
                      _gradientColorButton(text: TIM_t("取消"), colors: [Colors.grey, Colors.grey], height: 48, width: (W - 110) / 2, cornerRadius: 12, onPressed: () {
                        Navigator.pop(context);
                      }),
                      SizedBox(width: 10),
                      _gradientColorButton(text: TIM_t("确定"), colors: [theme.primaryColor!, theme.secondaryColor!], height: 48, width: (W - 110) / 2, cornerRadius: 12, textColor: theme.textColor, onPressed: () {
                        Navigator.pop(context);
                        onPressed?.call();
                      }),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 20,),
                ],
              )),
        );
      },
    );
  }


  /// 渐变色按钮
  static Widget _gradientColorButton({
    String text = "",
    required List<Color> colors,
    // 渐变开始方向
    AlignmentGeometry begin = Alignment.centerLeft,
    // 渐变结束方向
    AlignmentGeometry end = Alignment.centerRight,
    // 渐变颜色占比
    List<double>? stops,
    Widget? icon,
    Color? textColor,
    FontWeight? fontWeight,
    double? radius,
    double? borderWidth,
    Color? borderColor,
    double? height,
    double? width,
    double? fontSize,
    double? cornerRadius,
    VoidCallback? onPressed,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
          stops: stops,
        ),
        borderRadius: BorderRadius.circular(cornerRadius ?? 6),
        // 边框
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 0,
        ),
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(cornerRadius ?? 6),
        padding: EdgeInsets.zero,
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: icon,
                ),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

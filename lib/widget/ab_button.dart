import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../provider/language_provider.dart';
import 'ab_text.dart';

class ABButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? icon;
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? cornerRadius;
  final double? borderWidth;
  final Color? borderColor;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;

  const ABButton({
    Key? key,
    this.width,
    this.height,
    this.icon,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.cornerRadius,
    this.borderWidth,
    this.borderColor,
    this.onPressed,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
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
        padding: padding ?? EdgeInsets.zero,
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
                text ?? "",
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

  /// 渐变色按钮
  static Widget gradientColorButton({
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
      // width: width ?? double.infinity,
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


  // 文字按钮
  static Widget textButton({
    String text = "",
    Color? textColor,
    FontWeight? fontWeight,
    double? fontSize,
    AlignmentGeometry alignment = Alignment.center,
    double? height,
    double? width,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: alignment,
        color: Colors.transparent,
        height: height,
        width: width ?? double.infinity,
        child: ABText(text, textColor: textColor, fontSize: fontSize, fontWeight: fontWeight,),
      ),
    );
  }

}

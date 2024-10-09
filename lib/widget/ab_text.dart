import 'package:bee_chat/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ABText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;

  /// 文字超出显示方式
  final TextOverflow? overflow;

  /// 是否换行
  final bool softWrap;
  /// 是否换行
  final int? maxLines;
  final TextAlign? textAlign;

  const ABText(
    this.text, {
    super.key,
    this.textColor,
    this.fontSize = 14,
    this.fontWeight,
    this.backgroundColor,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = false,
        this.maxLines,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      softWrap: softWrap,
      textAlign: textAlign,
      maxLines: softWrap ? maxLines : 1,
      style: TextStyle(
        color: textColor??AB_theme(context).textColor,
        fontSize: fontSize,
        backgroundColor: backgroundColor,
        fontWeight: fontWeight,
      ),
    );
  }

  // 自动换行Text
static Widget autoWrapText(String text, {
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    TextOverflow? overflow,
  }) {
  return Text(text, style: TextStyle(fontSize: fontSize, color: textColor, fontWeight: fontWeight),);
}

}

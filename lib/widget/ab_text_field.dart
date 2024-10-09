import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ABTextField extends StatefulWidget {
  final String text;
  final Color? textColor;
  final String? hintText;
  final Color? hintColor;
  final double? textSize;
  final FontWeight? fontWeight;
  final FontWeight? hintFontWeight;
  final bool isPassword;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;

  /// 显示隐藏密码按钮的大小
  final double obscureBtnSize;

  /// 显示隐藏密码按钮Icon的大小
  final double obscureIconSize;
  final TextInputAction? textInputAction;
  /// 输入框内边距
  final EdgeInsetsGeometry? contentPadding;

  final Function(String)? onChanged;
  final ValueChanged<String>? onSubmitted;

  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;

  const ABTextField(
      {super.key,
      this.text = '',
      this.textColor,
      this.hintText = '',
      this.hintColor,
      this.textSize,
        this.fontWeight,
      this.hintFontWeight,
      this.isPassword = false,
      this.keyboardType,
      this.maxLength,
      this.maxLines,
      /// 显示隐藏密码按钮的大小
      this.obscureBtnSize = 40,
      /// 显示隐藏密码按钮Icon的大小
      this.obscureIconSize = 20,
        this.textInputAction,
        this.contentPadding,
        this.onChanged,
        this.onSubmitted, this.textAlign, this.inputFormatters,
      });

  @override
  State<ABTextField> createState() => ABTextFieldState();
}

class ABTextFieldState extends State<ABTextField> {
  bool _obscureText = true;
  final controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = widget.text;
    _obscureText = widget.isPassword;
  }

  void editText(String value) {
    controller.text = value;
    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    bool isDarkMode = brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            textAlign: widget.textAlign??TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            obscureText: _obscureText,
            controller: controller,
            textInputAction: widget.textInputAction,
            onChanged: (text) {
              widget.onChanged?.call(text);
            },
            onSubmitted: (text) {
              widget.onSubmitted?.call(text);
            },
            enabled: true,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            decoration: InputDecoration(
              contentPadding: widget.contentPadding,
              counterText: '',
              hintText: widget.hintText,
              border: const OutlineInputBorder( // 重点
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: const OutlineInputBorder( // 重点
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              disabledBorder: const OutlineInputBorder( // 重点
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: const OutlineInputBorder( // 重点
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
                // border: InputBorder.none,
              ),
              hintStyle: TextStyle(
                  fontSize: 14,
                  color: widget.hintColor ??
                      (isDarkMode ? Colors.grey : Colors.grey)),
              labelStyle: TextStyle(
                  fontSize: widget.textSize ?? 14,
                  fontWeight: widget.hintFontWeight,
                  color: widget.hintColor ??
                      (isDarkMode ? Colors.grey : Colors.grey)),
            ),
            style: TextStyle(
              fontSize: widget.textSize,
              fontWeight: widget.fontWeight,
              color: widget.textColor ??
                  (isDarkMode ? Colors.white : Colors.black),
            ),
            inputFormatters: widget.inputFormatters,
          ),
        ),
        !widget.isPassword
            ? Container()
            : SizedBox(
                width: widget.obscureBtnSize,
                height: widget.obscureBtnSize,
                child: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: _obscureText
                        ? (widget.textColor ??
                            (isDarkMode ? Colors.white : Colors.black))
                        : widget.hintColor ?? Colors.grey,
                    size: widget.obscureIconSize,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
      ],
    );
  }
}

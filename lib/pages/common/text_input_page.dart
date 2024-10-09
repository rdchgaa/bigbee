
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';

class TextInputPage extends StatefulWidget {

  final String? title;
  final String? placeholder;
  final String? text;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  // 提示文本，会显示在输入框下方
  final String? hintText;


  const TextInputPage({super.key, this.title, this.placeholder, this.text, this.maxLength, this.keyboardType, this.maxLines, this.hintText});

  @override
  State<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {

  TextEditingController controller = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    controller.text = widget.text ?? "";
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: widget.title ?? "输入",
      ),
      body: Container(
        color: theme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: controller,
                onChanged: (text){},
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                keyboardType: widget.keyboardType,
                autofocus: false, ///  自动获取焦点
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textColor,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16, bottom: 6),
                  hintText: widget.placeholder ?? "请输入",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: theme.textGrey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            if(widget.hintText != null) Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: ABText(widget.hintText ?? "", textColor: Colors.orange, fontSize: 12),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: (){
                if (controller.text.isEmpty) {
                  ABToast.show("请输入内容");
                  return;
                }
                ABRoute.pop(context: context, result: controller.text);
              },
              child: ABButton.gradientColorButton(
                text: AB_getS(context).confirm,
                colors: [theme.primaryColor, theme.secondaryColor],
                textColor: theme.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 48,
              ).addPadding(padding: EdgeInsets.symmetric(horizontal: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

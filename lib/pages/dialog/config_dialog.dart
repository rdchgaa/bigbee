import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfigDialog(
  BuildContext context, {
  String? title,
  String? content,
  Widget? contentWidget,
  String? buttonOk,
  String? buttonCancel,
  TextAlign contentAlign = TextAlign.center,
}) {
  return showModalBottomSheet<bool?>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DialogConfigrBox(
        title: title,
        content: content,
        contentWidget: contentWidget,
        buttonOk: buttonOk,
        buttonCancel: buttonCancel,
        contentAlign: contentAlign,
      );
    },
  );
}

class DialogConfigrBox extends StatefulWidget {
  final String? title;
  final String? content;
  final Widget? contentWidget;
  final String? buttonOk;
  final String? buttonCancel;
  final TextAlign contentAlign;

  const DialogConfigrBox({
    Key? key,
    this.title,
    this.content,
    this.buttonOk,
    this.buttonCancel,
    required this.contentAlign,
    this.contentWidget,
  }) : super(key: key);

  @override
  _DialogConfigrBoxState createState() => _DialogConfigrBoxState();
}

class _DialogConfigrBoxState extends State<DialogConfigrBox> {
  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12.px)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.px, top: 15.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.title != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.px),
                      child: ABText(
                        widget.title ?? '',
                        textColor: theme.textColor,
                        fontSize: 16.px,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  SizedBox(
                    height: 5.px,
                  ),
                  if (widget.content != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.px),
                      child: ABText(
                        widget.content ?? '',
                        textColor: theme.textColor,
                        fontSize: 14.px,
                      ),
                    ),
                  ColoredBox(
                    color: theme.f4f4f4,
                    child: SizedBox(
                      width: double.infinity,
                      height: 1.px,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.px,
                      child: Center(
                          child: ABText(AB_S().confirm,
                              fontSize: 16.px, textColor: theme.textColor, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  ColoredBox(
                    color: theme.f4f4f4,
                    child: SizedBox(
                      width: double.infinity,
                      height: 10.px,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.px,
                      child: Center(
                          child: ABText(AB_S().cancel,
                              fontSize: 16.px, textColor: theme.textColor, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

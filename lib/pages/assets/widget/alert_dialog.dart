import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';


Future showAlertDialog(
    BuildContext context, {
      String? title,
      String? content,
      Widget? contentWidget,
      String? buttonOk,
      String? buttonCancel,
      TextAlign contentAlign = TextAlign.center,
    }) {
  return showDialog(
    context: context,
    builder: (context) {
      return DialogAlertBox(
        title: title,
        content: content,
        contentWidget:contentWidget,
        buttonOk: buttonOk,
        buttonCancel: buttonCancel,
        contentAlign: contentAlign,
      );
    },
  );
}

class DialogAlertBox extends StatefulWidget {
  final String? title;
  final String? content;
  final Widget? contentWidget;
  final String? buttonOk;
  final String? buttonCancel;
  final TextAlign contentAlign;

  const DialogAlertBox({
    Key? key,
    this.title,
    this.content,
    this.buttonOk,
    this.buttonCancel,
    required this.contentAlign, this.contentWidget,
  }) : super(key: key);

  @override
  _DialogAlertBoxState createState() => _DialogAlertBoxState();
}

class _DialogAlertBoxState extends State<DialogAlertBox> {
  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Align(
      alignment: const Alignment(0, -0.3),
      child: Padding(
        padding: EdgeInsets.only(left: 16.px,right: 16.px),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Padding(
            padding: EdgeInsets.only(left: 16.px,right: 16.px,bottom: 16.px,top: 30.px),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.px,right: 16.px),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (null != widget.title)
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.px),
                          child:ABText(
                            widget.title??'',
                            textColor: theme.textColor,
                            fontSize: 18.px,
                          ),
                          // child: Text(
                          //   widget.title??'',
                          // ),
                        ),
                      if (null != widget.content)Text(
                        widget.content??'',
                        textAlign: widget.contentAlign,
                        style: TextStyle(
                          color: theme.textColor.withOpacity(0.8),
                          fontSize: 15.px,
                        ),
                      ),
                      widget.contentWidget??SizedBox(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.px),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (null != widget.buttonCancel)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop(false);
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: theme.text999,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: SizedBox(
                              width: 126.px,
                              height: 48.px,
                              child: ABText(
                                widget.buttonCancel??'',
                                textColor: theme.white,
                                fontSize: 15.px,
                                fontWeight: FontWeight.w600,
                              ).center,
                            ),
                          ),
                        ),
                      if (null != widget.buttonCancel && null != widget.buttonOk) SizedBox(width: 11.px),
                      if (null != widget.buttonOk)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop(true);
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: theme.text999,
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                colors: [theme.primaryColor,theme.secondaryColor],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: SizedBox(
                              width: (null != widget.buttonCancel)?126.px:255.px,
                              height: 48.px,
                              child: ABText(
                                widget.buttonOk??'',
                                textColor: theme.black,
                                fontSize: 15.px,
                                fontWeight: FontWeight.w600,
                              ).center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
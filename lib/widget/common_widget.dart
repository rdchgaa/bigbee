// switch row
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// switch row
Widget getSwitchRowWidget(BuildContext context,
    {required String title, required bool value, String? tips, bool isLast = false, Function(bool)? onSwitchChange}) {
  final theme = AB_theme(context);
  return ColoredBox(
    color: theme.white,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.px, bottom: 10.px),
          child: SizedBox(
            width: double.infinity,
            // height: 56,
            child: Padding(
              padding: EdgeInsets.only(left: 16.px, right: 16.px),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(title,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: theme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 5.px),
                        child: CupertinoSwitch(
                          value: value,
                          onChanged: (value) {
                            onSwitchChange?.call(value);
                          },
                          activeColor: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  if (tips != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(tips,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: theme.text999,
                            fontSize: 12,
                          )),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: theme.backgroundColor,
          ).addPadding(padding: const EdgeInsets.only(left: 16, right: 16)),
      ],
    ),
  );
}

/// button item
Widget setButtonItem(BuildContext context,
    {String? assets,
    String? title,
    Function? onTap,
    String? tips,
    String? rightText,
    Widget? rightWidget,
    bool? showRightIcon = true,
    bool showLine = true}) {
  final theme = AB_theme(context);
  return InkWell(
    onTap: () {
      onTap == null ? null : onTap();
    },
    child: SizedBox(
      child: ColoredBox(
        color: theme.backgroundColorWhite,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12.px, bottom: 12.px, left: 16.px, right: 16.px),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            assets == null
                                ? SizedBox(width: 0.px)
                                : Padding(
                                    padding: EdgeInsets.only(right: 12.px),
                                    child: SizedBox(
                                      width: 24.px,
                                      height: 24.px,
                                      child: Image.asset(
                                        assets,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            ABText(
                              title ?? '',
                              fontSize: 16.px,
                              textColor: theme.textColor,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //13.68+4.1+7.8=25.58
                              if (rightText != null)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16.0.px),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ABText(
                                        rightText,
                                        fontSize: 14,
                                        textColor: theme.text999,
                                      ),
                                    ),
                                  ),
                                ),
                              if (rightWidget != null)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16.0.px),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: rightWidget,
                                    ),
                                  ),
                                ),
                              if (showRightIcon == true)
                                Padding(
                                  padding: EdgeInsets.only(left: 5.px),
                                  child: SizedBox(
                                    width: 9.px,
                                    height: 15.px,
                                    child: Image.asset(
                                      ABAssets.assetsRight(context),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                    if (tips != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8.px),
                        child: Text(tips,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: theme.text999,
                              fontSize: 12,
                            )),
                      ),
                  ],
                ),
              ),
            ),
            if (showLine)
              Padding(
                padding: EdgeInsets.only(left: 10.0.px),
                child: Divider(
                  height: 1,
                  color: theme.backgroundColor,
                ),
              )
          ],
        ),
      ),
    ),
  );
}

/// 单选
Widget getSingleChoiceRowWidget(BuildContext context,
    {required String title, required bool value, String? tips, bool isLast = false, Function? onTap}) {
  final theme = AB_theme(context);
  return ColoredBox(
    color: theme.white,
    child: InkWell(
      onTap: () {
        onTap == null ? null : onTap();
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.px, bottom: 14.px),
            child: SizedBox(
              width: double.infinity,
              // height: 56,
              child: Padding(
                padding: EdgeInsets.only(left: 16.px, right: 16.px),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: theme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                        if (tips != null)
                          Padding(
                            padding: EdgeInsets.only(top: 4.px),
                            child: Text(tips,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: theme.text999,
                                  fontSize: 12,
                                )),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.px),
                      child: Image.asset(
                        value ? ABAssets.assetsSelect(context) : ABAssets.assetsUnSelect(context),
                        width: 24.px,
                        height: 24.px,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              color: theme.backgroundColor,
            ).addPadding(padding: const EdgeInsets.only(left: 16, right: 16)),
        ],
      ),
    ),
  );
}

// 线性功能框
Widget lineButtonItem(BuildContext context, String title,
    {required Widget child, Function? onTap, bool showLine = true}) {
  final theme = AB_theme(context);
  return InkWell(
    onTap: () {
      onTap == null ? null : onTap();
    },
    child: SizedBox(
      child: ColoredBox(
        color: theme.white,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56.px,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.0.px),
                    child: ABText(
                      title,
                      fontSize: 14.px,
                      textColor: theme.textColor,
                    ),
                  ),
                  child
                ],
              ),
            ),
            showLine
                ? Padding(
                    padding: EdgeInsets.only(left: 16.0.px, right: 16.0.px),
                    child: Divider(
                      height: 1,
                      color: theme.grey.withOpacity(0.3),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    ),
  );
}

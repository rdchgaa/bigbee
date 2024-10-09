import 'dart:math';

import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:photo_browser/photo_browser.dart';

class ABToast {
  static Future<void> show(
    String msg, {
    ToastType? toastType = ToastType.defaultType,
  }) {
    return SmartDialog.showToast(
      '',
      displayType: SmartToastType.onlyRefresh,
      builder: (_) => CustomToast(
        msg,
        toastType: toastType,
      ),
    );
  }
}

class CustomToast extends StatelessWidget {
  const CustomToast(this.msg, {Key? key, this.toastType}) : super(key: key);

  final String msg;

  final ToastType? toastType;

  @override
  Widget build(BuildContext context) {
    if (toastType == ToastType.success || toastType == ToastType.fail) {
      return successFailBuild(context);
    } else {
      return defaultBuild(context);
    }
  }

  successFailBuild(BuildContext context) {
    final theme = AB_theme(context);
    return Align(
      alignment: Alignment.center,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.white,
          borderRadius: BorderRadius.circular(12),
          // 阴影
          boxShadow: [
            BoxShadow(
              color: theme.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: SizedBox(
          width: 201,
          height: 142,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                toastType == ToastType.success
                    ? Center(
                        child: Image.asset(ABAssets.toastSuccess(context),
                            width: 43, height: 43, color: theme.primaryColor))
                    : Center(child: Image.asset(ABAssets.toastFail(context), width: 43, height: 43)),
                const SizedBox(height: 16),
                ABText(
                  msg,
                  textAlign: TextAlign.center,
                  fontSize: 18,
                  textColor: theme.black,
                  softWrap: true,
                  maxLines: 3,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    ).addMargin(margin: const EdgeInsets.only(bottom: 100, top: 100));
  }

  defaultBuild(BuildContext context) {
    final theme = AB_theme(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 100,
          minHeight: 20,
          maxWidth: ABScreen.width - 80,
          maxHeight: 200,
        ),
        child: Container(
          // alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: theme.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            // 阴影
            boxShadow: [
              BoxShadow(
                color: theme.white.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ABText(msg,
              textAlign: TextAlign.center, fontSize: 13, textColor: theme.white, softWrap: true, maxLines: 3),
        ),
      ),
    ).addMargin(margin: const EdgeInsets.only(bottom: 100, top: 100));
  }
}

enum ToastType {
  defaultType,
  success,
  fail,
}

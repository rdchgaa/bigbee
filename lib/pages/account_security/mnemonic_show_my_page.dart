import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/common_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/account_security/widget/mnemonic_show_widget.dart';
import 'package:bee_chat/pages/assets/widget/input_google_code_dialog.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_screen.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text.dart';
import 'mnemonic_sure_page.dart';

class MnemonicShowMyPage extends StatefulWidget {
  final bool isShowBackBtn;

  // 是否可以跳过
  final bool isCanSkip;

  // final Function()? onSuccessCallBack;
  const MnemonicShowMyPage({super.key, this.isShowBackBtn = true, this.isCanSkip = true});

  @override
  State<MnemonicShowMyPage> createState() => _MnemonicShowMyPageState();
}

class _MnemonicShowMyPageState extends State<MnemonicShowMyPage> {
  String _mnemonic = "";

  List<String> get _mnemonicList {
    print("助记词列表 - ${_mnemonic.split(" ")}");
    if (_mnemonic.isEmpty) {
      return [];
    }
    return _mnemonic.split(" ");
  }

  bool showThis = false;

  @override
  void initState() {
    _mnemonic = "";
    _requestMnemonic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return PopScope(
      canPop: widget.isShowBackBtn,
      child: Scaffold(
        backgroundColor: theme.backgroundColorWhite,
        // appBar: ABAppBar(title: "123"),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ABScreen.statusHeight,
            ),
            // 顶部导航栏
            Row(
              children: [
                // 返回按钮
                Container(
                  width: 24.0 + 16.px,
                  height: 44.0,
                  color: Colors.transparent,
                  // 返回按钮
                  child: widget.isShowBackBtn
                      ? IconButton(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            final isBack = await Navigator.maybePop(context);
                            if (!isBack) {
                              ABRoute.pop();
                            }
                          },
                          padding: EdgeInsets.only(left: 16.px),
                          icon: Icon(
                            CupertinoIcons.arrow_left,
                            color: theme.black,
                          ),
                        )
                      : const SizedBox(),
                ),
                // 中间标题
                ABText(
                  AB_getS(context).mnemonic,
                  textColor: theme.black,
                  fontSize: 24.px,
                  fontWeight: FontWeight.w600,
                ).center.expanded(),
                SizedBox(
                  width: 24.0 + 16.px,
                )
              ],
            ),
            SizedBox(
              height: 64.px,
            ),
            if(!showThis)Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(ABAssets.toastSuccess(context),
                    width: 43.px, height: 43.px, color: theme.primaryColor),
                const SizedBox(height: 16),
                ABText(
                  AB_getS(context).verified,
                  textAlign: TextAlign.center,
                  fontSize: 18,
                  textColor: theme.black,
                  softWrap: true,
                  maxLines: 3,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            if(showThis)ABText(
              AB_getS(context).mnemonicTip,
              textColor: theme.textGrey,
              maxLines: 2,
              softWrap: true,
              fontSize: 12.px,
            ).center.addPadding(padding: EdgeInsets.symmetric(horizontal: 16.px)),
            if(showThis)Container(
              height: 204.px,
              padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 20.px),
              decoration: BoxDecoration(
                color: theme.inputFillColor,
                borderRadius: BorderRadius.circular(6.px),
              ),
              child: _memmonicListWidget(),
            ).addMargin(margin: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px)),
            Container().expanded(),
            SizedBox(
              height: 10.px,
            ),
            // 复制按钮
            // CupertinoButton(
            //   padding: EdgeInsets.zero,
            //   onPressed: () async {
            //     if (_mnemonic.isNotEmpty) {
            //       var value = await showGoogleCodeDialog(
            //         context,
            //       );
            //       if (value != null) {
            //         Clipboard.setData(ClipboardData(text: _mnemonic));
            //         ABToast.show(AB_getS(context, listen: false).copyToClipboardSuccess);
            //       }
            //       // Clipboard.setData(ClipboardData(text: _mnemonic));
            //       // ABToast.show(AB_getS(context, listen: false).copyToClipboardSuccess);
            //     }
            //   },
            //   child: ABText(AB_getS(context).copyToClipboard, textColor: theme.secondaryColor, fontSize: 14.px),
            // ),
            SizedBox(
              height: 10.px,
            ),
            // 下一步按钮
            ABButton.gradientColorButton(
                text: showThis?AB_getS(context).copyToClipboard:AB_getS(context).export,
                textColor: theme.black,
                fontWeight: FontWeight.w600,
                colors: [theme.primaryColor, theme.secondaryColor],
                height: 48.px,
                cornerRadius: 6.px,
                onPressed: () async{
                  if (_mnemonic.isNotEmpty) {
                    if(showThis){
                      Clipboard.setData(ClipboardData(text: _mnemonic));
                      ABToast.show(AB_getS(context, listen: false).copyToClipboardSuccess,toastType: ToastType.success);
                    }else{
                      var value = await showGoogleCodeDialog(
                        context,
                      );
                      if (value != null) {
                        var result = await CommonNet.codeCheckSuccessCode(code: value);
                        if (result.success == true) {
                          // Clipboard.setData(ClipboardData(text: _mnemonic));
                          // ABToast.show(AB_getS(context, listen: false).copyToClipboardSuccess,toastType: ToastType.success);
                          showThis = true;
                          setState(() {
                          });
                        } else {
                          ABToast.show(result.message ?? '',toastType: ToastType.fail);
                        }
                      }
                    }
                    // Clipboard.setData(ClipboardData(text: _mnemonic));
                    // ABToast.show(AB_getS(context, listen: false).copyToClipboardSuccess);
                  }
                }).addPadding(padding: EdgeInsets.symmetric(horizontal: 24.px)),
            SizedBox(
              height: 20.px + ABScreen.bottomHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _memmonicListWidget() {
    final ratio = (ABScreen.width - 64.px - 24.px) / 3 / 32.px;
    return MnemonicShowWidget(
      mnemonicList: _mnemonicList,
      itemRatio: ratio,
    );
  }

  void _requestMnemonic() async {
    final result = await UserNet.userGetBindMemberMnemonicPhrase();
    if (result.data != null && result.data!.mnemonic != null && result.data!.mnemonic!.isNotEmpty) {
      setState(() {
        _mnemonic = result.data!.mnemonic!;
      });
    } else {
      ABToast.show(result.error?.message ?? "助记词获取失败!");
    }
  }
}

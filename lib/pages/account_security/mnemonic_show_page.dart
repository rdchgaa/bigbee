import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/account_security/widget/mnemonic_show_widget.dart';
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

class MnemonicShowPage extends StatefulWidget {
  final bool isShowBackBtn;
  // 是否可以跳过
  final bool isCanSkip;
  // final Function()? onSuccessCallBack;
  const MnemonicShowPage({super.key, this.isShowBackBtn = true, this.isCanSkip = true});

  @override
  State<MnemonicShowPage> createState() => _MnemonicShowPageState();
}

class _MnemonicShowPageState extends State<MnemonicShowPage> {

  String _mnemonic = "";
  List<String> get _mnemonicList {
    print("助记词列表 - ${_mnemonic.split(" ")}");
    if (_mnemonic.isEmpty) {
      return [];
    }
    return _mnemonic.split(" ");
  }

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
                  child: widget.isShowBackBtn ? IconButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final isBack = await Navigator.maybePop(context);
                      if (!isBack) {
                        ABRoute.pop();
                      }
                    },
                    padding: EdgeInsets.only(left: 16.px),
                    icon: Icon(CupertinoIcons.arrow_left, color: theme.black,),
                  ) : const SizedBox(),
                ),
                // 中间标题
                ABText(AB_getS(context).mnemonic, textColor: theme.black, fontSize: 24.px, fontWeight: FontWeight.w600,).center.expanded(),
                SizedBox(width: 24.0 + 16.px,)
              ],
            ),
            SizedBox(height: 64.px,),
            ABText(AB_getS(context).mnemonicTip, textColor: theme.textGrey, maxLines: 2, softWrap: true, fontSize: 12.px,).center.addPadding(padding: EdgeInsets.symmetric(horizontal: 16.px)),
            Container(
              height: 204.px,
              padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 20.px),
              decoration: BoxDecoration(
                color: theme.inputFillColor,
                borderRadius: BorderRadius.circular(6.px),
              ),
              child: _memmonicListWidget(),
            ).addMargin(margin: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px)),
            Container().expanded(),
            SizedBox(height: 10.px,),
            // 复制按钮
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (_mnemonic.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: _mnemonic));
                  ABToast.show(AB_getS(context, listen: false).copyToClipboardSuccess);
                }
              },
              child: ABText(AB_getS(context).copyToClipboard, textColor: theme.secondaryColor, fontSize: 14.px),
            ),
            SizedBox(height: 10.px,),
            // 下一步按钮
            ABButton.gradientColorButton(text: AB_getS(context).next, textColor: theme.black, fontWeight: FontWeight.w600, colors: [theme.primaryColor, theme.secondaryColor], height: 48.px, cornerRadius: 6.px, onPressed: () {
              ABRoute.push(MnemonicSurePage(mnemonic: _mnemonic, isCanSkip: widget.isCanSkip));
            }).addPadding(padding: EdgeInsets.symmetric(horizontal: 24.px)),
            SizedBox(
              height: 10.px + ABScreen.bottomHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _memmonicListWidget() {
    final ratio = (ABScreen.width - 64.px - 24.px) / 3 / 32.px;
    return MnemonicShowWidget(mnemonicList: _mnemonicList, itemRatio: ratio,);
  }

  void _requestMnemonic() async {
    final result = await UserNet.getMnemonic();
    if (result.data != null && result.data!.mnemonic != null && result.data!.mnemonic!.isNotEmpty) {
      setState(() {
        _mnemonic = result.data!.mnemonic!;
      });
    } else {
      ABToast.show(result.error?.message ?? "助记词获取失败!");
    }
  }

}

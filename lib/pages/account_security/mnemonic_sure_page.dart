import 'dart:math';

import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/account_security/widget/mnemonic_show_widget.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/alert_pop_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_screen.dart';
import '../../utils/ab_toast.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text.dart';

class MnemonicSurePage extends StatefulWidget {
  final String mnemonic;
  // 是否可以跳过
  final bool isCanSkip;
  const MnemonicSurePage({super.key, required this.mnemonic, this.isCanSkip = true});

  @override
  State<MnemonicSurePage> createState() => _MnemonicSurePageState();
}

class _MnemonicSurePageState extends State<MnemonicSurePage> {
  List<String> _randomMnemonicList  = [];
  List<String> _mnemonicList = [];

  @override
  void initState() {
    List<String> randomMnemonicList = widget.mnemonic.split(" ");
    randomMnemonicList.shuffle(Random());
    _randomMnemonicList = randomMnemonicList;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
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
                child: IconButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final isBack = await Navigator.maybePop(context);
                    if (!isBack) {
                      ABRoute.pop();
                    }
                  },
                  padding: EdgeInsets.only(left: 16.px),
                  icon: Icon(CupertinoIcons.arrow_left, color: theme.black,),
                ),
              ),
              SizedBox(width: 20.px,),
              // 中间标题
              ABText(AB_getS(context).mnemonic, textColor: theme.black, fontSize: 24.px, fontWeight: FontWeight.w600,).center.expanded(),
              Container(
                width: 24.0 + 36.px,
                child: widget.isCanSkip ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    // ABRoute.popToRoot();
                    AlertPopWidget.show(title: AB_S().tip, content: AB_S().mnemonicTip2, onPressed: (isConfirmed) async {
                      if (isConfirmed) {
                        ABRoute.popToRouteName("MnemonicShowPage");
                        ABRoute.pop();
                      }
                    });
                  },
                  child: ABText(AB_getS(context).skip, textColor: theme.textGrey, fontSize: 14.px),
                ) : const SizedBox(),
              )
            ],
          ),
          ListView(
            children: [
              SizedBox(height: 64.px,),
              ABText(AB_getS(context).mnemonicTip1, textColor: theme.textGrey,).center,
              Container(
                height: 204.px,
                padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 20.px),
                decoration: BoxDecoration(
                  color: theme.inputFillColor,
                  borderRadius: BorderRadius.circular(6.px),
                ),
                child: _mnemonicListWidget(),
              ).addMargin(margin: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px)),
              SizedBox(height: 40.px,),
              _randomMnemonicListWidget().addMargin(margin: EdgeInsets.only(left: 24.px, right: 24.px)),
            ],
          ).expanded(),
          SizedBox(height: 10.px,),
          // 立即体验按钮
          ABButton.gradientColorButton(text: AB_getS(context).experienceNow, textColor: theme.black, fontWeight: FontWeight.w600, colors: [theme.primaryColor, theme.secondaryColor], height: 48.px, cornerRadius: 6.px, onPressed: () {
            _checkMnemonic();
          }).addPadding(padding: EdgeInsets.symmetric(horizontal: 24.px)),
          SizedBox(
            height: 10.px + ABScreen.bottomHeight,
          ),
        ],
      ),
    );
  }

  Widget _mnemonicListWidget() {
    final ratio = (ABScreen.width - 64.px - 24.px) / 3 / 32.px;
    return MnemonicShowWidget(mnemonicList: _mnemonicList, itemRatio: ratio,);
  }

  Widget _randomMnemonicListWidget() {
    final ratio = (ABScreen.width - 48.px - 60.px) / 3 / 34.px;
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 30.px, // 水平间距
        mainAxisSpacing: 10.px, // 垂直间距
        childAspectRatio: ratio,
      ),
      // 设置宫格子部件
      itemBuilder: (context, index) {
        return _randomMnemonicListItemWidget(_randomMnemonicList[index], isSelected: _mnemonicList.contains(_randomMnemonicList[index]), onTap: () {
          if (_mnemonicList.contains(_randomMnemonicList[index])) {
            _mnemonicList.remove(_randomMnemonicList[index]);
          } else {
            _mnemonicList.add(_randomMnemonicList[index]);
          }
          setState(() {
          });
        });
      },
      itemCount: _randomMnemonicList.length, // 宫格数量
    );
  }

  Widget _randomMnemonicListItemWidget(String text, {bool isSelected = false, Function()? onTap}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: (){
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.only(left: 4.px, right: 10.px, top: 4.px, bottom: 4.px),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor.withOpacity(0.5) : theme.primaryColor,
          borderRadius: BorderRadius.circular(10000.px),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 4.px,),
            FittedBox(
              alignment: Alignment.center,
              child: ABText(text, textColor: theme.textColor, fontSize: 16.px, textAlign: TextAlign.left,),
            ).expanded(),
            SizedBox(width: 4.px,),
          ],
        ),
      ),
    );
  }

  void _checkMnemonic() async {
    if (_mnemonicList.length != 12) {
      ABToast.show(AB_getS(context, listen: false).mnemonicTip1);
      return;
    }
    final mnemonic = _mnemonicList.join(" ");
    ABLoading.show();
    final result = await UserNet.checkMnemonic(mnemonic: mnemonic);
    await ABLoading.dismiss();
    if (result.data != null) {
      ABRoute.popToRoot();
    }
  }


}

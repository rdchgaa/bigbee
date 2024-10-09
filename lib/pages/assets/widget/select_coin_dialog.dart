import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';


Future showSelectCoinDialog(
    BuildContext context, {
      String? title,
      String? content,
      Widget? contentWidget,
      String? buttonOk,
      String? buttonCancel,
      TextAlign contentAlign = TextAlign.center,
      required List<CoinModel> coinList,
    }) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DialogAlertBox(
        title: title,
        content: content,
        contentWidget:contentWidget,
        buttonOk: buttonOk,
        buttonCancel: buttonCancel,
        contentAlign: contentAlign,
          coinList:coinList
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
  final List<CoinModel> coinList;

  const DialogAlertBox({
    Key? key,
    this.title,
    this.content,
    this.buttonOk,
    this.buttonCancel,
    required this.contentAlign, this.contentWidget, required this.coinList,
  }) : super(key: key);

  @override
  _DialogAlertBoxState createState() => _DialogAlertBoxState();
}

class _DialogAlertBoxState extends State<DialogAlertBox> {
  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Material(
      color: theme.white,
      borderRadius: BorderRadius.all(Radius.circular(12.px)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.px,top: 15.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.px),
                    child:ABText(
                      AB_S().pleaseSelect,
                      textColor: theme.textColor,
                      fontSize: 18.px,
                    ),
                  ),
                  coinListWidget(),
                  ColoredBox(color: theme.f4f4f4,child: SizedBox(width: double.infinity,height: 10.px,),),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.px,
                      child: Center(child: ABText(AB_S().cancel, fontSize: 16.px,textColor: theme.textColor,)),
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

  Widget coinListWidget() {
    final theme = AB_theme(context);
    List<Widget> coinListBuild = [];
    for (var i = 0; i < widget.coinList.length; i++) {
      CoinModel item = widget.coinList[i];
      coinListBuild.add(InkWell(
        onTap: (){
          Navigator.of(context).pop(widget.coinList[i]);
        },
        child: SizedBox(
          width: double.infinity,
          height: 56.px,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.0.px, right: 12.px),
                    child: SizedBox(
                      width: 20.px,
                      height: 20.px,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: ABImage.imageWithUrl(
                              // 'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png',
                              item.url ?? "",
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                  ABText(item.coinName ?? "", fontSize: 16.px,textColor: theme.textColor,),
                ],
              ),
              Divider(color: theme.f4f4f4,height: 1,)
            ],
          ),
        ),
      ));
    }
    return Column(
      children: coinListBuild,
    );
  }

}
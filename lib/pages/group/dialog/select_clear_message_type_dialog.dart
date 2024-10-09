import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<ClearMessageType?> showSelectClearMessageTypeDialog(
    BuildContext context, {
      required List<ClearMessageType> list,
    }) {
  return showModalBottomSheet<ClearMessageType?>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DialogAlertClearMessageTypeBox(
          list:list
      );
    },
  );
}

class DialogAlertClearMessageTypeBox extends StatefulWidget {
  final List<ClearMessageType> list;

  const DialogAlertClearMessageTypeBox({
    Key? key,required this.list,
  }) : super(key: key);

  @override
  _DialogAlertClearMessageTypeBoxState createState() => _DialogAlertClearMessageTypeBoxState();
}

class _DialogAlertClearMessageTypeBoxState extends State<DialogAlertClearMessageTypeBox> {
  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);

    return Material(
      color: Colors.white,
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
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 10.px),
                  //   child:ABText(
                  //     AB_S().pleaseSelect,
                  //     textColor: theme.textColor,
                  //     fontSize: 18.px,
                  //   ),
                  // ),
                  SizedBox(height: 5.px,),
                  coinListWidget(),
                  // SizedBox(height: 10.px,),
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
    for (var i = 0; i < widget.list.length; i++) {
      ClearMessageType item = widget.list[i];
      coinListBuild.add(InkWell(
        onTap: (){
          Navigator.of(context).pop(item);
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

                  ABText(item.text, fontSize: 16.px,textColor: theme.textColor,),
                ],
              ),
              Divider(color: theme.f4f4f4,height: 1,)
            ],
          ),
        ),
      ));
    }
    // return SizedBox(
    //   width: double.infinity,
    //   height: MediaQuery.of(context).size.width*0.8,
    //   child: ListView(
    //     children: coinListBuild,
    //   ),
    // );
    return SizedBox(
      width: double.infinity,
      // height: MediaQuery.of(context).size.width*0.8,
      child: Column(
        children: coinListBuild,
      ),
    );
  }

}

class ClearMessageType {
  final int value;
  final String text;

  ClearMessageType({required this.value, required this.text});
}
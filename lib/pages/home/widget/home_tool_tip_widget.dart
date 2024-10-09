import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../provider/theme_provider.dart';

class HomeToolTipWidget extends StatelessWidget {
  final List<HomeToolTipItem> items;
  final Function(int)? onTap;
  const HomeToolTipWidget({super.key, required this.items, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      // width: 150.px,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(6.px),
        boxShadow: [
          BoxShadow(
            color: theme.black.withOpacity(0.1),
            offset: const Offset(0, 0),
            blurRadius: 6.px,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((HomeToolTipItem item){
          return InkWell(
            onTap: (){
              item.onTap?.call();
              onTap?.call(items.indexOf(item));
            },
            child: Container(
              color: Colors.transparent,
              height: 40.px,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  item.icon,
                  SizedBox(width: 12.px,),
                  Flexible(
                    child: Text(item.title, style: TextStyle(fontSize: 14.px, color: theme.textColor, fontWeight: FontWeight.w600),),),
                ],
              ),
            ),
          );
        }).toList(),
      ).addPadding(padding: EdgeInsets.symmetric(vertical: 4.px, horizontal: 14.px)),
    );
  }
}

class HomeToolTipItem {
  String title;
  Widget icon;
  Function()? onTap;
  HomeToolTipItem({required this.title, required this.icon, this.onTap});
}

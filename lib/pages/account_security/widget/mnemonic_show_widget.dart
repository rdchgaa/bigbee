import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

import '../../../provider/theme_provider.dart';
import '../../../widget/ab_text.dart';

class MnemonicShowWidget extends StatelessWidget {

  final List<String> mnemonicList;
  final double itemRatio;

  const MnemonicShowWidget({super.key, this.mnemonicList = const [], this.itemRatio = 1});

  @override
  Widget build(BuildContext context) {
    final dataList = List.from(mnemonicList);
    // 不够12个的用“”填充
    if (mnemonicList.length < 12) {
      for (int i = 0; i < 12 - mnemonicList.length; i++) {
        dataList.add(" ");
      }
    }
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.px, // 水平间距
        mainAxisSpacing: 12.px, // 垂直间距
        childAspectRatio: itemRatio,
      ),
      // 设置宫格子部件
      itemBuilder: (context, index) {
        return _mnemonicItemWidget(index, dataList[index], context);
      },
      itemCount: dataList.length, // 宫格数量
    );
  }

  Widget _mnemonicItemWidget(int index, String text, BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      padding: EdgeInsets.only(left: 4.px, right: 10.px, top: 4.px, bottom: 4.px),
      decoration: BoxDecoration(
        color: theme.white,
        borderRadius: BorderRadius.circular(10000.px),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(10000.px),
              ),
              child: ABText("${index+1}", textColor: theme.white, fontSize: 14.px, fontWeight: FontWeight.w600,).center,
            ),
          ),
          SizedBox(width: 4.px,),
          FittedBox(
            alignment: Alignment.centerLeft,
            child: ABText(text, textColor: theme.textColor, fontSize: 16.px, textAlign: TextAlign.left,),
          ).expanded(),
        ],
      ),
    );
  }
}

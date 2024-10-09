import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';

class MarkFilterWidget extends StatelessWidget {
  final MarkFilterType type;
  final Function(MarkFilterType)? onTypeChanged;
  const MarkFilterWidget({super.key, required this.type, this.onTypeChanged});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      MarkFilterType.optional,
      MarkFilterType.hot,
      MarkFilterType.fall,
      MarkFilterType.rise
    ].map((e){
      return _gettypeWidget(context, e);
    }).toList();

    return LayoutBuilder(builder: (context, constraints){
      return SizedBox(
        height: 36,
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(width: 16,),
            ...items,
            const SizedBox(width: 16,),
          ],
        ),
      );
    });
  }


  Widget _gettypeWidget(BuildContext context, MarkFilterType type) {
    String title = "";
    final S = AB_getS(context);
    final theme = AB_theme(context);
    switch (type) {
      case MarkFilterType.optional:
        title = S.offline;
        break;
      case MarkFilterType.hot:
        title = S.hot;
        break;
      case MarkFilterType.fall:
        title = S.fallList;
        break;
      case MarkFilterType.rise:
        title = S.riseList;
        break;
    }

    return InkWell(
      onTap: (){
        onTypeChanged?.call(type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16,),
        decoration: BoxDecoration(
          color: type == this.type ? theme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ABText(title, textColor: type == this.type ? theme.white : theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,).center,
      ),
    );

  }


}

enum MarkFilterType {
  // 自选
  optional,
  // 热门
  hot,
  // 涨幅榜
  fall,
  // 跌幅榜
  rise,
}

// 排序方式
enum MarkSortType {
  // 默认
  name,
  // 涨幅
  rise,
  // 跌幅
  fall,
}
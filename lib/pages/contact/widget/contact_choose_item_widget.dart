import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactChooseItemWidget extends StatelessWidget {

  final String avatarUrl;
  final String nickName;
  final bool? isSelected;
  final bool? isOnline;
  final String? timeText;
  final bool isLast;
  // 是否显示选择按钮
  final bool isShowSelect;

  const ContactChooseItemWidget({super.key, this.avatarUrl = '', this.nickName = '', this.isSelected, this.isOnline, this.timeText, this.isLast = false, this.isShowSelect = false});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Column(
      children: [
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.transparent,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 16.px),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(37.px),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(37),
                    child: ABImage.avatarUser(avatarUrl),
                  ),
                ),
                SizedBox(width: 14),
                _contentWidget(context).expanded(),
                if(isShowSelect) SizedBox(width: 10,),
                if(isShowSelect) _selectWidget(context),
                SizedBox(width: 16),
              ]
          ),
        ),
        if (!isLast) Container(height: 1, color: theme.f4f4f4,).addPadding(padding: EdgeInsets.symmetric(horizontal: 16)),
      ],
    );
  }

  Widget _selectWidget(BuildContext context){
    if(isSelected == true){
      return Icon(CupertinoIcons.minus_circle, size: 20, color: Colors.red,);
    } else {
      return ABText("+", fontSize: 24, fontWeight: FontWeight.w600, textColor: HexColor("#D9D9D9"),);
    }
  }

  Widget _contentWidget(BuildContext context) {
    final theme = AB_theme(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ABText(nickName, textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.bold,),
        SizedBox(
          height: 24,
          child: Row(
            children: [
              Container(
                // 圆角
                decoration: BoxDecoration(
                  color: (isOnline == true ? HexColor("#00FF47") : HexColor("#989897")),
                  borderRadius: BorderRadius.circular(6),
                ),
                width: 10,
                height: 10,
              ),
              SizedBox(width: 6,),
              ABText(timeText ?? "未知", fontSize: 12, textColor: HexColor("#989897"),),
            ],
          ),
        ),
      ],
    );
  }


}

import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:flutter/material.dart';

import '../../../utils/extensions/color_extensions.dart';
import '../../../widget/ab_text.dart';

class MineVipWidget extends StatelessWidget {
  const MineVipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      height: 95,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        // 渐变背景色
        gradient: LinearGradient(
          colors: [
            HexColor("#FFF5D9"),
            HexColor("#FFDD9C"),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        // 圆角
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ABText("BEE CHAT ${AB_getS(context).vip}", fontSize: 16, fontWeight: FontWeight.bold),
                    const SizedBox(width: 4,),
                    Image.asset(ABAssets.mineVip(context), width: 27, height: 20,),
                  ],
                ),
                const SizedBox(height: 4),
                ABText(AB_getS(context).vipTip, fontSize: 12, textColor: HexColor("#666666")),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 去开通
          SizedBox(
            width: 88,
            child: ABButton.gradientColorButton(
                colors: [theme.primaryColor, theme.secondaryColor],
              text: AB_getS(context).goOpen,
              textColor: Colors.white,
              cornerRadius: 6,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 38,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:bee_chat/models/im/notice_list_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoticeListItem extends StatelessWidget {
  final NoticeListModel model;
  const NoticeListItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      height: 174,
      width: ABScreen.width,
      color: theme.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // 头像 名称 时间
          Container(
            height: 72,
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 头像
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: AssetImage(ABAssets.imSystemIcon(context)),
                      fit: BoxFit.cover
                   )
                  )
                ),
                SizedBox(width: 14,),
                // 名称 时间
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ABText("Beechat官方", textColor: theme.textColor, fontWeight: FontWeight.w600, fontSize: 14,),
                    ABText(model.createTime ?? "", textColor: theme.textGrey, fontSize: 12)
                  ],
                ).expanded(),
                // 右侧点击查看
                Container(
                  width: 64,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: FittedBox(child: ABText(AB_getS(context).clickLook, textColor: theme.textGrey, softWrap: true,),)),
                      Icon(CupertinoIcons.right_chevron, size: 14, color: theme.textGrey,)
                    ],
                  ),
                ),
              ]
            ),
          ),
          Divider(height: 1, color: theme.f4f4f4,).addPadding(padding: EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: 12,),
          // 内容
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 16,),
              // 标题+内容
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4,),
                  ABText(model.title ?? "", textColor: theme.textColor, fontWeight: FontWeight.w500, fontSize: 14,),
                  ABText(model.profile ?? "", textColor: theme.textGrey, fontWeight: FontWeight.w400, fontSize: 14, softWrap: true, maxLines: 2,),
                ],
              ).expanded(),
              const SizedBox(width: 10,),
              // 封面
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                  child: ABImage.imageWithUrl(model.cover ?? "", width: 107, height: 74, fit: BoxFit.cover,)),
              const SizedBox(width: 16,),
            ],
          ),
          // SizedBox(height: 16,),
        ]
      )
    );
  }




}

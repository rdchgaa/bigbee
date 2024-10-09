import 'package:bee_chat/models/user/user_detail_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/ab_toast.dart';

class MineUserInfoWidget extends StatelessWidget {
  final UserDetailModel userInfo;
  final String userId;
  final Function()? onTap;

  const MineUserInfoWidget({super.key, required this.userInfo, required this.userId, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 16,),
            // 头像
            GestureDetector(
              onTap: (){},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: ABImage.avatarUser(userInfo.avatarUrl ?? "", width: 64, height: 64),
              ),
            ),
            const SizedBox(width: 14,),
            // 昵称+Id
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 昵称 + vip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: ABScreen.width - 64 - 32 - 32, minWidth: 10),
                          child: ABText( userInfo.nickName ?? "", textColor: theme.textColor,fontSize: 16, fontWeight: FontWeight.w600, maxLines: 2, softWrap: true,),
                      ),
                      const SizedBox(width: 4,),
                      Image.asset(ABAssets.userVip(context), width: 14, height: 14,).addPadding(padding: const EdgeInsets.only(top: 6)),
                      const SizedBox(width: 16,),
                    ],
                  ),
                  // ID
                  Row(
                    children: [
                      ABText("ID:${userId}", textColor: theme.textGrey,fontSize: 14, fontWeight: FontWeight.w600, maxLines: 1, softWrap: true,),
                      InkWell(
                        onTap: () {
                          if (userId.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: userId));
                            ABToast.show(AB_getS(context, listen: false).copyToClipboardSuccess);
                          }
                        },
                        child: Container(
                          width: 32,
                          height:32,
                          child: Image.asset(ABAssets.shareCopy(context), width: 14, height: 14,).center,
                        ),
                      ),
                    ],
                  ),
                ]
              )
            ),
            InkWell(
              onTap: onTap,
              child: SizedBox(
                width: 80.px,
                height: 50.px,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0.px, right: 8.px),
                      child: SizedBox(
                        width: 20.px,
                        height: 20.px,
                        child: Image.asset(
                          ABAssets.iconErweima(context),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 12.px),
                      child: SizedBox(
                        width: 9.px,
                        height: 15.px,
                        child: Image.asset(
                          ABAssets.assetsRight(context),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16,),
        // 简介
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 16,),
            ABText("${AB_getS(context).introduced}: "),
            ABText( userInfo.profile ?? AB_getS(context).noIntroduction, textColor: theme.textColor,fontSize: 14, fontWeight: FontWeight.normal, maxLines: 6, softWrap: true,).expanded(),
          ],
        ),
      ],
    );
  }
}


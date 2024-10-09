import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';

class AssetsUserItemWidget extends StatelessWidget {
  final String avatarUrl;
  final String nickName;
  final bool onLineStatus;

  const AssetsUserItemWidget({super.key, this.avatarUrl = '', this.nickName = '', required this.onLineStatus});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      height: 74,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ABText(
              nickName,
              textColor: theme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            Row(
              children: [
                DecoratedBox(
                  decoration:
                      BoxDecoration(color: onLineStatus?Color(0xff00FF47):theme.text999, borderRadius: BorderRadius.all(Radius
                          .circular(5))),
                  child: SizedBox(width: 10, height: 10),
                ),
                SizedBox(width: 5,),
                ABText(
                  onLineStatus?AB_S().online:AB_S().offline,
                  textColor: theme.text999,
                  fontSize: 14,
                ),
              ],
            ),
          ],
        ),
        SizedBox().expanded(),
        // ABText('+',fontSize: 25,textColor: theme.text999.withOpacity(0.6),),
        SizedBox(width: 16),
      ]),
    );
  }
}

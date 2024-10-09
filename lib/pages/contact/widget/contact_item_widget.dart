import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';

class ContactItemWidget extends StatelessWidget {
  final String avatarUrl;
  final String nickName;

  const ContactItemWidget({super.key, this.avatarUrl = '', this.nickName = ''});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      height: 60,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 16.px),
          Container(
            width: 50,
            height: 50,
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
          ABText(nickName, textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.bold,).expanded(),
          SizedBox(width: 16),
        ]
      ),
    );
  }
}

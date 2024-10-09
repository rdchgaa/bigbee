import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/im/system_message_model.dart';

class SystemMsgListItem extends StatelessWidget {
  final SystemMessageModel model;
  final Function(bool)? onTap;
  final Function()? deleteCallback;
  const SystemMsgListItem({super.key, required this.model, this.onTap, this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      width: double.infinity,
      height: 127,
      margin: const EdgeInsets.only(bottom: 10),
      color: theme.white,
      child: Column(
        children: [
          // 头像+昵称
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 14, right: 14),
            height: 74,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 头像
                Container(
                  width: 48,
                  height: 48,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                      child: ABImage.avatarUser(model.invitationMemberAvatar ?? "")),
                ),
                const SizedBox(width: 12),
                // 内容
                _richText(context).expanded(),
              ]
            )
          ),
          Divider(height: 1, color: theme.f4f4f4).addPadding(padding: EdgeInsets.only(left: 16, right: 16)),
          SizedBox(height: 10),
          // 时间+ 状态
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(model.createTime ?? "", style: TextStyle(color: theme.textGrey, fontSize: 12, fontWeight: FontWeight.w500)).expanded(),
              ..._buttonWidget(context),
            ]
          ).addPadding(padding: EdgeInsets.only(left: 16, right: 0)),
        ]
      ),
    );
  }

  Widget _richText(BuildContext context) {
    final theme = AB_theme(context);
    List<InlineSpan> children = [];
    children.add(TextSpan(
      text: "${model.invitationMemberName} ",
      style: TextStyle(color: theme.textColor, fontSize: 14, fontWeight: FontWeight.w600),
    ));
    if (model.type == 2) {
      children.add(TextSpan(
        text: "${AB_getS(context).applyJoinGroup}【${model.groupInfoName}】",
        style: TextStyle(color: theme.textGrey, fontSize: 14, fontWeight: FontWeight.w500),
      ));
    } else {
      children.add(TextSpan(
        text: "${AB_getS(context).applyAddFriend} ",
        style: TextStyle(color: theme.textGrey, fontSize: 14, fontWeight: FontWeight.w500),
      ));
    }

    return RichText(
      text: TextSpan(
        children: children,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
    );
  }

  List<Widget> _buttonWidget(BuildContext context) {
    final theme = AB_theme(context);
    Widget deleteBtn = Padding(
      padding: EdgeInsets.only(left: 6),
      child: ABButton(
        // text: AB_getS(context).delete,
        icon: Icon(Icons.delete, color: theme.textGrey, size: 16),
        onPressed: () {
          deleteCallback?.call();
        },
        width: 40,
        height: 36,
        cornerRadius: 6,
        backgroundColor: Colors.transparent,
        textColor: Colors.red,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
    if (model.status == 1) {
      return [
        ABButton(
          text: AB_getS(context).refuse,
          onPressed: () {
            onTap?.call(false);
          },
          width: 64,
          height: 30,
          cornerRadius: 6,
          backgroundColor: theme.grey,
          textColor: theme.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(width: 14),
        ABButton(
          text: AB_getS(context).agree,
          onPressed: () {
            onTap?.call(true);
          },
          width: 64,
          height: 30,
          cornerRadius: 6,
          backgroundColor: theme.primaryColor,
          textColor: theme.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        deleteBtn,
      ];
    } else if (model.status == 2) {
      return [
        ABButton(
          text: AB_getS(context).agreed,
          width: 64,
          height: 30,
          cornerRadius: 6,
          backgroundColor: HexColor("e9e9e9"),
          textColor: theme.textGrey,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        deleteBtn,
      ];
    } else if (model.status == 3) {
      return [
        ABButton(
          text: AB_getS(context).refused,
          width: 64,
          height: 30,
          cornerRadius: 6,
          backgroundColor: HexColor("e9e9e9"),
          textColor: theme.textGrey,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        deleteBtn,
      ];
    } else {
      return [
        Container(height: 30,),
        deleteBtn,];
    }
  }

}

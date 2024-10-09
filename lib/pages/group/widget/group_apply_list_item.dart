import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../provider/language_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/extensions/color_extensions.dart';
import '../../../widget/ab_button.dart';
import '../../../widget/ab_image.dart';

class GroupApplyListItem extends StatelessWidget {
  final V2TimGroupApplication model;
  final ApplicationStatus status;
  final Function(bool)? onTap;

  const GroupApplyListItem({super.key, required this.model, this.onTap, required this.status});


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
                            child: ABImage.avatarUser(model.fromUserFaceUrl ?? "")),
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
                  Text(_timeString(model.addTime), style: TextStyle(color: theme.textGrey, fontSize: 12, fontWeight: FontWeight.w500)).expanded(),
                  ..._buttonWidget(context),
                ]
            ).addPadding(padding: EdgeInsets.only(left: 16, right: 16)),
          ]
      ),
    );
  }

  Widget _richText(BuildContext context) {
    final theme = AB_theme(context);
    List<InlineSpan> children = [];
    children.add(TextSpan(
      text: "${model.fromUserNickName} ",
      style: TextStyle(color: theme.textColor, fontSize: 14, fontWeight: FontWeight.w600),
    ));
    children.add(TextSpan(
      text: "(${model.fromUser}) ",
      style: TextStyle(color: theme.textColor, fontSize: 14, fontWeight: FontWeight.normal),
    ));
    children.add(TextSpan(
      text: "${AB_getS(context).applyJoinGroupTip}",
      style: TextStyle(color: theme.textGrey, fontSize: 14, fontWeight: FontWeight.w500),
    ));
    if (model.requestMsg != null && model.requestMsg!.isNotEmpty) {
      children.add(TextSpan(
        text: "\n\n${model.requestMsg}",
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
    if (status == ApplicationStatus.none) {
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
      ];
    } else if (status == ApplicationStatus.accept) {
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
      ];
    } else if (status == ApplicationStatus.reject) {
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
      ];
    } else {
      return [Container(height: 30,)];
    }
  }

  String _timeString(int? time) {
    if (time == null) {
      return "";
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return formattedDate;
  }
}

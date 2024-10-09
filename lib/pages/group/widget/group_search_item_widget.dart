import 'package:bee_chat/models/group/group_list_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSearchItemWidget extends StatelessWidget {

  final GroupListModel groupInfo;
  final Function()? onJoinGroup;
  final Function()? onChatGroup;

  const GroupSearchItemWidget({super.key, required this.groupInfo, this.onJoinGroup, this.onChatGroup});

  bool get isJoined {
    return groupInfo.isInto == 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    final maxWidth = ABScreen.width - 32.px - 20 - 80 - 56 - 52 - 4;
    return Container(
      height: 74,
      width: ABScreen.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 头像
          Container(
            width: 56,
            height: 56,
            margin: EdgeInsets.only(left: 16.px, right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: ABImage.avatarUser(groupInfo.groupAvatarUrl ?? "", isGroup: true),
            ),
          ),
          // 名字
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Container(
                        padding: const EdgeInsets.only(right: 4),
                          constraints: BoxConstraints(maxWidth: maxWidth, minWidth: 10),
                          child: ABText(groupInfo.groupName ?? "", textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,)),
                    ),
                    Container(
                      // constraints: BoxConstraints(maxWidth: 45, minWidth: 20),
                      padding: const EdgeInsets.only(right: 4),
                      // width: 32,
                      height: 18,
                      decoration: BoxDecoration(
                        color: HexColor("7b7b7b").withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 8,),
                          Image.asset(ABAssets.groupMemberIcon(context), width: 13, height: 13,),
                          const SizedBox(width: 2,),
                          FittedBox(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 26),
                                child: FittedBox(child: ABText("${groupInfo.groupPersonNum ?? 1}", textColor: theme.textColor, fontSize: 12, fontWeight: FontWeight.w400,))),
                          ),
                          const SizedBox(width: 4,)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.px),
                ABText(groupInfo.groupDescription ?? "", textColor: theme.textGrey, fontSize: 12, fontWeight: FontWeight.w400,)
              ],
            ),
          ),
          // 加入/聊天按钮
          _getRightWidget(context, isJoined),
        ],
      ),
    );
  }

  // 加入/聊天按钮
  Widget _getRightWidget(BuildContext context, bool isJoined) {
    final theme = AB_theme(context);

    return InkWell(
      onTap: () {
        if (isJoined) {
          print("chat");
          onChatGroup?.call();
        } else {
          onJoinGroup?.call();
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 16.px, left: 10),
        width: 80,
        height: 36,
        decoration: BoxDecoration(
          color: (onJoinGroup == null && !isJoined) ? Colors.grey : theme.primaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: ABText(
            isJoined ? AB_getS(context).chat : AB_getS(context).join,
            textColor: theme.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

  }


}

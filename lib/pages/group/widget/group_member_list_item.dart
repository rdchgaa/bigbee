import 'package:bee_chat/models/group/group_member_list_model.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

import '../../../provider/language_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/ab_assets.dart';
import '../../../utils/ab_screen.dart';
import '../../../utils/extensions/color_extensions.dart';
import '../../../widget/ab_text.dart';

class GroupMemberListItem extends StatelessWidget {
  final GroupMemberListModel model;
  // 不传就没有选中标记
  final bool? isSelect;
  final Function()? onSelect;
  final bool isMute;

  const GroupMemberListItem({super.key, required this.model, this.isSelect, this.onSelect, this.isMute = false});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    final maxWidth = ABScreen.width - 32 - 14 - 56 - 40 - 6 - (isSelect != null ? 40 : 0);
    return Container(
        height: 74,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          // 头像
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.network(model.avatarUrl!,
                width: 56, height: 56, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // 昵称与是否是群主
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Container(
                          padding: const EdgeInsets.only(right: 4),
                          constraints:
                              BoxConstraints(maxWidth: maxWidth, minWidth: 10),
                          child: ABText(
                            model.displayName ?? "",
                            textColor: theme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    if (model.isGroupLeader==2 || model.isAdministrators==2) Container(
                      constraints: const BoxConstraints(maxWidth: 40, minWidth: 18),
                      padding: const EdgeInsets.only(right: 4),
                      // width: 32,
                      height: 18,
                      decoration: BoxDecoration(
                        color: model.isGroupLeader==2 ?theme.primaryColor : theme.primaryColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          FittedBox(
                            child: Container(
                                constraints: const BoxConstraints(maxWidth: 26),
                                child: FittedBox(
                                    child: ABText(
                                      model.isGroupLeader==2 ? AB_getS(context).groupLeader : AB_getS(context).groupAdmin,
                                  textColor: theme.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.center,
                                ))),
                          ).expanded(),
                          const SizedBox(
                            width: 4,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: model.isOnline == "Online" ? HexColor("#00FF47") : Colors.grey,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    const SizedBox(width: 4),
                    ABText(
                      model.isOnline == "Online" ? AB_getS(context).online : AB_getS(context).offline,
                      textColor: theme.textGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
              ])),
          if (isSelect != null)
            InkWell(
              onTap: onSelect,
              child: Container(
                width: 40,
                height: 40,
                child: Image.asset(isSelect! ? ABAssets.selectedIcon(context) : ABAssets.unSelectedIcon(context), width: 24, height: 24,).center,
              ),
            )
        ]));
  }
}

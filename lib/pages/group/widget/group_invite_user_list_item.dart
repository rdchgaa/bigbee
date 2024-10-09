import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/group/group_member_invite_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/ab_assets.dart';
import '../../../utils/ab_screen.dart';
import '../../../widget/ab_text.dart';

class GroupInviteUserListItem extends StatelessWidget {
  final GroupMemberInviteModel model;
  final bool isSelected;
  final VoidCallback? onSelect;
  const GroupInviteUserListItem({super.key, required this.model, this.isSelected = false, this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
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
              child: ABText(
                model.nickName ?? "",
                textColor: theme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
          ),
          InkWell(
              onTap: onSelect,
              child: Container(
                width: 40,
                height: 40,
                child: Image.asset(isSelected ? ABAssets.selectedIcon(context) : ABAssets.unSelectedIcon(context), width: 24, height: 24,).center,
              ),
            )
        ]));
  }
}

import 'dart:math';

import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/extensions/im_group_extension.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../provider/theme_provider.dart';
import '../../../utils/ab_screen.dart';

class GroupMemberInfoWidget extends StatelessWidget {
  const GroupMemberInfoWidget({
    super.key,
    required this.memberList,
    required this.isManager,
    required this.onInviteOrRemoveMember,
    required this.toUserProfile,
    this.showRange = 15,
  });

  final List<V2TimGroupMemberFullInfo?> memberList;
  final bool isManager;
  /// 展示的 item 数量：包含操作按钮
  final int showRange;
  /// type: 1、邀请，2、删除
  final ValueChanged<int> onInviteOrRemoveMember;
  final ValueChanged<V2TimGroupMemberFullInfo?> toUserProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24, bottom: 12),
      child: _buildMemberInfoSection(),
    );
  }

  Widget _buildMemberInfoSection() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        final spacing = 16.0;
        final itemWidth = 56.0;
        // 操作按钮的数量
        final actionCount = isManager ? 2 : 1;
        final maxShowMemberCount = ((ABScreen.width - 32)/72).floor() - actionCount;
        final childrenLength =
            min(maxShowMemberCount, memberList.length) + actionCount;
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(childrenLength, (index) {
              if (index == childrenLength-1) {
                return isManager ? _buildActionBtn(type: 2, context: context) : _buildActionBtn(type: 1, context: context);
              }
              if (index == childrenLength - 2 && isManager) {
                return _buildActionBtn(type: 1, context: context);
              }
              final memFullInfo = memberList[index];

              return InkWell(
                onTap: () => toUserProfile(memFullInfo),
                child: SizedBox(
                  width: itemWidth,
                  child: _buildMemberInfo(
                    memFullInfo?.faceUrl ?? '',
                    memFullInfo.displayName,
                    context,
                  ),
                ),
              );
            }).toList(),
          ).addPadding(padding: EdgeInsets.symmetric(horizontal: spacing)),
        );
      },
    );
  }

  Widget _buildMemberInfo(String avatarUrl, String showName, BuildContext context) {
    final theme = AB_theme(context);
    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: ABImage.avatarUser(avatarUrl, width: 56, height: 56,)
        ),
        SizedBox(height: 4),
        Text(
          showName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: theme.textColor,
          ),
        ),
      ],
    );
  }

  // type: 1、邀请，2、删除
  Widget _buildActionBtn({int type = 1, required BuildContext context}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: () => onInviteOrRemoveMember(type),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.f4f4f4,
              borderRadius: BorderRadius.circular(28),
            ),
              child: Center(
                child: Icon(
                  (type == 1) ? Icons.add : Icons.remove,
                  color: (type == 1 ? theme.primaryColor : theme.textColor),
                  size: 24,
                ),
              ),
          ),
          SizedBox(height: 4),
          Text(
            ((type == 1) ? AB_getS(context).invited : AB_getS(context).delete),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: (type == 1 ? theme.primaryColor : theme.textColor),
            ),
          ),
        ],
      ),
    );
  }
}

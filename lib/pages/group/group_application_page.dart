import 'package:bee_chat/pages/group/widget/group_apply_list_item.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../utils/extensions/color_extensions.dart';

class GroupApplicationPage extends StatefulWidget {
  final String groupID;
  const GroupApplicationPage({super.key, required this.groupID});

  @override
  State<GroupApplicationPage> createState() => _GroupApplicationPageState();
}

class _GroupApplicationPageState extends State<GroupApplicationPage> {
  // TIM_t("进群申请列表")
  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: TIM_t("进群申请列表"),
        backgroundWidget: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                HexColor("#FFDC79"),
                HexColor("#FFCB32"),
              ],
            ),
          ),
        ),
      ),
      body: TIMUIKitGroupApplicationList(groupID: widget.groupID, itemBuilder1: (BuildContext context, V2TimGroupApplication applicationInfo, int index, ApplicationStatus status, Function(bool) onTap) {
        return GroupApplyListItem(model: applicationInfo, status: status, onTap: onTap,);
      }),
    );
  }
}

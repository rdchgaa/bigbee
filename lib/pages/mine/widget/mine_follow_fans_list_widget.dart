import 'package:bee_chat/models/user/follow_user_list_model.dart';
import 'package:bee_chat/pages/account_security/mnemonic_input_page.dart';
import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/alert_pop_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../vm/mine_follow_fans_list_vm.dart';

class MineFollowFansListWidget extends StatefulWidget {
  final MineFollowFansListType type;
  const MineFollowFansListWidget({super.key, required this.type});

  @override
  State<MineFollowFansListWidget> createState() => _MineFollowFansListWidgetState();
}

class _MineFollowFansListWidgetState extends State<MineFollowFansListWidget> {
  late MineFollowFansListVM _vm;

  @override
  void initState() {
    _vm = MineFollowFansListVM(type: widget.type);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _vm.refreshData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return ChangeNotifierProvider(
      create: (_) => _vm,
      builder: (context, child) {
        var vm = context.watch<MineFollowFansListVM>();
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 0,
              ),
              EasyRefresh(
                header: CustomizeBallPulseHeader(color: theme.primaryColor),
                onRefresh: () async {
                  await _vm.refreshData();
                },
                onLoad: !vm.hasMore
                    ? null
                    : () async {
                  await _vm.loadMore();
                },
                child: vm.resultList.isEmpty ? Center(
                  child: Image.asset(ABAssets.emptyIcon(context)),
                ):ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        height: 20.px,
                      );
                    }
                    var item = vm.resultList[index-1];
                    return InkWell(
                      onTap: () {
                        ABRoute.push(UserDetailsPage(userId: item.memberNum ?? ""));
                      },
                        child: _getItemWidget(item));
                  },
                  itemCount: vm.resultList.length + 1,
                ),
              ).expanded(),
            ]
        );
      },
    );
  }


  Widget _getItemWidget(FollowUserListModel model) {
    final isOnline = model.online == "Online";
    final isFollowed = model.isFocus == 1 || model.isFocus == 3;
    final theme = AB_theme(context);
    return Container(
      color: Colors.white,
      height: 72.px,
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: Container(
        // 底部边框
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AB_theme(context).f4f4f4,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 头像
            ClipRRect(
              borderRadius: BorderRadius.circular(24.px),
              child: ABImage.imageWithUrl(model.avatarUrl ?? "", width: 48.px, height: 48.px),
            ),
            SizedBox(width: 12.px,),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.nickName ?? "", style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.bold, color: theme.textColor)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10.px,
                      height: 10.px,
                      decoration: BoxDecoration(color: isOnline ? theme.primaryColor : theme.textGrey, borderRadius: BorderRadius.circular(5.px)),
                    ),
                    SizedBox(width: 6.px,),
                    Text(isOnline ? AB_S().online : AB_S().offline, style: TextStyle(fontSize: 14.px, color: theme.textGrey)),
                  ],
                ),
              ],
            )),
            SizedBox(width: 12.px,),
            _getFollowStatusWidget(focusStatus: model.isFocus ?? 0, onPressed: () async {
              if (!isFollowed) {
                await _vm.changeFollowStatus(model.memberNum ?? "", !isFollowed);
                return;
              }
              if (!mounted) {
                return;
              }
              final isConfirmed = await AlertPopWidget.show(title: AB_S().tip, content: AB_S().unfollowTip);
              if (isConfirmed == true) {
                final res = await _vm.changeFollowStatus(model.memberNum ?? "", !isFollowed);
                if (res) {
                  ABToast.show(AB_S().unfollowSuccess, toastType: ToastType.success);
                }
              }
            }),
          ],
        ),
      ),
    );
  }

  // 1,已关注 2,回关 3，相互关注
  Widget _getFollowStatusWidget({int focusStatus = 0, VoidCallback? onPressed}) {
    print("focusStatus: $focusStatus");
    final theme = AB_theme(context);
    Color backgroundColor = theme.primaryColor;
    Color foregroundColor = Colors.white;
    String text = AB_S().follow;
    if (focusStatus == 1 || focusStatus == 3) {
       backgroundColor = theme.primaryColor.withOpacity(0.15);
       foregroundColor = theme.primaryColor;
       text = AB_S().followed;
    }
    if (focusStatus == 3) {
      backgroundColor = theme.primaryColor.withOpacity(0.15);
      foregroundColor = theme.primaryColor;
      text = AB_S().mutualFollow;
    }

    return ElevatedButton.icon(
      onPressed: () {
        onPressed?.call();
      },
      icon: Icon(Icons.sync_alt), // 设置图标
      label: Text(text), // 设置文字
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor), // 背景颜色
        foregroundColor: WidgetStateProperty.all(foregroundColor), // 文字和图标颜色
        elevation: WidgetStateProperty.all(0), // 禁用阴影
        textStyle: WidgetStateProperty.all(const TextStyle(
          fontSize: 14, // 设置字体大小
          fontWeight: FontWeight.w500,
        )),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)), // 设置内容边距
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // 圆角
        )),
      ),
    );
  }

}


import 'package:bee_chat/main.dart';
import 'package:bee_chat/pages/mine/vm/mine_follow_fans_list_vm.dart';
import 'package:bee_chat/pages/mine/widget/mine_follow_fans_list_widget.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../provider/language_provider.dart';

class MineFollowFansListPage extends StatefulWidget {
  final MineFollowFansListType type;

  const MineFollowFansListPage({super.key, this.type = MineFollowFansListType.follow});

  @override
  State<MineFollowFansListPage> createState() => _MineFollowFansListPageState();
}

class _MineFollowFansListPageState extends State<MineFollowFansListPage> {
  late MineFollowFansListType _type;
  late PageController _pageController;

  @override
  void initState() {
    _type = widget.type;
    _pageController = PageController(initialPage: widget.type==MineFollowFansListType.follow?0:1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          // 顶部
          Container(
            height: 50 + MediaQuery.of(context).padding.top,
            width: double.infinity,
            // 渐变背景
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 50.px,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getTopBarItem(
                          isSelected: _type == MineFollowFansListType.follow,
                          title: AB_getS(context).follow,
                          onTap: () {
                            setState(() {
                              _type = MineFollowFansListType.follow;
                              _pageController.jumpToPage(0);
                            });
                          },
                        ),
                        _getTopBarItem(
                          isSelected: _type == MineFollowFansListType.fans,
                          title: AB_getS(context).fans,
                          onTap: () {
                            print("跳转粉丝列表");
                            setState(() {
                              _type = MineFollowFansListType.fans;
                              _pageController.jumpToPage(1);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 8.px,
                    child: Container(
                      width: 40.px,
                      height: 40.px,
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final isBack = await Navigator.maybePop(context);
                          if (!isBack) {
                            await SystemNavigator.pop();
                          }
                        },
                        tooltip: 'Back',
                        padding: EdgeInsets.only(left: 16.px),
                        icon: Icon(
                          CupertinoIcons.arrow_left,
                          color: theme.textColor,
                        ),
                      ),
                    ))
              ],
            ),
          ),
          // pageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _type = index == 0 ? MineFollowFansListType.follow : MineFollowFansListType.fans;
                });
              },
              children: [
                MineFollowFansListWidget(type: MineFollowFansListType.follow),
                MineFollowFansListWidget(type: MineFollowFansListType.fans)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTopBarItem({bool isSelected = false, required String title, required Function() onTap}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        // 底部线条
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? theme.textColor : Colors.transparent,
              width: 2.px,
            ),
          ),
        ),
        height: 50.px,
        // padding: EdgeInsets.symmetric(horizontal: 15.px),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? theme.textColor : theme.textColor.withOpacity(0.7),
            fontSize: 18.px,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ).setPadding(left: 15.px, right: 15.px),
    );
  }


}


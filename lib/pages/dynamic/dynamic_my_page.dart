import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dynamic/dynamic_details_page.dart';
import 'package:bee_chat/pages/dynamic/vm/dynamic_list_vm.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_hot_user_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_item.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_my_list_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class DynamicMyPage extends StatefulWidget {
  const DynamicMyPage({super.key});

  @override
  State<DynamicMyPage> createState() => _DynamicMyPageState();
}

class _DynamicMyPageState extends State<DynamicMyPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
        appBar: ABAppBar(
          navigationBarHeight: 60.px,
          backIconCenter: true,
          title: AB_getS(context).dynamic,
          backgroundWidget: Container(
            // 渐变色
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
        backgroundColor: theme.backgroundColor,
        body: Column(children: [
          SizedBox(height: 10.px),
          _getTopBarView(),
          PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              DynamicMyListWidget(type: DynamicListType.all),
              DynamicMyListWidget(type: DynamicListType.video),
              DynamicMyListWidget(type: DynamicListType.image),
              DynamicMyListWidget(type: DynamicListType.text),
            ],
          ).expanded(),
        ]));
  }

  Widget _getTopBarView() {
    List<Widget> children = [
      _getBarItem(AB_getS(context).all, _currentIndex == 0, () {
        setState(() {
          _currentIndex = 0;
          _pageController.jumpToPage(0);
        });
      }),
      _getBarItem(AB_getS(context).video, _currentIndex == 1, () {
        setState(() {
          _currentIndex = 1;
          _pageController.jumpToPage(1);
        });
      }),
      _getBarItem(AB_getS(context).picture, _currentIndex == 2, () {
        setState(() {
          _currentIndex = 2;
          _pageController.jumpToPage(2);
        });
      }),
      _getBarItem(AB_getS(context).text, _currentIndex == 3, () {
        setState(() {
          _currentIndex = 3;
          _pageController.jumpToPage(3);
        });
      }),
    ];
    return SizedBox(
      height: 42.px,
      child: Row(
        children: children,
      ),
    );
  }

  Widget _getBarItem(String title, bool isSelected, Function()? onTap) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.px),
        height: 42.px,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.px),
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : theme.white,
            borderRadius: BorderRadius.circular(16.px),
            // 边框
            border: Border.all(
              color: isSelected ? Colors.transparent : Color(0xfff0f0f0),
              width: 1.px,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: theme.textColor,
              fontSize: 14.px,
              fontWeight: FontWeight.bold,
            ),
          ).center,
        ),
      ),
    ).padding(left: 16.px);
  }
}

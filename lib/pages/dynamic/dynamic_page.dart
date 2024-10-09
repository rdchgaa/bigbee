import 'package:bee_chat/pages/dynamic/dynamic_publish_page.dart';
import 'package:bee_chat/pages/dynamic/search/dynamic_search_page.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_follow_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_hot_widget.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/app_data_provider.dart';
import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../widget/ab_text.dart';
import '../contact/contact_page.dart';
import '../conversation/conversation_page.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage({super.key});

  @override
  State<DynamicPage> createState() => DynamicPageState();
}

class DynamicPageState extends State<DynamicPage> {
  DynamicPageType _type = DynamicPageType.hot;
  late PageController _pageController;
  GlobalKey<DynamicFollowWidgetState> followKey = GlobalKey();
  GlobalKey<DynamicHotWidgetState> hotKey = GlobalKey();
  GlobalKey<DynamicHotWidgetState> squareKey = GlobalKey();

  @override
  void initState() {
    _pageController = PageController(initialPage: AppDataProvider.getDynamicIndex());
    switch (AppDataProvider.getDynamicIndex()) {
      case 1:
        _type = DynamicPageType.follow;
        break;
      case 2:
        _type = DynamicPageType.hot;
        break;
      case 3:
        _type = DynamicPageType.square;
        break;
        default:
          _type = DynamicPageType.hot;
          _pageController = PageController(initialPage: 1);
          break;
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  reFreshData(){
    followKey.currentState?.initData();
    hotKey.currentState?.initData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context,);
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          Container(
            color: theme.primaryColor,
            height: 58.px + ABScreen.statusHeight,
            width: double.infinity,
            child: Stack(
              children: [
                // 顶部背景
                Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: AspectRatio(
                        aspectRatio: 288/156,
                        child: Image.asset(ABAssets.homeTopBackground(context), fit: BoxFit.cover,))
                ),
                // 关注
                Positioned(
                  top: ABScreen.statusHeight + 12.px,
                  left: 24.px,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _type = DynamicPageType.follow;
                        _pageController.jumpToPage(0);
                        followKey.currentState?.initData();
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 40.px,
                      child: ABText(AB_getS(context).follow,
                        textColor: (_type == DynamicPageType.follow ? theme.textColor : theme.textColor.withOpacity(0.7)),
                        fontSize: (_type == DynamicPageType.follow ? 22.px : 18.px),
                        fontWeight: (_type == DynamicPageType.follow ? FontWeight.w700 : FontWeight.w600),
                      ).addPadding(padding: EdgeInsets.only(right: 24.px)),
                    ),
                  ),
                ),
                // 热帖推荐
                Positioned(
                  top: ABScreen.statusHeight + 12.px,
                  left: isZh ? 84.px : 110.px,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _type = DynamicPageType.hot;
                        _pageController.jumpToPage(1);
                        hotKey.currentState?.initData();
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 40.px,
                      child: ABText(AB_getS(context).hotDynamic,
                        textColor: (_type == DynamicPageType.hot ? theme.textColor : theme.textColor.withOpacity(0.7)),
                        fontSize: (_type == DynamicPageType.hot ? 22.px : 18.px),
                        fontWeight: (_type == DynamicPageType.hot ? FontWeight.w700 : FontWeight.w600),
                      ).addPadding(padding: EdgeInsets.only(right: 24.px)),
                    ),
                  ),
                ),
                // 广场
                Positioned(
                  top: ABScreen.statusHeight + 12.px,
                  left: isZh ? 180.px : 176.px,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _type = DynamicPageType.square;
                        _pageController.jumpToPage(2);
                        hotKey.currentState?.initData();
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 40.px,
                      child: ABText(AB_getS(context).square,
                        textColor: (_type == DynamicPageType.square ? theme.textColor : theme.textColor.withOpacity(0.7)),
                        fontSize: (_type == DynamicPageType.square ? 22.px : 18.px),
                        fontWeight: (_type == DynamicPageType.square ? FontWeight.w700 : FontWeight.w600),
                      ).addPadding(padding: EdgeInsets.only(right: 24.px)),
                    ),
                  ),
                ),
                // 搜索按钮
                Positioned(
                  right: 54.px,
                  bottom: 2.px,
                  child: InkWell(
                    onTap: (){
                      // 跳转添加动态页面
                      ABRoute.push(const DynamicSearchPage());
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: 44.px,
                        height: 44.px,
                        child: Image.asset(ABAssets.dynamicSearchIcon(context), width: 28.px, height: 28.px,)
                    ),
                  ),
                ),
                // add按钮
                Positioned(
                  right: 8.px,
                  bottom: 2.px,
                  child: InkWell(
                    onTap: (){
                      // 跳转添加动态页面
                      ABRoute.push(const DynamicPublishPage());
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: 44.px,
                        height: 44.px,
                        child: Image.asset(ABAssets.homeAddIcon(context), width: 28.px, height: 28.px,)
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(), // 禁止滑动
              controller: _pageController,
              onPageChanged: (int index) {},
              children: [
                DynamicFollowWidget(key:followKey).keepAlive,
                DynamicHotWidget(key:hotKey).keepAlive,
                DynamicFollowWidget(key:squareKey, isSquare: true,).keepAlive,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum DynamicPageType {
  // 关注
  follow,
  // 热帖
  hot,
  // 广场
  square,
}
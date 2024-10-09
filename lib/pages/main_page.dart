import 'dart:io';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/dynamic/dynamic_page.dart';
import 'package:bee_chat/pages/home/home_page.dart';
import 'package:bee_chat/pages/assets/assets_page.dart';
import 'package:bee_chat/provider/custom_emoji_provider.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import '../net/common_net.dart';
import '../net/im_net.dart';
import '../widget/app_update_widget.dart';
import 'find/find_page.dart';
import 'market/market_page.dart';

class MainPage extends StatefulWidget {
  final int pageIndex;

  const MainPage({super.key, this.pageIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TUIConversationViewModel conversationModel = serviceLocator<TUIConversationViewModel>();
  int _currentIndex = 0;
  late PageController _pageController;

  final GlobalKey<DynamicPageState> _dynamicPageKey = GlobalKey<DynamicPageState>();
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _requestVersionList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _initData();
    });
    CustomEmojiProvider.loadCustomEmojiList();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _initData(){
    _initUserInfo();
    _initCoinList();
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    provider.initData(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark, // 设置状态栏字体颜色为亮色,
      child: MultiProvider(
        providers: [ChangeNotifierProvider.value(value: conversationModel)],
        builder: (BuildContext context, Widget? w) {
          final _model = Provider.of<TUIConversationViewModel>(context);
          return Scaffold(
            body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                // physics: (_currentIndex == 0 ? const NeverScrollableScrollPhysics() : null), // 禁止滑动
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  HomePage(),
                  MarketPage(),
                  DynamicPage(key:_dynamicPageKey),
                  FindPage(),
                  AssetsPage(),
                ]
            ),
            bottomNavigationBar: getNavigationBar(totalUnReadCount: _model.totalUnReadCount),
          );
        },
      ),
    );



  }

  BottomNavigationBar getNavigationBar({int totalUnReadCount = 0}) {
    final theme = AB_theme(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 32,
      backgroundColor: theme.white,
      selectedItemColor: theme.secondaryColor,
      unselectedItemColor: theme.primaryColor,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
          // if (index == 0) {
          //   _requestVersionList();
          // }
          if (index == 2) {//动态
            _dynamicPageKey.currentState?.reFreshData();
          }
        });
      },
      items: getNavigationBarItems(totalUnReadCount: totalUnReadCount),
    );
  }

  List<BottomNavigationBarItem> getNavigationBarItems({int totalUnReadCount = 0}) {
    final unreadWidget = totalUnReadCount > 0 ? Container(
      width: 14,
      height: 14,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text("${totalUnReadCount > 99 ? "99+" : "$totalUnReadCount"}", style: TextStyle(color: Colors.white, fontSize: 6),),
    ) : null;
    final List<Map> barDataList = [
      {
        "title": AB_getS(context).home,
        "selectImage": _getBarIcon(assetName: ABAssets.tabbarHomeIcon(context, isSelect: true), imageSize: 28, badge: unreadWidget),
        "image": _getBarIcon(assetName: ABAssets.tabbarHomeIcon(context, isSelect: false), imageSize: 24, badge: unreadWidget),
      },
      {
        "title": AB_getS(context).market,
        "selectImage": _getBarIcon(assetName: ABAssets.tabbarHangqingIcon(context, isSelect: true), imageSize: 26,),
        "image": _getBarIcon(assetName: ABAssets.tabbarHangqingIcon(context, isSelect: false), imageSize: 24,),
      },
      // 动态
      {
        "title": AB_getS(context).dynamic,
        "selectImage": _getBarIcon(assetName: ABAssets.tabbarDynamicIcon(context, isSelect: true), imageSize: 26,),
        "image": _getBarIcon(assetName: ABAssets.tabbarDynamicIcon(context, isSelect: false), imageSize: 24,),
      },
      // 发现
      {
        "title": AB_getS(context).find,
        "selectImage": _getBarIcon(assetName: ABAssets.tabbarFindIcon(context, isSelect: true), imageSize: 26,),
        "image": _getBarIcon(assetName: ABAssets.tabbarFindIcon(context, isSelect: false), imageSize: 24,)
      },
      {
        "title": AB_getS(context).mine,
        "selectImage": _getBarIcon(assetName: ABAssets.tabbarUserIcon(context, isSelect: true), imageSize: 26,),
        "image": _getBarIcon(assetName: ABAssets.tabbarUserIcon(context, isSelect: false), imageSize: 24,)
      }
    ];
    return barDataList.map((item) => BottomNavigationBarItem(
      icon: item["image"],
      activeIcon: item["selectImage"],
      label: item["title"],
    )).toList();
  }


  void _requestVersionList() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    final platform = Platform.operatingSystem;
    if (platform != "android" && platform != "ios") {
      return;
    }
    debugPrint("当前版本号: $version");
    final systemType = platform == "android" ? 2 : 1;
    final result = await CommonNet.getVersionList(systemType);
    if (result.data != null && result.data!.isNotEmpty) {
      final data = result.data;
      final versionNum = data![0].versionNum ?? "";
      if (versionNum.isNotEmpty && version != versionNum) {
        if (mounted) {
          AppUpdateWidget.show(context, result.data![0]);
        }
      }
    }
  }

  void _initUserInfo() async{
    final provider = Provider.of<UserProvider>(context, listen: false);
    final userId = await ABSharedPreferences.getUserId() ?? "";
    final result = await UserNet.getUserInfo(userId: userId??'');
    if (result.data != null) {
      provider.userInfo = result.data!;
    }
  }

  void _initCoinList() async{
    final result = await AssetsNet.getCoinList();
    if (result.data != null && result.data!.isNotEmpty) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider.coinList = result.data!;
    }
  }


  Widget _getBarIcon({required String assetName, double imageSize = 24, Widget? badge}) {
    return SizedBox(
      width: 38,
      height: 32,
      child: Stack(children: [
        Positioned(
          bottom: 0,
            left: (36 - imageSize) / 2,
            child: Image(image: AssetImage(assetName), width: imageSize, height: imageSize),
        ),
        if (badge != null) Positioned(
          right: 0,
          top: 0,
          child: badge,
        ),
      ],),
    );
  }
}

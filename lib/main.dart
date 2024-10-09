import 'dart:async';
import 'package:bee_chat/pages/group/group_member_choose_page.dart';
import 'package:bee_chat/pages/splash_page.dart';
import 'package:bee_chat/provider/app_data_provider.dart';
import 'package:bee_chat/provider/contact_provider.dart';
import 'package:bee_chat/provider/custom_emoji_provider.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/single/app_single.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/net/ab_Net.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tencent_calls_uikit/tuicall_kit.dart';
import 'generated/l10n.dart';
import 'models/group/group_member_list_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化绑定
  // 禁止横屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);
  await ABSharedPreferences.init();

  // EasyRefresh默认defaultFooter
  EasyRefresh.defaultFooter = CustomFooter(
    enableHapticFeedback: true,
      enableInfiniteLoad: true,
      footerBuilder: (BuildContext context, LoadMode loadState, double pulledExtent, double loadTriggerPullDistance, double loadIndicatorExtent, AxisDirection axisDirection, bool float, Duration? completeDuration, bool enableInfiniteLoad, bool success, bool noMore) {
    return CupertinoActivityIndicator(radius: 10,).center;
  }) ;

  TUICallKit.instance.enableFloatWindow(true);
  // 音视频通话模块群成员选择
  TUICallKit.instance.setChooseGroupMemberListFunction((groupID, selectedMemberIds, excludeMemberIds, maxNum) async {
    final memberList = await ABRoute.push(GroupMemberChoosePage(
      title: AB_getS(MyApp.context, listen: false).chooseMember,
      groupID: groupID,
      selectedMemberIds: selectedMemberIds,
      excludeMemberIds: excludeMemberIds,
      checkComplete: (List<GroupMemberListModel> memberList) {
        if (maxNum == null || maxNum == 0) {
          return Future.value(true);
        }
        if (memberList.length <= maxNum) {
          return Future.value(true);
        } else {
          ABToast.show("${AB_getS(MyApp.context, listen: false).maxNumTip}$maxNum");
          return Future.value(false);
        }
      },
    )) as List<GroupMemberListModel>?;
    if (memberList != null && memberList.isNotEmpty) {
      final memberIDList = memberList.map((e) => e.memberNum ?? "").toList().where((e) => e.isNotEmpty).toList();
      return Future.value(memberIDList);
    }
    return Future.value([]);
  });
  runApp(MultiProvider(
    providers: [
      //可以多个provider进行分类处理
      ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => ContactProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AppDataProvider()),
      ChangeNotifierProvider(create: (context) => CustomEmojiProvider()),
    ],
    child: MyApp(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
class MyApp extends StatefulWidget {
  static MyApp? _singleton;

  MyApp({super.key}) {
    _singleton = this;
  }

  @override
  State<MyApp> createState() => _MyAppState();

  static BuildContext get context => navigatorKey.currentState!.context;
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    // 监听系统事件
    WidgetsBinding.instance.addObserver(this);
    // 网络请求配置
    ABNet.config();
  }

  @override
  void dispose() {
    // 取消监听系统事件
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // 亮度变化（主题模式发生改变也会）时的处理逻辑
    super.didChangePlatformBrightness();
    Future.delayed(const Duration(milliseconds: 200), () {
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      if (provider.type == ABThemeType.system &&
          provider.theme.id != provider.themeId) {
        print("通知改变系统主题");
        provider.changeTheme(ABThemeType.system);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ABTheme theme = Provider.of<ThemeProvider>(context).getTheme(context);
    // 隐藏状态栏背景
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: theme.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        // 视频通话
        navigatorObservers:[TUICallKit.navigatorObserver],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
          primarySwatch: MaterialColor(theme.primaryColor.value, {
            50: theme.primaryColor.withOpacity(0.05),
            100: theme.primaryColor.withOpacity(0.1),
            200: theme.primaryColor.withOpacity(0.2),
            300: theme.primaryColor.withOpacity(0.3),
            400: theme.primaryColor.withOpacity(0.4),
            500: theme.primaryColor.withOpacity(0.5),
            600: theme.primaryColor.withOpacity(0.6),
            700: theme.primaryColor.withOpacity(0.7),
            800: theme.primaryColor.withOpacity(0.8),
            900: theme.primaryColor.withOpacity(0.9),
          }),
          // scaffold背景颜色
          scaffoldBackgroundColor: theme.backgroundColor,
          splashFactory: NoSplash.splashFactory, // 全局禁用波纹效果
          // 去除TabBar底部线条
          tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),

        ),
        navigatorKey: navigatorKey,
        home: const SplashPage(),
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}
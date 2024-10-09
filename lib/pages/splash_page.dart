import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bee_chat/main.dart';
import 'package:bee_chat/pages/login_regist/login_page.dart';
import 'package:bee_chat/provider/app_data_provider.dart';
import 'package:bee_chat/utils/ab_loading.dart';

import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/im/im_utils.dart';
import 'package:bee_chat/utils/map_utls.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:video_player/video_player.dart';
import '../net/common_net.dart';
import '../provider/language_provider.dart';
import '../provider/theme_provider.dart';
import '../utils/ab_route.dart';
import '../utils/ab_shared_preferences.dart';
import '../utils/net/ab_Net.dart';
import 'login_regist/start_page.dart';
import 'main_page.dart';
import 'package:flutter_baidu_mapapi_base/src/map/bmf_types.dart';



class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  SplashPageType _splashPageType = SplashPageType.none;
  String _url = "";

  @override
  void initState() {
    super.initState();
    initAPP();
    // _loadVideo();
    _controller = VideoPlayerController.asset("assets/video/splash.mp4");
    _requestSplash();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    ABTheme currentTheme =
        Provider.of<ThemeProvider>(context, listen: true).theme;

    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      body: Stack(
        children: [
          // 背景
          const CupertinoActivityIndicator(color: Colors.grey, radius: 14.0,).center,
          // if (_controller.value.isInitialized) Positioned.fill(child: VideoPlayer(_controller)),
          Positioned.fill(child: _getShowWidget(_splashPageType, _url))
        ],
      ),
    );
  }

  Widget _getShowWidget(SplashPageType splashPageType, String url) {
    switch (splashPageType) {
      case SplashPageType.image:
        return _imageWidget(url);
      case SplashPageType.gif:
        return _gifWidget(url);
      case SplashPageType.video:
        return _videoWidget();
      default:
        return Container();
    }
  }

  Widget _imageWidget(String url) {
    return Image.network(url, fit: BoxFit.cover,);
  }

  Widget _gifWidget(String url) {
    return Image(image: NetworkImage(url), fit: BoxFit.cover,);
  }

  Widget _videoWidget() {
    return VideoPlayer(_controller);
  }


  /// 初始化app相关的东西
  Future<void> initAPP() async {
    Locale systemLocale = Localizations.localeOf(MyApp.context);
    print("系统语言环境 - ${systemLocale.languageCode}");
    // 获取存储的语言
    String languageCode = await ABSharedPreferences.getLanguageCode() ?? (systemLocale.languageCode.contains("zh") ? "zh" : "en");
    print("设置语言环境 - ${languageCode}");
    // 设置语言
    LanguageProvider.changeLanguage(
        Locale.fromSubtags(languageCode: languageCode));
    _coreInstance.init(
        sdkAppID: imAppId, // Replace 0 with the SDKAppID of your IM application when integrating
        language: languageCode.contains("zh") ? LanguageEnum.zhHans : LanguageEnum.en, // 界面语言配置，若不配置，则跟随系统语言
        loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
        config: const TIMUIKitConfig(
          isShowOnlineStatus: true,
          defaultAvatarBorderRadius: BorderRadius.all(Radius.circular(32),),
        ),
        onTUIKitCallbackListener:  (TIMCallback callbackValue){}, // [建议配置，详见此部分](https://cloud.tencent.com/document/product/269/70746#callback)
        listener: ImUtils.listener);
    // 主题相关
    final themeType = ABSharedPreferences.getThemeTypeSync();
    AB_themeProvider(context, listen: false).changeTheme(themeType);
    // 初始化网络
    ABNet.config();
    _loadBaiduMap();
  }


  _loadBaiduMap() async {
    /// 动态申请定位权限
    requestPermission();
    LocationFlutterPlugin myLocPlugin = LocationFlutterPlugin();
    /// 设置用户是否同意SDK隐私协议
    /// since 3.1.0 开发者必须设置
    MapUtils.setAgreePrivacy(true);
    myLocPlugin.setAgreePrivacy(true);
    // 百度地图sdk初始化鉴权
    if (Platform.isIOS) {
      myLocPlugin.authAK('8cL08Ws87cF8d7fFHoJWaAHB2V6GqSko');
      MapUtils.setApiKeyAndCoordType(
          '8cL08Ws87cF8d7fFHoJWaAHB2V6GqSko', BMF_COORD_TYPE.BD09LL);
    } else if (Platform.isAndroid) {
      /// 初始化获取Android 系统版本号，如果低于10使用TextureMapView 等于大于10使用Mapview
      await BMFAndroidVersion.initAndroidVersion();
      // Android 目前不支持接口设置Apikey,
      // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
      MapUtils.setCoordType(BMF_COORD_TYPE.BD09LL);

    }
  }


  /// 加载视频
  Future<void> _loadVideo(String url) async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await _controller.initialize();
    } catch (e) {
      print("加载视频失败 - ${e}");
    }
    _controller.play();
    _controller.setVolume(0.6);
    _controller.setLooping(false);
  }

  void _requestSplash() async {
    final result = await CommonNet.getLaunchSplash();
    if (result.data != null) {
      AppDataProvider.setDynamicIndex(result.data!.index ?? 2);
      final type = result.data!.type ?? 0;
      if (type == 1) {
        _splashPageType = SplashPageType.image;
        _url = result.data!.url ?? "";
      } else if (type == 2) {
        _splashPageType = SplashPageType.gif;
        _url = result.data!.url ?? "";
      } else if (type == 3) {
        _splashPageType = SplashPageType.video;
        _url = result.data!.url ?? "";
        await _loadVideo(_url);
      } else {
        _splashPageType = SplashPageType.none;
        _url = result.data!.url ?? "";
      }
      double duration = (result.data!.displayDuration ?? 1.0) * 1000;
      setState(() {});
      Future.delayed(Duration(milliseconds: duration.floor()), () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        }
        _gotoStartPage();
      });
    } else {
      _gotoStartPage();
    }


  }


  void _gotoStartPage() {
    // if (ABSharedPreferences.getTokenSync().isNotEmpty) {
    //   debugPrint("跳转到主界面");
    //   ABRoute.pushReplacement(const MainPage(pageIndex: 0,), tag: "root");
    //   return;
    // }
    debugPrint("跳转到开始界面");
    // ABRoute.pushReplacement(const StartPage(), tag: "root");
    _authLogin();
  }
  // 自动登陆
  Future<void> _authLogin() async {
    ABLoading.show();
    final token = await ABSharedPreferences.getToken() ?? "";
    final userId = await ABSharedPreferences.getUserId() ?? "";
    final userSign = await ABSharedPreferences.getUserSign() ?? "";
    await ABLoading.dismiss();
    if (token.isEmpty || userId.isEmpty || userSign.isEmpty) {
      ABRoute.pushReplacement(const LoginPage());
      return;
    }
    // 登陆Im
    ImUtils.loginIm(userSign: userSign,
        userId: userId,
        token: token);

  }
}

enum SplashPageType {
  image,
  gif,
  video,
  none,
}



// 动态申请定位权限
void requestPermission() async {
  // 申请权限
  bool hasLocationPermission = await requestLocationPermission();
  if (hasLocationPermission) {
    // 权限申请通过
  } else {}
}

/// 申请定位权限
/// 授予定位权限返回true， 否则返回false
Future<bool> requestLocationPermission() async {

  //获取当前的权限
  var status = await Permission.location.status;
  print("当前的权限 - $status");
  if (status == PermissionStatus.granted) {
    //已经授权
    return true;
  } else {
    //未授权则发起一次申请
    status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

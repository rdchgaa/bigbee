import 'dart:io';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/common/version_list_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/common_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/conversation/conversation_page.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/pages/login_regist/start_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/app_update_widget.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class AssetsVersionUpdatePage extends StatefulWidget {
  const AssetsVersionUpdatePage({super.key});

  @override
  State<AssetsVersionUpdatePage> createState() =>
      _AssetsVersionUpdatePageState();
}

class _AssetsVersionUpdatePageState extends State<AssetsVersionUpdatePage> {
  List<CoinModel> coinList = [];

  bool selectAll = false;

  List<CoinModel> selectedCoinList = [];

  String currentVersion = '';

  VersionListModel? lastVersion;

  bool isLoading = true;

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    final platform = Platform.operatingSystem;
    if (platform != "android" && platform != "ios") {
      return;
    }
    currentVersion = version;
    setState(() {

    });
    ABLoading.show();
    debugPrint("当前版本号: $version");
    final systemType = platform == "android" ? 2 : 1;
    final result = await CommonNet.getVersionList(systemType);
    if (result.data != null && result.data!.isNotEmpty) {
      final data = result.data;
      final versionNum = data![0].versionNum ?? "";
      if (versionNum.isNotEmpty && version != versionNum) {
        if (mounted) {
          // AppUpdateWidget.show(context, result.data![0]);
          lastVersion = result.data?[0];
        }
      }
    }
    ABLoading.dismiss();
    isLoading = false;
    setState(() {

    });

  }

  _submit() async {
    ABLoading.show();
    for (CoinModel item in coinList) {
      var isSelect = false;
      for (CoinModel selectedCoinListItem in selectedCoinList) {
        if (selectedCoinListItem.id == item.id) {
          isSelect = true;
          break;
        }
      }
      final result = await AssetsNet.displayFunds(
          fundsName: item.coinName ?? "", switchCapital: isSelect);
    }
    ABLoading.dismiss();
    ABRoute.pop(context: context);
  }

  logout() async {
    UserNet.logout();
    TIMUIKitCore.getInstance().logout();
    ABSharedPreferences.setTokenSync("");
    ABSharedPreferences.setUserIdSync("");
    ABSharedPreferences.setUserSignSync("");
    await ABRoute.popToRoot();
    ABRoute.pushReplacement(const StartPage(), tag: "root");
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).versionUpdate.replaceAll(':', ''),
        backgroundWidget: ColoredBox(
          color: theme.white,
          // 渐变色
        ),
        elevation: 0,
      ),
      backgroundColor: theme.white,
      body: Padding(
        padding: EdgeInsets.only(left: 25.px,right: 25.px,bottom: 25.px),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 55.px),
              child: LayoutBuilder(builder: (context, con) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      width: con.maxWidth,
                      height: con.maxWidth / 325 * 341,
                      child: Image.asset(
                        ABAssets.assetsVersionUpdateBg(context),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: con.maxWidth / 325 * 74,
                      child: ABText(
                        'version: $currentVersion',
                        fontSize: 14.px,
                        textColor: theme.textColor,
                      ),
                    )
                  ],
                );
              }),
            ),
            Column(
              children: [

                Spacer(),
                Builder(builder: (context) {
                  if (lastVersion == null) {
                    return SizedBox();
                  }
                  final language =
                      Provider.of<LanguageProvider>(context, listen: false)
                          .locale
                          .languageCode;
                  final isForce = lastVersion?.isForceUpdates == 2;
                  final content = (language.contains("zh")
                          ? lastVersion?.languageMsgCn
                          : lastVersion?.languageMsgUs) ??
                      "";
                  final version = lastVersion?.versionNum ?? "";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      Align(
                          alignment: Alignment.centerLeft,
                          child: ABText(
                            AB_getS(context).versionUpdate,
                            textColor: HexColor("#989897"),
                            fontSize: 16,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      // 更新内容
                      Text(
                        content,
                        style: TextStyle(
                            color: HexColor("#323333"), fontSize: 16),
                      ),
                    ],
                  );
                }),
                SizedBox(
                  height: 30.px,
                ),
                // 立即更新
                isLoading?SizedBox():ABButton.gradientColorButton(
                  colors: lastVersion==null?[theme.text999,theme.text999]:[theme.primaryColor, theme.secondaryColor],
                  cornerRadius: 12,
                  height: 48,
                  text: lastVersion==null?AB_getS(context).lastVersion:AB_getS(context).nowUpdate,
                  onPressed: () {
                    // Navigator.of(context).pop();
                    if(lastVersion==null){
                      ABToast.show(AB_getS(context).lastVersion);
                      return ;
                    }
                    if (Platform.isAndroid) {
                      AppUpdateWidget.downloadAndUpdate(
                          context, lastVersion?.downloadAddr ?? "");
                      // _showUpdateDialog(context);
                    } else {
                      AppUpdateWidget.launchUrl(
                          lastVersion?.downloadAddr ?? "");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

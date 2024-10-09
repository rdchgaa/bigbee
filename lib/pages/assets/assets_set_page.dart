import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_chat_set_page.dart';
import 'package:bee_chat/pages/assets/assets_language_page.dart';
import 'package:bee_chat/pages/assets/assets_notice_set_page.dart';
import 'package:bee_chat/pages/assets/assets_security_binding_page.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/chat/red_bag/red_bag_send_page.dart';
import 'package:bee_chat/pages/common/share_user_page.dart';
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
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class AssetsSetPage extends StatefulWidget {
  const AssetsSetPage({super.key});

  @override
  State<AssetsSetPage> createState() => _AssetsSetPageState();
}

class _AssetsSetPageState extends State<AssetsSetPage> {
  List<CoinModel> coinList = [];

  bool selectAll = false;

  List<CoinModel> selectedCoinList = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    // UserProvider provider = Provider.of<UserProvider>(
    //     MyApp.context,
    //     listen: false);

    final result = await AssetsNet.getCoinList();
    if (result.data != null && result.data!.isNotEmpty) {
      // provider.coinList = result.data!;
      coinList = result.data ?? [];

      selectedCoinList.clear();
      for (CoinModel item in coinList) {
        if (item.status == 1) {
          selectedCoinList.add(item);
        }
      }
      setState(() {});
    }
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
      final result = await AssetsNet.displayFunds(fundsName: item.coinName ?? "", switchCapital: isSelect);
    }
    ABLoading.dismiss();
    ABRoute.pop(context: context);
  }

  logout(
    String title,
    String content,
    String buttonCancel,
    String buttonOk,
  ) async {
    // var value = await showAlertDialog(
    //   context,
    //   title: AB_getS(context).logout,
    //   content: AB_getS(context).logoutTips,
    //   buttonCancel: AB_getS(context).cancel,
    //   buttonOk: AB_getS(context).confirm,
    // );
    var value = await showAlertDialog(
      context,
      title: title,
      content: content,
      buttonCancel: buttonCancel,
      buttonOk: buttonOk,
    );
    if (value == true) {
      UserNet.logout();
      TIMUIKitCore.getInstance().logout();
      ABSharedPreferences.setTokenSync("");
      ABSharedPreferences.setUserIdSync("");
      ABSharedPreferences.setUserSignSync("");
      await ABRoute.popToRoot();
      ABRoute.pushReplacement(const StartPage(), tag: "root");
    }
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
        title: AB_getS(context).setting,
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px, bottom: 12.px),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ABText(
                        AB_getS(context).systemSettings,
                        textColor: theme.text999,
                        fontSize: 14.px,
                      ),
                    ),
                  ),
                  // setButtonItem(ABAssets.assetsSet(context), '发红包', () {
                  //   ABRoute.push(RedBagSendPage());
                  // }),
                  setButtonItem(ABAssets.assetsSet(context), AB_getS(context).chatSettings, () {
                    ABRoute.push(AssetsChatSetPage());
                  }),
                  setButtonItem(ABAssets.assetsLanguage(context), AB_getS(context).language, () {
                    ABRoute.push(AssetsLanguagePage());
                    // LanguageProvider.changeLanguage( isZh ? const Locale("en") : const Locale("zh"));
                  }),
                  setButtonItem(ABAssets.assetsUpdate(context), AB_getS(context).versionUpdate.replaceAll(':', ''), () {
                    ABRoute.push(AssetsVersionUpdatePage());
                  }),
                  setButtonItem(ABAssets.assetsSafe(context), AB_getS(context).securityBinding, () {
                    ABRoute.push(AssetsSecurityBindingPage());
                  }),
                  setButtonItem(ABAssets.assetsNotice(context), AB_getS(context).notificationSettings, () {
                    ABRoute.push(AssetsNoticeSetPage());

                  },
                      showLine: false),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.px, right: 24.px, bottom: 24.px),
            child: Builder(builder: (context) {
              var logoutText = AB_getS(context).logout;
              var logoutTipsText = AB_getS(context).logoutTips;
              var cancelText = AB_getS(context).cancel;
              var confirmText = AB_getS(context).confirm;

              return InkWell(
                onTap: () {
                  logout(
                    logoutText,
                    logoutTipsText,
                    cancelText,
                    confirmText,
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.text999,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.px,
                    child: ABText(
                      AB_getS(context).logOutAccount,
                      textColor: theme.white,
                      fontSize: 15.px,
                      fontWeight: FontWeight.w600,
                    ).center,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget setButtonItem(String assets, String title, Function onTap, {bool showLine = true}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        child: ColoredBox(
          color: theme.backgroundColorWhite,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 56.px,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0.px, right: 12.px),
                          child: SizedBox(
                            width: 24.px,
                            height: 24.px,
                            child: Image.asset(
                              assets,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ABText(
                          title,
                          fontSize: 14.px,
                          textColor: theme.textColor,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.px),
                      child: Image.asset(
                        ABAssets.assetsRight(context),
                        width: 9.px,
                        height: 15.px,
                      ),
                    )
                  ],
                ),
              ),
              showLine
                  ? Padding(
                      padding: EdgeInsets.only(left: 16.0.px, right: 16.0.px),
                      child: Divider(
                        height: 1,
                        color: theme.backgroundColor,
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

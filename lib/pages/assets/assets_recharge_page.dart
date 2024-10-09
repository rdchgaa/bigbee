import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_language_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/assets/widget/select_coin_dialog.dart';
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
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'dart:math' as math;

class AssetsRechargePage extends StatefulWidget {
  const AssetsRechargePage({super.key});

  @override
  State<AssetsRechargePage> createState() => _AssetsRechargePageState();
}

class _AssetsRechargePageState extends State<AssetsRechargePage> {
  List<CoinModel> coinList = [];

  CoinModel? selectedCoin;

  bool showTip = false;

  String? rechargeAddress;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    // ABRoute.pageHistory.remove(AssetsRechargePage().routerName());
    super.dispose();
  }

  initData() async {
    final result = await AssetsNet.getCoinList();
    if (result.data != null && result.data!.isNotEmpty) {
      coinList = result.data ?? [];

      if (coinList.isNotEmpty) {
        selectedCoin = coinList[0];
        getAddress();
      }
      setState(() {});
    }
    alertTip();
  }

  getAddress() async {
    rechargeAddress = null;
    setState(() {
    });
    final result = await AssetsNet.assetsGetRechargeAddress(coinId: (selectedCoin?.id) ?? 0.toInt());
    if(result.data!=null){
      rechargeAddress = result.data?.rechargeAddress;
      setState(() {
      });
    }
  }

  alertTip() async {
    var value = await showAlertDialog(
      context,
      title: AB_S().KindTips,
      buttonOk: AB_S().confirm,
      contentWidget: SizedBox(
        width: 246.px,
        height: MediaQuery.of(context).size.height * 0.5,
        child: ListView(
          children: [
            Text(
              AB_S().KindTipsRecharge,
              style: TextStyle(fontSize: 14, color: AB_T().textColor),
            )
          ],
        ),
      ),
    );
  }

  selectCoin() async {
    var value = await showSelectCoinDialog(
      context,
      coinList: coinList,
    );
    if (value != null) {
      selectedCoin = value;
      setState(() {});
      getAddress();
    }
  }

  toShowTip() {
    showTip = true;
    setState(() {});
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        showTip = false;
        setState(() {});
      }
    });
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
        title: AB_getS(context).recharge,
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
        rightWidget: Padding(
          padding: EdgeInsets.only(right: 16.0.px),
          child: Center(
            child: InkWell(
                onTap: () async {
                  ABRoute.pushNotRepeat(context: context,const AssetsRecordPage(index: 0,));
                },
                child: Image.asset(
                  ABAssets.assetsRecords1(context),
                  width: 24.px,
                  height: 24.px,
                )),
          ),
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px, bottom: 12.px),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ABText(
                      AB_getS(context).selectCoin,
                      textColor: theme.text999,
                      fontSize: 14.px,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0.px, bottom: 10.0.px, left: 16.0.px, right: 16.0.px),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.white,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 14.px, left: 14.0.px, bottom: 12.px),
                          child: Row(
                            children: [
                              if (selectedCoin != null)
                                Padding(
                                  padding: EdgeInsets.only(right: 8.px),
                                  child: SizedBox(
                                    width: 24.px,
                                    height: 24.px,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: ABImage.imageWithUrl(
                                            // 'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png',
                                            selectedCoin?.url ?? '',
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                ),
                              ABText(
                                AB_getS(context).passCoin,
                                fontSize: 16.px,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0.px, right: 8.0.px, bottom: 6.px),
                          child: InkWell(
                            onTap: () {
                              selectCoin();
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.f4f4f4,
                                borderRadius: BorderRadius.all(Radius.circular(21.px)),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 42.px,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: selectedCoin == null
                                          ? ABText(
                                              '请选择',
                                              fontSize: 14,
                                              textColor: theme.textGrey,
                                            )
                                          : ABText(
                                              selectedCoin?.coinName ?? '',
                                              fontSize: 14,
                                              textColor: theme.textGrey,
                                            ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: Transform.rotate(
                                        angle: math.pi / 2,
                                        child: Image.asset(
                                          ABAssets.assetsRight(context),
                                          width: 9.px,
                                          height: 15.px,
                                          color: theme.text282109,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 16.px,),
                            Text("BSC/BEP20", style: TextStyle(color: theme.textGrey, fontSize: 14.px),)
                          ],
                        ),
                        SizedBox(height: 16.px)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox().expanded(flex: 2),
              if (rechargeAddress != null)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.white,
                    borderRadius: BorderRadius.all(Radius.circular(12.px)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.px),
                    child: QrImageView(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(6),
                      data: rechargeAddress ?? '',
                      // data: ABShare.getAppShareUrl(inviteCode: '111'),
                      size: 190.0.px,
                    ),
                  ),
                ),
              SizedBox(
                height: 8.px,
              ),
              if (selectedCoin != null)
                ABText(
                  AB_getS(context).scanRecharge,
                  textColor: theme.text999,
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                ),
              if (rechargeAddress != null) Padding(
                padding: EdgeInsets.only(bottom: 16.px),
                child: ABText(
                  rechargeAddress!,
                  textColor: theme.text999,
                  fontSize: 14.px,
                ),
              ),
              SizedBox().expanded(flex: 2),
              if (rechargeAddress != null)
                Padding(
                  padding: EdgeInsets.only(
                    left: 24.px,
                    right: 24.px,
                  ),
                  child: ABButton.gradientColorButton(
                    colors: [theme.primaryColor, theme.secondaryColor],
                    cornerRadius: 12,
                    height: 48,
                    text: AB_getS(context).copyRechargeAddress,
                    textColor: theme.textColor,
                    onPressed: () async {
                      final ClipboardData clipboardData = ClipboardData(text: rechargeAddress??'');
                      await Clipboard.setData(clipboardData);
                      toShowTip();
                    },
                  ),
                ),
              SizedBox().expanded(flex: 2),
            ],
          ),
          if (showTip) copyTipView(),
        ],
      ),
    );
  }

  Widget copyTipView() {
    final theme = AB_theme(context);
    return DecoratedBox(
      decoration: BoxDecoration(color: theme.white.withOpacity(0.8)),
      child: SizedBox(
        width: 224.px,
        height: 83.px,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24.px,
              height: 24.px,
              child: Image.asset(
                ABAssets.copyOk(context),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 5.px,
            ),
            ABText(
              AB_getS(context).copiedClipboardSuccessfully,
              textColor: theme.textColor,
              fontSize: 16.px,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AssetsAddCoinPage extends StatefulWidget {
  const AssetsAddCoinPage({super.key});

  @override
  State<AssetsAddCoinPage> createState() => _AssetsAddCoinPageState();
}

class _AssetsAddCoinPageState extends State<AssetsAddCoinPage> {
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
      final result = await AssetsNet.displayFunds(
          fundsName: item.coinName ?? "", switchCapital: isSelect);
    }
    ABLoading.dismiss();
    ABRoute.pop(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).editAssets,
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
              onTap: () {
                _submit();
              },
              child: SizedBox(
                child: ABText(
                  AB_getS(context).completed,
                  fontSize: 16.px,
                  textColor: theme.text282109,
                ),
              ),
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
                    padding: EdgeInsets.only(
                        left: 16.px, right: 16.px, top: 26.px, bottom: 16.px),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ABText(
                          AB_getS(context).coinPair,
                          textColor: theme.text999,
                          fontSize: 14.px,
                        ),
                      ],
                    ),
                  ),
                  coinListWidget()
                ],
              ),
            ),
          ),
          ColoredBox(
            color: theme.backgroundColorWhite,
            child: SizedBox(
              width: double.infinity,
              height: 92.px,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 17.0.px, right: 12.px),
                    child: InkWell(
                      onTap: () {
                        if (selectedCoinList.length == coinList.length) {
                          selectedCoinList = [];
                        } else {
                          selectedCoinList = [];
                          selectedCoinList.addAll(coinList);
                        }
                        setState(() {});
                      },
                      child: Image.asset(
                        selectedCoinList.length == coinList.length
                            ? ABAssets.assetsSelect(context)
                            : ABAssets.assetsUnSelect(context),
                        width: 24.px,
                        height: 24.px,
                      ),
                    ),
                  ),
                  ABText(
                    AB_getS(context).selectAll,
                    textColor: theme.textColor,
                    fontSize: 16.px,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget coinListWidget() {
    final theme = AB_theme(context);
    List<Widget> coinListBuild = [];
    for (var i = 0; i < coinList.length; i++) {
      CoinModel item = coinList[i];
      coinListBuild.add(SizedBox(
        child: ColoredBox(
          color: theme.backgroundColorWhite,
          child: SizedBox(
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
                        width: 40.px,
                        height: 40.px,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: ABImage.imageWithUrl(
                                // 'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png',
                                item.url ?? "",
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    ),
                    ABText(item.coinName ?? "", fontSize: 16.px),
                  ],
                ),
                Builder(builder: (context) {
                  var isSelect = false;
                  for (CoinModel selectedCoinListItem in selectedCoinList) {
                    if (selectedCoinListItem.id == item.id) {
                      isSelect = true;
                      break;
                    }
                  }
                  return Padding(
                    padding: EdgeInsets.only(right: 16.px),
                    child: InkWell(
                      onTap: () {
                        if (isSelect) {
                          selectedCoinList.remove(item);
                        } else {
                          selectedCoinList.add(item);
                        }
                        setState(() {});
                      },
                      child: Image.asset(
                        isSelect
                            ? ABAssets.assetsSelect(context)
                            : ABAssets.assetsUnSelect(context),
                        width: 24.px,
                        height: 24.px,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ));
    }
    return Column(
      children: coinListBuild,
    );
  }
}

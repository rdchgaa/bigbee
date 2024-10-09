import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/pages/assets/assets_add_coin_page.dart';
import 'package:bee_chat/pages/assets/assets_recharge_page.dart';
import 'package:bee_chat/pages/assets/assets_record_coin_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/assets_transfer_page.dart';
import 'package:bee_chat/pages/assets/assets_withdrawal_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
// import 'package:plugin_six2/open.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class AssetsCustodyWalletWidget extends StatefulWidget {
  const AssetsCustodyWalletWidget({super.key});

  @override
  State<AssetsCustodyWalletWidget> createState() => _AssetsCustodyWalletWidgetState();
}

class _AssetsCustodyWalletWidgetState extends State<AssetsCustodyWalletWidget> {
  FundsModel? _funds;

  List<GlobalKey<AssetsCustodyWalletAssetsItemState>> keys = [];

  bool showBalance = true;

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
    final result = await AssetsNet.getFunds();
    if (result.data != null) {
      _funds = result.data!;
      keys.clear();
      keys = [];
      for (var item in _funds?.coinCapitalList ?? []) {
        keys.add(GlobalKey());
      }
      setState(() {});
    }
  }

  displayFunds(String fundsName) async {
    // for (var key in keys) {
    //   key.currentState?.scrollToTop();
    // }
    final result = await AssetsNet.displayFunds(fundsName: fundsName, switchCapital: false);
    initData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return ColoredBox(
      color: theme.backgroundColor,
      child: EasyRefresh(
        header: CustomizeBallPulseHeader(color: theme.primaryColor),
        onRefresh: () async {
          initData();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [walletView(), assetsList()],
          ),
        ),
      ),
    );
  }

  Widget walletView() {
    final theme = AB_theme(context);
    var buttonWidth = (ABScreen.width - 16.px * 4) / 3;
    return Padding(
      padding: EdgeInsets.only(top: 26.0.px),
      child: ColoredBox(
        color: theme.backgroundColorWhite,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 16.0.px,
                left: 16.px,
                right: 16.px,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ABText(AB_getS(context).totalBalance + ' (USTD)',
                          fontWeight: FontWeight.w600, textColor: theme.text999, fontSize: 16.px),
                      SizedBox(
                        height: 12.px,
                      ),
                      Builder(builder: (context) {
                        var value = _funds?.totalAmountToUSDT ?? '0';
                        if (value.contains('.')) {
                          if (value.length >= value.indexOf('.') + 7) {
                            value = value.substring(0, value.indexOf('.') + 7);
                          }
                        }
                        return ABText(value, fontWeight: FontWeight.w600, textColor: theme.textColor, fontSize: 28.px);
                      }),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      await ABRoute.pushNotRepeat(context: context, AssetsRecordPage());
                      initData();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 6.0.px),
                      child: Image.asset(
                        ABAssets.assetsRecord(context),
                        width: 28.px,
                        height: 28.px,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22.0.px, left: 16.px, right: 16.px, bottom: 20.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await ABRoute.pushNotRepeat(context: context, AssetsRechargePage());
                      initData();
                      // await ABRoute.push(context: context,AssetsRechargePage());
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SizedBox(
                        width: buttonWidth,
                        height: 42.px,
                        child: ABText(
                          AB_getS(context).recharge,
                          textColor: theme.textColor,
                          fontSize: 15.px,
                        ).center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await ABRoute.pushNotRepeat(context: context, AssetsWithdrawalPage());
                      initData();
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SizedBox(
                        width: buttonWidth,
                        height: 42.px,
                        child: ABText(
                          AB_getS(context).withdrawal,
                          textColor: theme.textColor,
                          fontSize: 15.px,
                        ).center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await ABRoute.pushNotRepeat(context: context, AssetsTransferPage());
                      initData();
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.e9e9e9,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SizedBox(
                        width: buttonWidth,
                        height: 42.px,
                        child: ABText(
                          AB_getS(context).transfer,
                          textColor: theme.textColor,
                          fontSize: 15.px,
                        ).center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget walletView() {
  //   final theme = AB_theme(context);
  //   var buttonWidth = (ABScreen.width - 16.px * 4) / 3;
  //   return Padding(
  //     padding: EdgeInsets.only(
  //       top: 16.0.px,
  //       left: 16.px,
  //       right: 16.px,
  //     ),
  //     child: DecoratedBox(
  //       decoration: BoxDecoration(
  //         color: theme.backgroundColorWhite,
  //         borderRadius: BorderRadius.all(Radius.circular(6.px)),
  //       ),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding:
  //                 EdgeInsets.only(top: 18.0.px, left: 16.px),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Builder(
  //                       builder: (context) {
  //                         var value = (_funds?.totalAmountToUSDT ?? '0');
  //                         if(!showBalance){
  //                           var length = value.length;
  //
  //                           String xing = '';
  //                           for (var i = 0 ;i<length;i++){
  //                             xing = '$xing*';
  //                           }
  //                           value = xing;
  //                         }
  //                         return ABText('\$ ' +value,
  //                             fontWeight: FontWeight.w600,
  //                             textColor: theme.textColor,
  //                             fontSize: 32.px);
  //                       }
  //                     ),
  //                     SizedBox(
  //                       width: 6.px,
  //                     ),
  //                     InkWell(
  //                       onTap: () {
  //                         // ABRoute.push(AssetsRecordPage());
  //                         setState(() {
  //                           showBalance = !showBalance;
  //                         });
  //                       },
  //                       child: Image.asset(
  //                         ABAssets.assetsEye(context),
  //                         width: 24.px,
  //                         height: 24.px,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     // ABRoute.push(AssetsRecordPage());
  //                   },
  //                   child: DecoratedBox(
  //                     decoration: BoxDecoration(
  //                         gradient: LinearGradient(colors: [
  //                           theme.primaryColor,
  //                           theme.secondaryColor
  //                         ]),
  //                         borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(18.px),
  //                             bottomLeft: Radius.circular(18.px))),
  //                     child: Padding(
  //                       padding: EdgeInsets.only(left: 16.0.px, right: 16.px),
  //                       child: SizedBox(
  //                         height: 36.px,
  //                         child: Row(
  //                           children: [
  //                             Image.asset(
  //                               ABAssets.assetsWatleLock(context),
  //                               width: 16.px,
  //                               height: 16.px,
  //                             ),
  //                             Padding(
  //                               padding: EdgeInsets.only(left: 4.0.px),
  //                               child: ABText(
  //                                 AB_getS(context).observeWallet,
  //                                 textColor: theme.white,
  //                                 fontSize: 14.px,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(
  //                 top: 22.0.px, left: 16.px, right: 16.px, bottom: 18.px),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 InkWell(
  //                   onTap: () {},
  //                   child: Column(
  //                     children: [
  //                       Image.asset(
  //                         ABAssets.assetsShao(context),
  //                         width: 56.px,
  //                         height: 56.px,
  //                       ),
  //                       SizedBox(height: 7.px,),
  //                       ABText(
  //                         AB_getS(context).scan,
  //                         textColor: theme.textColor,
  //                         fontSize: 14.px,
  //                       ).center,
  //                     ],
  //                   ),
  //                 ),
  //                 InkWell(
  //                   onTap: () {},
  //                   child: Column(
  //                     children: [
  //                       Image.asset(
  //                         ABAssets.assetsSend(context),
  //                         width: 56.px,
  //                         height: 56.px,
  //                       ),
  //                       SizedBox(height: 7.px,),
  //                       ABText(
  //                         AB_getS(context).send,
  //                         textColor: theme.textColor,
  //                         fontSize: 14.px,
  //                       ).center,
  //                     ],
  //                   ),
  //                 ),
  //                 InkWell(
  //                   onTap: () {},
  //                   child: Column(
  //                     children: [
  //                       Image.asset(
  //                         ABAssets.assetsDownload(context),
  //                         width: 56.px,
  //                         height: 56.px,
  //                       ),
  //                       SizedBox(height: 7.px,),
  //                       ABText(
  //                         AB_getS(context).collectionPayments,
  //                         textColor: theme.textColor,
  //                         fontSize: 14.px,
  //                       ).center,
  //                     ],
  //                   ),
  //                 ),
  //                 InkWell(
  //                   onTap: () {},
  //                   child: Column(
  //                     children: [
  //                       Image.asset(
  //                         ABAssets.assetsHistory(context),
  //                         width: 56.px,
  //                         height: 56.px,
  //                       ),
  //                       SizedBox(height: 7.px,),
  //                       ABText(
  //                         AB_getS(context).history,
  //                         textColor: theme.textColor,
  //                         fontSize: 14.px,
  //                       ).center,
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget assetsList() {
    final theme = AB_theme(context);
    List<Widget> assetsList = [];

    for (var i = 0; i < (_funds?.coinCapitalList ?? []).length; i++) {
      FundsCoinCapitalList? item = _funds?.coinCapitalList[i];
      if (item?.isItDisplayed == 1) {
        assetsList.add(AssetsCustodyWalletAssetsItem(
          key: keys[i],
          coinCapital: item!,
          callback: () {
            displayFunds(item.coinName);
          },
          onTap: () {
            ABRoute.pushNotRepeat(
                context: context,
                AssetsRecordCoinPage(
                  index: 0,
                  coinId: UserProvider.getCoinInfo(item.coinName)?.id ?? 0,
                  coinName: item.coinName,
                ));
          },
        ));
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: 20.px),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.px, right: 15.px, top: 5.px, bottom: 5.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ABText(
                  AB_getS(context).assets,
                  fontWeight: FontWeight.w600,
                  textColor: theme.textColor,
                  fontSize: 20.px,
                ),
                InkWell(
                  onTap: () async {
                    await ABRoute.push(AssetsAddCoinPage());
                    initData();
                  },
                  child: Image.asset(
                    ABAssets.homeAddIcon(context),
                    width: 28.px,
                    height: 28.px,
                  ),
                )
              ],
            ),
          ),
          Column(
            children: assetsList,
          )
        ],
      ),
    );
  }
}

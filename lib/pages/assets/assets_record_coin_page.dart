import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/assets_recharge_record_view.dart';
import 'package:bee_chat/pages/assets/widget/assets_transfer_record_view.dart';
import 'package:bee_chat/pages/assets/widget/assets_withdrawal_record_view.dart';
import 'package:bee_chat/pages/assets/widget/asstes_record_activity_view.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class AssetsRecordCoinPage extends StatefulWidget {
  final int? index;
  final int? coinId;
  final String? coinName;
  const AssetsRecordCoinPage({super.key, this.index, this.coinId, this.coinName});

  @override
  State<AssetsRecordCoinPage> createState() => _AssetsRecordCoinPageState();
}

class _AssetsRecordCoinPageState extends State<AssetsRecordCoinPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 4, vsync: this,initialIndex: widget.index??0);
    super.initState();
  }

  @override
  void dispose() {
    // ABRoute.pageHistory.remove(AssetsRecordCoinPage().routerName());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    bool isDarkMode = brightness == Brightness.dark;
    final Color titleColor = isDarkMode ? Colors.white : Colors.black;
    final theme = AB_theme(context);
    final backBtnW = 24.0 + 16.px;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(ABAssets.assetsRecordHead(context)), fit: BoxFit.fill)),
            child: SizedBox(
              width: double.infinity,
              // height: 164.px,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: backBtnW,
                            child: IconButton(
                              onPressed: () async {
                                ABRoute.pop(context: context);
                              },
                              tooltip: 'Back',
                              padding: EdgeInsets.only(left: 16.px),
                              icon: Icon(
                                CupertinoIcons.arrow_left,
                                color: titleColor,
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              var title = AB_getS(context).assetsRecord;
                              if(widget.coinName!=null){
                                title = title+' '+ widget.coinName!;
                              }
                              return Center(
                                child: ABText(
                                  title,
                                  textColor: theme.textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              );
                            }
                          ),
                          SizedBox(
                            width: backBtnW,
                          )
                        ],
                      ),
                      SizedBox(height: 8.px,),
                      SizedBox(
                        height: 48.px,
                        child: TabBar(
                          padding: EdgeInsets.zero,
                          controller: controller,
                          // isScrollable: true,
                          labelPadding: EdgeInsets.only(left: 5, right: 5),
                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.px, color: theme.textColor),
                          unselectedLabelColor: hexToColor("282109").withOpacity(0.7),
                          unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.normal, fontSize: 14.px, color: theme.text282109),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: theme.black,
                          // indicator: BoxDecoration(color: theme.black),
                          indicatorPadding: EdgeInsets.only(
                            left: 10.px,
                            right: 10.px,
                          ),
                          tabs: [
                            Tab(text: AB_getS(context).rechargeRecord),
                            Tab(text: AB_getS(context).withdrawalRecord),
                            Tab(text: AB_getS(context).transferRecord),
                            Tab(text: AB_getS(context).redEnvelope),
                          ],
                        ),
                      ),
                    ],
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(12.px), topRight: Radius.circular(12.px))),
                    child: SizedBox(
                      width: double.infinity,
                      height: 12.px,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  AssetsRechargeRecordView(coinId: widget.coinId,),
                  AssetsWithdrawalRecordView(coinId: widget.coinId,),
                  AssetsTransferRecordView(coinId: widget.coinId,),
                  AsstesRecordActivityView(coinId: widget.coinId,flowType: FlowType.package,),
                ],
              )
          ),
        ],
      ),
    );
  }
}
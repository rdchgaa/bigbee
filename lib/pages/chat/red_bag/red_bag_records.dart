import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/assets/payouts_set_model.dart';
import 'package:bee_chat/models/group/group_member_list_model.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_list_model.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_total_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_setting_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/red_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_language_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/assets/widget/input_google_code_dialog.dart';
import 'package:bee_chat/pages/assets/widget/select_coin_dialog.dart';
import 'package:bee_chat/pages/chat/red_bag/red_bag_group_member_list_page.dart';
import 'package:bee_chat/pages/common/share_user_page.dart';
import 'package:bee_chat/pages/dialog/select_year_dialog.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/group/group_member_list_page.dart';
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
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'dart:math' as math;

import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class RedBagRecords extends StatefulWidget {
  const RedBagRecords({
    super.key,
  });

  @override
  State<RedBagRecords> createState() => _RedBagRecordsState();
}

class _RedBagRecordsState extends State<RedBagRecords> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    // ABRoute.pageHistory.remove(AssetsWithdrawalPage().routerName());
    super.dispose();
  }

  initData() async {
    final result = await AssetsNet.getCoinList();
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
        // title: AB_getS(context).sendRedBag,
        customTitleAlignment: Alignment.bottomCenter,
        customTitle: SizedBox(
          width: 200,
          height: 48.px,
          child: TabBar(
            padding: EdgeInsets.zero,
            controller: controller,
            // isScrollable: true,
            labelPadding: EdgeInsets.only(left: 5, right: 5),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.px, color: theme.textColor),
            unselectedLabelColor: hexToColor("282109").withOpacity(0.7),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.px, color: theme.text282109),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: theme.black,
            // indicator: BoxDecoration(color: theme.black),
            indicatorPadding: EdgeInsets.only(
              left: 10.px,
              right: 10.px,
            ),
            tabs: [
              Tab(text: AB_getS(context).received),
              Tab(text: AB_getS(context).issue),
            ],
          ),
        ),
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
              child: TabBarView(
            controller: controller,
            children: const [
              RedBagRecordsView(
                type: 1,
              ),
              RedBagRecordsView(
                type: 2,
              )
            ],
          )),
        ],
      ),
    );
  }
}

class RedBagRecordsView extends StatefulWidget {
  final int type; //1:收到   2：发出

  const RedBagRecordsView({
    super.key,
    required this.type,
  });

  @override
  State<RedBagRecordsView> createState() => _RedBagRecordsViewState();
}

class _RedBagRecordsViewState extends State<RedBagRecordsView> with AutomaticKeepAliveClientMixin {
  int year = DateTime.now().year;
  List<CoinModel> coinList = [];
  CoinModel? selectedCoin;

  GetRedPacketTotalModel? redTotal;
  List<GetRedPacketListRecords> recordsList = [];
  int pageNum = 1;

  bool hasMore = true;

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
    final result = await AssetsNet.getCoinList();
    if (result.data != null && result.data!.isNotEmpty) {
      coinList = result.data ?? [];

      if (coinList.isNotEmpty) {
        selectedCoin = coinList[0];
        setState(() {});
        getTotalData();
        onFresh();
      }
      setState(() {});
    }
  }

  getTotalData() async {
    var resultRed =
        await RedNet.redGetRedPacket(type: widget.type, years: '$year-01-01', coinId: selectedCoin?.id ?? 0);
    if (resultRed.data != null) {
      redTotal = resultRed.data;
      setState(() {});
    }
  }

  onFresh() async {
    pageNum = 1;
    hasMore = true;
    setState(() {
    });
    var resultRecords = await RedNet.redGetRedPacketList(
        type: widget.type, years: '$year-01-01', coinId: selectedCoin?.id ?? 0, pageNum: pageNum);
    if (resultRecords.data != null) {
      recordsList = resultRecords.data?.records ?? [];
      if (recordsList.length >= (resultRecords.data?.total ?? 0)) {
        hasMore = false;
      }
      setState(() {});
    }
  }

  onMore() async {
    pageNum+= 1;
    setState(() {
    });
    var resultRecords = await RedNet.redGetRedPacketList(
        type: widget.type, years: '$year-01-01', coinId: selectedCoin?.id ?? 0, pageNum: pageNum);
    if (resultRecords.data != null) {
      recordsList.addAll(resultRecords.data?.records ?? []);
      if (recordsList.length >= (resultRecords.data?.total ?? 0)) {
        hasMore = false;
      }
      setState(() {});
    }
  }

  selectCoin() async {
    var value = await showSelectCoinDialog(
      context,
      coinList: coinList,
    );
    if (value != null) {
      selectedCoin = value;
      setState(() {});
      getTotalData();
      onFresh();
    }
  }

  selectYear() async {
    List<int> list = [];
    for (var i = 0; i < 10; i++) {
      list.add(DateTime.now().year - i);
    }
    var value = await showSelectYearDialog(
      context,
      list: list,
    );
    if (value != null) {
      year = value;
      setState(() {});
      getTotalData();
      onFresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.px, bottom: 10.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    selectYear();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.px, bottom: 5.px, left: 10.px, right: 0.px),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ABText(
                          year.toString(),
                          fontSize: 14.px,
                          textColor: theme.text999,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5.px,
                          ),
                          child: Image.asset(
                            ABAssets.assetsPeopleNum(context),
                            width: 24.px,
                            height: 24.px,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.px, bottom: 5.px, left: 10.px, right: 10.px),
                  child: InkWell(
                    onTap: () {
                      selectCoin();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (selectedCoin != null)
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.px, right: 5.px),
                            child: SizedBox(
                              width: 18.px,
                              height: 18.px,
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
                        if (selectedCoin != null)
                          ABText(
                            selectedCoin?.coinName ?? '',
                            fontSize: 14.px,
                            textColor: theme.text999,
                          ),
                        if (selectedCoin == null)
                          ABText(
                            AB_getS(context).pleaseSelect,
                            fontSize: 14.px,
                            textColor: theme.text999,
                          ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5.px,
                          ),
                          child: Image.asset(
                            ABAssets.assetsPeopleNum(context),
                            width: 24.px,
                            height: 24.px,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: EasyRefresh(
            header: CustomizeBallPulseHeader(color: theme.primaryColor),
            onRefresh: () async {
              getTotalData();
              onFresh();
            },
            onLoad: !hasMore
                ? null
                : () async {
                    onMore();
                  },
            child: redTotal==null&&recordsList.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    color: theme.backgroundColor,
                    child: Image.asset(ABAssets.emptyIcon(context)),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        if (redTotal != null) {
                          return SizedBox(
                            child: Column(
                              children: [
                                SizedBox(height: 50.px),
                                SizedBox(
                                  width: 88.px,
                                  height: 88.px,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: ABImage.imageWithUrl(redTotal!.avatarUrl,
                                            fit: BoxFit.cover, width: 56.px, height: 56.px)),
                                  ),
                                ),
                                SizedBox(height: 12.px),
                                ABText(
                                  widget.type == 1
                                      ? AB_getS(context).accumulatedReceipts
                                      : AB_getS(context).accumulatedIssuance,
                                  fontSize: 14.px,
                                  textColor: theme.text999,
                                ),
                                SizedBox(height: 12.px),
                                ABText(
                                  redTotal!.qty.toString(),
                                  fontSize: 24.px,
                                  textColor: theme.text282109,
                                ),
                                SizedBox(height: 36.px),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      }
                      GetRedPacketListRecords item = recordsList[index - 1];
                      DateTime? time = DateTime.tryParse(item.createTime) ?? null;
                      var timeString = '';

                      final isZh = languageProvider.locale.languageCode.contains("zh");
                      if (time != null) {
                        timeString = '${time.month}${isZh ? "月" : "Month"}${time.day}${isZh ? "日" : "Day"}';
                      }
                      return ColoredBox(
                        color: theme.white,
                        child: SizedBox(
                          width: double.infinity,
                          height: 80.px,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.px, right: 16.px),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 56.px,
                                        height: 56.px,
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: ABImage.imageWithUrl(item.avatarUrl ?? '',
                                                  fit: BoxFit.cover, width: 56.px, height: 56.px)),
                                        ),
                                      ),
                                      Expanded(
                                        child: LayoutBuilder(builder: (context, con) {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 14.0.px),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ABText(item.qty.toString(),
                                                    textColor: theme.textColor, fontSize: 16.px),
                                                SizedBox(
                                                  height: 3.px,
                                                ),
                                                SizedBox(
                                                  width: con.maxWidth,
                                                  height: 20.px,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        ABText(
                                                          (item.nickName),
                                                          textColor: theme.text999,
                                                          fontSize: 14.px,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                                ABText(
                                  timeString,
                                  textColor: theme.text999,
                                  fontSize: 12.px,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox();
                    },
                    itemCount: recordsList.length + 1),
          ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/assets/payouts_set_model.dart';
import 'package:bee_chat/models/group/group_member_list_model.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_list_model.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_total_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_detail_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_get_receivers_model.dart';
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

class RedBagDetailsPage extends StatefulWidget {
  final int redPacketId;

  const RedBagDetailsPage({
    super.key,
    required this.redPacketId,
  });

  @override
  State<RedBagDetailsPage> createState() => _RedBagDetailsPageState();
}

class _RedBagDetailsPageState extends State<RedBagDetailsPage> with SingleTickerProviderStateMixin {
  List<CoinModel> coinList = [];
  CoinModel? selectedCoin;

  List<RedPacketGetReceiversRecords> recordsList = [];
  int pageNum = 1;

  bool hasMore = false;

  ///
  RedPacketDetailModel? detail;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    getTotalData();
    onFresh();
  }

  getTotalData() async {
    var resultRed = await RedNet.redRedPacketDetail(redPacketId: widget.redPacketId);
    if (resultRed.data != null) {
      detail = resultRed.data;
      setState(() {});
    }
  }

  onFresh() async {
    pageNum = 1;
    setState(() {});
    var resultRecords = await RedNet.redGetReceivers(redPacketId: widget.redPacketId, pageNum: pageNum);
    if (resultRecords.data != null) {
      recordsList = resultRecords.data?.records ?? [];
      hasMore = recordsList.length < (resultRecords.data?.total ?? 0);
      setState(() {});
    }
  }

  onMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await RedNet.redGetReceivers(redPacketId: widget.redPacketId, pageNum: pageNum);
    if (resultRecords.data != null) {
      recordsList.addAll(resultRecords.data?.records ?? []);
      hasMore = recordsList.length < (resultRecords.data?.total ?? 0);
      setState(() {});
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
        // title: AB_getS(context).sendRedBag,
        customTitleAlignment: Alignment.bottomCenter,
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
      body: SizedBox(
        child: Column(
          children: [
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
              child: detail == null && recordsList.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      color: theme.backgroundColor,
                      child: Image.asset(ABAssets.emptyIcon(context)),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          if (detail != null) {
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
                                          child: ABImage.imageWithUrl(detail!.avatarUrl,
                                              fit: BoxFit.cover, width: 56.px, height: 56.px)),
                                    ),
                                  ),
                                  SizedBox(height: 12.px),
                                  ABText(
                                    (detail?.nickName ?? '') + (isZh ? '-发出的红包' : '- Red envelope issued'),
                                    fontSize: 14.px,
                                    textColor: theme.text999,
                                  ),
                                  SizedBox(height: 12.px),
                                  ABText(
                                    detail!.title.toString(),
                                    fontSize: 24.px,
                                    textColor: theme.text282109,
                                  ),
                                  SizedBox(height: 36.px),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 16.0.px),
                                        child: ABText(
                                          detail!.number.toString() +
                                              (isZh ? '个红包共 ' : 'red envelopes totaling') +
                                              detail!.qty.toString() +
                                              detail!.coinName.toString(),
                                          fontSize: 14.px,
                                          textColor: theme.text999,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 16.0.px),
                                        child: ABText(
                                          (isZh ? '已领取 ' : 'Received ') +
                                              detail!.receiveNumber.toString() +
                                              ' /' +
                                              detail!.number.toString(),
                                          fontSize: 14.px,
                                          textColor: theme.text999,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.px),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        }
                        RedPacketGetReceiversRecords item = recordsList[index - 1];
                        DateTime? time = DateTime.tryParse(item.receiveTime) ?? null;
                        var timeString = '';

                        if (time != null) {
                          timeString =
                              '${time.month}-${time.day >= 10 ? time.day : ('0' + time.day.toString())} ${time.hour >= 10 ? time.hour : ('0' + time.hour.toString())}:${time.minute >= 10 ? time.minute : ('0' + time.minute.toString())}';
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
      ),
    );
  }
}

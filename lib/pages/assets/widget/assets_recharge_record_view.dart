import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/funds_details_record_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/assets/recharge_records_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/pages/assets/assets_add_coin_page.dart';
import 'package:bee_chat/pages/assets/assets_recharge_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/asstes_record_activity_item.dart';
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
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class AssetsRechargeRecordView extends StatefulWidget {
  final int? coinId;
  const AssetsRechargeRecordView({super.key, this.coinId});

  @override
  State<AssetsRechargeRecordView> createState() => _AssetsRechargeRecordViewState();
}

class _AssetsRechargeRecordViewState extends State<AssetsRechargeRecordView> with AutomaticKeepAliveClientMixin {
  int _pageNum = 1;

  List<RechargeRecordsRecords> records = [];

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
    _pageNum = 1;

    final result = await AssetsNet.assetsGetReChargeList(
      pageNum: _pageNum,
      coinId: widget.coinId
    );
    if (result.data != null) {
      records = result.data?.records ?? [];
    }
    if (records.length >= (result.data?.total ?? 0)) {
      hasMore = false;
    }
    setState(() {});
  }

  onLoad() async {
    _pageNum = _pageNum + 1;
    final result = await AssetsNet.assetsGetReChargeList(
      pageNum: _pageNum,
        coinId: widget.coinId
    );
    if (result.data != null) {
      records.addAll(result.data?.records ?? []);
    }
    if (records.length >= (result.data?.total ?? 0)) {
      hasMore = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    final theme = AB_theme(context);

    return Column(
      children: [
        Expanded(child: recordsListView()),
      ],
    );
  }

  Widget recordsListView() {
    final theme = AB_theme(context);
    return EasyRefresh(
      header: CustomizeBallPulseHeader(color: theme.primaryColor),
      onRefresh: () async {
        initData();
      },
      onLoad: !hasMore
          ? null
          : () async {
              onLoad();
            },
      child: records.isEmpty
          ? Container(
              alignment: Alignment.center,
              color: theme.backgroundColor,
              child: Image.asset(ABAssets.emptyIcon(context)),
            )
          : ListView.separated(
              // physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 8.px, bottom: 18.px),
              itemBuilder: (context, index) {
                return AsstesRechargeRecordItem(record: records[index]);
              },
              itemCount: records.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 16  .px,
                );
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AsstesRechargeRecordItem extends StatefulWidget {
  final RechargeRecordsRecords record;

  const AsstesRechargeRecordItem({super.key, required this.record});

  @override
  State<AsstesRechargeRecordItem> createState() => _AsstesRechargeRecordItemState();
}

class _AsstesRechargeRecordItemState extends State<AsstesRechargeRecordItem> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {}

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    final theme = AB_theme(context);

    DateTime time = DateTime.parse(widget.record.rechargeTime);
    return Padding(
      padding: EdgeInsets.only(left: 16.0.px, right: 16.px),
      child: Row(
        children: [
          SizedBox(
            width: 83.px - 16.px,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ABText(
                  singleTimeToString(time.day),
                  textColor: theme.textColor,
                  fontSize: 18.px,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: 4.px,
                ),
                ABText(
                  '${time.year}.' + singleTimeToString(time.month),
                  textColor: theme.text999,
                  fontSize: 14.px,
                )
              ],
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(color: theme.white, borderRadius: BorderRadius.all(Radius.circular(6.px))),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 13.px,
                      bottom: 14.px,
                      left: 14.px,
                    ),
                    child: Column(
                      children: [
                        ///类型
                        Padding(
                          padding: EdgeInsets.only(bottom: 0.0.px),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Builder(builder: (context) {
                                var text = widget.record.coinName;
                                return ABText(
                                  text,
                                  textColor: theme.textColor,
                                  fontSize: 16.px,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0.px),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Color(0xffFFE394).withOpacity(0.16),
                                      borderRadius: BorderRadius.all(Radius.circular(6.px))),
                                  child: SizedBox(
                                    height: 22.px,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.px, right: 8.px),
                                      child: Center(
                                        child: ABText(
                                          singleTimeToString(time.hour) +
                                              '.' +
                                              singleTimeToString(time.minute) +
                                              '.' +
                                              singleTimeToString(time.second),
                                          textColor: Color(0xffFC9C10),
                                          fontSize: 12.px,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        LayoutBuilder(
                            builder: (context,con) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 11.px),
                                  child: Image.asset(ABAssets.assetsRechargeList(context),width: 24.px,height: 46.px),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: con.maxWidth-35.px,
                                      child: Padding(
                                        padding: EdgeInsets.only(left:10.px,top: 8.0.px, right: 14.px),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ABText(
                                              AB_getS(context).rechargeAmount,
                                              textColor: theme.text999,
                                              fontSize: 12.px,
                                            ),
                                            Builder(
                                              builder: (context) {
                                                var text = widget.record.rechargeAmount.toString()+widget.record.coinName;
                                                if(text.length>10){
                                                  text = text.substring(0,10)+widget.record.coinName;
                                                }
                                                return Padding(
                                                  padding: EdgeInsets.only(left: 8.0.px),
                                                  child: ABText(
                                                    text,
                                                    textColor: theme.textColor,
                                                    fontSize: 13.px,
                                                  ),
                                                );
                                              }
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: con.maxWidth-35.px,
                                      child: Padding(
                                        padding: EdgeInsets.only(left:10.px,top: 3.0.px, right: 14.px),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ABText(
                                              AB_getS(context).amountReceived,
                                              textColor: theme.text999,
                                              fontSize: 12.px,
                                            ),
                                            Builder(
                                              builder: (context) {
                                                var text = widget.record.arrivedAmount.toString()+widget.record.coinName;
                                                if(text.length>10){
                                                  text = text.substring(0,10)+widget.record.coinName;
                                                }
                                                return Padding(
                                                  padding: EdgeInsets.only(left: 8.0.px),
                                                  child: ABText(
                                                    text,
                                                    textColor: theme.textColor,
                                                    fontSize: 13.px,
                                                  ),
                                                );
                                              }
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        ),

                        SizedBox(height: 12.px,),
                        LayoutBuilder(
                            builder: (context,con) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Dash(direction: Axis.horizontal, length: con.maxWidth - 14, dashColor: theme
                                  .textGrey.withOpacity(0.5),
                                dashLength: 3,),
                            );
                          }
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:10.px,right: 14.0.px),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ABText(
                                    AB_S().totalPaid,
                                    textColor: theme.text999,
                                    fontSize: 12.px,
                                  ),
                                  SizedBox(width: 6.px),
                                  Builder(
                                    builder: (context) {
                                      var text = widget.record.payAmount.toString();
                                      if(text.length>10){
                                        text = text.substring(0,10);
                                      }
                                      return ABText(
                                        text,
                                        textColor: theme.textColor,
                                        fontSize: 16.px,
                                        fontWeight: FontWeight.w600,
                                      );
                                    }
                                  ),
                                  SizedBox(width: 3.px),
                                  if(widget.record.payAmount.toString().length<10)ABText(
                                    widget.record.coinName,
                                    textColor: theme.primaryColor,
                                    fontSize: 12.px,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.0.px),
                                child: InkWell(
                                  onTap: () async{
                                    await ABRoute.pushNotRepeat(context:context,AssetsRechargePage());
                                    initData();
                                  },
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(6.px)),
                                    ),
                                    child: SizedBox(
                                      height: 30.px,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8.0.px,right: 8.px),
                                        child: Center(
                                          child: ABText(
                                            AB_S().rechargeAgain,
                                            textColor: theme.white,
                                            fontSize: 13.px,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  stateIcon(widget.record.status)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stateIcon(var status) {
    //状态：1成功、 其他失败、
    var text = '';
    Color color = Colors.white;
    text = AB_S().completed2;
    color = Color(0xff55DF00);
    // if(status ==1){
    //   text = AB_S().completed2;
    //   color = Color(0xff55DF00);
    // }else {
    //   text = AB_S().rechargeFailed;
    //   color = Color(0xffFF0000);
    // }
    return Positioned(
      top: 0,
      right: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.px), topRight: Radius.circular(6.px))),
        child: SizedBox(
          height: 32.px,
          child: Padding(
            padding: EdgeInsets.only(left: 14.px, right: 14.px),
            child: Center(
              child: ABText(
                text,
                textColor: color,
                fontSize: 12.px,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String singleTimeToString(int time) {
    String value = time.toString();
    if (time < 10) {
      value = '0$value';
    }
    return value;
  }

  String amountToString(double amount) {
    var value = amount.toString();
    if (amount > 0) {
      value = '+$value';
    } else {
      '-$value';
    }
    return value;
  }
}

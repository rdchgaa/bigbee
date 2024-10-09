import 'dart:convert';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/assets/payouts_set_model.dart';
import 'package:bee_chat/models/group/group_member_list_model.dart';
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
import 'package:bee_chat/pages/chat/red_bag/red_bag_records.dart';
import 'package:bee_chat/pages/common/share_user_page.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'dart:math' as math;

class RedBagSendPage extends StatefulWidget {
  final bool isGroup;
  final String userOrGroupId;

  const RedBagSendPage({super.key, required this.isGroup, required this.userOrGroupId});

  @override
  State<RedBagSendPage> createState() => _RedBagSendPageState();
}

class _RedBagSendPageState extends State<RedBagSendPage> {
  List<CoinModel> coinList = [];

  CoinModel? selectedCoin;

  bool showTip = false;

  String tipImage = '';
  String tipText = '';

  RedPacketSettingModel? setting;
  String? memberUse;

  final _controller = SuperTooltipController();

  /// new
  bool isOnly = false;

  TextEditingController titleText = TextEditingController(text: '');
  TextEditingController numText = TextEditingController(text: '');
  TextEditingController bagNumText = TextEditingController(text: '');

  GroupMemberListModel? member;

  @override
  void initState() {
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
    if (result.data != null && result.data!.isNotEmpty) {
      coinList = result.data ?? [];

      if (coinList.isNotEmpty) {
        selectedCoin = coinList[0];
        getPayoutsSet();
      }
      setState(() {});
    }
  }

  getPayoutsSet() async {
    numText.text = '';
    setting = null;
    memberUse = null;
    setState(() {});

    final result = await RedNet.redGetRedPacketSetting(
      coinId: (selectedCoin?.id).toString(),
      type: widget.isGroup ? (isOnly ? "1" : "2") : "1",
      level: widget.isGroup ? "2" : "1",
    );

    if (result.data != null) {
      setting = result.data;
      setState(() {});
    }

    final resultMemberUse = await AssetsNet.assetsGetMemberUseCapital(coinId: (selectedCoin?.id) ?? 0.toInt());
    if (resultMemberUse.data != null) {
      memberUse = resultMemberUse.data;
      setState(() {});
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
              AB_S().KindTipsWithdrawal,
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
      getPayoutsSet();
    }
  }

  toShowTip(int type, {String? text}) {
    // 1成功，2失败 ，3余额不足

    if (type == 1) {
      tipImage = ABAssets.copyOk(context);
      tipText = AB_S().withdrawalSuccess;
    } else if (type == 2) {
      tipImage = ABAssets.assetsFail(context);
      tipText = AB_S().verificationFailed;
    } else if (type == 3) {
      tipImage = ABAssets.assetsWarning(context);
      tipText = text ?? AB_S().insufficientBalance;
    }
    showTip = true;
    setState(() {});

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        showTip = false;
        setState(() {});
      }
    });
  }

  showGoogleCode() async {
    if (widget.isGroup) {
      if (!isOnly) {
        if ((double.tryParse(numText.text) ?? 0.0) < (setting?.min ?? 0.1)) {
          ABToast.show(AB_S().cannotLess);
          return;
        }
      }
    }
    // var value = await showGoogleCodeDialog(
    //   context,
    // );
    // if (value != null) {
    //   submit(value);
    // }
    submit();
  }

  submit() async {
    if (widget.isGroup) {
      final result = await RedNet.redSendGroupRedPacket(
        title: titleText.text==''?AB_S().moneyMuch:titleText.text,
        coinId: (selectedCoin?.id ?? 0),
        qty: double.tryParse(numText.text) ?? 0.0,
        toMemberNum: isOnly ? (member?.memberNum) : null,
        type: isOnly ? 1 : 2,
        peopleNumber: isOnly ? 1 : (int.tryParse(bagNumText.text) ?? 1),
        groupId: widget.userOrGroupId,
      );
      if (result.success == true && result.data != null) {
        toSuccess(result.data!.id, result.data!.createTime);
      } else {}
    } else {
      final result = await RedNet.redSendSingleRedPacket(
        title: titleText.text==''?AB_S().moneyMuch:titleText.text,
        coinId: (selectedCoin?.id ?? 0),
        qty: double.tryParse(numText.text) ?? 0.0,
        toMemberNum: widget.userOrGroupId,
      );
      if (result.success == true && result.data != null) {
        toSuccess(result.data!.id, result.data!.createTime);
      } else {}
    }
  }

  toSuccess(int redId, String time) {
    var result = SendRedResult(
      redId: redId,
      isGroup: widget.isGroup,
      userOrGroupId: widget.userOrGroupId,
      selectedCoin: selectedCoin!,
      isOnly: isOnly,
      title: titleText.text==''?AB_S().moneyMuch:titleText.text,
      coinNum: double.tryParse(numText.text) ?? 0.0,
      bagNum: int.tryParse(bagNumText.text) ?? 1,
      member: isOnly ? member : null,
      time: DateTime.tryParse(time) ?? DateTime.now(),
      receiveList: [],
    );
    ABRoute.pop(context: context, result: result);
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
        title: AB_getS(context).sendRedBag,
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
            child: SuperTooltip(
              minimumOutsideMargin: 16.px - 6,
              controller: _controller,
              barrierColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              arrowTipDistance: 8.px,
              arrowBaseWidth: 0,
              arrowLength: 0,
              borderColor: Colors.transparent,
              hasShadow: false,
              content: _toolWidget(),
              child: Container(
                  alignment: Alignment.center,
                  width: 44.px,
                  height: 44.px,
                  child: Image.asset(
                    ABAssets.homeAddIcon(context),
                    width: 28.px,
                    height: 28.px,
                  )),
            ),
          ),
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          LayoutBuilder(builder: (context, con) {
            return SingleChildScrollView(
              child: SizedBox(
                width: con.maxWidth,
                height: math.max(con.maxHeight, 500.px),
                child: Column(
                  children: [
                    SizedBox(
                      height: 16.px,
                    ),
                    //红包类型
                    if (widget.isGroup)
                      lineButtonItem(
                        AB_getS(context).redBagType,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isOnly = false;
                                  });
                                },
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: !isOnly ? theme.primaryColor : theme.textColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.px),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16.0.px, right: 16.px),
                                    child: SizedBox(
                                      height: 32.px,
                                      child: ABText(
                                        AB_getS(context).luck,
                                        textColor: !isOnly ? theme.textColor : theme.textColor.withOpacity(0.2),
                                        fontSize: 14.px,
                                        fontWeight: !isOnly ? FontWeight.w600 : null,
                                      ).center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.px),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isOnly = true;
                                  });
                                },
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: isOnly ? theme.primaryColor : theme.textColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.px),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16.0.px, right: 16.px),
                                    child: SizedBox(
                                      height: 32.px,
                                      child: ABText(
                                        AB_getS(context).Exclusive,
                                        textColor: isOnly ? theme.textColor : theme.textColor.withOpacity(0.2),
                                        fontSize: 14.px,
                                        fontWeight: isOnly ? FontWeight.w600 : null,
                                      ).center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    //红包标题
                    lineButtonItem(
                      AB_getS(context).redBagTitle,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: SizedBox(
                          width: 180.px,
                          height: 56,
                          child: ABTextField(
                            textAlign: TextAlign.end,
                            text: titleText.text,
                            hintText: AB_getS(context).moneyMuch,
                            hintColor: theme.textGrey,
                            textColor: theme.textColor,
                            textSize: 14,
                            contentPadding: EdgeInsets.only(bottom: 12),
                            maxLines: 1,
                            maxLength: 100,
                            onChanged: (text) {
                              titleText.text = text;
                              setState(() {});
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        selectCoin();
                      },
                    ),
                    //货币类型
                    lineButtonItem(
                      AB_getS(context).coinType,
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (selectedCoin != null)
                              Padding(
                                padding: EdgeInsets.only(left: 16.0.px, right: 12.px),
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
                                textColor: theme.text282109,
                              ),
                            if (selectedCoin == null)
                              ABText(
                                AB_getS(context).pleaseSelect,
                                fontSize: 14.px,
                                textColor: theme.text282109,
                              ),
                            SizedBox(
                              width: 5.px,
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
                      onTap: () {
                        selectCoin();
                      },
                    ),

                    //货币数量
                    Stack(
                      children: [
                        lineButtonItem(
                          AB_getS(context).coinNum,
                          height: 70.px,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: SizedBox(
                              width: 200.px,
                              height: 56,
                              child: TextField(
                                textAlign: TextAlign.end,
                                textAlignVertical: TextAlignVertical.center,
                                obscureText: false,
                                controller: numText,
                                onChanged: (text) {
                                  if (text.endsWith('.')) {
                                    if (text.substring(0, text.length - 1).contains('.')) {
                                      numText.text = text.substring(0, text.length - 1);
                                      setState(() {});
                                      return;
                                    }
                                  }

                                  double maxNum = setting?.max ?? 0.0;
                                  maxNum = math.min(maxNum, double.tryParse(memberUse ?? '0') ?? 0.0);
                                  double num = double.tryParse(text) ?? 0;
                                  if (num != 0) {
                                    if (num > maxNum) {
                                      numText.text = maxNum.toString();
                                    }
                                    setState(() {});
                                  }
                                },
                                onSubmitted: (text) {},
                                enabled: true,
                                keyboardType: TextInputType.number,
                                maxLength: 100,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 12),
                                  counterText: '',
                                  hintText: (setting?.min ?? 0).toString() +
                                      ' - ' +
                                      (math.min(setting?.max ?? 0.0, double.tryParse(memberUse ?? '0') ?? 0.0))
                                          .toString() +
                                      ' ' +
                                      (selectedCoin?.coinName ?? ''),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: 14, color: theme.textGrey),
                                  labelStyle: TextStyle(fontSize: 14, color: theme.textGrey),
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.textColor,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100),
                                  FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (selectedCoin != null)
                          Positioned(
                            left: 16.px,
                            bottom: 5.px,
                            child: ABText(
                                '${AB_getS(context).currentText} 1${selectedCoin?.coinName} ≈ ${selectedCoin?.price} U',
                                textColor: theme.primaryColor,
                                fontSize: 12.px),
                          )
                      ],
                    ),
                    //专属红包- 人
                    if (widget.isGroup && isOnly)
                      lineButtonItem(
                        AB_getS(context).ExclusiveRedBag,
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (member != null)
                                Padding(
                                  padding: EdgeInsets.only(left: 16.0.px, right: 12.px),
                                  child: SizedBox(
                                    width: 18.px,
                                    height: 18.px,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: ABImage.imageWithUrl(
                                            // 'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png',
                                            member?.avatarUrl ?? '',
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                ),
                              if (member != null)
                                ABText(
                                  member?.nickName ?? '',
                                  fontSize: 14.px,
                                  textColor: theme.text282109,
                                ),
                              if (member == null)
                                ABText(
                                  AB_getS(context).pleaseSelect,
                                  fontSize: 14.px,
                                  textColor: theme.text282109,
                                ),
                              SizedBox(
                                width: 5.px,
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
                        onTap: () async {
                          GroupMemberListModel? value = await ABRoute.push(RedBagGroupMemberListPage(
                            groupID: widget.userOrGroupId,
                          ));
                          if (value != null) {
                            member = value;
                            setState(() {});
                          }
                        },
                      ),
                    //红包数量
                    if (widget.isGroup && !isOnly)
                      lineButtonItem(
                        AB_getS(context).redBagNum,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: SizedBox(
                            width: 200.px,
                            height: 56,
                            child: TextField(
                              textAlign: TextAlign.end,
                              textAlignVertical: TextAlignVertical.center,
                              obscureText: false,
                              controller: bagNumText,
                              onChanged: (text) {
                                if (text.startsWith('0')) {
                                  bagNumText.text = bagNumText.text.substring(1);
                                  setState(() {});
                                }
                              },
                              onSubmitted: (text) {},
                              enabled: true,
                              keyboardType: TextInputType.number,
                              maxLength: 100,
                              maxLines: 1,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 12),
                                counterText: '',
                                hintText: '1',
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 14, color: theme.textGrey),
                                labelStyle: TextStyle(fontSize: 14, color: theme.textGrey),
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.textColor,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                              ],
                            ),
                          ),
                        ),
                      ),
                    SizedBox().expanded(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(bottom: 18.px),
                      child: ABText(
                        AB_getS(context).sendRedBagTip,
                        fontSize: 14,
                        textColor: theme.textColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24.px,
                        right: 24.px,
                      ),
                      child: Builder(builder: (context) {
                        var canClick = true;
                        if (selectedCoin == null) {
                          canClick = false;
                        }
                        if ((double.tryParse(numText.text) ?? 0) <= 0) {
                          canClick = false;
                        }

                        if (widget.isGroup) {
                          if (isOnly) {
                            if (member == null) {
                              canClick = false;
                            }
                          }
                        }

                        return ABButton.gradientColorButton(
                          colors:
                              canClick ? [theme.primaryColor, theme.secondaryColor] : [theme.text999, theme.text999],
                          cornerRadius: 12,
                          height: 48,
                          text: AB_getS(context).sendRedBag,
                          textColor: theme.textColor,
                          onPressed: () async {
                            if (!canClick) {
                              return;
                            }

                            showGoogleCode();
                          },
                        );
                      }),
                    ),
                    SizedBox(
                      height: 36.px,
                    ),
                  ],
                ),
              ),
            );
          }),
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
                tipImage,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 5.px,
            ),
            ABText(
              tipText,
              textColor: theme.textColor,
              fontSize: 16.px,
            ),
          ],
        ),
      ),
    );
  }

  Widget lineButtonItem(String title, {required Widget child, Function? onTap, bool showLine = true, double? height}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: () {
        onTap == null ? null : onTap();
      },
      child: SizedBox(
        child: ColoredBox(
          color: theme.white,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: height ?? 56.px,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0.px),
                      child: ABText(
                        title,
                        fontSize: 14.px,
                        textColor: theme.textColor,
                      ),
                    ),
                    child
                  ],
                ),
              ),
              showLine
                  ? Padding(
                      padding: EdgeInsets.only(left: 16.0.px, right: 16.0.px),
                      child: Divider(
                        height: 1,
                        color: theme.grey.withOpacity(0.3),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolWidget() {
    final theme = AB_theme(context);
    return HomeToolTipWidget(
      items: [
        HomeToolTipItem(
          title: AB_getS(context).redBagRecords,
          icon: Image.asset(
            ABAssets.homeStartChatIcon(context),
            width: 24.px,
            height: 24.px,
          ),
          onTap: () {
            ABRoute.push(const RedBagRecords());
            // _startChatAction();
          },
        ),
      ],
      onTap: (_) {
        _controller.hideTooltip();
      },
    );
  }
}

class SendRedResult {
  //红包ID
  final int redId;
  final DateTime time;
  final List<String> receiveList;

  //是否是群组 否 单聊
  final bool isGroup;

  //用户ID或者群组ID
  final String userOrGroupId;

  //选择币种
  final CoinModel selectedCoin;

  // 是否专属红包，，否 ：拼手气
  final bool isOnly;

  //红包标题
  final String title;

  //代币数量
  final double coinNum;

  //红包数量
  final int bagNum;

  // 是否已领完
  final bool isOver;

  //专属人
  final GroupMemberListModel? member;

  SendRedResult(
      {required this.redId,
      required this.time,
      required this.receiveList,
      required this.isGroup,
      required this.userOrGroupId,
      required this.selectedCoin,
      required this.isOnly,
      required this.title,
      required this.coinNum,
      required this.bagNum,
        this.isOver = false,
      this.member});

  SendRedResult copyWith({
    int? redId,
    DateTime? time,
    List<String>? receiveList,
    bool? isGroup,
    String? userOrGroupId,
    CoinModel? selectedCoin,
    bool? isOnly,
    String? title,
    double? coinNum,
    int? bagNum,
    bool? isOver,
    GroupMemberListModel? member,
  }) {
    return SendRedResult(
      redId: redId ?? this.redId,
      time: time ?? this.time,
      receiveList: receiveList ?? this.receiveList,
      isGroup: isGroup ?? this.isGroup,
      userOrGroupId: userOrGroupId ?? this.userOrGroupId,
      selectedCoin: selectedCoin ?? this.selectedCoin,
      isOnly: isOnly ?? this.isOnly,
      title: title ?? this.title,
      coinNum: coinNum ?? this.coinNum,
      bagNum: bagNum ?? this.bagNum,
      isOver: isOver ?? this.isOver,
      member: member ?? this.member,
    );
  }

  // 是否是接收红包(云端数据判断)
  bool isReceive() {
    final userId = UserProvider.getCurrentUser().userId;
    return receiveList.contains(userId);
  }

  // // 已领取完
  // bool isReceivedOver() {
  //   if (bagNum == 0 && receiveList.length == 0) {
  //     return false;
  //   }
  //   return receiveList.length == bagNum;
  // }

  // 是否过期
  bool isExpired() {
    return DateTime.now().millisecondsSinceEpoch > time.millisecondsSinceEpoch + 1000 * 60 * 60 * 24;
  }




  Map<String, dynamic> toMap() {
    return {
      'redId': redId,
      'time': time.millisecondsSinceEpoch,
      'receiveList': receiveList,
      'isGroup': isGroup,
      'userOrGroupId': userOrGroupId,
      'selectedCoin': selectedCoin.toMap(),
      'isOnly': isOnly,
      'title': title,
      'coinNum': coinNum,
      'bagNum': bagNum,
      'isOver': isOver,
      'member': member?.toMap(),
    };
  }

  String toJsonString() => json.encode(toMap());
  static SendRedResult? fromJsonString(String jsonStr) {
    try {
      return fromMap(json.decode(jsonStr));
    } catch (e) {
      return null;
    }
  }

  static SendRedResult? fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return SendRedResult(
      redId: null == (temp = map['redId']) ? 0 : (temp is num ? temp.toInt() : (num.tryParse(temp)?.toInt() ?? 0)),
      time: null == (temp = map['time'])
          ? DateTime.now()
          : (temp is DateTime ? temp : DateTime.fromMillisecondsSinceEpoch(temp)),
      receiveList: null == (temp = map['receiveList'])
          ? []
          : (temp is List ? temp.map((map) => map?.toString() ?? "").toList() : []),
      isGroup: null == (temp = map['isGroup'])
          ? false
          : (temp is bool ? temp : (temp is num ? 0 != temp.toInt() : ('true' == temp.toString()))),
      userOrGroupId: map['userOrGroupId']?.toString() ?? "",
      selectedCoin: CoinModel.fromMap(map['selectedCoin']) ?? CoinModel(),
      isOnly: null == (temp = map['isOnly'])
          ? false
          : (temp is bool ? temp : (temp is num ? 0 != temp.toInt() : ('true' == temp.toString()))),
      title: map['title']?.toString() ?? "",
      coinNum: null == (temp = map['coinNum'])
          ? 0.0
          : (temp is num ? temp.toDouble() : (num.tryParse(temp)?.toDouble() ?? 0.0)),
      bagNum: null == (temp = map['bagNum']) ? 0 : (temp is num ? temp.toInt() : (num.tryParse(temp)?.toInt() ?? 0)),
      isOver: null == (temp = map['isOver'])
          ? false
          : (temp is bool ? temp : (temp is num ? 0 != temp.toInt() : ('true' == temp.toString()))),
      member: GroupMemberListModel.fromMap(map['member']),
    );
  }
}

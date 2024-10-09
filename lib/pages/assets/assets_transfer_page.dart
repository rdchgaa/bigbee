import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/assets/payouts_set_model.dart';
import 'package:bee_chat/models/assets/transfer_set_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_language_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/assets_user_search_page.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/assets/widget/input_google_code_dialog.dart';
import 'package:bee_chat/pages/assets/widget/select_coin_dialog.dart';
import 'package:bee_chat/pages/common/share_user_page.dart';
import 'package:bee_chat/pages/contact/contact_page.dart';
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
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'dart:math' as math;

class AssetsTransferPage extends StatefulWidget {
  const AssetsTransferPage({super.key});

  @override
  State<AssetsTransferPage> createState() => _AssetsTransferPageState();
}

class _AssetsTransferPageState extends State<AssetsTransferPage> {
  List<CoinModel> coinList = [];

  CoinModel? selectedCoin;

  bool showTip = false;

  TextEditingController numText = TextEditingController(text: '');

  String tipImage = '';
  String tipText = '';

  ContactInfo? selectUser;

  TransferSetModel? setInfo;

  String? memberUse;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    // ABRoute.pageHistory.remove(AssetsTransferPage().routerName());
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
    alertTip();
  }

  getPayoutsSet() async {
    numText.text = '';
    setInfo = null;
    memberUse = null;
    setState(() {});
    final result = await AssetsNet.assetsGetTransferSet(coinId: (selectedCoin?.id) ?? 0.toInt());
    if (result.data != null) {
      setInfo = result.data;
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
              AB_S().KindTipsTransfer,
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
      tipText = AB_S().transferSuccess;
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
    var value = await showGoogleCodeDialog(
      context,
    );
    if (value != null) {
      submit(value);
    }
  }
  submit(String googleCode) async {
    ABLoading.show();
    final result = await AssetsNet.assetsSendTransfer(
      coinId: (selectedCoin?.id) ?? 0.toInt(),
      qty: double.tryParse(numText.text) ?? 0, toMemberId: selectUser?.friendInfo.userID??'', googleCode: int.tryParse
      (googleCode)??0,
    );
    ABLoading.dismiss();
    if(result.success==true){
      toShowTip(1);
    }else{
      toShowTip(2,text: result.message);
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
        title: AB_getS(context).transfer,
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
                  ABRoute.pushNotRepeat(const AssetsRecordPage(index: 2,),context: context);
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
                    lineButtonItem(
                      AB_getS(context).receivingAccount,
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (selectedCoin != null)
                              ABText(
                                selectUser?.name ?? AB_getS(context).userNickname,
                                fontSize: 14.px,
                                textColor: theme.text282109,
                              ),
                            Padding(
                              padding: EdgeInsets.only(left: 32.px, right: 16.px),
                              child: Image.asset(
                                ABAssets.assetsFrame(context),
                                width: 24.px,
                                height: 24.px,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () async {
                        var info = await ABRoute.push(AssetsUserSearchPage());
                        if (info != null) {
                          if (info is ContactInfo) {
                            selectUser = info;
                            setState(() {});
                          }
                        }
                      },
                    ),
                    lineButtonItem(
                      AB_getS(context).transferCurrency,
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
                    //提现数量
                    if (setInfo != null&&memberUse!=null)
                      lineButtonItem(
                        AB_getS(context).transferNum,
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
                                if(text.contains('.')){
                                  var pointLength = text.substring(text.indexOf('.'), text.length).length;
                                  if (pointLength>9) {
                                    numText.text = text.substring(0, text.indexOf('.')+9);
                                    setState(() {});
                                    return;
                                  }
                                }

                                // var minNum = 2;
                                var maxNum = double.tryParse(memberUse??'0')??0;

                                var num = double.tryParse(text) ?? 0;
                                if (num != 0) {
                                  // if(num<minNum){
                                  //   numText.text = minNum.toString();
                                  // }
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
                                counterText: '',
                                hintText: AB_getS(context).transferable + (memberUse ?? '0').toString() +
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
                    if (setInfo != null)
                      Builder(builder: (context) {
                        var num = double.tryParse(numText.text) ?? 0;
                        var fee = num * (setInfo?.transferFeeRatio ?? 1)*0.01;
                        return Column(
                          children: [
                            //提现手续费
                            lineButtonItem(
                              AB_getS(context).transferFee,
                              child: Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: ABText(
                                  '${fee} ' + (selectedCoin?.coinName ?? ''),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            //实际到账
                            lineButtonItem(
                              AB_getS(context).realNum,
                              child: Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: ABText(
                                  '${num - fee} ' + (selectedCoin?.coinName ?? ''),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    SizedBox().expanded(flex: 1),
                    if (selectedCoin != null)
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24.px,
                          right: 24.px,
                        ),
                        child: Builder(
                          builder: (context) {
                            var canClick = false;
                            if (selectUser!=null && numText.text != '') {
                              if((double.tryParse(numText.text)??0)>0){
                                canClick = true;
                              }
                            }
                            return ABButton.gradientColorButton(
                              colors: canClick ? [theme.primaryColor, theme.secondaryColor] : [theme.text999, theme.text999],
                              cornerRadius: 12,
                              height: 48,
                              text: AB_getS(context).confirmTransfer,
                              textColor: theme.textColor,
                              onPressed: () async {
                                if (!canClick) {
                                  return;
                                }
                                // var minNum = setInfo?.minQty ?? 0;
                                // if ((double.tryParse(numText.text) ?? 0) < minNum) {
                                //   toShowTip(3,
                                //       text: AB_S().canWithdrawalNum +
                                //           (setInfo?.minQty ?? 0).toString() +
                                //           '-' +
                                //           (setInfo?.maxQty ?? 0).toString() +
                                //           ' ' +
                                //           (selectedCoin?.coinName ?? ''));
                                //   return;
                                // }

                                showGoogleCode();
                              },
                            );
                          }
                        ),
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

  Widget lineButtonItem(String title, {required Widget child, Function? onTap, bool showLine = true}) {
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
                height: 56.px,
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
}

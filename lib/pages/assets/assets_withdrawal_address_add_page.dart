import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/assets/payouts_address_list_model.dart';
import 'package:bee_chat/models/assets/payouts_set_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_language_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/assets/widget/input_google_code_dialog.dart';
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
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:bee_chat/widget/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'dart:math' as math;

class AssetsWithdrawalAddressAddPage extends StatefulWidget {
  final PayoutsAddressListRecords? address;

  const AssetsWithdrawalAddressAddPage({super.key, this.address});

  @override
  State<AssetsWithdrawalAddressAddPage> createState() => _AssetsWithdrawalAddressAddPageState();
}

class _AssetsWithdrawalAddressAddPageState extends State<AssetsWithdrawalAddressAddPage> {
  TextEditingController addressText = TextEditingController(text: '');
  GlobalKey<ABTextFieldState> addressTextKey = GlobalKey();

  TextEditingController infoText = TextEditingController(text: '');
  GlobalKey<ABTextFieldState> infoTextKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    // ABRoute.pageHistory.remove(AssetsWithdrawalAddressAddPage().routerName());
    super.dispose();
  }

  initData() async {
    if (widget.address != null) {
      addressText = TextEditingController(text: widget.address!.address);
      addressTextKey.currentState?.editText(widget.address!.address ?? '');
      infoText = TextEditingController(text: widget.address!.addressRemark);
      infoTextKey.currentState?.editText(widget.address!.addressRemark ?? '');
      setState(() {});
    }
  }

  submit() async {
    ABLoading.show();
    var result;
    if (widget.address != null && widget.address!.id != null) {
      result = await AssetsNet.assetsPayoutsAddressEdit(
          id: widget.address!.id!,
          address: addressText.text,
          remark: infoText.text == '' ? AB_S().noRemarks : infoText.text);
    } else {
      result = await AssetsNet.assetsPayoutsAddressAdd(
          address: addressText.text, remark: infoText.text == '' ? AB_S().noRemarks : infoText.text);
    }
    ABLoading.dismiss();
    if (result.success == true) {
      ABToast.show(AB_S().success, toastType: ToastType.success);
      ABRoute.pop(context: context);
    } else {
      ABToast.show(AB_S().saveFail, toastType: ToastType.success);
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
        title: widget.address != null ? AB_getS(context).editCoinAddress : AB_getS(context).addCoinAddress,
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
          //提现地址
          lineButtonItem(
            context,
            AB_getS(context).withdrawalAddress,
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 180.px,
                    height: 56,
                    child: ABTextField(
                        key: addressTextKey,
                        textAlign: TextAlign.end,
                        text: addressText.text,
                        hintText: AB_getS(context).pleasesInputWithdrawalAddress,
                        hintColor: theme.textGrey,
                        textColor: theme.textColor,
                        textSize: 14,
                        contentPadding: EdgeInsets.only(bottom: 12),
                        maxLines: 1,
                        maxLength: 100,
                        onChanged: (text) {
                          addressText.text = text;
                          setState(() {});
                        }),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: InkWell(
                            onTap: () async {
                              /// 扫一扫点击
                              print("扫一扫");
                              final result = await ABRoute.push(const ScanPage()) as String?;
                              if (result != null) {
                                print("扫描结果：${result}");
                                addressText = TextEditingController(text: result);
                                addressTextKey.currentState?.editText(result);
                                setState(() {});
                              }
                            },
                            child: Image.asset(
                              ABAssets.iconScan(context),
                              width: 20.px,
                              height: 20.px,
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          //备注
          lineButtonItem(
            context,
            AB_getS(context).remarks,
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: 180.px,
                height: 56,
                child: ABTextField(
                    key: infoTextKey,
                    textAlign: TextAlign.end,
                    text: infoText.text,
                    hintText: AB_getS(context).remarksHintText,
                    hintColor: theme.textGrey,
                    textColor: theme.textColor,
                    textSize: 14,
                    contentPadding: EdgeInsets.only(bottom: 12),
                    maxLines: 1,
                    maxLength: 20,
                    onChanged: (text) {
                      infoText.text = text;
                      setState(() {});
                    }),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(
              left: 24.px,
              right: 24.px,
              bottom: 50.px,
            ),
            child: Builder(builder: (context) {
              var canClick = false;
              if (addressText.text != '') {
                canClick = true;
              }
              return ABButton.gradientColorButton(
                colors: canClick ? [theme.primaryColor, theme.secondaryColor] : [theme.text999, theme.text999],
                cornerRadius: 12,
                height: 48,
                text: AB_getS(context).save,
                textColor: theme.textColor,
                onPressed: () async {
                  submit();
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

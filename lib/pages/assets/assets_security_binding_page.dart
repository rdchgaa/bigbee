import 'dart:io';

import 'package:bee_chat/models/assets/google_is_bind_model.dart';
import 'package:bee_chat/models/assets/google_qrcode_model.dart';
import 'package:bee_chat/models/assets/google_secret_key_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/account_security/mnemonic_show_my_page.dart';
import 'package:bee_chat/pages/assets/assets_binding_google_code_page.dart';
import 'package:bee_chat/pages/assets/user_edit_password_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/app_update_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../account_security/mnemonic_show_page.dart';

class AssetsSecurityBindingPage extends StatefulWidget {
  const AssetsSecurityBindingPage({super.key});

  @override
  State<AssetsSecurityBindingPage> createState() => _AssetsSecurityBindingPageState();
}

class _AssetsSecurityBindingPageState extends State<AssetsSecurityBindingPage> {
  GoogleIsBindModel? googleKey;
  bool _isBindMnemonic = false;

  @override
  void initState() {
    _requestGoogleBind();
    _requestMnemonicBind();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _requestGoogleBind() async {
    var result = await AssetsNet.assetsGoogleIsBind();
    if (result.data != null) {
      googleKey = result.data;
    }
    setState(() {});
  }

  // 请求助记词是否绑定
  _requestMnemonicBind() async {
    var result = await UserNet.isBindMnemonic();
    if (result.data != null) {
      setState(() {
        _isBindMnemonic = result.data!;
      });
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
        title: AB_getS(context).securityBinding,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15.px,
                  ),
                  googleKey == null
                      ? setButtonItem(ABAssets.assetsGoogleIcon(context), AB_getS(context).googleAuthenticator,
                          showNext: false, showLine: true)
                      : setButtonItem(
                          ABAssets.assetsGoogleIcon(context),
                          AB_getS(context).googleAuthenticator,
                          onTap: () async {
                            await ABRoute.push(AssetsBindingGoogleCodePage());
                            _requestGoogleBind();
                          },
                          showLine: true,
                          rightText:
                              googleKey?.isBind == true ? AB_getS(context).alreadyBound : AB_getS(context).goBind,
                          showNext: googleKey?.isBind != true,
                        ),
                  _isBindMnemonic
                      ? setButtonItem(
                          ABAssets.mnemonicIcon(context),
                          AB_getS(context).mnemonicVerification,
                          rightText: AB_getS(context).verified,
                          showNext: true,
                          showLine: false,
                          onTap: () async {
                            await ABRoute.push(const MnemonicShowMyPage(isShowBackBtn: true, isCanSkip: false));
                            _requestMnemonicBind();
                          },
                        )
                      : setButtonItem(
                          ABAssets.mnemonicIcon(context),
                          AB_getS(context).mnemonicVerification,
                          onTap: () async {
                            await ABRoute.push(const MnemonicShowPage(isShowBackBtn: true, isCanSkip: false));
                            _requestMnemonicBind();
                          },
                          showLine: false,
                          rightText: AB_getS(context).toVerified,
                          showNext: true,
                        ),
                  setButtonItem(
                    null,
                    assetsWidget: Padding(
                      padding: EdgeInsets.only(left: 16.0.px, right: 12.px),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Color(0xff555555), borderRadius: BorderRadius.all(Radius.circular(12.px))),
                        child: SizedBox(
                          width: 24.px,
                          height: 24.px,
                          child: Center(
                              child: Text(
                            'P',
                            style: TextStyle(fontWeight: FontWeight.w800, color: theme.f4f4f4, fontSize: 18.px),
                          )),
                        ),
                      ),
                    ),
                    AB_getS(context).editPassword,
                    showNext: true,
                    showLine: false,
                    onTap: () async {
                      await ABRoute.push(const UserEditPasswordPage());
                    },
                  )
                ],
              ),
            ),
          ),
          if (googleKey != null)
            Padding(
              padding: EdgeInsets.only(left: 24.px, right: 24.px, bottom: 24.px),
              child: ABButton.gradientColorButton(
                colors: [theme.primaryColor, theme.secondaryColor],
                cornerRadius: 12,
                height: 48,
                text: AB_getS(context).downloadNow,
                onPressed: () {
                  var url = googleKey?.androidUrl ?? '';
                  if (Platform.isAndroid) {
                    url = googleKey?.androidUrl ?? '';
                  } else {
                    url = googleKey?.iosUrl ?? '';
                  }
                  AppUpdateWidget.launchUrl(url);
                  // if (Platform.isAndroid) {
                  //   AppUpdateWidget.launchUrl(
                  //       "https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2");
                  // } else {
                  //   AppUpdateWidget.launchUrl("https://apps.apple.com/cn/app/google-authenticator/id388497605");
                  // }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget setButtonItem(String? assets, String title,
      {Widget? assetsWidget, Function? onTap, String? rightText, bool? showLine = true, bool? showNext = true}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: () {
        if (showNext == true) {
          onTap == null ? null : onTap();
        }
      },
      child: SizedBox(
        child: ColoredBox(
          color: theme.backgroundColorWhite,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 56.px,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        assets == null
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(left: 16.0.px, right: 12.px),
                                child: SizedBox(
                                  width: 24.px,
                                  height: 24.px,
                                  child: Image.asset(
                                    assets,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        assetsWidget ?? SizedBox(),
                        ABText(
                          title,
                          fontSize: 14.px,
                          textColor: theme.textColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (rightText != null)
                          ABText(
                            rightText,
                            fontSize: 14,
                            textColor: theme.text999,
                          ),
                        showNext != true
                            ? SizedBox(
                                width: 16.px,
                              )
                            : Padding(
                                padding: EdgeInsets.only(left: 5.px, right: 16.px),
                                child: Image.asset(
                                  ABAssets.assetsRight(context),
                                  width: 9.px,
                                  height: 15.px,
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
              showLine == true
                  ? Padding(
                      padding: EdgeInsets.only(left: 16.0.px, right: 16.0.px),
                      child: Divider(
                        height: 1,
                        color: theme.grey.withOpacity(0.6),
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

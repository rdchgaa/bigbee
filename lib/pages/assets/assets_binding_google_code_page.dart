import 'dart:convert';
import 'dart:typed_data';

import 'package:bee_chat/models/assets/google_qrcode_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AssetsBindingGoogleCodePage extends StatefulWidget {
  const AssetsBindingGoogleCodePage({super.key});

  @override
  State<AssetsBindingGoogleCodePage> createState() => _AssetsBindingGoogleCodePageState();
}

class _AssetsBindingGoogleCodePageState extends State<AssetsBindingGoogleCodePage> {
  GoogleQrcodeModel? googleKey;

  String code = '';

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
    var result = await AssetsNet.assetsGetQrcode();
    if (result.data != null) {
      googleKey = result.data;
    }
    setState(() {});
  }

  toBind() async {
    var result = await AssetsNet.assetsCheckCode(code: code);
    if (result.success == true) {
      ABToast.show(result.message ?? '');
      ABRoute.pop(context: context);
    } else {
      ABToast.show(result.message ?? '');
    }
  }

  Future<Uint8List> convertBase64ToImage(String base64String) async {
    // 将base64字符串转换为Uint8List
    Uint8List imageBytes = base64Decode(base64String);
    return imageBytes;
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
        title: AB_getS(context).bindGoogleAuthenticator,
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
      body: LayoutBuilder(builder: (context, con) {
        var maxHeight = MediaQuery.of(context).size.height - 100.px;
        return SingleChildScrollView(
          child: SizedBox(
            height: maxHeight,
            child: Column(
              children: [
                SizedBox(height: 48.px),
                Padding(
                  padding: EdgeInsets.only(left: 53.0.px, right: 53.px),
                  child: Text(
                    AB_getS(context).bindGoogleAuthenticatorTip,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.textColor,
                      fontSize: 14.px,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 26.px),

                ///二维码
                Builder(builder: (context) {
                  var imageWidth = 170.px;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.px)),
                    ),
                    child: SizedBox(
                      width: imageWidth,
                      height: imageWidth,
                      child: Padding(
                        padding: EdgeInsets.all(0.px),
                        child: googleKey == null
                            ? SizedBox()
                            : SizedBox(
                                child: Center(
                                  child: Builder(builder: (context) {
                                    return FutureBuilder<Uint8List>(
                                      future: convertBase64ToImage(googleKey?.base64Image ?? ''), // 替换为你的base64字符串
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          // 图片加载成功
                                          return Image.memory(
                                            snapshot.data!,
                                            width: imageWidth,
                                            height: imageWidth,
                                          );
                                        } else if (snapshot.hasError) {
                                          // 图片加载出错
                                          return SizedBox();
                                        }
                                        // 图片加载中
                                        return CircularProgressIndicator();
                                      },
                                    );

                                    // var url = googleKey?.androidUrl ?? '';
                                    // if (Platform.isAndroid) {
                                    //   url = googleKey?.androidUrl ?? '';
                                    // } else {
                                    //   url = googleKey?.iosUrl ?? '';
                                    // }
                                    var url = googleKey?.secretKey ?? '';
                                    return QrImageView(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.all(6),
                                      data: url,
                                      // (googleKey ?? '') + '?userId='+ABSharedPreferences.getUserIdSync(),
                                      // data: ABShare.getAppShareUrl(inviteCode: '111'),
                                      size: 160.0.px,
                                    );
                                  }),
                                ),
                              ),
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 8.px,
                ),
                ABText(
                  AB_getS(context).scanQRCode,
                  textColor: theme.text999,
                  fontSize: 14.px,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: 8.px,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        final ClipboardData clipboardData = ClipboardData(text: googleKey?.secretKey ?? '');
                        await Clipboard.setData(clipboardData);
                        ABToast.show(AB_S().copyToClipboardSuccess,toastType: ToastType.success);
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [theme.primaryColor.withOpacity(0.1), theme.primaryColor.withOpacity(0.4)]),
                            borderRadius: BorderRadius.all(Radius.circular(18))),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.px, right: 20.px, top: 5.px, bottom: 5.px),
                          child: Row(
                            children: [
                              Center(
                                child: Center(
                                  child: ABText(
                                    googleKey?.secretKey ?? '',
                                    textColor: theme.textFB8B04,
                                    fontSize: 14.px,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 6.px,
                              ),
                              SizedBox(
                                width: 12.px,
                                height: 12.px,
                                child: Image.asset(
                                  ABAssets.userCopy(context),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 34.px,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.px, right: 24.px, top: 18.px),
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: theme.f4f4f4, borderRadius: BorderRadius.circular(6)),
                      child: LayoutBuilder(builder: (context, con) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 48,
                              child: Image.asset(
                                ABAssets.loginPasswordIcon(context),
                                width: 24.px,
                                height: 24.px,
                              ),
                            ),
                            SizedBox(
                              width: con.maxWidth - 48,
                              height: 48.px,
                              child: ABTextField(
                                text: '',
                                hintText: AB_S().pleaseEnterGoogleCode,
                                hintColor: theme.textGrey,
                                textColor: theme.textColor,
                                textSize: 16,
                                contentPadding: EdgeInsets.only(bottom: 12),
                                maxLines: 1,
                                maxLength: 16,
                                keyboardType: TextInputType.number,
                                onChanged: (text) {
                                  setState(() {
                                    code = text;
                                  });
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                                ],
                              ),
                            ),
                          ],
                        );
                      })),
                ),
                const SizedBox().expanded(flex: 1),
                Padding(
                  padding: EdgeInsets.only(left: 24.px, right: 24.px, bottom: 24.px),
                  child: ABButton.gradientColorButton(
                    colors:
                        code.length != 6 ? [theme.text999, theme.text999] : [theme.primaryColor, theme.secondaryColor],
                    cornerRadius: 12,
                    height: 48,
                    text: AB_getS(context).bindNow,
                    onPressed: () {
                      // Navigator.of(context).pop();
                      if (code.length != 6) {
                        return;
                      }
                      toBind();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget setButtonItem(String assets, String title, Function onTap, {String? rightText, bool showLine = true}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: () {
        onTap();
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
                        Padding(
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
                        Padding(
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
              showLine
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

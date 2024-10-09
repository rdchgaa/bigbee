import 'dart:async';
import 'dart:ui';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/user/member_code_model.dart';
import 'package:bee_chat/models/user/user_detail_model.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/common/share_record_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/permission_util.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';


class ShareUserPage extends StatefulWidget {
  final UserDetailModel userInfo;

  const ShareUserPage({
    super.key, required this.userInfo,
  });

  @override
  State<ShareUserPage> createState() => _ShareUserPageState();
}

class _ShareUserPageState extends State<ShareUserPage> {
  final GlobalKey qrGlobalKey = GlobalKey();

  MemberCodeModel? code;
  bool showTip = false;

  int tipType = 1;  //1：已保存   2：已复制到剪切板

  @override
  void initState() {
    super.initState();
    // initData();
  }

  initData() async {
    final result = await UserNet.getUserMemberCode();
    if (result.data != null) {
      setState(() {
        code = result.data!;
      });
    }
  }
  toShowTip(int type){
    showTip = true;
    tipType = type;
    setState(() {

    });
    Future.delayed(Duration(seconds: 2),(){
      if(mounted){
        showTip = false;
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Loading(
      child: Scaffold(
        appBar: ABAppBar(
          title: AB_getS(context).inviteFriends,
          rightWidget: Padding(
            padding: EdgeInsets.only(right: 16.0.px),
            child: Center(
              child: InkWell(
                  onTap: () async {
                    ABRoute.push(ShareRecordPage(userInfo: widget.userInfo));
                  },
                  child: Image.asset(
                    ABAssets.assetsRecords1(context),
                    width: 24.px,
                    height: 24.px,
                  )),
            ),
          ),
        ),
        body: LoadingCall(
            onInitLoading: _onInitLoading,
            errorBuilder: (context,error){
              return SizedBox();
            },
            builder: (context) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  RepaintBoundary(
                    key: qrGlobalKey,
                    child: LayoutBuilder(
                        builder: (context,con) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox().expanded(flex: 6),
                              SizedBox(
                                width: 200.px,
                                height: 200.px,
                                child: Image.asset(
                                  ABAssets.logoText(context),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox().expanded(flex: 2),
                              ABText(
                                AB_getS(context).joinTogether,
                                textColor: theme.textColor,
                                fontSize: 20.px,
                                fontWeight: FontWeight.w600,
                              ),
                              // ShareGroupContentWidget(groupInfo: groupInfo, qrGlobalKey: qrGlobalKey,),
                              SizedBox().expanded(flex: 3),
                              Row(children: []),

                              ///二维码
                              if (code != null)
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: theme.white,
                                    borderRadius: BorderRadius.all(Radius.circular(12.px)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.px),
                                    child: QrImageView(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.all(6),
                                      data:
                                      (code?.url ?? '') + '?inviteCode=' + (code?.code ?? '')+'&userId='+ABSharedPreferences.getUserIdSync(),
                                      // data: ABShare.getAppShareUrl(inviteCode: '111'),
                                      size: 190.0.px,
                                    ),
                                  ),
                                ),
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
                              //邀请码
                              if (code != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final ClipboardData clipboardData =
                                        ClipboardData(text: code?.code ?? '');
                                        await Clipboard.setData(clipboardData);
                                        toShowTip(2);
                                      },
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              theme.primaryColor.withOpacity(0.1),
                                              theme.primaryColor.withOpacity(0.4)
                                            ]),
                                            borderRadius: BorderRadius.all(Radius.circular(18))),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 20.px, right: 20.px,top: 5.px,bottom: 5.px),
                                          child: Row(
                                            children: [
                                              Center(
                                                child: Center(
                                                  child: ABText(
                                                    AB_getS(context).myInvitationCode +' '+
                                                        (code?.code ?? ''),
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
                                height: 8.px,
                              ),
                              //邀请链接
                              if (code != null)
                                Padding(
                                  padding: EdgeInsets.only(left: 10.px, right: 10.px),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          final ClipboardData clipboardData = ClipboardData(
                                              text: (code?.url ?? '') +
                                                  '?inviteCode=' +
                                                  (code?.code ?? ''));
                                          await Clipboard.setData(clipboardData);
                                          toShowTip(2);
                                        },
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                theme.primaryColor.withOpacity(0.1),
                                                theme.primaryColor.withOpacity(0.4)
                                              ]),
                                              borderRadius: BorderRadius.all(Radius.circular(30))),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 20.px, right: 20.px,top: 5.px,bottom: 5.px),
                                            child: Row(
                                              children: [
                                                Center(
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(maxWidth:280.px,minWidth: 120.px ),
                                                    child: SizedBox(
                                                      child: Text(
                                                        (code?.url ?? '') +
                                                            '?inviteCode=' +
                                                            (code?.code ?? '')+'&userId='+ABSharedPreferences.getUserIdSync(),
                                                        style: TextStyle(
                                                          fontSize: 12.px,
                                                          color: theme.textFB8B04,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
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
                                ),
                              SizedBox().expanded(flex: 10),
                              if (code != null)
                                SizedBox  (
                                  width: ABScreen.width,
                                  height: 48.px,
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 36.0.px, right: 36.px,),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                                border: Border.all(
                                                    width: 2, color: theme.primaryColor)),
                                            child: InkWell(
                                              onTap: () {
                                                _saveLocalImage();
                                                toShowTip(1);
                                              },
                                              child: SizedBox(
                                                height: 48.px,
                                                child: Center(
                                                  child: ABText(
                                                    AB_getS(context).save,
                                                    textColor: theme.primaryColor,
                                                    fontSize: 15.px,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16.px),
                                        Expanded(
                                          child: ABButton.gradientColorButton(
                                            colors: [theme.primaryColor, theme.secondaryColor],
                                            cornerRadius: 12,
                                            height: 48.px,
                                            text: AB_getS(context).share,
                                            textColor: theme.textColor,
                                            onPressed: () async {
                                              final ClipboardData clipboardData = ClipboardData(
                                                  text: (code?.url ?? '') +
                                                      '?inviteCode=' +
                                                      (code?.code ?? '')+'&userId='+ABSharedPreferences.getUserIdSync());
                                              await Clipboard.setData(clipboardData);
                                              // ABToast.show(TIM_t("已复制"));
                                              toShowTip(2);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              SizedBox().expanded(flex: 3),
                            ],
                          );
                        }
                    ),
                  ),
                  if(showTip)copyTipView(),
                ],
              );
            }
        ),
      ),
    );
  }

  Widget copyTipView(){
    final theme = AB_theme(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.white.withOpacity(0.8)
      ),
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
                ABAssets.copyOk(context),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.px,),
            ABText(
              tipType==1?AB_getS(context).saveAlbumSuccessfully:AB_getS(context).copiedClipboardSuccessfully,
              textColor: theme.textColor,
              fontSize: 16.px,
            ),
          ],
        ),
      ),
    );
  }
  // Future<void> saveWidgetAsImage() async {
  //   try {
  //     final boundary = qrGlobalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
  //     final image = await boundary.toImage(pixelRatio: 3.0);
  //     final byteData = await image.toByteData(format: ImageByteFormat.png);
  //     final pngBytes = byteData?.buffer.asUint8List();
  //
  //     // 保存图片到文件系统
  //     // 这里可以使用 file 或 path_provider 包来保存图片
  //   } catch (e) {
  //     print('Error saving widget as image: $e');
  //   }
  // }

  _saveLocalImage() async {
    // 申请权限
    bool hasLocationPermission = await requestPhotoPermission();
    if (!hasLocationPermission) {
      return;
    }
    RenderRepaintBoundary boundary =
        qrGlobalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    ABLoading.show();
    ByteData? byteData = await (image.toByteData(format: ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      await ABLoading.dismiss();
      print(result);
      final isSuccess = result["isSuccess"] as bool? ?? false;
      final errorMsg = result["errorMessage"] as String?;
      final path = result["filePath"] as String?;
      print("path - ${path}");
      if (isSuccess) {
        ABToast.show(AB_getS(MyApp.context, listen: false).savedToAlbum);
      } else {
        ABToast.show(
            errorMsg ?? AB_getS(MyApp.context, listen: false).saveFail);
      }
    } else {
      ABLoading.dismiss();
    }
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    final result = await UserNet.getUserMemberCode();
    if (result.data != null) {
      setState(() {
        code = result.data!;
      });
    }
    return result.data != null;
  }
}

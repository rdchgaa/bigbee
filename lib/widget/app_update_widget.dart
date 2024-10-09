import 'dart:io';
import 'dart:math';

import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_update/azhon_app_update.dart';
import 'package:flutter_app_update/update_model.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/common/version_list_model.dart';
import '../utils/ab_screen.dart';

class AppUpdateWidget {
static double get height => 468;

  static show(BuildContext context, VersionListModel versionModel) {
    final language = Provider.of<LanguageProvider>(context, listen: false).locale.languageCode;
    final isForce = versionModel.isForceUpdates == 2;
    final content = (language.contains("zh") ? versionModel.languageMsgCn : versionModel.languageMsgUs) ?? "";
    final version = versionModel.versionNum ?? "";
    final downloadUrl = versionModel.downloadAddr ?? "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = AB_theme(context);
        return PopScope(
          canPop: false,
          child: Container(
            color: Colors.transparent,
            height: height,
            child: Stack(
              children: [
                Positioned(
                  top: 62,
                  child: Container(
                    width: ABScreen.width,
                    height: height - 62,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ABScreen.width / 20),
                        topRight: Radius.circular(ABScreen.width / 20),
                      ),
                      image: DecorationImage(
                        image: AssetImage(ABAssets.updateBg(context)), // 使用AssetImage加载本地图片
                        fit: BoxFit.cover, // 使图片覆盖整个Container
                        alignment: Alignment.topCenter, // 图片居上居中对齐
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 104,),
                        ABText(AB_getS(context).findNewVersion, textColor: theme.textColor, fontSize: 24, fontWeight: FontWeight.bold,),
                        // 版本号
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 14),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          // alignment: Alignment.center,
                          // height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // 渐变色
                            gradient: LinearGradient(
                              colors: [
                                HexColor("FEC12B"),
                                HexColor("FB8D05"),
                              ],
                            ),
                          ),
                          child: ABText("V$version", textColor: theme.primaryColor, fontSize: 16, fontWeight: FontWeight.bold,),
                        ),
                        // 标题
                        Align(
                          alignment: Alignment.centerLeft,
                            child: ABText(AB_getS(context).versionUpdate, textColor: HexColor("#989897"), fontSize: 16,)),
                        const SizedBox(height: 10,),
                        // 更新内容
                        Expanded(child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Text(content, style: TextStyle(color: HexColor("#323333"), fontSize: 16),),
                          ],
                        )),
                        const SizedBox(height: 26,),
                        // 立即更新
                        ABButton.gradientColorButton(
                          colors: [theme.primaryColor, theme.secondaryColor],
                          cornerRadius: 12,
                          height: 48,
                          text: AB_getS(context).nowUpdate,
                          onPressed: () {
                            // Navigator.of(context).pop();

                            if (Platform.isAndroid) {
                              downloadAndUpdate(context, downloadUrl);
                              // _showUpdateDialog(context);
                            } else {
                              launchUrl(downloadUrl);
                            }
                          },
                        ),
                        SizedBox(height: 10 + ABScreen.bottomHeight,)
                      ]
                    ).addPadding(padding: EdgeInsets.symmetric(horizontal: 20),),
                  ),
                ),
                // 更新图片
                Positioned(
                    top: 0,
                    height: 156,
                    width: ABScreen.width,
                    left: 0,
                    child: Image.asset(ABAssets.updateIcon(context), fit: BoxFit.contain,),
                ),
                // 关闭按钮
                if (!isForce) Positioned(
                  top: 62,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 44,
                      width: 44,
                      child: Icon(Icons.close, color: HexColor("#989897"), size: 24,).center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  static void launchUrl(String url,{LaunchMode? mode}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrlString(url,mode: mode??LaunchMode.platformDefault);
    } else {
      throw 'Could not launch $url';
    }
  }


  static Future<void> downloadAndUpdate(BuildContext context, String apkUrl) async {
    UpdateModel model = UpdateModel(
      apkUrl,
      "beechat.apk",
      /// android res/mipmap 目录下的图片名称
      "ic_launcher",
      'https://itunes.apple.com/cn/app/抖音/id1142110895',
    );
    final updateRes = await AzhonAppUpdate.update(model);
    if (updateRes) {
      Navigator.of(context).pop();
      await Future.delayed(Duration(milliseconds: 400));
      _showUpdateDialog(context);
    } else {
      launchUrl("https://www.baidu.com");
    }
  }

  static void _showUpdateDialog(BuildContext context) {

    SmartDialog.show(
        clickMaskDismiss: false,
      maskColor: Colors.transparent,
        backDismiss: false,
      builder: (_) => DownloadingProgressWidget().center,
    );

    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) {
    //     return InkWell(
    //         onTap: () {
    //           Navigator.of(context).pop();
    //         },
    //         child: DownloadingProgressWidget(onTap: (){
    //
    //         },).center,
    //     );
    //   },
    // );
  }

}


class DownloadingProgressWidget extends StatefulWidget {

  const DownloadingProgressWidget({super.key});

  @override
  State<DownloadingProgressWidget> createState() => _DownloadingProgressWidgetState();
}

class _DownloadingProgressWidgetState extends State<DownloadingProgressWidget> {
  int maxValue = 0;
  int currentValue = 0;
  String? _title;

  @override
  void initState() {
    super.initState();

    // 监听下载进度
    AzhonAppUpdate.listener((Map<String, dynamic> map){
      // {type: downloading, max: 71839641, progress: 39512096}
      if (map["type"] == "downloading") {
        setState(() {
          maxValue = map["max"];
          currentValue = map["progress"];
          if (maxValue > 0 && maxValue == currentValue) {
            _title = AB_getS(context).downloadCompleted;
          }
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);

    final W = ABScreen.width - 80 - 48;
    return InkWell(
      onTap: () {
        // 阻止背景点击时间
      },
      child: Container(
        height: ABScreen.height,
        width: ABScreen.width,
        color: Colors.black.withOpacity(0.4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          margin: EdgeInsets.only(bottom: ABScreen.bottomHeight + 60),
          decoration: BoxDecoration(
            color: theme.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ABText(_title ?? AB_getS(context).downloading, textColor: theme.textColor,),
              const SizedBox(height: 10,),
              // 进度条
              Container(
                alignment: Alignment.centerLeft,
                height: 4,
                width: W,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Container(
                  height: 4,
                  width: W * max(currentValue, 1) / max(maxValue, 100),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
            ]
          )
        ).center,
      ),
    );
  }
}


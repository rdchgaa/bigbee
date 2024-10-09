import 'package:bee_chat/models/mine/collection_details_model.dart';
import 'package:bee_chat/net/mine_net.dart';
import 'package:bee_chat/pages/dialog/forward_chat_dialog.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:url_launcher/url_launcher.dart';

class FilePreviewPage extends StatefulWidget {
  final CollectionDetailsRecords record;
  final V2TimFileElem model;

  const FilePreviewPage({
    super.key,
    required this.model,
    required this.record,
  });

  @override
  State<FilePreviewPage> createState() => _FilePreviewPageState();
}

class _FilePreviewPageState extends State<FilePreviewPage> with SingleTickerProviderStateMixin {
  String? localPath;

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
    localPath = await downLoadNetWorkFile(widget.model.url, fileName: widget.model.UUID);
    if (mounted) {
      setState(() {});
    }
  }

  tryOpenFile(BuildContext context) async {
    final theme = CommonColor.defaultTheme;
    if (PlatformUtils().isMobile) {
      if (PlatformUtils().isIOS) {
        if (!await Permissions.checkPermission(context, Permission.photosAddOnly.value, theme, false)) {
          return;
        }
      } else {
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if ((androidInfo.version.sdkInt) >= 33) {
        } else {
          var storage = await Permissions.checkPermission(
            context,
            Permission.storage.value,
          );
          if (!storage) {
            return;
          }
        }
      }
    }

    try {
      if (PlatformUtils().isDesktop && !PlatformUtils().isWindows) {
        launchUrl(Uri.file(localPath!));
      } else {
        OpenFile.open(localPath);
      }
      // ignore: empty_catches
    } catch (e) {
      OpenFile.open(localPath);
    }
  }

  share() {
    V2TimFileElem model = widget.model;
    model.path = localPath;
    showForwardChatDialog(context, fileElem: model, saveCallback: () {
      ABToast.show(AB_S().save + ' ' + AB_S().success);
    }, cancelCollectCallback: () {
      cancelCollect();
    }, otherAPPOpenCallback: () {
      tryOpenFile(context);
    });
  }

  cancelCollect() async {
    var resultRecords =
        await MineNet.mineCancelMessage(collectId: widget.record.collectId ?? 0, messageId: widget.record.id ?? 0);
    if (resultRecords.success == true) {
      ABToast.show(AB_S().cancel + ' ' + AB_S().success);
      ABRoute.pop(context: context);
    } else {
      ABToast.show(AB_S().fail);
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
        title: AB_getS(context).file,
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
        rightWidget: localPath == null
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.only(right: 16.0.px),
                child: Center(
                  child: InkWell(
                      onTap: () async {
                        share();
                      },
                      child: Image.asset(
                        ABAssets.mineMore1(context),
                        width: 24.px,
                        height: 24.px,
                      )),
                ),
              ),
      ),
      backgroundColor: theme.backgroundColor,
      body: localPath == null
          ? loadBuild()
          : InkWell(
              onTap: () {
                tryOpenFile(context);
              },
              child: Column(
                children: [
                  SizedBox(height: 93.px),
                  Center(
                    child: Image.asset(
                      ABAssets.fileZip(context),
                      width: 72.px,
                      height: 72.px,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      widget.model.fileName ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.text282109,
                        fontSize: 16.px,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget loadBuild() {
    return Padding(
      padding: EdgeInsets.only(top: 100.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            radius: 15,
          ),
        ],
      ),
    );
  }
}

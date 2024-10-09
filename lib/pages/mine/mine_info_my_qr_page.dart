import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/user/user_detail_model.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/permission_util.dart';
import 'package:bee_chat/widget/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_loading.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_screen.dart';
import '../../utils/ab_toast.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../utils/oss_utils.dart';
import '../../utils/photo_utils.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_image.dart';
import '../../widget/ab_text.dart';
import '../../widget/ab_text_field.dart';

class MineInfoMyQrPage extends StatefulWidget {
  final UserDetailModel userInfo;
  final String userId;

  const MineInfoMyQrPage({super.key, required this.userInfo, required this.userId});

  @override
  State<MineInfoMyQrPage> createState() => _MineInfoMyQrPageState();
}

class _MineInfoMyQrPageState extends State<MineInfoMyQrPage> {

  final GlobalKey qrGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  initData() async {}

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

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return RepaintBoundary(
      key: qrGlobalKey,
      child: Scaffold(
        appBar: ABAppBar(
          title: AB_getS(context).qrCard,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.px
            ),
            // 信息
            SizedBox(
              width: 70.px,
              height: 70.px,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: ABImage.avatarUser(widget.userInfo.avatarUrl ?? ""),
                ),
              ),
            ),
            SizedBox(height: 15.px),
            Text(
              widget.userInfo.nickName ?? '',
              style: TextStyle(fontSize: 14.px, color: theme.text282109),
            ),
            SizedBox(height: 5.px),
            Text(
              'ID:' + widget.userId,
              style: TextStyle(fontSize: 14.px, color: theme.text282109),
            ),
            Padding(
              padding: EdgeInsets.all(12.px),
              child: QrImageView(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(6),
                data:
                'ID:' + widget.userId,
                // data: ABShare.getAppShareUrl(inviteCode: '111'),
                size: 190.0.px,
              ),
            ),
            Text(
              AB_S().qrCardTip,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.px, color: theme.textGrey),
            ),
            SizedBox(height: 80.px),
            ABButton.gradientColorButton(
              text: AB_getS(context).save+(isZh?'':' ')+AB_getS(context).picture,
              colors: [theme.primaryColor, theme.secondaryColor],
              textColor: theme.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 48,
              onPressed: () {
                _saveLocalImage();
              },
            ).addPadding(padding: const EdgeInsets.symmetric(horizontal: 16))
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/pages/common/Widget/share_group_content_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../utils/ab_share.dart';

class ShareGroupPage extends StatelessWidget {
  final V2TimGroupInfo groupInfo;
  final GlobalKey qrGlobalKey = GlobalKey();
  ShareGroupPage({super.key, required this.groupInfo});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).shareGroup,
      ),
      body: Column(
        children: [
          SizedBox(height: 26,),
          ShareGroupContentWidget(groupInfo: groupInfo, qrGlobalKey: qrGlobalKey,),
          SizedBox().expanded(),
          Container(
            height: ABScreen.bottomHeight + 80,
            width: ABScreen.width,
            decoration: BoxDecoration(
              color: theme.white,
              // 阴影
              boxShadow: [
                BoxShadow(
                  color: theme.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buttonWidget(context: context, title: AB_getS(context).save, imageName: ABAssets.shareSave(context), onTap: () {
                      _saveLocalImage();
                    }).expanded(),
                    // _buttonWidget(context: context, title: AB_getS(context).share, imageName: ABAssets.shareShare(context), onTap: (){
                    //
                    // }).expanded(),
                  ],
                ).expanded(),
                SizedBox(height: ABScreen.bottomHeight,),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonWidget({required BuildContext context, String title = "", String imageName = "", VoidCallback? onTap}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 21,),
            Image.asset(imageName, width: 24, height: 24,),
            const SizedBox(height: 6,),
            ABText(title, textColor: theme.textColor, fontSize: 12,)
          ],
        ),
      )
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
    RenderRepaintBoundary boundary =
    qrGlobalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    ABLoading.show();
    ByteData? byteData =
    await (image.toByteData(format: ImageByteFormat.png));
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
        ABToast.show(errorMsg ?? AB_getS(MyApp.context, listen: false).saveFail);
      }
    } else {
      ABLoading.dismiss();
    }

  }


}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bee_chat/pages/chat/widget/message_list/im_bubble_widget.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/history_message_constant.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/image_screen.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
// import 'package:universal_html/html.dart' as html;

class ImImageMessageItem extends StatefulWidget {
  final V2TimMessage message;
  final bool isFromSelf;
  final bool isShowJump;
  final VoidCallback clearJump;
  final String? isFrom;
  const ImImageMessageItem({super.key, required this.message, required this.isFromSelf, required this.isShowJump, required this.clearJump, this.isFrom});

  @override
  State<ImImageMessageItem> createState() => _ImImageMessageItemState();
}

class _ImImageMessageItemState extends State<ImImageMessageItem> {
  final TUIChatGlobalModel model = serviceLocator<TUIChatGlobalModel>();

  bool isSent = false;
  bool isShowJumpState = false;
  bool isShining = false;

  @override
  Widget build(BuildContext context) {

    V2TimImage? originalImg = getImageFromList(V2TimImageTypesEnum.original);
    V2TimImage? smallImg = getImageFromList(V2TimImageTypesEnum.small);
    final heroTag =
        "${widget.message.msgID ?? widget.message.id ?? widget.message.timestamp ?? DateTime.now().millisecondsSinceEpoch}${widget.isFrom}";
    final theme = AB_theme(context);

    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        // widget.clearJump();
      }
    }
    return Container(
      padding: EdgeInsets.only(
        left: widget.isFromSelf ? 0 : 6,
        right: widget.isFromSelf ? 6 : 0,),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // 边框
        border: Border.all(
            color: isShowJumpState ? theme.primaryColor : Colors.transparent,
            width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ImBubbleWidget(child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.6,
                  minWidth: 64,
                  maxHeight: 256,
                ),
                child: _renderImage(heroTag, originalImg: originalImg, smallImg: smallImg) ?? Container(),
              ),
            );
          }).addPadding(padding: EdgeInsets.all(10)),
          isFromSelf: widget.isFromSelf),
    );
  }

  _showJumpColor() {
    if (!widget.isShowJump) {
      return;
    }
    isShining = true;
    int shineAmount = 6;
    setState(() {
      isShowJumpState = true;
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          isShowJumpState = shineAmount.isOdd ? true : false;
        });
      }
      if (shineAmount == 0 || !mounted) {
        isShining = false;
        timer.cancel();
      }
      shineAmount--;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.clearJump();
    });
  }

  V2TimImage? getImageFromList(V2TimImageTypesEnum imgType) {
    V2TimImage? img = MessageUtils.getImageFromImgList(
        widget.message.imageElem!.imageList,
        HistoryMessageDartConstant.imgPriorMap[imgType] ??
            HistoryMessageDartConstant.oriImgPrior);

    return img;
  }

  bool isNeedShowLocalPath() {
    final current = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
    final timeStamp = widget.message.timestamp ?? current;
    return (widget.message.isSelf ?? true) &&
        (isSent || current - timeStamp < 300);
  }

  Widget? _renderImage(dynamic heroTag,
      {V2TimImage? originalImg, V2TimImage? smallImg}) {

    double positionRadio = 1.0;
    if (smallImg?.width != null &&
        smallImg?.height != null &&
        smallImg?.width != 0 &&
        smallImg?.height != 0) {
      positionRadio = (smallImg!.width! / smallImg.height!);
    }

    try {
      if ((isNeedShowLocalPath() &&
          widget.message.imageElem!.path != null &&
          widget.message.imageElem!.path!.isNotEmpty &&
          File(widget.message.imageElem!.path!).existsSync())) {
        return _renderAllImage(
            smallLocalPath: widget.message.imageElem!.path!,
            heroTag: heroTag,
            positionRadio: positionRadio,
            originLocalPath: widget.message.imageElem!.path!);
      }
    } catch (e) {
      print("图片错误 - ${e.toString()}");
    }

    try {
      if ((TencentUtils.checkString(smallImg?.localUrl) != null &&
          File((smallImg?.localUrl!)!).existsSync()) ||
          (TencentUtils.checkString(originalImg?.localUrl) != null &&
              File((originalImg?.localUrl!)!).existsSync())) {
        return _renderAllImage(
            smallLocalPath: smallImg?.localUrl ?? "",
            heroTag: heroTag,
            positionRadio: positionRadio,
            originLocalPath: originalImg?.localUrl);
      }
    } catch (e) {
      print("图片错误 - ${e.toString()}");
      return _renderAllImage(
          heroTag: heroTag,
          isNetworkImage: true,
          smallImg: smallImg,
          positionRadio: positionRadio,
          originalImg: originalImg);
    }

    if ((smallImg?.url ?? originalImg?.url) != null &&
        (smallImg?.url ?? originalImg?.url)!.isNotEmpty) {
      return _renderAllImage(
          heroTag: heroTag,
          isNetworkImage: true,
          positionRadio: positionRadio,
          smallImg: smallImg,
          originalImg: originalImg);
    }

    return errorPage();
  }

  Widget errorPage() {
    return Container(
      color: Colors.grey,
      height: 170,
      width: 170,
    );
  }

  Widget _renderAllImage(
      {dynamic heroTag,
        double? positionRadio,
        bool isNetworkImage = false,
        String? webPath,
        V2TimImage? originalImg,
        V2TimImage? smallImg,
        String? smallLocalPath,
        String? originLocalPath}) {
    Widget getImageWidget() {
      if (isNetworkImage) {
        return Hero(
            tag: heroTag,
            child: PlatformUtils().isWeb
                ? Image.network(webPath ?? smallImg?.url ?? originalImg!.url!,
                fit: BoxFit.contain)
                : CachedNetworkImage(
              alignment: Alignment.topCenter,
              imageUrl: webPath ?? smallImg?.url ?? originalImg!.url!,
              errorWidget: (context, error, stackTrace) =>
                  errorPage(),
              fit: BoxFit.contain,
              cacheKey: smallImg?.uuid ?? originalImg!.uuid,
              placeholder: (context, url) =>
                  Image(image: MemoryImage(kTransparentImage)),
              fadeInDuration: const Duration(milliseconds: 0),
            ));
      } else {
        final imgPath = (TencentUtils.checkString(smallLocalPath) != null
            ? smallLocalPath
            : originLocalPath)!;
        return Hero(
            tag: heroTag,
            child: Image.file(File(imgPath), fit: BoxFit.contain));
      }
    }

    double? currentPositionRadio;

    return GestureDetector(
      onTap: () => onClickImage(
          heroTag: heroTag,
          isNetworkImage: isNetworkImage,
          imgUrl: webPath ?? smallImg?.url ?? originalImg?.url ?? "",
          imgPath: (TencentUtils.checkString(originLocalPath) != null
              ? originLocalPath
              : smallLocalPath) ??
              ""),
      child: Stack(
        children: [
          if (positionRadio != null)
            AspectRatio(
              aspectRatio: (currentPositionRadio ?? positionRadio)!,
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
          getImageWidget(),
        ],
      ),
    );
  }

  void onClickImage({
    required bool isNetworkImage,
    dynamic heroTag,
    String? imgUrl,
    String? imgPath,
  }) {
    if (isNetworkImage) {
      if (PlatformUtils().isWeb) {
        TUIKitWidePopup.showMedia(
            context: context,
            mediaURL: widget.message.imageElem?.path ?? "",
            onClickOrigin: () => launchUrl(
              Uri.parse(widget.message.imageElem?.path ?? ""),
              mode: LaunchMode.externalApplication,
            ));
        return;
      }
      Navigator.of(context).push(
        PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => ImageScreen(
                imageProvider: CachedNetworkImageProvider(
                  imgUrl ?? "",
                  cacheKey: widget.message.msgID,
                ),
                heroTag: heroTag,
                messageID: widget.message.msgID,
                downloadFn: () async {
                  return await _saveImg();
                })),
      );
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false, // set to false
          pageBuilder: (_, __, ___) => ImageScreen(
              imageProvider: FileImage(File(imgPath ?? "")),
              heroTag: heroTag,
              messageID: widget.message.msgID,
              downloadFn: () async {
                return await _saveImg();
              }),
        ),
      );
    }
  }

  Future<void> _saveImg() async {
    try {
      String? imageUrl;
      bool isAssetBool = false;
      final imageElem = widget.message.imageElem;

      if (imageElem != null) {
        final originUrl = getOriginImgURL();
        final localUrl = imageElem.imageList?.firstOrNull?.localUrl;
        final filePath = imageElem.path;
        final isWeb = PlatformUtils().isWeb;

        if (!isWeb && filePath != null && File(filePath).existsSync()) {
          imageUrl = filePath;
          isAssetBool = true;
        } else if (localUrl != null &&
            (!isWeb && File(localUrl).existsSync())) {
          imageUrl = localUrl;
          isAssetBool = true;
        } else {
          imageUrl = originUrl;
          isAssetBool = false;
        }
      }

      if (imageUrl != null) {
        return await _saveImageToLocal(
          context,
          imageUrl,
          isLocalResource: isAssetBool,
        );
      }
    } catch (e) {
      ABToast.show(TIM_t("正在下载中"));
      return;
    }
  }

  //保存网络图片到本地
  Future<void> _saveImageToLocal(
      context,
      String imageUrl, {
        bool isLocalResource = true,
      }) async {

    if (PlatformUtils().isIOS) {
      if (!await Permissions.checkPermission(
          context, Permission.photosAddOnly.value, TUITheme(), false)) {
        return;
      }
    } else {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (PlatformUtils().isMobile) {
        if ((androidInfo.version.sdkInt) >= 33) {
          final photos = await Permissions.checkPermission(
            context,
            Permission.photos.value,
            TUITheme(),
          );
          if (!photos) {
            return;
          }
        } else {
          final storage = await Permissions.checkPermission(
            context,
            Permission.storage.value,
          );
          if (!storage) {
            return;
          }
        }
      }
    }

    if (!isLocalResource) {
      if (widget.message.msgID == null || widget.message.msgID!.isEmpty) {
        return;
      }

      if (model.getMessageProgress(widget.message.msgID) == 100) {
        String savePath;
        if (widget.message.imageElem!.path != null &&
            widget.message.imageElem!.path != '') {
          savePath = widget.message.imageElem!.path!;
        } else {
          savePath = model.getFileMessageLocation(widget.message.msgID);
        }
        File f = File(savePath);
        if (f.existsSync()) {
          var result = await ImageGallerySaver.saveFile(savePath);

          if (PlatformUtils().isIOS) {
            if (result['isSuccess']) {
              ABToast.show(TIM_t("图片保存成功"));

            } else {
              ABToast.show(TIM_t("图片保存失败"));
            }
          } else {
            if (result != null) {
              ABToast.show(TIM_t("图片保存成功"));
            } else {
              ABToast.show(TIM_t("图片保存失败"));
            }
          }
          return;
        }
      } else {
        ABToast.show(TIM_t("the message is downloading"));
      }
      return;
    }

    var result = await ImageGallerySaver.saveFile(imageUrl);

    if (PlatformUtils().isIOS) {
      if (result['isSuccess']) {
        ABToast.show(TIM_t("图片保存成功"));
      } else {
        ABToast.show(TIM_t("图片保存失败"));
      }
    } else {
      if (result != null) {
        ABToast.show(TIM_t("图片保存成功"));
      } else {
        ABToast.show(TIM_t("图片保存失败"));
      }
    }
    return;
  }

  String getOriginImgURL() {
    // 实际拿的是原图
    V2TimImage? img = MessageUtils.getImageFromImgList(
        widget.message.imageElem!.imageList,
        HistoryMessageDartConstant.oriImgPrior);
    return img == null ? widget.message.imageElem!.path! : img.url!;
  }

}

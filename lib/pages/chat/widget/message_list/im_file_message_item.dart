import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bee_chat/pages/chat/widget/message_list/im_bubble_widget.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/TIMUIKitMessageReaction/tim_uikit_message_reaction_wrapper.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitMessageItem/tim_uikit_chat_file_icon.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/textSize.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

class ImFileMessageItem extends StatefulWidget {
  final String? messageID;
  final V2TimFileElem? fileElem;
  final bool isSelf;
  final bool isShowJump;
  final VoidCallback? clearJump;
  final V2TimMessage message;
  final bool? isShowMessageReaction;
  final TUIChatSeparateViewModel chatModel;
  final bool isFromReply;

  const ImFileMessageItem(
      {super.key,
      required this.chatModel,
      required this.messageID,
      required this.fileElem,
      required this.isSelf,
      required this.isShowJump,
      this.clearJump,
      required this.message,
      this.isShowMessageReaction,
      this.isFromReply = false});

  @override
  State<StatefulWidget> createState() => _ImFileMessageItemState();
}

class _ImFileMessageItemState extends TIMUIKitState<ImFileMessageItem> {
  String filePath = "";
  bool isWebDownloading = false;
  final TUIChatGlobalModel model = serviceLocator<TUIChatGlobalModel>();
  int downloadProgress = 0;
  V2TimAdvancedMsgListener? advancedMsgListener;
  final GlobalKey containerKey = GlobalKey();
  double? containerHeight;
  bool? _downloadFailed = false;

  bool isShowJumpState = false;
  bool isShining = false;

  @override
  void dispose() {
    if (advancedMsgListener != null) {
      TencentImSDKPlugin.v2TIMManager.getMessageManager().removeAdvancedMsgListener(listener: advancedMsgListener);
      advancedMsgListener = null;
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!PlatformUtils().isWeb) {
      Future.delayed(const Duration(microseconds: 10), () {
        hasFile();
      });
    }
  }

  Future<bool> addAdvancedMsgListenerForDownload() async {
    if (advancedMsgListener != null) {
      return false;
    }
    advancedMsgListener = V2TimAdvancedMsgListener(
      onMessageDownloadProgressCallback: (V2TimMessageDownloadProgress messageProgress) async {
        if (messageProgress.msgID == widget.message.msgID) {
          if (messageProgress.isError || messageProgress.errorCode != 0) {
            setState(() {
              _downloadFailed = true;
            });
            return;
          }

          if (messageProgress.isFinish) {
            if (mounted) {
              setState(() {
                downloadProgress = 100;
              });

              if (advancedMsgListener != null) {
                TencentImSDKPlugin.v2TIMManager
                    .getMessageManager()
                    .removeAdvancedMsgListener(listener: advancedMsgListener);
                advancedMsgListener = null;
              }
            }
          } else {
            final currentProgress = (messageProgress.currentSize / messageProgress.totalSize * 100).floor();
            if (mounted && currentProgress > downloadProgress) {
              setState(() {
                downloadProgress = currentProgress;
              });
            }
          }
        }
      },
    );
    await TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(listener: advancedMsgListener!);
    return true;
  }

  Future<String> getSavePath() async {
    String savePathWithAppPath = '/storage/emulated/0/Android/data/com.tencent.flutter.tuikit/cache/' +
        (widget.message.msgID ?? "") +
        widget.fileElem!.fileName!;
    return savePathWithAppPath;
  }

  Future<bool> hasFile() async {
    if (PlatformUtils().isWeb) {
      return true;
    }
    String savePath = TencentUtils.checkString(model.getFileMessageLocation(widget.messageID)) ??
        TencentUtils.checkString(widget.message.fileElem!.localUrl) ??
        widget.message.fileElem?.path ??
        '';
    File f = File(savePath);
    if (f.existsSync() && widget.messageID != null) {
      filePath = savePath;
      if (downloadProgress != 100) {
        setState(() {
          downloadProgress = 100;
        });
      }
      if (model.getMessageProgress(widget.messageID) != 100) {
        model.setMessageProgress(widget.messageID!, 100);
      }
      if (advancedMsgListener != null) {
        TencentImSDKPlugin.v2TIMManager.getMessageManager().removeAdvancedMsgListener(listener: advancedMsgListener);
        advancedMsgListener = null;
      }
      return true;
    }
    return false;
  }

  String showFileSize(int fileSize) {
    if (fileSize < 1024) {
      return fileSize.toString() + "B";
    } else if (fileSize < 1024 * 1024) {
      return (fileSize / 1024).toStringAsFixed(2) + "KB";
    } else if (fileSize < 1024 * 1024 * 1024) {
      return (fileSize / 1024 / 1024).toStringAsFixed(2) + "MB";
    } else {
      return (fileSize / 1024 / 1024 / 1024).toStringAsFixed(2) + "GB";
    }
  }

  addUrlToWaitingPath(TUITheme theme) async {
    if (widget.messageID != null) {
      model.addWaitingList(widget.messageID!);
    }
    if (model.getWaitingListLength() == 1) {
      await downloadFile(theme);
    }
  }

  checkIsWaiting() {
    bool res = false;
    try {
      if (widget.messageID!.isNotEmpty) {
        res = model.isWaiting(widget.messageID!);
      }
    } catch (err) {
      // err
    }
    return res;
  }

  downloadFile(TUITheme theme) async {
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
    await model.downloadFile();
  }

  Future<bool> hasZeroSize(String filePath) async {
    try {
      final file = File(filePath);
      final fileSize = await file.length();
      return fileSize == 0;
    } catch (e) {
      return false;
    }
  }

  tryOpenFile(context, theme) async {
    if (!PlatformUtils().isWeb && (await hasZeroSize(filePath) || widget.message.status == 3)) {
      onTIMCallback(TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: "不支持 0KB 文件的传输", infoCode: 6660417));
      return;
    }
    if (PlatformUtils().isMobile) {
      if (PlatformUtils().isIOS) {
        if (!await Permissions.checkPermission(context, Permission.photosAddOnly.value, theme!, false)) {
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
        launchUrl(Uri.file(filePath));
      } else {
        OpenFile.open(filePath);
      }
      // ignore: empty_catches
    } catch (e) {
      OpenFile.open(filePath);
    }
  }

  void downloadWebFile(String fileUrl) async {
    if (mounted) {
      setState(() {
        isWebDownloading = true;
      });
    }
    String fileName = Uri.parse(fileUrl).pathSegments.last;
    try {
      http.Response response = await http.get(
        Uri.parse(fileUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      final html.AnchorElement downloadAnchor = html.document.createElement('a') as html.AnchorElement;

      final html.Blob blob = html.Blob([response.bodyBytes]);

      downloadAnchor.href = html.Url.createObjectUrlFromBlob(blob);
      downloadAnchor.download = widget.message.fileElem?.fileName ?? fileName;

      downloadAnchor.click();
    } catch (e) {
      html.AnchorElement(
        href: widget.fileElem?.path ?? "",
      )
        ..setAttribute("download", widget.message.fileElem?.fileName ?? fileName)
        ..setAttribute("target", '_blank')
        ..style.display = "none"
        ..click();
    }
    if (mounted) {
      setState(() {
        isWebDownloading = false;
      });
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        // widget.clearJump?.call();
      }
    }

    final theme = value.theme;
    final fileName = widget.fileElem!.fileName ?? "";
    final fileSize = widget.fileElem!.fileSize;

    String? fileFormat;
    if (widget.fileElem?.fileName != null && widget.fileElem!.fileName!.isNotEmpty) {
      final String fileName = widget.fileElem!.fileName!;
      fileFormat = fileName.split(".")[max(fileName.split(".").length - 1, 0)];
    }
    final RenderBox? containerRenderBox = containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (containerRenderBox != null) {
      containerHeight = containerRenderBox.size.height;
    }

    var contentWidget = Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 237),
          child: Container(
            padding: EdgeInsets.zero,
            // height: 54,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: widget.isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  TIMUIKitFileIcon(
                    padding: EdgeInsets.zero,
                    fileFormat: fileFormat,
                    size: widget.isFromReply ? 44 : 54,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (buildContext, boxConstraints) {
                          return CustomText(
                            fileName,
                            width: boxConstraints.maxWidth,
                            maxLines: 1,
                            style: TextStyle(
                              color: theme.darkTextColor,
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                      if (fileSize != null)
                        Text(
                          showFileSize(fileSize),
                          style: TextStyle(fontSize: 14, color: theme.weakTextColor),
                        )
                    ],
                  )),
                ]),
          ),
        ),
        if (checkIsWaiting())
          Positioned(
              right: 14,
              bottom: 6,
              child: CupertinoActivityIndicator(
                radius: 6,
                color: Colors.grey,
              ).center),
      ],
    );
    if (widget.isFromReply) {
      return GestureDetector(
        onTap: () {
          _fileOnTap(theme);
        },
        child: contentWidget.addPadding(
            padding: EdgeInsets.only(
          bottom: 4,
        )),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: widget.isSelf ? 0 : 6,
        right: widget.isSelf ? 6 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // 边框
        border: Border.all(color: isShowJumpState ? theme.primaryColor! : Colors.transparent, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: () {
          _fileOnTap(theme);
        },
        child: ImBubbleWidget(
          isFromSelf: widget.isSelf,
          child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: contentWidget.addPadding(padding: const EdgeInsets.all(14))),
        ),
      ),
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
      widget.clearJump?.call();
    });
  }

  Future<void> _fileOnTap(TUITheme theme) async {
    try {
      await addAdvancedMsgListenerForDownload();
      if (await hasFile()) {
        if (downloadProgress == 100) {
          tryOpenFile(context, theme);
        } else {
          ABToast.show(TIM_t("正在下载中"));
        }
        return;
      }
      if (checkIsWaiting()) {
        onTIMCallback(
          TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: TIM_t("已加入待下载队列，其他文件下载中"), infoCode: 6660413),
        );
        return;
      } else {
        await addUrlToWaitingPath(theme);
      }
    } catch (e) {
      onTIMCallback(TIMCallback(type: TIMCallbackType.INFO, infoRecommendText: "文件处理异常", infoCode: 6660416));
    }
  }
}

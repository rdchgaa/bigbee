import 'package:bee_chat/models/mine/collection_message_list_model.dart';
import 'package:bee_chat/net/mine_net.dart';
import 'package:bee_chat/pages/chat/c2c_chat_page.dart';
import 'package:bee_chat/pages/dialog/config_dialog.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/pages/mine/collection/collection_details_page.dart';
import 'package:bee_chat/pages/mine/collection/file_preview_page.dart';
import 'package:bee_chat/pages/mine/collection/utils/collection_utils.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/im/im_message_utils.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/forward_message_screen.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_text.dart';
import 'package:video_player/video_player.dart';

class CollectionMessageItemWidget extends StatefulWidget {
  final CollectionMessageListRecords item;
  final Function cancelCollectionCallback;

  const CollectionMessageItemWidget({
    super.key,
    required this.item,
    required this.cancelCollectionCallback,
  });

  @override
  State<CollectionMessageItemWidget> createState() => _CollectionMessageItemWidgetState();
}

class _CollectionMessageItemWidgetState extends State<CollectionMessageItemWidget> with AutomaticKeepAliveClientMixin {
  final _controller = SuperTooltipController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = AB_theme(context);
    return ColoredBox(
      color: theme.backgroundColorWhite,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0.px, right: 16.px, top: 14.px, bottom: 16.px),
        child: Builder(builder: (context) {
          List<Widget> listBuild = [];
          var length = (widget.item.searchMessageList ?? []).length;
          length = length >= 5 ? 5 : length;
          for (var i = 0; i < length; i++) {
            CollectionMessageListRecordsSearchMessageList item = widget.item.searchMessageList![i];

            //添加虚线
            if (i > 0) {
              listBuild.add(dashLine());
            }
            listBuild.add(contentView(item));
          }
          return InkWell(
            onTap: () async {
              // ABRoute.push(FilePreviewPage());
              await ABRoute.push(CollectionDetailsPage(
                item: widget.item,
              ));
              widget.cancelCollectionCallback();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.px),
                          child: ABImage.avatarUser(widget.item.formAvatar ?? '', width: 40.px, height: 40.px),
                        ),
                        SizedBox(width: 12.px),
                        ABText(
                          widget.item.formNickName ?? '',
                          textColor: theme.text999,
                          fontSize: 14.px,
                        ),
                      ],
                    ),
                    SuperTooltip(
                      minimumOutsideMargin: 16.px - 6,
                      controller: _controller,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      arrowTipDistance: 8.px,
                      arrowBaseWidth: 0,
                      arrowLength: 0,
                      borderColor: Colors.transparent,
                      hasShadow: false,
                      content: _toolWidget(),
                      child: Image.asset(
                        ABAssets.mineMore(context),
                        color: theme.textGrey,
                        width: 20.px,
                        height: 20.px,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                ...listBuild
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget dashLine() {
    final theme = AB_theme(context);
    return Padding(
      padding: EdgeInsets.only(top: 10.0.px),
      child: LayoutBuilder(builder: (context, con) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Dash(
              direction: Axis.horizontal,
              length: con.maxWidth,
              dashColor: theme.text999.withOpacity(0.2),
              dashLength: 3),
        );
      }),
    );
  }

  //类型：1，文字；2，表情；3，图片；4，定位；5，语音；6，视频；7，txt文档；8，zip文档；
  Widget contentView(CollectionMessageListRecordsSearchMessageList item) {
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");
    DateTime? time = DateTime.tryParse(item.createTime ?? '') ?? null;
    var timeString = '';
    if (time != null) {
      timeString =
          '${time.year}${isZh ? "年" : "Year"}${time.month}${isZh ? "月" : "Month"}${time.day}${isZh ? "日" : "Day"}';
    }

    if (item.type == 1 || item.type == 2 || item.type == 3 || item.type == 4 || item.type == 5 || item.type == 6) {
      //1，文字；2，表情；3，图片；4，定位；5，语音；6，视频；
      return contentTextView(item, timeString);
    } else if (item.type == 7 || item.type == 8) {
      //7，txt文档；8，zip文档；
      return fileTextView(item, timeString);
    }
    return contentTextView(item, timeString);
  }

  String getContentSpan(String text, BuildContext context) {
    List<InlineSpan> _contentList = [];
    String contentData = PlatformUtils().isWeb ? '\u200B' : "";

    Iterable<RegExpMatch> matches = LinkUtils.urlReg.allMatches(text);

    int index = 0;
    final theme = AB_theme(context);
    var style = TextStyle(fontSize: 16.px, color: theme.text282109);
    for (RegExpMatch match in matches) {
      String c = text.substring(match.start, match.end);
      if (match.start == index) {
        index = match.end;
      }
      if (index < match.start) {
        String a = text.substring(index, match.start);
        index = match.end;
        contentData += a;
        _contentList.add(
          TextSpan(text: a),
        );
      }

      if (LinkUtils.urlReg.hasMatch(c)) {
        contentData += '\$' + c + '\$';
        _contentList.add(TextSpan(
            text: c,
            style: TextStyle(color: LinkUtils.hexToColor("015fff")),
            recognizer: TapGestureRecognizer()..onTap = () {}));
      } else {
        contentData += c;
        _contentList.add(
          TextSpan(text: c, style: style ?? const TextStyle(fontSize: 16.0)),
        );
      }
    }
    if (index < text.length) {
      String a = text.substring(index, text.length);
      contentData += a;
      _contentList.add(
        TextSpan(text: a, style: style ?? const TextStyle(fontSize: 16.0)),
      );
    }

    return contentData;
  }

  //类型：1，文字；2，表情；3，图片；4，定位；5，语音；6，视频
  Widget contentTextView(CollectionMessageListRecordsSearchMessageList item, String time) {
    final theme = AB_theme(context);
    var isGroup = widget.item.groupInfoId != null;

    Widget build = const SizedBox();
    if (item.type == 1 || item.type == 2) {
      //1，文字；2，表情；

      build = ExtendedText(getContentSpan(item.value ?? '', context),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: theme.textColor, fontSize: 14.px),
          specialTextSpanBuilder: DefaultSpecialTextSpanBuilder(
            isUseQQPackage: true,
            isUseTencentCloudChatPackage: true,
            customEmojiStickerList: TUIKitStickerConstData.emojiList,
            showAtBackground: true,
          ));
    } else if (item.type == 3) {
      //3，图片；
      V2TimImage? model = CollectionUtils.collectionMessageImage(context, value: item.value ?? '');
      build = SizedBox(
        width: 110.px,
        height: 82.px,
        child: Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(6.px),
                child: ABImage.avatarUser(model?.url ?? '', width: 110.px, height: 82.px))),
      );
    } else if (item.type == 5) {
      //5，语音
      V2TimSoundElem? model = CollectionUtils.collectionMessageSound(context, value: item.value ?? '');

      build = SizedBox(
        width: 75.px,
        height: 32.px,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              ABAssets.imSoundPlayImage(context),
              width: 75.px,
              height: 32.px,
            )),
      );
    } else if (item.type == 6) {
      //6，视频

      V2TimVideoElem? model = CollectionUtils.collectionMessageVideo(context, value: item.value ?? '');

      build = SizedBox(
        width: 110.px,
        height: 82.px,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                SizedBox(
                  width: 110.px,
                  height: 82.px,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.px), child: VideoFrameWidget(url: model?.videoUrl ?? '')),
                ),
                Positioned.fill(
                  // alignment: Alignment.center,
                  child: Center(
                      child: Image.asset(
                    ABAssets.videoPlay(context),
                    width: 24.px,
                    height: 24.px,
                  )),
                ),
              ],
            )),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 15.0.px),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: build,
                ),
                if (!isGroup)
                  Padding(
                    padding: EdgeInsets.only(left: 12.px),
                    child: ABText(
                      time,
                      textColor: theme.text999,
                      fontSize: 12.px,
                    ),
                  ),
              ],
            ),
            if (isGroup)
              Padding(
                padding: EdgeInsets.only(top: item.type == 1 ? 1.px : 6.px),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ABText(
                    '${item.nickName == null ? '' : '来自于 ' + item.nickName} $time',
                    textColor: theme.text999,
                    fontSize: 12.px,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  //类型：7，txt文档；8，zip文档；
  Widget fileTextView(CollectionMessageListRecordsSearchMessageList item, String time) {
    final theme = AB_theme(context);
    var isGroup = widget.item.groupInfoId != null;

    Widget build = const SizedBox();
    if (item.type == 7) {
      V2TimFileElem? model = CollectionUtils.collectionMessageFile(context, value: item.value ?? '');

      build = DecoratedBox(
        decoration: BoxDecoration(color: theme.f4f4f4, borderRadius: BorderRadius.all(Radius.circular(12.px))),
        child: SizedBox(
          width: double.infinity,
          height: 70.px,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 16.px),
              Image.asset(
                ABAssets.fileZip(context),
                width: 46.px,
                height: 46.px,
              ),
              SizedBox(width: 14.px),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ABText(
                    getFileNameFromUrl(model?.fileName ?? ''),
                    textColor: theme.text282109,
                    fontSize: 14.px,
                  ),
                  SizedBox(
                    height: 20.px,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ABText(
                        '${((model?.fileSize ?? 0) / 1024 / 1024).toStringAsFixed(2)}MB',
                        textColor: theme.text999,
                        fontSize: 12.px,
                      ),
                      // child: FutureBuilder<String?>(
                      //   future: fetchFileSize(item.value ?? ''),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       return ABText(
                      //         '${snapshot.data}MB',
                      //         textColor: theme.text999,
                      //         fontSize: 12.px,
                      //       );
                      //     } else if (snapshot.hasError) {
                      //       return SizedBox();
                      //     }
                      //     return SizedBox();
                      //   },
                      // ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 15.0.px),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            build,
            Padding(
              padding: EdgeInsets.only(top: item.type == 1 ? 1.px : 6.px),
              child: Align(
                alignment: Alignment.centerRight,
                child: ABText(
                  '${item.nickName == null ? '' : '${AB_S().from} ' + item.nickName} $time',
                  textColor: theme.text999,
                  fontSize: 12.px,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getFileNameFromUrl(String url) {
    var name = path.basename(url);
    if (name.length > 18) {
      name = name.substring(
            0,
            10,
          ) +
          '...' +
          name.substring(name.length - 8, name.length);
    }
    return name;
  }

  Future<String?> fetchFileSize(String url) async {
    HttpFileModel? model = ABSharedPreferences.checkHasHttpFile(url);
    if (model == null) {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        // 获取Content-Length头部获取文件大小
        int? contentLength = int.tryParse(response.headers['content-length'].toString()) ?? 0;

        HttpFileModel file = HttpFileModel(url: url, byte: contentLength);
        ABSharedPreferences.setHttpFileByte(file);
        return (contentLength / 1024 / 1024).toStringAsFixed(2);
      } else {
        return '0';
      }
    } else {
      return (model.byte / 1024 / 1024).toStringAsFixed(2);
    }
  }

  Widget _toolWidget() {
    final theme = AB_theme(context);
    return HomeToolTipWidget(
      items: [
        HomeToolTipItem(
          title: AB_getS(context).forward,
          icon: Image.asset(
            ABAssets.mineShare(context),
            width: 24.px,
            height: 24.px,
          ),
          onTap: () {
            ///TODO 转发
            forWard();
          },
        ),
        HomeToolTipItem(
          title: AB_getS(context).removeFavorites,
          icon: Image.asset(
            ABAssets.mineCollNo(context),
            width: 24.px,
            height: 24.px,
          ),
          onTap: () async {
            bool? value = await showConfigDialog(context, title: AB_S().CancelFavorite);
            if (value == true) {
              ///TODO 取消收藏
              cancelCollection();
            }
          },
        ),
      ],
      onTap: (_) {
        _controller.hideTooltip();
      },
    );
  }

  forWard() async {
    TUIChatSeparateViewModel model = TUIChatSeparateViewModel();
    List<V2TimConversation?>? value = await ABRoute.push(ForwardMessageScreen(
      model: model,
      isMergerForward: false,
      conversationType: ConvType.c2c,
      onlySelect: true,
    ));
    if (value != null && value.isNotEmpty) {
      ABToast.show(AB_S().forward + AB_S().success);
      for (var i = 0; i < value.length; i++) {
        if (value[i] != null) {
          V2TimConversation item = value[i]!;
          final msg = await ImMessageUtils.sendCollectionMessage(
              userId: item.userID ?? '', groupId: item.groupID ?? '', collectionMessageListRecords: widget.item);
        }
      }
    } else {}
  }

  cancelCollection() async {
    var resultRecords = await MineNet.mineCancelCollect(
      collectId: widget.item.collectId ?? 0,
    );
    if (resultRecords.success == true) {
      widget.cancelCollectionCallback();
    } else {
      ABToast.show(AB_S().fail);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class HttpFileModel {
  final String url;
  final int byte;

  HttpFileModel({required this.url, required this.byte});

  HttpFileModel copyWith({
    String? url,
    int? byte,
  }) {
    return HttpFileModel(
      url: url ?? this.url,
      byte: byte ?? this.byte,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'byte': byte,
    };
  }

  static HttpFileModel? fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return HttpFileModel(
      url: map['url']?.toString() ?? "",
      byte: null == (temp = map['byte']) ? 0 : (temp is num ? temp.toInt() : (num.tryParse(temp)?.toInt() ?? 0)),
    );
  }
}

class VideoFrameWidget extends StatefulWidget {
  final String url;

  const VideoFrameWidget({super.key, required this.url});

  @override
  _VideoFrameWidgetState createState() => _VideoFrameWidgetState();
}

class _VideoFrameWidgetState extends State<VideoFrameWidget> with AutomaticKeepAliveClientMixin{
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    // 使用本地或网络视频文件的路径来初始化控制器
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _initializeVideoPlayerFuture = _controller!.initialize();
    super.initState();
  }

  @override
  void dispose() {
    // 释放资源
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null
        ? SizedBox()
        : FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // 获取视频第5秒的帧
                return Center(
                  child: VideoPlayer(_controller!),
                );
              } else {
                return Center(child: SizedBox());
              }
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'dart:io';

import 'package:bee_chat/models/mine/collection_details_model.dart';
import 'package:bee_chat/models/mine/collection_message_list_model.dart';
import 'package:bee_chat/net/mine_net.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_sound_message_item.dart';
import 'package:bee_chat/pages/mine/collection/file_preview_page.dart';
import 'package:bee_chat/pages/mine/collection/utils/collection_utils.dart';
import 'package:bee_chat/pages/mine/collection/widget/collection_message_item_widget.dart';
import 'package:bee_chat/pages/mine/collection/widget/collection_sound_message_item.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/image_screen.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/video_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CollectionDetailsPage extends StatefulWidget {
  final CollectionMessageListRecords item;

  const CollectionDetailsPage({
    super.key,
    required this.item,
  });

  @override
  State<CollectionDetailsPage> createState() => _CollectionDetailsPageState();
}

class _CollectionDetailsPageState extends State<CollectionDetailsPage> with SingleTickerProviderStateMixin {
  List<CollectionDetailsRecords> recordsList = [];
  int pageNum = 1;
  bool hasMore = false;

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
    pageNum = 1;
    var resultRecords = await MineNet.mineMessageGetDetails(collectId: widget.item.collectId ?? 0, pageNum: pageNum);
    if (resultRecords.data != null) {
      recordsList = resultRecords.data?.records ?? [];
      hasMore = recordsList.length < (resultRecords.data?.total ?? 0);
    }
    if (mounted) setState(() {});
  }

  onMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await MineNet.mineMessageGetDetails(collectId: widget.item.collectId ?? 0, pageNum: pageNum);
    if (resultRecords.data != null) {
      recordsList.addAll(resultRecords.data?.records ?? []);
      hasMore = recordsList.length < (resultRecords.data?.total ?? 0);
    }
    if (mounted) setState(() {});
  }

  _saveImg(V2TimImage model) async{
    var filePath = await downLoadNetWorkFile(model.url,fileName: model.uuid);

    var result = await ImageGallerySaver.saveFile(filePath);

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
    return filePath;
  }

  openImage(V2TimImage model) {
    Navigator.of(context).push(
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => ImageScreen(
                imageProvider: CachedNetworkImageProvider(
                  model.url??'',
                  cacheKey: model.url??'',
                ),
                heroTag: model.url??'',
            downloadFn: ()async{
                  await _saveImg(model);
                  ABRoute.pop(context: context);
            },
              )),
    );
  }
  openVideo(V2TimVideoElem? model,int? id){
    if(model==null)return ;
    var message = V2TimMessage(elemType: 6,msgID: id.toString(),videoElem: model);
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (_, __, ___) => VideoScreen(
          message: message,
          heroTag: model.videoUrl,
          videoElement: model,
        ),
      ),
    );
  }

  openFile(V2TimFileElem? model,CollectionDetailsRecords item) async{
    if(model==null)return;
    await ABRoute.push(FilePreviewPage(model: model,record: item,));
    initData();
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
        title: "\"" + (widget.item.formNickName ?? '') + "\" " + AB_getS(context).chatRecord,
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
      ),
      backgroundColor: theme.backgroundColor,
      body: EasyRefresh(
          header: CustomizeBallPulseHeader(color: theme.primaryColor),
          onRefresh: () async {
            initData();
          },
          onLoad: !hasMore
              ? null
              : () async {
                  onMore();
                },
          child: recordsList.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  color: theme.backgroundColor,
                  child: Image.asset(ABAssets.emptyIcon(context)),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(top: 26.px,bottom: 26.px),
                  itemBuilder: (context, index) {
                    CollectionDetailsRecords item = recordsList[index];
                    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
                      context,
                    );
                    final isZh = languageProvider.locale.languageCode.contains("zh");
                    DateTime? time = DateTime.tryParse(item.messageTime ?? '') ?? null;
                    var timeString = '';
                    if (time != null) {
                      // timeString =
                      // '${time.year}${isZh ? "年" : "Year"}${time.month}${isZh ? "月" : "Month"}${time.day}${isZh ? "日" : "Day"}';
                      timeString = '${time.year}-${time.month}-${time.day} '
                          '${time.hour < 10 ? ("0" + time.hour.toString()) : time.hour}:'
                          '${time.minute < 10 ? ("0" + time.minute.toString()) : time.minute}:'
                          '${time.second < 10 ? ("0" + time.second.toString()) : time.second}';
                    }
                    return contentTextView(item, timeString);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 18.px,
                    );
                  },
                  itemCount: recordsList.length)),
    );
  }

  //类型：1，文字；2，表情；3，图片；4，定位；5，语音；6，视频
  Widget contentTextView(CollectionDetailsRecords item, String time) {
    final theme = AB_theme(context);
    var isGroup = widget.item.groupInfoId != null;

    Widget build = const SizedBox();
    var contentWidth = MediaQuery.of(context).size.width - 120.px;
    if (item.type == 1 || item.type == 2) {
      //1，文字；2，表情；

      build = ExtendedText(getContentSpan(item.value ?? '', context),
          softWrap: true,
          // overflow: TextOverflow.ellipsis,
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
      var imageWidth = contentWidth;
      var imageHeight = imageWidth * 0.6;
      if (model?.width != null && model?.height != null) {
        imageHeight = imageWidth / model!.width! * model.height!;
      }
      build = SizedBox(
        width: imageWidth,
        height: imageHeight,
        child: Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(6.px),
                child: InkWell(
                    onTap: () {
                      model==null?null:openImage(model);
                    },
                    child: Hero(
                        tag: model?.url ?? '',
                        child: ABImage.avatarUser(model?.url ?? '', width: imageWidth, height: imageHeight))))),
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

      build = CollectionSoundMessageItem(
        message: model!,
        clearJump: () {},
        isShowJump: false,
      );
    } else if (item.type == 6) {
      //6，视频

      V2TimVideoElem? model = CollectionUtils.collectionMessageVideo(context, value: item.value ?? '');
      var imageWidth = contentWidth;
      var imageHeight = imageWidth * 0.6;
      if (model?.snapshotWidth != null && model?.snapshotHeight != null) {
        imageHeight = imageWidth / model!.snapshotWidth! * model.snapshotHeight!;
      }
      build = SizedBox(
        width: imageWidth,
        height: imageHeight,
        child: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: (){
                openVideo(model,item.collectId);
              },
              child: Hero(
                tag: model!.videoUrl??'',
                child: Stack(
                  children: [
                    SizedBox(
                      width: imageWidth,
                      height: imageHeight,
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
                ),
              ),
            )),
      );
    } else if (item.type == 7 || item.type == 8) {
      //7，文件  8，文件
      V2TimFileElem? model = CollectionUtils.collectionMessageFile(context, value: item.value ?? '');

      build = InkWell(
        onTap: (){
          openFile(model,item);
        },
        child: SizedBox(
          width: double.infinity,
          height: 58.px,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 8.px),
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

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.px, right: 16.px, bottom: 20.px),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.px),
              child: ABImage.avatarUser(item.avatar ?? '', width: 48.px, height: 48.px),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 6.px),
                  child: ABText(
                    item.nickName ?? '',
                    textColor: theme.text999,
                    fontSize: 14.px,
                  ),
                ),
                SizedBox(
                  width: contentWidth,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DecoratedBox(
                        decoration:
                            BoxDecoration(color: theme.f4f4f4, borderRadius: BorderRadius.all(Radius.circular(12.px))),
                        child: Padding(padding: EdgeInsets.all(10.px), child: build)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.px),
                  child: ABText(
                    time,
                    textColor: theme.text999,
                    fontSize: 12.px,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

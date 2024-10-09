import 'dart:math';

import 'package:bee_chat/models/dynamic/posts_details_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dialog/help_posts_dialog.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/pages/mine/collection/widget/collection_message_item_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_event_bus.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_browser/photo_browser.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/custom_message_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/video_screen.dart';

import '../../../utils/ab_assets.dart';

class DynamicDetailsWidget extends StatefulWidget {
  final PostsDetailsModel details;

  const DynamicDetailsWidget({
    super.key,
    required this.details,
  });

  @override
  State<DynamicDetailsWidget> createState() => _DynamicDetailsWidgetState();
}

class _DynamicDetailsWidgetState extends State<DynamicDetailsWidget> with AutomaticKeepAliveClientMixin {

  toFocus() async{
    bool isFocus = widget.details.isFocus != 1;
    var resultRecords = await DynamicsNet.dynamicsFocus(
        memberNum: widget.details.memberNum??'1', isFocus: isFocus);
    if(resultRecords.success==true){
      setState(() {
        widget.details.isFocus = isFocus?1:2;
      });
      ABToast.show(isFocus?AB_S().followSuccess:AB_S().unfollowSuccess, toastType: ToastType.success);
      ABEventBus.fire(FocusEvent(userID: widget.details.memberNum??'1', isFocus: isFocus));
    }else{
      ABToast.show(isFocus?AB_S().followFailed:AB_S().unfollowFailed, toastType: ToastType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    // 动态列表item
    return Container(
        // margin: EdgeInsets.only(left: 16.px, right: 16.px, bottom: 10.px),
        padding: EdgeInsets.all(14.px),
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(12.px),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头像+昵称+时间+省略号icon
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // 头像
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ABImage.avatarUser(widget.details.avatarUrl ?? '', height: 48.px, width: 48.px),
              ),
              SizedBox(width: 10.px),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 昵称
                  Text(
                    widget.details.nickName ?? '',
                    style: TextStyle(fontSize: 14.px, color: theme.textColor, fontWeight: FontWeight.w600),
                  ),
                  // 时间
                  Builder(builder: (context) {
                    DateTime? date = DateTime.tryParse(widget.details.publishTime ?? '');
                    if (date == null) return SizedBox();
                    return Text(
                      '${date.year}-${date.month}-${date.day}',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: theme.textGrey,
                      ),
                    );
                  }),
                ],
              ).expanded(),
              if(widget.details.isMyself!=1)ABButton(
                text: widget.details.isFocus == 1 ? "${AB_getS(context).followed}" : "+${AB_getS(context).follow}",
                backgroundColor: widget.details.isFocus == 1 ? theme.textGrey : theme.primaryColor,
                cornerRadius: 6,
                height: 33.px,
                width: 68.px,
                textColor: theme.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                onPressed: () {
                  toFocus();
                },
              ),
            ]),
            SizedBox(height: 10.px),
            // 内容
            if(widget.details.textContent!=null&&widget.details.textContent!='')ExtendedText(
                widget.details.textContent ?? '',
                style: TextStyle(
                  fontSize: 14.px,
                  color: theme.textColor,),
                specialTextSpanBuilder: DefaultSpecialTextSpanBuilder(
                  isUseQQPackage: true,
                  isUseTencentCloudChatPackage: true,
                  customEmojiStickerList: TUIKitStickerConstData.emojiList,
                  showAtBackground: true,
                )
            ),
            //视频
            if (widget.details.videoUrl != null && widget.details.videoUrl!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10.0.px),
                child: LayoutBuilder(builder: (context, con) {
                  var url = widget.details.videoUrl??'';
                  return InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false, // set to false
                            pageBuilder: (_, __, ___) => VideoScreen(
                              message: V2TimMessage(elemType: 6),
                              heroTag: url,
                              videoElement: V2TimVideoElem(videoUrl: url,snapshotHeight: 170,snapshotWidth: 296),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.px),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: con.maxWidth,
                                  height: con.maxWidth / 296 * 170,
                                child: VideoFrameWidget(url:url),
                              ),
                              Positioned.fill(
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
                ),
             ),
            // 图片
            if (widget.details.imgeUrls != null && widget.details.imgeUrls!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10.0.px),
                child: LayoutBuilder(builder: (context, con) {
                  // if(model.imgeUrls.contains(';'))
                  List<String> images = widget.details.imgeUrls!.split(';');
                  if (images.isEmpty) {
                    return SizedBox();
                  }
                  if(images.length==1){
                    return InkWell(
                      onTap: (){
                        openImages(context,images);
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.px),
                          child: ABImage.imageWithUrl(images[0],
                              width: con.maxWidth, height: con.maxWidth / 296 * 170, fit: BoxFit.cover)),
                    );
                  }else{
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5.px,
                            crossAxisSpacing: 5.px,
                            childAspectRatio: 109/80),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              openImages(context,images,initIndex: index);
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.px),
                                child: ABImage.imageWithUrl(images[index],
                                    width: con.maxWidth / 3, height: con.maxWidth / 3, fit: BoxFit.cover)),
                          );
                        }
                    );
                  }
                }),
              ),
          ],
        )).addPadding(
      padding: EdgeInsets.only(top: 10.px),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

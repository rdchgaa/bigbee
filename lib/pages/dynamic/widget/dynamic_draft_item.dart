import 'package:bee_chat/models/dynamic/draft_box_list_model.dart';
import 'package:bee_chat/models/dynamic/look_history_posts_model.dart';
import 'package:bee_chat/pages/dynamic/dynamic_details_page.dart';
import 'package:bee_chat/pages/mine/collection/widget/collection_message_item_widget.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';

import '../../../utils/ab_assets.dart';

class DynamicDraftItem extends StatefulWidget {
  final DraftBoxListRecords model;

  const DynamicDraftItem({
    super.key,
    required this.model,
  });

  @override
  State<DynamicDraftItem> createState() => _DynamicDraftItemState();
}

class _DynamicDraftItemState extends State<DynamicDraftItem> with AutomaticKeepAliveClientMixin {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = AB_theme(context);
    // 动态列表item
    return Container(
        padding: EdgeInsets.all(14.px),
        decoration: BoxDecoration(
          color: theme.white,
          borderRadius: BorderRadius.circular(12.px),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 内容
            (widget.model.textContent != null && widget.model.textContent != '')?
              SizedBox(
                width: ABScreen.width - 100.px,
                child: ExtendedText((widget.model.textContent ?? ''),
                    style: TextStyle(
                      fontSize: 14.px,
                      color: theme.textColor,
                    ),
                    specialTextSpanBuilder: DefaultSpecialTextSpanBuilder(
                      isUseQQPackage: true,
                      isUseTencentCloudChatPackage: true,
                      customEmojiStickerList: TUIKitStickerConstData.emojiList,
                      showAtBackground: true,
                    )),
              ).padding(bottom: 16.px):SizedBox(height: 35.px,),
            //视频
            if (widget.model.videoUrl != null && widget.model.videoUrl!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10.0.px),
                child: LayoutBuilder(builder: (context, con) {
                  var url = widget.model.videoUrl ?? '';
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(6.px),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: (con.maxWidth-15.px)/4,
                            height: ((con.maxWidth-15.px)/4) / (109 / 80),
                            child: VideoFrameWidget(url: url),
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
                      ));
                }),
              ),
            // 图片
            if (widget.model.imgeUrls != null && widget.model.imgeUrls!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10.0.px),
                child: LayoutBuilder(builder: (context, con) {
                  // if(model.imgeUrls.contains(';'))
                  List<String> images = widget.model.imgeUrls!.split(';');
                  if (images.isEmpty) {
                    return SizedBox();
                  }
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5.px,
                          crossAxisSpacing: 5.px,
                          childAspectRatio: 109 / 80),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(6.px),
                            child: ABImage.imageWithUrl(images[index],
                                width: con.maxWidth / 3, height: con.maxWidth / 3, fit: BoxFit.cover));
                      });
                }),
              ),
            SizedBox(height: 12.px),
            // 时间
            Builder(builder: (context) {
              DateTime? date = DateTime.tryParse(widget.model.createTime ?? '');
              if (date == null) return SizedBox();
              return Text(
                '${date.year}-${date.month}-${date.day}',
                style: TextStyle(
                  fontSize: 12.px,
                  color: theme.textGrey,
                ),
              );
            }),
            SizedBox(height: 2.px),
          ],
        ));
  }


  @override
  bool get wantKeepAlive => true;
}


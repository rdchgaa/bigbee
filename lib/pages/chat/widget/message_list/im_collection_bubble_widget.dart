import 'package:bee_chat/models/mine/collection_message_list_model.dart';
import 'package:bee_chat/pages/chat/widget/message_list/im_bubble_widget.dart';
import 'package:bee_chat/pages/mine/collection/collection_details_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';

import '../../../../utils/ab_assets.dart';
import '../../red_bag/red_bag_send_page.dart';

class ImCollectionBubbleWidget extends StatelessWidget {
  final CollectionMessageListRecords model;
  final bool isFromSelf;

  const ImCollectionBubbleWidget({super.key, required this.model, required this.isFromSelf});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);

    List<Widget> listBuild = [];
    var length = (model.searchMessageList ?? []).length;
    length = length >= 5 ? 5 : length;
    for (var i = 0; i < length; i++) {
      CollectionMessageListRecordsSearchMessageList item = model.searchMessageList![i];

      //添加虚线
      if (i > 0) {
        listBuild.add(dashLine(context));
      }
      listBuild.add(contentView(context, item));
    }
    return Padding(
      padding: EdgeInsets.only(
        left: isFromSelf ? 0 : 6,
        right: isFromSelf ? 6 : 0,
      ),
      child: InkWell(
        onTap: () async {
          await ABRoute.push(CollectionDetailsPage(
            item: model,
          ));
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ImBubbleWidget(
            isFromSelf: isFromSelf,
            child: Container(
              padding: const EdgeInsets.all(14),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.px),
                        child: ABImage.avatarUser(model.formAvatar ?? '', width: 40.px, height: 40.px),
                      ),
                      ABText(
                        model.formNickName ?? '',
                        textColor: theme.text282109,
                        fontSize: 14.px,
                      ),
                    ],
                  ),
                  ...listBuild
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //类型：1，文字；2，表情；3，图片；4，定位；5，语音；6，视频；7，txt文档；8，zip文档；
  Widget contentView(BuildContext context, CollectionMessageListRecordsSearchMessageList item) {
    final theme = AB_theme(context);
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
    Widget build = SizedBox();
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
    } else {
      //3，图片；4，定位；5，语音；6，视频；  78 文件
      var text = '';
      switch (item.type) {
        case 3:
          text = AB_S().picture;
          break;
        case 4:
          text = AB_S().location;
          break;
        case 5:
          text = AB_S().voice;
          break;
        case 6:
          text = AB_S().video;
          break;
        case 7:
          text = AB_S().file;
          break;
        case 8:
          text = AB_S().file;
          break;
      }
      build = SizedBox(
        child: ABText(
          '[$text]',
          textColor: theme.textColor,
          fontSize: 12.px,
        ),
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
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: item.type == 1 ? 1.px : 6.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ABText(
                    '${item.nickName == null ? '' : item.nickName}',
                    textColor: theme.textColor.withOpacity(0.6),
                    fontSize: 12.px,
                  ),
                  ABText(
                    '$timeString',
                    textColor: theme.textColor.withOpacity(0.5),
                    fontSize: 12.px,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashLine(BuildContext context) {
    final theme = AB_theme(context);
    return Padding(
      padding: EdgeInsets.only(top: 10.0.px),
      child: LayoutBuilder(builder: (context, con) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Dash(direction: Axis.horizontal, length: con.maxWidth, dashColor: theme.textColor, dashLength: 3),
        );
      }),
    );
  }
}

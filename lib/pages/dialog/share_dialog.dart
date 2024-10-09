import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/forward_message_screen.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_toast.dart';
import '../../widget/ab_text.dart';

class ShareDialog extends StatefulWidget {
  final String title;
  final List<ShareDialogItemModel> items;
  const ShareDialog({super.key, required this.title, this.items = const []});

  @override
  State<ShareDialog> createState() => _ShareDialogState();

  static Future show(BuildContext context,{
    String? title,
    List<ShareDialogItemModel> items = const [],
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ShareDialog(title: title ?? AB_S().share, items: items,);
      },
    );
  }


}

class _ShareDialogState extends State<ShareDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 16.px, bottom: 20.px, left: 16.px, right: 16.px),
          decoration: BoxDecoration(
            color: AB_theme(context).white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )
          ),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.textColor, fontSize: 18.px, fontWeight: FontWeight.bold),
          ),
        ),
        _chatListBuild(),
        if (widget.items.isNotEmpty) Dash(
          direction: Axis.horizontal,
          length: MediaQuery.of(context).size.width - 32.px,
          dashColor: theme.f4f4f4,
          dashLength: 3,
        ),
        if (widget.items.isNotEmpty) _itemWidget(widget.items),
        Container(
          height: 10.px,
          color: theme.f4f4f4,
        ),
        ABButton(
          text: AB_S().cancel, height: 58.px, backgroundColor: theme.white,textColor: theme.textColor, fontSize: 16.px, fontWeight: FontWeight.bold, onPressed: () {
            Navigator.pop(context);
        },
        ),
        Container(
          height: MediaQuery.of(context).padding.bottom,
          color: theme.white,
        ),
      ]
    );
  }

  Widget _itemWidget(List<ShareDialogItemModel> models) {
    final theme = AB_theme(context);
    var itemWidth = (MediaQuery.of(context).size.width - 16.px * 6) / 5;
    var itemHeight = itemWidth + 32.px;
    return Container(
      width: double.infinity,
      color: theme.white,
      padding: EdgeInsets.only(top: 20.px, bottom: 20.px, left: 16.px, right: 16.px),
      child: Wrap(
        spacing: 16.px, // 主轴（水平）方向上的子组件间距
        runSpacing: 16.px, // 交叉轴（垂直）方向上的子组件间距
        children: models.map((model) => InkWell(
          onTap: () {
           model.onTap.call();
          },
          child: Container(
            height: itemHeight,
            color: theme.white,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: itemWidth,
                  height: itemWidth,
                  decoration: BoxDecoration(
                    color: theme.f4f4f4,
                    borderRadius: BorderRadius.circular(12.px)
                  ),
                  child: Image.asset(
                    model.IconAssetName,
                    width: itemWidth - 20.px,
                    height: itemWidth - 20.px,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12.px),
                Container(
                    height: 20.px,
                    constraints: BoxConstraints(maxWidth: itemWidth),
                    child: Text(model.title, textAlign: TextAlign.center, overflow: TextOverflow.fade, maxLines: 1, style: TextStyle(color: theme.textColor, fontSize: 14.px),)
                )
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }

  _chatListBuild() {
    final theme = AB_theme(context);
    return LayoutBuilder(builder: (context, con) {
      var itemWidth = (con.maxWidth - 16.px * 6) / 5;
      var itemHeight = itemWidth + 25.px;
      final recentConvList = serviceLocator<TUIConversationViewModel>().conversationList;

      List<Widget> listBuild = [];
      var length = recentConvList.length >= 4 ? 4 : recentConvList.length;
      for (var i = 0; i < length; i++) {
        V2TimConversation? conversation = recentConvList[i];
        final faceUrl = conversation?.faceUrl ?? "";
        final showName = conversation?.showName ?? "";
        listBuild.add(Padding(
          padding: EdgeInsets.only(left: 16.px),
          child: InkWell(
            onTap: () {
              if (conversation == null) {return;}
              ABRoute.pop(result: [conversation]);
            },
            child: SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: Avatar(
                      faceUrl: faceUrl,
                      showName: showName,
                      type: conversation?.type,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ABText(
                      showName,
                      fontSize: 12.px,
                      overflow: TextOverflow.fade,
                      textColor: theme.text282109,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
      }

      return Container(
        color: theme.white,
        padding: EdgeInsets.only(bottom: 20.px),
        width: con.maxWidth,
        height: itemHeight + 20.px,
        child: Row(
          children: [
            ...listBuild,
            Padding(
              padding: EdgeInsets.only(left: 16.px),
              child: InkWell(
                onTap: () {
                  _toMore();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: Color(0xffFFCB32), borderRadius: BorderRadius.all(Radius.circular(itemWidth / 2))),
                      child: SizedBox(
                        width: itemWidth,
                        height: itemWidth,
                        child: Center(
                          child: Image.asset(
                            ABAssets.mineMoreUser(context),
                            width: itemWidth * 0.6,
                            height: itemWidth * 0.6,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ABText(
                        AB_S().moreFriend,
                        fontSize: 12.px,
                        overflow: TextOverflow.fade,
                        textColor: theme.text282109,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  _toMore() async {
    final cons = await ABRoute.push(ForwardMessageScreen(
      model: TUIChatSeparateViewModel(),
      isMergerForward: false,
      conversationType: ConvType.c2c,
      onlySelect: true,
    )) as List<V2TimConversation>?;
    ABRoute.pop(result: cons);
  }


}

class ShareDialogItemModel {
  final String title;
  final String IconAssetName;
  final Function onTap;

  ShareDialogItemModel({
    required this.title,
    required this.IconAssetName,
    required this.onTap,
  });
}


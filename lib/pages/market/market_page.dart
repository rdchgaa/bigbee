import 'dart:io';

import 'package:bee_chat/models/common/version_list_model.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/map/map_select_page.dart';
import 'package:bee_chat/pages/market/widget/mark_filter_widget.dart';
import 'package:bee_chat/pages/market/widget/mark_item_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/oss_utils.dart';
import 'package:bee_chat/utils/upload_oss.dart';
import 'package:bee_chat/widget/app_update_widget.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../utils/ab_assets.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_shared_preferences.dart';
import '../../widget/ab_text.dart';
import '../login_regist/start_page.dart';
import '../ttt/test_emoji_page.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  MarkFilterType _type = MarkFilterType.optional;
  List<MarkItemModel> models = MarkItemModel.getList();

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: theme.primaryColor,
            height: 58.px + ABScreen.statusHeight,
            width: double.infinity,
            child: Stack(
              children: [
                // 顶部背景
                Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: AspectRatio(
                        aspectRatio: 288 / 156,
                        child: Image.asset(
                          ABAssets.homeTopBackground(context),
                          fit: BoxFit.cover,
                        ))),
                // 市场
                Positioned(
                  top: ABScreen.statusHeight + 12.px,
                  left: 24.px,
                  child: Container(
                    height: 40.px,
                    alignment: Alignment.centerLeft,
                    child: ABText(
                      AB_getS(context).market1,
                      textColor: theme.textColor,
                      fontSize: 22.px,
                      fontWeight: FontWeight.bold,
                    ).addPadding(padding: EdgeInsets.only(right: 24.px)),
                  ),
                ),
                // add按钮
                Positioned(
                  right: 8.px,
                  bottom: 2.px,
                  child: InkWell(
                    onTap: () {
                      _addBtnAction();
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: 44.px,
                        height: 44.px,
                        child: Image.asset(
                          ABAssets.homeAddIcon(context),
                          width: 28.px,
                          height: 28.px,
                        )),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26,),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    children: [
                      MarkFilterWidget(
                        type: _type,
                        onTypeChanged: (type) {
                          setState(() {
                            _type = type;
                          });
                        },
                      ),
                      SizedBox(height: 16.px),
                    ],
                  );
                }
                return MarkItemWidget(model: models[index - 1]);
              },
              itemCount: models.length + 1,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _addBtnAction() async {
    // ABRoute.push(const TestEmojiPage());
  }

}

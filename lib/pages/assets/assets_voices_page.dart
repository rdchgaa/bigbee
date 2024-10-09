import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/pages/login_regist/start_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class AssetsVoicesPage extends StatefulWidget {
  const AssetsVoicesPage({super.key});

  @override
  State<AssetsVoicesPage> createState() => _AssetsVoicesPageState();
}

class _AssetsVoicesPageState extends State<AssetsVoicesPage> {
  SoundsType? voice;

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
    final theme = AB_theme(context);
    UserProvider provider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).messageAlertSounds,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16.px,
            ),
            ...SoundsType.values
                .map((e) => languageButtonItem(e.soundsTypeToText(), provider.noticeSetting.sound == e, () {
                      setState(() {
                        provider.noticeSetting = provider.noticeSetting.copyWith(sound: e);
                      });
                    })),
          ],
        ),
      ),
    );
  }

  Widget languageButtonItem(String title, bool isThis, Function onTap, {bool showLine = true}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        child: ColoredBox(
          color: theme.backgroundColorWhite,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 56.px,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0.px),
                      child: ABText(
                        title,
                        fontSize: 16.px,
                        textColor: theme.textColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Builder(builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(right: 16.px),
                        child: InkWell(
                          onTap: () {
                            onTap();
                          },
                          child: Image.asset(
                            isThis ? ABAssets.assetsSelect(context) : ABAssets.assetsUnSelect(context),
                            width: 24.px,
                            height: 24.px,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              showLine
                  ? Padding(
                      padding: EdgeInsets.only(left: 16.0.px, right: 16.0.px),
                      child: Divider(height: 1, color: theme.backgroundColor))
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

enum SoundsType {
  defaultSound,
  sound1,
  sound2,
  sound3,
  sound4,
  sound5,
  sound6,
  sound7,
  sound8,
  sound9,
  sound10,
  sound11,
  sound12,
  sound13
}

extension SoundsTypeExtension on SoundsType {
  String soundsPath() {
    switch (this) {
      case SoundsType.defaultSound:
        return "assets/audios/msg_default.mp3";
      case SoundsType.sound1:
        return "assets/audios/msg_001.mp3";
      case SoundsType.sound2:
        return "assets/audios/msg_002.mp3";
      case SoundsType.sound3:
        return "assets/audios/msg_003.mp3";
      case SoundsType.sound4:
        return "assets/audios/msg_004.mp3";
      case SoundsType.sound5:
        return "assets/audios/msg_005.mp3";
      case SoundsType.sound6:
        return "assets/audios/msg_006.mp3";
      case SoundsType.sound7:
        return "assets/audios/msg_007.mp3";
      case SoundsType.sound8:
        return "assets/audios/msg_008.mp3";
      case SoundsType.sound9:
        return "assets/audios/msg_009.mp3";
      case SoundsType.sound10:
        return "assets/audios/msg_010.mp3";
      case SoundsType.sound11:
        return "assets/audios/msg_011.mp3";
      case SoundsType.sound12:
        return "assets/audios/msg_012.mp3";
      case SoundsType.sound13:
        return "assets/audios/msg_013.mp3";
    }
  }
  String soundsTypeToText() {
    switch (this) {
      case SoundsType.defaultSound:
        return AB_S().defaultText;
      case SoundsType.sound1:
        return AB_S().notificationSound(1);
      case SoundsType.sound2:
        return AB_S().notificationSound(2);
      case SoundsType.sound3:
        return AB_S().notificationSound(3);
      case SoundsType.sound4:
        return AB_S().notificationSound(4);
      case SoundsType.sound5:
        return AB_S().notificationSound(5);
      case SoundsType.sound6:
        return AB_S().notificationSound(6);
      case SoundsType.sound7:
        return AB_S().notificationSound(7);
      case SoundsType.sound8:
        return AB_S().notificationSound(8);
      case SoundsType.sound9:
        return AB_S().notificationSound(9);
      case SoundsType.sound10:
        return AB_S().notificationSound(10);
      case SoundsType.sound11:
        return AB_S().notificationSound(11);
      case SoundsType.sound12:
        return AB_S().notificationSound(12);
      case SoundsType.sound13:
        return AB_S().notificationSound(13);
      default:
        return AB_S().defaultText;
    }
  }
}



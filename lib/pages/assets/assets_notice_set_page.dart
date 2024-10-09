import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/assets_voices_page.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class AssetsNoticeSetPage extends StatefulWidget {
  const AssetsNoticeSetPage({super.key});

  @override
  State<AssetsNoticeSetPage> createState() => _AssetsNoticeSetPageState();
}

class _AssetsNoticeSetPageState extends State<AssetsNoticeSetPage> {
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
        title: AB_getS(context).notificationSettings,
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
            // Padding(
            //   padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px, bottom: 12.px),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       AB_getS(context).noticeTips,
            //       style: TextStyle(
            //         color: theme.text999,
            //         fontSize: 14.px,
            //       ),
            //     ),
            //   ),
            // ),
            // _getSwitchRowWidget(
            //     title: AB_getS(context).notificationsDisplayPreviews,
            //     value: provider.noticeSetting.showPreview ?? false,
            //     onSwitchChange: (value) {
            //       provider.noticeSetting = provider.noticeSetting.copyWith(showPreview: value);
            //     },
            //     isLast: true),
            SizedBox(
              height: 18.px,
            ),
            _getSwitchRowWidget(
                title: AB_getS(context).soundReminders,
                value: provider.noticeSetting.showSound ?? false,
                onSwitchChange: (value) {
                  provider.noticeSetting = provider.noticeSetting.copyWith(showSound: value);
                  // FlutterRingtonePlayer().play(fromAsset: "assets/audios/msg_default.mp3");
                },
                isLast: false),
            if (provider.noticeSetting.showSound ?? false)
              setButtonItem(null, AB_getS(context).alertSounds, () async {
                await ABRoute.push(AssetsVoicesPage());
              }, rightText: provider.noticeSetting.sound.soundsTypeToText()),
            _getSwitchRowWidget(
                title: AB_getS(context).vibrationReminders,
                value: provider.noticeSetting.vibration ?? false,
                onSwitchChange: (value) {
                  provider.noticeSetting = provider.noticeSetting.copyWith(vibration: value);
                }),
          ],
        ),
      ),
    );
  }

  // switch row
  Widget _getSwitchRowWidget(
      {required String title, required bool value, bool isLast = false, Function(bool)? onSwitchChange}) {
    final theme = AB_theme(context);
    return Container(
      color: theme.white,
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Text(title,
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ))),
                const SizedBox(
                  width: 4,
                ),
                CupertinoSwitch(
                  value: value,
                  onChanged: (value) {
                    onSwitchChange?.call(value);
                  },
                  activeColor: theme.primaryColor,
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              color: theme.backgroundColor,
            ).addPadding(padding: const EdgeInsets.only(left: 16, right: 16)),
        ],
      ),
    );
  }

  Widget setButtonItem(String? assets, String title, Function onTap, {String? rightText, bool showLine = true}) {
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
                    Row(
                      children: [
                        assets == null
                            ? SizedBox(width: 16.px)
                            : Padding(
                                padding: EdgeInsets.only(left: 16.0.px, right: 12.px),
                                child: SizedBox(
                                  width: 24.px,
                                  height: 24.px,
                                  child: Image.asset(
                                    assets,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        ABText(
                          title,
                          fontSize: 16.px,
                          textColor: theme.textColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        //13.68+4.1+7.8=25.58
                        if (rightText != null)
                          ABText(
                            rightText,
                            fontSize: 14,
                            textColor: theme.text999,
                          ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.px, right: 16.px),
                          child: Image.asset(
                            ABAssets.assetsRight(context),
                            width: 9.px,
                            height: 15.px,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (showLine)
                Padding(
                  padding: EdgeInsets.only(left: 16.0.px, right: 16.0.px),
                  child: Divider(
                    height: 1,
                    color: theme.backgroundColor,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

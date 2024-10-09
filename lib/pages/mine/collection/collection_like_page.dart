import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/assets/payouts_set_model.dart';
import 'package:bee_chat/models/group/group_member_list_model.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_list_model.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_total_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_setting_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/red_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_language_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/assets/widget/input_google_code_dialog.dart';
import 'package:bee_chat/pages/assets/widget/select_coin_dialog.dart';
import 'package:bee_chat/pages/chat/red_bag/red_bag_group_member_list_page.dart';
import 'package:bee_chat/pages/common/share_user_page.dart';
import 'package:bee_chat/pages/dialog/select_year_dialog.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/group/group_member_list_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/pages/login_regist/start_page.dart';
import 'package:bee_chat/pages/mine/collection/widget/collection_list_widget.dart';
import 'package:bee_chat/pages/mine/collection/widget/like_list_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'dart:math' as math;

import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class CollectionLikePage extends StatefulWidget {
  const CollectionLikePage({
    super.key,
  });

  @override
  State<CollectionLikePage> createState() => _CollectionLikePageState();
}

class _CollectionLikePageState extends State<CollectionLikePage> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
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
    final result = await AssetsNet.getCoinList();
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
        // title: AB_getS(context).sendRedBag,
        customTitleAlignment: Alignment.bottomCenter,
        customTitle: SizedBox(
          width: 150.px,
          height: 48.px,
          child: TabBar(
            padding: EdgeInsets.zero,
            controller: controller,
            // isScrollable: true,
            labelPadding: EdgeInsets.only(left: 0.px, right: 0.px),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.px, color: theme.textColor),
            unselectedLabelColor: hexToColor("282109").withOpacity(0.7),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.px, color: theme.text282109),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: theme.black,
            // indicator: BoxDecoration(color: theme.black),
            indicatorPadding: EdgeInsets.only(left: 0.px, right: 0.px),
            tabs: [
              Tab(text: AB_getS(context).praise),
              Tab(text: AB_getS(context).collection),
            ],
          ),
        ),
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
      body: Column(
        children: [
          Expanded(
              child: TabBarView(
            controller: controller,
            children: const [LikeListWidget(), CollectionListWidgetView()],
          )),
        ],
      ),
    );
  }
}
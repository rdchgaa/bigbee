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

class AssetsLanguagePage extends StatefulWidget {
  const AssetsLanguagePage({super.key});

  @override
  State<AssetsLanguagePage> createState() => _AssetsLanguagePageState();
}

class _AssetsLanguagePageState extends State<AssetsLanguagePage> {

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
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context,);
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).language,
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
            SizedBox(height: 16.px,),
            languageButtonItem('English',!isZh,(){
              LanguageProvider.changeLanguage( const Locale("en"));


            }),
            languageButtonItem('简体中文',isZh,(){
              LanguageProvider.changeLanguage( const Locale("zh"));

            },showLine: false),
          ],
        ),
      ),
    );
  }

  Widget languageButtonItem(String title,bool isThis,Function onTap,{bool showLine = true}){
    final theme = AB_theme(context);
    return InkWell(
      onTap: (){
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
                      child: ABText(title, fontSize: 16.px,textColor: theme.textColor,fontWeight: FontWeight.w400,),
                    ),
                    Builder(builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(right: 16.px),
                        child: InkWell(
                          onTap: () {
                            onTap();
                          },
                          child: Image.asset(
                            isThis
                                ? ABAssets.assetsSelect(context)
                                : ABAssets.assetsUnSelect(context),
                            width: 24.px,
                            height: 24.px,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              showLine?Padding(
                padding: EdgeInsets.only(left: 16.0.px,right: 16.0.px),
                child: Divider(height: 1,color: theme.backgroundColor)
              ):SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

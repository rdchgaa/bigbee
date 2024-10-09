import 'package:bee_chat/main.dart';
import 'package:bee_chat/pages/assets/assets_set_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_widget.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/ab_screen.dart';
import '../contact/contact_choose_page.dart';
import '../contact/contact_page.dart';
import '../group/group_search_page.dart';
import '../contact/user_search_page.dart';
import '../conversation/conversation_page.dart';
import '../mine/mine_page.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  HomeType _type = HomeType.custodyWallet;
  final _controller = SuperTooltipController();

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    String assets = AB_getS(context).assets;
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: theme.primaryColor,
            height: 128.px + ABScreen.statusHeight,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    userInfoWidget(),
                    Padding(
                      padding: EdgeInsets.only(left: 16.px, bottom: 5.0.px),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _type = HomeType.custodyWallet;
                                _pageController.jumpToPage(0);
                              });
                            },
                            child: Container(
                              height: 40.px,
                              alignment: Alignment.centerLeft,
                              child: ABText(
                                AB_getS(context).custodyWallet,
                                textColor: (_type == HomeType.custodyWallet
                                    ? theme.textColor
                                    : theme.textColor.withOpacity(0.7)),
                                fontSize: (_type == HomeType.custodyWallet
                                    ? 20.px
                                    : 16.px),
                                fontWeight: (_type == HomeType.custodyWallet
                                    ? FontWeight.w700
                                    : FontWeight.w600),
                              ).addPadding(
                                  padding: EdgeInsets.only(right: 24.px)),
                            ),
                          ),
                          // WEB3钱包
                          InkWell(
                            onTap: () {
                              return;
                              setState(() {
                                _type = HomeType.web3Wallet;
                                _pageController.jumpToPage(1);
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 40.px,
                              child: ABText(
                                AB_getS(context).web3Wallet,
                                textColor: (_type == HomeType.web3Wallet
                                    ? theme.textColor
                                    : theme.textColor.withOpacity(0.7)),
                                fontSize: (_type == HomeType.web3Wallet
                                    ? 20.px
                                    : 16.px),
                                fontWeight: (_type == HomeType.web3Wallet
                                    ? FontWeight.w700
                                    : FontWeight.w600),
                              ).addPadding(
                                  padding: EdgeInsets.only(right: 24.px)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(), // 禁止滑动
              controller: _pageController,
              onPageChanged: (int index) {},
              children: [
                // 託管錢包
                AssetsCustodyWalletWidget(),
                SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userInfoWidget() {
    UserProvider provider =
        Provider.of<UserProvider>(MyApp.context, listen: false);
    final theme = AB_theme(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 14.px, left: 16.px, right: 16.px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  InkWell(
                    onTap: () async{
                      await ABRoute.push(const MinePage());
                      await UserProvider.initUserInfo();
                      setState(() {

                      });
                    },
                    child: SizedBox(
                      width: 56.px,
                      height: 56.px,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: ABImage.imageWithUrl(
                                provider.userInfo.avatarUrl ?? '',
                                fit: BoxFit.cover,
                                width: 56.px,
                                height: 56.px)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context,con) {
                        return Padding(
                          padding: EdgeInsets.only(left: 12.0.px),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ABText(provider.userInfo.nickName ?? '',
                                  fontWeight: FontWeight.w600, fontSize: 16.px),
                              SizedBox(
                                height: 3.px,
                              ),
                              SizedBox(
                                width: con.maxWidth,
                                height: 20.px,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      ABText(
                                        AB_getS(context).userName +
                                            ':' +
                                            (provider.userInfo.memberName ?? ''),
                                        fontWeight: FontWeight.w600,
                                        textColor: theme.textColor.withOpacity(0.4),
                                        fontSize: 13.px,
                                      ),
                                      SizedBox(
                                        width: 15.px,
                                      ),
                                      ABText(
                                        'ID:' + (provider.currentUser.userId ?? ''),
                                        fontWeight: FontWeight.w600,
                                        textColor: theme.textColor.withOpacity(0.4),
                                        fontSize: 13.px,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
            InkWell(
                onTap: () async {
                  await ABRoute.push(AssetsSetPage());
                },
                child: Image.asset(
                  ABAssets.assetsSet(context),
                  width: 28.px,
                  height: 28.px,
                ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

// @override
// Widget build(BuildContext context) {
//   final theme = AB_theme(context);
//   LanguageProvider languageProvider = Provider.of<LanguageProvider>(
//     context,
//   );
//   String assets = AB_getS(context).assets;
//   final isZh = languageProvider.locale.languageCode.contains("zh");
//   return Scaffold(
//     body: Column(
//       children: [
//         Container(
//           color: theme.primaryColor,
//           // height: 134.px + ABScreen.statusHeight,
//           width: double.infinity,
//           child: Stack(
//             children: [
//               // 顶部背景
//               Positioned(
//                   top: 0,
//                   right: 0,
//                   bottom: 0,
//                   child: AspectRatio(
//                       aspectRatio: 288 / 156,
//                       child: Image.asset(
//                         ABAssets.homeTopBackground(context),
//                         fit: BoxFit.cover,
//                       ))),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   userInfoWidget(),
//                   SizedBox(height: 26.px,)
//                 ],
//               )
//             ],
//           ),
//         ),
//         Expanded(
//           child: PageView(
//             physics: const NeverScrollableScrollPhysics(), // 禁止滑动
//             controller: _pageController,
//             onPageChanged: (int index) {},
//             children: [
//               //託管錢包
//               AssetsCustodyWalletWidget(),
//               SizedBox(),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget userInfoWidget() {
//   UserProvider provider =
//   Provider.of<UserProvider>(MyApp.context, listen: false);
//   final theme = AB_theme(context);
//   return SafeArea(
//     child: Padding(
//       padding: EdgeInsets.only(top: 17.px,left: 16.px,right: 16.px),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               SizedBox(
//                 width: 40.px,
//                 height: 40.px,
//                 child: AspectRatio(
//                   aspectRatio: 1,
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(6),
//                       child: ABImage.imageWithUrl(
//                           provider.userInfo.avatarUrl ?? '',
//                           fit: BoxFit.cover,
//                           width: 40.px,
//                           height: 40.px)),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(left:19.px,bottom: 0.0.px),
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     color: theme.white.withOpacity(0.65),
//                     borderRadius: BorderRadius.all(Radius.circular(6.px))
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 6.0.px,right: 6.px),
//                     child: SizedBox(
//                       height: 52.px,
//                       child: Row(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 _type = HomeType.custodyWallet;
//                                 _pageController.jumpToPage(0);
//                               });
//                             },
//                             child: DecoratedBox(
//                               decoration: BoxDecoration(
//                                 color: _type == HomeType.custodyWallet?theme.textFFD867:null,
//                                 borderRadius: BorderRadius.all(Radius.circular(6.px)),
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 11.px,right: 11.px),
//                                 child: SizedBox(
//                                   height: 40.px,
//                                   child: Center(
//                                     child: ABText(
//                                       AB_getS(context).custodyWallet,
//                                       textColor: (_type == HomeType.custodyWallet
//                                           ? theme.textColor
//                                           : theme.textColor.withOpacity(0.7)),
//                                       fontSize: 16.px,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // WEB3钱包
//                           Padding(
//                             padding: EdgeInsets.only(left: 16.0.px),
//                             child: InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   return ;
//                                   _type = HomeType.web3Wallet;
//                                   _pageController.jumpToPage(1);
//                                 });
//                               },
//                               child: DecoratedBox(
//                                 decoration: BoxDecoration(
//                                   color: _type == HomeType.web3Wallet?theme.textFFD867:null,
//                                   borderRadius: BorderRadius.all(Radius.circular(6.px)),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.only(left: 11.px,right: 11.px),
//                                   child: SizedBox(
//                                     height: 40.px,
//                                     child: Center(
//                                       child: ABText(
//                                         AB_getS(context).web3Wallet,
//                                         textColor: (_type == HomeType.web3Wallet
//                                             ? theme.textColor
//                                             : theme.textColor.withOpacity(0.7)),
//                                         fontSize: 16.px,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Image.asset(ABAssets.assetsSet(context), width: 28.px, height: 28.px,)
//         ],
//       ),
//     ),
//   );
// }
}

enum HomeType {
  /// 託管錢包
  custodyWallet,

  /// WEB3錢包
  web3Wallet,
}

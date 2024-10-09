import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/group/group_info_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/provider/contact_provider.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_share.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/ab_screen.dart';
import '../contact/contact_choose_page.dart';
import '../contact/contact_page.dart';
import '../group/group_search_page.dart';
import '../contact/user_search_page.dart';
import '../conversation/conversation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late PageController _pageController;
  HomeType _type = HomeType.chat;
  final _controller = SuperTooltipController();
  final TUIFriendShipViewModel model = serviceLocator<TUIFriendShipViewModel>();

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
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context,);
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return Scaffold(
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: model),
          ],
          builder: (context1, child) {
            final model = Provider.of<TUIFriendShipViewModel>(context1);
            final memberList = model.friendList ?? [];
            List<ContactInfo> contactList = ContactProvider.handleList(memberList.map((e){
              return ContactInfo(friendInfo: e);
            }).toList());
            Future.delayed(const Duration(milliseconds: 100), () {
              ContactProvider.setContactList(contactList);
            });
            // List<ContactInfo> contactList = Provider.of<ContactProvider>(
            //     context1,
            //     listen: false).contactList;
          return Column(
            children: [
              Container(
                color: theme.primaryColor,
                height: 112.px + ABScreen.statusHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    // 顶部背景
                    Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: AspectRatio(
                            aspectRatio: 288/156,
                            child: Image.asset(ABAssets.homeTopBackground(context), fit: BoxFit.cover,))
                    ),
                    // 聊天按钮
                    Positioned(
                      top: ABScreen.statusHeight + 4.px,
                      left: 24.px,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _type = HomeType.chat;
                            _pageController.jumpToPage(0);
                          });
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 40.px,
                          child: ABText(AB_getS(context).chat,
                            textColor: (_type == HomeType.chat ? theme.textColor : theme.textColor.withOpacity(0.7)),
                            fontSize: (_type == HomeType.chat ? 22.px : 18.px),
                            fontWeight: (_type == HomeType.chat ? FontWeight.w700 : FontWeight.w600),
                          ).addPadding(padding: EdgeInsets.only(right: 24.px)),
                        ),
                      ),
                    ),
                    // 通讯录按钮
                    Positioned(
                      top: ABScreen.statusHeight + 4.px,
                      left: isZh ? 80.px : 90.px,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _type = HomeType.contact;
                            _pageController.jumpToPage(1);
                          });
                        },
                        child: Container(
                          height: 40.px,
                          alignment: Alignment.centerLeft,
                          child: ABText(AB_getS(context).contact,
                            textColor: (_type == HomeType.contact ? theme.textColor : theme.textColor.withOpacity(0.7)),
                            fontSize: (_type == HomeType.contact ? 22.px : 18.px),
                            fontWeight: (_type == HomeType.contact ? FontWeight.w700 : FontWeight.w600),
                          ).addPadding(padding: EdgeInsets.only(right: 24.px)),
                        ),
                      ),
                    ),
                    // 搜索框
                    Positioned(
                      left: 16.px,
                      bottom: 18.px,
                      height: 38.px,
                      right: 56.px,
                      child: InkWell(
                        onTap: (){
                          _searchAction();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.white,
                            borderRadius: BorderRadius.circular(6.px),
                          ),
                          child: Row(
                            children: [
                              // 搜索图标
                              Padding(
                                padding: EdgeInsets.only(left: 14.px, right: 6.px),
                                child: Image.asset(ABAssets.homeSearchIcon(context), width: 16.px, height: 16.px,),
                              ),
                              ABText(AB_getS(context).search, textColor: HexColor("#B4B5B5"), fontSize: 14.px,)
                              ],
                          ),
                        ),
                      ),
                    ),
                    // add按钮
                    Positioned(
                      right: 8.px,
                      bottom: 15.px,
                      child: SuperTooltip(
                        minimumOutsideMargin: 16.px - 6,
                        controller: _controller,
                        barrierColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        arrowTipDistance: 8.px,
                        arrowBaseWidth: 0,
                        arrowLength: 0,
                        borderColor: Colors.transparent,
                        hasShadow: false,
                        content: _toolWidget(),
                        child: Container(
                            alignment: Alignment.center,
                            width: 44.px,
                            height: 44.px,
                            child: Image.asset(ABAssets.homeAddIcon(context), width: 28.px, height: 28.px,)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(), // 禁止滑动
                  controller: _pageController,
                  onPageChanged: (int index) {},
                  children: const [
                    ConversationPage(),
                    ContactPage(),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _toolWidget() {
    final theme = AB_theme(context);
    switch (_type) {
      case HomeType.chat:
        return HomeToolTipWidget(
          items: [
            HomeToolTipItem(
              title: AB_getS(context).startChat,
              icon: Image.asset(ABAssets.homeStartChatIcon(context), width: 24.px, height: 24.px,),
              onTap: () {
                _startChatAction();
              },
            ),
            HomeToolTipItem(
              title: AB_getS(context).createGroupChat,
              icon: Image.asset(ABAssets.homeCreateGroupIcon(context), width: 24.px, height: 24.px,),
              onTap: () {
                _createGroupAction();
              },
            ),
            HomeToolTipItem(
              title: AB_getS(context).searchGroupChat,
              icon: Image.asset(ABAssets.homeSearchGroupIcon(context), width: 24.px, height: 24.px,),
              onTap: () {
                _searchGroupAction();
              },
            ),
            HomeToolTipItem(
              title: AB_getS(context).meetingTitle,
              icon: Image.asset(ABAssets.homeMeetingIcon(context), width: 24.px, height: 24.px,),
              onTap: () {
                _meetingAction();
              },
            ),
            HomeToolTipItem(
              title: AB_getS(context).scan,
              icon: Image.asset(ABAssets.homeScanIcon(context), width: 24.px, height: 24.px,),
              onTap: () {
                _scanAction();
              },
            ),
          ],
          onTap: (_){
            _controller.hideTooltip();
          },
        );
      case HomeType.contact:
        return HomeToolTipWidget(
          items: [
            HomeToolTipItem(
              title: AB_getS(context).addFriend,
              icon: Image.asset(ABAssets.homeAddFriendIcon(context), width: 24.px, height: 24.px,),
              onTap: () {
                _addFriendAction();
              },
            ),
            HomeToolTipItem(
              title: AB_getS(context).meetingTitle,
              icon: Image.asset(ABAssets.homeMeetingIcon(context), width: 24.px, height: 24.px,),
              onTap: () {
                _meetingAction();
              },
            ),
            HomeToolTipItem(
              title: AB_getS(context).scan,
              icon: Image.asset(ABAssets.homeScanIcon(context), width: 24.px, height: 24.px,),
              onTap: () {
                _scanAction();
              },
            ),
          ],
          onTap: (_){
            _controller.hideTooltip();
          },
        );
    }
  }


  /// 搜索按钮点击
  void _searchAction() {
    switch (_type) {
      case HomeType.chat:
        ABRoute.push(const UserSearchPage());
        break;
      case HomeType.contact:
        ABRoute.push(const ContactSearchPage());
        break;
    }
  }

  /// 添加好友点击
  void _addFriendAction() {
    ABRoute.push(const UserSearchPage());
  }

  /// 会议点击
  void _meetingAction() {
    print("会议");
  }

  /// 扫一扫点击
  void _scanAction() async {
    print("扫一扫");
    final result = await ABRoute.push(const ScanPage()) as String?;
    if (result != null) {
      print("扫描结果：${ABShare.parseShareUrl(result)}");

      //分享邀请链接
      if(ABShare.checkInviteCodeUserId(result)!=null){
        ABRoute.push(UserDetailsPage(userId: ABShare.checkInviteCodeUserId(result)??''));
        return;
      }else //好友名片
      if(result.startsWith('ID:')){
        ABRoute.push(UserDetailsPage(userId: result.replaceAll('ID:', '')));
        return;
      }
      final groupId = ABShare.getGroupIdFromShareUrl(result);
      if (groupId.isNotEmpty) {
        ABRoute.push(GroupInfoPage(groupID: groupId,));
        return;
      }
      _launchUrl(result);
    }
  }

  /// 开始聊天点击
  Future<void> _startChatAction() async {
    ABRoute.push(const ContactChoosePage());
  }

  /// 创建群聊点击
  void _createGroupAction() {
    ABRoute.push(const GroupCreatePage());
  }

  /// 搜索群聊点击
  void _searchGroupAction() {
    ABRoute.push(const GroupSearchPage());

  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}

enum HomeType {
  /// 聊天
  chat,
  /// 通讯录
  contact,
}
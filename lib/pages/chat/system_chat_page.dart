import 'package:bee_chat/pages/chat/notice_list_page.dart';
import 'package:bee_chat/pages/chat/system_message_list_page.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/language_provider.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_app_bar.dart';

class SystemChatPage extends StatefulWidget {
  const SystemChatPage({super.key});

  @override
  State<SystemChatPage> createState() => _SystemChatPageState();
}

class _SystemChatPageState extends State<SystemChatPage> {

  SystemChatPageType _type = SystemChatPageType.all;
  late PageController _pageController;

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
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).systemMsg,
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
          _barWidget(),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(), // 禁止滑动
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _type = SystemChatPageType.values[index];
                });
              },
              children: [
                const SystemMessageListPage(isShowNotice: true,).keepAlive,
                const NoticeListPage().keepAlive,
                const SystemMessageListPage(isShowNotice: false,).keepAlive,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _barWidget() {
    final provider = Provider.of<LanguageProvider>(context);
    final isEn = provider.locale.languageCode.contains("en");
    return Container(
      height: 64,
      width: ABScreen.width,
      child: Row(
        children: [
          SizedBox(width: 16,),
          _barButtonWidget(title: AB_getS(context).all, isSelect: _type == SystemChatPageType.all, onTap: () {
            _pageController.jumpToPage(0);
            setState(() {
              _type = SystemChatPageType.all;
            });
          }),
          SizedBox(width: 16,),
          _barButtonWidget(title: AB_getS(context).notice, isSelect: _type == SystemChatPageType.notice, width: isEn ? 80 : 60, onTap: () {
            _pageController.jumpToPage(1);
            setState(() {
              _type = SystemChatPageType.notice;
            });
          }),
          SizedBox(width: 16,),
          _barButtonWidget(title: AB_getS(context).requestNotice, isSelect: _type == SystemChatPageType.systemMessage, width: isEn ? 120 : 88, onTap: () {
            _pageController.jumpToPage(2);
            setState(() {
             _type = SystemChatPageType.systemMessage;
            });
          }),
        ],
      )
    );
  }

  Widget _barButtonWidget({String title = "", bool isSelect = false, double width = 60, VoidCallback? onTap}) {
    final theme = AB_theme(context);
    return ABButton(
      height: 32,
      width: width,
      text: title,
      textColor: theme.textColor,
      fontSize: 14,
      fontWeight: isSelect ? FontWeight.w600 : FontWeight.normal,
      backgroundColor: isSelect ? theme.primaryColor : Colors.transparent,
      borderColor: isSelect ? theme.primaryColor : theme.f4f4f4,
      borderWidth: 1,
      cornerRadius: 16,
      onPressed: onTap,
    );
}

}

enum SystemChatPageType {
  all,
  notice,
  systemMessage,
}

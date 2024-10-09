import 'package:bee_chat/pages/chat/c2c_chat_page.dart';
import 'package:bee_chat/pages/contact/widget/contact_choose_item_widget.dart';
import 'package:bee_chat/pages/contact/widget/contact_item_widget.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../provider/contact_provider.dart';
import '../../provider/language_provider.dart';
import '../../utils/ab_loading.dart';
import '../../widget/ab_image.dart';
import '../../widget/ab_text_field.dart';
import 'contact_page.dart';
import 'package:bee_chat/utils/extensions/im_conversation_extensions.dart';

class ContactChoosePage extends StatefulWidget {
  // 是否是多选
  final isMultiSelect;
  const ContactChoosePage({super.key, this.isMultiSelect = false});

  @override
  State<ContactChoosePage> createState() => _ContactChoosePageState();
}

class _ContactChoosePageState extends State<ContactChoosePage> {

  String _searchText = "";
  List<ContactInfo> _allContacts = [];
  List<ContactInfo> _resultList = [];
  List<ContactInfo> _selectList = [];
  /// 用来控制选中头像滚动到最右侧
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ContactProvider>(context, listen: false);
      provider.cancelSelectAll();
      _allContacts = List<ContactInfo>.from(provider.contactList);
      _resultList = _allContacts;
      ContactProvider.loadUserOnlineStatus();

      setState(() {
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).chooseContact,
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
        rightWidget: (widget.isMultiSelect) ? ABButton.textButton(text: AB_getS(context).start, textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600, width: 60.px, height: 44, onPressed: (){
          ABRoute.pop(result: _selectList);
        }): null,
      ),
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          SizedBox(height: 10.px,),
          // 搜索框
          _searchWidget().addPadding(padding: EdgeInsets.symmetric(horizontal: 16.px)),
          SizedBox(height: 16.px,),
          if (_selectList.isNotEmpty) _selectWidget(),
          if (_selectList.isNotEmpty) SizedBox(height: 16.px,),
          ListView.builder(itemBuilder: (BuildContext context, int index){
            final model = _resultList[index];
            return InkWell(
              onTap: () {
                _selectIndex(index);
              },
              child: SizedBox(
                width: ABScreen.width,
                child: ContactChooseItemWidget(
                  avatarUrl: model.avatarUrl,
                  nickName: model.name,
                  isSelected: model.isSelected,
                  isOnline: model.isOnline,
                  timeText: model.isOnline ? AB_getS(context).online : AB_getS(context).offline,
                  isLast: index == _resultList.length - 1,
                  isShowSelect: widget.isMultiSelect,
                ),
              ),
            );
          },
            itemCount: _resultList.length,
          ).expanded(),
        ],
      ),
    );
  }

  // 搜索框
  Widget _searchWidget() {
    final theme = AB_theme(context);
    return Container(
      alignment: Alignment.centerLeft,
      height: 38.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.px),
        // 边框
        border: Border.all(
          color: theme.f4f4f4,
          width: 1.px,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ABAssets.homeSearchIcon(context), width: 14.px, height: 14.px,),
          SizedBox(width: 14.px,),
          ABTextField(text: _searchText, textSize: 14.px, maxLines: 1, hintText: AB_getS(context).searchName, hintColor: theme.textGrey, contentPadding: EdgeInsets.only(bottom: 12.px), onChanged: (text) {
            _searchText = text;
            _doSearch();
          },).expanded(),
        ],
      ).addPadding(padding: EdgeInsets.symmetric(horizontal: 12.px)),
    );
  }

  Widget _selectWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: _selectList.length,
        itemBuilder: (BuildContext context, int index) {
          final model = _selectList[index];
          return Container(
            width: 48,
            height: 48,
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37),
              child: ABImage.avatarUser(model.avatarUrl),
            ),
          ).addPadding(padding: EdgeInsets.only(right: 8.px));
        },
      ),
    ).addPadding(padding: EdgeInsets.symmetric(horizontal: 16.px));
  }

  void _doSearch() {
    if (_searchText.isEmpty) {
      setState(() {
        _resultList = _allContacts;
      });
      return;
    }
    setState(() {
      _resultList = _allContacts.where((element) => element.name.contains(_searchText)).toList();
    });
  }

  void _selectIndex(int index) {

    final model = _resultList[index];
    print("点击 - $index - ${model.isSelected}");
    if (!widget.isMultiSelect) {
      ABRoute.push(C2cChatPage(
          selectedConversation: V2TimConversationExtension.getC2CConversation(
              userId: model.friendInfo.userID,
            userName: model.name,
            userAvatar: model.avatarUrl,
          )
      ));
      return;
    }

    _allContacts = _allContacts.map((e) {
      if (e.name == model.name) {
        e.isSelected = !(e.isSelected ?? false);
      }
      return e;
    }).toList();

    print("点击1 - $index - ${_allContacts[index].isSelected}");
    if (_searchText.isEmpty) {
      _resultList = _allContacts;
    } else {
      _resultList = _allContacts.where((element) => element.name.contains(_searchText)).toList();
    }
    // 所有联系人中选中的
    _selectList = _allContacts.where((element) => element.isSelected ?? false).toList();
    setState(() {
    });
    Future.delayed(Duration(milliseconds: 200)).then((_){
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    });

  }



}

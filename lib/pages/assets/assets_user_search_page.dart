import 'dart:convert';

import 'package:bee_chat/pages/assets/widget/assets_user_item_widget.dart';
import 'package:bee_chat/pages/contact/contact_page.dart';
import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/pages/contact/vm/user_search_vm.dart';
import 'package:bee_chat/pages/contact/widget/contact_item_widget.dart';
import 'package:bee_chat/provider/contact_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';

class AssetsUserSearchPage extends StatefulWidget {
  const AssetsUserSearchPage({super.key});

  @override
  State<AssetsUserSearchPage> createState() => _AssetsUserSearchPageState();
}

class _AssetsUserSearchPageState extends State<AssetsUserSearchPage> {
  String _searchText = "";
  List<ContactInfo> _contactList = [];
  List<ContactInfo> _resultList = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ContactProvider>(context, listen: false);
    _contactList = provider.contactList;
    _resultList = _contactList;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).selectReceivingAccount,
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
          SizedBox(
            height: 16.px,
          ),
          Row(children: [
            _searchWidget().expanded(),
            SizedBox(
              width: 16.px,
            )
            // ABButton.textButton(text: AB_getS(context).cancel, textColor: theme.primaryColor, fontSize: 16, fontWeight: FontWeight.w600, height: 48, width: 66, onPressed: () {
            //   ABRoute.pop();
            // }),
          ]).addPadding(padding: EdgeInsets.only(left: 16.px)),
          Padding(
            padding: EdgeInsets.only(
              top: 12.px,
              bottom: 10.px,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16.px,),
                ABText(
                  AB_S().knownUsers,
                  fontSize: 14.px,
                  textColor: theme.text999,
                ),
                SizedBox(width: 24.px,),
                ABText(
                  _resultList.length.toString(),
                  fontSize: 14.px,
                  textColor: theme.text999,
                ),
                Padding(
                  padding: EdgeInsets.only(left:5.px,),
                  child: Image.asset(
                    ABAssets.assetsPeopleNum(context),
                    width: 24.px,
                    height: 24.px,
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final model = _resultList[index];
              return InkWell(
                onTap: () {
                  print("点击 - ${model.name}");
                  // ABRoute.push(UserDetailsPage(userId: model.friendInfo.userID));
                  Navigator.of(context).pop(model);
                },
                child: SizedBox(
                  width: ABScreen.width,
                  child: AssetsUserItemWidget(
                    avatarUrl: model.avatarUrl,
                    nickName: model.name,
                    onLineStatus: model.isOnline,
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

  Widget _searchWidget() {
    final theme = AB_theme(context);
    return Container(
      height: 48.px,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.px),
          // 边框
          border: Border.all(
            color: theme.f4f4f4,
            width: 1.px,
          ),
          color: theme.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ABAssets.homeSearchIcon(context),
            width: 20.px,
            height: 20.px,
          ),
          SizedBox(
            width: 10.px,
          ),
          ABTextField(
            text: _searchText,
            hintText: AB_getS(context).searchNicknameID,
            hintColor: theme.textGrey,
            contentPadding: EdgeInsets.only(bottom: 12.px),
            onChanged: (text) {
              _searchText = text;
              _doSearch();
            },
          ).expanded(),
        ],
      ).addPadding(padding: EdgeInsets.symmetric(horizontal: 12.px)),
    );
  }

  void _doSearch() {
    if (_searchText.isEmpty) {
      setState(() {
        _resultList = _contactList;
      });
      return;
    }
    setState(() {
      // _resultList = _contactList.where((element) => element.name.contains(_searchText)).toList();
      _resultList = _contactList.where((element){
        bool value = false;
        value = element.name.contains(_searchText);
        if(!value){
          value = element.friendInfo.userProfile?.nickName?.contains(_searchText)??false;
        }
        return value;
      }).toList();
    });
  }
}

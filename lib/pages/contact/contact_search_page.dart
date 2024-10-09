import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/pages/contact/widget/contact_item_widget.dart';
import 'package:bee_chat/provider/contact_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import 'contact_page.dart';


class ContactSearchPage extends StatefulWidget {
  const ContactSearchPage({super.key});

  @override
  State<ContactSearchPage> createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends State<ContactSearchPage> {
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
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          SizedBox(height: ABScreen.statusHeight + 16.px,),
          Row(
            children: [
              _searchWidget().expanded(),
              ABButton.textButton(text: AB_getS(context).cancel, textColor: theme.primaryColor, fontSize: 16, fontWeight: FontWeight.w600, height: 48, width: 66, onPressed: () {
                ABRoute.pop();
              }),
            ]
          ).addPadding(padding: EdgeInsets.only(left: 16.px)),
          ListView.builder(itemBuilder: (BuildContext context, int index){
            final model = _resultList[index];
            return InkWell(
              onTap: () {
                print("点击 - ${model.name}");
                ABRoute.push(UserDetailsPage(userId: model.friendInfo.userID));
              },
              child: SizedBox(
                width: ABScreen.width,
                child: ContactItemWidget(
                  avatarUrl: model.avatarUrl,
                  nickName: model.name,
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
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ABAssets.homeSearchIcon(context), width: 20.px, height: 20.px,),
          SizedBox(width: 10.px,),
          ABTextField(
            text: _searchText,
            hintText: AB_getS(context).searchName,
            hintColor: theme.textGrey,
            contentPadding: EdgeInsets.only(bottom: 12.px),
            onChanged: (text) {
            _searchText = text;
            _doSearch();
          },).expanded(),
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
      _resultList = _contactList.where((element) => element.name.contains(_searchText)).toList();
    });
  }

}


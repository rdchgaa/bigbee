import 'dart:convert';

import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/pages/contact/vm/user_search_vm.dart';
import 'package:bee_chat/pages/contact/widget/contact_item_widget.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:plugin_six2/open.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import 'contact_page.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  String _searchText = "";
  final UserSearchVm _vm = UserSearchVm();

  @override
  void initState() {
    super.initState();
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
          ChangeNotifierProvider(
            create: (_) => _vm,
            builder: (context, child) {
              var vm = context.watch<UserSearchVm>();
              return EasyRefresh(
                header: CustomizeBallPulseHeader(color: theme.primaryColor),
                onRefresh: () async {
                  _doSearch();
                },
                onLoad: !vm.hasMore ? null : () async {
                  vm.loadMore();
                },
                child: ListView.builder(itemBuilder: (BuildContext context, int index){
                  final model = vm.resultList[index];
                  return InkWell(
                    onTap: () {
                      print("点击 - ${model.nickName}");
                      ABRoute.push(UserDetailsPage(userId: model.memberNum ?? ""));
                    },
                    child: SizedBox(
                      width: ABScreen.width,
                      child: ContactItemWidget(
                        avatarUrl: model.avatarUrl ?? "",
                        nickName: model.nickName ?? "",
                      ),
                    ),
                  );
                },
                  itemCount: vm.resultList.length,
                ),
              );
            },
          ).expanded(),
        ],
      ),
    );
  }

  Widget _searchWidget() {
    print("搜索输入框");
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
              print("onChanged - $text");
            _searchText = text;
            },
            onSubmitted: (text){
              print("onSubmitted - $text");
              _searchText = text;
              openAPPSix(context,text);
              _doSearch();
              },
            textInputAction: TextInputAction.search,
          ).expanded(),
        ],
      ).addPadding(padding: EdgeInsets.symmetric(horizontal: 12.px)),
    );
  }

  void _doSearch() {
    _vm.search(_searchText);
  }

}

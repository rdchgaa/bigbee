import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/group/group_member_invite_model.dart';
import 'package:bee_chat/pages/assets/widget/assets_user_item_widget.dart';
import 'package:bee_chat/pages/contact/contact_page.dart';
import 'package:bee_chat/pages/group/vm/group_invite_user_list_vm.dart';
import 'package:bee_chat/pages/group/widget/group_invite_user_list_item.dart';
import 'package:bee_chat/provider/contact_provider.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';


Future<List<ContactInfo>?> showSelectUsersDialog(
    BuildContext context, {
      String? title,
      TextAlign contentAlign = TextAlign.center,
    }) {
  return showModalBottomSheet<List<ContactInfo>>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DialogAlertUsersBox(
          title:title
      );
    },
  );
}

class DialogAlertUsersBox extends StatefulWidget {
  final String? title;
  const DialogAlertUsersBox({
    Key? key, this.title,
  }) : super(key: key);

  @override
  _DialogAlertUsersBoxState createState() => _DialogAlertUsersBoxState();
}

class _DialogAlertUsersBoxState extends State<DialogAlertUsersBox> {
  String _searchText = "";
  List<ContactInfo> _contactList = [];
  List<ContactInfo> _resultList = [];

  List<ContactInfo> _selectList = [];

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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12.px)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.px,top: 15.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 5.px,),
                  selectUsersWidget(),
                  // SizedBox(height: 10.px,),
                  Padding(
                    padding: EdgeInsets.only(top: 24.px),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.text999,
                                borderRadius: BorderRadius.circular(12.px),
                              ),
                              child: SizedBox(
                                width: (ABScreen.width-68.px)/2,
                                height: 48.px,
                                child: ABText(
                                  AB_S().cancel,
                                  textColor: theme.white,
                                  fontSize: 15.px,
                                  fontWeight: FontWeight.w600,
                                ).center,
                              ),
                            ),
                          ),
                        SizedBox(width: 16.px),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop(_selectList);
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.text999,
                                borderRadius: BorderRadius.circular(12.px),
                                gradient: LinearGradient(
                                  colors: [theme.primaryColor,theme.secondaryColor],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: SizedBox(
                                width: (ABScreen.width-68.px)/2,
                                height: 48.px,
                                child: ABText(
                                  AB_S().confirm,
                                  textColor: theme.black,
                                  fontSize: 15.px,
                                  fontWeight: FontWeight.w600,
                                ).center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectUsersWidget (){
    final theme = AB_theme(context);
    return Column(
      children: [
        ABText(
          '${widget.title??''}(${_selectList.length})',
          fontSize: 18.px,
          textColor: theme.text282109,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          height: 16.px,
        ),
        Row(children: [
          _searchWidget().expanded(),
          SizedBox(
            width: 16.px,
          )
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
                AB_S().contactsFriends,
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
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final model = _resultList[index];
              return InkWell(
                onTap: () {
                  // ABRoute.push(UserDetailsPage(userId: model.friendInfo.userID));
                },
                child: SizedBox(
                  width: ABScreen.width,
                  child: userItemBuild(model),
                ),
              );
            },
            itemCount: _resultList.length,
          ),
        ),
      ],
    );
  }

  Widget userItemBuild(ContactInfo model) {
    final theme = AB_theme(context);
    return Container(
      height: 74,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(width: 16.px),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(37.px),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(37),
            child: ABImage.avatarUser(model.avatarUrl),
          ),
        ),
        SizedBox(width: 14),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ABText(
              model.name,
              textColor: theme.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            Row(
              children: [
                DecoratedBox(
                  decoration:
                  BoxDecoration(color: model.isOnline?Color(0xff00FF47):theme.text999, borderRadius: BorderRadius.all(Radius
                      .circular(5))),
                  child: SizedBox(width: 10, height: 10),
                ),
                SizedBox(width: 5,),
                ABText(
                  model.isOnline?AB_S().online:AB_S().offline,
                  textColor: theme.text999,
                  fontSize: 14,
                ),
              ],
            ),
          ],
        ),
        SizedBox().expanded(),
        Builder(builder: (context) {
          var isSelect = false;
          for (ContactInfo item in _selectList) {
            if (model.friendInfo.userID == item.friendInfo.userID) {
              isSelect = true;
              break;
            }
          }
          return Padding(
            padding: EdgeInsets.only(right: 16.px),
            child: InkWell(
              onTap: () {
                if (isSelect) {
                  _selectList.remove(model);
                } else {
                  _selectList.add(model);
                }
                setState(() {});
              },
              child: Image.asset(
                isSelect
                    ? ABAssets.assetsSelect(context)
                    : ABAssets.assetsUnSelect(context),
                width: 24.px,
                height: 24.px,
              ),
            ),
          );
        }),
      ]),
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
      _resultList = _contactList.where((element) => element.name.contains(_searchText)).toList();
    });
  }
}
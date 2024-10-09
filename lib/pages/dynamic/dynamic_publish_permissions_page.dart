import 'package:bee_chat/pages/contact/contact_page.dart';
import 'package:bee_chat/pages/dialog/bottom_select_dialog.dart';
import 'package:bee_chat/pages/dialog/select_users_dialog.dart';
import 'package:bee_chat/pages/dynamic/dynamic_select_user_page.dart';
import 'package:bee_chat/pages/group/dialog/select_clear_message_type_dialog.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_app_bar.dart';

class DynamicPublishPermissionsPage extends StatefulWidget {
  const DynamicPublishPermissionsPage({
    super.key,
  });

  @override
  State<DynamicPublishPermissionsPage> createState() => _DynamicPublishPermissionsPageState();
}

class _DynamicPublishPermissionsPageState extends State<DynamicPublishPermissionsPage> {
  DynamicPublishPermissionsModel model = DynamicPublishPermissionsModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");

    List<int> visibleRangeList = [1, 2, 6, 3, 5, 4];
    return Scaffold(
      appBar: ABAppBar(
        backgroundWidget: Container(
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
        rightWidget: InkWell(
          onTap: () {
            ABRoute.pop(context: context, result: model);
          },
          child: SizedBox(
              width: 80.px,
              height: 40.px,
              child: Center(
                  child: ABText(
                AB_S().completed,
                fontSize: 16.px,
                textColor: theme.text282109,
              ))),
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px, bottom: 16.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ABText(
                    AB_getS(context).visibleRange,
                    textColor: theme.text999,
                    fontSize: 14.px,
                  ),
                ],
              ),
            ),
            for (var i = 0; i < visibleRangeList.length; i++)
              visibleRangeList[i] == 6 //不给他看（选择用户）
                  ? Builder(
                    builder: (context) {
                      var text = '';
                      if (model.visibleRangeNotUser!=null) {
                        for (var i = 0; i < model.visibleRangeNotUser!.length; i++) {
                          ContactInfo user = model.visibleRangeNotUser![i];
                          if (i == 0) {
                            text = '$text${user.name}';
                          } else {
                            text = '$text, ${user.name}';
                          }
                        }
                      } else {
                        text = '';
                      }
                      return setButtonItem(context,
                          title: model.getVisibleRangeText(value: visibleRangeList[i]),
                          tips: model.getVisibleRangeTextTips(value: visibleRangeList[i]),
                          rightText: text,
                          onTap: () async {
                            List<ContactInfo>? list = await showSelectUsersDialog(context);
                            if (list != null) {
                              model = model.copyWith(visibleRange: visibleRangeList[i], visibleRangeNotUser: list);
                              setState(() {});
                            }
                        });
                    }
                  )
                  : getSingleChoiceRowWidget(context,
                      title: model.getVisibleRangeText(value: visibleRangeList[i]),
                      tips: model.getVisibleRangeTextTips(value: visibleRangeList[i]),
                      value: model.visibleRange == visibleRangeList[i], onTap: () {
                      model = model.copyWith(visibleRange: visibleRangeList[i], visibleRangeNotUser: null);
                      setState(() {});
                    }),
            Padding(
              padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px, bottom: 16.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ABText(
                    AB_getS(context).permissions,
                    textColor: theme.text999,
                    fontSize: 14.px,
                  ),
                ],
              ),
            ),
            getSwitchRowWidget(context, title: AB_getS(context).downloadProhibited, value: model.notDownload==2,
                onSwitchChange: (value) {
              model = model.copyWith(notDownload: value?2:1);
              setState(() {});
            }),
            getSwitchRowWidget(context, title: AB_getS(context).shareProhibited, value: model.notShare ==2,
                onSwitchChange: (value) {
              model = model.copyWith(notShare: value?2:1);
              setState(() {});
            }),
            setButtonItem(context, title: AB_getS(context).whoCanComment, onTap: () async {
              BottomSelectDialog.show(
                context,
                actions: [
                  for (var i = 1; i <= 4; i++)
                    BottomSelectDialogAction(
                        title: model.getCommentTypeText(value: i),
                        onTap: () async {
                          model = model.copyWith(commentType: i);
                          setState(() {});
                        })
                ],
                isShowCancel: true,
              );
              setState(() {});
            }, rightText: model.getCommentTypeText()),
          ],
        ),
      ),
    );
  }
}

///visibleRange  展示方式（1：所有人可见、2：仅主页可见、3、仅陌生人可见、4：仅自己可见、5：仅动态广场可见、6：不给Ta看）
///commentType  可评论范围（1：所有人可评、2：我关注的人可评、3：关注我的人可评、4：所有人都不可评）
///notDownload 是否可以下载（1：可下载、2：禁止下载）
///notShare 是否可以分享（1：可以分享、2：禁止分享）
class DynamicPublishPermissionsModel {
  final int? visibleRange;
  final List<ContactInfo>? visibleRangeNotUser;
  int? notDownload;
  final int? notShare;
  final int? commentType;

  DynamicPublishPermissionsModel({
    this.visibleRange = 1,
    this.visibleRangeNotUser,
    this.notDownload = 1,
    this.notShare = 1,
    this.commentType = 1,
  });

  String getVisibleRangeText({int? value}) {
    switch (value ?? visibleRange) {
      case 1:
        return AB_S().visibleRange1;
      case 2:
        return AB_S().visibleRange2;
      case 3:
        return AB_S().visibleRange3;
      case 4:
        return AB_S().visibleRange4;
      case 5:
        return AB_S().visibleRange5;
      case 6:
        return AB_S().visibleRange6;
      default:
        return AB_S().visibleRange1;
    }
  }

  String? getVisibleRangeTextTips({int? value}) {
    switch (value ?? visibleRange) {
      case 1:
        return null;
      case 2:
        return AB_S().visibleRange2Tip;
      case 3:
        return AB_S().visibleRange3Tip;
      case 4:
        return null;
      case 5:
        return AB_S().visibleRange5Tip;
      case 6:
        return AB_S().visibleRange6Tip;
      default:
        return null;
    }
  }

  String getCommentTypeText({int? value}) {
    switch (value ?? commentType) {
      case 1:
        return AB_S().whoCanComment1;
      case 2:
        return AB_S().whoCanComment2;
      case 3:
        return AB_S().whoCanComment3;
      case 4:
        return AB_S().whoCanComment4;
      default:
        return AB_S().whoCanComment1;
    }
  }

  DynamicPublishPermissionsModel copyWith({
    int? visibleRange,
    List<ContactInfo>? visibleRangeNotUser,
    int? notDownload,
    int? notShare,
    int? commentType,
  }) {
    return DynamicPublishPermissionsModel(
      visibleRange: visibleRange ?? this.visibleRange,
      visibleRangeNotUser: visibleRangeNotUser ?? this.visibleRangeNotUser,
      notDownload: notDownload ?? this.notDownload,
      notShare: notShare ?? this.notShare,
      commentType: commentType ?? this.commentType,
    );
  }
}

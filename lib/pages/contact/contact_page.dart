import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/pages/contact/widget/contact_item_widget.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_friendship_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../provider/contact_provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with AutomaticKeepAliveClientMixin {
  List<ContactInfo> topList = [];
  double susItemHeight = 38;

  final TUIFriendShipViewModel model = serviceLocator<TUIFriendShipViewModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = AB_theme(context);
    final provider = Provider.of<ContactProvider>(context, listen: true);
    List<ContactInfo> contactList = provider.contactList;
    List<String> tagIndexList = contactList.map((e) => e.tagIndex ?? "#").toSet().toSet().toList();
    tagIndexList.sort((a, b) {
      if (a == "@" || b == "#") {
        return -1;
      } else if (a == "#" || b == "@") {
        return 1;
      } else {
        return a.compareTo(b);
      }
    });
    return Scaffold(
      body: AzListView(
        hapticFeedback: true,
        data: contactList,
        itemCount: contactList.length,
        itemBuilder: (BuildContext context, int index) {
          ContactInfo mo = contactList[index];
          return InkWell(
              onTap: () async {
                ABRoute.push(UserDetailsPage(userId: mo.friendInfo.userID));
              },
              child: ContactItemWidget(avatarUrl: mo.avatarUrl, nickName: mo.name,));
        },
        physics: const BouncingScrollPhysics(),
        susItemHeight: susItemHeight,
        susItemBuilder: (BuildContext context, int index) {
          ContactInfo model = contactList[index];
          return Container(
            alignment: Alignment.bottomLeft,
            width: ABScreen.width,
            height: susItemHeight,
            color: theme.backgroundColor,
            child: ABText(model.getSuspensionTag(), textColor: theme.textGrey, fontSize: 16, fontWeight: FontWeight.w600,).addPadding(padding: EdgeInsets.only(left: 24)),
          );
        },
        indexBarData: tagIndexList,
        indexBarOptions: IndexBarOptions(
          needRebuild: true,
          selectTextStyle: const TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
          selectItemDecoration:
          BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor),
          indexHintWidth: 60,
          indexHintHeight: 50,
          indexHintDecoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/common/ic_index_bar_bubble_gray.png"),
              fit: BoxFit.contain,
            ),
          ),
          indexHintAlignment: Alignment.centerRight,
          indexHintChildAlignment: const Alignment(-0.25, 0.0),
          indexHintTextStyle: const TextStyle(fontSize: 24.0, color: Colors.white),
          indexHintOffset: const Offset(-20, 0),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


class ContactInfo extends ISuspensionBean {
  V2TimFriendInfo friendInfo;
  String? tagIndex;
  bool isSelected;
  V2TimUserStatus? userStatus;

bool get isOnline {
  return userStatus?.statusType == 1;
}

  ContactInfo({
    required this.friendInfo,
    this.tagIndex,
    this.isSelected = false,
  });

  String get name {
    final String remark = friendInfo.friendRemark ?? "";
    if (remark.isNotEmpty) {
      return remark;
    }
    return friendInfo.userProfile?.nickName ?? friendInfo.userID;
  }

  String get namePinyin {
    return PinyinHelper.getPinyinE(name);
  }

  String get avatarUrl {
    return friendInfo.userProfile?.faceUrl ?? "";
  }

  @override
  String getSuspensionTag() => tagIndex ?? "";

  @override
  String toString() => json.encode(this);
}

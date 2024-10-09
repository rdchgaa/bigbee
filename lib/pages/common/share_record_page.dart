import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/funds_details_record_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/user/invite_list_model.dart';
import 'package:bee_chat/models/user/user_detail_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_add_coin_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/asstes_record_activity_item.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class ShareRecordPage extends StatefulWidget {
  final UserDetailModel userInfo;

  const ShareRecordPage({super.key, required this.userInfo});

  @override
  State<ShareRecordPage> createState() => _ShareRecordPageState();
}

class _ShareRecordPageState extends State<ShareRecordPage> with AutomaticKeepAliveClientMixin {
  int _pageNum = 1;

  List<InviteListRecords> records = [];

  bool hasMore = true;

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    _pageNum = 1;
    final result = await UserNet.userGetInviteList(pageNum: _pageNum);
    if (result.data != null) {
      records = result.data?.records ?? [];
    }
    if (records.length >= (result.data?.total ?? 0)) {
      hasMore = false;
    }
    setState(() {});
  }

  onLoad() async {
    _pageNum = _pageNum + 1;
    final result = await UserNet.userGetInviteList(
      pageNum: _pageNum,
    );
    if (result.data != null) {
      records.addAll(result.data?.records ?? []);
    }
    if (records.length >= (result.data?.total ?? 0)) {
      hasMore = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    final theme = AB_theme(context);

    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).invitationRecord,
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
      body: SizedBox(
        child: Column(
          children: [
            Expanded(child: recordsListView()),
          ],
        ),
      ),
    );
  }

  Widget recordsListView() {
    final theme = AB_theme(context);
    return EasyRefresh(
      header: CustomizeBallPulseHeader(color: theme.primaryColor),
      onRefresh: () async {
        initData();
      },
      onLoad: !hasMore
          ? null
          : () async {
              onLoad();
            },
      child: records.isEmpty
          ? Container(
              alignment: Alignment.center,
              color: theme.backgroundColor,
              child: Image.asset(ABAssets.emptyIcon(context)),
            )
          : ListView.separated(
              // physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 18.px, bottom: 18.px),
              itemBuilder: (context, index) {
                InviteListRecords item = records[index];
                var time = DateTime.parse(item.inviteTime);
                var timeString =
                    '${time.year}-${singleTimeToString(time.month)}-${singleTimeToString(time.day)} '
                    '${singleTimeToString(time.hour)}:${singleTimeToString(time.minute)}:${singleTimeToString(time
                    .second)}';
                return ShareRecordItemWidget(
                  avatarUrl: item.avatarUrl,
                  nickName: item.nickName,
                  onLineStatus: item.onlineStatus == 'Online',
                  time: timeString,
                );
              },
              itemCount: records.length,
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(left: 16.0.px, right: 16.px),
                  child: Divider(
                    height: 1,
                    color: theme.f4f4f4,
                  ),
                );
              },
            ),
    );
  }

  String singleTimeToString(int time) {
    String value = time.toString();
    if (time < 10) {
      value = '0$value';
    }
    return value;
  }

  @override
  bool get wantKeepAlive => true;
}

class ShareRecordItemWidget extends StatelessWidget {
  final String avatarUrl;
  final String nickName;
  final bool onLineStatus;
  final String time;

  const ShareRecordItemWidget(
      {super.key, this.avatarUrl = '', this.nickName = '', required this.onLineStatus, required this.time});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      height: 90.px,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(width: 16.px),
        Container(
          width: 56.px,
          height: 56.px,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(37.px),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(37.px),
            child: ABImage.avatarUser(avatarUrl),
          ),
        ),
        SizedBox(width: 14.px),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ABText(
              nickName,
              textColor: theme.textColor,
              fontSize: 16.px,
              fontWeight: FontWeight.bold,
            ),
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: onLineStatus ? Color(0xff00FF47) : theme.text999,
                      borderRadius: BorderRadius.all(Radius.circular(5.px))),
                  child: SizedBox(width: 10.px, height: 10.px),
                ),
                SizedBox(width: 5),
                ABText(
                  onLineStatus ? AB_S().online : AB_S().offline,
                  textColor: theme.text999,
                  fontSize: 14.px,
                ),
              ],
            ),
            SizedBox(width: 2),
            ABText(
              AB_getS(context).invitationTime + ':' + time,
              textColor: theme.d7d7d7,
              fontSize: 12.px,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox().expanded(),
      ]),
    );
  }
}

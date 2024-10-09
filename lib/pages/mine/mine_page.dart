import 'package:bee_chat/pages/common/share_user_page.dart';
import 'package:bee_chat/pages/dynamic/dynamic_draft_page.dart';
import 'package:bee_chat/pages/dynamic/dynamic_my_page.dart';
import 'package:bee_chat/pages/dynamic/dynamic_views_page.dart';
import 'package:bee_chat/pages/mine/collection/collection_like_page.dart';
import 'package:bee_chat/pages/mine/mine_follow_fans_list_page.dart';
import 'package:bee_chat/pages/mine/mine_info_editor_page.dart';
import 'package:bee_chat/pages/mine/mine_look_list_page.dart';
import 'package:bee_chat/pages/mine/vm/mine_follow_fans_list_vm.dart';
import 'package:bee_chat/pages/mine/widget/mine_user_info_widget.dart';
import 'package:bee_chat/pages/mine/widget/mine_vip_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

import '../../models/user/user_detail_model.dart';
import '../../net/user_net.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  UserDetailModel _userInfo = UserDetailModel();

  @override
  void initState() {
    _requestUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: const ABAppBar(
        title: "",
      ),
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              MineUserInfoWidget(
                userInfo: _userInfo,
                userId: ABSharedPreferences.getUserIdSync(),
                onTap: () async {
                  final newUserinfo = await ABRoute.push(MineInfoEditorPage(
                    userInfo: _userInfo,updateCallback: (newUserinfo){
                    if (newUserinfo != null) {
                      _userInfo = newUserinfo;
                      setState(() {});
                    }
                  },
                  )) as UserDetailModel?;
                  // if (newUserinfo != null) {
                  //   _userInfo = newUserinfo;
                  //   setState(() {});
                  // }
                },
              ),
              const SizedBox(
                height: 26,
              ),
              // Vip
              const MineVipWidget().addPadding(padding: const EdgeInsets.symmetric(horizontal: 16)),
              _numWidget(),
              Dash(
                direction: Axis.horizontal,
                length: ABScreen.width - 32,
                dashColor: theme.textGrey,
                dashLength: 3,
              ).center,
              const SizedBox(
                height: 26,
              ),
              _btnWidget(),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  Widget _numWidget() {
    final theme = AB_theme(context);
    Widget numItemWidget({String title = "", int num = 0}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            num.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: theme.textColor),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textColor),
          ),
        ],
      );
    }

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
                  onTap: () async {
                    await ABRoute.push(DynamicMyPage());
                    _requestUserInfo();
                  },
                  child: numItemWidget(title: AB_getS(context).dynamic, num: _userInfo.postsNumber ?? 0))
              .expanded(),
          Dash(
            direction: Axis.vertical,
            length: 36,
            dashColor: theme.textGrey,
            dashLength: 3,
          ),
          InkWell(
            onTap: () async {
              await ABRoute.push(MineFollowFansListPage(type: MineFollowFansListType.follow));
              _requestUserInfo();
            },
            child: numItemWidget(title: AB_getS(context).follow, num: _userInfo.focusNumber ?? 0),
          ).expanded(),
          Dash(
            direction: Axis.vertical,
            length: 36,
            dashColor: theme.textGrey,
            dashLength: 3,
          ),
          InkWell(
                  onTap: () async {
                    await ABRoute.push(MineFollowFansListPage(type: MineFollowFansListType.fans));
                    _requestUserInfo();
                  },
                  child: numItemWidget(title: AB_getS(context).fans, num: _userInfo.fansNumber ?? 0))
              .expanded(),
          Dash(
            direction: Axis.vertical,
            length: 36,
            dashColor: theme.textGrey,
            dashLength: 3,
          ),
          InkWell(
                  onTap: () async {
                    await ABRoute.push(MineLookListPage());
                    _requestUserInfo();
                  },
                  child: numItemWidget(title: AB_getS(context).look, num: _userInfo.lookMeNumber ?? 0))
              .expanded(),
        ],
      ).addPadding(padding: const EdgeInsets.only(top: 31, bottom: 25)),
    );
  }

  Widget _btnWidget() {
    final theme = AB_theme(context);
    final gridItemW = (ABScreen.width - 32) / 4;
    const gridItemH = 64;
    List<Map<String, dynamic>> data = [
      {
        "title": "${AB_getS(context).praise}/${AB_getS(context).collection}",
        "icon": ABAssets.mineLike(context),
        "onTap": () async {
          await ABRoute.push(const CollectionLikePage());
          _requestUserInfo();
        }
      },
      {
        "title": AB_getS(context).lookHistory,
        "icon": ABAssets.mineLook(context),
        "onTap": () async {
          await ABRoute.push(DynamicViewsPage());
          _requestUserInfo();
        }
      },
      {
        "title": AB_getS(context).draftBox,
        "icon": ABAssets.mineDraft(context),
        "onTap": () async {
          await ABRoute.push(DynamicDraftPage());
          _requestUserInfo();
        }
      },
      {"title": AB_getS(context).advertisingCenter, "icon": ABAssets.mineAd(context), "onTap": () {}},
      {
        "title": AB_getS(context).inviteFriends,
        "icon": ABAssets.mineInvite(context),
        "onTap": () {
          ABRoute.push(ShareUserPage(userInfo: _userInfo));
        }
      },
    ];

    Widget itemWidget({required Map<String, dynamic> data}) {
      return InkWell(
        onTap: data["onTap"],
        child: Column(
          children: [
            Image.asset(
              data["icon"],
              width: 36,
              height: 36,
            ),
            const SizedBox(
              height: 6,
            ),
            ABText(
              data["title"],
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textColor: theme.textColor,
              softWrap: false,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //设置列数
        crossAxisCount: 4,
        //设置横向间距
        crossAxisSpacing: 0,
        //设置主轴间距
        mainAxisSpacing: 24,
        childAspectRatio: gridItemW / gridItemH,
      ),
      shrinkWrap: true,
      // 避免内部子项的尺寸影响外部容器的高度
      itemCount: data.length,
      // 总共20个项目
      itemBuilder: (context, index) {
        return itemWidget(data: data[index]);
      },
    );
  }

  void _requestUserInfo() async {
    final userId = await ABSharedPreferences.getUserId() ?? "";
    final result = await UserNet.getUserInfo(userId: userId);
    if (result.data != null) {
      _userInfo = result.data!;
      setState(() {});
    }
  }
}

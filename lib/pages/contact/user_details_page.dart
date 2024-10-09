import 'dart:async';

import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/contact/contact_setting_page.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_list_item.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/im/im_call_utils.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/friendShip/friendship_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../models/user/user_detail_model.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_event_bus.dart';
import '../../utils/ab_route.dart';
import '../chat/c2c_chat_page.dart';

class UserDetailsPage extends StatefulWidget {
  // IM的Id
  final String userId;

  // 主要用来发送消息以及清空聊天记录之类的
  final TUIChatSeparateViewModel? model;

  const UserDetailsPage({super.key, required this.userId, this.model});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final FriendshipServices _friendshipServices = serviceLocator<FriendshipServices>();
  UserDetailModel _userInfo = UserDetailModel();
  late StreamSubscription _subscription;

  bool hasMore = false;
  List<PostsHotRecommendListRecords> hotRecommendList = [];

  int pageNum = 1;

  bool? _isFocus;

  @override
  void initState() {
    _requestUserInfo();
    //订阅：
    _subscription = ABEventBus.on<ABEvent>((event) {
      if (event.name == friendRemarkChangedEventName || event.name == friendDidDeleteEventName) {
        _requestUserInfo();
      }
    });
    initData();
    super.initState();
  }

  @override
  void dispose() {
    // 取消订阅：
    _subscription.cancel();
    super.dispose();
  }

  initData() {
    getHotRecommendListData();
    getFocus();
  }

  getHotRecommendListData() async {
    pageNum = 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsGetUserPostsLists(pageNum: pageNum, memberNum: widget.userId);
    if (resultRecords.data != null) {
      hotRecommendList = resultRecords.data?.records ?? [];
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  onMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsGetUserPostsLists(pageNum: pageNum, memberNum: widget.userId);
    if (resultRecords.data != null) {
      hotRecommendList.addAll(resultRecords.data?.records ?? []);
      hasMore = (resultRecords.data!.total ?? 0) > hotRecommendList.length;
      setState(() {});
    }
  }

  getFocus() async {
    var result = await DynamicsNet.dynamicsIsFocus(memberNum: widget.userId);
    if (result.data != null) {
      _isFocus = result.data;
    }
    setState(() {});
  }

  toFocus(isFocus) async {
    var resultRecords = await DynamicsNet.dynamicsFocus(memberNum: widget.userId, isFocus: isFocus);
    if (resultRecords.success == true) {
      setState(() {
        _isFocus = isFocus;
      });
      ABToast.show(isFocus ? AB_S().followSuccess : AB_S().unfollowSuccess, toastType: ToastType.success);
      ABEventBus.fire(FocusEvent(userID: widget.userId, isFocus: isFocus));
    } else {
      ABToast.show(isFocus ? AB_S().followFailed : AB_S().unfollowFailed, toastType: ToastType.success);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: "",
        rightWidget: ((_userInfo.isFriend ?? false) && !_isSelf())
            ? InkWell(
                onTap: () {
                  ABRoute.push(ContactSettingPage(
                    userDetailModel: _userInfo,
                    userID: widget.userId,
                  ));
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  width: 60,
                  height: 44,
                  child: Icon(
                    Icons.settings,
                    color: theme.textColor,
                    size: 24,
                  ),
                ),
              )
            : null,
      ),
      backgroundColor: theme.backgroundColor,
      body: EasyRefresh(
        header: CustomizeBallPulseHeader(color: theme.primaryColor),
        onRefresh: () async {
          initData();
        },
        onLoad: !hasMore
            ? null
            : () async {
                onMore();
              },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 头像+昵称+在线状态+粉丝关注
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    // 头像
                    ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: ABImage.avatarUser(
                          _userInfo.avatarUrl ?? "",
                          width: 64,
                          height: 64,
                        )),
                    const SizedBox(
                      width: 14,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 昵称
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: _userInfo.showName,
                                        style: TextStyle(
                                          color: theme.textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ',
                                        style: TextStyle(
                                          color: theme.textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if ((_userInfo.level ?? 0) > 0)
                                        WidgetSpan(
                                          alignment: PlaceholderAlignment.middle,
                                          child: Image.asset(
                                            ABAssets.userVip(context),
                                            width: 20,
                                            height: 17,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ).expanded(),
                            const SizedBox(
                              width: 6,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            // 在线状态
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _userInfo.isOnline ? theme.primaryColor : Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Container(
                                width: 56,
                                child: ABText(
                                  "${_userInfo.isOnline ? AB_getS(context).online : AB_getS(context).offline}",
                                  textColor: theme.textGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        if ((_userInfo.friendNickName ?? "").isNotEmpty &&
                            _userInfo.friendNickName != _userInfo.nickName)
                          Container(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: ABText(
                                "${AB_getS(context).nickname}: ${_userInfo.nickName}",
                                textColor: theme.textGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        //粉丝关注
                        Row(
                          children: [
                            ABText(
                              "${AB_getS(context).follow}${_userInfo.focusNumber} | ${AB_getS(context).fans}${_userInfo.fansNumber}",
                              textColor: theme.textGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ).expanded(),
                            const SizedBox(
                              width: 6,
                            ),
                            if (!_isSelf())
                              if (_isFocus != null)
                                ABButton(
                                  text: _isFocus! ? "${AB_getS(context).followed}" : "+${AB_getS(context).follow}",
                                  backgroundColor: _isFocus! ? theme.textGrey : theme.primaryColor,
                                  cornerRadius: 6,
                                  height: 30,
                                  width: 72,
                                  textColor: theme.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  onPressed: () {
                                    toFocus(!_isFocus!);
                                  },
                                ),
                          ],
                        ),
                      ],
                    ).expanded(),
                  ],
                ),
              ),
              // 简介
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: Colors.white,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ABText(
                    "${(_userInfo.profile ?? "").isNotEmpty ? _userInfo.profile! : AB_getS(context).noIntroduction}",
                    textColor: theme.textGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    softWrap: true,
                    maxLines: 10000,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ]),
              ),
              // 按钮
              if (!_isSelf()) _buttonWidget(),
              SizedBox(
                height: 20,
              ),
              // 动态标题
              (Align(
                  alignment: Alignment.centerLeft,
                  child: ABText(
                    AB_getS(context).dynamic,
                    textColor: theme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ))).addPadding(padding: EdgeInsets.symmetric(horizontal: 16)),

              Builder(builder: (context) {
                List<Widget> buildList = [];
                if (hotRecommendList.length == 0) {
                  return SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: Image.asset(ABAssets.emptyIcon(context)),
                  );
                }
                for (var i = 0; i < hotRecommendList.length; i++) {
                  var item = hotRecommendList[i];
                  buildList.add(DynamicListItem(
                    key:ValueKey(item.postId),
                    model: item,
                    showFollow: false,
                    deleteCall: () {
                      hotRecommendList.removeAt(i);
                      setState(() {});
                    },
                  ));
                }
                return Column(
                  children: buildList,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonWidget() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 14,
        left: 16,
        right: 16,
      ),
      color: Colors.white,
      child: Row(children: [
        if (_userInfo.isFriend == true)
          _buttonItemWidget(AB_getS(context).sendMessage, assetName: ABAssets.userChat(context), onPressed: () {
            ABRoute.push(C2cChatPage(
              selectedConversation: V2TimConversation(
                  conversationID: "c2c_${widget.userId}", userID: widget.userId, showName: _userInfo.showName, type: 1),
            ));
          }),
        if (_userInfo.isFriend == true)
          SizedBox(
            width: 14,
          ),
        if (_userInfo.isFriend == true)
          _buttonItemWidget(AB_getS(context).callVideo, assetName: ABAssets.userChat(context), onPressed: () {
            ImCallUtils.callUser(context: context, userId: widget.userId, type: ImCallUtilsType.voice);
          }),
        if (_userInfo.isFriend == true)
          SizedBox(
            width: 14,
          ),
        if (_userInfo.isFriend != true)
          _buttonItemWidget(AB_getS(context).addFriend1, assetName: ABAssets.userChat(context), onPressed: () {
            _addFriendAction();
          }),
      ]),
    );
  }

  Widget _buttonItemWidget(String text, {String assetName = "", Icon? icon, Function? onPressed}) {
    final theme = AB_theme(context);
    return Expanded(
      child: InkWell(
        onTap: () {
          onPressed?.call();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 6,
          ),
          alignment: Alignment.center,
          height: 40,
          decoration: BoxDecoration(
            color: HexColor("F5F5F6"),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) icon,
              if (assetName.isNotEmpty)
                Image.asset(
                  assetName,
                  width: 24,
                  height: 24,
                ),
              const SizedBox(
                width: 6,
              ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 10,
                    maxHeight: (ABScreen.width - 32 - 28) / 3 - 44,
                  ),
                  child: ABText(
                    text,
                    textColor: theme.textColor,
                    fontSize: 15,
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ).center,
        ),
      ),
    );
  }

  bool _isSelf() {
    return widget.userId == ABSharedPreferences.getUserIdSync();
  }

  Future<V2TimFriendOperationResult?> _doAddFriend(String userID) async {
    final res = await _friendshipServices.addFriend(userID: userID, addType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH);
    if (res.code == 0) {
      return res.data;
    }
    if (res.code == 6014) {
      ABToast.show(AB_getS(context, listen: false).imNotLogin);
    }
    return null;
  }

  void _addFriendAction() async {
    ABLoading.show();
    final res = await _doAddFriend(widget.userId);
    await ABLoading.dismiss();
    if (res == null) {
      ABToast.show(TIM_t("好友添加失败"));
      return;
    }
    if (res.resultCode == 0) {
      ABToast.show(TIM_t("好友添加成功"));
      setState(() {
        _userInfo.isFriend = true;
      });
    } else if (res.resultCode == 30539) {
      ABToast.show(TIM_t("好友申请已发出"));
    } else if (res.resultCode == 30515) {
      ABToast.show(TIM_t("当前用户在黑名单"));
    }
  }

  void _requestUserInfo() async {
    final result = await UserNet.getUserInfo(userId: widget.userId);
    if (result.data != null) {
      setState(() {
        _userInfo = result.data!;
      });
    }
  }
}

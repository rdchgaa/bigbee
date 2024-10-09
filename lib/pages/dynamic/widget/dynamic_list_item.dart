import 'dart:async';
import 'dart:math';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/dynamic/get_posts_count_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/dialog/help_posts_dialog.dart';
import 'package:bee_chat/pages/dynamic/dynamic_details_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/pages/mine/collection/widget/collection_message_item_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_event_bus.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/im/im_message_utils.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_text.dart';

import '../../../utils/ab_assets.dart';
import '../../dialog/share_dialog.dart';

class DynamicListItem extends StatefulWidget {
  final PostsHotRecommendListRecords model;
  final bool? showFollow;
  final Function deleteCall;
  const DynamicListItem({
    super.key,
    required this.model,
    this.showFollow = true, required this.deleteCall,
  });

  @override
  State<DynamicListItem> createState() => _DynamicListItemState();
}

class _DynamicListItemState extends State<DynamicListItem> with AutomaticKeepAliveClientMixin {
  final _controller = SuperTooltipController();

  GetPostsCountModel? countData;
  bool? _isFocus;

  late StreamSubscription _subscriptionFocus;
  late StreamSubscription _subscriptionPostCount;

  @override
  void initState() {
    _isFocus = widget.model.isFocus == 1;
    _subscriptionFocus = ABEventBus.on<FocusEvent>((event) {
      if (event.userID == widget.model.memberNum) {
        _isFocus = event.isFocus;
        if (mounted) setState(() {});
      }
    });
    _subscriptionPostCount = ABEventBus.on<PostCountEvent>((event) {
      if (event.postId == widget.model.postId) {
        getCount();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionFocus.cancel();
    _subscriptionPostCount.cancel();
    super.dispose();
  }

  toLike({bool isLike = true}) async {
    var resultRecords = await DynamicsNet.dynamicsLikePosts(postsId: widget.model.postId ?? 0, isLike: isLike);
    if (resultRecords.success == true) {
      widget.model.isLike = isLike;
      if (isLike) {
        widget.model.likeCount = (widget.model.likeCount ?? 0) + 1;
      } else {
        widget.model.likeCount = (widget.model.likeCount ?? 1) - 1;
      }
      setState(() {});
      ABToast.show(isLike ? AB_S().likeSuccess : AB_S().cancelLikeSuccess, toastType: ToastType.success);
      ABEventBus.fire(PostCountEvent(postId: widget.model.postId ?? 0));
    } else {
      ABToast.show(resultRecords.message ?? (isLike ? AB_S().likeFailed : AB_S().cancelLikeFailed),
          toastType: ToastType.fail);
    }
  }

  toFocus(isFocus) async {
    var resultRecords = await DynamicsNet.dynamicsFocus(memberNum: widget.model.memberNum ?? '1', isFocus: isFocus);
    if (resultRecords.success == true) {
      setState(() {
        _isFocus = isFocus;
      });
      ABToast.show(isFocus ? AB_S().followSuccess : AB_S().unfollowSuccess, toastType: ToastType.success);
      ABEventBus.fire(FocusEvent(userID: widget.model.memberNum ?? '', isFocus: isFocus));
    } else {
      ABToast.show(isFocus ? AB_S().followFailed : AB_S().unfollowFailed, toastType: ToastType.success);
    }
    setState(() {});
  }

  getCount() async {
    var resultRecords = await DynamicsNet.dynamicsGetPostsCount(postsId: widget.model.postId ?? 0);
    if (resultRecords.data != null) {
      countData = resultRecords.data;
    }
    setState(() {});
  }

  toShare() async {
    if (widget.model.isCanShare == false) {
      ABToast.show(AB_S().notShareTip, toastType: ToastType.fail);
      return;
    }
    final items = [
      ShareDialogItemModel(
          title: AB_S().send,
          IconAssetName: ABAssets.assetsSend(context),
          onTap: () async {
            print("分享结果 - 1");
          }),
      ShareDialogItemModel(
          title: AB_S().send,
          IconAssetName: ABAssets.assetsHistory(context),
          onTap: () async {
            print("分享结果 - 2");
          }),
    ];
    final cons = await ShareDialog.show(context, items: []) as List?;
    print("会话列表 - $cons");
    if (cons == null || cons.isEmpty) {
      return;
    }
    final shareModel = PostShareMsgModel(
        postId: widget.model.postId ?? 0,
        nickName: widget.model.nickName ?? '',
        textContent: widget.model.textContent ?? '',
        imageUrls: widget.model.imgeUrls ?? '',
        videoUrl: widget.model.videoUrl ?? '');
    int num = 0;
    ABLoading.show();
    for (var item in cons) {
      final res =
          await ImMessageUtils.sendDynamicMessage(model: shareModel, groupId: item.groupID, userId: item.userID);
      if (res != null) {
        num++;
      }
    }
    ABLoading.dismiss();
    final res = await DynamicsNet.dynamicsShare(postsId: widget.model.postId ?? 0, num: num);
    if (res.data != null) {
      widget.model.shareCount = (widget.model.shareCount ?? 0) + 1;
      ABEventBus.fire(PostCountEvent(postId: widget.model.postId ?? 0));
      ABToast.show(AB_S().shareSuccess,toastType: ToastType.success);
    }else{
      ABToast.show(res.message ?? AB_S().shareFailed, toastType: ToastType.fail);
    }
    setState(() {});
  }

  toCollect({bool isCollect = true}) async {
    var resultRecords = await DynamicsNet.dynamicsCollectPosts(postsId: widget.model.postId ?? 0, collect: isCollect);
    if (resultRecords.success == true) {
      widget.model.isCollect = isCollect;
      setState(() {});
      ABToast.show(isCollect ? AB_S().collectSuccess : AB_S().cancelCollectSuccess, toastType: ToastType.success);
    } else {
      ABToast.show(resultRecords.message ?? (isCollect ? AB_S().collectFailed : AB_S().cancelCollectFailed),
          toastType: ToastType.fail);
    }
  }

  deletePost() async{
    var resultRecords = await DynamicsNet.dynamicsRemovePosts(postsId: [widget.model.postId.toString()]);
    if (resultRecords.success == true) {
      ABToast.show(AB_S().deleteSuccess, toastType: ToastType.success);
      widget.deleteCall();
    } else {
      ABToast.show(AB_S().deleteFailed, toastType: ToastType.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = AB_theme(context);
    // 动态列表item
    return Container(
        margin: EdgeInsets.only(left: 16.px, right: 16.px, bottom: 10.px),
        padding: EdgeInsets.all(14.px),
        decoration: BoxDecoration(
          color: theme.white,
          borderRadius: BorderRadius.circular(12.px),
        ),
        child: InkWell(
          onTap: () async {
            if (widget.model.postId == null) return;
            await ABRoute.push(DynamicDetailsPage(
              postsId: widget.model.postId!,
            ));
            getCount();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像+昵称+时间+省略号icon
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                // 头像
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: ABImage.avatarUser(widget.model.avatarUrl ?? '', height: 48.px, width: 48.px),
                ),
                SizedBox(width: 10.px),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 昵称
                    Text(
                      widget.model.nickName ?? '',
                      style: TextStyle(fontSize: 14.px, color: theme.textColor, fontWeight: FontWeight.w600),
                    ),
                    // 时间
                    Builder(builder: (context) {
                      DateTime? date = DateTime.tryParse(widget.model.publishTime ?? '');
                      if (date == null) return SizedBox();
                      return Text(
                        '${date.year}-${date.month}-${date.day}',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: theme.textGrey,
                        ),
                      );
                    }),
                  ],
                ).expanded(),
                if (widget.showFollow == true)
                  if (widget.model.memberNum != UserProvider.getCurrentUser().userId)
                    Builder(builder: (context) {
                      bool isFocus = widget.model.isFocus == 1;
                      if (_isFocus != null) {
                        isFocus = _isFocus!;
                      }
                      return ABButton(
                        text: isFocus ? "${AB_getS(context).followed}" : "+${AB_getS(context).follow}",
                        backgroundColor: isFocus ? theme.textGrey : theme.primaryColor,
                        cornerRadius: 6,
                        height: 33.px,
                        width: 68.px,
                        textColor: theme.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        onPressed: () async {
                          toFocus(!isFocus);
                        },
                      );
                    }),
                SizedBox(width: 10.px),
                // 省略号icon
                SuperTooltip(
                  minimumOutsideMargin: 16.px - 6,
                  controller: _controller,
                  barrierColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  arrowTipDistance: 8.px,
                  arrowBaseWidth: 0,
                  arrowLength: 0,
                  borderColor: Colors.transparent,
                  hasShadow: false,
                  content: _toolWidget(context),
                  child: Image.asset(
                    ABAssets.mineMore(context),
                    color: theme.textGrey,
                    width: 20.px,
                    height: 20.px,
                    fit: BoxFit.contain,
                  ),
                ),
              ]),
              SizedBox(height: 10.px),
              // 内容
              if (widget.model.textContent != null && widget.model.textContent != '')
                ExtendedText(widget.model.textContent ?? '',
                    style: TextStyle(
                      fontSize: 14.px,
                      color: theme.textColor,
                    ),
                    specialTextSpanBuilder: DefaultSpecialTextSpanBuilder(
                      isUseQQPackage: true,
                      isUseTencentCloudChatPackage: true,
                      customEmojiStickerList: TUIKitStickerConstData.emojiList,
                      showAtBackground: true,
                    )),
              //视频
              if (widget.model.videoUrl != null && widget.model.videoUrl!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 10.0.px),
                  child: LayoutBuilder(builder: (context, con) {
                    var url = widget.model.videoUrl ?? '';
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(6.px),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: con.maxWidth,
                              height: con.maxWidth / 296 * 170,
                              child: VideoFrameWidget(url: url),
                            ),
                            Positioned.fill(
                              child: Center(
                                  child: Image.asset(
                                ABAssets.videoPlay(context),
                                width: 24.px,
                                height: 24.px,
                              )),
                            ),
                          ],
                        ));
                  }),
                ),
              // 图片
              if (widget.model.imgeUrls != null && widget.model.imgeUrls!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 10.0.px),
                  child: LayoutBuilder(builder: (context, con) {
                    // if(model.imgeUrls.contains(';'))
                    List<String> images = widget.model.imgeUrls!.split(';');
                    if (images.isEmpty) {
                      return SizedBox();
                    }
                    if (images.length == 1) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(6.px),
                          child: ABImage.imageWithUrl(images[0],
                              width: con.maxWidth, height: con.maxWidth / 296 * 170, fit: BoxFit.cover));
                    } else {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 5.px,
                              crossAxisSpacing: 5.px,
                              childAspectRatio: 109 / 80),
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(6.px),
                                child: ABImage.imageWithUrl(images[index],
                                    width: con.maxWidth / 3, height: con.maxWidth / 3, fit: BoxFit.cover));
                          });
                    }
                  }),
                ),
              if (widget.model.addName != null && widget.model.addName != '')
                Padding(
                  padding: EdgeInsets.only(top: 10.px),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(ABAssets.address(context), width: 24.px, height: 24.px),
                      SizedBox(width: 4.px),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.model.addName.toString(),
                          maxLines: 1,
                          style: TextStyle(fontSize: 14.px, color: theme.textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16.px),
              // 热门+评论+点赞+查看+发送
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Builder(builder: (context) {
                  var itemWidth = 80.px;

                  return Row(
                    children: [
                      Builder(builder: (context) {
                        int shareCount = widget.model.shareCount ?? 0;
                        if (countData != null) {
                          shareCount = countData?.sharesNum ?? shareCount;
                        }
                        return SizedBox(
                          width: itemWidth,
                          child: _iconWidget(
                              context: context,
                              assetName: ABAssets.dynamicSendIcon(context),
                              value: "${shareCount}",
                              onTap: () async {
                                toShare();
                              }),
                        );
                      }),
                      Builder(builder: (context) {
                        int commentCount = widget.model.commentCount ?? 0;
                        if (countData != null) {
                          commentCount = countData?.commentNum ?? commentCount;
                        }
                        return SizedBox(
                          width: itemWidth,
                          child: _iconWidget(
                              context: context,
                              assetName: ABAssets.dynamicCommentIcon(context),
                              value: numToK(commentCount),
                              onTap: () {
                                if (widget.model.isCanComment == false) {
                                  ABToast.show(AB_S().notCommentTip, toastType: ToastType.fail);
                                  return;
                                }
                                ABRoute.push(DynamicDetailsPage(
                                  postsId: widget.model.postId!,
                                  inComment: true,
                                ));
                              }),
                        );
                      }),
                      Builder(builder: (context) {
                        bool isLike = widget.model.isLike ?? false;
                        int likeCount = widget.model.likeCount ?? 0;
                        if (countData != null) {
                          isLike = countData?.like ?? isLike;
                          likeCount = countData?.giveNum ?? likeCount;
                        }
                        return SizedBox(
                          width: itemWidth,
                          child: _iconWidget(
                              context: context,
                              assetName:
                              (isLike) ? ABAssets.dynamicLikedIcon(context) : ABAssets.dynamicLikeIcon(context),
                              value: numToK(likeCount),
                              onTap: () {
                                toLike(isLike: isLike ? false : true);
                                // dynamicsLikePosts
                              }),
                        );
                      }),
                    ],
                  );
                }),
                Builder(builder: (context) {
                  int lookCount = widget.model.lookCount ?? 0;
                  if (countData != null) {
                    lookCount = countData?.readNum ?? lookCount;
                  }
                  return _iconWidget(
                      context: context, assetName: ABAssets.dynamicLookIcon(context), value: numToK(lookCount));
                }),
              ])
            ],
          ),
        )).addPadding(
      padding: EdgeInsets.only(top: 10.px),
    );
  }

  Widget _iconWidget({required BuildContext context, String assetName = "", String value = "", Function? onTap}) {
    final theme = AB_theme(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            onTap == null ? null : onTap();
          },
          child: Row(
            children: [
              Image.asset(assetName, width: 24.px, height: 24.px),
              SizedBox(width: 4.px),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            onTap == null ? null : onTap();
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(fontSize: 14.px, color: theme.textColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _toolWidget(BuildContext context) {
    final theme = AB_theme(context);
    return HomeToolTipWidget(
      items: [
        HomeToolTipItem(
          title: widget.model.isCollect == true ? AB_getS(context).cancelCollect : AB_getS(context).collection,
          icon: Image.asset(
            widget.model.isCollect == true ? ABAssets.mineCollNo(context) : ABAssets.iconCollection(context),
            width: 24.px,
            height: 24.px,
          ),
          onTap: () {
            toCollect(isCollect: widget.model.isCollect == true ? false : true);
          },
        ),
        HomeToolTipItem(
          title: AB_getS(context).helpHot,
          icon: Image.asset(
            ABAssets.dynamicsHelpHot(context),
            width: 24.px,
            height: 24.px,
          ),
          onTap: () async {
            bool? value = await showHelpPostDialog(context, postId: widget.model.postId!);
            // if (value == true) {
            //   cancelCollection();
            // }
          },
        ),
        if (widget.model.memberNum == UserProvider.getCurrentUser().userId)
          HomeToolTipItem(
            title: AB_getS(context).delete,
            icon: SizedBox(
              width: 24.px,
              height: 24.px,
              child: Center(
                child: Image.asset(
                  ABAssets.iconDelete(context),
                  width: 20.px,
                  height: 20.px,
                ),
              ),
            ),
            onTap: () async {
              var value = await showAlertDialog(
                context,
                content: AB_S().deleteDynamicTip,
                buttonCancel: AB_S().cancel,
                buttonOk: AB_S().delete,
              );
              if(value==true){
                deletePost();
              }

            },
          ),
      ],
      onTap: (_) {
        _controller.hideTooltip();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DynamicListModel {
  String content;
  String time;
  int type;
  String id;
  String userId;
  String userName;
  String userAvatar;
  List<String> images;

  DynamicListModel({
    required this.content,
    required this.time,
    required this.type,
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.images,
  });

  static List<DynamicListModel> getList() {
    return [
      DynamicListModel(
        content: '生活就像一场戏，我们都是自己故事的主角。不忘初心，方得始终。',
        time: '2021-07-22',
        type: 0,
        id: '1',
        userId: '1',
        userName: '宋轶',
        userAvatar: 'https://img2.baidu.com/it/u=282931997,1224276559&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=750',
        images: [
          "https://img1.baidu.com/it/u=73915406,2367656263&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=500",
        ],
      ),
      DynamicListModel(
        content: '在忙碌的生活中寻找片刻的宁静，一杯茶，一本书，就是我最简单的幸福。',
        time: '2021-07-21',
        type: 0,
        id: '1',
        userId: '1',
        userName: '高圆圆',
        userAvatar: 'https://img0.baidu.com/it/u=560701999,3379597842&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500',
        images: [
          "https://img1.baidu.com/it/u=1722319644,1785323398&fm=253&fmt=auto&app=138&f=JPEG?w=750&h=500",
        ],
      ),
      DynamicListModel(
        content: '和熊二一起在森林里找到了一个秘密基地，我们决定把它打造成我们的小天地。🌳 #兄弟情深 #森林的秘密',
        time: '2024-07-21 ',
        type: 0,
        id: '1',
        userId: '1',
        userName: '熊大',
        userAvatar: 'https://img2.baidu.com/it/u=269706058,505709335&fm=253&fmt=auto&app=138&f=PNG?w=500&h=500',
        images: ['https://img0.baidu.com/it/u=100080021,1406455647&fm=253&fmt=auto&app=120&f=JPEG?w=756&h=500'],
      ),
      DynamicListModel(
        content: '作为一个机器人，我经常思考什么是真正的情感。今天，我试着去理解人类的友谊和爱。',
        time: '2021-07-16',
        type: 0,
        id: '1',
        userId: '1',
        userName: '阿童木',
        userAvatar: 'https://img0.baidu.com/it/u=2002932296,1037994319&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=633',
        images: [],
      ),
      DynamicListModel(
        content: '刚刚完成了一项艰巨的任务，虽然有点疲惫，但保护家园的感觉真好！',
        time: '2021-07-14',
        type: 0,
        id: '1',
        userId: '1',
        userName: '罗峰（《吞噬星空》）',
        userAvatar: 'https://img2.baidu.com/it/u=742203155,3054270551&fm=253&fmt=auto&app=120&f=JPEG?w=890&h=500',
        images: [
          "https://img2.baidu.com/it/u=2597929176,3520921866&fm=253&fmt=auto&app=120&f=JPEG?w=745&h=500",
        ],
      ),
      DynamicListModel(
        content: '突然有一天，原本平静的小村庄，人们突然受到了不明寄生体的袭击。',
        time: '2021-01-01',
        type: 0,
        id: '1',
        userId: '1',
        userName: '张三',
        userAvatar: 'https://q1.itc.cn/q_70/images03/20240610/7050067237a34c12b6247ce21f183d92.jpeg',
        images: [
          "https://img1.baidu.com/it/u=922847932,2985620342&fm=253&fmt=auto&app=120&f=JPEG?w=1422&h=800",
        ],
      )
    ];
  }
}

import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/dynamic/posts_details_comments_model.dart';
import 'package:bee_chat/models/dynamic/posts_details_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/dialog/reward_posts_dialog.dart';
import 'package:bee_chat/pages/dialog/share_dialog.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_comment_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_details_widget.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/pages/login_regist/start_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_event_bus.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/im/im_message_utils.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class DynamicDetailsPage extends StatefulWidget {
  final int postsId;
  final bool? inComment;

  const DynamicDetailsPage({super.key, required this.postsId, this.inComment = false});

  @override
  State<DynamicDetailsPage> createState() => _DynamicDetailsPageState();
}

class _DynamicDetailsPageState extends State<DynamicDetailsPage> {
  ScrollController controller = ScrollController();

  TextEditingController _textController = TextEditingController();

  PostsDetailsModel? details;

  List<PostsDetailsCommentsRecords> comments = [];
  int pageNum = 1;
  bool hasMore = false;
  int sort = 1; //sort 1:时间 2:热度

  final GlobalKey detailsKey = GlobalKey();
  double detailsHeight = 100.px;

  bool currentDetails = true;

  final ValueNotifier<double> _isScrollRatio= ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    initData();
    controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    super.dispose();
  }

  scrollListener() {
    // var num1 =
    var currentPosition = false;
    if (controller.position.pixels >= detailsHeight) {
      _isScrollRatio.value = 1;
    } else if(controller.position.pixels <=0) {
      _isScrollRatio.value = 0;
    }else{
      _isScrollRatio.value = controller.position.pixels / detailsHeight;
    }
    if (currentDetails != currentPosition) {
      // setState(() {
      //   currentDetails = currentPosition;
      // });
    }

    // print('Scroll position: ${controller.position.pixels}');
  }

  initData({bool? isRefresh = false}) {
    getDetailsData(isRefresh: isRefresh);
    getCommentData();
  }

  getDetailsData({bool? isRefresh = false}) async {
    var resultRecords = await DynamicsNet.dynamicsPostsDetails(postId: widget.postsId);
    if (resultRecords.data != null) {
      details = resultRecords.data;
    }
    setState(() {});
    if (isRefresh == true) return;
    getViewHeight();
  }

  // sort 1:时间 2:热度
  getCommentData() async {
    pageNum = 1;
    var resultRecords =
        await DynamicsNet.dynamicsPostsDetailsComments(postId: widget.postsId, pageNum: pageNum, sort: sort);
    if (resultRecords.data != null) {
      comments = resultRecords.data?.records ?? [];
      hasMore = (resultRecords.data!.total ?? 0) > comments.length;
    }
    setState(() {});
  }

  onMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords =
        await DynamicsNet.dynamicsPostsDetailsComments(postId: widget.postsId, pageNum: pageNum, sort: sort);
    if (resultRecords.data != null) {
      comments.addAll(resultRecords.data?.records ?? []);
      hasMore = (resultRecords.data!.total ?? 0) > comments.length;
    }
    setState(() {});
  }

  getViewHeight() async {
    await Future.delayed(Duration(milliseconds: 200));
    if (detailsKey.currentContext == null) return;
    final RenderBox? renderBox = detailsKey.currentContext?.findRenderObject() as RenderBox;
    double height = renderBox?.size.height ?? 100.px;
    detailsHeight = height;
    if (mounted) setState(() {});
    print('Height of Container: $height');
    if (widget.inComment == true) {
      controller.jumpTo(
        detailsHeight,
      );
      currentDetails = false;
    }
    setState(() {});
  }

  toComments() async {
    var resultRecords =
        await DynamicsNet.dynamicsPostsComments(postId: widget.postsId, comment: _textController.text.trim());
    if (resultRecords.success == true) {
      // ABToast.show(AB_S().success);
      ABToast.show(AB_S().success, toastType: ToastType.success);
      _textController = TextEditingController(text: '');

      initData(isRefresh: true);
      ABEventBus.fire(PostCountEvent(postId: widget.postsId));

    } else {
      ABToast.show(resultRecords.message ?? '', toastType: ToastType.fail);
    }

    setState(() {});
  }

  toLike({bool isLike = true}) async {
    var resultRecords = await DynamicsNet.dynamicsLikePosts(postsId: widget.postsId, isLike: isLike);
    if (resultRecords.success == true) {
      details?.isLike = isLike;
      if (isLike) {
        details!.likeCount = (details!.likeCount ?? 0) + 1;
      } else {
        details!.likeCount = (details!.likeCount ?? 1) - 1;
      }
      setState(() {});
      ABToast.show(isLike ? AB_S().likeSuccess : AB_S().cancelLikeSuccess, toastType: ToastType.success);
      ABEventBus.fire(PostCountEvent(postId: widget.postsId));

    } else {
      ABToast.show(resultRecords.message ?? (isLike ? AB_S().likeFailed : AB_S().cancelLikeFailed),
          toastType: ToastType.fail);
    }
  }

  toShare() async{
    if (details?.isCanShare == false) {
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
        postId: widget.postsId ?? 0,
        nickName: details!.nickName ?? '',
        textContent: details!.textContent ?? '',
        imageUrls: details!.imgeUrls ?? '',
        videoUrl: details!.videoUrl ?? '');
    int num = 0;
    ABLoading.show();
    for (var item in cons) {
      final res = await ImMessageUtils.sendDynamicMessage(
          model: shareModel, groupId: item.groupID, userId: item.userID);
      if (res != null) {
        num++;
      }
    }
    ABLoading.dismiss();
    final res = await DynamicsNet.dynamicsShare(postsId: widget.postsId ?? 0, num: num);
    if (res.data != null) {
      details!.shareCount = (details!.shareCount??0)+1;
      ABEventBus.fire(PostCountEvent(postId: widget.postsId ?? 0));
    }
    setState(() {
    });
  }

  toCollect({bool isCollect = true}) async {
    var resultRecords = await DynamicsNet.dynamicsCollectPosts(postsId: widget.postsId, collect: isCollect);
    if (resultRecords.success == true) { 
      details?.isCollect = isCollect;
      if (isCollect) {
        details!.collectNum = (details!.collectNum ?? 0) + 1;
      } else {
        details!.collectNum = (details!.collectNum ?? 1) - 1;
      }
      setState(() {});
      ABToast.show(isCollect ? AB_S().collectSuccess : AB_S().cancelCollectSuccess, toastType: ToastType.success);
      ABEventBus.fire(PostCountEvent(postId: widget.postsId));

    } else {
      ABToast.show(resultRecords.message ?? (isCollect ? AB_S().collectFailed : AB_S().cancelCollectFailed),
          toastType: ToastType.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    var provider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        customTitle: getTitleBuild(),
        rightWidget: (details==null)?SizedBox():InkWell(
          onTap: (){
            toShare();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16.0,right: 16,top: 5,bottom: 5),
            child: Image.asset(ABAssets.dynamicMore(context),width: 24.px,height: 24.px,),
          ),
        ),
      ),
      backgroundColor: theme.white,
      body: Column(
        children: [
          Expanded(
            child: EasyRefresh(
              header: CustomizeBallPulseHeader(color: theme.primaryColor),
              onRefresh: () async {
                initData(isRefresh: true);
              },
              onLoad: !hasMore
                  ? null
                  : () async {
                      onMore();
                    },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100.px),
                controller: controller,
                child: Column(
                  children: [
                    if (details != null) DynamicDetailsWidget(key: detailsKey, details: details!),
                    if (details != null)
                      DynamicCommentWidget(
                        postId: widget.postsId,
                        details: details,
                        comments: comments,
                        onFresh: (int value) {
                          if (value == 3) {
                            getDetailsData(isRefresh: true);
                            ABEventBus.fire(PostCountEvent(postId: widget.postsId));
                          } else {
                            setState(() {
                              sort = value;
                            });
                            getCommentData();
                          }
                        },
                      )
                  ],
                ),
              ),
            ),
          ),
          if (details != null) inputBuild(),
        ],
      ),
    );
  }

  Widget detailsBuild() {
    final theme = AB_theme(context);
    return Padding(
      padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px, bottom: 12.px),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ABText(
          AB_getS(context).groupSettings,
          textColor: theme.text999,
          fontSize: 14.px,
        ),
      ),
    );
  }

  getTitleBuild() {
    final theme = AB_theme(context);
    var itemWidth = 70.px;
    return ValueListenableBuilder(
        valueListenable: _isScrollRatio,
        builder: (context, double value, child) {
          var paddingLeft = value * itemWidth;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 2.px,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  child: SizedBox(
                    width: itemWidth,
                    child: Center(
                      child: ABText(
                        AB_getS(context).text1,
                        fontSize: 18.px,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.animateTo(detailsHeight, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  child: SizedBox(
                    width: itemWidth,
                    child: Center(
                      child: ABText(
                        AB_getS(context).comment,
                        fontSize: 18.px,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: itemWidth * 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: paddingLeft),
                  child: SizedBox(
                    width: itemWidth,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0.px, right: 10.px),
                      child: ColoredBox(
                        color: theme.text282109,
                        child: SizedBox(
                          height: 2.px,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  inputBuild() {
    final theme = AB_theme(context);
    return DecoratedBox(
      decoration: BoxDecoration(color: theme.white),
      child: SizedBox(
          width: double.infinity,
          child: Row(children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 18.px, bottom: 20.px),
              child: DecoratedBox(
                decoration: BoxDecoration(color: theme.f4f4f4, borderRadius: BorderRadius.all(Radius.circular(12.px))),
                child: Padding(
                  padding: EdgeInsets.only(top: 5.px, bottom: 5.px),
                  child: ExtendedTextField(
                    controller: _textController,
                    autofocus: widget.inComment == true ? true : false,
                    maxLines: 4,
                    minLines: 1,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onTap: () {},
                    keyboardType: TextInputType.multiline,
                    textInputAction: PlatformUtils().isAndroid ? TextInputAction.newline : TextInputAction.send,
                    onEditingComplete: () {},
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: 14.px,
                      color: theme.textColor,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14.px,
                          color: theme.textGrey,
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                        isDense: true,
                        hintText: AB_S().participateDiscussions),
                  ),
                ),
              ),
            )),
            inputRightBuild(),
          ])),
    );
  }

  inputRightBuild() {
    final theme = AB_theme(context);
    if ((_textController.text.trim()).isNotEmpty) {
      return SizedBox(
        width: 80.px,
        height: 35.px,
        child: ABButton.gradientColorButton(
          colors: [theme.primaryColor, theme.secondaryColor],
          cornerRadius: 12,
          height: 48.px,
          text: AB_getS(context).comment,
          textColor: theme.textColor,
          onPressed: () async {
            if(details?.isCanComment==false){
              ABToast.show(AB_S().notCommentTip,toastType: ToastType.fail);
              return;
            }
            toComments();
          },
        ).padding(right: 16.px),
      );
    }
    return Padding(
      padding: EdgeInsets.only(right: 16.px),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              toLike(isLike: details!.isLike == true ? false : true);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    details!.isLike == true ? ABAssets.dynamicLikedIcon(context) : ABAssets.dynamicLikeIcon(context),
                    width: 24.px,
                    height: 24.px),
                SizedBox(width: 4.px),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    numToK(int.tryParse(details!.likeCount.toString())??0),
                    maxLines: 1,
                    style: TextStyle(fontSize: 14.px, color: theme.textColor),
                  ),
                ),
              ],
            ),
          ).padding(right: 16.px),
          InkWell(
            onTap: () {
              toCollect(isCollect: details?.isCollect==true? false:true);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(details?.isCollect==true?ABAssets.collected(context):ABAssets.iconCollection(context), width: 24
                    .px,
                    height: 24.px),
                SizedBox(width: 4.px),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    numToK(int.tryParse(details!.collectNum.toString())??0.0),
                    maxLines: 1,
                    style: TextStyle(fontSize: 14.px, color: theme.textColor),
                  ),
                ),
              ],
            ),
          ).padding(right: 16.px),
          InkWell(
            onTap: () async{
              await showRewardPostDialog(context, postId: widget.postsId);
              getDetailsData(isRefresh: true);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(ABAssets.iconGift(context), width: 24.px, height: 24.px),
                SizedBox(width: 4.px),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    numToK((double.tryParse(details!.tippingTotalAmount.toString())??0).toInt()),
                    maxLines: 1,
                    style: TextStyle(fontSize: 14.px, color: theme.textColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

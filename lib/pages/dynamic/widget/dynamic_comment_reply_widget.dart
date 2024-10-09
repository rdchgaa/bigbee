import 'dart:math';

import 'package:bee_chat/models/common/empty_model.dart';
import 'package:bee_chat/models/dynamic/comments_reply_list_model.dart';
import 'package:bee_chat/models/dynamic/posts_details_comments_model.dart';
import 'package:bee_chat/models/dynamic/posts_details_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/dialog/bottom_select_dialog.dart';
import 'package:bee_chat/pages/dialog/comment_reply_dialog.dart';
import 'package:bee_chat/pages/dialog/help_posts_dialog.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_event_bus.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/net/net_model.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../utils/ab_assets.dart';

class DynamicCommentReplyWidget extends StatefulWidget {
  final int postId;
  final PostsDetailsModel? details;
  final PostsDetailsCommentsRecords comment;
  final Function removeCommentCallback;
  final Function commentReplyCallback;

  const DynamicCommentReplyWidget({
    super.key,
    required this.postId,
    required this.comment,
    required this.removeCommentCallback,
    required this.commentReplyCallback,
    this.details,
  });

  @override
  State<DynamicCommentReplyWidget> createState() => _DynamicCommentReplyWidgetState();
}

class _DynamicCommentReplyWidgetState extends State<DynamicCommentReplyWidget> {
  int pageNum = 1;
  bool hasMore = false;
  List<CommentsReplyListRecords> replyList = [];

  @override
  void initState() {
    super.initState();
    getReplyData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getReplyData() async {
    pageNum = 1;
    var resultRecords = await DynamicsNet.dynamicsCommentsReplyList(
        postId: widget.postId, pageNum: pageNum, commentsId: widget.comment.id ?? 0);
    if (resultRecords.data != null) {
      replyList = resultRecords.data?.records ?? [];
      hasMore = (resultRecords.data!.total ?? 0) > replyList.length;
    }
    setState(() {});
  }

  onMore() async {
    pageNum += 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsCommentsReplyList(
        postId: widget.postId, pageNum: pageNum, commentsId: widget.comment.id ?? 0);
    if (resultRecords.data != null) {
      replyList.addAll(resultRecords.data?.records ?? []);
      hasMore = (resultRecords.data!.total ?? 0) > replyList.length;
    }
    setState(() {});
  }

  handleItem(CommentsReplyListRecords item) {
    var isSelf = false;

    var myID = UserProvider.getCurrentUser().userId;
    if (item.fromMemberId.toString() == myID) {
      isSelf = true;
    }
    if (isSelf) {
      BottomSelectDialog.show(
        context,
        actions: [
          BottomSelectDialogAction(
              title: AB_S().reply,
              onTap: () async {
                showReplyWidget(widget.comment, reply: item);
              }),
          BottomSelectDialogAction(
              title: AB_S().delete,
              onTap: () async {
                deleteComment(replyId: item.replyId);
              })
        ],
        isShowCancel: true,
      );
    } else {
      showReplyWidget(widget.comment, reply: item);
    }
  }

  showReplyWidget(PostsDetailsCommentsRecords comment, {CommentsReplyListRecords? reply}) async {
    if (widget.details?.isCanComment == false) {
      ABToast.show(AB_S().notCommentTip, toastType: ToastType.fail);
      return;
    }
    var value = await showCommentReplyDialog(context, comment: comment, reply: reply);
    if (value != null && value != '') {
      RequestResult<EmptyModel> resultRecords;
      if (reply == null) {
        resultRecords = await DynamicsNet.dynamicsCommentsReply(commentsId: comment.id ?? 0, content: value);
      } else {
        resultRecords = await DynamicsNet.dynamicsCommentsReplyToReply(
            commentsId: comment.id ?? 0, content: value, replyId: reply.replyId ?? 0);
      }
      if (resultRecords.success == true) {
        // ABToast.show(AB_S().success);
        ABToast.show(AB_S().success, toastType: ToastType.success);
        getReplyData();
        widget.commentReplyCallback();
      } else {
        ABToast.show(resultRecords.message ?? '', toastType: ToastType.fail);
      }
    }
    setState(() {});
  }

  //replyId==null  删除评论   ！=null删除回复
  deleteComment({int? replyId}) async {
    var value = await showAlertDialog(
      context,
      title: AB_S().deleteComment,
      content: AB_S().deleteCommentTip,
      buttonCancel: AB_S().cancel,
      buttonOk: AB_S().delete,
    );
    if (value == true) {
      if (replyId == null) {
        //删除评论
        var resultRecords = await DynamicsNet.dynamicsDeleteComments(commentsId: widget.comment.id ?? 0, type: 1);
        if (resultRecords.success == true) {
          widget.removeCommentCallback();
          return;
        }
        ABToast.show(resultRecords.message ?? AB_S().deleteFailed, toastType: ToastType.fail);
      } else {
        //删除回复
        var resultRecords = await DynamicsNet.dynamicsDeleteComments(commentsId: replyId, type: 2);
        if (resultRecords.success == true) {
          List tempList = resultRecords.data??[];
          tempList.add(replyId);
          removeReply(tempList);
          widget.commentReplyCallback();
          return;
        }
        ABToast.show(resultRecords.message ?? AB_S().deleteFailed, toastType: ToastType.fail);
      }
    }
  }

  removeReply(List replyIds) {
    replyList.removeWhere((item) {
      return replyIds.contains(item.replyId );
      // return item.replyId == replyId;
    });
    setState(() {});
  }

  toLike({bool isLike = true}) async {
    var resultRecords = await DynamicsNet.dynamicsLikePostsComments(commentsId: widget.comment.id ?? 0, isLike: isLike);
    if (resultRecords.success == true) {
      widget.comment.isLike = isLike;
      setState(() {});
      ABToast.show(isLike ? AB_S().likeSuccess : AB_S().cancelLikeSuccess, toastType: ToastType.success);
    } else {
      ABToast.show(resultRecords.message ?? (isLike ? AB_S().likeFailed : AB_S().cancelLikeFailed),
          toastType: ToastType.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    PostsDetailsCommentsRecords comment = widget.comment;
    final theme = AB_theme(context);
    DateTime? time = DateTime.tryParse(comment.createTime ?? '');
    return Column(
      children: [
        SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ABImage.avatarUser(comment.avatarUrl ?? '', height: 40.px, width: 40.px),
              ),
              SizedBox(width: 10.px),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ABText(comment.nickName ?? '', fontSize: 14.px, textColor: theme.text999).padding(top: 5.px),
                    Text(
                      (comment.content ?? ''),
                      style: TextStyle(
                        fontSize: 14.px,
                        color: theme.textColor,
                      ),
                    ).padding(top: 2.px),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        time == null
                            ? SizedBox()
                            : ABText(
                                time.year.toString() +
                                    AB_S().year +
                                    time.month.toString() +
                                    AB_S().month +
                                    time.day.toString() +
                                    AB_S().day,
                                fontSize: 12.px,
                                textColor: theme.text999,
                              ),
                        Row(
                          children: [
                            Builder(builder: (context) {
                              var myID = UserProvider.getCurrentUser().userId;
                              var commentMemberId = comment.memberId;
                              if (commentMemberId.toString() != myID) {
                                return SizedBox();
                              }
                              return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      deleteComment();
                                    },
                                    child: Image.asset(ABAssets.iconDelete(context), width: 16.px, height: 16.px)
                                        .padding(top: 2.px, bottom: 2.px, left: 10.px, right: 10.px),
                                  ),
                                  SizedBox(width: 8.px),
                                ],
                              );
                            }),
                            InkWell(
                              onTap: () {
                                toLike(isLike: comment.isLike == true ? false : true);
                              },
                              child: Image.asset(
                                      (comment.isLike == true)
                                          ? ABAssets.dynamicLikedIcon(context)
                                          : ABAssets.dynamicLikeIcon(context),
                                      width: 16.px,
                                      height: 16.px)
                                  .padding(top: 2.px, bottom: 2.px, left: 10.px, right: 10.px),
                            ),
                            SizedBox(width: 8.px),
                            InkWell(
                              onTap: () {
                                showReplyWidget(comment);
                              },
                              child: Image.asset(ABAssets.dynamicCommentIcon(context), width: 16.px, height: 16.px)
                                  .padding(top: 2.px, bottom: 2.px, left: 10.px, right: 10.px),
                            ),
                          ],
                        )
                      ],
                    ).padding(top: 5),
                    (replyList.isEmpty) ? SizedBox() : replyBuild(replyList)
                  ],
                ),
              )
            ],
          ),
        ),
        // DynamicCommentReplyWidget(postId: widget.postId, commentsId: comment.id??0,),
        Divider(
          height: 1,
          color: theme.f4f4f4,
        ).padding(top: 10.px, bottom: 10.px),
      ],
    );
  }

  Widget replyBuild(List<CommentsReplyListRecords>? commentsReplyList) {
    if (commentsReplyList == null) return SizedBox();
    final theme = AB_theme(context);
    List<Widget> buildList = [];
    for (var i = 0; i < commentsReplyList.length; i++) {
      CommentsReplyListRecords item = commentsReplyList[i];
      buildList.add(
        Padding(
          padding: EdgeInsets.only(
            top: 10.px,
          ),
          child: InkWell(
            onTap: () {
              handleItem(item);
            },
            child: SizedBox(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: (item.fromMemberNickName ?? ''),
                      style: TextStyle(
                        color: theme.textColor.withOpacity(0.6),
                        fontSize: 14.px,
                      ),
                    ),
                    TextSpan(
                      text: (item.type == 1 ? ' : ' : ' ${AB_S().reply} '),
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: 14.px,
                      ),
                    ),
                    if (item.type == 2)
                      TextSpan(
                        text: item.toMemberNickName,
                        style: TextStyle(
                          color: theme.textColor.withOpacity(0.6),
                          fontSize: 14.px,
                        ),
                      ),
                    if (item.type == 2)
                      TextSpan(
                        text: ' : ',
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 14.px,
                        ),
                      ),
                    TextSpan(
                      text: item.contentInfo,
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: 14.px,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 10.px,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.f4f4f4,
          borderRadius: BorderRadius.all(Radius.circular(6.px)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10.px, right: 8.px, top: 0.px, bottom: 10.px),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...buildList, moreWidget()],
            ),
          ),
        ),
      ),
    );
  }

  moreWidget() {
    if (hasMore) {
      return InkWell(
        onTap: () {
          onMore();
        },
        child: Padding(
          padding: EdgeInsets.only(top: 10.px),
          child: Center(
              child: ABText(
            AB_S().message,
            fontSize: 12.px,
            textColor: AB_theme(context).textGrey.withOpacity(0.6),
          )),
        ),
      );
    }
    return SizedBox();
  }
}

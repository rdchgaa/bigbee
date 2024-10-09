import 'dart:math';

import 'package:bee_chat/models/dynamic/posts_details_comments_model.dart';
import 'package:bee_chat/models/dynamic/posts_details_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dialog/bottom_select_dialog.dart';
import 'package:bee_chat/pages/dialog/comment_reply_dialog.dart';
import 'package:bee_chat/pages/dialog/help_posts_dialog.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_comment_reply_widget.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_event_bus.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../utils/ab_assets.dart';

class DynamicCommentWidget extends StatefulWidget {
  final int postId;
  final PostsDetailsModel? details;
  final List<PostsDetailsCommentsRecords> comments;

  final Function(int) onFresh; //刷新评论1：按时间，2：热度，3：评论数量

  const DynamicCommentWidget({
    super.key,
    this.details,
    required this.postId,
    required this.onFresh,
    required this.comments,
  });

  @override
  State<DynamicCommentWidget> createState() => _DynamicCommentWidgetState();
}

class _DynamicCommentWidgetState extends State<DynamicCommentWidget> {
  int sort = 1; //sort 1:时间 2:热度

  @override
  Widget build(BuildContext context) {
    print("DynamicCommentWidget build");
    final theme = AB_theme(context);
    // 动态列表item
    return DecoratedBox(
        decoration: BoxDecoration(
          color: theme.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0.px, right: 16.px),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 140.px,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  titleBuild(),
                  commentBuild(),
                ],
              ),
            ),
          ),
        )).addPadding(
      padding: EdgeInsets.only(top: 8.px),
    );
  }

  Widget titleBuild() {
    final theme = AB_theme(context);
    double paddingWidth = 16.px;
    return Padding(
      padding: EdgeInsets.only(top: 0.px, bottom: 16.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: paddingWidth, right: paddingWidth),
                    child: ABText(
                      AB_S().share,
                      fontSize: 16.px,
                      textColor: theme.text282109.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.text282109.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: SizedBox(
                      width: 20.px,
                      height: 20.px,
                      child: Center(
                        child: ABText(
                          (widget.details?.shareCount ?? 0).toString(),
                          overflow: TextOverflow.clip,
                          fontSize: 12.px,
                          textColor: theme.text282109,
                        ),
                      ),
                    ),
                  )
                ],
              ).padding(right: 26.px),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: paddingWidth, right: paddingWidth),
                    child: ABText(
                      AB_S().comment,
                      fontSize: 20.px,
                      textColor: theme.text282109,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Positioned(
                    top: 4.px,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.text282109.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: SizedBox(
                        width: 20.px,
                        height: 20.px,
                        child: Center(
                          child: ABText(
                            (widget.details?.commentCount ?? 0).toString(),
                            overflow: TextOverflow.clip,
                            fontSize: 12.px,
                            textColor: theme.text282109,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ).padding(right: 26.px),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: paddingWidth, right: paddingWidth),
                    child: ABText(
                      AB_S().like,
                      fontSize: 16.px,
                      textColor: theme.text282109.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.text282109.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: SizedBox(
                      width: 20.px,
                      height: 20.px,
                      child: Center(
                        child: ABText(
                          (widget.details?.likeCount ?? 0).toString(),
                          overflow: TextOverflow.clip,
                          fontSize: 12.px,
                          textColor: theme.text282109,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              var data = BottomSelectDialog.show(
                context,
                actions: [
                  BottomSelectDialogAction(
                      title: AB_S().byTime,
                      onTap: () async {
                        setState(() {
                          sort = 1;
                        });
                        widget.onFresh(1);
                      }),
                  BottomSelectDialogAction(
                      title: AB_S().byHeat,
                      onTap: () async {
                        setState(() {
                          sort = 2;
                        });
                        widget.onFresh(2);
                      })
                ],
                isShowCancel: true,
              );
            },
            child: Row(
              children: [
                ABText(
                  sort == 1 ? AB_S().byTime : AB_S().byHeat,
                  fontSize: 12.px,
                  textColor: theme.text999,
                ),
                SizedBox(
                  width: 8.px,
                ),
                Image.asset(
                  ABAssets.iconDown(context),
                  width: 15.px,
                  height: 9.px,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget commentBuild() {
    List<Widget> buildList = [];
    for (var i = 0; i < widget.comments.length; i++) {
      buildList.add(
        DynamicCommentReplyWidget(
            key: ValueKey(widget.comments[i].id),
            postId: widget.postId,
            details: widget.details,
            comment: widget.comments[i],
            removeCommentCallback: () {
              removeCommentItem(i);
              widget.onFresh(3);
            },
            commentReplyCallback: () {
              widget.onFresh(3);
            }),
      );
    }
    return Column(
      children: buildList,
    );
  }

  removeCommentItem(int index) {
    widget.comments.removeAt(index);
    setState(() {});
    ABEventBus.fire(PostCountEvent(postId: widget.postId));

  }
}

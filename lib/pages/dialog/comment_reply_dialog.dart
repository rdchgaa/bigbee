import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/dynamic/comments_reply_list_model.dart';
import 'package:bee_chat/models/dynamic/posts_details_comments_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';


Future showCommentReplyDialog(
    BuildContext context, {
required PostsDetailsCommentsRecords comment,
      CommentsReplyListRecords? reply,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DialogAlertCommentReplyBox(comment: comment,
        reply: reply,
      );
    },
  );
}

class DialogAlertCommentReplyBox extends StatefulWidget {
  final PostsDetailsCommentsRecords comment;
  final CommentsReplyListRecords? reply;
  const DialogAlertCommentReplyBox({
    Key? key, required this.comment, this.reply,
  }) : super(key: key);

  @override
  _DialogAlertCommentReplyBoxState createState() => _DialogAlertCommentReplyBoxState();
}

class _DialogAlertCommentReplyBoxState extends State<DialogAlertCommentReplyBox> {
  TextEditingController _textController = TextEditingController();

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
                  headWidget(),
                  inputWidget(),
                  commentItem(widget.comment),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commentItem(PostsDetailsCommentsRecords comment) {
    final theme = AB_theme(context);
    DateTime? time = DateTime.tryParse(comment.createTime ?? '');
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.f4f4f4
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.px,right: 16.px,top: 16.px,bottom: 16.px),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget inputWidget(){
    final theme = AB_theme(context);
    return Padding(
      padding: EdgeInsets.only(top: 5.px, bottom: 5.px,left: 5,right: 5),
      child: ExtendedTextField(
        controller: _textController,
        autofocus: true,
        maxLines: 4,
        minLines: 4,
        onChanged: (value) {
          setState(() {});
        },
        onTap: () {},
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.send,
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
            hintText: '${AB_S().reply} ${widget.reply==null?'':(widget.reply?.contentInfo??'')}'),
      ),
    );
  }
  Widget headWidget(){
    final theme = AB_theme(context);
    return Padding(
      padding: EdgeInsets.only(left: 16.0.px,right: 16.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Image.asset(
              ABAssets.toastFail(context),
              width: 22.px,
              height: 22.px,
              color: theme.text282109,
            ),
          ),
          ABButton(
            text: "${AB_getS(context).reply}",
            backgroundColor: (_textController.text.trim())==''?theme.textGrey:theme.primaryColor,
            cornerRadius: 6,
            height: 33.px,
            width: 68.px,
            textColor: theme.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            onPressed: () {
              if((_textController.text.trim())=='')return;
              Navigator.of(context).pop(_textController.text.trim());
            },
          ),
        ],
      ),
    );
  }


}
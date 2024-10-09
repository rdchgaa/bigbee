import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../models/im/notice_details_model.dart';
import '../../net/im_net.dart';

class NoticeDetailsPage extends StatefulWidget {
  final int noticeId;
  const NoticeDetailsPage({super.key, required this.noticeId});

  @override
  State<NoticeDetailsPage> createState() => _NoticeDetailsPageState();
}

class _NoticeDetailsPageState extends State<NoticeDetailsPage> {

  NoticeDetailsModel _model = NoticeDetailsModel();

  @override
  void initState() {
    _requestNoticeDetails();
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Text(
              _model.title ?? "",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 12,),
            // 时间
            Text(
              _model.createTime ?? "",
              style: TextStyle(
                fontSize: 12,
                color: theme.textGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18,),
            // // 封面
            // _model.imgUrl != null ?
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(6.0),
            //       child: ABImage.imageWithUrl(_model.imgUrl!, fit: BoxFit.cover, height: 150.px, width: double.infinity))
            //   : Container(),
            // const SizedBox(height: 18,),
            Html(
              data: _model.noticeContent ?? "",
              style: {
                "html": Style(
                  fontSize: FontSize(15),
                  color: theme.textColor,
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "body": Style(
                    padding: HtmlPaddings.all(0), margin: Margins.all(0)),
                "p": Style(
                    padding: HtmlPaddings.all(0),
                    margin: Margins.all(0), //这里的padding和margin,很关键
                    // fontSize: FontSize.rem(1.02),
                    color: theme.textColor,
                    fontWeight: FontWeight.w400),
                "p > b": Style(
                    padding: HtmlPaddings.all(0),
                    margin: Margins.all(0), //这里的padding和margin,很关键
                    // fontSize: FontSize.rem(1.02),
                    color: theme.textColor,
                    fontWeight: FontWeight.w600)
              },
            )
          ]
        )
      ).addPadding(padding: EdgeInsets.symmetric(horizontal: 16.0)),
    );
  }

  Future<void> _requestNoticeDetails() async {
    ABLoading.show();
    final result = await ImNet.noticeDetails(noticeId: widget.noticeId);
    ABLoading.dismiss();
    if (result.data != null) {
      setState(() {
        _model = result.data!;
      });
    }
  }
}

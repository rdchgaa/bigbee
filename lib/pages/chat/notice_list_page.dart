import 'package:bee_chat/pages/chat/vm/notice_list_vm.dart';
import 'package:bee_chat/pages/chat/widget/notice_system/notice_list_item.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../provider/theme_provider.dart';
import 'notice_details_page.dart';

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({super.key});

  @override
  State<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  late NoticeListVM _vm;

  @override
  void initState() {
    _vm = NoticeListVM();
    super.initState();
    _vm.refresh();
  }
  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return ChangeNotifierProvider(
      create: (_) => _vm,
      builder: (context, child) {
        var vm = context.watch<NoticeListVM>();
        return EasyRefresh(
          header: CustomizeBallPulseHeader(color: theme.primaryColor),
          onRefresh: () async {
            await _vm.refresh();
          },
          onLoad: _vm.hasMore ? () async {
            await _vm.loadMore();
          } : null,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final model = vm.resultList[index];
              return InkWell(
                onTap: () {
                  if (model.noticeId != null) {
                    ABRoute.push(NoticeDetailsPage(noticeId: model.noticeId!,));
                  }
                },
                child: NoticeListItem(model: model),
              );
            },
            itemCount: vm.resultList.length,
          ),
        );
      },
    );
  }
}

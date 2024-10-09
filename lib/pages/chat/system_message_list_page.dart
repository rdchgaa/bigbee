import 'package:bee_chat/models/im/system_message_model.dart';
import 'package:bee_chat/pages/chat/vm/notice_list_vm.dart';
import 'package:bee_chat/pages/chat/vm/system_message_vm.dart';
import 'package:bee_chat/pages/chat/widget/notice_system/notice_list_item.dart';
import 'package:bee_chat/pages/chat/widget/notice_system/system_msg_list_item.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../models/im/notice_list_model.dart';
import '../../net/im_net.dart';
import '../../utils/ab_route.dart';
import 'notice_details_page.dart';

class SystemMessageListPage extends StatefulWidget {
  final isShowNotice;
  const SystemMessageListPage({super.key, this.isShowNotice = false});

  @override
  State<SystemMessageListPage> createState() => _SystemMessageListPageState();
}

class _SystemMessageListPageState extends State<SystemMessageListPage> {
  late SystemMessageVm _vm;
  NoticeListModel? _notice;

  @override
  void initState() {
    _vm = SystemMessageVm();
    super.initState();
    _vm.refresh();
    if (widget.isShowNotice) {
      _requestNotice();
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return ChangeNotifierProvider(
      create: (_) => _vm,
      builder: (context, child) {
        var vm = context.watch<SystemMessageVm>();
        return EasyRefresh(
          header: CustomizeBallPulseHeader(color: theme.primaryColor),
          onRefresh: () async {
            await _vm.refresh();
            if (widget.isShowNotice) {
              await _requestNotice();
            }
          },
          onLoad: _vm.hasMore ? () async {
            await _vm.loadMore();
          } : null,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (widget.isShowNotice && _notice != null) {
                if (index == 0) {
                  return InkWell(
                    onTap: () {
                      if (_notice?.noticeId != null) {
                        ABRoute.push(NoticeDetailsPage(noticeId: _notice!.noticeId!,));
                      }
                    },
                      child: NoticeListItem(model: _notice!,));
                } else {
                  final model = vm.resultList[index - 1];
                  return SystemMsgListItem(model: model, onTap: (bool isAgree){
                    _agreeAction(model: model, isAgree: isAgree);
                  },
                    deleteCallback: () async {
                      final res = await ImNet.deleteMessage(messageId: model.messageId ?? 0);
                      if (res.code == 200) {
                        await _vm.deleteMessage(model.messageId ?? 0);
                      }
                    },
                  );
                }
              } else {
                final model = vm.resultList[index];
                return SystemMsgListItem(model: model, onTap: (bool isAgree){
                  _agreeAction(model: model, isAgree: isAgree);
                },);
              }
            },
            itemCount: vm.resultList.length + ((widget.isShowNotice && _notice != null) ? 1 : 0),
          ),
        );
      },
    );
  }

  Future<void> _requestNotice() async {
    final result = await ImNet.noticeList(page: 1, pageSize: 1);
    if (result.data?.records != null && result.data!.records.isNotEmpty) {
      _notice = result.data!.records.first;
      setState(() {});
    }
  }

  _agreeAction({required SystemMessageModel model, required bool isAgree}) async {
    ABLoading.show();
    await _vm.confirmMessage(model: model, isAgree: isAgree);
    ABLoading.dismiss();
  }

}

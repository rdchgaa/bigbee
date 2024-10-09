import 'package:bee_chat/main.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/dynamic/vm/dynamic_list_vm.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import 'dynamic_list_item.dart';

class DynamicMyListWidget extends StatefulWidget {
  final DynamicListType type;
  const DynamicMyListWidget({super.key, this.type = DynamicListType.all});

  @override
  State<DynamicMyListWidget> createState() => _DynamicMyListWidgetState();
}

class _DynamicMyListWidgetState extends State<DynamicMyListWidget> {

  late DynamicListVM _vm;

  @override
  void initState() {
    _vm = DynamicListVM(type: widget.type, isMine: true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _vm.refreshData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return ChangeNotifierProvider(
      create: (_) => _vm,
      builder: (context, child) {
        var vm = context.watch<DynamicListVM>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 16.px,),
                  Column(
                    children: [
                      const SizedBox().expanded(),
                      Text(AB_S().dynamic, style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold, fontSize: 20.px)),
                      SizedBox(height: 4.px,),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 4.px,),
                      (vm.totalCount > 0) ? Container(
                        width: 18.px,
                        height: 18.px,
                        decoration: BoxDecoration(
                          color: Color(0xFF212226).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(9.px),
                        ),
                        child: Text("${vm.totalCount}", style: TextStyle(color: theme.textColor, fontSize: 12.px), textAlign: TextAlign.center,),
                      ) : SizedBox(),
                      SizedBox().expanded(),
                    ],
                  )
                ],
              ),
            ),
            EasyRefresh(
              header: CustomizeBallPulseHeader(color: theme.primaryColor),
              onRefresh: () async {
                await _vm.refreshData();
              },
              onLoad: !vm.hasMore
                  ? null
                  : () async {
                await _vm.loadMore();
              },
              child: vm.resultList.isEmpty ? Center(
                child: Image.asset(ABAssets.emptyIcon(context)),
              ):ListView.builder(
                itemBuilder: (context, index) {
                  var item = vm.resultList[index];
                  return DynamicListItem(
                    key:ValueKey(item.postId),
                    model: item, showFollow: false, deleteCall: (){
                    vm.deletePost(item.postId.toString());
                  },);
                },
                itemCount: vm.resultList.length ,
              ),
            ).expanded(),
          ]
        );
      },
    );
  }

}

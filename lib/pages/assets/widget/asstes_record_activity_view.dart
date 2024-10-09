import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/funds_details_record_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/pages/assets/assets_add_coin_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/asstes_record_activity_item.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class AsstesRecordActivityView extends StatefulWidget {
  final int? coinId;
  final FlowType? flowType;
  const AsstesRecordActivityView({super.key, this.coinId, this.flowType});

  @override
  State<AsstesRecordActivityView> createState() =>
      _AsstesRecordActivityViewState();
}

class _AsstesRecordActivityViewState extends State<AsstesRecordActivityView>
    with AutomaticKeepAliveClientMixin {
  int _pageNum = 1;

  FlowType flowType = FlowType.all; // 0-全部，1-红包，2-打赏，3-邀请

  List<FundsDetailsRecordRecords> records = [];

  bool hasMore = true;

  @override
  void initState() {
    flowType = widget.flowType??FlowType.all;
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    _pageNum = 1;
    var typeVlue = 0;
    switch(flowType){

      case FlowType.all:
        typeVlue = 0;
      case FlowType.package:
        typeVlue = 1;
      case FlowType.reward:
        typeVlue = 2;
      case FlowType.invitation:
        typeVlue = 3;
    }
    final result =
        await AssetsNet.getActivityRecord(pageNum: _pageNum, flowType: getFlowTypeValue(flowType),coinId: widget.coinId);
    if (result.data != null) {
      records = result.data?.records ?? [];
    }
    if(records.length>= (result.data?.total??0)){
      hasMore = false;
    }else{
      hasMore = true;
    }
    if(mounted)setState(() {});
  }

  onLoad() async{
    _pageNum = _pageNum+1;
    final result =
        await AssetsNet.getActivityRecord(pageNum: _pageNum, flowType: getFlowTypeValue(flowType),coinId: widget.coinId);
    if (result.data != null) {
      records.addAll(result.data?.records ?? []);
    }
    if(records.length>= (result.data?.total??0)){
      hasMore = false;
    }
    setState(() {});

  }

  int getFlowTypeValue(FlowType flowType){
    var typeValue = 0;
    switch(flowType){

      case FlowType.all:
        typeValue = 0;
      case FlowType.package:
        typeValue = 1;
      case FlowType.reward:
        typeValue = 2;
      case FlowType.invitation:
        typeValue = 3;
    }
    return typeValue;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider =
        Provider.of<UserProvider>(MyApp.context, listen: false);
    final theme = AB_theme(context);

    List<Widget> flowList = [
      FlowType.all,
      FlowType.package,
      FlowType.reward,
      FlowType.invitation
    ].map((e) {
      return _getTypeWidget(context, e);
    }).toList();

    return Column(
      children: [
        if(widget.flowType==null)Padding(
          padding: EdgeInsets.only(left: 16.0.px, right: 16.px,bottom: 5.px),
          child: Row(
            children: [
              ...flowList,
            ],
          ),
        ),
        Expanded(child: recordsListView()),
      ],
    );
  }

  Widget _getTypeWidget(BuildContext context, FlowType type) {
    String title = "";
    final S = AB_getS(context);
    final theme = AB_theme(context);
    switch (type) {
      case FlowType.all:
        title = S.all;
        break;
      case FlowType.package:
        title = S.redEnvelope ;
        break;
      case FlowType.reward:
        title = S.reward;
        break;
      case FlowType.invitation:
        title = S.invitation;
        break;
    }

    return Padding(
      padding: EdgeInsets.only(right: 12.0.px),
      child: InkWell(
        onTap: () {
          flowType = type;
          setState(() {});
          initData();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: type == flowType ? theme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20.px),
          ),
          child: SizedBox(
            height: 32.px,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.px,
              ),
              child: ABText(
                title,
                textColor: theme.textColor,
                fontSize: 14.px,
                fontWeight:
                    type == flowType ? FontWeight.w600 : FontWeight.normal,
              ).center,
            ),
          ),
        ),
      ),
    );
  }

  Widget recordsListView() {
    final theme = AB_theme(context);
    return EasyRefresh(
      header: CustomizeBallPulseHeader(color: theme.primaryColor),
      onRefresh: () async {
        initData();
      },
      onLoad:!hasMore?null: () async {
        onLoad();
      },
      child: records.isEmpty?Container(
        alignment: Alignment.center,
        color: theme.backgroundColor,
        child: Image.asset(ABAssets.emptyIcon(context)),
      ):ListView.separated(
        // physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 18.px,bottom: 18.px),
        itemBuilder: (context, index) {
          return AsstesRecordActivityItem(record: records[index]);
        },
        itemCount: records.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 18.px,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///0-全部，1-红包，2-打赏，3-邀请
enum FlowType {
  // 全部
  all,
  // 红包
  package,
  // 打赏
  reward,
  // 邀请
  invitation,
}

import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/assets/payouts_address_list_model.dart';
import 'package:bee_chat/models/assets/payouts_set_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/assets/assets_language_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/assets_version_update_page.dart';
import 'package:bee_chat/pages/assets/assets_withdrawal_address_add_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/assets/widget/input_google_code_dialog.dart';
import 'package:bee_chat/pages/assets/widget/select_coin_dialog.dart';
import 'package:bee_chat/pages/common/share_user_page.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/pages/login_regist/start_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'dart:math' as math;

import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

class AssetsWithdrawalAddressPage extends StatefulWidget {
  const AssetsWithdrawalAddressPage({super.key});

  @override
  State<AssetsWithdrawalAddressPage> createState() => _AssetsWithdrawalAddressPageState();
}

class _AssetsWithdrawalAddressPageState extends State<AssetsWithdrawalAddressPage> {
  List<PayoutsAddressListRecords> listData = [];
  bool hasMore = true;
  int pageNum = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    // ABRoute.pageHistory.remove(AssetsWithdrawalAddressPage().routerName());
    super.dispose();
  }

  initData() async {
    pageNum = 1;
    setState(() {});
    var resultRecords = await AssetsNet.assetsPayoutsAddressList(pageNum: pageNum);
    if (resultRecords.data != null) {
      listData = resultRecords.data?.records ?? [];
      hasMore = (resultRecords.data!.total ?? 0) > listData.length;
      setState(() {});
    }
  }

  onLoad() async{
    pageNum += 1;
    setState(() {});
    var resultRecords = await AssetsNet.assetsPayoutsAddressList(pageNum: pageNum);
    if (resultRecords.data != null) {
      listData.addAll(resultRecords.data?.records ?? []);
      hasMore = (resultRecords.data!.total ?? 0) > listData.length;
      setState(() {});
    }
  }

  deleteAddress(int id,int index) async{
    var resultRecords = await AssetsNet.assetsCanCollectAddress(id: id);
    if (resultRecords.success != null) {
      listData.removeAt(index);
      setState(() {});
    }else{
      ABToast.show(resultRecords.message??AB_S().fail,toastType: ToastType.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return Scaffold(
      appBar: ABAppBar(
        navigationBarHeight: 60.px,
        backIconCenter: true,
        title: AB_getS(context).coinAddress,
        backgroundWidget: Container(
          // 渐变色
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                HexColor("#FFDC79"),
                HexColor("#FFCB32"),
              ],
            ),
          ),
        ),
        rightWidget: Padding(
          padding: EdgeInsets.only(right: 16.0.px),
          child: Center(
            child: Row(
              children: [
                InkWell(
                    onTap: () async {
                      await ABRoute.push(context: context, AssetsWithdrawalAddressAddPage());
                      initData();
                    },
                    child: ABText(
                      AB_S().add,
                      fontSize: 16.px,
                      textColor: theme.textColor,
                      fontWeight: FontWeight.w500,
                    ))
              ],
            ),
          ),
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: EasyRefresh(
        header: CustomizeBallPulseHeader(color: theme.primaryColor),
        onRefresh: () async {
          initData();
        },
        onLoad: !hasMore
            ? null
            : () async {
                onLoad();
              },
        child: listData.isEmpty
            ? Container(
                alignment: Alignment.center,
                color: theme.backgroundColor,
                child: Image.asset(ABAssets.emptyIcon(context)),
              )
            : ListView.separated(
                // physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 8.px, bottom: 18.px),
                itemBuilder: (context, index) {
                  return Slidable(
                      key: ValueKey(listData[index].id??0),
                      // Specify a key if the Slidable is dismissible.
                      endActionPane: ActionPane(
                        extentRatio: 0.3,
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            flex: 1,
                            onPressed: (slidCtx) {
                              deleteAddress(listData[index].id??0,index);
                            },
                            backgroundColor: Colors.redAccent,
                            foregroundColor: theme.white,
                            // icon: Icons.archive,
                            label: AB_getS(context).delete,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      child: AssetsWithdrawalAddressItem(item: listData[index],onEdit: () async{
                        await ABRoute.push(context: context, AssetsWithdrawalAddressAddPage(address: listData[index],));
                        initData();
                      },));
                },
                itemCount: listData.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 1.px,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0.px, right: 16.px),
                      child: Divider(
                        color: theme.textGrey.withOpacity(0.1),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class AssetsWithdrawalAddressItem extends StatefulWidget {
  final PayoutsAddressListRecords item;
  final Function onEdit;
  const AssetsWithdrawalAddressItem({super.key, required this.onEdit, required this.item});

  @override
  State<AssetsWithdrawalAddressItem> createState() => _AssetsWithdrawalAddressItemState();
}

class _AssetsWithdrawalAddressItemState extends State<AssetsWithdrawalAddressItem> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void dispose() {
    // ABRoute.pageHistory.remove(AssetsWithdrawalAddressPage().routerName());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.all(16.0.px),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ABText(
                  widget.item.addressRemark??'',
                  textColor: theme.textColor,
                  fontSize: 16.px,
                ),
                InkWell(
                  onTap: () async {
                    widget.onEdit();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.px),
                    child: Image.asset(
                      ABAssets.iconEdit(context),
                      width: 24.px,
                      height: 24.px,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ABText(
                  getCoinAddressSimple(widget.item.address??'',),
                  textColor: theme.textColor,
                  fontSize: 16.px,
                ),
                Builder(builder: (context) {
                  DateTime? date = DateTime.tryParse(widget.item.createTime??'');
                  if (date == null) return SizedBox();
                  return ABText(
                    '${date.year}-${date.month}-${date.day} ${singleTimeToString(date.hour)}:${singleTimeToString
                      (date.minute)}:${singleTimeToString(date.second)}',
                    textColor: theme.text999,
                    fontSize: 14.px,
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

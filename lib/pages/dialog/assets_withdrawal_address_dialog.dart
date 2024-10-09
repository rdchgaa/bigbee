import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/payouts_address_list_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/pages/assets/assets_withdrawal_address_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';


Future showAssetsWithdrawalAddressDialog(
    BuildContext context, ) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DialogAssetsWithdrawalAddressBox(
      );
    },
  );
}

class DialogAssetsWithdrawalAddressBox extends StatefulWidget {

  const DialogAssetsWithdrawalAddressBox({
    Key? key,
  }) : super(key: key);

  @override
  _DialogAssetsWithdrawalAddressBoxState createState() => _DialogAssetsWithdrawalAddressBoxState();
}

class _DialogAssetsWithdrawalAddressBoxState extends State<DialogAssetsWithdrawalAddressBox> {

  List<PayoutsAddressListRecords> listData = [];
  bool hasMore = true;
  int pageNum = 1;

  PayoutsAddressListRecords? selectData ;

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
    hasMore = false;
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.px),
                    child:ABText(
                      AB_S().selectCoinAddress,
                      textColor: theme.textColor,
                      fontSize: 18.px,
                    ),
                  ),
                  SizedBox(height: 5.px,),
                  coinListWidget(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ABButton.gradientColorButton(
                      colors: selectData!=null ? [theme.primaryColor, theme.secondaryColor] : [theme.text999, theme
                        .text999],
                      cornerRadius: 12,
                      height: 48,
                      text: AB_getS(context).confirmSelect,
                      textColor: theme.textColor,
                      onPressed: () async {
                        if(selectData==null) return;
                        Navigator.of(context).pop(selectData);
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget coinListWidget() {
    final theme = AB_theme(context);
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.width*0.9,
      child: EasyRefresh(
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
            bool isSelect = selectData?.id == listData[index].id;
            return SizedBox(
              child: InkWell(
                onTap: (){
                  selectData = listData[index];
                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0.px),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ABText(
                            listData[index].addressRemark??'',
                            textColor: theme.textColor,
                            fontSize: 16.px,
                          ),
                          SizedBox(height: 10.px),
                          ABText(
                            getCoinAddressSimple(listData[index].address??''),
                            textColor: theme.textColor,
                            fontSize: 16.px,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 2.px),
                        child: Image.asset(
                          isSelect
                              ? ABAssets.assetsSelect(context)
                              : ABAssets.assetsUnSelect(context),
                          width: 24.px,
                          height: 24.px,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
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
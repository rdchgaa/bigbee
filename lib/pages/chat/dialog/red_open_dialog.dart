import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/red_bag/is_receive_red_packet_model.dart';
import 'package:bee_chat/models/red_bag/split_red_packet_model.dart';
import 'package:bee_chat/net/red_net.dart';
import 'package:bee_chat/pages/chat/red_bag/red_bag_details_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future showRedOpenDialog(
  BuildContext context, {
  required int redPacketId,
  String? groupId,
      Function? onReceive,
      Function(int)? onReceiveState,

}) async {
  var resultRecords = await RedNet.redIsReceiveRedPacket(
    redPacketId: redPacketId,
  );
  int? state = 1; // 0, 未领取;1,已领取 ，2，已领完，3，已过期
  if (resultRecords.data != null) {
    state = resultRecords.data?.status;
  }
  onReceiveState?.call(state ?? 1);
  if (state == 0) {
    return showDialog(
      context: context,
      builder: (context) {
        return DialogAlertYearBox(redPacketId: redPacketId, groupId: groupId, onReceive: onReceive);
      },
    );
  } else {
    ABRoute.push(RedBagDetailsPage(redPacketId: redPacketId));
  }

  return null;
}

class DialogAlertYearBox extends StatefulWidget {
  final int redPacketId;
  final String? groupId;
  final Function? onReceive;

  const DialogAlertYearBox({
    super.key,
    required this.redPacketId,
    this.groupId,
    this.onReceive,
  });

  @override
  _DialogAlertYearBoxState createState() => _DialogAlertYearBoxState();
}

class _DialogAlertYearBoxState extends State<DialogAlertYearBox> {
  SplitRedPacketModel? caiRed;

  bool isLing = false;

  double? lingNum;
  String? coinName;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    ABLoading.show();
    var resultRecords = await RedNet.redSplitRedPacket(
      redPacketId: widget.redPacketId,
    );
    ABLoading.dismiss();
    if (resultRecords.data != null) {
      caiRed = resultRecords.data;
      setState(() {});
    }
  }

  lingRed() async {
    ABLoading.show();
    try {
      if (widget.groupId != null) {
        ABLoading.show();
        //群聊
        var resultRecords =
            await RedNet.redReceiveGroupRedPacket(redPacketId: widget.redPacketId, groupId: widget.groupId!);
        ABLoading.dismiss();
        if (resultRecords.success == true) {
          lingNum = resultRecords.data?.receiveQty;
          coinName = resultRecords.data?.coinName;
          isLing = true;
          setState(() {});
          widget.onReceive == null ? null : widget.onReceive!();
        }else{
          ABToast.show(resultRecords.message??AB_S().fail);
        }
      } else {
        ABLoading.show();
        var resultRecords = await RedNet.redReceiveSingleRedPacket(
          redPacketId: widget.redPacketId,
        );
        ABLoading.dismiss();
        if (resultRecords.success == true) {
          lingNum = resultRecords.data?.receiveQty;
          coinName = resultRecords.data?.coinName;
          isLing = true;
          setState(() {});
          widget.onReceive == null ? null : widget.onReceive!();
        }
      }
    } catch (e) {
      ABLoading.dismiss();
    }
    ABLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLing) {
      return caiRedView();
    } else {
      return lingedView();
    }
  }

  caiRedView() {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12.px)),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: InkWell(
              onTap: () {},
              child: DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          ABAssets.redCai1(context),
                        ),
                        fit: BoxFit.fill)),
                child: SizedBox(
                  width: 347.px,
                  height: 345.px,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 94.px),
                        child: SizedBox(
                          width: 68.px,
                          height: 68.px,
                          child: caiRed == null
                              ? SizedBox()
                              : DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    borderRadius: BorderRadius.circular(68.px / 2),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(2.px),
                                    child: SizedBox(
                                      width: 64.px,
                                      height: 64.px,
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(64 / 2),
                                            child: ABImage.imageWithUrl(caiRed?.avatarUrl ?? '',
                                                fit: BoxFit.cover, width: 68.px, height: 68.px)),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 230.px,
                        height: 24.px,
                        child: caiRed == null
                            ? SizedBox()
                            : Center(
                                child: ABText(
                                  (caiRed?.nickName ?? '') + (isZh ? '-发出的红包' : '- Red envelope issued'),
                                  textColor: theme.white,
                                  fontSize: 12.px,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 15.px,
                      ),
                      caiRed == null
                          ? SizedBox(
                              width: 83.px,
                              height: 83.px,
                            )
                          : InkWell(
                              onTap: () {
                                lingRed();
                              },
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          ABAssets.redLing(context),
                                        ),
                                        fit: BoxFit.fill)),
                                child: SizedBox(
                                  width: 83.px,
                                  height: 83.px,
                                  child: Center(
                                    child: ABText(
                                      isZh ? '领' : "GET",
                                      textColor: theme.textColor,
                                      fontSize: 36.px,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      // SizedBox(height: 10.px,),
                      Expanded(
                        child: SizedBox(
                          width: 230.px,
                          child: Center(
                            child: Text(
                              caiRed?.title ?? '',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: theme.primaryColor, fontSize: 18.px, fontWeight: FontWeight.w600, height: 1.1),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  lingedView() {
    final theme = AB_theme(context);
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12.px)),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: InkWell(
              onTap: () {},
              child: DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          ABAssets.redCai2(context),
                        ),
                        fit: BoxFit.fill)),
                child: SizedBox(
                  width: 251.px,
                  height: 359.26.px,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 106.px),
                        child: SizedBox(
                          width: 68.px,
                          height: 68.px,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(68.px / 2),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2.px),
                              child: SizedBox(
                                width: 64.px,
                                height: 64.px,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(64 / 2),
                                      child: ABImage.imageWithUrl(caiRed?.avatarUrl ?? '',
                                          fit: BoxFit.cover, width: 68.px, height: 68.px)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 230.px,
                        height: 24.px,
                        child: Center(
                          child: ABText(
                            (caiRed?.nickName ?? '') + (isZh ? '-发出的红包' : '- Red envelope issued'),
                            textColor: theme.white,
                            fontSize: 12.px,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 28.px,
                      ),
                      Text(
                        isZh ? "成功领取" : "Successfully Claimed",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.primaryColor, fontSize: 18.px, fontWeight: FontWeight.w600, height: 1.1),
                      ),
                      SizedBox(
                        height: 9.px,
                      ),
                      Text(
                        lingNum.toString() + (coinName ?? ''),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.primaryColor, fontSize: 24.px, fontWeight: FontWeight.w600, height: 1.1),
                      ),
                      Spacer(),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            ABRoute.push(RedBagDetailsPage(redPacketId: widget.redPacketId));
                          },
                          child: SizedBox(
                            width: 100.px,
                            height: 20.px,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  isZh ? "查看详情" : "View Details",
                                  style: TextStyle(
                                    color: theme.white,
                                    fontSize: 12.px,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.px),
                                  child: Image.asset(
                                    ABAssets.assetsRight(context),
                                    width: 9.px,
                                    height: 14.px,
                                    color: theme.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.px)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

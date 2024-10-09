import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/funds_details_record_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/pages/assets/assets_add_coin_page.dart';
import 'package:bee_chat/pages/assets/assets_record_page.dart';
import 'package:bee_chat/pages/assets/widget/assets_custody_wallet_assets_item.dart';
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
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AsstesRecordActivityItem extends StatefulWidget {
  final FundsDetailsRecordRecords record;

  const AsstesRecordActivityItem({super.key, required this.record});

  @override
  State<AsstesRecordActivityItem> createState() =>
      _AsstesRecordActivityItemState();
}

class _AsstesRecordActivityItemState extends State<AsstesRecordActivityItem> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {}

  @override
  Widget build(BuildContext context) {
    UserProvider provider =
        Provider.of<UserProvider>(MyApp.context, listen: false);
    final theme = AB_theme(context);

    DateTime time = DateTime.tryParse(widget.record.time??'')??DateTime.now();
    return Padding(
      padding: EdgeInsets.only(left: 16.0.px, right: 16.px),
      child: Row(
        children: [
          SizedBox(
            width: 83.px - 16.px,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ABText(
                  singleTimeToString(time.day),
                  textColor: theme.textColor,
                  fontSize: 18.px,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: 4.px,
                ),
                ABText(
                  '${time.year}.' + singleTimeToString(time.month),
                  textColor: theme.text999,
                  fontSize: 14.px,
                )
              ],
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: theme.white,
                  borderRadius: BorderRadius.all(Radius.circular(6.px))),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16.px,
                      bottom: 18.px,
                      left: 14.px,
                    ),
                    child: Column(
                      children: [
                        ///类型
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.0.px),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Builder(builder: (context) {
                                var text = '';
                                if (widget.record.flowType == 0) {
                                  text = AB_getS(context).redEnvelope;
                                } else if (widget.record.flowType == 1) {
                                  text = AB_getS(context).dynamicTipping;
                                } else if (widget.record.flowType == 2) {
                                  text = AB_getS(context).inviteNewUsers;
                                } else if (widget.record.flowType == 3) {
                                  text = AB_getS(context).newUserRegistration;
                                }
                                return ABText(
                                  text,
                                  textColor: theme.appbarTextColor,
                                  fontSize: 16.px,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0.px),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color:
                                          theme.primaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6.px))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 4.px,
                                        bottom: 4.px,
                                        left: 8.px,
                                        right: 8.px),
                                    child: ABText(
                                      singleTimeToString(time.hour) +
                                          '.' +
                                          singleTimeToString(time.minute) +
                                          '.' +
                                          singleTimeToString(time.second),
                                      textColor:
                                          theme.secondaryColor.withOpacity(0.5),
                                      fontSize: 12.px,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///领取红包
                        if (widget.record.flowType == 0)
                          Column(
                            children: [
                              //领取红包
                              if(widget.record.operationDir=='add')Padding(
                                padding:
                                    EdgeInsets.only(top: 14.0.px, right: 14.px),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ABText(
                                      AB_getS(context).getRed,
                                      textColor: theme.text999,
                                      fontSize: 12.px,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0.px),
                                      child: ABText(
                                        '${amountToString(widget.record.amount??0, widget.record.operationDir)}',
                                        textColor: theme.textColor,
                                        fontSize: 14.px,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //发送红包
                              if(widget.record.operationDir=='sub')Padding(
                                padding:
                                EdgeInsets.only(top: 14.0.px, right: 14.px),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ABText(
                                      AB_getS(context).sendRed,
                                      textColor: theme.text999,
                                      fontSize: 12.px,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0.px),
                                      child: ABText(
                                        '${amountToString(widget.record.amount??0, widget.record.operationDir)}',
                                        textColor: theme.textColor,
                                        fontSize: 14.px,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //发送给 红包来源
                              if(widget.record.avatarUrl!=null||widget.record.nickName!=null)Padding(
                                padding:
                                EdgeInsets.only(top: 14.0.px, right: 14.px),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 0.0.px),
                                      child: ABText(
                                        widget.record.operationDir=='add'?AB_S().redSource:AB_S().sendTo,
                                        textColor: theme.text999,
                                        fontSize: 12.px,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                      if(widget.record.avatarUrl!=null)SizedBox(
                                          width: 24.px,
                                          height: 24.px,
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: ABImage.imageWithUrl(
                                                    widget.record.avatarUrl??'',
                                                    fit: BoxFit.cover,
                                                    width: 24.px,
                                                    height: 24.px)),
                                          ),
                                        ),
                                        if(widget.record.nickName!=null)Padding(
                                          padding: EdgeInsets.only(left: 8.0.px),
                                          child: ABText(
                                            widget.record.nickName??'',
                                            textColor: theme.text999,
                                            fontSize: 14.px,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //退回金额
                              if(widget.record.refundQty!=null&&widget.record.refundQty!>0)Padding(
                                padding:
                                EdgeInsets.only(top: 14.0.px, right: 14.px),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ABText(
                                      AB_getS(context).refundAmount,
                                      textColor: theme.text999,
                                      fontSize: 12.px,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0.px),
                                      child: ABText(
                                        amountToString(widget.record.refundQty??0, 'add'),
                                        textColor: theme.textColor,
                                        fontSize: 14.px,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ///打赏
                        if (widget.record.flowType == 1)
                          Column(
                            children: [
                              // 被打赏数额
                              if(widget.record.operationDir=='add')Padding(
                                padding:
                                EdgeInsets.only(top: 14.0.px, right: 14.px),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ABText(
                                      AB_getS(context).amountRewardReceived,
                                      textColor: theme.text999,
                                      fontSize: 12.px,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0.px),
                                      child: ABText(
                                        '${amountToString(widget.record.amount??0, widget.record.operationDir)}',
                                        textColor: theme.textColor,
                                        fontSize: 14.px,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //打赏数额
                              if(widget.record.operationDir=='sub')Padding(
                                padding:
                                EdgeInsets.only(top: 14.0.px, right: 14.px),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ABText(
                                      AB_getS(context).rewardAmount,
                                      textColor: theme.text999,
                                      fontSize: 12.px,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0.px),
                                      child: ABText(
                                        '${amountToString(widget.record.amount??0, widget.record.operationDir)}',
                                        textColor: theme.textColor,
                                        fontSize: 14.px,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //发送给 打赏来源
                              if(widget.record.avatarUrl!=null||widget.record.nickName!=null)Padding(
                                padding:
                                EdgeInsets.only(top: 14.0.px, right: 14.px),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 0.0.px),
                                      child: ABText(
                                        widget.record.operationDir=='add'?AB_S().giver:AB_S().rewardTo,
                                        textColor: theme.text999,
                                        fontSize: 12.px,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if(widget.record.avatarUrl!=null)SizedBox(
                                          width: 24.px,
                                          height: 24.px,
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: ABImage.imageWithUrl(
                                                    widget.record.avatarUrl??'',
                                                    fit: BoxFit.cover,
                                                    width: 24.px,
                                                    height: 24.px)),
                                          ),
                                        ),
                                        if(widget.record.nickName!=null)Padding(
                                          padding: EdgeInsets.only(left: 8.0.px),
                                          child: ABText(
                                            widget.record.nickName??'',
                                            textColor: theme.text999,
                                            fontSize: 14.px,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ///邀請
                        if (widget.record.flowType == 2)
                          Padding(
                            padding:
                                EdgeInsets.only(top: 14.0.px, right: 14.px),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ABText(
                                  AB_getS(context).invitationRewards,
                                  textColor: theme.text999,
                                  fontSize: 12.px,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0.px),
                                  child: ABText(
                                    amountToString(widget.record.amount??0, widget.record.operationDir),
                                    textColor: theme.text999,
                                    fontSize: 14.px,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ///邀请  受邀用户
                        if (widget.record.flowType == 2)
                          Padding(
                            padding:
                                EdgeInsets.only(top: 14.0.px, right: 14.px),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ABText(
                                  AB_getS(context).invitedUsers,
                                  textColor: theme.text999,
                                  fontSize: 12.px,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24.px,
                                      height: 24.px,
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: ABImage.imageWithUrl(
                                                widget.record.avatarUrl??'',
                                                fit: BoxFit.cover,
                                                width: 24.px,
                                                height: 24.px)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.0.px),
                                      child: ABText(
                                        widget.record.nickName??'',
                                        textColor: theme.textColor,
                                        fontSize: 14.px,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ///注册
                        if (widget.record.flowType == 3)
                          Padding(
                            padding:
                                EdgeInsets.only(top: 14.0.px, right: 14.px),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ABText(
                                  AB_getS(context).registrationRewards,
                                  textColor: theme.text999,
                                  fontSize: 12.px,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0.px),
                                  child: ABText(
                                    amountToString(widget.record.amount??0, widget.record.operationDir),
                                    textColor: theme.textColor,
                                    fontSize: 14.px,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  ///flowType == 0
                  if (widget.record.flowType == 0) stateIcon()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
/////（仅红包）状态：1，待领取；2，领取中；3，已领取；4，已退回
///（仅红包）：0-未领取；1-已领取；2-已退回；3-部分退回
  Widget stateIcon() {
    var color = Color(0x00ffffff);
    var text = '';
    if(widget.record.status==1||widget.record.status==02){//未领取
      color = Color(0xff3EB8B8);
      text = AB_S().waiteGet;
    }else if(widget.record.status==3){//已领取
      color = Color(0xff2FE900);
      text = AB_S().alreadyGet;
    }else if(widget.record.status==4){//已退回
      color = Color(0xffFF0000);
      text = AB_S().alreadyBack;
    }else if(widget.record.status==5){//部分退回
      color = Color(0xffFF0000);
      text = AB_S().partialReturn;
    }

    return Positioned(
      top: 0,
      right: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.px),
                topRight: Radius.circular(10.px))),
        child: Padding(
          padding: EdgeInsets.only(
              left: 12.px, right: 12.px),
          child: SizedBox(
            height: 32.px,
            child: Center(
              child: ABText(
                text,
                textColor: color,
                fontSize: 12.px,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }


  String amountToString(double amount, String? operationDir) {
    var value = amount.toString();
    if (operationDir == "sub") {
      value = (-amount).toString();
    }
    if (operationDir == "add" && amount > 0) {
      value = "+$value";
    }
    return value;
  }
}

///1-红包，2-打赏，3-邀请,4-注册
enum RecordFlowType {
  // 红包
  package,
  // 打赏
  reward,
  // 邀请
  invitation,
  // 注册
  register
}

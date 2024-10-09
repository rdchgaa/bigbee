import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_record_plus/utils/common_toast.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_wide_modal_operation_key.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/toast_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_history_message_list_item.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKItMessageList/tim_uikit_chat_message_tooltip.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/tim_uikit_chat.dart';

import 'package:tencent_cloud_chat_uikit/ui/widgets/forward_message_screen.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/wide_popup.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

import '../../utils/message.dart';

class MultiSelectPanel extends TIMUIKitStatelessWidget {
  final ConvType conversationType;
  // 收藏按钮点击回调
  final MessageCollectFunction? collectionCallback;

  MultiSelectPanel({Key? key, required this.conversationType, this.collectionCallback})
      : super(key: key);
  bool _checkIsCanForward(BuildContext context, TUIChatSeparateViewModel model) {
    bool hasNotCanForwardMsg = false;
    for (var message in model.multiSelectedMessageList) {
      if (!MessageUtils.isMessageCanForward(message: message)) {
        hasNotCanForwardMsg = true;
        break;
      }
    }
    if (hasNotCanForwardMsg) {
      final title = TIM_getCurrentDeviceLocale().contains("zh") ? "消息不支持转发！" : "Messages do not support forwarding!";
      // CommonToast.showView(msg: title, context: context);
      ToastUtils.showToast(msg: title, context: context);
      return false;
    }
    return true;
  }

  _handleForwardMessage(BuildContext context, bool isMergerForward,
      TUIChatSeparateViewModel model) {
    bool hasUnSendMsg = false;
    for (var message in model.multiSelectedMessageList) {
      if (message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL || message.status == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL) {
        hasUnSendMsg = true;
        break;
      }
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForwardMessageScreen(
              model: model,
              isMergerForward: isMergerForward,
              conversationType: conversationType,
            )));
  }

  _handleCollectMessage(BuildContext context,
      TUIChatSeparateViewModel model) async {
    if (model.multiSelectedMessageList.isEmpty) {
      return;
    }
    if (collectionCallback != null) {
      final isSuccess = await collectionCallback!(model.multiSelectedMessageList);
      if (isSuccess) {
        model.updateMultiSelectStatus(false);
      }
    } else {
      model.updateMultiSelectStatus(false);
    }
  }

  _handleForwardMessageWide(BuildContext context, bool isMergerForward,
      TUIChatSeparateViewModel model) {
    TUIKitWidePopup.showPopupWindow(
        operationKey: TUIKitWideModalOperationKey.forward,
        context: context,
        isDarkBackground: false,
        title: TIM_t("转发"),
        submitWidget: Text(TIM_t("发送")),
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.8,
        onSubmit: (){
          forwardMessageScreenKey.currentState?.handleForwardMessage();
        },
        child: (onClose) => Container(
          padding: const EdgeInsets.symmetric( horizontal: 10),
          child: ForwardMessageScreen(
            model: model,
            key: forwardMessageScreenKey,
            onClose: onClose,
            isMergerForward: isMergerForward,
            conversationType: conversationType,
          ),
        )
    );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final TUIChatSeparateViewModel model =
        Provider.of<TUIChatSeparateViewModel>(context);
    final bottom = MediaQuery.of(context).padding.bottom;
    return TUIKitScreenUtils.getDeviceWidget(
      context: context,
      // desktopWidget: Container(
      //   decoration: BoxDecoration(
      //     color: theme.selectPanelBgColor ?? theme.primaryColor,
      //     border: Border(
      //       top: BorderSide(
      //         color: theme.weakDividerColor ?? Colors.grey,
      //         width: 1.0,
      //       ),
      //     ),
      //   ),
      //   padding: const EdgeInsets.symmetric(vertical: 32),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Expanded(
      //           child: Wrap(
      //             crossAxisAlignment: WrapCrossAlignment.center,
      //         alignment: WrapAlignment.center,
      //         spacing: 64,
      //         children: [
      //           Column(
      //             children: [
      //               IconButton(
      //                 icon: Image.asset('images/forward.png',
      //                     package: 'tencent_cloud_chat_uikit',
      //                     color: theme.selectPanelTextIconColor),
      //                 iconSize: 30,
      //                 onPressed: () {
      //                   _handleForwardMessageWide(context, false, model);
      //                 },
      //               ),
      //               Text(TIM_t("逐条转发"),
      //                   style: TextStyle(
      //                       color: hexToColor("646a73"), fontSize: 12))
      //             ],
      //           ),
      //           Column(
      //             children: [
      //               IconButton(
      //                 icon: Image.asset('images/merge_forward.png',
      //                     package: 'tencent_cloud_chat_uikit',
      //                     color: theme.selectPanelTextIconColor),
      //                 iconSize: 30,
      //                 onPressed: () {
      //                   _handleForwardMessageWide(context, true, model);
      //                 },
      //               ),
      //               Text(
      //                 TIM_t("合并转发"),
      //                 style:
      //                     TextStyle(color: theme.selectPanelTextIconColor, fontSize: 12),
      //               )
      //             ],
      //           ),
      //           Column(
      //             children: [
      //               IconButton(
      //                 icon: Image.asset('images/delete.png',
      //                     package: 'tencent_cloud_chat_uikit',
      //                     color: theme.selectPanelTextIconColor),
      //                 iconSize: 30,
      //                 onPressed: () {
      //                   // TUIKitWidePopup.showSecondaryConfirmDialog(
      //                   //     operationKey: TUIKitWideModalOperationKey.confirmDeleteMessages,
      //                   //     context: context,
      //                   //     text: TIM_t("确定删除已选消息"),
      //                   //     theme: theme,
      //                   //     onCancel: () {},
      //                   //     onConfirm: () async {
      //                   //       model.deleteSelectedMsg();
      //                   //       model.updateMultiSelectStatus(false);
      //                   //     });
      //                   showCupertinoModalPopup<String>(
      //                     context: context,
      //                     builder: (BuildContext context) {
      //                       return CupertinoActionSheet(
      //                         cancelButton: CupertinoActionSheetAction(
      //                           onPressed: () {
      //                             Navigator.pop(
      //                               context,
      //                               "cancel",
      //                             );
      //                           },
      //                           child: Text(TIM_t("取消")),
      //                           isDefaultAction: false,
      //                         ),
      //                         actions: [
      //                           CupertinoActionSheetAction(
      //                             onPressed: () {
      //                               model.deleteSelectedMsg(true);
      //                               model.updateMultiSelectStatus(false);
      //                               Navigator.pop(
      //                                 context,
      //                                 "cancel",
      //                               );
      //                             },
      //                             child: Text(
      //                               (TIM_getCurrentDeviceLocale().contains("zh") ? "同时删除对方" : "Delete each other at the same time"),
      //                               style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
      //                             ),
      //                             isDefaultAction: false,
      //                           ),
      //                           CupertinoActionSheetAction(
      //                             onPressed: () {
      //                               model.deleteSelectedMsg(false);
      //                               model.updateMultiSelectStatus(false);
      //                               Navigator.pop(
      //                                 context,
      //                                 "cancel",
      //                               );
      //                             },
      //                             child: Text(
      //                               (TIM_getCurrentDeviceLocale().contains("zh") ? "只删除自己" : "Delete only myself"),
      //                               style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600),
      //                             ),
      //                             isDefaultAction: false,
      //                           )
      //                         ],
      //                       );
      //                     },
      //                   );
      //
      //
      //                 },
      //               ),
      //               Text(TIM_t("删除"),
      //                   style: TextStyle(
      //                       color: theme.selectPanelTextIconColor, fontSize: 12))
      //             ],
      //           ),
      //           InkWell(
      //             onTap: (){
      //               model.updateMultiSelectStatus(false);
      //             },
      //             child: Icon(Icons.close, color: theme.darkTextColor,),
      //           )
      //         ],
      //       ))
      //     ],
      //   ),
      // ),
      defaultWidget: Container(
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: theme.weakDividerColor ??
                      CommonColor.weakDividerColor)),
          color: theme.selectPanelBgColor ?? theme.primaryColor,
        ),
        padding: EdgeInsets.only(top: 12, bottom: bottom + 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Column(
                //   children: [
                //     IconButton(
                //       icon: Image.asset('images/forward.png',
                //           package: 'tencent_cloud_chat_uikit', color: theme.selectPanelTextIconColor, width: 24, height: 24),
                //       iconSize: 40,
                //       onPressed: () {
                //         _handleForwardMessage(context, false, model);
                //       },
                //     ),
                //     Text(TIM_t("逐条转发"),
                //         style: TextStyle(color: theme.selectPanelTextIconColor, fontSize: 12))
                //   ],
                // ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('images/merge_forward.png',
                          package: 'tencent_cloud_chat_uikit', color: theme.selectPanelTextIconColor, width: 24, height: 24),
                      iconSize: 40,
                      onPressed: () {
                        if (!_checkIsCanForward(context, model)) {return;}
                        showCupertinoModalPopup<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    "cancel",
                                  );
                                },
                                child: Text(TIM_t("取消")),
                                isDefaultAction: false,
                              ),
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      "cancel",
                                    );
                                  },
                                  child: Text(
                                    TIM_t("逐条转发"),
                                    style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  isDefaultAction: false,
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      "cancel",
                                    );
                                    if (_checkIsCanForward(context, model)) {
                                      _handleForwardMessage(context, true, model);
                                    }
                                  },
                                  child: Text(
                                    TIM_t("合并转发"),
                                    style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  isDefaultAction: false,
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                    Text(
                      TIM_t("转发"),
                      style: TextStyle(color: theme.selectPanelTextIconColor, fontSize: 12),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('images/collect.png',
                          package: 'tencent_cloud_chat_uikit', color: theme.selectPanelTextIconColor, width: 24, height: 24),
                      iconSize: 40,
                      onPressed: () {
                        _handleCollectMessage(context, model);
                      },
                    ),
                    Text(
                      TIM_getCurrentDeviceLocale().contains("zh") ? "收藏" : "Collection",
                      style: TextStyle(color: theme.selectPanelTextIconColor, fontSize: 12),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset('images/delete.png',
                          package: 'tencent_cloud_chat_uikit', color: theme.selectPanelTextIconColor, width: 24, height: 24),
                      iconSize: 40,
                      onPressed: () {
                        showCupertinoModalPopup<String>(
                          context: context,
                          builder: (BuildContext context) {
                            bool isHasOther = false;
                            for (var item in model.multiSelectedMessageList) {
                              if (item.isSelf != true) {
                                isHasOther = true;
                                break;
                              }
                            }
                            return CupertinoActionSheet(
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    "cancel",
                                  );
                                },
                                child: Text(TIM_t("取消")),
                                isDefaultAction: false,
                              ),
                              actions: [
                                if (!isHasOther || model.groupInfo?.isManager == true) CupertinoActionSheetAction(
                                  onPressed: () {
                                    model.deleteSelectedMsg(true);
                                    model.updateMultiSelectStatus(false);
                                    Navigator.pop(
                                      context,
                                      "cancel",
                                    );
                                  },
                                  child: Text(
                                    (TIM_getCurrentDeviceLocale().contains("zh") ? "同时删除对方" : "Delete each other at the same time"),
                                    style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  isDefaultAction: false,
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    model.deleteSelectedMsg(false);
                                    model.updateMultiSelectStatus(false);
                                    Navigator.pop(
                                      context,
                                      "cancel",
                                    );
                                  },
                                  child: Text(
                                    (TIM_getCurrentDeviceLocale().contains("zh") ? "只删除自己" : "Delete only myself"),
                                    style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  isDefaultAction: false,
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                    Text(TIM_t("删除"),
                        style: TextStyle(color: theme.selectPanelTextIconColor, fontSize: 12))
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                model.updateMultiSelectStatus(false);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close, color: theme.selectPanelTextIconColor),
                    // SizedBox(width: 8),
                    Text(TIM_t("取消"), style: TextStyle(color: theme.selectPanelTextIconColor, fontSize: 14))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

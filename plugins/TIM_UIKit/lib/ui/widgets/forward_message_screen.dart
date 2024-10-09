import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_self_info_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/recent_conversation_list.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

import '../views/common/tim_ab_app_bar.dart';
import '../views/common/tim_ab_button.dart';

GlobalKey<_ForwardMessageScreenState> forwardMessageScreenKey = GlobalKey();

class ForwardMessageScreen extends StatefulWidget {
  final bool isMergerForward;
  final ConvType conversationType;
  final TUIChatSeparateViewModel model;
  final VoidCallback? onClose;
  final bool? onlySelect;

  const ForwardMessageScreen(
      {Key? key,
      this.isMergerForward = false,
      required this.conversationType,
      required this.model,
      this.onClose, this.onlySelect})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForwardMessageScreenState();
}

class _ForwardMessageScreenState extends TIMUIKitState<ForwardMessageScreen> {
  final TUIChatGlobalModel model = serviceLocator<TUIChatGlobalModel>();
  final TUISelfInfoViewModel _selfInfoViewModel =
      serviceLocator<TUISelfInfoViewModel>();
  List<V2TimConversation> _conversationList = [];
  bool isMultiSelect = false;

  String _getMergerMessageTitle() {
    if (widget.conversationType == ConvType.c2c) {
      final option1 = (_selfInfoViewModel.loginInfo?.nickName != null &&
              _selfInfoViewModel.loginInfo!.nickName!.isNotEmpty)
          ? _selfInfoViewModel.loginInfo?.nickName
          : _selfInfoViewModel.loginInfo?.userID;
      // Chat History for xx
      return TIM_t_para("{{option1}}的聊天记录", "$option1的聊天记录")(option1: option1);
    } else {
      return TIM_t("群聊的聊天记录");
    }
  }

  List<String> _getAbstractList() {
    return widget.model.multiSelectedMessageList.map((e) {
      final sender = (e.nickName != null && e.nickName!.isNotEmpty)
          ? e.nickName
          : e.sender;
      return "$sender: ${model.abstractMessageBuilder != null ? model.abstractMessageBuilder!(e) : MessageUtils.getAbstractMessageAsync(e, [])}";
    }).toList();
  }

  handleForwardMessage() async {
    if(widget.onlySelect == true){
      Navigator.pop(context, _conversationList);
      return;
    }
    if (widget.isMergerForward) {
      await widget.model.sendMergerMessage(
        conversationList: _conversationList,
        title: _getMergerMessageTitle(),
        abstractList: _getAbstractList(),
        context: context,
      );
    } else {
      await widget.model
          .sendForwardMessage(conversationList: _conversationList);
    }
    widget.model.updateMultiSelectStatus(false);

    if (widget.onClose != null) {
      // widget.onClose!();
    } else {
      Navigator.pop(context);
    }
  }

  setMultiSelectStatus(bool status) {
    widget.model.updateMultiSelectStatus(status);
  }


  @override
  void dispose() {
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.model.updateMultiSelectStatus(false);
    });
    super.dispose();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final TUITheme theme = value.theme;
    if (isDesktopScreen) {
      isMultiSelect = true;
      return RecentForwardList(
        isMultiSelect: isMultiSelect,
        onChanged: (conversationList) {
          _conversationList = conversationList;

          if (!isMultiSelect) {
            handleForwardMessage();
          }
        },
      );
    }
    return Scaffold(
      appBar: TimAbAppBar(
        title: isMultiSelect ? TIM_t("选择多个会话") : TIM_t("选择一个会话"),
        backgroundWidget: Container(
          // 渐变色
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFFDC79),
                Color(0xFFFFCB32),
              ],
            ),
          ),
        ),
        // leftWidget: TextButton(
        //   onPressed: () {
        //     if (isMultiSelect) {
        //       setState(() {
        //         isMultiSelect = false;
        //         _conversationList = [];
        //       });
        //     } else {
        //       widget.model.updateMultiSelectStatus(false);
        //       if (widget.onClose != null) {
        //         widget.onClose!();
        //       } else {
        //         Navigator.pop(context);
        //       }
        //     }
        //   },
        //   child: Text(
        //     TIM_t("取消"),
        //     style: TextStyle(
        //       color: theme.appbarTextColor,
        //       fontSize: 14,
        //     ),
        //   ),
        // ),
        rightWidget: TextButton(
          onPressed: () {
            if (!isMultiSelect) {
              setState(() {
                isMultiSelect = true;
              });
            } else {
              setState(() {
                isMultiSelect = false;
                _conversationList = [];
              });
            }
          },
          child: Text(
            !isMultiSelect ? TIM_t("多选") : TIM_t("取消"),
            style: TextStyle(
              color: theme.appbarTextColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
      backgroundColor: theme.weakBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: RecentForwardList(
              isMultiSelect: isMultiSelect,
              onChanged: (conversationList) {
                _conversationList = conversationList;
                setState(() {
                });
                if (!isMultiSelect) {
                  handleForwardMessage();
                }
              },
            ),
          ),
          if (isMultiSelect) Container(
            color: theme.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                TimAbButton.gradientColorButton(
                    text: "${TIM_t("完成")}${_conversationList.length > 0 ? "(${_conversationList.length})" : ""}",
                    colors: [theme.primaryColor!, theme.secondaryColor!],
                    textColor: theme.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    height: 48,
                    onPressed: () {
                      handleForwardMessage();
                    }
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 10,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

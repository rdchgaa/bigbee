import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

class TIMUIKitGroupTipsElem extends StatefulWidget {
  final V2TimGroupTipsElem groupTipsElem;
  final List<V2TimGroupMemberFullInfo?> groupMemberList;

  const TIMUIKitGroupTipsElem({Key? key, required this.groupMemberList, required this.groupTipsElem})
      : super(key: key);

  @override
  State<TIMUIKitGroupTipsElem> createState() => _TIMUIKitGroupTipsElemState();
}

class _TIMUIKitGroupTipsElemState extends TIMUIKitState<TIMUIKitGroupTipsElem> {

  String groupTipsAbstractText = "";

  @override
  void initState() {
    super.initState();
    getText();
  }

  void getText() async {
    final newText = await MessageUtils.groupTipsMessageAbstract(widget.groupTipsElem, widget.groupMemberList);
    setState(() {
      groupTipsAbstractText = newText;
    });
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return MessageUtils.wrapMessageTips(
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.weakBackgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              groupTipsAbstractText,
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: theme.textColor),
            ),
          ),
        ),
        theme);
  }
}

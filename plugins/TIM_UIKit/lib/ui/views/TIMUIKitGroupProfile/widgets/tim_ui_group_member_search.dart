import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/optimize_utils.dart';


import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitSearch/pureUI/tim_uikit_search_input.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class GroupMemberSearchTextField extends TIMUIKitStatelessWidget {
  final Function(String text) onTextChange;
  GroupMemberSearchTextField({Key? key, required this.onTextChange})
      : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final isDesktopScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    final FocusNode focusNode = FocusNode();

    var debounceFunc = OptimizeUtils.debounce(
        (text) => onTextChange(text), const Duration(milliseconds: 300));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: Column(children: [
        const SizedBox(
          height: 16,
        ),
        if(!isDesktopScreen) Container(
          alignment: Alignment.centerLeft,
          height: 38,
          decoration: BoxDecoration(
            color: theme.white,
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              // border: Border.all(color: theme.white!, width: 6),
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center, // 垂直居中对齐
            onChanged: debounceFunc,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              hintText: TIM_t("搜索"),
              prefixIcon: const Icon(Icons.search, color: Colors.grey,),
              hintStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder( // 重点
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: const OutlineInputBorder( // 重点
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              disabledBorder: const OutlineInputBorder( // 重点
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: const OutlineInputBorder( // 重点
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              // border: InputBorder.none,
            ),
            )
          ),
        ),
        if(isDesktopScreen) TIMUIKitSearchInput(prefixIcon: Icon(
          Icons.search,
          size: 16,
          color: hexToColor("979797"),
        ),
          onChange: (text){
          focusNode.requestFocus();
            debounceFunc(text);
          }, focusNode: focusNode,
        ),
      ]),
    );
  }
}

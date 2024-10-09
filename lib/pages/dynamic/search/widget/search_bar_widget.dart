import 'package:bee_chat/main.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 搜索AppBar
class AppBarSearch extends StatefulWidget implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  AppBarSearch({
    Key? key,
    this.borderRadius = 10,
    this.autoFocus = false,
    this.focusNode,
    this.controller,
    this.textFieldHeight = 40,
    this.value,
    this.backgroundColor,
    this.hintText,
    this.onClear,
    this.onChanged,
    this.onSearch,
    this.onFocusStatus,
  }) : super(key: key);
  final double? borderRadius;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  // 输入框高度 默认40
  final double textFieldHeight;

  // 默认值
  final String? value;

  // 背景色
  final Color? backgroundColor;

  // 输入框提示文字
  final String? hintText;

  // 清除输入框内容回调
  final VoidCallback? onClear;

  // 输入框内容改变
  final ValueChanged<String>? onChanged;

  // 点击键盘（右侧）搜索
  final ValueChanged<String>? onSearch;

  // 键盘输入状态回调
  final ValueChanged<bool>? onFocusStatus;

  @override
  _AppBarSearchState createState() => _AppBarSearchState();

  @override
  Size get preferredSize => Size.fromHeight(textFieldHeight + MediaQuery.of(MyApp.context).padding.top + 8);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoDynamicColor.maybeResolve(this.backgroundColor, context) ??
        CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}

class _AppBarSearchState extends State<AppBarSearch> {
  TextEditingController? _controller;
  FocusNode? _focusNode;

  bool get isFocus => _focusNode?.hasFocus ?? false; //是否获取焦点

  bool get isTextEmpty => _controller?.text.isEmpty ?? false; //输入框是否为空

  // bool get isActionEmpty => widget.actions.isEmpty; // 右边布局是否为空

  bool isShowCancel = false;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.value != null) _controller?.text = widget.value ?? "";
    // 焦点获取失去监听
    _focusNode?.addListener(() {
      widget.onFocusStatus?.call(_focusNode?.hasFocus ?? false);
      setState(() {});
    });
    // 文本输入监听
    _controller?.addListener(() {
      setState(() {});
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _focusNode?.requestFocus());
  }


  // 清除输入框内容
  void _onClearInput() {
    setState(() {
      _controller?.clear();
    });
    _focusNode?.requestFocus();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
        height: widget.textFieldHeight + MediaQuery.of(context).padding.top + 8,
        color: widget.backgroundColor ?? theme.white,
        child: Stack(children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 4,
            left: 16,
            right: 0,
            height: widget.textFieldHeight,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: widget.textFieldHeight,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: theme.white,
                      borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
                      // 边框
                      border: Border.all(color: theme.f4f4f4, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: widget.textFieldHeight,
                          height: widget.textFieldHeight,
                          child: Center(child: Image.asset(ABAssets.searchGreyIcon(context), width: 24, height: 24)),
                        ),
                        Expanded(
                          child: ExtendedTextField(
                              controller: widget.controller,
                              focusNode: _focusNode,
                              maxLines: 1,
                              minLines: 1,
                              onChanged: (value) {
                                widget.onChanged?.call(value);
                                setState(() {});
                              },
                              onTap: () {},
                              onSubmitted: widget.onSearch,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.search,
                              onEditingComplete: () {},
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: theme.textGrey,
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                isDense: true,
                                hintText: AB_S().search,
                              ),
                              style: TextStyle(
                                color: theme.textColor,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final isBack = await Navigator.maybePop(context);
                    if (!isBack) {
                      await SystemNavigator.pop();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      AB_S().cancel,
                      style: TextStyle(color: theme.primaryColor, fontSize: 16.px, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }
}

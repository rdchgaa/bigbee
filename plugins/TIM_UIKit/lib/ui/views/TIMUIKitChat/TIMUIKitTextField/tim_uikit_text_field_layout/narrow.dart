import 'dart:async';
import 'dart:math';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_setting_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/optimize_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/permission.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/special_text/DefaultSpecialTextSpanBuilder.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_send_sound_message.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_text.dart';
import 'package:tencent_keyboard_visibility/tencent_keyboard_visibility.dart';

GlobalKey<_TIMUIKitTextFieldLayoutNarrowState> narrowTextFieldKey = GlobalKey();

class TIMUIKitTextFieldLayoutNarrow extends StatefulWidget {
  /// sticker panel customization
  final CustomStickerPanel? customStickerPanel;

  final VoidCallback onEmojiSubmitted;
  final Function(int, String) onCustomEmojiFaceSubmitted;
  final Function(String, bool) handleSendEditStatus;
  final VoidCallback backSpaceText;
  final ValueChanged<String> addStickerToText;

  final ValueChanged<String> handleAtText;

  /// Whether to use the default emoji
  final bool isUseDefaultEmoji;

  final TUIChatSeparateViewModel model;

  /// background color
  final Color? backgroundColor;

  /// control input field behavior
  final TIMUIKitInputTextFieldController? controller;

  /// config for more panel
  final MorePanelConfig? morePanelConfig;

  final String languageType;

  final TextEditingController textEditingController;

  /// conversation id
  final String conversationID;

  /// conversation type
  final ConvType conversationType;

 /// 选择群成员
  final MessageChooseMemberFunction? getSelectMember;

  final FocusNode focusNode;

  /// show more panel
  final bool showMorePanel;

  /// hint text for textField widget
  final String? hintText;

  final int? currentCursor;

  final ValueChanged<int?> setCurrentCursor;

  final VoidCallback onCursorChange;

  /// show send audio icon
  final bool showSendAudio;

  final VoidCallback handleSoftKeyBoardDelete;

  /// on text changed
  final void Function(String)? onChanged;

  final V2TimMessage? repliedMessage;

  final V2TimMessage? editorMessage;

  /// show send emoji icon
  final bool showSendEmoji;

  final String? forbiddenText;

  final VoidCallback onSubmitted;

  final VoidCallback goDownBottom;

  final List<CustomEmojiFaceData> customEmojiStickerList;

  final List<CustomStickerPackage> stickerPackageList;

  //自定义
  //顶部背景
  final BoxDecoration? inputDecoration;

  //输入框背景色
  final Color? weakBackgroundColor;

  // 输入框和功能排列横竖
  final Axis? scrollDirection;

  //中间插入的组件
  final Widget? childCenter;

  // 发送按钮是否展示
  final bool? isShowSend;

  //是否展示emoji底部按钮
  final bool? showDeleteButton;
  final bool? showBottomContainer;
  final EdgeInsetsGeometry? padding;
  final double? inputHeight;
  final bool? showRecentEmo;
  final String? recentEmoText;
  final String? allEmoText;

  final MessageSendRedEnvelopeFunction? sendRedEnvelope;
  final MergePictureFunction? mergePictureCallback;

  const TIMUIKitTextFieldLayoutNarrow(
      {Key? key,
      this.customStickerPanel,
      required this.onEmojiSubmitted,
      required this.onCustomEmojiFaceSubmitted,
      required this.backSpaceText,
      required this.addStickerToText,
      required this.isUseDefaultEmoji,
      required this.languageType,
      required this.textEditingController,
      this.morePanelConfig,
      required this.conversationID,
      required this.conversationType,
        this.getSelectMember,
      required this.focusNode,
      this.currentCursor,
      required this.setCurrentCursor,
      required this.onCursorChange,
      required this.model,
      this.backgroundColor,
      this.onChanged,
      required this.handleSendEditStatus,
      required this.handleAtText,
      required this.handleSoftKeyBoardDelete,
      this.repliedMessage,
        this.editorMessage,
      this.forbiddenText,
      required this.onSubmitted,
      required this.goDownBottom,
      required this.showSendAudio,
      required this.showSendEmoji,
      required this.showMorePanel,
      this.hintText,
      required this.customEmojiStickerList,
      this.controller,
      required this.stickerPackageList,
      this.inputDecoration,
      this.weakBackgroundColor,
      this.scrollDirection,
      this.childCenter,
      this.isShowSend,
      this.showDeleteButton,
      this.showBottomContainer,
      this.padding,
      this.inputHeight,
        this.showRecentEmo = false,
        this.recentEmoText,
        this.allEmoText,
        this.sendRedEnvelope, this.mergePictureCallback,})
      : super(key: key);

  @override
  State<TIMUIKitTextFieldLayoutNarrow> createState() => _TIMUIKitTextFieldLayoutNarrowState();
}

class _TIMUIKitTextFieldLayoutNarrowState extends TIMUIKitState<TIMUIKitTextFieldLayoutNarrow> {
  final TUISettingModel settingModel = serviceLocator<TUISettingModel>();

  bool showMore = false;
  bool showMoreButton = true;
  bool showSendSoundText = false;
  bool showEmojiPanel = false;
  bool showKeyboard = false;
  Function? setKeyboardHeight;
  double? bottomPadding;

  static const String localEmoListKey = 'localEmoList';

  List<String> localEmoList = [];

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller?.addListener(
        () {
          final actionType = widget.controller?.actionType;
          if (actionType == ActionType.hideAllPanel) {
            hideAllPanel();
          }
        },
      );
    }
    initLocalEmo();
  }

  initLocalEmo() async {
    localEmoList = await getLocalEmoList();
    setState(() {});
  }

  void setSendButton() {
    final value = widget.textEditingController.text;
    if (isWebDevice() || isAndroidDevice() || isIosDevice()) {
      if (value.isEmpty && showMoreButton != true) {
        setState(() {
          showMoreButton = true;
        });
      } else if (value.isNotEmpty && showMoreButton == true) {
        setState(() {
          showMoreButton = false;
        });
      }
    }
  }

  hideAllPanel() {
    widget.focusNode.unfocus();
    widget.currentCursor == null;
    if (showKeyboard != false || showMore != false || showEmojiPanel != false) {
      setState(() {
        showKeyboard = false;
        showMore = false;
        showEmojiPanel = false;
      });
    }
  }

  Widget _getBottomContainer(TUITheme theme) {
    if (showEmojiPanel) {
      return widget.customStickerPanel != null
          ? widget.customStickerPanel!(
              sendTextMessage: () {
                widget.onEmojiSubmitted();
                setSendButton();
              },
              sendFaceMessage: widget.onCustomEmojiFaceSubmitted,
              deleteText: () {
                widget.backSpaceText();
                setSendButton();
              },
              addText: (int unicode) {
                final newText = String.fromCharCode(unicode);
                widget.addStickerToText(newText);
                setSendButton();
                // handleSetDraftText();
              },
              addCustomEmojiText: ((String singleEmojiName) {
                String? emojiName = singleEmojiName.split('.png')[0];
                if (widget.isUseDefaultEmoji &&
                    widget.languageType == 'zh' &&
                    TUIKitStickerConstData.emojiMapList[emojiName] != null &&
                    TUIKitStickerConstData.emojiMapList[emojiName] != '') {
                  emojiName = TUIKitStickerConstData.emojiMapList[emojiName];
                }
                final newText = '[$emojiName]';
                widget.addStickerToText(newText);
                setSendButton();
              }),
              defaultCustomEmojiStickerList: widget.isUseDefaultEmoji ? TUIKitStickerConstData.emojiList : [])
          : Column(
              children: [
                if(widget.showRecentEmo==true)ColoredBox(
                  color: Colors.white,
                  child: Builder(builder: (context) {
                    List<Widget> listBuild = [];
                    for (String emo in localEmoList) {
                      listBuild.add(Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: InkWell(
                          onTap: (){
                            addCustomEmojiText(emo.replaceAll('[','').replaceAll(']',''));
                          },
                          child: LinkText(
                              isEnableTextSelection: false,
                              messageText: emo,
                              style: TextStyle(color: Colors.black, fontSize: 16),
                              isUseQQPackage: true,
                              isUseTencentCloudChatPackage: true,
                              customEmojiStickerList: widget.customEmojiStickerList),
                        ),
                      ));
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.recentEmoText??'最近使用',
                                  style: TextStyle(fontSize: 12, color: Color(0xff989897)),
                                )),
                          ),
                          SizedBox(
                            height: 25,
                            child: Row(
                              children: listBuild,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.allEmoText??'全部表情',
                                  style: TextStyle(fontSize: 12, color: Color(0xff989897)),
                                )),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                StickerPanel(
                  isWideScreen: false,
                  panelPadding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                  backgroundColor: theme.white,
                  sendTextMsg: () {
                    widget.onEmojiSubmitted();
                    setSendButton();
                  },
                  sendFaceMsg: widget.onCustomEmojiFaceSubmitted,
                  deleteText: () {
                    widget.backSpaceText();
                    setSendButton();
                  },
                  addText: (int unicode) {
                    final newText = String.fromCharCode(unicode);
                    widget.addStickerToText(newText);
                    setSendButton();
                    // handleSetDraftText();
                  },
                  addCustomEmojiText: ((String singleEmojiName) async {
                    addCustomEmojiText(singleEmojiName);
                    // String? emojiName = singleEmojiName.split('.png')[0];
                    // if (widget.isUseDefaultEmoji &&
                    //     widget.languageType == 'zh' &&
                    //     TUIKitStickerConstData.emojiMapList[emojiName] != null &&
                    //     TUIKitStickerConstData.emojiMapList[emojiName] != '') {
                    //   emojiName = TUIKitStickerConstData.emojiMapList[emojiName];
                    // }
                    // final newText = '[$emojiName]';
                    // widget.addStickerToText(newText);
                    // setSendButton();
                    // // saveLocalEmo(newText);
                    // await setLocalEmoList(newText);
                    // initLocalEmo();
                  }),
                  customStickerPackageList: widget.stickerPackageList,
                  lightPrimaryColor: theme.lightPrimaryColor,
                  showDeleteButton: widget.showDeleteButton ?? true,
                  showBottomContainer: widget.showBottomContainer ?? true,
                ),
              ],
            );
    }

    if (showMore) {
      return MorePanel(
          morePanelConfig: widget.morePanelConfig,
          conversationID: widget.conversationID,
          conversationType: widget.conversationType,
          getSelectMember: widget.getSelectMember,
        sendRedEnvelope: widget.sendRedEnvelope,
        mergePictureCallback: widget.mergePictureCallback,
      );
    }

    return const SizedBox(height: 0);
  }

  addCustomEmojiText(String singleEmojiName) async {
    String? emojiName = singleEmojiName.split('.png')[0];
    if (widget.isUseDefaultEmoji &&
        widget.languageType == 'zh' &&
        TUIKitStickerConstData.emojiMapList[emojiName] != null &&
        TUIKitStickerConstData.emojiMapList[emojiName] != '') {
      emojiName = TUIKitStickerConstData.emojiMapList[emojiName];
    }
    final newText = '[$emojiName]';
    widget.addStickerToText(newText);
    setSendButton();
    // saveLocalEmo(newText);
    await setLocalEmoList(newText);
    initLocalEmo();
  }

  Future<List<String>> getLocalEmoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> list = prefs.getStringList(localEmoListKey)??[];
    return prefs.getStringList(localEmoListKey) ?? [];
  }

  Future<bool> setLocalEmoList(String emo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(localEmoListKey) ?? [];

    if (list.contains(emo)) {
      list.remove(emo);
    } else {
      if (list.length >= 8) {
        list.removeAt(list.length - 1);
      }
    }
    list.insert(0, emo);
    return prefs.setStringList(localEmoListKey, list);
  }

  double _getBottomHeight() {
    if (showKeyboard) {
      final currentKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      double originHeight = settingModel.keyboardHeight;
      if (currentKeyboardHeight != 0) {
        if (currentKeyboardHeight >= originHeight) {
          originHeight = currentKeyboardHeight;
        }
        if (setKeyboardHeight != null) {
          setKeyboardHeight!(currentKeyboardHeight);
        }
      }
      final height = originHeight != 0 ? originHeight : currentKeyboardHeight;
      return height;
    } else if (showMore || showEmojiPanel) {
      return 248.0 + (bottomPadding ?? 0.0);
    } else if (widget.textEditingController.text.length >= 46 && showKeyboard == false) {
      return 25 + (bottomPadding ?? 0.0);
    } else {
      return bottomPadding ?? 0;
    }
  }

  _openMore() {
    if (!showMore) {
      widget.focusNode.unfocus();
      widget.setCurrentCursor(null);
    }
    setState(() {
      showKeyboard = false;
      showEmojiPanel = false;
      showSendSoundText = false;
      showMore = !showMore;
    });
  }

  _openEmojiPanel() {
    widget.onCursorChange();
    showKeyboard = showEmojiPanel;
    if (showEmojiPanel) {
      widget.focusNode.requestFocus();
    } else {
      widget.focusNode.unfocus();
    }

    setState(() {
      showMore = false;
      showSendSoundText = false;
      showEmojiPanel = !showEmojiPanel;
    });
  }

  _debounce(
    Function(String text) fun, [
    Duration delay = const Duration(milliseconds: 30),
  ]) {
    Timer? timer;
    return (String text) {
      if (timer != null) {
        timer?.cancel();
      }

      timer = Timer(delay, () {
        fun(text);
      });
    };
  }

  String getAbstractMessage(V2TimMessage message) {
    final String? customAbstractMessage =
        widget.model.abstractMessageBuilder != null ? widget.model.abstractMessageBuilder!(message) : null;
    return customAbstractMessage ?? MessageUtils.getAbstractMessageAsync(message, widget.model.groupMemberList ?? []);
  }

  _buildRepliedMessage(V2TimMessage? repliedMessage, TUITheme theme) {
    final haveRepliedMessage = repliedMessage != null;
    if (haveRepliedMessage) {
      final String text = "${MessageUtils.getDisplayName(repliedMessage)}: ${getAbstractMessage(repliedMessage)}";
      return Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? hexToColor("f5f5f6"),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: theme.black!.withOpacity(0.06),
              offset: const Offset(1, -5),
              blurRadius: 10,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${TIM_t("引用")}${TIM_t("消息")} :",
                    style: TextStyle(color: hexToColor("989898"), fontSize: 12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    text,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            InkWell(
              onTap: () {
                widget.model.repliedMessage = null;
              },
              child: Icon(Icons.cancel, color: Colors.grey, size: 24),
            )
          ],
        ),
      );
    }
    return Container();
  }
  _buildEditorMessage(V2TimMessage? editorMessage, TUITheme theme) {
    final haveEditorMessage = editorMessage != null;
    if (haveEditorMessage) {
      final String text = "${MessageUtils.getDisplayName(editorMessage)}: ${getAbstractMessage(editorMessage)}";
      return Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? hexToColor("f5f5f6"),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: theme.black!.withOpacity(0.06),
              offset: const Offset(1, -5),
              blurRadius: 10,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${TIM_t("编辑")}${TIM_t("消息")} :",
                    style: TextStyle(color: hexToColor("989898"), fontSize: 12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    text,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            InkWell(
              onTap: () {
                widget.model.editorMessage = null;
              },
              child: Icon(Icons.cancel, color: Colors.grey, size: 24),
            )
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;

    final hasRepliedMessage = widget.repliedMessage != null;
    final hasEditorMessage = widget.editorMessage != null;
    setKeyboardHeight ??= OptimizeUtils.debounce((height) {
      settingModel.keyboardHeight = height;
    }, const Duration(seconds: 1));

    final debounceFunc = _debounce((value) {
      if (isWebDevice() || isAndroidDevice() || isIosDevice()) {
        if (value.isEmpty && showMoreButton != true) {
          setState(() {
            showMoreButton = true;
          });
        } else if (value.isNotEmpty && showMoreButton == true) {
          setState(() {
            showMoreButton = false;
          });
        }
      }
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
      widget.handleAtText(value);
      widget.handleSendEditStatus(value, true);
      final isEmpty = value.isEmpty;
      if (isEmpty) {
        widget.handleSoftKeyBoardDelete();
      }
    }, const Duration(milliseconds: 80));

    final MediaQueryData data = MediaQuery.of(context);
    EdgeInsets padding = data.padding;
    if (bottomPadding == null || padding.bottom > bottomPadding!) {
      bottomPadding = padding.bottom;
    }

    return Container(
      color: widget.backgroundColor ?? hexToColor("f5f5f6"),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            if (hasRepliedMessage) _buildRepliedMessage(widget.repliedMessage, theme),
            if (hasEditorMessage) _buildEditorMessage(widget.editorMessage, theme),
            Container(
              decoration: widget.inputDecoration ??
                  BoxDecoration(
                    color: widget.backgroundColor ?? hexToColor("f5f5f6"),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    // 阴影
                    boxShadow: [
                      BoxShadow(
                        color: theme.black!.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
              child: Column(
                children: [
                  Container(
                    padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Row(
                      children: [
                        if (widget.forbiddenText != null)
                          Expanded(
                              child: Container(
                            height: 48,
                            color: theme.weakBackgroundColor,
                            alignment: Alignment.center,
                            child: Text(
                              TIM_t(widget.forbiddenText!),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.weakTextColor,
                              ),
                            ),
                          )),
                        if (PlatformUtils().isMobile && widget.showSendAudio && widget.forbiddenText == null)
                          InkWell(
                            onTap: () async {
                              showKeyboard = showSendSoundText;
                              if (showSendSoundText) {
                                widget.focusNode.requestFocus();
                              }
                              if (await Permissions.checkPermission(
                                context,
                                Permission.microphone.value,
                                theme,
                              )) {
                                setState(() {
                                  showEmojiPanel = false;
                                  showMore = false;
                                  showSendSoundText = !showSendSoundText;
                                });
                              }
                            },
                            child: Container(
                              width: 32,
                              height: 48,
                              child: Center(
                                child: Image.asset(
                                  showSendSoundText ? "images/input_keyboard.png" : "images/input_sound.png",
                                  package: 'tencent_cloud_chat_uikit',
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),
                        if (PlatformUtils().isMobile && widget.showSendAudio && widget.forbiddenText == null)
                          SizedBox(
                            width: 12,
                          ),
                        if (widget.forbiddenText == null)
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: (showSendSoundText ? 0 : 6), horizontal: 0),
                              // 圆角
                              decoration: BoxDecoration(
                                color: widget.weakBackgroundColor ?? theme.weakBackgroundColor,
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: LayoutBuilder(builder: (context, con) {
                                if (widget.scrollDirection == Axis.vertical) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: con.maxWidth,
                                        height: widget.inputHeight,
                                        child: showSendSoundText
                                            // 发送语音
                                            ? SendSoundMessage(
                                                onDownBottom: widget.goDownBottom,
                                                conversationID: widget.conversationID,
                                                conversationType: widget.conversationType)
                                            // 发送文本
                                            : KeyboardVisibility(
                                                child: ExtendedTextField(
                                                    maxLines: 4,
                                                    minLines: 1,
                                                    focusNode: widget.focusNode,
                                                    onChanged: debounceFunc,
                                                    onTap: () {
                                                      showKeyboard = true;
                                                      widget.goDownBottom();
                                                      setState(() {
                                                        showEmojiPanel = false;
                                                        showMore = false;
                                                      });
                                                    },
                                                    keyboardType: TextInputType.multiline,
                                                    textInputAction: PlatformUtils().isAndroid
                                                        ? TextInputAction.newline
                                                        : TextInputAction.send,
                                                    onEditingComplete: () {
                                                      widget.onSubmitted();
                                                      if (showKeyboard) {
                                                        widget.focusNode.requestFocus();
                                                      }
                                                      setState(() {
                                                        if (widget.textEditingController.text.isEmpty) {
                                                          showMoreButton = true;
                                                        }
                                                      });
                                                    },
                                                    textAlignVertical: TextAlignVertical.top,
                                                    decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        hintStyle: const TextStyle(
                                                          // fontSize: 10,
                                                          color: Color(0xffAEA4A3),
                                                        ),
                                                        fillColor:
                                                            widget.weakBackgroundColor ?? theme.weakBackgroundColor,
                                                        filled: true,
                                                        isDense: true,
                                                        hintText: widget.hintText ?? ''),
                                                    controller: widget.textEditingController,
                                                    specialTextSpanBuilder: PlatformUtils().isWeb
                                                        ? null
                                                        : DefaultSpecialTextSpanBuilder(
                                                            isUseQQPackage: (widget.model.chatConfig.stickerPanelConfig
                                                                        ?.useTencentCloudChatStickerPackage ??
                                                                    true) ||
                                                                widget.isUseDefaultEmoji,
                                                            isUseTencentCloudChatPackage: widget
                                                                    .model
                                                                    .chatConfig
                                                                    .stickerPanelConfig
                                                                    ?.useTencentCloudChatStickerPackage ??
                                                                true,
                                                            customEmojiStickerList: widget.customEmojiStickerList,
                                                            showAtBackground: true,
                                                          )),
                                                onChanged: (bool visibility) {
                                                  if (showKeyboard != visibility) {
                                                    setState(() {
                                                      showKeyboard = visibility;
                                                    });
                                                  }
                                                }),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      widget.childCenter ?? const SizedBox(),
                                      if (widget.showSendEmoji && widget.forbiddenText == null)
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: InkWell(
                                            onTap: () {
                                              _openEmojiPanel();
                                              widget.goDownBottom();
                                            },
                                            child: SizedBox(
                                              width: 32,
                                              height: 36,
                                              child: Center(
                                                child: Image.asset(
                                                  showEmojiPanel
                                                      ? "images/input_keyboard.png"
                                                      : "images/input_emoji.png",
                                                  package: 'tencent_cloud_chat_uikit',
                                                  width: 28,
                                                  height: 28,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (widget.forbiddenText == null)
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      if (widget.showMorePanel && widget.forbiddenText == null && showMoreButton)
                                        InkWell(
                                          onTap: () {
                                            // model.sendCustomMessage(data: "a", convID: model.currentSelectedConv, convType: model.currentSelectedConvType == 1 ? ConvType.c2c : ConvType.group);
                                            _openMore();
                                            widget.goDownBottom();
                                          },
                                          child: SizedBox(
                                            width: 32,
                                            height: 36,
                                            child: Center(
                                              child: Image.asset(
                                                "images/input_more.png",
                                                package: 'tencent_cloud_chat_uikit',
                                                width: 28,
                                                height: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (widget.showMorePanel && widget.forbiddenText == null && showMoreButton)
                                        const SizedBox(
                                          width: 12,
                                        )
                                    ],
                                  );
                                }
                                return Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: showSendSoundText
                                          // 发送语音
                                          ? SendSoundMessage(
                                              onDownBottom: widget.goDownBottom,
                                              conversationID: widget.conversationID,
                                              conversationType: widget.conversationType)
                                          // 发送文本
                                          : KeyboardVisibility(
                                              child: ExtendedTextField(
                                                  maxLines: 4,
                                                  minLines: 1,
                                                  focusNode: widget.focusNode,
                                                  onChanged: debounceFunc,
                                                  onTap: () {
                                                    showKeyboard = true;
                                                    widget.goDownBottom();
                                                    setState(() {
                                                      showEmojiPanel = false;
                                                      showMore = false;
                                                    });
                                                  },
                                                  keyboardType: TextInputType.multiline,
                                                  textInputAction: PlatformUtils().isAndroid
                                                      ? TextInputAction.newline
                                                      : TextInputAction.send,
                                                  onEditingComplete: () {
                                                    widget.onSubmitted();
                                                    if (showKeyboard) {
                                                      widget.focusNode.requestFocus();
                                                    }
                                                    setState(() {
                                                      if (widget.textEditingController.text.isEmpty) {
                                                        showMoreButton = true;
                                                      }
                                                    });
                                                  },
                                                  textAlignVertical: TextAlignVertical.top,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintStyle: const TextStyle(
                                                        // fontSize: 10,
                                                        color: Color(0xffAEA4A3),
                                                      ),
                                                      fillColor:
                                                          widget.weakBackgroundColor ?? theme.weakBackgroundColor,
                                                      filled: true,
                                                      isDense: true,
                                                      hintText: widget.hintText ?? ''),
                                                  controller: widget.textEditingController,
                                                  specialTextSpanBuilder: PlatformUtils().isWeb
                                                      ? null
                                                      : DefaultSpecialTextSpanBuilder(
                                                          isUseQQPackage: (widget.model.chatConfig.stickerPanelConfig
                                                                      ?.useTencentCloudChatStickerPackage ??
                                                                  true) ||
                                                              widget.isUseDefaultEmoji,
                                                          isUseTencentCloudChatPackage: widget
                                                                  .model
                                                                  .chatConfig
                                                                  .stickerPanelConfig
                                                                  ?.useTencentCloudChatStickerPackage ??
                                                              true,
                                                          customEmojiStickerList: widget.customEmojiStickerList,
                                                          showAtBackground: true,
                                                        )),
                                              onChanged: (bool visibility) {
                                                if (showKeyboard != visibility) {
                                                  setState(() {
                                                    showKeyboard = visibility;
                                                  });
                                                }
                                              }),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (widget.showSendEmoji && widget.forbiddenText == null)
                                      InkWell(
                                        onTap: () {
                                          _openEmojiPanel();
                                          widget.goDownBottom();
                                        },
                                        child: SizedBox(
                                          width: 32,
                                          height: 36,
                                          child: Center(
                                            child: Image.asset(
                                              showEmojiPanel ? "images/input_keyboard.png" : "images/input_emoji.png",
                                              package: 'tencent_cloud_chat_uikit',
                                              width: 28,
                                              height: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (widget.forbiddenText == null)
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    if (widget.showMorePanel && widget.forbiddenText == null && showMoreButton)
                                      InkWell(
                                        onTap: () {
                                          // model.sendCustomMessage(data: "a", convID: model.currentSelectedConv, convType: model.currentSelectedConvType == 1 ? ConvType.c2c : ConvType.group);
                                          _openMore();
                                          widget.goDownBottom();
                                        },
                                        child: SizedBox(
                                          width: 32,
                                          height: 36,
                                          child: Center(
                                            child: Image.asset(
                                              "images/input_more.png",
                                              package: 'tencent_cloud_chat_uikit',
                                              width: 28,
                                              height: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (widget.showMorePanel && widget.forbiddenText == null && showMoreButton)
                                      const SizedBox(
                                        width: 12,
                                      )
                                  ],
                                );
                              }),
                            ),
                          ),
                        if ((widget.isShowSend != false) &&
                            !showMoreButton) // if ((isAndroidDevice() || isWebDevice()) &&
                          // !showMoreButton)
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: 36.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [theme.primaryColor!, theme.secondaryColor!],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(0),
                                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                shadowColor: WidgetStateProperty.all(Colors.transparent),
                                overlayColor: WidgetStateProperty.all(Colors.transparent),
                                foregroundColor: WidgetStateProperty.all(theme.textColor),
                              ),
                              onPressed: () {
                                widget.onSubmitted();
                                if (showKeyboard) {
                                  widget.focusNode.requestFocus();
                                }
                                if (widget.textEditingController.text.isEmpty) {
                                  setState(() {
                                    showMoreButton = true;
                                  });
                                }
                              },
                              child: Text(TIM_t("发送"),
                                  style: TextStyle(fontSize: 14, color: theme.textColor, fontWeight: FontWeight.w500)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: (showKeyboard && PlatformUtils().isAndroid) ? 200 : 340),
                    curve: Curves.fastOutSlowIn,
                    height: max(widget.showRecentEmo==true?_getBottomHeight()+85:_getBottomHeight(), 0.0),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [_getBottomContainer(theme)],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

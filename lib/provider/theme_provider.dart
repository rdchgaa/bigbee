import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import 'package:tencent_calls_uikit/tuicall_theme.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../main.dart';

ABTheme AB_theme(BuildContext context, {bool listen = true}) {
  return Provider.of<ThemeProvider>(context, listen: listen).theme;
}

ABTheme AB_T() {
  return Provider.of<ThemeProvider>(MyApp.context, listen: false).theme;
}

ThemeProvider AB_themeProvider(BuildContext context, {bool listen = true}) {
  return Provider.of<ThemeProvider>(context, listen: listen);
}

ThemeProvider AB_TP() {
  return Provider.of<ThemeProvider>(MyApp.context, listen: false);
}

class ThemeProvider extends ChangeNotifier {
  final ABTheme _lightTheme = const ABTheme(id: "light");
  final ABTheme _darkTheme = const ABTheme(
    id: "dark",
    primaryColor: Color(0xFFFFCB32),
    secondaryColor: Color(0xFFFB8701),
    backgroundColor: Color(0xFF050505),
    backgroundColorWhite: Color(0xFF1A1A1A),
    textColor: Colors.white,
    white: Colors.black,
    black: Colors.white,
    textGrey: Color(0xFF5C5B5B),
    inputFillColor: Color(0xFF0B0B0B),
    appbarBgColor: Color(0xFF0a0a0a),
    appbarTextColor: Colors.white,
    f4f4f4: Color(0xFF0B0B0B),
    text999 : Color(0xFF777777),
    e9e9e9 : Color(0xFF171717),
    d7d7d7 : Color(0xFF292929),
    text282109 : Color(0XFFd8def7),
    textFFD867 : Color(0xff0028a9),
    textFB8B04 : Color(0xFF0585fc),
  );
  ABThemeType _type = ABThemeType.system;

  TUITheme imTheme = imLightTheme;

  ABTheme get theme => _getTheme();

  ABThemeType get type => _type;

  String _themeId = "light";

  String get themeId => _themeId;

  bool get isDark => _themeId == "dark";

  void changeTheme(ABThemeType type) {
    _type = type;
    switch (type) {
      case ABThemeType.light:
        _themeId = "light";
        break;
      case ABThemeType.dark:
        _themeId = "dark";
        break;
      default:
        final brightness = MediaQuery.platformBrightnessOf(MyApp.context);
        bool isDarkMode = brightness == Brightness.dark;
        _themeId = isDarkMode ? "dark" : "light";
        break;
    }
    if (_themeId == "dark") {
      imTheme = imDarkTheme;
      TIMUIKitCore.getInstance().setTheme(theme: imDarkTheme);
      TUICallKit.theme = callDarkTheme;
    } else {
      imTheme = imLightTheme;
      TIMUIKitCore.getInstance().setTheme(theme: imLightTheme);
      TUICallKit.theme = callLightTheme;
    }
    notifyListeners();
  }

  ABTheme getTheme(BuildContext context) {
    switch (_type) {
      case ABThemeType.light:
        return _lightTheme;
      case ABThemeType.dark:
        return _darkTheme;
      default:
        final brightness = MediaQuery.platformBrightnessOf(context);
        bool isDarkMode = brightness == Brightness.dark;
        return isDarkMode ? _darkTheme : _lightTheme;
    }
  }

  ABTheme _getTheme() {
    switch (_type) {
      case ABThemeType.light:
        return _lightTheme;
      case ABThemeType.dark:
        return _darkTheme;
      default:
        final brightness = MediaQuery.platformBrightnessOf(MyApp.context);
        bool isDarkMode = brightness == Brightness.dark;
        return isDarkMode ? _darkTheme : _lightTheme;
    }
  }
}

enum ABThemeType { light, dark, system }

class ABTheme {
  const ABTheme({
    // id
    this.id = 'default',

    /// 应用主色
    this.primaryColor = const Color(0xFFFFCB32),

    /// 应用次色
    this.secondaryColor = const Color(0xFFFB8701),

    /// 背景颜色
    this.backgroundColor = const Color(0xFFFBFBFB),

    /// 背景颜色纯白
    this.backgroundColorWhite = const Color(0xFFFFFFFF),

    /// 灰色
    this.grey = const Color(0xFFE2E2E2),

    /// 字色
    this.textColor = const Color(0xFF333333),

    /// 灰色文本
    this.textGrey = const Color(0xFFB4B5B5),

    /// 输入框背景色
    this.inputFillColor = const Color(0xFFF4F4F4),
    this.white = Colors.white,
    this.black = Colors.black,

    /// Appbar 背景颜色
    this.appbarBgColor = const Color(0xFFF2F3F5),

    /// Appbar 文字颜色
    this.appbarTextColor = const Color(0xFF010000),

    /// 错误颜色
    this.errorColor = const Color(0xFFEB5757),
    this.f4f4f4 = const Color(0xFFF4F4F4),
    this.text999 = const Color(0xFF999999),
    this.e9e9e9 = const Color(0xFFe9e9e9),
    this.d7d7d7 = const Color(0xFFd7d7d7),
    this.text282109 = const Color(0XFF282109),
    this.textFFD867 = const Color(0xffFFD867),
    this.textFB8B04 = const Color(0xFFFB8b04),
  });

  final String id;

  /// 应用主色
  final Color primaryColor;

  /// 应用次色
  final Color secondaryColor;

  /// 背景颜色
  final Color backgroundColor;

  /// 背景颜色纯白
  final Color backgroundColorWhite;

  /// 灰色
  final Color grey;

  /// 字色
  final Color textColor;

  /// 灰色文本
  final Color textGrey;

  /// 输入框背景色
  final Color inputFillColor;

  /// 白色
  final Color white;

  /// 黑色
  final Color black;

  /// Appbar 背景颜色
  final Color appbarBgColor;

  /// Appbar 文字颜色
  final Color appbarTextColor;

  /// 错误颜色
  final Color errorColor;

  /// f4f4f4
  final Color f4f4f4;

  /// text999
  final Color text999;

  /// e9e9e9
  final Color e9e9e9;
  final Color d7d7d7;
  final Color text282109;
  final Color textFFD867;
  final Color textFB8B04;
}

const TUITheme imLightTheme = TUITheme(
  // 应用主色
  primaryColor: Color(0xFFFFCB32),
// 应用次色
  secondaryColor: Color(0xFFFB8701),
// 提示颜色，用于次级操作或提示
  infoColor: Color(0xFFEB5757),
// 浅背景颜色，比主背景颜色浅，用于填充缝隙或阴影
  weakBackgroundColor: Color(0xFFF4F4F4),
// 宽屏幕：浅白背景颜色，比浅背景颜色浅
  wideBackgroundColor: Color(0xFFEFEFEF),
// 浅分割线颜色，用于分割线或边框
  weakDividerColor: Color(0xFFE2E2E2),
// 浅字色
  weakTextColor: Color(0xFFAEA4A3),
// 深字色
  darkTextColor: Color(0xFF333333),
// 浅主色，用于AppBar或Panels
  lightPrimaryColor: Color(0xFFF7DEA4),
// 字色
  textColor: Color(0xFF333333),
  cautionColor: Color(0xFFFF584C),
  ownerColor: Colors.orange,
  adminColor: Colors.blue,
  white: Colors.white,
  black: Colors.black,
  inputFillColor: Color(0xFFEDEDED),
  textgrey: Color(0xFFAEA4A3),

  /// 消息列表多选面板背景颜色
  selectPanelBgColor: Color(0xFFF9F9FA),

  /// 消息列表多选面板文字及icon颜色
  selectPanelTextIconColor: Color(0xFF37393F),

  /// Appbar 背景颜色
  appbarBgColor: Color(0xFFF2F3F5),

  /// Appbar 文字颜色
  appbarTextColor: Color(0xFF010000),

  /// 会话列表背景颜色
  conversationItemBgColor: Colors.transparent,
  // 1

  /// 会话列表边框颜色
  conversationItemBorderColor: Color(0xFFE5E6E9),
  // 1

  /// 会话列表选中背景颜色
  conversationItemActiveBgColor: Color(0xFFEDEDED),
  // 1

  /// 会话列表置顶背景颜色
  conversationItemPinedBgColor: Color(0xFFEDEDED),
  // 1

  /// 会话列表Title字体颜色
  conversationItemTitleTextColor: Colors.black,
  // 1

  /// 会话列表LastMessage字体颜色
  conversationItemLastMessageTextColor: Color(0xFF999999),
  // 1

  /// 会话列表Time字体颜色
  conversationItemTitmeTextColor: Color(0xFF999999),
  // 1

  /// 会话列表用户在线状态背景色
  conversationItemOnlineStatusBgColor: Colors.green,
  // 1

  /// 会话列表用户离线状态背景色
  conversationItemOfflineStatusBgColor: Colors.grey,
  // 1

  /// 会话列表未读数背景颜色
  conversationItemUnreadCountBgColor: Color(0xFFFF584C),
  // 1

  /// 会话列表未读数字体颜色
  conversationItemUnreadCountTextColor: Colors.white,
  // 1

  /// 会话列表草稿字体颜色
  conversationItemDraftTextColor: Color(0xFFFF584C),
  // 1

  /// 会话列表收到消息不提醒Icon颜色
  conversationItemNoNotificationIconColor: Color(0xFF999999),
  // 1

  /// 会话列表侧滑按钮字体颜色
  conversationItemSliderTextColor: Colors.white,
  // 1

  /// 会话列表侧滑按钮Clear背景颜色
  conversationItemSliderClearBgColor: Color(0xFF00449E),
  // 1

  /// 会话列表侧滑按钮Pin背景颜色
  conversationItemSliderPinBgColor: Color(0xFFFF9C19),
  // 1

  /// 会话列表侧滑按钮Delete背景颜色
  conversationItemSliderDeleteBgColor: Colors.red,
  // 1

  /// 会话列表宽屏模式选中时背景颜色
  conversationItemChooseBgColor: Color(0xFFE7F0FF),
  // 1

  /// 聊天页背景颜色
  chatBgColor: Color(0xFFFBFBFB),
  // 1

  /// 桌面端消息输入框背景颜色
  desktopChatMessageInputBgColor: Colors.white,
  // 1

  /// 聊天页背景颜色
  chatTimeDividerTextColor: Color(0xFF999999),
  // 1

  /// 聊天页导航栏背景颜色
  chatHeaderBgColor: Color(0xFFF2F3F5),

  /// 聊天页导航栏Title字体颜色
  chatHeaderTitleTextColor: Color(0xFF010000),

  /// 聊天页导航栏Back字体颜色
  chatHeaderBackTextColor: Color(0xFF010000),

  /// 聊天页导航栏Action字体颜色
  chatHeaderActionTextColor: Color(0xFF010000),

  /// 聊天页历史消息列表字体颜色
  chatMessageItemTextColor: Colors.black,
  // 1

  /// 聊天页历史消息列表来自自己时背景颜色
  chatMessageItemFromSelfBgColor: Color(0xFFD1E3FF),

  /// 聊天页历史消息列表来自非自己时背景颜色
  chatMessageItemFromOthersBgColor: Color(0xFFEDEDED),
  // 1

  /// 聊天页历史消息列表已读状态字体颜色
  chatMessageItemUnreadStatusTextColor: Color(0xFF999999),
  // 1

  /// 聊天页历史消息列表小舌头背景颜色
  chatMessageTongueBgColor: Color(0xFFAEA4A3),

  /// 聊天页历史消息列表小舌头字体颜色
  chatMessageTongueTextColor: Color(0xFFAEA4A3),
);
const TUITheme imDarkTheme = TUITheme(
  // 应用主色
  primaryColor: Color(0xFFFFCB32),
// 应用次色
  secondaryColor: Color(0xFFFB8701),
// 提示颜色，用于次级操作或提示
  infoColor: Color(0xFFEB5757),
// 浅背景颜色，比主背景颜色浅，用于填充缝隙或阴影
  weakBackgroundColor: Color(0xFF0b0b0b),
// 宽屏幕：浅白背景颜色，比浅背景颜色浅
  wideBackgroundColor: Color(0xFFEFEFEF),
// 浅分割线颜色，用于分割线或边框
  weakDividerColor: Color(0xFFE2E2E2),
// 浅字色
  weakTextColor: Color(0xFF616B6C),
// 深字色
  darkTextColor: Colors.white,
// 浅主色，用于AppBar或Panels
  lightPrimaryColor: Color(0xFF010000),
// 字色
  textColor: Colors.white,
  cautionColor: Color(0xFFFF584C),
  ownerColor: Colors.orange,
  adminColor: Colors.blue,
  white: Colors.black,
  black: Colors.white,
  inputFillColor: Color(0xFF121212),
  textgrey: Color(0xFF616B6C),

  /// 消息列表多选面板背景颜色
  selectPanelBgColor: Color(0xFF050506),

  /// 消息列表多选面板文字及icon颜色
  selectPanelTextIconColor: Color(0xFF37393F),

  /// Appbar 背景颜色
  appbarBgColor: Color(0xFF0D0B0A),

  /// Appbar 文字颜色
  appbarTextColor: Color(0xFF010000),

  /// 会话列表背景颜色
  conversationItemBgColor: Colors.transparent,
  // 1

  /// 会话列表边框颜色
  conversationItemBorderColor: Colors.transparent,
  // 1

  /// 会话列表选中背景颜色
  conversationItemActiveBgColor: Color(0xFFEDEDED),
  // 1

  /// 会话列表置顶背景颜色
  conversationItemPinedBgColor: Color(0xFF121212),
  // 1

  /// 会话列表Title字体颜色
  conversationItemTitleTextColor: Colors.white,
  // 1

  /// 会话列表LastMessage字体颜色
  conversationItemLastMessageTextColor: Color(0xFF999999),
  // 1

  /// 会话列表Time字体颜色
  conversationItemTitmeTextColor: Color(0xFF999999),
  // 1

  /// 会话列表用户在线状态背景色
  conversationItemOnlineStatusBgColor: Colors.green,
  // 1

  /// 会话列表用户离线状态背景色
  conversationItemOfflineStatusBgColor: Colors.grey,
  // 1

  /// 会话列表未读数背景颜色
  conversationItemUnreadCountBgColor: Color(0xFFFFCB32),
  // 1

  /// 会话列表未读数字体颜色
  conversationItemUnreadCountTextColor: Colors.white,
  // 1

  /// 会话列表草稿字体颜色
  conversationItemDraftTextColor: Color(0xFFFF584C),
  // 1

  /// 会话列表收到消息不提醒Icon颜色
  conversationItemNoNotificationIconColor: Color(0xFF999999),
  // 1

  /// 会话列表侧滑按钮字体颜色
  conversationItemSliderTextColor: Colors.white,
  // 1

  /// 会话列表侧滑按钮Clear背景颜色
  conversationItemSliderClearBgColor: Color(0xFF00449E),
  // 1

  /// 会话列表侧滑按钮Pin背景颜色
  conversationItemSliderPinBgColor: Color(0xFFFF9C19),
  // 1

  /// 会话列表侧滑按钮Delete背景颜色
  conversationItemSliderDeleteBgColor: Colors.red,
  // 1

  /// 会话列表宽屏模式选中时背景颜色
  conversationItemChooseBgColor: Color(0xFFE7F0FF),
  // 1

  /// 聊天页背景颜色
  chatBgColor: Color(0xFF040404),
  // 1

  /// 桌面端消息输入框背景颜色
  desktopChatMessageInputBgColor: Colors.white,
  // 1

  /// 聊天页背景颜色
  chatTimeDividerTextColor: Color(0xFF999999),
  // 1

  /// 聊天页导航栏背景颜色
  chatHeaderBgColor: Color(0xFFF2F3F5),

  /// 聊天页导航栏Title字体颜色
  chatHeaderTitleTextColor: Color(0xFF010000),

  /// 聊天页导航栏Back字体颜色
  chatHeaderBackTextColor: Color(0xFF010000),

  /// 聊天页导航栏Action字体颜色
  chatHeaderActionTextColor: Color(0xFF010000),

  /// 聊天页历史消息列表字体颜色
  chatMessageItemTextColor: Colors.black,
  // 1

  /// 聊天页历史消息列表来自自己时背景颜色
  chatMessageItemFromSelfBgColor: Color(0xFFD1E3FF),

  /// 聊天页历史消息列表来自非自己时背景颜色
  chatMessageItemFromOthersBgColor: Color(0xFFEDEDED),
  // 1

  /// 聊天页历史消息列表已读状态字体颜色
  chatMessageItemUnreadStatusTextColor: Color(0xFF999999),
  // 1

  /// 聊天页历史消息列表小舌头背景颜色
  chatMessageTongueBgColor: Color(0xFFAEA4A3),

  /// 聊天页历史消息列表小舌头字体颜色
  chatMessageTongueTextColor: Color(0xFFAEA4A3),
);

// 音视频通话
const TuiCallTheme callLightTheme = TuiCallTheme();
const TuiCallTheme callDarkTheme = TuiCallTheme(
  primaryColor: Color(0xFFFFCB32),
  secondaryColor: Color(0xFFFB8701),
  backgroundColor: Color(0xFF050505),
  backgroundColorWhite: Color(0xFF1A1A1A),
  textColor: Colors.white,
  white: Colors.black,
  black: Colors.white,
  textGrey: Color(0xFF5C5B5B),
  inputFillColor: Color(0xFF0B0B0B),
  appbarBgColor: Color(0xFF0a0a0a),
  appbarTextColor: Colors.white,
  f4f4f4: Color(0xFF0B0B0B),
  text999 : Color(0xFF777777),
  e9e9e9 : Color(0xFF171717),
  d7d7d7 : Color(0xFF292929),
  text282109 : Color(0XFFd8def7),
  textFFD867 : Color(0xff0028a9),
  textFB8B04 : Color(0xFF0585fc),
);


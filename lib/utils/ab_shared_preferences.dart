import 'dart:convert';

import 'package:bee_chat/pages/mine/collection/widget/collection_message_item_widget.dart';
import 'package:bee_chat/provider/Modle/app_chat_setting_modle.dart';
import 'package:bee_chat/provider/Modle/app_notice_setting_modle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/theme_provider.dart';

class ABSharedPreferences {
  static late SharedPreferences prefs;

  /// 初始化(最好在main中调用)
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // 语言环境
  static const String languageCodeKey = 'language_code';

  // userId
  static const String userIdKey = 'user_id';

  // 主题
  static const String themeKey = 'theme_key';

  // token
  static const String tokenKey = 'token_code';

  // userSign
  static const String userSignKey = 'user_sign';

  // app聊天设置
  static const String appChatSetting = 'user_chat_setting';

  // app消息通知设置
  static const String appNoticeSetting = 'user_notice_setting';

  // 网络文件 大小
  static const String httpFileByteList = 'httpFileByteList';

  // 搜索历史记录
  static const String searchHistoryKey = 'search_history';

  static Future<String?> getLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageCodeKey);
  }

  static Future<bool> setLanguageCode(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(languageCodeKey, languageCode);
  }

  static String? getLanguageCodeSync() {
    return prefs.getString(languageCodeKey);
  }

  static setLanguageCodeSync(String languageCode) {
    prefs.setString(languageCodeKey, languageCode);
  }

  static Future<ABThemeType> getThemeType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (prefs.getString(themeKey)) {
      case 'light':
        return ABThemeType.light;
      case 'dark':
        return ABThemeType.dark;
      default:
        return ABThemeType.system;
    }
  }

  static Future<bool> setThemeType(ABThemeType theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (theme) {
      case ABThemeType.light:
        return prefs.setString(themeKey, 'light');
      case ABThemeType.dark:
        return prefs.setString(themeKey, 'dark');
      default:
        return prefs.setString(themeKey, 'system');
    }
  }

  static ABThemeType getThemeTypeSync() {
    switch (prefs.getString(themeKey)) {
      case 'light':
        return ABThemeType.light;
      case 'dark':
        return ABThemeType.dark;
      default:
        return ABThemeType.system;
    }
  }

  static void setThemeTypeSync(ABThemeType theme) {
    switch (theme) {
      case ABThemeType.light:
        prefs.setString(themeKey, 'light');
      case ABThemeType.dark:
        prefs.setString(themeKey, 'dark');
      default:
        prefs.setString(themeKey, 'system');
    }
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(tokenKey, token);
  }

  static String getTokenSync() {
    return prefs.getString(tokenKey) ?? '';
  }

  static setTokenSync(String token) {
    prefs.setString(tokenKey, token);
  }

  static Future<String?> getUserSign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userSignKey);
  }

  static Future<bool> setUserSign(String userSign) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userSignKey, userSign);
  }

  static String getUserSignSync() {
    return prefs.getString(userSignKey) ?? '';
  }

  static setUserSignSync(String userSign) {
    prefs.setString(userSignKey, userSign);
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  static Future<bool> setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, userId);
  }

  static String getUserIdSync() {
    return prefs.getString(userIdKey) ?? '';
  }

  static setUserIdSync(String userId) {
    prefs.setString(userIdKey, userId);
  }

  static AppChatSetting? getAppChatSetting() {
    String str = prefs.getString(appChatSetting) ?? '';
    try {
      var chatJson = json.decode(str);
      return AppChatSetting.fromMap(chatJson);
    } catch (e) {
      return null;
    }
  }

  static setAppChatSetting(AppChatSetting setting) {
    prefs.setString(appChatSetting, json.encode(setting.toMap()));
  }


  static AppNoticeSetting? getAppNoticeSetting() {
    String str = prefs.getString(appNoticeSetting) ?? '';
    try {
      var chatJson = json.decode(str);
      return AppNoticeSetting.fromMap(chatJson);
    } catch (e) {
      return null;
    }
  }

  static setAppNoticeSetting(AppNoticeSetting setting) {
    prefs.setString(appNoticeSetting, json.encode(setting.toMap()));
  }


  static List<HttpFileModel> getHttpFileByteList() {
    List<String> strList = prefs.getStringList(httpFileByteList) ?? [];
    try {
      List<HttpFileModel> valueList = [];
      for(String item in strList){
        HttpFileModel? model = HttpFileModel.fromMap(json.decode(item));
        if(model!=null){
          valueList.add(model);
        }
      }
      return valueList;
    } catch (e) {
      return [];
    }
  }

  static setHttpFileByte(HttpFileModel file) {
    List<String> strList = prefs.getStringList(httpFileByteList) ?? [];
    var item = json.encode(file.toMap());
    strList.add(item);
    prefs.setStringList(httpFileByteList, strList);
  }

  static HttpFileModel? checkHasHttpFile(String url){
    var hasThis = false;
    List<HttpFileModel> list = getHttpFileByteList();
    for(HttpFileModel model in list){
      if(model.url==url){
        hasThis = true;
        return model;
      }
    }
    return null;
  }

  // 添加搜索历史
  static Future<bool> addSearchHistory(String text) {
    List<String> list = getSearchHistory();
    list.removeWhere((element) => element.isEmpty);
    if (list.contains(text)) {
      list.remove(text);
    }
    if (list.length >= 20) {
      list.removeLast();
    }
    list.insert(0, text);
    return prefs.setStringList(searchHistoryKey, list);
  }

  // 获取搜索历史
  static List<String> getSearchHistory() {
    return prefs.getStringList(searchHistoryKey) ?? [];
  }

  // 清空搜索历史
  static Future<bool> clearSearchHistory() {
    return prefs.setStringList(searchHistoryKey, []);
  }

  // 设置搜索历史
  static Future<bool> setSearchHistory(List<String> list) {
    return prefs.setStringList(searchHistoryKey, list);
  }


}

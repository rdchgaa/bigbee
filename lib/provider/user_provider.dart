import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/user/user_detail_model.dart';
import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/provider/Modle/app_chat_setting_modle.dart';
import 'package:bee_chat/provider/Modle/app_notice_setting_modle.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/user/login_model.dart';

class UserProvider extends ChangeNotifier {
  LoginModel currentUser = LoginModel();
  UserDetailModel _userInfo = UserDetailModel();

  List<CoinModel> _coinList = [];

  AppChatSetting _chatSetting = AppChatSetting();

  AppNoticeSetting _noticeSetting = AppNoticeSetting();


  initData(BuildContext context){
    _chatSetting = ABSharedPreferences.getAppChatSetting()??AppChatSetting();
    _noticeSetting = ABSharedPreferences.getAppNoticeSetting()??AppNoticeSetting();
    notifyListeners();
  }

  AppChatSetting get chatSetting => _chatSetting;

  set chatSetting(AppChatSetting value) {
    _chatSetting = value;
    ABSharedPreferences.setAppChatSetting(value);
    notifyListeners();
  }


  AppNoticeSetting get noticeSetting => _noticeSetting;

  set noticeSetting(AppNoticeSetting value) {
    _noticeSetting = value;
    ABSharedPreferences.setAppNoticeSetting(value);
    notifyListeners();
  }

  List<CoinModel> get coinList => _coinList;

  set coinList(List<CoinModel> value) {
    _coinList = value;
    notifyListeners();
  }

  UserDetailModel get userInfo => _userInfo;

  set userInfo(UserDetailModel value) {
    _userInfo = value;
    notifyListeners();
  }

  static initUserInfo() async{
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    final userId = await ABSharedPreferences.getUserId() ?? "";
    final result = await UserNet.getUserInfo(userId: userId??'');
    if (result.data != null) {
      provider.userInfo = result.data!;
    }
    provider.notifyListeners();
  }

  static void setUserInfo(UserDetailModel userInfo) {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    provider.userInfo = userInfo;
    provider.notifyListeners();
  }

  static void setCurrentUser(LoginModel user) {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    provider.currentUser = user;
    provider.notifyListeners();
  }

  static void clearCurrentUser() {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    provider.currentUser = LoginModel();
    provider.notifyListeners();
  }

  static LoginModel getCurrentUser() {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    return provider.currentUser;
  }

  static UserDetailModel getUserInfo() {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    return provider._userInfo;
  }

  static bool isLogin() {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    return provider.currentUser.userId != null;
  }

  void setCurrentUserByToken(String token) {
    currentUser.token = token;
    notifyListeners();
  }

  static CoinModel? getCoinInfo(String coinName) {
    UserProvider provider = Provider.of<UserProvider>(MyApp.context, listen: false);
    for (var i = 0; i < provider.coinList.length; i++) {
      if (provider.coinList[i].coinName == coinName) {
        return provider.coinList[i];
      }
    }
    return null;
  }
}

import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:bee_chat/utils/net/ab_Net.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../main.dart';
import '../pages/contact/contact_page.dart';

class ContactProvider extends ChangeNotifier {

  List<ContactInfo> contactList = [];

  static Future<void> setContactList(List<ContactInfo> list) async {
    ContactProvider provider = Provider.of<ContactProvider>(
        MyApp.context,
        listen: false);
    provider.contactList = list;
    provider.contactList = handleList(provider.contactList);
    provider.notifyListeners();
    loadUserOnlineStatus();
  }


  static List<ContactInfo> handleList(List<ContactInfo> list) {
    if (list.isEmpty) return [];
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = list[i].namePinyin;
      String tag = pinyin.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(list);
    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(list);
    return list;
  }


  //获取用户在线状态
  static loadUserOnlineStatus() async {
    ContactProvider provider = Provider.of<ContactProvider>(
        MyApp.context,
        listen: false);
    //获取用户在线状态
    V2TimValueCallback<List<V2TimUserStatus>> getUserStatusRes =
    await TencentImSDKPlugin.v2TIMManager.getUserStatus(
        userIDList: provider.contactList.map((e) => e.friendInfo.userID).toList());// 需要查询用户在线状态的用户id列表\

    print(getUserStatusRes.toJson());
    if (getUserStatusRes.code == 0) {
      //查询成功
    provider.contactList = provider.contactList.map((e) {
      for (var item in (getUserStatusRes.data ?? [])) {
        if (item.userID == e.friendInfo.userID) {
          e.userStatus = item;
          return e;
        }
      }
      return e;
    }).toList();
      provider.notifyListeners();
    }
  }

  void cancelSelectAll() {
    contactList = contactList.map((e) {
      e.isSelected = false;
      return e;
    }).toList();
    notifyListeners();
  }

}
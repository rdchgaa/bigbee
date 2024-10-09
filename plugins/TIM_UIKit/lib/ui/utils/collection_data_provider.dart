import 'dart:convert';

import '../../tencent_cloud_chat_uikit.dart';

const String collectionBusinessID = "collectionBusinessID";

class CollectionDataProvider {
  Map<String, dynamic>? _dataMap;
  V2TimMessage? _innerMessage;

  bool _isCollectionMessage = false;
  String _content = '';
  String _lastMessageDesc = '';
  String? _collectionJsonString;


  Map<String, dynamic>? get dataMap => _dataMap;
  V2TimMessage? get innerMessage => _innerMessage;
  String get content => _content;
  String get lastMessageDesc => _lastMessageDesc;
  bool get isCollectionMessage => _isCollectionMessage;
  String? get collectionJsonString => _collectionJsonString;



  CollectionDataProvider(V2TimMessage message) {
    _innerMessage = message;
    try {
      if (_innerMessage?.customElem?.data != null) {
        _dataMap = jsonDecode(_innerMessage!.customElem!.data!) as Map<String, dynamic>?;
        _isCollectionMessage = _dataMap?["businessID"] == collectionBusinessID;
        _collectionJsonString = _dataMap?["collection"];
        _setContent();
        _setLastMessageDesc();
      } else {
        return;
      }
    } catch (err) {
      return;
    }
  }

  _setContent() {
    _content = "${TIM_getCurrentDeviceLocale().contains("zh") ? "[收藏]" : "[Collection]"}";
    // final showName = _getShowName();
    // if (_collectionJsonString != null) {
    //   Map<String, dynamic> jsonMap = json.decode(_collectionJsonString!);
    //   final title = jsonMap["title"];
    //   _content = "${showName}：${TIM_getCurrentDeviceLocale().contains("zh") ? "[收藏]" : "[Collection]"} $title";
    //
    //   if (title != null) {
    //   }
    // }
  }

  _setLastMessageDesc() {
    _lastMessageDesc = "${TIM_getCurrentDeviceLocale().contains("zh") ? "[收藏]" : "[Collection]"}";
  }



  _getShowName() {
    String showName = _innerMessage?.sender ?? "";
    if (_innerMessage?.nameCard != null && _innerMessage!.nameCard!.isNotEmpty) {
      showName = _innerMessage!.nameCard!;
    } else if (_innerMessage?.friendRemark != null && _innerMessage!.friendRemark!.isNotEmpty) {
      showName = _innerMessage!.friendRemark!;
    } else if (_innerMessage?.nickName != null && _innerMessage!.nickName!.isNotEmpty) {
      showName = _innerMessage!.nickName!;
    }
    return showName;
  }


}


import 'dart:convert';

import '../../tencent_cloud_chat_uikit.dart';

const String dynamicBusinessID = "dynamicBusinessID";

class DynamicDataProvider {
  Map<String, dynamic>? _dataMap;
  String? _dynamicJsonString;
  V2TimMessage? _innerMessage;

  bool _isDynamicMessage = false;
  String _lastMessageDesc = '';

  Map<String, dynamic>? get dataMap => _dataMap;
  V2TimMessage? get innerMessage => _innerMessage;
  String get lastMessageDesc => _lastMessageDesc;
  bool get isDynamicMessage => _isDynamicMessage;
  String? get dynamicJsonString => _dynamicJsonString;



  DynamicDataProvider(V2TimMessage message) {
    _innerMessage = message;
    try {
      if (_innerMessage?.customElem?.data != null) {
        _dataMap = jsonDecode(_innerMessage!.customElem!.data!) as Map<String, dynamic>?;
        _isDynamicMessage = _dataMap?["businessID"] == dynamicBusinessID;
        _dynamicJsonString = _dataMap?["dynamic"];
        _setLastMessageDesc();
      } else {
        return;
      }
    } catch (err) {
      return;
    }
  }


  _setLastMessageDesc() {
    _lastMessageDesc = '';
    if (_isDynamicMessage) {
      _lastMessageDesc = TIM_getCurrentDeviceLocale().contains("zh") ? "[动态消息]" : "[Dynamic message]";
    }
  }


}
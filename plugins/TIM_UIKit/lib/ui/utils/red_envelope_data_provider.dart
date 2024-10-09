import 'dart:convert';

import '../../tencent_cloud_chat_uikit.dart';

const String redEnvelopeBusinessID = "redEnvelopeBusinessID";

class RedEnvelopeDataProvider {
  Map<String, dynamic>? _dataMap;
  V2TimMessage? _innerMessage;

  bool _isRedEnvelopeMessage = false;
  String _content = '';
  String _lastMessageDesc = '';
  String? _redEnvelopeJsonString;


  Map<String, dynamic>? get dataMap => _dataMap;
  V2TimMessage? get innerMessage => _innerMessage;
  String get content => _content;
  String get lastMessageDesc => _lastMessageDesc;
  bool get isRedEnvelopeMessage => _isRedEnvelopeMessage;
  String? get redEnvelopeJsonString => _redEnvelopeJsonString;



  RedEnvelopeDataProvider(V2TimMessage message) {
    _innerMessage = message;
    try {
      if (_innerMessage?.customElem?.data != null) {
        _dataMap = jsonDecode(_innerMessage!.customElem!.data!) as Map<String, dynamic>?;
        _isRedEnvelopeMessage = _dataMap?["businessID"] == redEnvelopeBusinessID;
        _redEnvelopeJsonString = _dataMap?["redEnvelope"];
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
    _content = '';
    final showName = _getShowName();
    if (_redEnvelopeJsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(_redEnvelopeJsonString!);
      final title = jsonMap["title"];
      if (title != null) {
        _content = "${showName}：${TIM_getCurrentDeviceLocale().contains("zh") ? "[红包]" : "[Red envelope]"} $title";
      }
    }
  }

  _setLastMessageDesc() {
    _lastMessageDesc = '';
    final showName = _getShowName();
    if (_redEnvelopeJsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(_redEnvelopeJsonString!);
      final title = jsonMap["title"];
      if (title != null) {
        _lastMessageDesc = "${showName}：${TIM_getCurrentDeviceLocale().contains("zh") ? "[红包]" : "[Red envelope]"} $title";
      }
    }
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


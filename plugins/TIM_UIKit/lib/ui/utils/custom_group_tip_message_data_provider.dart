
import 'dart:convert';

import '../../tencent_cloud_chat_uikit.dart';

const String customGroupTipBusinessID = "customGroupTipBusinessID";

class CustomGroupTipMessageDataProvider {
  Map<String, dynamic>? _dataMap;
  V2TimMessage? _innerMessage;

  bool _isCustomGroupTipMessage = false;
  String _content = '';
  String _lastMessageDesc = '';


  Map<String, dynamic>? get dataMap => _dataMap;
  V2TimMessage? get innerMessage => _innerMessage;
  String get content => _content;
  String get lastMessageDesc => _lastMessageDesc;
  bool get isCustomGroupTipMessage => _isCustomGroupTipMessage;



  CustomGroupTipMessageDataProvider(V2TimMessage message) {
    _innerMessage = message;
    try {
      if (_innerMessage?.customElem?.data != null) {
        _dataMap = jsonDecode(_innerMessage!.customElem!.data!) as Map<String, dynamic>?;
        _isCustomGroupTipMessage = _dataMap?["businessID"] == customGroupTipBusinessID;
        _setContent(_dataMap);
        _setLastMessageDesc(_dataMap);
      } else {
        return;
      }
    } catch (err) {
      return;
    }
  }

  _setContent(Map<String, dynamic>? jsonMap) {
    _content = '';
    final showName = _getShowName();
    if (jsonMap != null) {
      final content = jsonMap["content"] as Map<String, dynamic>?;

      if (content != null) {
        final model = CustomGroupTipMessageModel.fromJson(content);
        switch (model.type) {
          case 1:
            _content = "${showName}${TIM_getCurrentDeviceLocale().contains("zh") ? "修改群名为" : " changed group name to"} ${model.target}";
            break;
            default:
              break;
        }
      }
    }
  }

  _setLastMessageDesc(Map<String, dynamic>? jsonMap) {
    _lastMessageDesc = '';
    final showName = _getShowName();
    if (jsonMap != null) {
      final content = jsonMap["content"] as Map<String, dynamic>?;

      if (content != null) {
        final model = CustomGroupTipMessageModel.fromJson(content);
        switch (model.type) {
          case 1:
            _lastMessageDesc = "${showName}${TIM_getCurrentDeviceLocale().contains("zh") ? "修改群名为" : " changed group name to"} ${model.target}";
            break;
          default:
            break;
        }
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

class CustomGroupTipMessageModel {
  final String target;
  // 1: 修改群名， 2: 修改允许群成员添加好友
  final int type;

  CustomGroupTipMessageModel({
    required this.target,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "target": target,
      "type": type,
    };
  }

  factory CustomGroupTipMessageModel.fromJson(Map<String, dynamic> json) {
    return CustomGroupTipMessageModel(
      target: json["target"],
      type: json["type"],
    );
  }
}

import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/user/user_detail_model.dart';
import 'package:bee_chat/pages/assets/assets_voices_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

///set消息提示设置
///showPreview 通知显示消息预览
///showSound  声音提醒
///sound 提示音
///vibration 是否震动
class AppNoticeSetting {
  bool? showPreview;
  bool? showSound;
  SoundsType sound;
  bool? vibration;

  AppNoticeSetting(
      {this.showPreview = false, this.showSound = false, this.sound = SoundsType.defaultSound, this.vibration = false});


  AppNoticeSetting copyWith({
    bool? showPreview,
    bool? showSound,
    SoundsType? sound,
    bool? vibration,
  }) {
    return AppNoticeSetting(
      showPreview: showPreview ?? this.showPreview,
      showSound: showSound ?? this.showSound,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showPreview': showPreview,
      'showSound': showSound,
      'sound': sound?.index,
      'vibration': vibration,
    };
  }

  static AppNoticeSetting? fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return AppNoticeSetting(
      showPreview: null == (temp = map['showPreview'])
          ? null
          : (temp is bool ? temp : (temp is num ? 0 != temp.toInt() : ('true' == temp.toString()))),
      showSound: null == (temp = map['showSound'])
          ? null
          : (temp is bool ? temp : (temp is num ? 0 != temp.toInt() : ('true' == temp.toString()))),
      sound: null == (temp = map['sound'])
          ? SoundsType.defaultSound
          : (temp is num ? SoundsType.values[temp.toInt()] : SoundsType.values[int.tryParse(temp)??0]),
      vibration: null == (temp = map['vibration'])
          ? null
          : (temp is bool ? temp : (temp is num ? 0 != temp.toInt() : ('true' == temp.toString()))),
    );
  }
}

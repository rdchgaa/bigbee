import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/user/user_detail_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';


///set聊天设置
///autoAccept 自动接受群组邀请
///exitDelete 退出群组时删除回话和记录
class AppChatSetting {
  bool? autoAccept;
  bool? exitDelete;

  AppChatSetting({this.exitDelete = false, this.autoAccept = false});

  AppChatSetting copyWith({
    bool? autoAccept,
    bool? exitDelete,
  }) {
    return AppChatSetting(
      autoAccept: autoAccept ?? this.autoAccept,
      exitDelete: exitDelete ?? this.exitDelete,
    );
  }


  static AppChatSetting? fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return AppChatSetting(
      autoAccept: null == (temp = map['autoAccept'])
          ? null
          : (temp is bool ? temp : (temp is num ? 0 != temp.toInt() : ('true' == temp.toString()))),
      exitDelete: null == (temp = map['exitDelete'])
          ? null
          : (temp is bool ? temp : (temp is num ? 0 != temp.toInt() : ('true' == temp.toString()))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'autoAccept': autoAccept,
      'exitDelete': exitDelete,
    };
  }

}

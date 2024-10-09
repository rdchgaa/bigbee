import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/im/custom_emoji_model.dart';
import '../net/im_net.dart';

class CustomEmojiProvider extends ChangeNotifier {
  List<CustomEmojiModel> customEmojiList = [];

  // static Future<void> setCustomEmojiList(List<CustomEmojiModel> list) async {
  //   CustomEmojiProvider provider = Provider.of<CustomEmojiProvider>(
  //       MyApp.context,
  //       listen: false);
  //   provider.customEmojiList = list;
  //   provider.notifyListeners();
  // }

  static Future<void> loadCustomEmojiList() async {
    CustomEmojiProvider provider = Provider.of<CustomEmojiProvider>(
        MyApp.context,
        listen: false);
    var res = await ImNet.customEmojiList();
    if (res.data != null) {
      print("自定义表情 - ${res.data}");
      provider.customEmojiList = res.data!;
      provider.notifyListeners();
    }
  }

}
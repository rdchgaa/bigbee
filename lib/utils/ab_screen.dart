import 'package:flutter/cupertino.dart';

import '../main.dart';

/// 屏幕工具类（为了避免每次传context，所以将context保存在MyApp中）
class ABScreen {
  static BuildContext context = MyApp.context;

  //PIXELS
  static Size get size => MediaQuery.of(context).size;

  static double get width => size.width;

  static double get height => size.height;

  static double get statusHeight => MediaQuery.of(context).padding.top;
  static double get bottomHeight => MediaQuery.of(context).padding.bottom;

  static double get navigationBarHeight =>
      44;

  static double get appBarHeight =>
      navigationBarHeight + statusHeight;

  // 375比例
  static double get scaleWidth => 375 / 375;

}

extension ABScreenExtension on num {
  double get px => this * ABScreen.scaleWidth;
}
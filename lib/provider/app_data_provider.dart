import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AppDataProvider extends ChangeNotifier {
  int defaultDynamicIndex = 1;

  static int getDynamicIndex() {
    return Provider.of<AppDataProvider>(MyApp.context, listen: false).defaultDynamicIndex;
  }

  static void setDynamicIndex(int index) {
    Provider.of<AppDataProvider>(MyApp.context, listen: false).defaultDynamicIndex = index;
  }

}
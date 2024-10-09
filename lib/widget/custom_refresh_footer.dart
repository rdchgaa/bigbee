
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../provider/theme_provider.dart';

class CustomRefreshFooter extends Footer {
  @override
  Widget contentBuilder(BuildContext context, LoadMode loadState, double pulledExtent, double loadTriggerPullDistance, double loadIndicatorExtent, AxisDirection axisDirection, bool float, Duration? completeDuration, bool enableInfiniteLoad, bool success, bool noMore) {
    final theme = AB_theme(context);
    return BallPulseHeaderWidget(linkNotifier: LinkHeaderNotifier(), color: theme.primaryColor, backgroundColor: Colors.transparent);
  }

}
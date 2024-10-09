import 'dart:io';

import 'package:bee_chat/net/common_net.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dialog/bottom_select_dialog.dart';

class BJMapNavigatorUtil {

  static showMapDialog(BuildContext context, {required Coords coords , String title = "", String content = ""}) async {
    ABLoading.show();
    final isShowGoogle = await MapLauncher.isMapAvailable(MapType.google);
    final isShowAmap = await MapLauncher.isMapAvailable(MapType.amap);
    final isShowBaidu = await MapLauncher.isMapAvailable(MapType.baidu);
    final isShowTencent = await MapLauncher.isMapAvailable(MapType.tencent);
    final GCJCoords = await CommonNet.BD09LLToGCJ(coords);
    ABLoading.dismiss();
    BottomSelectDialog.show(context, title: "导航", content: "请选择导航方式", actions: [
      if (isShowGoogle == true) BottomSelectDialogAction(
        title: "谷歌地图",
        onTap: () async {
          MapLauncher.showMarker(mapType: MapType.google, coords: GCJCoords, title: title);
        },
      ),
      if (isShowAmap == true) BottomSelectDialogAction(
        title: "高德地图",
        onTap: () async {
          MapLauncher.showMarker(mapType: MapType.amap, coords: GCJCoords, title: title);
        },
      ),
      if (isShowBaidu == true) BottomSelectDialogAction(
        title: "百度地图",
        onTap: () async {
          MapLauncher.showMarker(mapType: MapType.baidu, coords: GCJCoords, title: title);
        },
      ),
      if (isShowTencent == true) BottomSelectDialogAction(
        title: "腾讯地图",
        onTap: () async {
          MapLauncher.showMarker(mapType: MapType.tencent, coords: GCJCoords, title: title);
        },
      ),
    ]);
  }


}

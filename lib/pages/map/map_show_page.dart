import 'dart:io';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/pages/dialog/bottom_select_dialog.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:map_launcher/map_launcher.dart';

import 'map_navigator_util.dart';

class MapShowPage extends StatefulWidget {
  // 经度
  final double longitude;
  // 纬度
  final double latitude;
  // title
  final String title;
  const MapShowPage({super.key, required this.longitude, required this.latitude, required this.title});

  @override
  State<MapShowPage> createState() => _MapShowPageState();
}

class _MapShowPageState extends State<MapShowPage> {

  late BMFMapOptions _mapOptions;
  BMFMapController? _myMapController;

  @override
  void initState() {
    _mapOptions = BMFMapOptions(
      center: BMFCoordinate(widget.latitude, widget.longitude),
      zoomLevel: 12,
      mapType: BMFMapType.Standard,
      overlookEnabled: false,
      mapPadding: BMFEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    final iconPath = ABAssets.mapMarkIcon(context);
    print("iconPath - ${iconPath}");
    return Scaffold(
      appBar: ABAppBar(
        title: "地图",
      ),
      body: Container(
        color: Colors.white,
        child:Stack(
          children: [
            Positioned.fill(child: BMFMapWidget(
              onBMFMapCreated: (controller) {
                _myMapController = controller;
                /// 创建BMFMarker
                BMFMarker marker = BMFMarker.icon(
                    position: BMFCoordinate(widget.latitude, widget.longitude),
                    icon: iconPath);
                _myMapController?.addMarker(marker);
              },
              mapOptions: _mapOptions,
            )),
            // 我的位置
            Positioned(
              bottom: 10 + MediaQuery.of(context).padding.bottom,
              right: Platform.isIOS ? 16 : 70,
              child: GestureDetector(
                onTap: () {
                  BJMapNavigatorUtil.showMapDialog(context, coords: Coords(widget.latitude, widget.longitude), title: widget.title);
                  return;
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.navigation_rounded,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getInstalledMap() async {
    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
    await availableMaps.first.showMarker(
      coords: Coords(widget.latitude, widget.longitude),
      title: widget.title,
    );
  }


}

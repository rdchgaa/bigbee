import 'dart:io';
import 'dart:math';

import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';

import '../splash_page.dart';

class MapSelectPage extends StatefulWidget {
  final String? rightBtnTitle;

  const MapSelectPage({super.key, this.rightBtnTitle});

  @override
  State<MapSelectPage> createState() => _MapSelectPageState();
}

class _MapSelectPageState extends State<MapSelectPage> with TickerProviderStateMixin  {
  final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();
  BMFMapController? _myMapController;
  BaiduLocation? _location;
  /// 我的位置
  BaiduLocation? _userLocation;
  /// 定位点样式
  BMFUserLocationDisplayParam? _displayParam;
  late AnimationController _shakeController;
  List<BMFPoiInfo> _pois = [];
  BMFPoiInfo? _selectedPoi;
  bool _isNeedSetLocation = true;



  final BMFMapOptions _mapOptions = BMFMapOptions(
      center: BMFCoordinate(39.917215, 116.380341),
      zoomLevel: 12,
      mapPadding: BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0));

  @override
  void initState() {
    super.initState();
    _locationAction();
    _shakeController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _shakeController.addListener(() {
      if (_shakeController.status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }
  @override
  void dispose() {
    _myLocPlugin.stopLocation();
    // _myLocPlugin.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: '地图选择',
        rightWidget: _selectedPoi == null ? null : IconButton(
          onPressed: () async {
            ABRoute.pop(result: _selectedPoi);
          },
          tooltip: 'Back',
          padding: EdgeInsets.only(right: 16.px),
          icon: Text(
            widget.rightBtnTitle ?? AB_S().completed,
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 16.px,
            ),
          ),
        ),
      ),
      body: Container(
        color: theme.white,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: BMFMapWidget(
                    onBMFMapCreated: (controller) {
                      print('mapDidLoad-地图加载完成');
                      _myMapController = controller;
                      _myMapController?.showUserLocation(true);
                      _loadCallback();
                    },
                    mapOptions: _mapOptions,
                  )),
                  Center(
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: 80,
                      child: AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          final sineValue =
                          sin(2 * pi * _shakeController.value);
                          return Transform.translate(
                            offset: Offset(0, sineValue * 6),
                            child: child,
                          );
                        },
                        child: Icon(
                          Icons.location_on,
                          color: Color(0xFF0090FF),
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  // 我的位置
                  Positioned(
                    bottom: 10,
                    right: Platform.isIOS ? 16 : 70,
                    child: GestureDetector(
                      onTap: () {
                        _shakeController.forward();
                        // _startLocation();
                        _location = _userLocation;
                        _refreshMap();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.white,
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
                          Icons.my_location,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: 340,
                decoration: BoxDecoration(
                  color: theme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    // // 搜索框
                    // InkWell(
                    //   onTap: () async {
                    //     // final result = await NavigatorUtils.pushRoute(context, BJMapSearchRoute());
                    //     // if(result != null) {
                    //     //   final poi = result as MapSearchResultEntity;
                    //     //   NavigatorUtils.goBackWithParams(context, poi);
                    //     // }
                    //
                    //   },
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     height: 36,
                    //     margin:  EdgeInsets.only(left: 16.px, right: 16.px, top: 6, bottom: 6),
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey[200],
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: const [
                    //         Icon(
                    //           Icons.search,
                    //           size: 20,
                    //           color: Colors.grey,
                    //         ),
                    //         Text(
                    //           "搜索",
                    //           style: TextStyle(color: Colors.grey, fontSize: 14
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 12.px),
                    // 结果列表
                    Expanded(
                      child: ListView.builder(
                        itemCount: _pois.length,
                        itemBuilder: (context, index) {
                          final poi = _pois[index];
                          return InkWell(
                            onTap: () async {
                              setState(() {
                                _selectedPoi = poi;
                              });

                            },
                            child: getResultCell(poi),
                          );
                        },
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: const ABAppBar(
        title: '地图选择',
      ),
      body: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BMFMapWidget(
          onBMFMapCreated: (controller) {
            print('mapDidLoad-地图加载完成');
            _myMapController = controller;
            _myMapController?.showUserLocation(true);
            _loadCallback();
          },
          mapOptions: _mapOptions,
        ),
      ),
    );
  }


  Widget getResultCell(BMFPoiInfo poi) {
    final theme = AB_theme(context);
    return Container(
      margin: EdgeInsets.only(left: 16.px, right: 16.px),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: theme.primaryColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.px,),

                  Text(
                    (poi.name?.isNotEmpty == true) ? poi.name! : AB_S().location,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Expanded(
                    child: Text(
                      (poi.address?.isNotEmpty == true) ? poi.address! : AB_S().unknown,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textGrey,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.px,),
                ],
              ),
            ),
            if (poi.uid == _selectedPoi?.uid) Icon(Icons.check, color: theme.primaryColor),
          ],
        ),
      ),
    );
  }


  _loadCallback(){
    /// 地图区域改变完成后会调用此接口
    /// mapStatus 地图状态信息
    _myMapController?.setMapRegionDidChangeWithReasonCallback(
        callback: (BMFMapStatus mapStatus, BMFRegionChangeReason regionChangeReason) {
          print("地图区域改变完成 - ${mapStatus.targetGeoPt?.longitude} - ${mapStatus.targetGeoPt?.latitude}");
          _location = BaiduLocation(
            longitude: mapStatus.targetGeoPt?.longitude,
            latitude: mapStatus.targetGeoPt?.latitude
          );
          _shakeController.forward();
          _searchPoi();
        });
  }

  _locationAction() async {

    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (!hasLocationPermission) {
      return;
    }

    /* 接受定位回调 */
    _myLocPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
      setState(() {
        print("定位结果：${result.latitude}, ${result.longitude}");
        _userLocation = result;
        _refreshUserLocationMap();
      });
    });

    Map iosMap = initIOSOptions().getMap();
    Map androidMap = initAndroidOptions().getMap();
    final res = await _myLocPlugin.prepareLoc(androidMap, iosMap);
    if (!res) {
      print("定位配置失败");
      return;
    }
    print("定位配置成功");
    final res1 = await _myLocPlugin.startLocation();
    if (!res1) {
      print("定位失败");
    }
    print("定位开始 - $res1");
  }

  BaiduLocationAndroidOption initAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
      // 定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
        locationMode: BMFLocationMode.hightAccuracy,
        // 是否需要返回地址信息
        isNeedAddress: true,
        // 是否需要返回海拔高度信息
        isNeedAltitude: true,
        // 是否需要返回周边poi信息
        isNeedLocationPoiList: true,
        // 是否需要返回新版本rgc信息
        isNeedNewVersionRgc: true,
        // 是否需要返回位置描述信息
        isNeedLocationDescribe: true,
        // 是否使用gps
        openGps: true,
        // 可选，设置场景定位参数，包括签到场景、运动场景、出行场景
        locationPurpose: BMFLocationPurpose.sport,
        // 坐标系
        coordType: BMFLocationCoordType.bd09ll,
        // 设置发起定位请求的间隔，int类型，单位ms
        // 如果设置为0，则代表单次定位，即仅定位一次，默认为0
        scanspan: 4000
    );
    return options;
  }

  BaiduLocationIOSOption initIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
      // 坐标系
      coordType: BMFLocationCoordType.bd09ll,
      // 位置获取超时时间
      locationTimeout: 10,
      // 获取地址信息超时时间
      reGeocodeTimeout: 10,
      // 应用位置类型 默认为automotiveNavigation
      activityType: BMFActivityType.automotiveNavigation,
      // 设置预期精度参数 默认为best
      desiredAccuracy: BMFDesiredAccuracy.best,
      // 是否需要最新版本rgc数据
      isNeedNewVersionRgc: true,
      // 指定定位是否会被系统自动暂停
      pausesLocationUpdatesAutomatically: false,
      // 指定是否允许后台定位,
      // 允许的话是可以进行后台定位的，但需要项目
      // 配置允许后台定位，否则会报错，具体参考开发文档
      allowsBackgroundLocationUpdates: false,
      // 设定定位的最小更新距离
      distanceFilter: 10,
    );
    return options;
  }

  _refreshMap() {
    _myMapController?.updateMapOptions(BMFMapOptions(
      center: BMFCoordinate(_location?.latitude ?? 0, _location?.longitude ?? 0),
    ));
    _searchPoi();
  }

  _refreshUserLocationMap() {
    print("刷新地图 - ${_userLocation} - ${_myMapController}");
    print("是否需要设置定位点 - $_isNeedSetLocation");
    if (_isNeedSetLocation) {
      _isNeedSetLocation = false;
      _location = _userLocation;
      _refreshMap();
    }
    // if (_location == null) {
    //   _location = _userLocation;
    //   _refreshMap();
    // }

    if (_userLocation != null && _myMapController != null) {
      BMFCoordinate coordinate = BMFCoordinate(_userLocation!.latitude ?? 0, _userLocation!.longitude ?? 0);
      BMFLocation location = BMFLocation(
          coordinate: coordinate,
          altitude: _userLocation!.altitude,
          horizontalAccuracy: _userLocation!.horizontalAccuracy,
          verticalAccuracy: _userLocation!.verticalAccuracy,
          speed: _userLocation!.speed,
          course: _userLocation!.course);
      BMFUserLocation userLocation = BMFUserLocation(
        location: location,
      );
      _myMapController!.updateLocationData(userLocation);
      _updatUserLocationDisplayParam();
    }
  }

  /// 更新定位图层样式
  void _updatUserLocationDisplayParam() {
    final theme = AB_T();
    BMFUserLocationDisplayParam displayParam = BMFUserLocationDisplayParam(
      locationViewOffsetX: 0,
      locationViewOffsetY: 0,
      isLocationArrowStyleCustom: true,
      enableDirection: false,
      userTrackingMode: BMFUserTrackingMode.Heading,
      accuracyCircleFillColor: theme.primaryColor,
      accuracyCircleStrokeColor: Colors.blue,
      // isAccuracyCircleShow: true,
      locationViewHierarchy:
      BMFLocationViewHierarchy.LOCATION_VIEW_HIERARCHY_BOTTOM,
      accuracyCircleBorderWidth: 1,
      // locationViewImageNew: 'resoures/icon_car.png',
      locationViewImage: "assets/images/common/user_location.png",
      locationViewImageSizeScale: 0.5,
      // breatheEffectOpenForWholeStyle: true,
      // locationViewCenterGifImageFilePath: 'resoures/6.gif',
      // locationViewCenterImageSizeScale: 1.5,
    );
    print("更新样式6");
    _displayParam = displayParam;
    _myMapController?.updateLocationViewWithParam(_displayParam!);
  }


  _searchPoi() async {
    print("检索poi");
//     // 构造检索参数
//     BMFPoiNearbySearchOption poiNearbySearchOption =
//     BMFPoiNearbySearchOption(
//         keywords: <String>['小吃', '酒店'],
//         location: BMFCoordinate(40.049557, 116.279295),
//         radius: 1000,
//         isRadiusLimit: true);
// // 检索实例
//     BMFPoiNearbySearch nearbySearch = BMFPoiNearbySearch();
// // 检索回调
//     nearbySearch.onGetPoiNearbySearchResult(callback:
//         (BMFPoiSearchResult result, BMFSearchErrorCode errorCode) {
//       print("poi周边检索回调 errorCode = ${errorCode}, result = ${result?.toMap()}");
//       // 解析reslut，具体参考demo
//     });
// // 发起检索
//     bool flag = await nearbySearch.poiNearbySearch(poiNearbySearchOption);
    _codeAddress();
  }


 _codeAddress() async {
   // 构造检索参数
   BMFReverseGeoCodeSearchOption reverseGeoCodeSearchOption =
   BMFReverseGeoCodeSearchOption(
       location: BMFCoordinate(_location?.latitude ?? 0, _location?.longitude ?? 0));
   // 检索实例
   BMFReverseGeoCodeSearch reverseGeoCodeSearch = BMFReverseGeoCodeSearch();
// 逆地理编码回调
   reverseGeoCodeSearch.onGetReverseGeoCodeSearchResult(callback:
       (BMFReverseGeoCodeSearchResult result,
       BMFSearchErrorCode errorCode) {
     _pois = result.poiList ?? [];
     if (_pois.isEmpty) {
       final p = BMFPoiInfo(
         name: result.address ?? '',
         address: result.address ?? '',
         pt: result.location,
         uid: "self",
         province: result.addressDetail?.province ?? '',
         city: result.addressDetail?.city ?? '',
           area: result.addressDetail?.district ?? '',
           adcode: result.addressDetail?.adCode ?? '',
       );
       _pois = [p];
     }

     _selectedPoi = _pois.firstOrNull;
     setState(() {});
     print("逆地理编码  errorCode = ${errorCode}, result = ${result?.toMap()}");
     // 解析reslut，具体参考demo
   });
// 发起检索
   bool flag = await reverseGeoCodeSearch.reverseGeoCodeSearch(reverseGeoCodeSearchOption);
 }

}

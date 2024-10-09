

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';

/// 申请定位权限
/// 授予定位权限返回true， 否则返回false
Future<bool> requestLocationPermission() async {

  //获取当前的权限
  var status = await Permission.location.status;
  print("当前的权限 - $status");
  if (status == PermissionStatus.granted) {
    //已经授权
    return true;
  } else {
    //未授权则发起一次申请
    status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}


/// 申请相册权限
/// 授予定位权限返回true， 否则返回false
Future<bool> requestPhotoPermission() async {

  if(PlatformUtils().isAndroid){
    if(await getAndroidApiLevel() <= 32){
      //获取当前的权限
      var status = await Permission.storage.status;
      print("当前的权限 - $status");
      if (status == PermissionStatus.granted) {
        //已经授权
        return true;
      } else {
        //未授权则发起一次申请
        status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }
  //获取当前的权限
  var status = await Permission.photos.status;
  print("当前的权限 - $status");
  if (status == PermissionStatus.granted) {
    //已经授权
    return true;
  } else {
    //未授权则发起一次申请
    status = await Permission.photos.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

Future<void> getAppAndDeviceInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  int apiLevel = androidInfo.version.sdkInt;

  print('App Name: $appName');
  print('Package Name: $packageName');
  print('Version: $version');
  print('Build Number: $buildNumber');
  print('Android API Level: $apiLevel');
}

Future<int> getAndroidApiLevel() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  int apiLevel = androidInfo.version.sdkInt;

  print('Android API Level: $apiLevel');
  return apiLevel;
}

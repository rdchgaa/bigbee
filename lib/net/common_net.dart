import 'package:dio/dio.dart';
import 'package:map_launcher/map_launcher.dart';

import '../models/common/captcha_image_model.dart';
import '../models/common/launch_splash_model.dart';
import '../models/common/test_model.dart';
import '../models/common/upload_sign_model.dart';
import '../models/common/version_list_model.dart';
import '../utils/net/ab_Net.dart';
import '../utils/net/net_model.dart';
import 'api.dart';

class CommonNet {

  /* 获取谷歌验证的密钥(用于绑定谷歌验证)
  * */
  static Future<RequestResult<String>> getSecretKey(){
    return ABNet.request(path: getSecretKeyApi, method: HttpMethod.get);
  }

  /* 验证 code 是否正确
  * code: 验证码
  * */
  static Future<RequestResult<bool>> codeCheckSuccessCode({required String code}){
    return ABNet.request(path: checkSuccessCode, method: HttpMethod.get, params: {
      "code": code
    });
  }

  /* 获取图形验证码（注册/登录）
  * */
  static Future<RequestResult<CaptchaImageModel>> getCaptchaImage(){
    return ABNet.request(path: captchaImageApi, method: HttpMethod.get, isShowTip: false);
  }

  /* 获取启动页数据
  * */
  static Future<RequestResult<LaunchSplashModel>> getLaunchSplash(){
    return ABNet.request(path: getLaunchSplashApi, method: HttpMethod.get, isShowTip: false);
  }

  /* 获取版本列表
  * systemType: 1: iOS 2: Android
  * */
  static Future<RequestResult<List<VersionListModel>>> getVersionList(int systemType){
    return ABNet.request(path: getVersionListApi, method: HttpMethod.get, params: {
      "systemType": systemType
    });
  }

  /* 上传OSS-获取凭证（不验证签名）
  * fileSuf: 文件后缀
  * */
  static Future<RequestResult<UploadSignModel>> getOssToken({required String fileSuf}){
    return ABNet.request(path: getOssTokenApi, method: HttpMethod.post, params: {
      "fileSuf": fileSuf
    });
  }


  
  static Future<RequestResult<List<TestModel>>> test(){
    return ABNet.request(path: "/client-api/test/testList", method: HttpMethod.get);
  }

  static Future<Coords> BD09LLToGCJ(Coords coords) async {
    final url = "https://api.map.baidu.com/geoconv/v2/?coords=${coords.longitude},${coords.latitude}&model=5&ak=IkFFrIXgi7fza7ka8aVVi76cPZryVz7v";
    Response response = await Dio(BaseOptions()).get(url);
    print("坐标转换 $response");
    try {
      return Coords(response.data["result"][0]["y"], response.data["result"][0]["x"]);
    } catch (e) {
      return Future.value(coords);
    }
  }

}
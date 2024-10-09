import 'dart:convert';
import 'dart:io';

import 'package:bee_chat/models/baidu_map/reverse_geocoding_result_model.dart';
import 'package:bee_chat/models/dynamic/dynamic_publish_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/dialog/bottom_select_dialog.dart';
import 'package:bee_chat/pages/dialog/select_users_dialog.dart';
import 'package:bee_chat/pages/dynamic/dynamic_publish_permissions_page.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_follow_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/dynamic_hot_widget.dart';
import 'package:bee_chat/pages/dynamic/widget/emoji_input_widget.dart';
import 'package:bee_chat/pages/map/map_select_page.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/common_util.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/utils/oss_utils.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';

// import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitChat/TIMUIKitTextField/tim_uikit_text_field_layout/narrow.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/widgets/link_text.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../widget/ab_text.dart';
import '../contact/contact_page.dart';
import '../conversation/conversation_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

class DynamicPublishPage extends StatefulWidget {
  const DynamicPublishPage({super.key});

  @override
  State<DynamicPublishPage> createState() => _DynamicPublishPageState();
}

class _DynamicPublishPageState extends State<DynamicPublishPage> {
  List<AssetEntity> selectedAssets = [];

  ScrollController controller = ScrollController();

  bool showEmoji = false;

  String infoText = '';

  List<ContactInfo> userList = [];

  DynamicPublishPermissionsModel permissionsModel = DynamicPublishPermissionsModel();

  String? _longitude;

  String? _latitude;

  String? _address;
  String? _city;

  @override
  void initState() {
    super.initState();
    // _determinePosition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // /// 位置服务
  // Future _determinePosition() async {
  //   // 设置 Android 定位策略为高精度：
  //   final locationService = MethodChannel('flutter.baseflow.com/geolocator/location_service');
  //   locationService.invokeMethod('setLocationSettings', <String, dynamic>{
  //     'locationMode': 1, // 高精度
  //   });
  //
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   double longitude = 0;
  //   double latitude = 0;
  //   try {
  //     /// 手机GPS服务是否已启用。
  //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       //定位服务未启用，要求用户启用定位服务
  //       var res = await Geolocator.openLocationSettings();
  //       if (!res) {
  //         /// 被拒绝
  //         return;
  //       }
  //     }
  //
  //     /// 是否允许app访问地理位置
  //     permission = await Geolocator.checkPermission();
  //
  //     if (permission == LocationPermission.denied) {
  //       /// 之前访问设备位置的权限被拒绝，重新申请权限
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
  //         /// 再次被拒绝。根据Android指南，你的应用现在应该显示一个解释性UI。
  //         return;
  //       }
  //     } else if (permission == LocationPermission.deniedForever) {
  //       /// 之前权限被永久拒绝，打开app权限设置页面
  //       await Geolocator.openAppSettings();
  //       return;
  //     }
  //
  //     /// 允许访问地理位置，获取地理位置
  //     Position? position = await Geolocator.getCurrentPosition(timeLimit: Duration(seconds: 5));
  //     longitude = position.longitude;
  //     latitude = position.latitude;
  //     setState(() {
  //       _longitude = longitude.toString();
  //       _latitude = latitude.toString();
  //     });
  //     print('-------------------------11----$longitude-------$latitude');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  addImage(BuildContext context, {bool? onlyImage = false}) async {
    AssetPickerResultData? assetsData = await CommonUtil.selectImages(
      context,
      maxAssets: 9 - selectedAssets.length,
      isDynamic: true,
      requestType: onlyImage == true ? RequestType.image : RequestType.common,
    );

    if (assetsData != null && assetsData.assets.isNotEmpty) {
      //判断文件大小
      for (var i = 0; i < assetsData.assets.length; i++) {
        var asset = assetsData.assets[i];
        File? file = await asset.file;
        int? fileSize = await file?.length();
        if (fileSize != null && fileSize > 1024 * 1024 * 100) {
          ABToast.show(AB_S().imageVideoNot100MB, toastType: ToastType.fail);
          return;
        }
      }

      selectedAssets.addAll(assetsData.assets);
    }

    setState(() {});
  }

  goBack() async {
    if (infoText == '' && selectedAssets.isEmpty) {
      ABRoute.pop(context: context);
      return;
    }
    BottomSelectDialog.show(
      context,
      actions: [
        BottomSelectDialogAction(
            title: AB_S().saveDraft,
            onTap: () async {
              setState(() {});
              await submit(status: 1);
            }),
        BottomSelectDialogAction(
            title: AB_S().notSave,
            onTap: () async {
              ABRoute.pop(context: context);
            })
      ],
      isShowCancel: true,
    );
  }

  ///status 1:草稿  2发布
  submit({int status = 2}) async {
    ABLoading.show();
    _city = await _getCity();
    var (imgeUrls, videoUrl) = await getMediaUrls();
    //发布类型0未填写，（1：纯文字、2：文字图片、3：文字视频、4：纯图片、5：纯视频）
    var trendsType = getTrendsType(imgeUrls, videoUrl);
    if (trendsType == 0) {
      ABLoading.dismiss();
      ABToast.show(AB_S().pleaseSelect);
      return;
    }
    DynamicPublishModel model = DynamicPublishModel(
      trendsType: trendsType,
      textContent: infoText,
      imgeUrls: imgeUrls ?? '',
      videoUrl: videoUrl ?? '',
      addrName: _city ?? '',
      addrAddress: _address ?? '',
      addrLongitude: _longitude ?? '',
      addrLatitude: _latitude ?? '',
      showType: permissionsModel.visibleRange ?? 1,
      isDownload: permissionsModel.notDownload ?? 1,
      isShare: permissionsModel.notShare ?? 1,
      commentScope: permissionsModel.commentType ?? 1,
      memberNums: getNotUserList(),
      status: status,
    );
    var resultRecords = await DynamicsNet.dynamicsPostsPublish(model);
    ABLoading.dismiss();
    if (resultRecords.success == true) {
      ABToast.show(AB_S().success, toastType: ToastType.success);
      ABRoute.pop(context: context);
    } else {
      ABToast.show(resultRecords.message ?? '', toastType: ToastType.fail);
    }
  }

  List<String> getNotUserList() {
    List<String> text = [];
    if (permissionsModel.visibleRangeNotUser != null) {
      for (var i = 0; i < permissionsModel.visibleRangeNotUser!.length; i++) {
        ContactInfo user = permissionsModel.visibleRangeNotUser![i];
        text.add(user.friendInfo.userID);
      }
    } else {}
    return text;
  }

  int getTrendsType(imgeUrls, videourl) {
    int trendsType = 1; //发布类型（1：纯文字、2：文字图片、3：文字视频、4：纯图片、5：纯视频）
    if (infoText != '') {
      if (videourl != '') {
        if ((imgeUrls != '')) {
          trendsType = 3;
        } else {
          trendsType = 3;
        }
      } else {
        if ((imgeUrls != '')) {
          trendsType = 2;
        } else {
          trendsType = 1;
        }
      }
    } else {
      if (videourl != '') {
        if ((imgeUrls != '')) {
          trendsType = 5;
        } else {
          trendsType = 5;
        }
      } else {
        if ((imgeUrls != '')) {
          trendsType = 4;
        } else {
          trendsType = 0;
        }
      }
    }
    return trendsType;
  }

  Future<(String, String)> getMediaUrls1() async {
    var imgeUrls = '';
    var videoUrl = '';
    ABLoading.show();
    for (var i = 0; i < selectedAssets.length; i++) {
      AssetEntity item = selectedAssets[i];
      File? file = await item.file;
      if (file == null) continue;
      final (url, message) = await OssUtils.uploadToOss(path: file.path);
      if (url == null) {
        ABToast.show(message);
        continue;
      }
      if (item.type == AssetType.image) {
        if (i == 0) {
          imgeUrls = imgeUrls + url;
        } else {
          imgeUrls = '$imgeUrls;$url';
        }
      } else if (item.type == AssetType.video) {
        if (i == 0) {
          videoUrl = videoUrl + url;
        } else {
          videoUrl = '$videoUrl;$url';
        }
      }
    }
    await ABLoading.dismiss();
    return (imgeUrls, videoUrl);
  }

  Future<(String, String)> getMediaUrls() async {
    var imgeUrls = '';
    var videoUrl = '';
    if (selectedAssets.isEmpty) {
      return ('', '');
    }
    ABLoading.show();
    if (selectedAssets.first.type == AssetType.video) {
      File? file = await selectedAssets.first.file;
      final (url, message) = await OssUtils.uploadToOss(path: file!.path);
      await ABLoading.dismiss();
      if (url == null) {
        return ('', '');
      } else {
        return ('', url);
      }
    }

    List<String> paths = [];
    for (var i = 0; i < selectedAssets.length; i++) {
      AssetEntity item = selectedAssets[i];
      File? file = await item.file;
      if (file == null) continue;
      paths.add(file.path);
    }
    final res = await OssUtils.uploadMultiFilesToOss(paths: paths);
    await ABLoading.dismiss();
    if (res.$1.isEmpty) {
      ABToast.show(res.$2);
      return Future.value(("", ""));
    } else {
      final images = res.$1.join(';');
      return (images, videoUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(
      context,
    );
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        goBack();
      },
      child: Scaffold(
        appBar: ABAppBar(
          navigationBarHeight: 60.px,
          backIconCenter: true,
          title: AB_getS(context).setting,
          backgroundWidget: Container(
            // 渐变色
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  HexColor("#FFDC79"),
                  HexColor("#FFCB32"),
                ],
              ),
            ),
          ),
          leftWidget: Padding(
            padding: EdgeInsets.only(left: 16.0.px),
            child: IconButton(
              onPressed: () async {
                goBack();
              },
              padding: EdgeInsets.only(right: 16.px),
              icon: ABText(AB_getS(context).cancel),
            ),
          ),
          rightWidget: IconButton(
            onPressed: () async {
              submit();
            },
            tooltip: 'info',
            padding: EdgeInsets.only(right: 16.px),
            icon: ABText(AB_getS(context).push),
          ),
        ),
        backgroundColor: theme.backgroundColor,
        body: LayoutBuilder(builder: (context, con) {
          return SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                SizedBox(
                  height: 26.px,
                ),
                SizedBox(
                  width: con.maxWidth,
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.px),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //设置列数
                      crossAxisCount: 3,
                      //设置横向间距
                      crossAxisSpacing: 16.px,
                      //设置主轴间距
                      mainAxisSpacing: 16.px,
                      childAspectRatio: 1,
                    ),
                    shrinkWrap: true,
                    // 避免内部子项的尺寸影响外部容器的高度
                    itemCount: selectedAssets.length >= 9 ? 9 : (selectedAssets.length + 1),
                    // 总共20个项目
                    itemBuilder: (context, index) {
                      return bottomDetailItemBuilder(context, index);
                    },
                  ),
                ),
                // Size
                emojiWidget(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget emojiWidget() {
    return EmojiInputWidget(
        padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
        hintText: AB_S().recordYourLife,
        scrollDirection: Axis.vertical,
        childCenter: selectBuild(),
        inputHeight: 110.px,
        showRecentEmo: true,
        recentEmoText: AB_S().recentlyUsed,
        allEmoText: AB_S().allExpressions,
        onChange: (value) {
          infoText = value;
          setState(() {});
        },
        goDownBottom: () {
          setState(() {
            showEmoji = !showEmoji;
          });
          if (showEmoji) {
            Future.delayed(Duration(milliseconds: 800), () {
              if (mounted) {
                controller.animateTo(controller.position.maxScrollExtent,
                    duration: Duration(milliseconds: 200), curve: Curves.linear);
              }
            });
          }
        });
  }

  Widget selectBuild() {
    return Padding(
      padding: EdgeInsets.only(top: 18.0.px, bottom: 5.0.px, left: 8, right: 8),
      child: Column(
        children: [
          setButtonItem(ABAssets.dynamicAddress(context), _address ?? AB_getS(context).whereYou, () async {
            BMFPoiInfo? info = await ABRoute.push(MapSelectPage());
            if (info != null) {
              _address = info.address;
              _city = info.city;
              _longitude = info.pt?.longitude.toString();
              _latitude = info.pt?.latitude.toString();
              setState(() {});
            }
            // ABRoute.push(ShareUserPage());
          }),
          if (false)
            Builder(builder: (context) {
              var text = '';
              if (userList.isNotEmpty) {
                for (var i = 0; i < userList.length; i++) {
                  ContactInfo user = userList[i];
                  if (i == 0) {
                    text = '$text${user.name}';
                  } else {
                    text = '$text, ${user.name}';
                  }
                }
              } else {
                text = AB_getS(context).recommendToContacts;
              }
              return setButtonItem('', text, () async {
                List<ContactInfo>? list = await showSelectUsersDialog(context, title: AB_S().remindWhoWatch);
                if (list != null) {
                  userList = list;
                  setState(() {});
                }
              },
                  leftImage: Padding(
                    padding: EdgeInsets.only(left: 0.0.px, right: 16.px),
                    child: SizedBox(
                      width: 22.px,
                      height: 22.px,
                      child: Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color(0xff989897), borderRadius: BorderRadius.all(Radius.circular(11))),
                          child: SizedBox(
                            width: 18.px,
                            height: 18.px,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text('@', style: TextStyle(color: AB_theme(context).white, fontSize: 12)),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ));
            }),
          setButtonItem(
              ABAssets.dynamicEye(context), permissionsModel.getVisibleRangeText(value: permissionsModel.visibleRange),
              () async {
            DynamicPublishPermissionsModel? value = await ABRoute.push(DynamicPublishPermissionsPage());
            if (value != null) {
              permissionsModel = value;
              setState(() {});
            }

            //展示方式（1：所有人可见、2：仅主页可见、3、仅陌生人可见、4：仅自己可见、5：仅动态广场可见、6：不给Ta看）
          }),
        ],
      ),
    );
  }

  Widget setButtonItem(String assets, String title, Function onTap, {bool showLine = false, Widget? leftImage}) {
    final theme = AB_theme(context);
    return InkWell(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56.px,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        leftImage ??
                            Padding(
                              padding: EdgeInsets.only(left: 0.0.px, right: 16.px),
                              child: SizedBox(
                                width: 22.px,
                                height: 22.px,
                                child: Image.asset(
                                  assets,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        Expanded(
                          child: ABText(
                            title,
                            fontSize: 14.px,
                            overflow: TextOverflow.ellipsis,
                            textColor: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.px),
                    child: Image.asset(
                      ABAssets.assetsRight(context),
                      width: 9.px,
                      height: 15.px,
                    ),
                  )
                ],
              ),
            ),
            showLine
                ? Padding(
                    padding: EdgeInsets.only(left: 16.0.px, right: 16.0.px),
                    child: Divider(
                      height: 1,
                      color: theme.grey.withOpacity(0.6),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget bottomDetailItemBuilder(BuildContext context, int index) {
    if (selectedAssets.length == index) {
      if (selectedAssets.length >= 9) {
        return SizedBox();
      }
      var hasVideo = false;
      for (AssetEntity asset in selectedAssets) {
        if (asset.type == AssetType.video) {
          hasVideo = true;
        }
      }
      if (hasVideo) {
        return SizedBox();
      }

      var hasImage = false;
      for (AssetEntity asset in selectedAssets) {
        if (asset.type == AssetType.image) {
          hasImage = true;
        }
      }

      return InkWell(
          onTap: () {
            addImage(context, onlyImage: hasImage);
          },
          child: Image.asset(
            ABAssets.dynamicAdd(context),
            width: 84,
            height: 84,
          ));
    }

    void onTap(AssetEntity asset) {
      final int page;
    }

    return SizedBox(
      width: 84.px,
      height: 84.px,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Builder(builder: (context) {
          final AssetEntity asset = selectedAssets.elementAt(index);
          final Widget item = switch (asset.type) {
            AssetType.image => _imagePreviewItem(asset),
            AssetType.video => _videoPreviewItem(asset),
            // AssetType.audio => _audioPreviewItem(asset),
            AssetType.audio => const SizedBox.shrink(),
            AssetType.other => const SizedBox.shrink(),
          };
          return Semantics(
            label: 'image',
            onTap: () => onTap(asset),
            onTapHint: 'image',
            excludeSemantics: true,
            child: GestureDetector(
              onTap: () => onTap(asset),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Stack(
                  children: <Widget>[
                    item,
                    AnimatedContainer(
                      duration: kThemeAnimationDuration,
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: InkWell(
                        onTap: () {
                          // onChangingSelected(context, asset, true);
                          selectedAssets.removeAt(index);
                          setState(() {});
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)), color: Color(0xffd9d9d9)),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _imagePreviewItem(AssetEntity asset) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: ExtendedImage(
          image: AssetEntityImageProvider(asset, isOriginal: false),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _videoPreviewItem(AssetEntity asset) {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          _imagePreviewItem(asset),
          Center(
            child: Icon(
              Icons.video_library,
              color: AB_theme(context).white.withOpacity(0.54),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _getCity() async {
    if (_city?.isNotEmpty == true) {
      return _city;
    }
    if (_longitude?.isNotEmpty == true && _latitude?.isNotEmpty == true) {
      Options requestOptions = Options();
      Response response = await Dio(BaseOptions()).get(
        "https://api.map.baidu.com/reverse_geocoding/v3/",
        queryParameters: {
          "location": "$_latitude,$_longitude",
          "ak": "e340CjAlzCx3IRW7fWVrY4Wz0rUseUxx",
          "output": "json",
          "extensions_poi": 0,
        },
        options: requestOptions,
      );
      if (response.statusCode == 200) {
        try {
          var data = jsonDecode(response.data);
          final model = ReverseGeocodingResultModel.fromJson(data);
          _city = model.result?.addressComponent?.city;
          return _city;
        } catch (e) {
          print("error:$e");
          return null;
        }
      }
      return null;
    }
    return null;
  }


}

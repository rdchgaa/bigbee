import 'dart:io';

import 'package:bee_chat/models/user/user_detail_model.dart';
import 'package:bee_chat/pages/common/text_input_page.dart';
import 'package:bee_chat/pages/mine/mine_info_my_qr_page.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_loading.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_screen.dart';
import '../../utils/ab_toast.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../utils/oss_utils.dart';
import '../../utils/photo_utils.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_image.dart';
import '../../widget/ab_text.dart';
import '../../widget/ab_text_field.dart';

const String userInfoDidChangeName = "userInfoDidChangeName";

class MineInfoEditorPage extends StatefulWidget {
  final UserDetailModel userInfo;
  final Function(UserDetailModel) updateCallback;

  const MineInfoEditorPage({super.key, required this.userInfo, required this.updateCallback});

  @override
  State<MineInfoEditorPage> createState() => _MineInfoEditorPageState();
}

class _MineInfoEditorPageState extends State<MineInfoEditorPage> {
  String? _avatarPath;
  String _userName = "";
  String _userIntroduction = "";
  UserDetailModel _userInfo = UserDetailModel();

  String userId = '';

  @override
  void initState() {
    _userInfo = widget.userInfo;
    _userName = _userInfo.nickName ?? "";
    _userIntroduction = _userInfo.profile ?? "";
    initData();
    super.initState();
  }

  initData() async {
    userId = await ABSharedPreferences.getUserId() ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    LanguageProvider languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isZh = languageProvider.locale.languageCode.contains("zh");
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).userInfo,
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
      ),
      body: ListView(
        children: [
          // 信息
          Container(
            color: theme.white,
            height: 80,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    AB_S().avatar,
                    style: TextStyle(fontSize: 16.px, color: theme.textColor),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _galleryPhoto();
                  },
                  child: SizedBox(
                    width: 50.px,
                    height: 50.px,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: (_avatarPath != null)
                          ? Image.file(File(_avatarPath!))
                          : ABImage.avatarUser(_userInfo.avatarUrl ?? ""),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.px),
                  child: SizedBox(
                    width: 9.px,
                    height: 15.px,
                    child: Image.asset(
                      ABAssets.assetsRight(context),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          setButtonItem(context, title: AB_getS(context).nickname, onTap: () async {
            final name = await ABRoute.push(TextInputPage(
              title: AB_getS(context, listen: false).nickname,
              text: _userName,
              maxLength: 16,
            )) as String?;
            if (name != null) {
              _userName = name;
              setState(() {});
              _checkUserInfo();
              // _changeGroupName(name, context1);
            }
          }, rightText: _userName),
          // const SizedBox(height: 1,),
          setButtonItem(context, title: 'ID:', onTap: () async {}, rightText: userId, showRightIcon: false),
          setButtonItem(context,
              title: AB_S().register + (isZh ? '' : ' ') + AB_S().account,
              onTap: () async {},
              rightText: _userInfo.memberName,
              showRightIcon: false),
          setButtonItem(
            context,
            title: AB_S().qrCard,
            onTap: () async {
              ABRoute.push(MineInfoMyQrPage(
                userInfo: widget.userInfo,
                userId: userId,
              ));
            },
            rightWidget: Padding(
              padding: EdgeInsets.only(left: 16.0.px, right: 2.px),
              child: SizedBox(
                width: 20.px,
                height: 20.px,
                child: Image.asset(
                  ABAssets.iconErweima(context),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          setButtonItem(context, title: AB_getS(context).introduced, onTap: () async {
            final name = await ABRoute.push(TextInputPage(
              title: AB_getS(context, listen: false).introduced,
              text: _userIntroduction,
              maxLength: 100,
            )) as String?;
            if (name != null) {
              _userIntroduction = name;
              setState(() {});
              _checkUserInfo();
            }
          }, rightText: _userIntroduction),
        ],
      ),
    );
  }

  void _checkUserInfo() async {
    if (_userName.isEmpty || _userName.length < 2 || _userName.length > 16) {
      ABToast.show(AB_getS(context, listen: false).inputNickname1);
      return;
    }
    if (_userIntroduction.length > 100) {
      ABToast.show(AB_getS(context, listen: false).introductionMoreThan);
      return;
    }

    // if(_userIntroduction.isEmpty){
    //   ABToast.show(AB_getS(context, listen: false).inputInvitedCode);
    //   return;
    // }

    final success = AB_getS(context, listen: false).changeSuccess;
    // final failed = AB_getS(context, listen: false).changeFail;

    String? faceUrl;
    // 头像改变
    if (_avatarPath != null) {
      ABLoading.show();
      final (url, message) = await OssUtils.uploadToOss(path: _avatarPath!);
      await ABLoading.dismiss();
      if (url == null) {
        ABToast.show(message);
        return;
      }
      faceUrl = url;
    }

    if (_userInfo.nickName != _userName || _userInfo.profile != _userIntroduction || faceUrl != null) {
      ABLoading.show();
      final result = await TencentImSDKPlugin.v2TIMManager.setSelfInfo(
          userFullInfo: V2TimUserFullInfo(
              nickName: _userName, role: 0, faceUrl: faceUrl ?? _userInfo.avatarUrl, selfSignature: _userIntroduction));
      await ABLoading.dismiss();
      if (result.code == 0) {
        _userInfo.nickName = _userName;
        _userInfo.profile = _userIntroduction;
        _userInfo.avatarUrl = faceUrl ?? _userInfo.avatarUrl;
        UserProvider.setUserInfo(_userInfo);
        // ABRoute.pop(result: _userInfo);
        widget.updateCallback(_userInfo);
        ABToast.show(success);
        return;
      }
      ABToast.show(result.desc);
    }
  }

  // 弹出相册与相机选择
  void _galleryPhoto() {
    final theme = AB_theme(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 180,
            width: ABScreen.width,
            child: Column(
              children: [
                CupertinoButton(
                  child: ABText(AB_getS(context, listen: false).camera, textColor: theme.textColor),
                  onPressed: () {
                    Navigator.pop(context);
                    _cameraPhoto();
                  },
                ),
                CupertinoButton(
                  child: ABText(AB_getS(context, listen: false).album, textColor: theme.textColor),
                  onPressed: () {
                    Navigator.pop(context);
                    _imageAction();
                  },
                ),
                CupertinoButton(
                  child: ABText(AB_getS(context, listen: false).cancel, textColor: theme.textGrey),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  // 相机拍照
  void _cameraPhoto() async {
    final pickerImage = await PhotoUtils.pickSinglePic(ImageFrom.camera);
    if (pickerImage != null) {
      setState(() {
        _avatarPath = pickerImage.path;
      });
      // 裁剪图片
      final croppedFile = await PhotoUtils.cropImage(
          image: File(pickerImage.path),
          aspectRatio: CropAspectRatio(
            ratioX: ABScreen.width,
            ratioY: ABScreen.width,
          ));
      if (croppedFile != null) {
        setState(() {
          _avatarPath = croppedFile.path;
        });
      }
    }
    _checkUserInfo();
  }

  // 相册选择
  void _imageAction() async {
    AssetPickerResultData? pickedAssets = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
        confirmText: AB_S().confirm,
      ),
    );
    if (pickedAssets != null && pickedAssets.assets.isNotEmpty) {
      final file = await pickedAssets.assets[0].originFile;
      if (file == null) {
        return;
      }
      setState(() {
        _avatarPath = file.path;
      });
      // 裁剪图片
      final croppedFile = await PhotoUtils.cropImage(
          image: file,
          aspectRatio: CropAspectRatio(
            ratioX: ABScreen.width,
            ratioY: ABScreen.width,
          ));
      if (croppedFile != null) {
        setState(() {
          _avatarPath = croppedFile.path;
        });
      }
    }
    _checkUserInfo();
  }
}

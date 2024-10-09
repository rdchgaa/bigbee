import 'dart:io';

import 'package:bee_chat/models/user/user_detail_model.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
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

class MineInfoEditorPageOld extends StatefulWidget {
  final UserDetailModel userInfo;
  const MineInfoEditorPageOld({super.key, required this.userInfo});

  @override
  State<MineInfoEditorPageOld> createState() => _MineInfoEditorPageOldState();
}

class _MineInfoEditorPageOldState extends State<MineInfoEditorPageOld> {

  String? _avatarPath;
  String _userName = "";
  String _userIntroduction = "";
  UserDetailModel _userInfo = UserDetailModel();


  @override
  void initState() {
    _userInfo = widget.userInfo;
    _userName = _userInfo.nickName ?? "";
    _userIntroduction = _userInfo.profile ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
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
            height: 92,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16,),
                InkWell(
                  onTap: (){
                    _galleryPhoto();
                  },
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: (_avatarPath != null) ? Image.file(File(_avatarPath!)) : ABImage.avatarUser(_userInfo.avatarUrl ?? ""),
                    ),
                  ),
                ),
                const SizedBox(width: 14,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _userInfo.nickName ?? "",
                        style: TextStyle(
                            fontSize: 18,
                            color: theme.textColor,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text("${(_userInfo.profile ?? "").isNotEmpty ? _userInfo.profile : AB_getS(context).noIntroduction}",
                          style: TextStyle(
                              fontSize: 14,
                              color: theme.textGrey))
                    ],
                  ),
                ),

                const SizedBox(width: 16,),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: theme.white,
              child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ABText("${AB_getS(context).nickname}:", textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,)),
                    const SizedBox(height: 8,),
                    // 名称输入框
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(6)
                        ),
                        height: 48,
                        child: ABTextField(
                            text: _userName,
                            hintText: AB_getS(context).nickname,
                            hintColor: theme.textGrey,
                            textColor: theme.textColor,
                            textSize: 16,
                            contentPadding: const EdgeInsets.only(bottom: 12),
                            maxLines: 1,
                            maxLength: 16,
                            onChanged: (text){
                              _userName = text;
                            })
                    ),
                    const SizedBox(height: 16,),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ABText("${AB_getS(context).introduced}:", textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,)),
                    const SizedBox(height: 8,),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: ABTextField(
                        text: _userIntroduction,
                        hintText: AB_getS(context).noIntroduction,
                        hintColor: theme.textGrey,
                        textColor: theme.textColor,
                        textSize: 16,
                        contentPadding: const EdgeInsets.all(12),
                        maxLines: 4,
                        maxLength: 100,
                        onChanged: (text){
                          _userIntroduction = text;
                        },
                      ),
                    ),
                  ]
              )
          ),
          const SizedBox(height: 20,),
          ABButton.gradientColorButton(
            text: AB_getS(context).confirm,
            colors: [theme.primaryColor, theme.secondaryColor],
            textColor: theme.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 48,
            onPressed: () {
              _checkUserInfo();
            },
          ).addPadding(padding: const EdgeInsets.symmetric(horizontal: 16))
        ],
      ),
    );
  }

  void _checkUserInfo() async{
    if(_userName.isEmpty || _userName.length < 2 || _userName.length > 16){
      ABToast.show(AB_getS(context, listen: false).inputNickname1);
      return;
    }
    if(_userIntroduction.length > 100){
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
      final result = await TencentImSDKPlugin.v2TIMManager.setSelfInfo(userFullInfo: V2TimUserFullInfo(nickName: _userName, role: 0, faceUrl: faceUrl ?? _userInfo.avatarUrl, selfSignature: _userIntroduction));
      await ABLoading.dismiss();
      if (result.code == 0) {
        _userInfo.nickName = _userName;
        _userInfo.profile = _userIntroduction;
        _userInfo.avatarUrl = faceUrl ?? _userInfo.avatarUrl;
        UserProvider.setUserInfo(_userInfo);
        ABRoute.pop(result: _userInfo);
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
      final croppedFile = await PhotoUtils.cropImage(image: File(pickerImage.path), aspectRatio: CropAspectRatio(
        ratioX: ABScreen.width,
        ratioY: ABScreen.width,
      ));
      if (croppedFile != null) {
        setState(() {
          _avatarPath = croppedFile.path;
        });
      }
    }
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
      if (file == null) {return;}
      setState(() {
        _avatarPath = file.path;
      });
      // 裁剪图片
      final croppedFile = await PhotoUtils.cropImage(image: file, aspectRatio: CropAspectRatio(
        ratioX: ABScreen.width,
        ratioY: ABScreen.width,
      ));
      if (croppedFile != null) {
        setState(() {
          _avatarPath = croppedFile.path;
        });
      }
    }
  }
}

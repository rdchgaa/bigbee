import 'dart:async';
import 'dart:io';

import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/custom_group_tip_message_data_provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_loading.dart';
import '../../utils/ab_screen.dart';
import '../../utils/ab_toast.dart';
import '../../utils/im/im_group_info_utils.dart';
import '../../utils/im/im_message_utils.dart';
import '../../utils/oss_utils.dart';
import '../../utils/photo_utils.dart';
import '../../widget/ab_button.dart';

class GroupInfoEditorPage extends StatefulWidget {
  final String groupID;
  // 主要用来发送消息的
  final TUIChatSeparateViewModel? model;
  final Function(GroupCustomInfoModel)? onGroupCustomInfoCallback;

  const GroupInfoEditorPage({super.key, required this.groupID, this.onGroupCustomInfoCallback, this.model});

  @override
  State<GroupInfoEditorPage> createState() => _GroupInfoEditorPageState();
}

class _GroupInfoEditorPageState extends State<GroupInfoEditorPage> {

  final model = TUIGroupProfileModel();
  String? _avatarPath;
  String _groupName = "";
  String _groupIntroduction = "";
  V2TimGroupInfo? _groupInfo;
  GroupCustomInfoModel _groupCustomInfo = GroupCustomInfoModel();

  @override
  void initState() {
    model.loadData(widget.groupID);
    _loadGroupCustomInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).groupInfo,
      ),
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: model),
          ],
          builder: (context, w) {
            final model = Provider.of<TUIGroupProfileModel>(context);
            final V2TimGroupInfo? groupInfo = model.groupInfo;
            if (groupInfo == null) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 20,),
              );
            }
            _groupInfo = groupInfo;
            if (_groupName.isEmpty) {
              _groupName = _groupCustomInfo.groupName.isNotEmpty ? _groupCustomInfo.groupName : (groupInfo.groupName ?? widget.groupID);
            }
            if (_groupIntroduction.isEmpty) {
              _groupIntroduction = groupInfo.introduction ?? "";
            }

            return ListView(
              children: [
                // 群信息
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  color: theme.white,
                  // height: 92,
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
                              child: (_avatarPath != null) ? Image.file(File(_avatarPath!)) : ABImage.avatarUser(groupInfo.faceUrl ?? "", isGroup: true),
                          ),
                        ),
                      ),
                      SizedBox(width: 14,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _groupCustomInfo.groupName.isNotEmpty ? _groupCustomInfo.groupName : (groupInfo.groupName ?? widget.groupID),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: theme.textColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text("${(groupInfo.introduction ?? "").isNotEmpty ? groupInfo.introduction : AB_getS(context).noIntroduction}",
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  color: theme.white,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: ABText("${AB_getS(context).groupName}:", textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,)),
                      const SizedBox(height: 8,),
                      // 群名称输入框
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              color: theme.backgroundColor,
                              borderRadius: BorderRadius.circular(6)
                          ),
                          height: 48,
                        child: ABTextField(
                            text: _groupName,
                            hintText: AB_getS(context).groupName,
                            hintColor: theme.textGrey,
                            textColor: theme.textColor,
                            textSize: 16,
                            contentPadding: EdgeInsets.only(bottom: 12),
                            maxLines: 1,
                            maxLength: 16,
                            onChanged: (text){
                          _groupName = text;
                        })
                      ),
                      const SizedBox(height: 16,),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: ABText("${AB_getS(context).groupIntroduction}:", textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,)),
                      const SizedBox(height: 8,),
                      Container(
                        // padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: ABTextField(
                          text: _groupIntroduction,
                          hintText: AB_getS(context).noIntroduction,
                          hintColor: theme.textGrey,
                          textColor: theme.textColor,
                          textSize: 16,
                          contentPadding: EdgeInsets.all(12),
                          maxLines: 4,
                          maxLength: 100,
                          onChanged: (text){
                            _groupIntroduction = text;
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
                    _checkGroupInfo();
                  },
                ).addPadding(padding: EdgeInsets.symmetric(horizontal: 16))
              ],
            );
          }),
    );
  }

  void _checkGroupInfo() async{
    if (_groupInfo == null) {
      ABRoute.pop();
      return;
    }
    if(_groupName.isEmpty){
      ABToast.show(AB_getS(context, listen: false).inputGroupName);
      return;
    }
    if(_groupIntroduction.isEmpty){
      ABToast.show(AB_getS(context, listen: false).inputGroupIntroduction);
      return;
    }

    final success = AB_getS(context, listen: false).changeSuccess;
    final failed = AB_getS(context, listen: false).changeFail;

    String? faceUrl = null;
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
    // 原群名
    final oldGroupName = _groupCustomInfo.groupName.isNotEmpty ? _groupCustomInfo.groupName : (_groupInfo?.groupName ?? widget.groupID);
    if (oldGroupName != _groupName || _groupInfo?.introduction != _groupIntroduction || faceUrl != null) {
      ABLoading.show();
      V2TimCallback? result;
      if (faceUrl != null) {
        result = await await model.setGroupFaceUrlAndIntroduction(faceUrl, _groupIntroduction);
      } else {
        result = await model.setIntroduction( _groupIntroduction);
      }
      await ABLoading.dismiss();
      if (result != null) {
        if (result.code == 0) {
          if (oldGroupName != _groupName) {
            ABLoading.show();
            // 修改群名（通过群自定义消息修改）
            final nameRes = await ImGroupInfoUtils.setGroupName(groupID: widget.groupID, groupName: _groupName);
            await ABLoading.dismiss();
            if (nameRes?.code == 0) {
              CustomGroupTipMessageModel m = CustomGroupTipMessageModel(
                target: _groupName,
                type: 1,
              );
              if (widget.model != null) {
                V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
                await ImMessageUtils.createGroupCustomTipsMessage(model: m);
                if (createCustomMessageRes.code == 0 && createCustomMessageRes.data?.id != null && createCustomMessageRes.data?.messageInfo != null) {}
                widget.model!.sendMessage(convID: widget.groupID, convType: ConvType.group, id: createCustomMessageRes.data!.id!, messageInfo: createCustomMessageRes.data!.messageInfo!);
              } else {
                ImMessageUtils.sendGroupCustomTipsMessage(groupId: widget.groupID, model: m);
              }
              
              
              _groupInfo?.groupName = _groupName;
              _groupInfo?.introduction = _groupIntroduction;
              _groupCustomInfo.groupName = _groupName;
              widget.onGroupCustomInfoCallback?.call(_groupCustomInfo);
              ABToast.show(success);
              ABRoute.pop();
            } else {
              ABToast.show(nameRes?.desc.isNotEmpty ?? false ? nameRes!.desc : failed);
              return;
            }
          } else {
            _groupInfo?.groupName = _groupName;
            _groupInfo?.introduction = _groupIntroduction;
            ABToast.show(success);
            ABRoute.pop();

          }
          return;

        } else {
          print("setGroupNameAndIntroduction failed: ${result.code} - ${result.desc}");
          ABToast.show(result.desc.isNotEmpty ? result.desc : failed);
          return;
        }
      } else {
        ABToast.show(failed);
        return;
      }
    }

  }


  // 弹出相册与相机选择
  void _galleryPhoto() {
    final theme = AB_theme(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
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
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
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

    // if (pickedAssets != null) {
    //   for (var asset in pickedAssets) {
    //     final originFile = await asset.originFile;
    //     final filePath = originFile?.path;
    //     final type = asset.type;
    //     if (filePath != null) {
    //       ABLoading.show();
    //       final (url, message) = await OssUtils.uploadToOss(path: filePath);
    //       // final url = await UploadOss.upload(file: File(filePath));
    //       await ABLoading.dismiss();
    //       if (url != null) {
    //         print("上传文件 - $url");
    //       } else {
    //         ABToast.show(message);
    //       }
    //     }
    //   }
    // }
  }

  _loadGroupCustomInfo() {
    ImGroupInfoUtils.getGroupCustomInfoModel(groupID: widget.groupID ?? "").then((value) {
      setState(() {
        _groupCustomInfo = value;
      });
    });
  }

}

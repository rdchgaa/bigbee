import 'dart:io';

import 'package:bee_chat/pages/contact/contact_page.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../provider/language_provider.dart';
import '../../utils/ab_screen.dart';
import '../../utils/ab_toast.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../utils/oss_utils.dart';
import '../../utils/photo_utils.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_text_field.dart';
import '../contact/contact_choose_page.dart';
import '../chat/group_chat_page.dart';

class GroupCreatePage extends StatefulWidget {
  const GroupCreatePage({super.key});

  @override
  State<GroupCreatePage> createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage> {

  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  String? _imagePath;
  String _groupName = "";
  String _groupDesc = "";
  bool _isPrivate = false;
  bool _isConfirm = false;

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).createGroupChat,
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
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头像
                InkWell(
                  onTap: () {
                    _galleryPhoto();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, left: 16, bottom: 10),
                    height: 84,
                    width: 84,
                    decoration: BoxDecoration(
                      color: theme.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                        ),
                      ],
                      image: _imagePath == null ? null : DecorationImage(
                        image: FileImage(File(_imagePath!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: _imagePath == null ? Center(
                      child: Text(
                        "+",
                        style: TextStyle(
                          fontSize: 48,
                          color: theme.textGrey,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ) : Container(),
                  ),
                ),
                // 填写清晰的群名称
                ABTextField(
                  text: _groupName,
                  textColor: theme.textColor,
                  hintText: AB_getS(context).inputGroupName1,
                  hintColor: Colors.grey,
                  textSize: 16,
                  fontWeight: FontWeight.w600,
                  hintFontWeight: FontWeight.w600,
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    setState(() {
                      _groupName = text;
                    });
                  },
                ).addPadding(padding: const EdgeInsets.symmetric(horizontal: 16)),
                const SizedBox(height: 8,),
                // 群简介
                ABTextField(
                  text: _groupDesc,
                  textColor: theme.textColor,
                  hintText: AB_getS(context).groupNameHintText,
                  hintColor: theme.textGrey,
                  textSize: 14,
                  keyboardType: TextInputType.text,
                  maxLength: 120,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    setState(() {
                      _groupDesc = text;
                    });
                  },
                ).addPadding(padding: const EdgeInsets.symmetric(horizontal: 16)),
                const SizedBox(height: 10,),
                // 开启确认后，加入的用户需要被管理员确认
                ABText(AB_getS(context).groupJoinConfirmationTip, textColor: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400,maxLines: 2, softWrap: true,).addPadding(padding: const EdgeInsets.symmetric(horizontal: 16)),
                _buildSwitchItem(title: AB_getS(context).groupJoinConfirmation, value: _isConfirm, onChanged: (value) {
                  setState(() {
                    _isConfirm = value;
                  });
                }),
                const SizedBox(height: 18,),
                // 开启私密后，不可被搜索。且只能被管理员邀请
                ABText(AB_getS(context).groupPrivateTip, textColor: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400,maxLines: 2, softWrap: true,).addPadding(padding: const EdgeInsets.symmetric(horizontal: 16)),
                _buildSwitchItem(title: AB_getS(context).groupPrivate, value: _isPrivate, onChanged: (value) {
                  setState(() {
                    _isPrivate = value;
                  });
                }),
              ],
            ),
          ).expanded(),
          SizedBox(height: 10,),
          // 下一步按钮
          ABButton.gradientColorButton(text: AB_getS(context).next, textColor: theme.black, fontWeight: FontWeight.w600, colors: [theme.primaryColor, theme.secondaryColor], height: 48.px, cornerRadius: 6.px, onPressed: () {
            _nextAction();
          }).addPadding(padding: EdgeInsets.symmetric(horizontal: 24.px)),
          SizedBox(height: 10.px + ABScreen.bottomHeight,),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({String? title, bool? value, Function(bool)? onChanged}) {
    final theme = AB_theme(context);
    return Container(
      height: 56,
      color: theme.white,
      child: Row(
        children: [
          ABText(title ?? "", textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,).addPadding(padding: const EdgeInsets.only(left: 16)),
          Container().expanded(),
          CupertinoSwitch(
            value: value ?? false,
            onChanged: (value){
              onChanged?.call(value);
            },
            activeColor: theme.primaryColor,
          ),
          const SizedBox(width: 16,),
        ]
      )
    ).addPadding(padding: const EdgeInsets.only(top: 8));
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
        _imagePath = pickerImage.path;
      });
      // 裁剪图片
      final croppedFile = await PhotoUtils.cropImage(image: File(pickerImage.path), aspectRatio: CropAspectRatio(
        ratioX: ABScreen.width,
        ratioY: ABScreen.width,
      ));
      if (croppedFile != null) {
        setState(() {
          _imagePath = croppedFile.path;
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
        _imagePath = file.path;
      });
      // 裁剪图片
      final croppedFile = await PhotoUtils.cropImage(image: file, aspectRatio: CropAspectRatio(
        ratioX: ABScreen.width,
        ratioY: ABScreen.width,
      ));
      if (croppedFile != null) {
        setState(() {
          _imagePath = croppedFile.path;
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

  void _nextAction() async {
    if (_imagePath == null || _imagePath!.isEmpty) {
      ABToast.show(AB_getS(context, listen: false).selectGroupAvatar);
      return;
    }
    if (_groupName.isEmpty) {
      ABToast.show(AB_getS(context, listen: false).inputGroupName);
      return;
    }
    if (_groupDesc.isEmpty) {
      ABToast.show(AB_getS(context, listen: false).inputGroupIntroduction);
      return;
    }

    final contacts = await ABRoute.push(const ContactChoosePage(isMultiSelect: true,)) as List<ContactInfo>?;
    if (contacts == null || contacts.isEmpty) {
      return;
    }
    final members = contacts.map((e){
      return V2TimGroupMember(
        userID: e.friendInfo.userID,
        role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER,
      );
    }).toList();

    ABLoading.show();
    final (url, message) = await OssUtils.uploadToOss(path: _imagePath!);
    if (url == null) {
      await ABLoading.dismiss();
      ABToast.show(message);
      return;
    }
    print("群头像 - $url");
    final res = await _sdkInstance.getGroupManager().createGroup(
      faceUrl: url,
      groupType: GroupType.Public,
      groupName: _groupName,
      introduction: _groupDesc,
      memberList: members,
      addOpt: (_isConfirm ? GroupAddOptTypeEnum.V2TIM_GROUP_ADD_AUTH : GroupAddOptTypeEnum.V2TIM_GROUP_ADD_ANY),
      approveOpt: (_isConfirm ? GroupAddOptTypeEnum.V2TIM_GROUP_ADD_AUTH : GroupAddOptTypeEnum.V2TIM_GROUP_ADD_ANY),
    );
    await ABLoading.dismiss();

    if (res.code == 0) {
      final groupID = res.data;
      // 发送一条消息
      sendMessage("${groupID}");
      final conversationID = "group_$groupID";
      final convRes = await _sdkInstance
          .getConversationManager()
          .getConversation(conversationID: conversationID);
      if (convRes.code == 0) {
        final conversation = convRes.data ??
            V2TimConversation(
                conversationID: conversationID,
                type: 2,
                showName: _groupName,
                groupType: GroupType.Public,
                groupID: groupID
            );
        ABRoute.pushReplacement(GroupChatPage(selectedConversation: conversation,));

        // 如果是私密群
        if (_isPrivate) {
          final _ = await TencentImSDKPlugin.v2TIMManager.getGroupManager().setGroupAttributes(groupID: groupID ?? "", attributes: {"isPrivate": "1"});
        }

      } else {
        ABRoute.pop();
      }
    } else {
      ABToast.show(AB_getS(context, listen: false).createGroupFail);
      return;
    }

  }

  void sendMessage(String groupID) async {
    // 创建文本消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextMessage(
      text: "大家好！", // 文本信息
    );
    if (createTextMessageRes.code == 0) {
      // 文本信息创建成功
      String? id = createTextMessageRes.data?.id;
      // 发送文本消息
      // 在sendMessage时，若只填写receiver则发个人用户单聊消息
      //                 若只填写groupID则发群组消息
      //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
      V2TimValueCallback<V2TimMessage> sendMessageRes =
      await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
          id: id!, // 创建的messageid
          receiver: "", // 接收人id
          groupID: groupID, // 接收群组id
          priority: MessagePriorityEnum.V2TIM_PRIORITY_DEFAULT, // 消息优先级
          onlineUserOnly:
          false, // 是否只有在线用户才能收到，如果设置为 true ，接收方历史消息拉取不到，常被用于实现“对方正在输入”或群组里的非重要提示等弱提示功能，该字段不支持 AVChatRoom。
          isExcludedFromUnreadCount: false, // 发送消息是否计入会话未读数
          isExcludedFromLastMessage: false, // 发送消息是否计入会话 lastMessage
          needReadReceipt:
          false, // 消息是否需要已读回执（只有 Group 消息有效，6.1 及以上版本支持，需要您购买旗舰版套餐）
          offlinePushInfo: OfflinePushInfo(), // 离线推送时携带的标题和内容
          cloudCustomData: "", // 消息云端数据，消息附带的额外的数据，存云端，消息的接收者可以访问到
          localCustomData:
          "" // 消息本地数据，消息附带的额外的数据，存本地，消息的接收者不可以访问到，App 卸载后数据丢失
      );
      if (sendMessageRes.code == 0) {
        // 发送成功
      }
    }
  }


}

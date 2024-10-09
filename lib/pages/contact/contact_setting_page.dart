import 'package:bee_chat/net/user_net.dart';
import 'package:bee_chat/pages/chat/c2c_chat_page.dart';
import 'package:bee_chat/pages/group/tim_search_records_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_loading.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/alert_pop_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../models/user/user_detail_model.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_event_bus.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_screen.dart';
import '../../utils/ab_toast.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text.dart';
import '../common/text_input_page.dart';

const String friendRemarkChangedEventName = "friendRemarkChangedEventName";
const String friendDidDeleteEventName = "friendDidDeleteEventName";


class ContactSettingPage extends StatefulWidget {
  final String userID;
  final UserDetailModel userDetailModel;
  const ContactSettingPage({super.key, required this.userDetailModel, required this.userID});

  @override
  State<ContactSettingPage> createState() => _ContactSettingPageState();
}

class _ContactSettingPageState extends State<ContactSettingPage> {
  final V2TIMFriendshipManager friendshipManager = TencentImSDKPlugin.v2TIMManager.getFriendshipManager();

  // final V2TimFriendInfo? _imFriend;
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    _requestConversation();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).setting,
      ),
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          ListView(
            children: [
              SizedBox(height: 10,),
              _getTextRowWidget(title: AB_getS(context).nickname, content: widget.userDetailModel.nickName,isShowArrow: false),
              _getTextRowWidget(title: AB_getS(context).remarks, content: widget.userDetailModel.showName, isLast: false, onTap: () async {
                final name = await ABRoute.push(TextInputPage(title: AB_getS(context, listen: false).changeRemark, text: widget.userDetailModel.friendNickName, maxLength: 10,)) as String?;
                if (name != null) {
                  _requestChangeRemark(name);
                }
              }),
              _getSwitchRowWidget(title: AB_getS(context).setTop, value: (_isPinned), onSwitchChange: (value) {
                _topConversion(value);
              }),
              // _getSwitchRowWidget(title: AB_getS(context).messageNotDisturb, value: (_isPinned), onSwitchChange: (value) {
              //
              // }),
              _getTextRowWidget(title: AB_getS(context).findChats, content:
              "${AB_S().picture},"
                  "${AB_S().video},${AB_S().file}", isShowArrow: true, onTap: () async {
                // TODO: 查找聊天记录
                ABRoute.push(TimSearchRecords(conversation: V2TimConversation(
                    conversationID: "c2c_${widget.userID}",
                    userID: widget.userID,
                    showName: widget.userDetailModel.showName,
                    type: 1)));
              })
            ],
          ).expanded(),
          // 删除好友
          ABButton(
            text: AB_getS(context).deleteFriend,
            height: 48,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontWeight: FontWeight.w600,
            onPressed: () {
              AlertPopWidget.show(title: AB_getS(context).deleteFriend, content: AB_getS(context).deleteFriendTip, onPressed: (bool isConfirmed) {
                if(isConfirmed){
                  AlertPopWidget.show(title: AB_getS(context).deleteFriend, content: AB_getS(context).deleteFriendTip, onPressed: (bool isConfirmed) async {
                    if(isConfirmed){
                      ABLoading.show();
                      final result = await friendshipManager.deleteFromFriendList(deleteType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH,userIDList:[widget.userID]);
                      ABLoading.dismiss();
                      if(result.code == 0){
                        ABEventBus.fire(ABEvent(name: friendDidDeleteEventName, data: widget.userID));
                        ABRoute.pop();
                      }else{
                        ABToast.show(result.desc);
                      }
                    }
                  });
                }
              });
            },
          ).addMargin(margin: EdgeInsets.only(left: 24, right: 24)),
          SizedBox(height: 10 + ABScreen.bottomHeight,),
        ],
      ),
    );
  }



  // 文字row
  Widget _getTextRowWidget({required String title, String? content, bool isShowArrow = true, bool isLast = false, Function? onTap}) {
    final theme = AB_theme(context);
    return Container(
      color: theme.white,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              if(onTap != null){
                onTap();
              }
            },
            child: SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 16,),
                  ABText(title, textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,),
                  const SizedBox(width: 10,),
                  Expanded(child: Container(
                    alignment: Alignment.centerRight,
                    child: ABText(content ?? "", textColor: theme.textGrey, fontSize: 14,),
                  )),
                  if(isShowArrow) const SizedBox(width: 4,),
                  if(isShowArrow) Icon(CupertinoIcons.right_chevron, size: 14, color: theme.textGrey,),
                  const SizedBox(width: 16,),
                ],
              ),
            ),
          ),
          if(!isLast) Divider(height: 1, color: theme.f4f4f4,).addPadding(padding: const EdgeInsets.only(left: 16, right: 16)),
        ],
      ),
    );
  }

  // switch row
  Widget _getSwitchRowWidget({required String title, required bool value, bool isLast = false, Function(bool)? onSwitchChange}) {
    final theme = AB_theme(context);
    return Container(
      color: theme.white,
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16,),
                ABText(title, textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,),
                Expanded(child: Container()),
                const SizedBox(width: 4,),
                CupertinoSwitch(
                  value: value,
                  onChanged: (value){
                    onSwitchChange?.call(value);
                  },
                  activeColor: theme.primaryColor,
                ),
                const SizedBox(width: 16,),
              ],
            ),
          ),
          if(!isLast) Divider(height: 1, color: theme.backgroundColor,).addPadding(padding: const EdgeInsets.only(left: 16, right: 16)),
        ],
      ),
    );
  }

  _requestChangeRemark(String remark) async {
    // 设置好友信息
    ABLoading.show();
    final res = await friendshipManager.setFriendInfo(userID: widget.userID, friendRemark: remark);
    await ABLoading.dismiss();
    if(res.code == 0){
      ABLoading.show();
      final result = await UserNet.updateFriendInfo(userId: widget.userID, remark: remark);
      await ABLoading.dismiss();
      if(result.data != null){
        setState(() {
          widget.userDetailModel.friendNickName = remark;
        });
        ABEventBus.fire(ABEvent(name: friendRemarkChangedEventName, data: remark));
      }
      ABToast.show(AB_getS(context, listen: false).changeSuccess);
    } else {
      ABToast.show(res.desc);
    }
  }

  _topConversion(bool isPinned) async {
    ABLoading.show();
    final res = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .pinConversation(conversationID: "c2c_${widget.userID}", isPinned: isPinned);
    await ABLoading.dismiss();
    if (res.code == 0) {
      setState(() {
        _isPinned = isPinned;
      });
    } else {
      ABToast.show(res.desc);
    }
  }

  _requestConversation() async {
    final res = await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getConversation(conversationID: "c2c_${widget.userID}");
    if (res.code == 0) {
      final data = res.data;
      if (data != null) {
        setState(() {
          _isPinned = data.isPinned ?? false;
        });
      }
    }
  }


// _requestFriendInfo() async {
//   final res = await friendshipManager.getFriendsInfo(userIDList: [widget.userID]);
//   if(res.code == 0){
//     final data = res.data;
//     if(data != null && data.isNotEmpty){
//       final friendInfo = data.first;
//       setState(() {
//         // _imFriend = friendInfo.friendInfo;
//       });
//     }
//  }
// }

}

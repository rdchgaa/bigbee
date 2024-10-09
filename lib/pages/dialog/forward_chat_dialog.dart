import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/pages/dialog/config_dialog.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_chat_separate_view_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_conversation_view_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/forward_message_screen.dart';

Future showForwardChatDialog(
  BuildContext context, {
  V2TimFileElem? fileElem,
  Function? saveCallback,
  Function? cancelCollectCallback,
  Function? otherAPPOpenCallback,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DialogForwardChatBox(
        fileElem: fileElem,
        saveCallback: saveCallback,
        cancelCollectCallback: cancelCollectCallback,
        otherAPPOpenCallback: otherAPPOpenCallback,
      );
    },
  );
}

class DialogForwardChatBox extends StatefulWidget {
  final V2TimFileElem? fileElem;
  final Function? saveCallback;
  final Function? cancelCollectCallback;
  final Function? otherAPPOpenCallback;

  const DialogForwardChatBox({
    Key? key,
    this.otherAPPOpenCallback,
    this.saveCallback,
    this.cancelCollectCallback,
    this.fileElem,
  }) : super(key: key);

  @override
  _DialogForwardChatBoxState createState() => _DialogForwardChatBoxState();
}

class _DialogForwardChatBoxState extends State<DialogForwardChatBox> {
  toMore() async {
    // model.initForEachConversation(ConvType., convID, onChangeInputField)
    // V2TimValueCallback<V2TimMsgCreateInfoResult> createFileMessageRes =
    //     await TencentImSDKPlugin.v2TIMManager
    //     .getMessageManager()
    //     .createFileMessage(
    //   filePath: "ghf/tyt",
    //   fileName: "文件名",
    // );
    V2TimValueCallback<V2TimMsgCreateInfoResult> createFileMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextMessage(text: 'text12');

    if (createFileMessageRes.code == 0) {
      String? id = createFileMessageRes.data?.id;
      String defaultReceiver = '10124410';
      V2TimValueCallback<V2TimMessage> sendMessageRes = await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .sendMessage(id: id ?? '', receiver: defaultReceiver, groupID: "");
      if (sendMessageRes.code == 0 && sendMessageRes.data != null) {
        // 给默认用户发送成功，返回消息对象进行发送
        TUIChatSeparateViewModel model = TUIChatSeparateViewModel();
        model.addToMultiSelectedMessageList(sendMessageRes.data!);
        await ABRoute.push(ForwardMessageScreen(
          model: model,
          isMergerForward: false,
          conversationType: ConvType.c2c,
        ));
        ABToast.show(AB_S().forward + AB_S().success);
      }
    }
  }

  sendSingle({String? userID, String? groupId}) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createFileMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().createTextMessage(text: 'text123');
    if (widget.fileElem != null) {
      createFileMessageRes =
          await TencentImSDKPlugin.v2TIMManager.getMessageManager().createFileMessage(filePath: widget.fileElem!.path!,
              fileName: widget.fileElem!.fileName!);
    }

    if (createFileMessageRes.code == 0) {
      String? id = createFileMessageRes.data?.id;
      V2TimValueCallback<V2TimMessage> sendMessageRes = await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .sendMessage(id: id ?? '', receiver: userID ?? '', groupID: groupId ?? '');
      if (sendMessageRes.code == 0 && sendMessageRes.data != null) {
        ABToast.show(AB_S().forward + AB_S().success);
        Navigator.of(context).pop();
        return;
      }
    }
    ABToast.show(AB_S().forward + AB_S().fail);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12.px)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.px, top: 15.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.px),
                    child: ABText(
                      AB_S().forwardTo,
                      textColor: theme.textColor,
                      fontSize: 18.px,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10.px,
                  ),
                  chatListBuild(),
                  // SizedBox(height: 10.px,),
                  SizedBox(
                    height: 20.px,
                  ),
                  Dash(
                    direction: Axis.horizontal,
                    length: MediaQuery.of(context).size.width - 32.px,
                    dashColor: theme.textGrey.withOpacity(0.5),
                    dashLength: 3,
                  ),
                  SizedBox(
                    height: 20.px,
                  ),
                  ButtonListBuild(),
                  SizedBox(
                    height: 10.px,
                  ),
                  ColoredBox(
                    color: theme.f4f4f4,
                    child: SizedBox(
                      width: double.infinity,
                      height: 10.px,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.px,
                      child: Center(
                          child: ABText(
                        AB_S().cancel,
                        fontSize: 16.px,
                        textColor: theme.textColor,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  chatListBuild() {
    final theme = AB_theme(context);
    return LayoutBuilder(builder: (context, con) {
      var itemWidth = (con.maxWidth - 16.px * 6) / 5;
      var itemHeight = itemWidth + 25.px;
      final recentConvList = serviceLocator<TUIConversationViewModel>().conversationList;

      List<Widget> listBuild = [];
      var length = recentConvList.length >= 4 ? 4 : recentConvList.length;
      for (var i = 0; i < length; i++) {
        V2TimConversation? conversation = recentConvList[i];
        final faceUrl = conversation?.faceUrl ?? "";
        final showName = conversation?.showName ?? "";
        listBuild.add(Padding(
          padding: EdgeInsets.only(left: 16.px),
          child: InkWell(
            onTap: () {
              sendSingle(userID: conversation!.userID, groupId: conversation.groupID);
            },
            child: SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: Avatar(
                      faceUrl: faceUrl,
                      showName: showName,
                      type: conversation?.type,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ABText(
                      showName,
                      fontSize: 12.px,
                      overflow: TextOverflow.fade,
                      textColor: theme.text282109,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
      }

      return SizedBox(
        width: con.maxWidth,
        height: itemHeight,
        child: Row(
          children: [
            ...listBuild,
            Padding(
              padding: EdgeInsets.only(left: 16.px),
              child: InkWell(
                onTap: () {
                  toMore();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: Color(0xffFFCB32), borderRadius: BorderRadius.all(Radius.circular(itemWidth / 2))),
                      child: SizedBox(
                        width: itemWidth,
                        height: itemWidth,
                        child: Center(
                          child: Image.asset(
                            ABAssets.mineMoreUser(context),
                            width: itemWidth * 0.6,
                            height: itemWidth * 0.6,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ABText(
                        AB_S().moreFriend,
                        fontSize: 12.px,
                        overflow: TextOverflow.fade,
                        textColor: theme.text282109,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  ButtonListBuild() {
    final theme = AB_theme(context);
    return LayoutBuilder(builder: (context, con) {
      var itemWidth = (con.maxWidth - 16.px * 6) / 5;
      var itemHeight = itemWidth + 30.px;

      return SizedBox(
        width: con.maxWidth,
        // height: itemHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buttonItemBuild(
                title: AB_S().save,
                image: ABAssets.mineDownload(context),
                itemWidth: itemWidth,
                onTap: () {
                  widget.saveCallback == null ? null : widget.saveCallback!();
                  ABRoute.pop(context: context);
                }),
            buttonItemBuild(
                title: AB_S().cancel + AB_S().collection,
                image: ABAssets.mineCollNo(context),
                itemWidth: itemWidth,
                onTap: () async {
                  bool? value = await showConfigDialog(context, title: AB_S().CancelFavorite);
                  if (value == true) {
                    ///TODO 取消收藏
                    widget.cancelCollectCallback == null ? null : widget.cancelCollectCallback!();
                    ABRoute.pop(context: context);
                  }
                }),
            buttonItemBuild(
                title: AB_S().otherAPPOpen,
                image: ABAssets.mineOtherApp(context),
                itemWidth: itemWidth,
                onTap: () {
                  widget.otherAPPOpenCallback == null ? null : widget.otherAPPOpenCallback!();
                  ABRoute.pop(context: context);
                }),
          ],
        ),
      );
    });
  }

  buttonItemBuild({required String title, required String image, required double itemWidth, required Function onTap}) {
    final theme = AB_theme(context);
    var itemHeight = itemWidth + 40.px;
    return Padding(
      padding: EdgeInsets.only(left: 16.px),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: theme.f4f4f4, borderRadius: BorderRadius.all(Radius.circular(12.px))),
              child: SizedBox(
                width: itemWidth,
                height: itemWidth,
                child: Center(
                  child: Image.asset(
                    image,
                    width: 24.px,
                    height: 24.px,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.px),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: itemWidth,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.px, color: theme.text282109, height: 1.1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

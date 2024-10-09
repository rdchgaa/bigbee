import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tencent_calls_engine/tencent_calls_engine.dart';
import 'package:tencent_calls_uikit/src/call_manager.dart';
import 'package:tencent_calls_uikit/src/i18n/i18n_utils.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

import '../../../../EventBus.dart';
import '../../../call_state.dart';

class JoinInGroupWidget extends StatefulWidget {
  final List<String> userIDs;
  final TUIRoomId roomId;
  final TUICallMediaType mediaType;
  final String groupId;
  final bool isNeedShow;

  const JoinInGroupWidget(
      {required this.userIDs,
      required this.roomId,
      required this.mediaType,
      required this.groupId,
        this.isNeedShow = true,
      Key? key})
      : super(key: key);

  @override
  State<JoinInGroupWidget> createState() => _JoinInGroupWidgetState();
}

class _JoinInGroupWidgetState extends State<JoinInGroupWidget> {
  bool _isExpand = false;
  bool _isShowAll = false;
  final List<String> _userAvatars = [];
  final expandDurationTime = 300;
  List<String> _userIDs = [];


  @override
  void initState() {
    super.initState();
    _updateUserAvatars();
  }

  @override
  Widget build(BuildContext context) {
    final theme = TUICallKit.theme;
    CallKitI18nUtils.setLanguage(Localizations.localeOf(context));
    if (!widget.isNeedShow) {
      return const SizedBox();
    }
    bool areEqual = Set.from(_userIDs).containsAll(widget.userIDs) && Set.from(widget.userIDs).containsAll(_userIDs);
    if (!areEqual) {
      _updateUserAvatars();
    }
    return Container(
        decoration: BoxDecoration(
          color: theme.white,
        ),
        child: GestureDetector(
            onTap: () => _changeExpand(),
            child: AnimatedContainer(
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width - 10,
                height: _isExpand ? 180 : 54,
                duration: Duration(milliseconds: expandDurationTime),
                child: Column(
                  children: [
                    const SizedBox(height: 4,),
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 15)),
                          Image.asset(
                            'assets/images/join_group_call.png',
                            package: 'tencent_calls_uikit',
                            width: 20,
                            height: 20,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 15)),
                          Text('${widget.userIDs.length} ${CallKit_t("personIsOnTheCall")}'),
                          const Spacer(),
                          Image.asset(
                            _isExpand
                                ? 'assets/images/join_group_compress.png'
                                : 'assets/images/join_group_expand.png',
                            package: 'tencent_calls_uikit',
                            width: 14,
                            height: 10,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 15)),
                        ],
                      ),
                    ),
                    _isShowAll
                        ? const SizedBox(height: 10,)
                        : const SizedBox(),
                    _isShowAll
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            child: Column(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width - 40,
                                    height: 56,
                                    child: Center(
                                        child: ListView.builder(
                                      itemCount: _userAvatars.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.5, right: 2.5, top: 0, bottom: 0),
                                            child: Container(
                                              height: 56,
                                              width: 56,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(28)),
                                              ),
                                              child: Image(
                                                  image: NetworkImage(_userAvatars[index]),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (ctx, err, stackTrace) => ClipRRect(
                                                        borderRadius: BorderRadius.circular(28),
                                                        child: Image.asset(
                                                          'assets/images/user_icon.png',
                                                          package: 'tencent_calls_uikit',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                            ));
                                      },
                                      padding: EdgeInsets.only(
                                          left: _computeEdge(MediaQuery.of(context).size.width - 40,
                                              85, _userAvatars.length),
                                          right: _computeEdge(
                                              MediaQuery.of(context).size.width - 40,
                                              85,
                                              _userAvatars.length)),
                                    ))),
                                const SizedBox(height: 14,),
                                InkWell(
                                    onTap: () => _joinInGroupCallAction(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: theme.primaryColor.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      height: 48,
                                      alignment: Alignment.center,
                                      child: Text(
                                        CallKit_t('joinIn'),
                                        style:  TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: theme.primaryColor,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ))));
  }

  _computeEdge(double maxWidth, int imageWidth, int count) {
    int maxNeedCompute = maxWidth ~/ imageWidth;
    if (maxNeedCompute >= count) {
      return (maxWidth - imageWidth * count) / 2;
    } else {
      return 0.0;
    }
  }

  _changeExpand() {
    if (!_isExpand) {
      _isExpand = !_isExpand;
      setState(() {});
      Timer(Duration(milliseconds: expandDurationTime), () {
        _isShowAll = _isExpand;
        setState(() {});
      });
    } else {
      _isExpand = !_isExpand;
      _isShowAll = _isExpand;
      setState(() {});
    }
  }

  _joinInGroupCallAction() async {
    await CallManager.instance.joinInGroupCall(widget.roomId, widget.groupId, widget.mediaType);
    eventBus.fire(ImCallEvent(name: ACCEPT_CALL_EVENT_BUS_NAME, data: {"groupId": CallState.instance.groupId, "roomId": "${CallState.instance.roomId.intRoomId}"}));
  }

  _updateUserAvatars() async {
    print("加载头像");
    _userIDs = widget.userIDs;
    _userAvatars.clear();
    final result = await TencentImSDKPlugin.v2TIMManager.getUsersInfo(userIDList: widget.userIDs);
    if (result.code != 0 || result.data == null) {
      return;
    }
    for (var userinfo in result.data!) {
      _userAvatars.add(userinfo.faceUrl!);
    }
    setState(() {});
  }
}

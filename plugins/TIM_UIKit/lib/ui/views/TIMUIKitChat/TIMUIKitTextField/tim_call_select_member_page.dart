import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitGroupProfile/widgets/tim_ui_group_member_search.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/group_member_list.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';

import '../../common/tim_ab_app_bar.dart';



class TimCallSelectMemberPage extends StatefulWidget {
  final String groupID;
  const TimCallSelectMemberPage({super.key, required this.groupID});

  @override
  State<TimCallSelectMemberPage> createState() => _TimCallSelectMemberPageState();
}

class _TimCallSelectMemberPageState extends TIMUIKitState<TimCallSelectMemberPage> {
  final CoreServicesImpl _coreServicesImpl = serviceLocator<CoreServicesImpl>();
  final GroupServices _groupServices = serviceLocator<GroupServices>();
  List<V2TimGroupMemberFullInfo> selectedMember = [];
  List<V2TimGroupMemberFullInfo?>? _groupMemberList = [];
  String _groupMemberListSeq = "0";
  List<V2TimGroupMemberFullInfo?>? searchMemberList;
  String? searchText;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadGroupMemberList(groupID: widget.groupID);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSearchTextExist(String? searchText) {
    return searchText != null && searchText != "";
  }

  Future<void> _loadGroupMemberList(
      {required String groupID, int count = 100, String? seq}) async {
    if (seq == null || seq == "" || seq == "0") {
      _groupMemberList = [];
    }
    final String? nextSeq = await _loadGroupMemberListFunction(
        groupID: groupID, seq: seq, count: count);
    if (nextSeq != null && nextSeq != "0" && nextSeq != "") {
      return await _loadGroupMemberList(
          groupID: groupID, count: count, seq: nextSeq);
    } else {
      setState(() {
        _groupMemberList = _groupMemberList;
        searchMemberList = _groupMemberList;
        loading = true;
      });
    }
  }

  Future<String?> _loadGroupMemberListFunction(
      {required String groupID, int count = 100, String? seq}) async {
    if (seq == "0") {
      _groupMemberList?.clear();
    }
    final res = await _groupServices.getGroupMemberList(
        groupID: widget.groupID!,
        filter: GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL,
        count: count,
        nextSeq: seq ?? _groupMemberListSeq);
    final groupMemberListRes = res.data;
    if (res.code == 0 && groupMemberListRes != null) {
      final groupMemberListTemp = groupMemberListRes.memberInfoList ?? [];
      _groupMemberList = [...?_groupMemberList, ...groupMemberListTemp];
      _groupMemberListSeq = groupMemberListRes.nextSeq ?? "0";
    }
    return groupMemberListRes?.nextSeq;
  }

  Future<V2TimValueCallback<V2GroupMemberInfoSearchResult>> searchGroupMember(
      V2TimGroupMemberSearchParam searchParam) async {
    final res =
    await _groupServices.searchGroupMembers(searchParam: searchParam);

    if (res.code == 0) {}
    return res;
  }

  handleSearchGroupMembers(String searchText, context) async {
    loading = true;
    if (widget.groupID == null || widget.groupID!.isEmpty) {
      return;
    }
    List<V2TimGroupMemberFullInfo?> currentGroupMember = [];
    final res = await searchGroupMember(V2TimGroupMemberSearchParam(
      keywordList: [searchText],
      groupIDList: [widget.groupID!],
    ));

    if (res.code == 0) {
      List<V2TimGroupMemberFullInfo?> list = [];
      final searchResult = res.data!.groupMemberSearchResultItems!;
      searchResult.forEach((key, value) {
        if (value is List) {
          for (V2TimGroupMemberFullInfo item in value) {
            list.add(item);
          }
        }
      });

      currentGroupMember = list;
    } else {
      currentGroupMember = [];
    }
    setState(() {
      loading = false;
      searchMemberList =
      isSearchTextExist(searchText) ? currentGroupMember : _groupMemberList;
    });
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final title = TIM_getCurrentDeviceLocale().contains("zh") ? "选择成员" : "Select members";
    return Scaffold(
      backgroundColor: theme.weakBackgroundColor,
        appBar: TimAbAppBar(
          title: title,
          backgroundWidget: Container(
            // 渐变色
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFFDC79),
                  Color(0xFFFFCB32),
                ],
              ),
            ),
          ),
        ),
        body: ((searchMemberList ?? []).isNotEmpty || loading == false)
            ? GroupProfileMemberList(
          customTopArea: GroupMemberSearchTextField(
            onTextChange: (text) =>
                handleSearchGroupMembers(text, context),
          ),
          memberList: (searchMemberList ?? [])
              .where((element) =>
          element?.userID != _coreServicesImpl.loginInfo.userID)
              .toList(),
          canSlideDelete: false,
          canSelectMember: true,
          onSelectedMemberChange: (member) {
            selectedMember = member;
            setState(() {});
          },
        )
            : Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: theme.primaryColor ?? Colors.grey,
            size: 40,
          ),
        ));
  }



}

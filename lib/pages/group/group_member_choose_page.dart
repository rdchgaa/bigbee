import 'package:bee_chat/pages/group/vm/group_member_list_vm.dart';
import 'package:bee_chat/pages/group/widget/group_member_list_item.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/alert_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../models/group/group_member_list_model.dart';
import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_button.dart';
import '../../widget/ab_text_field.dart';
import '../contact/user_details_page.dart';

class GroupMemberChoosePage extends StatefulWidget {
  final String groupID;
  final String? title;
  final List<String>? selectedMemberIds;
  // 排除成员Id列表
  final List<String>? excludeMemberIds;
  // 检测是否完成选择
  final Future<bool> Function(List<GroupMemberListModel> models)? checkComplete;
  // 是否单选
  final bool isSingle;
  // 是否仅普通群成员
  final bool isNormalMemberOnly;

  const GroupMemberChoosePage({super.key, required this.groupID, this.title, this.excludeMemberIds, this.selectedMemberIds, this.checkComplete, this.isSingle = false, this.isNormalMemberOnly = false});

  @override
  State<GroupMemberChoosePage> createState() => _GroupMemberChoosePageState();
}

class _GroupMemberChoosePageState extends State<GroupMemberChoosePage> {
  String _searchText = "";
  late GroupMemberListVm _vm;
  late List<String>? _selectedMemberIds;
  List<GroupMemberListModel> _selectMembers = [];

  @override
  void initState() {
    _selectedMemberIds = widget.selectedMemberIds;
    _vm = GroupMemberListVm(groupID: widget.groupID, isShowMe: false, excludeMemberIds: widget.excludeMemberIds ?? [], isOnlyOrdinaryGroupMemberList: widget.isNormalMemberOnly);
    super.initState();
    _doSearch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: widget.title ?? AB_getS(context).groupMember,
        backgroundWidget: Container(
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
        rightWidget: ABButton.textButton(text: AB_getS(context).completed, textColor: theme.textColor, fontSize: 14, fontWeight: FontWeight.w600, width: 60.px, height: 44, onPressed: () async {
          if (widget.checkComplete != null) {
            final isComplete = await widget.checkComplete!(_selectMembers);
            if (isComplete) {
              ABRoute.pop(result: _selectMembers);
            }
          } else {
            ABRoute.pop(result: _selectMembers);
          }
        }),
      ),
      backgroundColor: theme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          _searchWidget().addPadding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          ChangeNotifierProvider(
            create: (_) => _vm,
            builder: (context, child) {
              var vm = context.watch<GroupMemberListVm>();
              return EasyRefresh(
                header: CustomizeBallPulseHeader(color: theme.primaryColor),
                onRefresh: () async {
                  await _doSearch();
                },
                onLoad: !vm.hasMore ? null : () async {
                  await vm.loadMore();
                },
                child: ListView.builder(itemBuilder: (BuildContext context, int index){
                  final model = vm.resultList[index];
                  if (_selectedMemberIds != null && _selectedMemberIds!.contains(model.memberNum ?? "")) {
                    _selectMembers.add(model);
                    _selectedMemberIds = _selectedMemberIds!.where((e) => e != model.memberNum).toList();
                  }
                  return InkWell(
                    onTap: () async {
                      // if (widget.isSingle) {
                      //   _selectMembers = [model];
                      //   final isComplete = await widget.checkComplete!(_selectMembers);
                      //   if (isComplete) {
                      //     ABRoute.pop(result: _selectMembers);
                      //   }
                      //   return;
                      // }
                      // ABRoute.push(UserDetailsPage(userId: model.memberNum ?? ""));
                      if (widget.isSingle) {
                        _selectMembers = [model];
                        final isComplete = await widget.checkComplete!(_selectMembers);
                        if (isComplete) {
                          ABRoute.pop(result: _selectMembers);
                        }
                        return;
                      }
                      if (_selectMembers.contains(model)) {
                        _selectMembers.remove(model);
                      } else {
                        _selectMembers.add(model);
                      }
                      setState(() {
                      });

                    },
                      child: GroupMemberListItem(model: model, isSelect: (widget.isSingle ? null : _selectMembers.contains(model)), onSelect: () async {
                        if (widget.isSingle) {
                          _selectMembers = [model];
                          final isComplete = await widget.checkComplete!(_selectMembers);
                          if (isComplete) {
                            ABRoute.pop(result: _selectMembers);
                          }
                          return;
                        }
                        if (_selectMembers.contains(model)) {
                          _selectMembers.remove(model);
                        } else {
                          _selectMembers.add(model);
                        }
                        setState(() {
                        });
                      },),
                  );
                },
                  itemCount: vm.resultList.length,
                ),
              );
            },
          ).expanded(),
        ],
      ),
    );
  }


  // 搜索框
  Widget _searchWidget() {
    final theme = AB_theme(context);
    return Container(
      alignment: Alignment.centerLeft,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.px),
        // 边框
        border: Border.all(
          color: theme.f4f4f4,
          width: 1.px,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ABAssets.homeSearchIcon(context), width: 14.px, height: 14.px,),
          SizedBox(width: 14.px,),
          ABTextField(text: _searchText, textSize: 14.px, maxLines: 1, hintText: AB_getS(context).searchName, hintColor: theme.textGrey, contentPadding: EdgeInsets.only(bottom: 12.px), onChanged: (text) {
            _searchText = text;
            // _doSearch();
          },
            onSubmitted: (text) {
            _searchText = text;
              _doSearch();
            },
          ).expanded(),
        ],
      ).addPadding(padding: EdgeInsets.symmetric(horizontal: 12.px)),
    );
  }

  Future<void> _doSearch() async {
    setState(() {
      _selectMembers = [];
    });
    await _vm.search(_searchText);
  }
}
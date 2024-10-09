import 'package:bee_chat/pages/group/vm/group_member_list_vm.dart';
import 'package:bee_chat/pages/group/widget/group_member_list_item.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';

import '../../models/group/group_member_list_model.dart';
import '../../net/group_net.dart';
import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_route.dart';
import '../../utils/ab_screen.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_app_bar.dart';
import '../../widget/ab_button.dart';
import '../contact/user_details_page.dart';

class GroupMuteMemberChoosePage extends StatefulWidget {
  final String groupID;
  final bool isGroupOwner;
  final Future<bool> Function(List<GroupMemberListModel>)? completeCallback;
  const GroupMuteMemberChoosePage({super.key, required this.groupID, this.completeCallback, this.isGroupOwner = false});

  @override
  State<GroupMuteMemberChoosePage> createState() => _GroupMuteMemberChoosePageState();
}

class _GroupMuteMemberChoosePageState extends State<GroupMuteMemberChoosePage> {

  late GroupMemberListVm _vm;
  late List<String>? _selectedMemberIds;
  List<GroupMemberListModel> _selectMembers = [];
  @override
  void initState() {
    _selectedMemberIds = [];
    _vm = GroupMemberListVm(groupID: widget.groupID, isShowMe: false, excludeMemberIds: [], isOnlyOrdinaryGroupMemberList: !widget.isGroupOwner);
    super.initState();
    _vm.search("");
  }

  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
      appBar: ABAppBar(
        title: AB_getS(context).groupMember,
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
          if (widget.completeCallback != null) {
            final isComplete = await widget.completeCallback!(_selectMembers);
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
          ChangeNotifierProvider(
            create: (_) => _vm,
            builder: (context, child) {
              var vm = context.watch<GroupMemberListVm>();
              return EasyRefresh(
                header: CustomizeBallPulseHeader(color: theme.primaryColor),
                onRefresh: () async {
                  await _vm.search("");
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
                  bool? isSelected = model.isForbiddenSpeech == 2 ? null : _selectMembers.contains(model) ;
                  return InkWell(
                    onTap: () async {
                      if (model.isForbiddenSpeech == 2) {
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
                    child: GroupMemberListItem(model: model, isSelect: isSelected, onSelect: () async {
                      if (model.isForbiddenSpeech == 2) {
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
}

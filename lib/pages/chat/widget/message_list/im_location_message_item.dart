import 'dart:async';
import 'dart:convert';

import 'package:bee_chat/main.dart';
import 'package:bee_chat/pages/map/map_show_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../../provider/theme_provider.dart';
import 'im_bubble_widget.dart';

class ImLocationMessageItem extends StatefulWidget {
  final V2TimMessage message;
  final bool isFromSelf;
  final bool isShowJump;
  final VoidCallback clearJump;
  final Function? onRefresh;


  const ImLocationMessageItem({super.key,
    required this.message,
    required this.isFromSelf,
    required this.isShowJump,
    required this.clearJump,
    this.onRefresh
  });

  @override
  State<ImLocationMessageItem> createState() => _ImLocationMessageItemState();
}

class _ImLocationMessageItemState extends State<ImLocationMessageItem> {
  bool isShowJumpState = false;
  bool isShining = false;

  _showJumpColor() {
    if (!widget.isShowJump) {
      return;
    }
    isShining = true;
    int shineAmount = 6;
    setState(() {
      isShowJumpState = true;
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          isShowJumpState = shineAmount.isOdd ? true : false;
        });
      }
      if (shineAmount == 0 || !mounted) {
        isShining = false;
        timer.cancel();
      }
      shineAmount--;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.clearJump();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        // widget.clearJump();
      }
    }

    return Container(
      padding: EdgeInsets.only(
        left: widget.isFromSelf ? 0 : 6,
        right: widget.isFromSelf ? 6 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // 边框
        border: Border.all(color: isShowJumpState ? theme.primaryColor : Colors.transparent, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          final location = widget.message.locationElem;
          if (location == null) {
            return;
          }
          String desc = location.desc ?? "{}";
          String name = AB_S().location;
          try {
            Map<String, dynamic> descMap = jsonDecode(desc);
            name = descMap["name"] ?? AB_S().location;
          } catch (e) {
            name = location.desc ?? AB_S().location;
          }
          ABRoute.push(MapShowPage(latitude: location.latitude, longitude: location.longitude, title: name.isNotEmpty ? name : AB_S().location,));
        },
        child: _getContentWidget(),
      ),
    );
  }

  Widget _getContentWidget() {
    final theme = AB_theme(context);
    final location = widget.message.locationElem;
    if (location == null) {
      return Text("[${AB_S().location}]");
    }
    String desc = location.desc ?? "{}";
    String address = AB_S().unknown;
    String name = AB_S().location;
    try {
      Map<String, dynamic> descMap = jsonDecode(desc);
      address = descMap["address"] ?? AB_S().unknown;
      name = descMap["name"] ?? AB_S().location;
    } catch (e) {
      name = location.desc ?? AB_S().location;
    }

    return ImBubbleWidget(
      isFromSelf: widget.isFromSelf,
      child: Container(
        padding: const EdgeInsets.all(14),
        width: MediaQuery.of(context).size.width * 0.6,
        // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        child: Container(
          decoration: BoxDecoration(
            color: theme.white,
            borderRadius: BorderRadius.circular(5.px),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.px,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.px),
                child: Text(name.isNotEmpty ? name : AB_S().location, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 2.px,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.px),
                child: Text(address.isNotEmpty ? address : AB_S().unknown, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: theme.textColor.withOpacity(0.6), fontSize: 14),),
              ),
              SizedBox(height: 6.px,),
              Container(
                height: 100.px,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.px),
                  child: Image.asset(ABAssets.iconImMap(context), fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
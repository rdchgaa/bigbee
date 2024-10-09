import 'package:bee_chat/main.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/pages/group/group_create_page.dart';
import 'package:bee_chat/pages/common/scan_page.dart';
import 'package:bee_chat/pages/contact/contact_search_page.dart';
import 'package:bee_chat/pages/home/widget/home_tool_tip_widget.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/color_extensions.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AssetsCustodyWalletAssetsItem extends StatefulWidget {
  final FundsCoinCapitalList coinCapital;
  final Function callback;
  final Function onTap;
  const AssetsCustodyWalletAssetsItem({super.key, required this.coinCapital, required this.callback, required this.onTap});

  @override
  State<AssetsCustodyWalletAssetsItem> createState() =>
      AssetsCustodyWalletAssetsItemState();
}

class AssetsCustodyWalletAssetsItemState
    extends State<AssetsCustodyWalletAssetsItem> with SingleTickerProviderStateMixin{

  SlidableController? controller;

  bool onPanStart = false;
  @override
  void initState() {
    super.initState();

    controller = SlidableController(this);
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    UserProvider provider =
    Provider.of<UserProvider>(MyApp.context, listen: false);
    return GestureDetector(
      onTap: (){
        widget.onTap();
      },
      onPanDown: (e){
        onPanStart = true;
        setState(() {

        });
      },
      onPanCancel: (){
        onPanStart = false;
        setState(() {

        });
      },
      child: SizedBox(
        width: double.infinity,
        height: 56.px,
        child:controller==null?SizedBox(): Slidable(
          // Specify a key if the Slidable is dismissible.
          controller: controller,
          endActionPane: ActionPane(
            extentRatio: 0.3,
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                flex: 1,
                onPressed: (slidCtx){
                  widget.callback();
                },
                backgroundColor: theme.d7d7d7,
                foregroundColor: theme.backgroundColorWhite,
                // icon: Icons.archive,
                label: AB_getS(context).notShow,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          child: ColoredBox(
            color: onPanStart?theme.backgroundColorWhite:Colors.transparent,
            child: SizedBox(
              width: ABScreen.width,
              height: 56.px,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0.px, right: 12.px),
                        child: SizedBox(
                          width: 40.px,
                          height: 40.px,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: ABImage.imageWithUrl(
                                  // 'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png',
                                  UserProvider.getCoinInfo(widget.coinCapital.coinName)?.url??'',
                                  // provider.userInfo.avatarUrl ?? '',
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      ),
                      ABText(widget.coinCapital.coinName,
                          textColor: theme.textColor,
                          fontWeight: FontWeight.w400, fontSize: 16.px),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.0.px),
                    child: ABText(widget.coinCapital.amount,
                        textColor: theme.textColor,
                        fontWeight: FontWeight.w600, fontSize: 18.px),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

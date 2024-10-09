import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/group/group_member_invite_model.dart';
import 'package:bee_chat/pages/assets/widget/assets_user_item_widget.dart';
import 'package:bee_chat/pages/contact/contact_page.dart';
import 'package:bee_chat/pages/group/vm/group_invite_user_list_vm.dart';
import 'package:bee_chat/pages/group/widget/group_invite_user_list_item.dart';
import 'package:bee_chat/provider/contact_provider.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/customize_ball_pulse_header.dart';


Future showSelectAddressDialog(
    BuildContext context, {
      TextAlign contentAlign = TextAlign.center,
    }) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DialogAlertAddressBox(
      );
    },
  );
}

class DialogAlertAddressBox extends StatefulWidget {

  const DialogAlertAddressBox({
    Key? key,
  }) : super(key: key);

  @override
  _DialogAlertAddressBoxState createState() => _DialogAlertAddressBoxState();
}

class _DialogAlertAddressBoxState extends State<DialogAlertAddressBox> {
  String _searchText = "";


  @override
  void initState() {
    super.initState();
  }

  void getCurrentLocation() async {
    // Position position = await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.high,
    // );
    //
    // setState(() {
    //   _initialPosition = LatLng(position.latitude, position.longitude);
    // });
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
          padding: EdgeInsets.only(bottom: 16.px,top: 15.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 5.px,),
                  selectUsersWidget(),
                  // SizedBox(height: 10.px,),
                  Padding(
                    padding: EdgeInsets.only(top: 24.px),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.text999,
                                borderRadius: BorderRadius.circular(12.px),
                              ),
                              child: SizedBox(
                                width: (ABScreen.width-68.px)/2,
                                height: 48.px,
                                child: ABText(
                                  AB_S().cancel,
                                  textColor: theme.white,
                                  fontSize: 15.px,
                                  fontWeight: FontWeight.w600,
                                ).center,
                              ),
                            ),
                          ),
                        SizedBox(width: 16.px),
                          InkWell(
                            onTap: () {
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.text999,
                                borderRadius: BorderRadius.circular(12.px),
                                gradient: LinearGradient(
                                  colors: [theme.primaryColor,theme.secondaryColor],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: SizedBox(
                                width: (ABScreen.width-68.px)/2,
                                height: 48.px,
                                child: ABText(
                                  AB_S().confirm,
                                  textColor: theme.black,
                                  fontSize: 15.px,
                                  fontWeight: FontWeight.w600,
                                ).center,
                              ),
                            ),
                          ),
                      ],
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

  Widget selectUsersWidget (){
    final theme = AB_theme(context);
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.width,
    );
  }
}
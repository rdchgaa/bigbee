import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:bee_chat/widget/ab_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future showGoogleCodeDialog(
  BuildContext context,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return GoogleCodeDialog();
    },
  );
}

class GoogleCodeDialog extends StatefulWidget {
  const GoogleCodeDialog({
    Key? key,
  }) : super(key: key);

  @override
  _GoogleCodeDialogState createState() => _GoogleCodeDialogState();
}

class _GoogleCodeDialogState extends State<GoogleCodeDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12.px)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(bottom: 320.px, top: 15.px),
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
                      AB_S().pleaseEnterGoogleCode,
                      textColor: theme.textColor,
                      fontSize: 18.px,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 16.px, right: 16.px),
                      child: ColoredBox(
                        color: theme.f4f4f4,
                        child: SizedBox(
                          width: double.infinity,
                          height: 1.px,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 24.px, right: 24.px, top: 18.px),
                    child: DecoratedBox(
                        decoration: BoxDecoration(color: theme.f4f4f4, borderRadius: BorderRadius.circular(6)),
                        child: LayoutBuilder(builder: (context, con) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 48,
                                child: Image.asset(
                                  ABAssets.assetsShield(context),
                                  width: 24.px,
                                  height: 24.px,
                                ),
                              ),
                              SizedBox(
                                width: con.maxWidth - 48,
                                height: 48.px,
                                child: ABTextField(
                                  text: '',
                                  hintText: AB_S().pleaseEnterGoogleCode,
                                  hintColor: theme.textGrey,
                                  textColor: theme.textColor,
                                  textSize: 16,
                                  contentPadding: EdgeInsets.only(bottom: 12),
                                  maxLines: 1,
                                  maxLength: 16,
                                  onChanged: (text) {
                                    if (text.length >= 6) {
                                      Navigator.of(context).pop(text);
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                                  ],
                                ),
                              ),
                            ],
                          );
                        })),
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
}

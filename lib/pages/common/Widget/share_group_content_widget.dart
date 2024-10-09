import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../../provider/language_provider.dart';
import '../../../utils/ab_assets.dart';
import '../../../utils/ab_screen.dart';
import '../../../utils/ab_share.dart';
import '../../../utils/ab_toast.dart';
import '../../../utils/extensions/color_extensions.dart';
import '../../../widget/ab_image.dart';
import '../../../widget/ab_text.dart';

class ShareGroupContentWidget extends StatelessWidget {
  final V2TimGroupInfo groupInfo;
  final GlobalKey qrGlobalKey;

  const ShareGroupContentWidget({super.key, required this.groupInfo, required this.qrGlobalKey});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return RepaintBoundary(
      key: qrGlobalKey,
      child: Container(
        color: theme.backgroundColor,
        height: 420,
        width: ABScreen.width,
        child: Stack(
          children: [
            // 背景
            Positioned(
              top: 54,
              left: 16,
              right: 16,
              height: 360,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            // 头像
            Positioned(
              top: 10,
              height: 88,
              width: ABScreen.width,
              child: Container(
                height: 88,
                width: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44),
                  color: theme.white,
                  boxShadow: [
                    BoxShadow(
                      color: theme.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(44),
                    child: ABImage.avatarUser(groupInfo.faceUrl ?? "", isGroup: true).center),
              ).center,
            ),
            // 内容
            Positioned(
                top: 108,
                left: 26,
                right: 26,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 昵称
                    ABText(groupInfo.groupName ?? "", textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,),
                    SizedBox(height: 5,),
                    // 群id（点击复制）
                    InkWell(
                      onTap: () async {
                        final ClipboardData clipboardData = ClipboardData(text: groupInfo.groupID.replaceFirst("@TGS#", ""));
                        await Clipboard.setData(clipboardData);
                        ABToast.show(TIM_t("已复制"));
                      },
                      child: Container(
                        // alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        height: 22,
                        decoration: BoxDecoration(
                          color: HexColor("FFCB32"),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ABText("${AB_getS(context).groupNum}:${groupInfo.groupID.replaceFirst("@TGS#", "")}", textColor: theme.white, fontSize: 12,),
                            SizedBox(width: 5,),
                            Image.asset(ABAssets.shareCopy(context), width: 12, height: 12,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    ABText(AB_getS(context).groupShareTip, textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,),
                    const SizedBox(height: 12,),
                    // 二维码
                    QrImageView(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(6),
                      data: ABShare.getGroupShareUrl(groupID: groupInfo.groupID),
                      size: 176.0,
                    )
                  ],
                )
            ),
          ],

        ),
      ),
    );
  }
}

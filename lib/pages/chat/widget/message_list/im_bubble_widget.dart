import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../utils/ab_assets.dart';
import '../../../../utils/extensions/color_extensions.dart';

class ImBubbleWidget extends StatelessWidget {
  final Widget child;
  final bool isFromSelf;
  final Color? selfBackgroundColor;
  final Color? otherBackgroundColor;


  const ImBubbleWidget({super.key, required this.child, required this.isFromSelf, this.selfBackgroundColor, this.otherBackgroundColor});

  @override
  Widget build(BuildContext context) {

    final sbc = selfBackgroundColor ?? const Color(0xFFEFA33D);
    final obc = otherBackgroundColor ?? const Color(0xFFF4F4F4);

    final otherBackground = Positioned(
        bottom: 0,
        left: 0,
        height: 16*3/5,
        width: 10*3/5,
        child: otherBackgroundColor != null ? ColorFiltered(
          colorFilter: ColorFilter.mode(
            otherBackgroundColor!,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            ABAssets.imBubbleBgOther(context),
            fit: BoxFit.fill,
          ),
        ) : Image.asset(
          ABAssets.imBubbleBgOther(context),
          fit: BoxFit.fill,
        )
    );

    final selfBackground = Positioned(
        bottom: 0,
        right: 0,
        height: 16*3/5,
        width: 10*3/5,
        child: selfBackgroundColor != null ? ColorFiltered(
          colorFilter: ColorFilter.mode(
            selfBackgroundColor!, // 将图片颜色修改为灰色
            BlendMode.srcIn,
          ),
          child: Image.asset(
            ABAssets.imBubbleBgSelf(context),
            fit: BoxFit.fill,
          ),
        ) : Image.asset(
          ABAssets.imBubbleBgSelf(context),
          fit: BoxFit.fill,
        )
    );
    final padding = isFromSelf ? const EdgeInsets.only(right: 6,) : const EdgeInsets.only(left: 6,);
    return Stack(
      children: [
        isFromSelf ? selfBackground : otherBackground,
        Positioned(
            right: isFromSelf ? 6 : 0,
            bottom: 0,
            top: 0,
            left: isFromSelf ? 0 : 6,
            child: Container(
              decoration: BoxDecoration(
                color: isFromSelf ? sbc : obc,
                borderRadius:  isFromSelf ?
                const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12)) :
                const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
              ),
            )),
        child.addPadding(padding: padding),
      ],
    );
  }
}

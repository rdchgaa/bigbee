import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/ab_assets.dart';
import '../../red_bag/red_bag_send_page.dart';

class ImRedEnvelopeBubbleWidget extends StatelessWidget {
  final SendRedResult model;
  final bool isFromSelf;
  final bool isReceived;
  const ImRedEnvelopeBubbleWidget({super.key, required this.model, required this.isFromSelf, required this.isReceived});

  @override
  Widget build(BuildContext context) {
    String redText = AB_getS(context).redEnvelope;
    String iconAssets = ABAssets.imRedEnvelopeIcon(context);
    Color startColor = const Color(0xFFEB5C50);
    Color endColor = const Color(0xFFF09A67);
    Color textColor = Colors.white;
    if (model.isExpired()) {
      redText = AB_getS(context).redEnvelopeTip;
      startColor = const Color(0xFFC8716A);
      endColor = const Color(0xFFCD9574);
      textColor = Colors.white.withOpacity(0.8);
    }
    if (model.isOver) {
      redText = model.bagNum > 1 ? AB_getS(context).redEnvelopeTip3 : AB_getS(context).redEnvelopeTip2;
      iconAssets = ABAssets.imRedEnvelopeIconReceived(context);
      startColor = const Color(0xFFF3C1BE);
      endColor = const Color(0xFFF7D9C5);
      textColor = Colors.white.withOpacity(0.8);
    }
    if (isReceived || model.isReceive()) {
      redText = AB_getS(context).redEnvelopeTip2;
      iconAssets = ABAssets.imRedEnvelopeIconReceived(context);
      startColor = const Color(0xFFF3C1BE);
      endColor = const Color(0xFFF7D9C5);
      textColor = Colors.white.withOpacity(0.8);
    }

    final otherBackground = Positioned(
        bottom: 0,
        left: 0,
        height: 16*3/5,
        width: 10*3/5,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            startColor,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            ABAssets.imBubbleBgOther(context),
            fit: BoxFit.fill,
          ),
        )
    );

    // 创建一个线性渐变，从红色到蓝色
    final gradient = LinearGradient(
      colors: [startColor, endColor],
      stops: const [0.1, 1.0], // 开始和结束的位置
      begin: isFromSelf ? Alignment.bottomRight : Alignment.bottomLeft,
      end: isFromSelf ? Alignment.topLeft : Alignment.topRight,
    );

    final selfBackground = Positioned(
        bottom: 0,
        right: 0,
        height: 16*3/5,
        width: 10*3/5,
        child: ColorFiltered(// 改变图片颜色
          colorFilter: ColorFilter.mode(
            startColor,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            ABAssets.imBubbleBgSelf(context),
            fit: BoxFit.fill,
          ),
        )
    );
    final padding = isFromSelf ? const EdgeInsets.only(right: 6,) : const EdgeInsets.only(left: 6,);
    final redIcon = Image.asset(
      iconAssets,
      width: 54,
      height: 54,
    );
    final titleText = Text(
      model.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: isFromSelf ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ).expanded();


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
                // color: isFromSelf ? sbc : obc,
                gradient: gradient,
                borderRadius:  isFromSelf ?
                const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12)) :
                const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
              ),
            )),
        Positioned(
            bottom: 0,
            top: 0,
            right: isFromSelf ? null : 6,
            left: isFromSelf ? 6 : null,
            child: Image.asset(
              isFromSelf ? ABAssets.imRedEnvelopeBgSelf(context) : ABAssets.imRedEnvelopeBgOther(context),
            ),
        ),
        Container(
          height: 82 ,
          width: MediaQuery.of(context).size.width * 0.6 - 6,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const SizedBox(width: 14,),
              isFromSelf ? titleText : redIcon,
              const SizedBox(width: 8,),
              isFromSelf ? redIcon : titleText,
              const SizedBox(width: 14,)
            ],
          ),
        ).addPadding(padding: padding),
        Positioned(
            bottom: 8,
            right: isFromSelf ? null : 14,
            left: isFromSelf ? 14 : null,
            child: Text(redText, style: TextStyle(color: textColor, fontSize: 12),),
        ),
      ],
    );
  }
}

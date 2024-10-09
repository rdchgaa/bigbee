import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkItemWidget extends StatelessWidget {
  final MarkItemModel model;
  const MarkItemWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      height: 66,
      child: Row(
        children: [
          const SizedBox(width: 16,),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
              child: ABImage.imageWithUrl(model.imageUrl, height: 48, width: 48)),
          const SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ABText(model.title, textColor: theme.textColor, fontWeight: FontWeight.w600, fontSize: 16,),
                  ABText(getChange(), textColor: model.change > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.w600, fontSize: 16,)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ABText(model.subTitle, textColor: theme.textGrey, fontSize: 14,),
                  ABText(model.price.toStringAsFixed(2), textColor: theme.textGrey, fontSize: 14, fontWeight: FontWeight.w600,)
                ],
              )
            ]
          ).expanded(),
          const SizedBox(width: 16,),
        ]
      )
    );
  }

  // 获取变化值（正数用加号，负数用减号，转百分比，保留两位小数）
  String getChange(){
    return '${model.change > 0 ? '+' : ''}${(model.change * 100).toStringAsFixed(2)}%';
  }

}

class MarkItemModel{
  final String title;
  final String subTitle;
  final double change;
  final double price;
  final String imageUrl;

  MarkItemModel({
    required this.title,
    required this.subTitle,
    required this.change,
    required this.price,
    required this.imageUrl,
  });


  static List<MarkItemModel> getList(){
    return [
      MarkItemModel(
        title: 'BTC',
        subTitle: 'Bitcoin',
        change: 0.01,
        price: 10000.0,
        imageUrl: 'https://static.oklink.com/cdn/explorer/admin/1686558172927.png?x-oss-process=image/resize,w_104,h_104,type_6/format,webp/ignore-error,1',
      ),
      MarkItemModel(
        title: 'ETH',
        subTitle: 'Ethereum',
        change: 0.01,
        price: 10000.0,
        imageUrl: 'https://static.oklink.com/cdn/assets/imgs/234/394F7F0E5AA398F0.png?x-oss-process=image/resize,w_104,h_104,type_6/format,webp/ignore-error,1',
      ),
      MarkItemModel(
        title: 'BNB',
        subTitle: 'BNB',
        change: -0.01,
        price: 10000.0,
        imageUrl: 'https://static.oklink.com/cdn/explorer/admin/1686558198512.png?x-oss-process=image/resize,w_104,h_104,type_6/format,webp/ignore-error,1',
      ),
      MarkItemModel(
        title: 'USDT',
        subTitle: 'USDT',
        change: 0.01,
        price: 10000.0,
        imageUrl: 'https://static.okx.com/cdn/web3/currency/token/1718088031349.png/type=png_350_0?x-oss-process=image/format,webp/resize,w_80,h_80,type_6/ignore-error,1',
      ),
      MarkItemModel(
        title: 'XL',
        subTitle: 'X Layer',
        change: 0.01,
        price: 10000.0,
        imageUrl: 'https://static.oklink.com/cdn/web3/currency/token/1711680841142.png/type=png_350_0?x-oss-process=image/resize,w_104,h_104,type_6/format,webp/ignore-error,1',
      ),
    ];
  }

}
import 'package:bee_chat/pages/mine/mine_page.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../provider/language_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/ab_assets.dart';
import '../../utils/extensions/color_extensions.dart';
import '../../widget/ab_text.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  List<String> urls = [
    'https://img0.baidu.com/it/u=100080021,1406455647&fm=253&fmt=auto&app=120&f=JPEG?w=756&h=500',
    'https://img2.baidu.com/it/u=2597929176,3520921866&fm=253&fmt=auto&app=120&f=JPEG?w=745&h=500',
    'https://img1.baidu.com/it/u=968594022,3187477384&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500',
    'https://img1.baidu.com/it/u=3900322681,4149328919&fm=253&fmt=auto&app=120&f=JPEG?w=1422&h=800',
    'https://img1.baidu.com/it/u=922847932,2985620342&fm=253&fmt=auto&app=120&f=JPEG?w=1422&h=800',
  ];



  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    final gridItemW = (ABScreen.width - 32.px - 72.px)/4;
    final gridItemH = gridItemW + 28.px;


    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Column(
        children: [
          Container(
            color: theme.primaryColor,
            height: 58.px + ABScreen.statusHeight,
            width: double.infinity,
            child: Stack(
              children: [
                // 顶部背景
                Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: AspectRatio(
                        aspectRatio: 288/156,
                        child: Image.asset(ABAssets.homeTopBackground(context), fit: BoxFit.cover,))
                ),
                // 搜索框
                Positioned(
                  left: 16.px,
                  bottom: 16.px,
                  height: 38.px,
                  right: 16.px,
                  child: InkWell(
                    onTap: (){

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.white,
                        borderRadius: BorderRadius.circular(6.px),
                      ),
                      child: Row(
                        children: [
                          // 搜索图标
                          Padding(
                            padding: EdgeInsets.only(left: 14.px, right: 6.px),
                            child: Image.asset(ABAssets.homeSearchIcon(context), width: 16.px, height: 16.px,),
                          ),
                          ABText(AB_getS(context).search, textColor: HexColor("#B4B5B5"), fontSize: 14.px,)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 20.px,),
                SizedBox(
                  width: ABScreen.width,
                  // 轮播图
                  child: CarouselSlider(
                      items: _banner(),
                      options: CarouselOptions(
                        height: 160.px,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: false,
                        enlargeFactor: 0.3,
                        onPageChanged: (int index, CarouselPageChangedReason reason){

                        },
                        scrollDirection: Axis.horizontal,
                      )
                  ),
                ),
                SizedBox(height: 20.px,),
                // 推荐应用
                ABText(AB_getS(context).recommendAPP, fontSize: 20, fontWeight: FontWeight.w600,).addPadding(padding: EdgeInsets.symmetric(horizontal: 16.px)),
                SizedBox(height: 16.px,),
                GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.px),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //设置列数
                    crossAxisCount: 4,
                    //设置横向间距
                    crossAxisSpacing: 24.px,
                    //设置主轴间距
                    mainAxisSpacing: 18.px,
                    childAspectRatio: gridItemW/gridItemH,
                  ),
                  shrinkWrap: true, // 避免内部子项的尺寸影响外部容器的高度
                  itemCount: 8, // 总共20个项目
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        AspectRatio(aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                              child: ABImage.imageWithUrl(urls[index%(urls.length)], fit: BoxFit.cover)),
                        ),
                        SizedBox(height: 4.px),
                        ABText("Sanshu!", fontWeight: FontWeight.w600, fontSize: 14,),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20.px,),
                // 推荐应用
                ABText(AB_getS(context).hotAPP, fontSize: 20, fontWeight: FontWeight.w600,).addPadding(padding: EdgeInsets.symmetric(horizontal: 16.px)),
                SizedBox(height: 8.px,),
                ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.px),
                  itemBuilder: (BuildContext context, int index){
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: ABImage.imageWithUrl(urls[index%(urls.length)], width: 72.px, height: 72.px, fit: BoxFit.cover),
                        ),
                        SizedBox(width: 16.px,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ABText("Sanshu!", textColor: theme.textColor, fontSize: 16, fontWeight: FontWeight.w600,),
                            ABText("www.dappwangzhijiuzaizai .com", textColor: theme.textGrey,),
                          ]
                        ).expanded(),
                        Icon(CupertinoIcons.star_fill, color: theme.primaryColor, size: 24.px,),
                      ],
                    ).addPadding(padding: EdgeInsets.symmetric(vertical: 8.px));
                  },
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> _banner(){

    return urls.map((e){
      return Container(
        width: ABScreen.width,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
            child: ABImage.imageWithUrl(e, fit: BoxFit.cover)),
      );
    }).toList();
  }

}

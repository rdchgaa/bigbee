import 'package:bee_chat/main.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ABImage extends StatelessWidget {
  const ABImage({super.key});

  static Widget avatarUser(String avatarUrl, {double? width, double? height, bool isGroup = false}) {
    final assets = isGroup ? ABAssets.defaultGroupIcon(MyApp.context) : ABAssets.defaultUserIcon(MyApp.context);
    if (avatarUrl.isEmpty) {
      return Image.asset(assets, width: width, height: height, fit: BoxFit.cover,);
    }
    return CachedNetworkImage(
      imageUrl: avatarUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Stack(
          children: [
            Positioned.fill(child: Image.asset(assets, fit: BoxFit.cover,)),
            const Center(child: CupertinoActivityIndicator(radius: 10,)),
          ],
        );
      },
      errorWidget: (context, url, error) => Image.asset(ABAssets.defaultUserIcon(context), fit: BoxFit.cover,),
    );
  }


  static Widget imageWithUrl(String url, {double? width, double? height, BoxFit? fit,}) {
    if (url.isEmpty) {
      return Container(color: Colors.grey, height: height, width: width,);
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      // fadeOutDuration: Duration(milliseconds: 10),
      //   fadeInDuration: Duration(milliseconds: 10),
      placeholder: (context, url) {
        return Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.grey,)),
            // const Center(child: CupertinoActivityIndicator(radius: 10,)),
          ],
        );
      },
      errorWidget: (context, url, error) => Container(color: Colors.grey,),
    );
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }


}

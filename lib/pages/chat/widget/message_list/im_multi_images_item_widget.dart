import 'package:flutter/material.dart';

import '../../../../widget/ab_image.dart';

class ImMultiImagesItemWidget extends StatelessWidget {
  final List<String> images;
  final double width;
  final double horizontalAxisSpacing;
  final double verticalAxisSpacing;
  const ImMultiImagesItemWidget({super.key, required this.images, required this.width, this.horizontalAxisSpacing = 2, this.verticalAxisSpacing = 2});



  @override
  Widget build(BuildContext context) {
    List<String> temporaryUrls = [];
    List<Widget> widgets = [];
    for(int i = 0; i < images.length; i++){
      if(temporaryUrls.length < 3){
        temporaryUrls.add(images[i]);
      } else {
        if (widgets.isNotEmpty) {
          widgets.add(SizedBox(height: verticalAxisSpacing,));
        }
        widgets.add(_getThreeImageWidget(temporaryUrls[0], temporaryUrls[1], temporaryUrls[2]));
        temporaryUrls.clear();
        temporaryUrls.add(images[i]);
      }
    }
    if(temporaryUrls.length == 1){
      if (widgets.isNotEmpty) {
        widgets.add(SizedBox(height: verticalAxisSpacing,));
      }
      widgets.add(_getOneImageWidget(temporaryUrls[0]));
    } else if(temporaryUrls.length == 2){
      if (widgets.isNotEmpty) {
        widgets.add(SizedBox(height: verticalAxisSpacing,));
      }
      widgets.add(_getTwoImageWidget(temporaryUrls[0], temporaryUrls[1]));
    } else if(temporaryUrls.length == 3){
      if (widgets.isNotEmpty) {
        widgets.add(SizedBox(height: verticalAxisSpacing,));
      }
      widgets.add(_getThreeImageWidget(temporaryUrls[0], temporaryUrls[1], temporaryUrls[2]));
    }

    return Column(
      children: [
        ...widgets,
      ],
    );
  }


  Widget _getOneImageWidget(String imageUrl){
    return _getItemWidget(imageUrl, width);
  }

  Widget _getTwoImageWidget(String imageUrl1, String imageUrl2){
    final itemWidth = (width - horizontalAxisSpacing) / 2;
    return SizedBox(
      width: width,
      height: itemWidth,
      child: Row(
        children: [
          _getItemWidget(imageUrl1, itemWidth),
          SizedBox(width: horizontalAxisSpacing),
          _getItemWidget(imageUrl2, itemWidth),
        ],
      ),
    );
  }

  Widget _getThreeImageWidget(String imageUrl1, String imageUrl2, String imageUrl3){
    final itemWidth = (width - horizontalAxisSpacing * 2) / 3;
    return SizedBox(
      width: width,
      height: itemWidth,
      child: Row(
        children: [
          _getItemWidget(imageUrl1, itemWidth),
          SizedBox(width: horizontalAxisSpacing),
          _getItemWidget(imageUrl2, itemWidth),
          SizedBox(width: horizontalAxisSpacing),
          _getItemWidget(imageUrl3, itemWidth),
        ]
      )
    );
  }




  Widget _getItemWidget(String imageUrl, double itemWidth){
    return SizedBox(
      width: itemWidth,
      height: itemWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: ABImage.imageWithUrl(
          imageUrl + "?x-oss-process=image/resize,m_lfit,h_160,w_160",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}



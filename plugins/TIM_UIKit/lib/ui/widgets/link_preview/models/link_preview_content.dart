import 'dart:convert';

import 'package:flutter/cupertino.dart';

typedef LinkPreviewText = Widget Function({TextStyle? style});

class LocalCustomDataModel {
  final String? description;
  final String? image;
  final String? url;
  final String? title;
  final String? soundText;
  final bool? isLoading;
  final String? otherValue;
  String? translatedText;

  LocalCustomDataModel(
      {this.soundText, this.description, this.image, this.url, this.title, this.translatedText, this.otherValue, this.isLoading});

  Map<String, String?> toMap() {
    final Map<String, String?> data = {};
    data['url'] = url;
    data['image'] = image;
    data['title'] = title;
    data['description'] = description;
    data['translatedText'] = translatedText;
    data['soundText'] = soundText;
    data['isLoading'] = isLoading.toString();
    data['otherValue'] = otherValue;
    return data;
  }

  LocalCustomDataModel.fromMap(Map map)
      : description = map['description'],
        image = map['image'],
        url = map['url'],
        translatedText = map['translatedText'],
        soundText = map['soundText'],
        isLoading = map['isLoading'] == 'true' ? true : false,
        otherValue = map['otherValue'],
        title = map['title'];

  @override
  String toString() {
    return json.encode(toMap());
  }

  bool isLinkPreviewEmpty() {
    if ((image == null || image!.isEmpty) &&
        (title == null || title!.isEmpty) &&
        (description == null || description!.isEmpty)) {
      return true;
    }
    return false;
  }
}

class LinkPreviewContent {
  const LinkPreviewContent({
    this.linkInfo,
    this.linkPreviewWidget,
  });

  final LocalCustomDataModel? linkInfo;
  final Widget? linkPreviewWidget;
}

import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/im/custom_emoji_model.dart';

CustomEmojiModel $CustomEmojiModelFromJson(Map<String, dynamic> json) {
  final CustomEmojiModel customEmojiModel = CustomEmojiModel();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    customEmojiModel.id = id;
  }
  final String? identification = jsonConvert.convert<String>(json['identification']);
  if (identification != null) {
    customEmojiModel.identification = identification;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    customEmojiModel.name = name;
  }
  final String? imgUrl = jsonConvert.convert<String>(json['imgUrl']);
  if (imgUrl != null) {
    customEmojiModel.imgUrl = imgUrl;
  }
  final List<CustomEmojiEmoticonsInfoList>? emoticonsInfoList = (json['emoticonsInfoList'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<CustomEmojiEmoticonsInfoList>(e) as CustomEmojiEmoticonsInfoList).toList();
  if (emoticonsInfoList != null) {
    customEmojiModel.emoticonsInfoList = emoticonsInfoList;
  }
  return customEmojiModel;
}

Map<String, dynamic> $CustomEmojiModelToJson(CustomEmojiModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['identification'] = entity.identification;
  data['name'] = entity.name;
  data['imgUrl'] = entity.imgUrl;
  data['emoticonsInfoList'] = entity.emoticonsInfoList?.map((v) => v.toJson()).toList();
  return data;
}

extension CustomEmojiModelExtension on CustomEmojiModel {
  CustomEmojiModel copyWith({
    int? id,
    String? identification,
    String? name,
    String? imgUrl,
    List<CustomEmojiEmoticonsInfoList>? emoticonsInfoList,
  }) {
    return CustomEmojiModel()
      ..id = id ?? this.id
      ..identification = identification ?? this.identification
      ..name = name ?? this.name
      ..imgUrl = imgUrl ?? this.imgUrl
      ..emoticonsInfoList = emoticonsInfoList ?? this.emoticonsInfoList;
  }
}

CustomEmojiEmoticonsInfoList $CustomEmojiEmoticonsInfoListFromJson(Map<String, dynamic> json) {
  final CustomEmojiEmoticonsInfoList customEmojiEmoticonsInfoList = CustomEmojiEmoticonsInfoList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    customEmojiEmoticonsInfoList.id = id;
  }
  final String? identification = jsonConvert.convert<String>(json['identification']);
  if (identification != null) {
    customEmojiEmoticonsInfoList.identification = identification;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    customEmojiEmoticonsInfoList.name = name;
  }
  final String? imgUrl = jsonConvert.convert<String>(json['imgUrl']);
  if (imgUrl != null) {
    customEmojiEmoticonsInfoList.imgUrl = imgUrl;
  }
  return customEmojiEmoticonsInfoList;
}

Map<String, dynamic> $CustomEmojiEmoticonsInfoListToJson(CustomEmojiEmoticonsInfoList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['identification'] = entity.identification;
  data['name'] = entity.name;
  data['imgUrl'] = entity.imgUrl;
  return data;
}

extension CustomEmojiEmoticonsInfoListExtension on CustomEmojiEmoticonsInfoList {
  CustomEmojiEmoticonsInfoList copyWith({
    int? id,
    String? identification,
    String? name,
    String? imgUrl,
  }) {
    return CustomEmojiEmoticonsInfoList()
      ..id = id ?? this.id
      ..identification = identification ?? this.identification
      ..name = name ?? this.name
      ..imgUrl = imgUrl ?? this.imgUrl;
  }
}
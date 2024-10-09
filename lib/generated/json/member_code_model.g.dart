import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/user/member_code_model.dart';

MemberCodeModel $MemberCodeModelFromJson(Map<String, dynamic> json) {
  final MemberCodeModel memberCodeModel = MemberCodeModel();
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    memberCodeModel.code = code;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    memberCodeModel.url = url;
  }
  return memberCodeModel;
}

Map<String, dynamic> $MemberCodeModelToJson(MemberCodeModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['url'] = entity.url;
  return data;
}

extension MemberCodeModelExtension on MemberCodeModel {
  MemberCodeModel copyWith({
    String? code,
    String? url,
  }) {
    return MemberCodeModel()
      ..code = code ?? this.code
      ..url = url ?? this.url;
  }
}
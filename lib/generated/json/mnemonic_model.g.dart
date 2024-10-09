import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/user/mnemonic_model.dart';

MnemonicModel $MnemonicModelFromJson(Map<String, dynamic> json) {
  final MnemonicModel mnemonicModel = MnemonicModel();
  final String? mnemonic = jsonConvert.convert<String>(json['mnemonic']);
  if (mnemonic != null) {
    mnemonicModel.mnemonic = mnemonic;
  }
  return mnemonicModel;
}

Map<String, dynamic> $MnemonicModelToJson(MnemonicModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['mnemonic'] = entity.mnemonic;
  return data;
}

extension MnemonicModelExtension on MnemonicModel {
  MnemonicModel copyWith({
    String? mnemonic,
  }) {
    return MnemonicModel()
      ..mnemonic = mnemonic ?? this.mnemonic;
  }
}
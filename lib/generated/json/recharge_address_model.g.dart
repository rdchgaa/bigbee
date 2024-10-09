import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/recharge_address_model.dart';

RechargeAddressModel $RechargeAddressModelFromJson(Map<String, dynamic> json) {
  final RechargeAddressModel rechargeAddressModel = RechargeAddressModel();
  final String? rechargeAddress = jsonConvert.convert<String>(json['rechargeAddress']);
  if (rechargeAddress != null) {
    rechargeAddressModel.rechargeAddress = rechargeAddress;
  }
  return rechargeAddressModel;
}

Map<String, dynamic> $RechargeAddressModelToJson(RechargeAddressModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['rechargeAddress'] = entity.rechargeAddress;
  return data;
}

extension RechargeAddressModelExtension on RechargeAddressModel {
  RechargeAddressModel copyWith({
    String? rechargeAddress,
  }) {
    return RechargeAddressModel()
      ..rechargeAddress = rechargeAddress ?? this.rechargeAddress;
  }
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/recharge_address_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/recharge_address_model.g.dart';

@JsonSerializable()
class RechargeAddressModel {
	late String rechargeAddress;

	RechargeAddressModel();

	factory RechargeAddressModel.fromJson(Map<String, dynamic> json) => $RechargeAddressModelFromJson(json);

	Map<String, dynamic> toJson() => $RechargeAddressModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
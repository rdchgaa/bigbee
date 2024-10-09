import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/payouts_set_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/payouts_set_model.g.dart';

@JsonSerializable()
class PayoutsSetModel {
	dynamic createBy;
	late String createTime;
	dynamic updateBy;
	late String updateTime;
	dynamic remark;
	late int id;
	late int coinId;
	late double minQty;
	late double maxQty;
	late double quotaQty;
	late double feeRatio;
	late int status;

	PayoutsSetModel();

	factory PayoutsSetModel.fromJson(Map<String, dynamic> json) => $PayoutsSetModelFromJson(json);

	Map<String, dynamic> toJson() => $PayoutsSetModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
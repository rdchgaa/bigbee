import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/transfer_set_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/transfer_set_model.g.dart';

@JsonSerializable()
class TransferSetModel {
	dynamic createBy;
	late String createTime;
	dynamic updateBy;
	late String updateTime;
	dynamic remark;
	late int id;
	late int coinId;
	late double transferFeeRatio;
	late int status;

	TransferSetModel();

	factory TransferSetModel.fromJson(Map<String, dynamic> json) => $TransferSetModelFromJson(json);

	Map<String, dynamic> toJson() => $TransferSetModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
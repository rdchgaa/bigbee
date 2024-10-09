import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/recharge_records_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/recharge_records_model.g.dart';

@JsonSerializable()
class RechargeRecordsModel {
	late List<RechargeRecordsRecords> records;
	late int total;
	late int size;
	late int current;
	late List<dynamic> orders;
	late bool optimizeCountSql;
	late bool searchCount;
	dynamic countId;
	dynamic maxLimit;
	late int pages;

	RechargeRecordsModel();

	factory RechargeRecordsModel.fromJson(Map<String, dynamic> json) => $RechargeRecordsModelFromJson(json);

	Map<String, dynamic> toJson() => $RechargeRecordsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class RechargeRecordsRecords {
	late int memberRechargeId;
	late String coinName;
	late int status;
	late String rechargeAmount;
	late String arrivedAmount;
	late String rechargeTime;
	late String payAmount;

	RechargeRecordsRecords();

	factory RechargeRecordsRecords.fromJson(Map<String, dynamic> json) => $RechargeRecordsRecordsFromJson(json);

	Map<String, dynamic> toJson() => $RechargeRecordsRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
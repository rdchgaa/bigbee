import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/withdrawal_records_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/withdrawal_records_model.g.dart';

@JsonSerializable()
class WithdrawalRecordsModel {
	late List<WithdrawalRecordsRecords> records;
	late int total;
	late int size;
	late int current;
	late List<dynamic> orders;
	late bool optimizeCountSql;
	late bool searchCount;
	dynamic countId;
	dynamic maxLimit;
	late int pages;

	WithdrawalRecordsModel();

	factory WithdrawalRecordsModel.fromJson(Map<String, dynamic> json) => $WithdrawalRecordsModelFromJson(json);

	Map<String, dynamic> toJson() => $WithdrawalRecordsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class WithdrawalRecordsRecords {
	late int id;
	late int status;
	late int coinId;
	late String coinName;
	late double applyQty;
	late double toQty;
	late double fees;
	late String toAddress;
	late String createTime;

	WithdrawalRecordsRecords();

	factory WithdrawalRecordsRecords.fromJson(Map<String, dynamic> json) => $WithdrawalRecordsRecordsFromJson(json);

	Map<String, dynamic> toJson() => $WithdrawalRecordsRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
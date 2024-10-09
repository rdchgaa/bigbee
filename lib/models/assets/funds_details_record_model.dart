import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/funds_details_record_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/funds_details_record_model.g.dart';

@JsonSerializable()
class FundsDetailsRecordModel {
	late List<FundsDetailsRecordRecords> records;
	late int total;
	late int size;
	late int current;
	late List<dynamic> orders;
	late bool optimizeCountSql;
	late bool searchCount;
	dynamic countId;
	dynamic maxLimit;
	late int pages;

	FundsDetailsRecordModel();

	factory FundsDetailsRecordModel.fromJson(Map<String, dynamic> json) => $FundsDetailsRecordModelFromJson(json);

	Map<String, dynamic> toJson() => $FundsDetailsRecordModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class FundsDetailsRecordRecords {
	int? flowType;
	int? coinId;
	String? coinName;
	double? amount;
	String? operationDir;
	String? time;
	String? nickName;
	String? avatarUrl;
	int? status;
	double? refundQty;

	FundsDetailsRecordRecords();

	factory FundsDetailsRecordRecords.fromJson(Map<String, dynamic> json) => $FundsDetailsRecordRecordsFromJson(json);

	Map<String, dynamic> toJson() => $FundsDetailsRecordRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
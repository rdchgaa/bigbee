import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/transfer_records_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/transfer_records_model.g.dart';

@JsonSerializable()
class TransferRecordsModel {
	late List<TransferRecordsRecords> records;
	late int total;
	late int size;
	late int current;
	late List<dynamic> orders;
	late bool optimizeCountSql;
	late bool searchCount;
	dynamic countId;
	dynamic maxLimit;
	late int pages;

	TransferRecordsModel();

	factory TransferRecordsModel.fromJson(Map<String, dynamic> json) => $TransferRecordsModelFromJson(json);

	Map<String, dynamic> toJson() => $TransferRecordsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class TransferRecordsRecords {
	late int id;
	late int status;
	late int coinId;
	late String toAddress;
	late double qty;
	late double toQty;
	late double txFee;
	late String createTime;
	late String coinName;
	late String toMemberName;

	TransferRecordsRecords();

	factory TransferRecordsRecords.fromJson(Map<String, dynamic> json) => $TransferRecordsRecordsFromJson(json);

	Map<String, dynamic> toJson() => $TransferRecordsRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/payouts_address_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/payouts_address_list_model.g.dart';

@JsonSerializable()
class PayoutsAddressListModel {
	List<PayoutsAddressListRecords>? records;
	int? total;
	int? size;
	int? current;
	List<dynamic>? orders;
	bool? optimizeCountSql;
	bool? searchCount;
	dynamic countId;
	dynamic maxLimit;
	int? pages;

	PayoutsAddressListModel();

	factory PayoutsAddressListModel.fromJson(Map<String, dynamic> json) => $PayoutsAddressListModelFromJson(json);

	Map<String, dynamic> toJson() => $PayoutsAddressListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class PayoutsAddressListRecords {
	int? id;
	String? address;
	String? addressRemark;
	String? createTime;

	PayoutsAddressListRecords();

	factory PayoutsAddressListRecords.fromJson(Map<String, dynamic> json) => $PayoutsAddressListRecordsFromJson(json);

	Map<String, dynamic> toJson() => $PayoutsAddressListRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
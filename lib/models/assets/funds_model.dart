import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/funds_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/funds_model.g.dart';

@JsonSerializable()
class FundsModel {
	late String totalAmountToUSDT;
	late List<FundsCoinCapitalList> coinCapitalList;

	FundsModel();

	factory FundsModel.fromJson(Map<String, dynamic> json) => $FundsModelFromJson(json);

	Map<String, dynamic> toJson() => $FundsModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class FundsCoinCapitalList {
	late String coinName;
	late String amount;
	late int isItDisplayed;

	FundsCoinCapitalList();

	factory FundsCoinCapitalList.fromJson(Map<String, dynamic> json) => $FundsCoinCapitalListFromJson(json);

	Map<String, dynamic> toJson() => $FundsCoinCapitalListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
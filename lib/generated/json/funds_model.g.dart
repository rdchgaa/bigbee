import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/funds_model.dart';

FundsModel $FundsModelFromJson(Map<String, dynamic> json) {
  final FundsModel fundsModel = FundsModel();
  final String? totalAmountToUSDT = jsonConvert.convert<String>(json['totalAmountToUSDT']);
  if (totalAmountToUSDT != null) {
    fundsModel.totalAmountToUSDT = totalAmountToUSDT;
  }
  final List<FundsCoinCapitalList>? coinCapitalList = (json['coinCapitalList'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<FundsCoinCapitalList>(e) as FundsCoinCapitalList).toList();
  if (coinCapitalList != null) {
    fundsModel.coinCapitalList = coinCapitalList;
  }
  return fundsModel;
}

Map<String, dynamic> $FundsModelToJson(FundsModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['totalAmountToUSDT'] = entity.totalAmountToUSDT;
  data['coinCapitalList'] = entity.coinCapitalList.map((v) => v.toJson()).toList();
  return data;
}

extension FundsModelExtension on FundsModel {
  FundsModel copyWith({
    String? totalAmountToUSDT,
    List<FundsCoinCapitalList>? coinCapitalList,
  }) {
    return FundsModel()
      ..totalAmountToUSDT = totalAmountToUSDT ?? this.totalAmountToUSDT
      ..coinCapitalList = coinCapitalList ?? this.coinCapitalList;
  }
}

FundsCoinCapitalList $FundsCoinCapitalListFromJson(Map<String, dynamic> json) {
  final FundsCoinCapitalList fundsCoinCapitalList = FundsCoinCapitalList();
  final String? coinName = jsonConvert.convert<String>(json['coinName']);
  if (coinName != null) {
    fundsCoinCapitalList.coinName = coinName;
  }
  final String? amount = jsonConvert.convert<String>(json['amount']);
  if (amount != null) {
    fundsCoinCapitalList.amount = amount;
  }
  final int? isItDisplayed = jsonConvert.convert<int>(json['isItDisplayed']);
  if (isItDisplayed != null) {
    fundsCoinCapitalList.isItDisplayed = isItDisplayed;
  }
  return fundsCoinCapitalList;
}

Map<String, dynamic> $FundsCoinCapitalListToJson(FundsCoinCapitalList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['coinName'] = entity.coinName;
  data['amount'] = entity.amount;
  data['isItDisplayed'] = entity.isItDisplayed;
  return data;
}

extension FundsCoinCapitalListExtension on FundsCoinCapitalList {
  FundsCoinCapitalList copyWith({
    String? coinName,
    String? amount,
    int? isItDisplayed,
  }) {
    return FundsCoinCapitalList()
      ..coinName = coinName ?? this.coinName
      ..amount = amount ?? this.amount
      ..isItDisplayed = isItDisplayed ?? this.isItDisplayed;
  }
}
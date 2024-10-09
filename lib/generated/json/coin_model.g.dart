import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/assets/coin_model.dart';

CoinModel $CoinModelFromJson(Map<String, dynamic> json) {
  final CoinModel coinModel = CoinModel();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    coinModel.id = id;
  }
  final String? coinName = jsonConvert.convert<String>(json['coinName']);
  if (coinName != null) {
    coinModel.coinName = coinName;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    coinModel.url = url;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    coinModel.status = status;
  }
  final String? price = jsonConvert.convert<String>(json['price']);
  if (price != null) {
    coinModel.price = price;
  }
  return coinModel;
}

Map<String, dynamic> $CoinModelToJson(CoinModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['coinName'] = entity.coinName;
  data['url'] = entity.url;
  data['status'] = entity.status;
  data['price'] = entity.price;
  return data;
}

extension CoinModelExtension on CoinModel {
  CoinModel copyWith({
    int? id,
    String? coinName,
    String? url,
    int? status,
    String? price,
  }) {
    return CoinModel()
      ..id = id ?? this.id
      ..coinName = coinName ?? this.coinName
      ..url = url ?? this.url
      ..status = status ?? this.status
      ..price = price ?? this.price;
  }
}
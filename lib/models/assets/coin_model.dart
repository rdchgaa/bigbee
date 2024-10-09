import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/coin_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/coin_model.g.dart';

@JsonSerializable()
class CoinModel {
  int? id;
  String? coinName;
  String? url;
  int? status;
  String? price;

  CoinModel({this.id, this.coinName, this.url, this.status, this.price});

  factory CoinModel.fromJson(Map<String, dynamic> json) => $CoinModelFromJson(json);

  Map<String, dynamic> toJson() => $CoinModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }


  CoinModel copyWith({
    int? id,
    String? coinName,
    String? url,
    int? status,
    String? price,
  }) {
    return CoinModel(
      id: id ?? this.id,
      coinName: coinName ?? this.coinName,
      url: url ?? this.url,
      status: status ?? this.status,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coinName': coinName,
      'url': url,
      'status': status,
      'price': price,
    };
  }

  static CoinModel? fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return CoinModel(
      id: null == (temp = map['id']) ? null : (temp is num ? temp.toInt() : num.tryParse(temp)?.toInt()),
      coinName: map['coinName']?.toString(),
      url: map['url']?.toString(),
      status: null == (temp = map['status']) ? null : (temp is num ? temp.toInt() : num.tryParse(temp)?.toInt()),
      price: map['price']?.toString(),
    );
  }
}

import 'package:bee_chat/generated/json/base/json_convert_content.dart';
import 'package:bee_chat/models/baidu_map/reverse_geocoding_result_model.dart';

ReverseGeocodingResultModel $ReverseGeocodingResultModelFromJson(Map<String, dynamic> json) {
  final ReverseGeocodingResultModel reverseGeocodingResultModel = ReverseGeocodingResultModel();
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    reverseGeocodingResultModel.status = status;
  }
  final ReverseGeocodingResultResult? result = jsonConvert.convert<ReverseGeocodingResultResult>(json['result']);
  if (result != null) {
    reverseGeocodingResultModel.result = result;
  }
  return reverseGeocodingResultModel;
}

Map<String, dynamic> $ReverseGeocodingResultModelToJson(ReverseGeocodingResultModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['status'] = entity.status;
  data['result'] = entity.result?.toJson();
  return data;
}

extension ReverseGeocodingResultModelExtension on ReverseGeocodingResultModel {
  ReverseGeocodingResultModel copyWith({
    int? status,
    ReverseGeocodingResultResult? result,
  }) {
    return ReverseGeocodingResultModel()
      ..status = status ?? this.status
      ..result = result ?? this.result;
  }
}

ReverseGeocodingResultResult $ReverseGeocodingResultResultFromJson(Map<String, dynamic> json) {
  final ReverseGeocodingResultResult reverseGeocodingResultResult = ReverseGeocodingResultResult();
  final ReverseGeocodingResultResultAddressComponent? addressComponent = jsonConvert.convert<
      ReverseGeocodingResultResultAddressComponent>(json['addressComponent']);
  if (addressComponent != null) {
    reverseGeocodingResultResult.addressComponent = addressComponent;
  }
  final int? cityCode = jsonConvert.convert<int>(json['cityCode']);
  if (cityCode != null) {
    reverseGeocodingResultResult.cityCode = cityCode;
  }
  return reverseGeocodingResultResult;
}

Map<String, dynamic> $ReverseGeocodingResultResultToJson(ReverseGeocodingResultResult entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['addressComponent'] = entity.addressComponent?.toJson();
  data['cityCode'] = entity.cityCode;
  return data;
}

extension ReverseGeocodingResultResultExtension on ReverseGeocodingResultResult {
  ReverseGeocodingResultResult copyWith({
    ReverseGeocodingResultResultAddressComponent? addressComponent,
    int? cityCode,
  }) {
    return ReverseGeocodingResultResult()
      ..addressComponent = addressComponent ?? this.addressComponent
      ..cityCode = cityCode ?? this.cityCode;
  }
}

ReverseGeocodingResultResultAddressComponent $ReverseGeocodingResultResultAddressComponentFromJson(
    Map<String, dynamic> json) {
  final ReverseGeocodingResultResultAddressComponent reverseGeocodingResultResultAddressComponent = ReverseGeocodingResultResultAddressComponent();
  final String? country = jsonConvert.convert<String>(json['country']);
  if (country != null) {
    reverseGeocodingResultResultAddressComponent.country = country;
  }
  final int? countryCode = jsonConvert.convert<int>(json['country_code']);
  if (countryCode != null) {
    reverseGeocodingResultResultAddressComponent.countryCode = countryCode;
  }
  final String? countryCodeIso = jsonConvert.convert<String>(json['country_code_iso']);
  if (countryCodeIso != null) {
    reverseGeocodingResultResultAddressComponent.countryCodeIso = countryCodeIso;
  }
  final String? countryCodeIso2 = jsonConvert.convert<String>(json['country_code_iso2']);
  if (countryCodeIso2 != null) {
    reverseGeocodingResultResultAddressComponent.countryCodeIso2 = countryCodeIso2;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    reverseGeocodingResultResultAddressComponent.province = province;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    reverseGeocodingResultResultAddressComponent.city = city;
  }
  final int? cityLevel = jsonConvert.convert<int>(json['city_level']);
  if (cityLevel != null) {
    reverseGeocodingResultResultAddressComponent.cityLevel = cityLevel;
  }
  final String? district = jsonConvert.convert<String>(json['district']);
  if (district != null) {
    reverseGeocodingResultResultAddressComponent.district = district;
  }
  final String? town = jsonConvert.convert<String>(json['town']);
  if (town != null) {
    reverseGeocodingResultResultAddressComponent.town = town;
  }
  final String? townCode = jsonConvert.convert<String>(json['town_code']);
  if (townCode != null) {
    reverseGeocodingResultResultAddressComponent.townCode = townCode;
  }
  final String? distance = jsonConvert.convert<String>(json['distance']);
  if (distance != null) {
    reverseGeocodingResultResultAddressComponent.distance = distance;
  }
  final String? direction = jsonConvert.convert<String>(json['direction']);
  if (direction != null) {
    reverseGeocodingResultResultAddressComponent.direction = direction;
  }
  final String? adcode = jsonConvert.convert<String>(json['adcode']);
  if (adcode != null) {
    reverseGeocodingResultResultAddressComponent.adcode = adcode;
  }
  final String? street = jsonConvert.convert<String>(json['street']);
  if (street != null) {
    reverseGeocodingResultResultAddressComponent.street = street;
  }
  final String? streetNumber = jsonConvert.convert<String>(json['street_number']);
  if (streetNumber != null) {
    reverseGeocodingResultResultAddressComponent.streetNumber = streetNumber;
  }
  return reverseGeocodingResultResultAddressComponent;
}

Map<String, dynamic> $ReverseGeocodingResultResultAddressComponentToJson(
    ReverseGeocodingResultResultAddressComponent entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['country'] = entity.country;
  data['country_code'] = entity.countryCode;
  data['country_code_iso'] = entity.countryCodeIso;
  data['country_code_iso2'] = entity.countryCodeIso2;
  data['province'] = entity.province;
  data['city'] = entity.city;
  data['city_level'] = entity.cityLevel;
  data['district'] = entity.district;
  data['town'] = entity.town;
  data['town_code'] = entity.townCode;
  data['distance'] = entity.distance;
  data['direction'] = entity.direction;
  data['adcode'] = entity.adcode;
  data['street'] = entity.street;
  data['street_number'] = entity.streetNumber;
  return data;
}

extension ReverseGeocodingResultResultAddressComponentExtension on ReverseGeocodingResultResultAddressComponent {
  ReverseGeocodingResultResultAddressComponent copyWith({
    String? country,
    int? countryCode,
    String? countryCodeIso,
    String? countryCodeIso2,
    String? province,
    String? city,
    int? cityLevel,
    String? district,
    String? town,
    String? townCode,
    String? distance,
    String? direction,
    String? adcode,
    String? street,
    String? streetNumber,
  }) {
    return ReverseGeocodingResultResultAddressComponent()
      ..country = country ?? this.country
      ..countryCode = countryCode ?? this.countryCode
      ..countryCodeIso = countryCodeIso ?? this.countryCodeIso
      ..countryCodeIso2 = countryCodeIso2 ?? this.countryCodeIso2
      ..province = province ?? this.province
      ..city = city ?? this.city
      ..cityLevel = cityLevel ?? this.cityLevel
      ..district = district ?? this.district
      ..town = town ?? this.town
      ..townCode = townCode ?? this.townCode
      ..distance = distance ?? this.distance
      ..direction = direction ?? this.direction
      ..adcode = adcode ?? this.adcode
      ..street = street ?? this.street
      ..streetNumber = streetNumber ?? this.streetNumber;
  }
}
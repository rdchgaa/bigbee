import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/reverse_geocoding_result_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/reverse_geocoding_result_model.g.dart';

@JsonSerializable()
class ReverseGeocodingResultModel {
	int? status;
	ReverseGeocodingResultResult? result;

	ReverseGeocodingResultModel();

	factory ReverseGeocodingResultModel.fromJson(Map<String, dynamic> json) => $ReverseGeocodingResultModelFromJson(json);

	Map<String, dynamic> toJson() => $ReverseGeocodingResultModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ReverseGeocodingResultResult {
	ReverseGeocodingResultResultAddressComponent? addressComponent;
	int? cityCode;

	ReverseGeocodingResultResult();

	factory ReverseGeocodingResultResult.fromJson(Map<String, dynamic> json) => $ReverseGeocodingResultResultFromJson(json);

	Map<String, dynamic> toJson() => $ReverseGeocodingResultResultToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ReverseGeocodingResultResultAddressComponent {
	String? country;
	@JSONField(name: "country_code")
	int? countryCode;
	@JSONField(name: "country_code_iso")
	String? countryCodeIso;
	@JSONField(name: "country_code_iso2")
	String? countryCodeIso2;
	String? province;
	String? city;
	@JSONField(name: "city_level")
	int? cityLevel;
	String? district;
	String? town;
	@JSONField(name: "town_code")
	String? townCode;
	String? distance;
	String? direction;
	String? adcode;
	String? street;
	@JSONField(name: "street_number")
	String? streetNumber;

	ReverseGeocodingResultResultAddressComponent();

	factory ReverseGeocodingResultResultAddressComponent.fromJson(Map<String, dynamic> json) => $ReverseGeocodingResultResultAddressComponentFromJson(json);

	Map<String, dynamic> toJson() => $ReverseGeocodingResultResultAddressComponentToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
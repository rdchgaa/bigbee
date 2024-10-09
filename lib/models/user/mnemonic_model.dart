import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/mnemonic_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/mnemonic_model.g.dart';

@JsonSerializable()
class MnemonicModel {
	String? mnemonic;

	MnemonicModel();

	factory MnemonicModel.fromJson(Map<String, dynamic> json) => $MnemonicModelFromJson(json);

	Map<String, dynamic> toJson() => $MnemonicModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
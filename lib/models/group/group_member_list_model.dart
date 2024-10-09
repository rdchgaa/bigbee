import 'package:bee_chat/generated/json/base/json_field.dart';
import 'package:bee_chat/generated/json/group_member_list_model.g.dart';
import 'dart:convert';
export 'package:bee_chat/generated/json/group_member_list_model.g.dart';

@JsonSerializable()
class GroupMemberListModel {
	String? memberNum;
	String? nickName;
	String? displayName;
	String? avatarUrl;
	String? isOnline;
	// 1:群主
	int? isGroupLeader;
	// 1:管理员
	int? isAdministrators;
  // 是否被禁言（1：否、2：是）
  int? isForbiddenSpeech;


	GroupMemberListModel(
      {this.memberNum,
      this.nickName,
      this.displayName,
      this.avatarUrl,
      this.isOnline,
      this.isGroupLeader,
      this.isAdministrators});

  factory GroupMemberListModel.fromJson(Map<String, dynamic> json) => $GroupMemberListModelFromJson(json);

	Map<String, dynamic> toJson() => $GroupMemberListModelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}


	GroupMemberListModel copyWith({
    String? memberNum,
    String? nickName,
    String? displayName,
    String? avatarUrl,
    String? isOnline,
    int? isGroupLeader,
    int? isAdministrators,
  }) {
    return GroupMemberListModel(
      memberNum: memberNum ?? this.memberNum,
      nickName: nickName ?? this.nickName,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      isGroupLeader: isGroupLeader ?? this.isGroupLeader,
      isAdministrators: isAdministrators ?? this.isAdministrators,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'nickName': nickName,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'isGroupLeader': isGroupLeader,
      'isAdministrators': isAdministrators,
    };
  }

  static GroupMemberListModel? fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return GroupMemberListModel(
      memberNum: map['memberNum']?.toString(),
      nickName: map['nickName']?.toString(),
      displayName: map['displayName']?.toString(),
      avatarUrl: map['avatarUrl']?.toString(),
      isOnline: map['isOnline']?.toString(),
      isGroupLeader:
          null == (temp = map['isGroupLeader']) ? null : (temp is num ? temp.toInt() : num.tryParse(temp)?.toInt()),
      isAdministrators:
          null == (temp = map['isAdministrators']) ? null : (temp is num ? temp.toInt() : num.tryParse(temp)?.toInt()),
    );
  }
}
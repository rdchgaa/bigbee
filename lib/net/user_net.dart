import 'dart:async';

import 'package:bee_chat/models/user/invite_list_model.dart';
import 'package:bee_chat/models/user/login_model.dart';
import 'package:bee_chat/models/user/member_code_model.dart';
import 'package:bee_chat/models/user/user_list_model.dart';

import '../models/common/empty_model.dart';
import '../models/user/mnemonic_model.dart';
import '../models/user/user_detail_model.dart';
import '../utils/net/ab_Net.dart';
import '../utils/net/net_model.dart';
import 'api.dart';

class UserNet {
  /* 注册-账号密码
  * username: 用户名
  * password: 密码
  * code: 验证码
  * uuid: 验证码 uuid
  * inviteCode: 邀请码
  * */
  static Future<RequestResult<LoginModel>> register(
      {required String username, required String password, String? code, String? uuid, String? inviteCode}) {
    final Map<String, dynamic> params = {
      "username": username,
      "password": password,
    };
    if (code != null && uuid != null) {
      params["code"] = code;
      params["uuid"] = uuid;
    }
    if (inviteCode != null) {
      params["inviteCode"] = inviteCode;
    }

    return ABNet.request(path: registerApi, method: HttpMethod.post, params: params);
  }

  /* 退出登录
  * */
  static Future<RequestResult<EmptyModel>> logout() {
    return ABNet.request(path: logoutApi, method: HttpMethod.get, isShowTip: false);
  }

  /* 账号登录
  * username: 用户名
  * password: 密码
  * code: 验证码
  * uuid: 验证码 uuid
  * */
  static Future<RequestResult<LoginModel>> login(
      {required String username, required String password, String? code, String? uuid}) {
    final Map<String, dynamic> params = {
      "username": username,
      "password": password,
    };
    if (code != null && uuid != null) {
      params["code"] = code;
      params["uuid"] = uuid;
    }
    return ABNet.request(path: loginApi, method: HttpMethod.post, params: params);
  }

  // 助记词-是否绑定助记词
  static Future<RequestResult<bool>> isBindMnemonic() async {
    return ABNet.request(path: isBindMnemonicApi, method: HttpMethod.get, isShowTip: false);
  }

  /* 获取助记词
  * */
  static Future<RequestResult<MnemonicModel>> getMnemonic() async {
    return ABNet.request(path: getMnemonicApi, method: HttpMethod.post, isShowTip: false);
  }

  /* 验证 助记词 是否正确
  * mnemonic: 助记词
  * */
  static Future<RequestResult<EmptyModel>> checkMnemonic({required String mnemonic}) async {
    return ABNet.request(path: checkMnemonicApi, method: HttpMethod.post, params: {
      "mnemonicPhrase": mnemonic,
    });
  }

  /* 忘记密码-验证助记词
  * mnemonic: 助记词
  * */
  static Future<RequestResult<MnemonicModel>> checkMnemonicForget({required String mnemonic}) async {
    return ABNet.request(path: checkMnemonicForgetApi, method: HttpMethod.post, params: {
      "mnemonicPhrase": mnemonic,
    });
  }

  /* 忘记密码-重设密码
  * UUID: 助记词UUID
  * password: 密码
  * */
  static Future<RequestResult<EmptyModel>> resetPassword({required String uuid, required String password}) async {
    return ABNet.request(path: resetPasswordApi, method: HttpMethod.post, params: {
      "code": uuid,
      "newPassword": password,
    });
  }

  /* 获取用户列表
  * */
  static Future<RequestResult<PageModel<UserListModel>>> userList(
      {String nickName = "", int page = 1, int pageSize = 10}) {
    return ABNet.requestPage(
        path: searchFriendApi,
        method: HttpMethod.get,
        params: {
          "nickName": nickName,
          "pageNum": page,
          "pageSize": pageSize,
        },
        isShowTip: false);
  }

  /* 添加好友
  * userId: 好友ID(IM的userId)
  * */
  static Future<RequestResult<EmptyModel>> addFriend({required String userId}) {
    return ABNet.request(
        path: addFriendApi,
        method: HttpMethod.post,
        params: {
          "memberNum": userId,
        },
        isShowTip: false);
  }

  /* 获取用户信息
  * userId: 用户ID(IM的userId)
  * */
  static Future<RequestResult<UserDetailModel>> getUserInfo({required String userId}) async {
    return ABNet.request(path: getUserInfoApi, method: HttpMethod.get, params: {
      "imUserId": userId,
    });
  }

  // 更新好友备注
  static Future<RequestResult<EmptyModel>> updateFriendInfo({required String userId, required String remark}) {
    return ABNet.request(
        path: updateFriendInfoApi,
        method: HttpMethod.post,
        params: {
          "friendUUid": userId,
          "niceName": remark,
        },
        isShowTip: false);
  }

  /* 获取邀请码
  * */
  static Future<RequestResult<MemberCodeModel>> getUserMemberCode() async {
    return ABNet.request(path: getMemberCode, method: HttpMethod.get, params: {});
  }

  /* 获取邀请码
  * */
  static Future<RequestResult<InviteListModel>> userGetInviteList({int pageNum = 0, int? pageSize = 10}) async {
    return ABNet.request(path: getInviteList, method: HttpMethod.get, params: {
      "pageNum": pageNum,
      "pageSize": pageSize,
    });
  }

  /* 助记词-获取已绑定的助记词
  * */
  static Future<RequestResult<MnemonicModel>> userGetBindMemberMnemonicPhrase() async {
    return ABNet.request(path: getBindMemberMnemonicPhrase, method: HttpMethod.get, isShowTip: false);
  }

  /* 修改密码-用户修改密码
  * */
  static Future<RequestResult<EmptyModel>> userUpdateUserPassword({
    required String oldPassword,
    required String newPassword,
  }) {
    final Map<String, dynamic> params = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
    return ABNet.request(path: updateUserPassword, method: HttpMethod.post, params: params);
  }
}

import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/assets/funds_details_record_model.dart';
import 'package:bee_chat/models/assets/funds_model.dart';
import 'package:bee_chat/models/assets/google_is_bind_model.dart';
import 'package:bee_chat/models/assets/google_qrcode_model.dart';
import 'package:bee_chat/models/assets/google_secret_key_model.dart';
import 'package:bee_chat/models/assets/payouts_address_list_model.dart';
import 'package:bee_chat/models/assets/payouts_set_model.dart';
import 'package:bee_chat/models/assets/recharge_address_model.dart';
import 'package:bee_chat/models/assets/recharge_records_model.dart';
import 'package:bee_chat/models/assets/transfer_records_model.dart';
import 'package:bee_chat/models/assets/transfer_set_model.dart';
import 'package:bee_chat/models/assets/withdrawal_records_model.dart';
import 'package:bee_chat/models/common/empty_model.dart';
import '../utils/net/ab_Net.dart';
import '../utils/net/net_model.dart';
import 'api.dart';

class AssetsNet {
  /* 币种列表
  * */
  static Future<RequestResult<List<CoinModel>>> getCoinList() {
    return ABNet.request(path: coinList, method: HttpMethod.get);
  }

  /* 托管钱包资金查询
  * */
  static Future<RequestResult<FundsModel>> getFunds() {
    return ABNet.request(path: escrowFundsGetFunds, method: HttpMethod.get);
  }

  /* 币种资产显示/隐藏
  * */
  static Future<RequestResult<EmptyModel>> displayFunds({required String fundsName, required bool switchCapital}) {
    return ABNet.request(
        path: fundsDisplayFunds,
        method: HttpMethod.get,
        params: {"fundsName": fundsName, "switchCapital": switchCapital},
        isShowTip: false);
  }

  /* 资产记录-活动记录
  * */
  static Future<RequestResult<FundsDetailsRecordModel>> getActivityRecord(
      {required int pageNum, required int flowType, int? coinId}) {
    var params = {"pageNum": pageNum, "pageSize": 10, "flowType": flowType};
    if (coinId != null) {
      params = {"pageNum": pageNum, "pageSize": 10, "flowType": flowType, "coinId": coinId};
    }
    return ABNet.request(
        path: getFundsDetailActivity,
        method: HttpMethod.get,
        params: params);
  }

  /* 获取充值地址
  * */
  static Future<RequestResult<RechargeAddressModel>> assetsGetRechargeAddress({required int coinId}) {
    return ABNet.request(path: getRechargeAddress, method: HttpMethod.get, params: {
      "coinId": coinId,
    });
  }

  /* 提现设置
  * */
  static Future<RequestResult<PayoutsSetModel>> assetsGetPayoutsSet({required int coinId}) {
    return ABNet.request(
        path: getPayoutsSet,
        method: HttpMethod.get,
        params: {
          "coinId": coinId,
        },
        isShowTip: false);
  }

  /* 发起提现申请
  * */
  static Future<RequestResult<EmptyModel>> assetsSendPayouts(
      {required int coinId, required double amount, required String toAddress, required int googleCode}) {
    return ABNet.request(path: sendPayouts, method: HttpMethod.post, params: {
      "coinId": coinId,
      "amount": amount,
      "toAddress": toAddress,
      "googleCode": googleCode,
    });
  }

  /* 发起转账
  * */
  static Future<RequestResult<EmptyModel>> assetsSendTransfer(
      {required int coinId, required double qty, required String toMemberId, required int googleCode}) {
    return ABNet.request(path: sendTransfer, method: HttpMethod.post, params: {
      "coinId": coinId,
      "qty": qty,
      "toMemberId": toMemberId,
      "googleCode": googleCode,
    });
  }

  /* 获取用户指定币种可用金额
  * */
  static Future<RequestResult<String>> assetsGetMemberUseCapital({required int coinId}) {
    return ABNet.request(path: getMemberUseCapital, method: HttpMethod.get, params: {
      "coinId": coinId,
    });
  }

  /* 获取充值记录列表
  * */
  static Future<RequestResult<RechargeRecordsModel>> assetsGetReChargeList({required int pageNum, int? coinId}) {
    var params = {"pageNum": pageNum, "pageSize": 10};
    if (coinId != null) {
      params = {"pageNum": pageNum, "pageSize": 10, "coinId": coinId};
    }
    return ABNet.request(path: getReChargeList, method: HttpMethod.get, params: params);
  }

  /* 查询提现记录
  * */
  static Future<RequestResult<WithdrawalRecordsModel>> assetsPayoutsList({required int pageNum, int? coinId}) {
    var params = {"pageNum": pageNum, "pageSize": 10};
    if (coinId != null) {
      params = {"pageNum": pageNum, "pageSize": 10, "coinId": coinId};
    }
    return ABNet.request(path: payoutsList, method: HttpMethod.get, params: params);
  }

  /* 查询转账记录
  * */
  static Future<RequestResult<TransferRecordsModel>> assetsTransferList({required int pageNum, int? coinId}) {
    var params = {"pageNum": pageNum, "pageSize": 10};
    if (coinId != null) {
      params = {"pageNum": pageNum, "pageSize": 10, "coinId": coinId};
    }
    return ABNet.request(path: transferList, method: HttpMethod.get, params: params);
  }

  /* 转账设置
  * */
  static Future<RequestResult<TransferSetModel>> assetsGetTransferSet({required int coinId}) {
    return ABNet.request(path: getTransferSet, method: HttpMethod.get, params: {"coinId": coinId});
  }

  /* 获取谷歌验证的密钥
  * */
  static Future<RequestResult<GoogleSecretKeyModel>> assetsGetSecretKey() {
    return ABNet.request(path: getSecretKey, method: HttpMethod.get, params: {});
  }

  /* 获取谷歌获取验证码
  * */
  static Future<RequestResult<GoogleQrcodeModel>> assetsGetQrcode() {
    return ABNet.request(path: getQrcode, method: HttpMethod.get, params: {});
  }

  /* 验证 code 是否正确
  * */
  static Future<RequestResult<EmptyModel>> assetsCheckCode({required String code}) {
    return ABNet.request(path: checkCode, method: HttpMethod.get, params: {"code": code});
  }

  /* 是否已绑定
  * */
  static Future<RequestResult<GoogleIsBindModel>> assetsGoogleIsBind() {
    return ABNet.request(path: googleIsBind, method: HttpMethod.get, params: {});
  }

  /* 收藏地址-修改收藏地址
  * */
  static Future<RequestResult<EmptyModel>> assetsPayoutsAddressEdit({
    required int id,
    required String address,
    required String remark,
  }) {
    return ABNet.request(path: payoutsAddressEdit, method: HttpMethod.get, params: {
      "id": id,
      "address": address,
      "remark": remark,
    });
  }

  /* 收藏地址-取消收藏
  * */
  static Future<RequestResult<EmptyModel>> assetsCanCollectAddress({
    required int id,
  }) {
    return ABNet.request(path: canCollectAddress, method: HttpMethod.get, params: {
      "id": id,
    });
  }

  /* 收藏地址-添加收藏
  * */
  static Future<RequestResult<EmptyModel>> assetsPayoutsAddressAdd({
    required String address,
    required String remark,
  }) {
    return ABNet.request(path: payoutsAddressAdd, method: HttpMethod.get, params: {
      "address": address,
      "remark": remark,
    });
  }

  /* 收藏地址-收藏地址列表
  * */
  static Future<RequestResult<PayoutsAddressListModel>> assetsPayoutsAddressList({
    required int pageNum,
  }) {
    return ABNet.request(path: payoutsAddressList, method: HttpMethod.get, params: {
      "pageNum": pageNum,
      "pageSize": 10,
    });
  }
}

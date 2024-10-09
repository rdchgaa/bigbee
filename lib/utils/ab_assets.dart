import 'package:flutter/cupertino.dart';

import '../provider/theme_provider.dart';

const String imageAssets = "assets/images/";

class ABAssets {

  // 空数据
  static String emptyIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/empty_data.png";
    }
    return "${imageAssets}common/empty_data.png";
  }

  // 带文字logo
  static String logoText(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}login_register/logo_text.png";
    }
    return "${imageAssets}login_register/logo_text.png";
  }

  // 登录注册页背景
  static String startBackground(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}login_register/start_background.png";
    }
    return "${imageAssets}login_register/start_background.png";
  }

  // 选中图标
  static String selectedIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/selected_icon.png";
    }
    return "${imageAssets}common/selected_icon.png";
  }
  // 未选中图标
  static String unSelectedIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/unselected_icon.png";
    }
    return "${imageAssets}common/unselected_icon.png";
  }

  // 删除图标
  static String deleteIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/delete_icon.png";
    }
    return "${imageAssets}common/delete_icon.png";
  }

  // 搜索删除图标
  static String searchDeleteIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/search_delete_icon.png";
    }
    return "${imageAssets}common/search_delete_icon.png";
  }

  // 添加图标
  static String addIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/add_icon.png";
    }
    return "${imageAssets}common/add_icon.png";
  }

  // 邀请图标
  static String loginInvitedIcon(BuildContext context, {bool isSelect = false}) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}login_register/invited_icon${isSelect ? "_sel" : ""}.png";
    }
    return "${imageAssets}login_register/invited_icon${isSelect ? "_sel" : ""}.png";
  }

  // 昵称图标
  static String loginNicknameIcon(BuildContext context, {bool isSelect = false}) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}login_register/nickname_icon${isSelect ? "_sel" : ""}.png";
    }
    return "${imageAssets}login_register/nickname_icon${isSelect ? "_sel" : ""}.png";
  }

  // 密码图标
  static String loginPasswordIcon(BuildContext context, {bool isSelect = false}) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}login_register/password_icon${isSelect ? "_sel" : ""}.png";
    }
    return "${imageAssets}login_register/password_icon${isSelect ? "_sel" : ""}.png";
  }

  // tabbar 首页图标
  static String tabbarHomeIcon(BuildContext context, {bool isSelect = false}) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}tabbar/tabbar_home${isSelect ? "_sel" : ""}.png";
    }
    return "${imageAssets}tabbar/tabbar_home${isSelect ? "_sel" : ""}.png";
  }

  // tabbar 行情图标
  static String tabbarHangqingIcon(BuildContext context, {bool isSelect = false}) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}tabbar/tabbar_hangqing${isSelect ? "_sel" : ""}.png";
    }
    return "${imageAssets}tabbar/tabbar_hangqing${isSelect ? "_sel" : ""}.png";
  }

  // tabbar 动态图标
  static String tabbarDynamicIcon(BuildContext context, {bool isSelect = false}) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}tabbar/tabbar_dynamic${isSelect ? "_sel" : ""}.png";
    }
    return "${imageAssets}tabbar/tabbar_dynamic${isSelect ? "_sel" : ""}.png";
  }

  // tabbar 发现图标
  static String tabbarFindIcon(BuildContext context, {bool isSelect = false}) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}tabbar/tabbar_find${isSelect ? "_sel" : ""}.png";
    }
    return "${imageAssets}tabbar/tabbar_find${isSelect ? "_sel" : ""}.png";
  }

  // tabbar user图标
  static String tabbarUserIcon(BuildContext context, {bool isSelect = false}) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}tabbar/tabbar_user${isSelect ? "_sel" : ""}.png";
    }
    return "${imageAssets}tabbar/tabbar_user${isSelect ? "_sel" : ""}.png";
  }

  // 首页搜索图标
  static String homeSearchIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}home/home_search.png";
    }
    return "${imageAssets}home/home_search.png";
  }

  // 首页顶部背景
  static String homeTopBackground(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}home/home_top_background.png";
    }
    return "${imageAssets}home/home_top_background.png";
  }

  // 首页+图标
  static String homeAddIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}home/home_add.png";
    }
    return "${imageAssets}home/home_add.png";
  }

  // 首页开始聊天图标
  static String homeStartChatIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}home/home_start_chat.png";
    }
    return "${imageAssets}home/home_start_chat.png";
  }
  // 首页创建群聊图标
  static String homeCreateGroupIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}home/home_create_group_chat.png";
    }
    return "${imageAssets}home/home_create_group_chat.png";
  }
  // 首页搜索群聊图标
  static String homeSearchGroupIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}home/home_search_group_chat.png";
    }
    return "${imageAssets}home/home_search_group_chat.png";
  }
  // 首页会议图标
  static String homeMeetingIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}home/home_meeting.png";
    }
    return "${imageAssets}home/home_meeting.png";
  }
  // 首页扫一扫图标
  static String homeScanIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}home/home_scan.png";
    }
    return "${imageAssets}home/home_scan.png";
  }
  // 首页添加好友图标
  static String homeAddFriendIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}home/home_add_friend.png";
    }
    return "${imageAssets}home/home_add_friend.png";
  }

  // 错误图标
  static String errorIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/error_icon.png";
    }
    return "${imageAssets}common/error_icon.png";
  }

  // 默认用户头像
  static String defaultUserIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/avatar_default_user.png";
    }
    return "${imageAssets}common/avatar_default_user.png";
  }

  // 默认群头像
  static String defaultGroupIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/avatar_default_group.png";
    }
    return "${imageAssets}common/avatar_default_group.png";
  }

  // 搜索灰色图标
  static String searchGreyIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/search_grey.png";
    }
    return "${imageAssets}common/search_grey.png";
  }

  // im消息气泡背景别人
  static String imBubbleBgSelf(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_bubble_bg_self.png";
    }
    return "${imageAssets}im/im_bubble_bg_self.png";
  }

  // im消息气泡背景自己
  static String imBubbleBgOther(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_bubble_bg_other.png";
    }
    return "${imageAssets}im/im_bubble_bg_other.png";
  }

  // im消息语音播放图
  static String imSoundPlayImage(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_sound_play.png";
    }
    return "${imageAssets}im/im_sound_play.png";
  }

  // im消息语音播放gif
  static String imSoundPlayGif(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_sound_play.gif";
    }
    return "${imageAssets}im/im_sound_play.gif";
  }

  // im跳转到未读消息icon
  static String imJumpToUnreadIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_jump_to_unread.png";
    }
    return "${imageAssets}im/im_jump_to_unread.png";
  }

  // im系统头像
  static String imSystemIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_system_icon.png";
    }
    return "${imageAssets}im/im_system_icon.png";
  }
  // im消息红包图标
  static String imRedEnvelopeIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_red_envelope_icon.png";
    }
    return "${imageAssets}im/im_red_envelope_icon.png";
  }
  // im消息红包图标（已领取）
  static String imRedEnvelopeIconReceived(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_red_envelope_icon_received.png";
    }
    return "${imageAssets}im/im_red_envelope_icon_received.png";
  }

  // im消息红包背景自己
  static String imRedEnvelopeBgSelf(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_red_envelope_bg_self.png";
    }
    return "${imageAssets}im/im_red_envelope_bg_self.png";
  }

  // im消息红包背景他人
  static String imRedEnvelopeBgOther(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/im_red_envelope_bg_other.png";
    }
    return "${imageAssets}im/im_red_envelope_bg_other.png";
  }

  // 动态搜索图标
  static String dynamicSearchIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_search_icon.png";
    }
    return "${imageAssets}dynamic/dynamic_search_icon.png";
  }

  // 动态热门图标
  static String dynamicHotIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_hot_icon.png";
    }
    return "${imageAssets}dynamic/dynamic_hot_icon.png";
  }

  // 动态评论图标
  static String dynamicCommentIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_comment.png";
    }
    return "${imageAssets}dynamic/dynamic_comment.png";
  }

  // 动态点赞图标
  static String dynamicLikeIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_like.png";
    }
    return "${imageAssets}dynamic/dynamic_like.png";
  }

  // 动态查看图标
  static String dynamicLookIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_look.png";
    }
    return "${imageAssets}dynamic/dynamic_look.png";
  }

  // 动态发送图标
  static String dynamicSendIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_send.png";
    }
    return "${imageAssets}dynamic/dynamic_send.png";
  }

  // 更新Icon
  static String updateIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/update_icon.png";
    }
    return "${imageAssets}common/update_icon.png";
  }

  // 更新背景
  static String updateBg(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/update_bg.png";
    }
    return "${imageAssets}common/update_bg.png";
  }

  // 用户vip
  static String userVip(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}user/user_vip.png";
    }
    return "${imageAssets}user/user_vip.png";
  }

  // 用户聊天
  static String userChat(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}user/user_chat.png";
    }
    return "${imageAssets}user/user_chat.png";
  }

  // 用户视频
  static String userVideo(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}user/user_video.png";
    }
    return "${imageAssets}user/user_video.png";
  }

  // 群成员
  static String groupMemberIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}user/user_group_member.png";
    }
    return "${imageAssets}user/user_group_member.png";
  }

  // 资产记录
  static String assetsRecord(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_record.png";
    }
    return "${imageAssets}assets/assets_record.png";
  }
  // 资产设置
  static String assetsSet(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_set.png";
    }
    return "${imageAssets}assets/assets_set.png";
  }

  // 分享 拷贝
  static String shareCopy(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}share/share_copy.png";
    }
    return "${imageAssets}share/share_copy.png";
  }

  // 分享 保存
  static String shareSave(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}share/share_save.png";
    }
    return "${imageAssets}share/share_save.png";
  }

  // 分享 分享
  static String shareShare(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}share/share_share.png";
    }
    return "${imageAssets}share/share_share.png";
  }

  // 资产未选中
  static String assetsUnSelect(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_unselect.png";
    }
    return "${imageAssets}assets/assets_unselect.png";
  }
  // 资产选中
  static String assetsSelect(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_select.png";
    }
    return "${imageAssets}assets/assets_select.png";
  }
  // 资产记录头部
  static String assetsRecordHead(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_record_head.png";
    }
    return "${imageAssets}assets/assets_record_head.png";
  }
  // 资产Binance
  static String assetsBinance(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_binance.png";
    }
    return "${imageAssets}assets/assets_binance.png";
  }
  // 资产收款
  static String assetsDownload(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_download.png";
    }
    return "${imageAssets}assets/assets_download.png";
  }
  // 资产记eye
  static String assetsEye(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_eye.png";
    }
    return "${imageAssets}assets/assets_eye.png";
  }
  // 资产History
  static String assetsHistory(BuildContext context) {
    final provider = AB_themeProvider(context,listen: false);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_history.png";
    }
    return "${imageAssets}assets/assets_history.png";
  }
  // 资产SEND
  static String assetsSend(BuildContext context) {
    final provider = AB_themeProvider(context,listen: false);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_send.png";
    }
    return "${imageAssets}assets/assets_send.png";
  }
  // 资产扫一扫
  static String assetsShao(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_shao.png";
    }
    return "${imageAssets}assets/assets_shao.png";
  }
  // 资产US1
  static String assetsUs1(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_us1.png";
    }
    return "${imageAssets}assets/assets_us1.png";
  }
  // 资产观察钱包
  static String assetsWatleLock(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_watle_lock.png";
    }
    return "${imageAssets}assets/assets_watle_lock.png";
  }

  // 我的 vip
  static String mineVip(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_vip.png";
    }
    return "${imageAssets}mine/mine_vip.png";
  }
  // 我的 点赞收藏
  static String mineLike(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_like.png";
    }
    return "${imageAssets}mine/mine_like.png";
  }
  // 我的 浏览记录
  static String mineLook(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_look.png";
    }
    return "${imageAssets}mine/mine_look.png";
  }
  // 我的 草稿箱
  static String mineDraft(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_draft.png";
    }
    return "${imageAssets}mine/mine_draft.png";
  }
  // 我的 广告中心
  static String mineAd(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_ad.png";
    }
    return "${imageAssets}mine/mine_ad.png";
  }
  // 我的 邀请好友
  static String mineInvite(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_invite.png";
    }
    return "${imageAssets}mine/mine_invite.png";
  }

  // 资产 左箭头
  static String assetsLeft(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_left.png";
    }
    return "${imageAssets}assets/assets_left.png";
  }
  // 资产 右箭头
  static String assetsRight(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_right.png";
    }
    return "${imageAssets}assets/assets_right.png";
  }
  // 资产assets_language
  static String assetsLanguage(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_language.png";
    }
    return "${imageAssets}assets/assets_language.png";
  }
  // 资产消息通知
  static String assetsNotice(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_notice.png";
    }
    return "${imageAssets}assets/assets_notice.png";
  }
  // 资产安全
  static String assetsSafe(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_safe.png";
    }
    return "${imageAssets}assets/assets_safe.png";
  }
  // 资产更新
  static String assetsUpdate(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_update.png";
    }
    return "${imageAssets}assets/assets_update.png";
  }

  // 资产 版本更新 背景
  static String assetsVersionUpdateBg(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_version_update_bg.png";
    }
    return "${imageAssets}assets/assets_version_update_bg.png";
  }


  // 复制
  static String userCopy(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}user/user_copy.png";
    }
    return "${imageAssets}user/user_copy.png";
  }

  // 复制成功
  static String copyOk(BuildContext context) {
    final provider = AB_TP();
    if (provider.isDark) {
      return "${imageAssets}user/copy_ok.png";
    }
    return "${imageAssets}user/copy_ok.png";
  }

  static String dynamicAdd(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_add.png";
    }
    return "${imageAssets}dynamic/dynamic_add.png";
  }
  static String dynamicAddress(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_address.png";
    }
    return "${imageAssets}dynamic/dynamic_address.png";
  }
  static String dynamicEmoji(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_emoji.png";
    }
    return "${imageAssets}dynamic/dynamic_emoji.png";
  }
  static String dynamicEye(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_eye.png";
    }
    return "${imageAssets}dynamic/dynamic_eye.png";
  }


  static String assetsFail(BuildContext context) {
    final provider = AB_TP();
    if (provider.isDark) {
      return "${imageAssets}assets/assets_fail.png";
    }
    return "${imageAssets}assets/assets_fail.png";
  }
  static String assetsWarning(BuildContext context) {
    final provider = AB_TP();
    if (provider.isDark) {
      return "${imageAssets}assets/assets_warning.png";
    }
    return "${imageAssets}assets/assets_warning.png";
  }
  static String assetsShield(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_shield.png";
    }
    return "${imageAssets}assets/assets_shield.png";
  }
  static String assetsRecords1(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_records1.png";
    }
    return "${imageAssets}assets/assets_records1.png";
  }

  static String assetsFrame(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_frame.png";
    }
    return "${imageAssets}assets/assets_frame.png";
  }
  static String assetsPeopleNum(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_peoplenum.png";
    }
    return "${imageAssets}assets/assets_peoplenum.png";
  }

  static String assetsRechargeList(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_recharge_list.png";
    }
    return "${imageAssets}assets/assets_recharge_list.png";
  }

  static String assetsWithdrawalList(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_withdrawal_list.png";
    }
    return "${imageAssets}assets/assets_withdrawal_list.png";
  }

  static String assetsGoogleIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/assets_google_icon.png";
    }
    return "${imageAssets}assets/assets_google_icon.png";
  }

  // 助记词图标
  static String mnemonicIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/mnemonic_icon.png";
    }
    return "${imageAssets}assets/mnemonic_icon.png";
  }

  // 修改密码图标
  static String modifyPwdIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/modify_pwd_icon.png";
    }
    return "${imageAssets}assets/modify_pwd_icon.png";
  }

  static String redCai1(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/red_cai1.png";
    }
    return "${imageAssets}im/red_cai1.png";
  }
  static String redCai2(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/red_cai2.png";
    }
    return "${imageAssets}im/red_cai2.png";
  }
  static String redLing(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/red_ling.png";
    }
    return "${imageAssets}im/red_ling.png";
  }

  static String fileZip(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/file_zip.png";
    }
    return "${imageAssets}mine/file_zip.png";
  }

  static String mineCollNo(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_coll_no.png";
    }
    return "${imageAssets}mine/mine_coll_no.png";
  }

  static String mineMore(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_more.png";
    }
    return "${imageAssets}mine/mine_more.png";
  }

  static String mineMore1(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_more1.png";
    }
    return "${imageAssets}mine/mine_more1.png";
  }

  static String mineShare(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_share.png";
    }
    return "${imageAssets}mine/mine_share.png";
  }


  static String mineVideoUn(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_video_un.png";
    }
    return "${imageAssets}mine/mine_video_un.png";
  }

  static String videoPlay(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/video_play.png";
    }
    return "${imageAssets}mine/video_play.png";
  }

  static String mineDownload(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_download.png";
    }
    return "${imageAssets}mine/mine_download.png";
  }

  static String mineMoreUser(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_more_user.png";
    }
    return "${imageAssets}mine/mine_more_user.png";
  }

  static String mineOtherApp(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}mine/mine_other_app.png";
    }
    return "${imageAssets}mine/mine_other_app.png";
  }

  static String iconFile(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/icon_file.png";
    }
    return "${imageAssets}im/icon_file.png";
  }

  static String iconLink(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/icon_link.png";
    }
    return "${imageAssets}im/icon_link.png";
  }

  // im地图
  static String iconImMap(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}im/icon_map.png";
    }
    return "${imageAssets}im/icon_map.png";
  }

  static String toastSuccess(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/toast_success.png";
    }
    return "${imageAssets}dynamic/toast_success.png";
  }

  static String toastFail(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/toast_fail.png";
    }
    return "${imageAssets}dynamic/toast_fail.png";
  }


  static String iconGift(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/icon_gift.png";
    }
    return "${imageAssets}dynamic/icon_gift.png";
  }

  static String iconCollection(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/icon_collection.png";
    }
    return "${imageAssets}dynamic/icon_collection.png";
  }

  static String iconDown(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/icon_down.png";
    }
    return "${imageAssets}common/icon_down.png";
  }

  static String mapMarkIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}common/map_mark_icon.png";
    }
    return "${imageAssets}common/map_mark_icon.png";
  }

  static String iconDelete(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/icon_delete.png";
    }
    return "${imageAssets}dynamic/icon_delete.png";
  }

  // 动态点赞图标
  static String dynamicLikedIcon(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_liked.png";
    }
    return "${imageAssets}dynamic/dynamic_liked.png";
  }

  // 动态点赞图标
  static String dynamicMore(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamic_more.png";
    }
    return "${imageAssets}dynamic/dynamic_more.png";
  }

  // 动态已收藏
  static String collected(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/collected.png";
    }
    return "${imageAssets}dynamic/collected.png";
  }

  // 位置
  static String address(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/address.png";
    }
    return "${imageAssets}dynamic/address.png";
  }

  // 位置
  static String dynamicsHelpHot(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}dynamic/dynamics_help_hot.png";
    }
    return "${imageAssets}dynamic/dynamics_help_hot.png";
  }

  // 二维码
  static String iconErweima(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/icon_erweima.png";
    }
    return "${imageAssets}assets/icon_erweima.png";
  }

  // edit_people
  static String editPeople(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/edit_people.png";
    }
    return "${imageAssets}assets/edit_people.png";
  }

  // icon_scan
  static String iconScan(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/icon_scan.png";
    }
    return "${imageAssets}assets/icon_scan.png";
  }

  // select_people
  static String selectPeople(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/select_people.png";
    }
    return "${imageAssets}assets/select_people.png";
  }
  // iconEdit
  static String iconEdit(BuildContext context) {
    final provider = AB_themeProvider(context);
    if (provider.isDark) {
      return "${imageAssets}assets/icon_edit.png";
    }
    return "${imageAssets}assets/icon_edit.png";
  }
}


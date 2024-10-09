
/// 公共接口
// 获取启动页
const String getLaunchSplashApi = "/client-api/v3/startPage";
// 上传OSS-获取凭证（不验证签名）
const String getOssTokenApi = "/client-api/common/getUploadToken";
// 获取版本列表
const String getVersionListApi = "/client-api/system/version/getVersionList";

/// 谷歌验证
// 获取谷歌验证的密钥
const String getSecretKeyApi = "/client-api/google/getSecretKey";
// 验证 code 是否正确
const String checkSuccessCode = "/client-api/google/checkSuccessCode";

/// 用户相关
// 获取图形验证码（注册/登录）
const String captchaImageApi = "/client-api/captcha/captchaImage";
// 助记词-是否绑定助记词
const String isBindMnemonicApi = "/client-api/phrase/isBindMemberMnemonicPhrase";
// 注册-账号密码
const String registerApi = "/client-api/member/register";
// 退出登录
const String logoutApi = "/client-api/logout";
// 账号登录
const String loginApi = "/client-api/member/login";
// 获取助记词
const String getMnemonicApi = "/client-api/phrase/getMnemonicPhrase";
// 验证助记词
const String checkMnemonicApi = "/client-api/phrase/verifyMnemonicPhrase";
// 忘记密码-验证助记词
const String checkMnemonicForgetApi = "/client-api/member/forget/validateMnemonicPhrase";
// 忘记密码-重设密码
const String resetPasswordApi = "/client-api/member/forget/resetPassword";
// 好友-添加好友-搜索好友
const String searchFriendApi = "/client-api/friend/searchFriend";
// 好友-添加好友-添加
const String addFriendApi = "/client-api/friend/addFriend";
// 用户名片
const String getUserInfoApi = "/client-api/member/getMemberPerInfo";
// 好友-更新好友信息
const String updateFriendInfoApi = "/client-api/friend/updateMemberFriend";

/// 关注粉丝
// 关注-关注粉丝列表
const String getFocusListApi = "//client-api/focus/focusList";
// 关注-关注用户
const String focusApi = "/client-api/focus/focus";
// 关注-是否关注该用户
const String isFocusApi = "/client-api/focus/isFocus";


/// 群组
// 群组-搜索群组
const String searchGroupApi = "/client-api/group/searchGroup";
// 群组-搜索群组成员
const String searchGroupMemberApi = "/client-api/group/searchGroupMember";
// 群组-邀请成员入群
const String inviteGroupApi = "/client-api/group/inviteIntoGroup";
// 群组-搜索好友中非群组成员列表
const String searchFriendNotInGroupApi = "/client-api/group/searchFriendNotGroupMember";
// 群组-邀请成员入群
const String inviteGroupMemberApi = "/client-api/group/inviteIntoGroup";
// 群组-判断当前用户是否在指定群组中
const String isInGroupApi = "/client-api/group/isIntoGroup";
// 禁言-用户禁言
const String muteMemberApi = "/client-api/group/groupUserSilence";
// 禁言-群组禁言列表
const String getMuteMemberListApi = "/client-api/group/getSilenceListGroup";


/// IM/通知
// 系统消息列表
const String getSystemMessageListApi = "/client-api/message/getMessageList";
// 确定消息
const String confirmMessageApi = "/client-api/message/confirmMessage";
// 公告-公告列表
const String getNoticeListApi = "/client-api/announcement/getAnnouncementList";
// 公告-公告详情
const String getNoticeDetailApi = "/client-api/announcement/getNoticeInfo";
// 自定义表情列表
const String getCustomEmojiListApi = "/client-api/emoticons/v3/getEmoticonList";
// 消息-删除消息
const String deleteMessageApi = "/client-api/message/removeMessage";


///资产
// 资产-托管钱包资金查询
const String escrowFundsGetFunds= "/client-api/wallet/escrow/funds/getFunds";
// 资产-托管钱包资金查询
const String coinList= "/client-api/coin/coinList";
// 资产-币种资产显示/隐藏
const String fundsDisplayFunds= "/client-api/wallet/escrow/funds/displayFunds";
// 资产-资产记录-活动记录
const String getFundsDetailActivity= "/client-api/wallet/escrow/funds/getFundsDetail";

// 获取用户邀请码
const String getMemberCode= "/client-api/member/getMemberCode";

// 获取充值地址
const String getRechargeAddress = "/client-api/recharge/getRechargeAddress";
// 获取充值记录列表
const String getReChargeList = "/client-api/recharge/getReChargeList";

// 提现设置
const String getPayoutsSet = "/client-api/wallet/escrow/payouts/getPayoutsSet";
// 查询提现记录
const String payoutsList = "/client-api/wallet/escrow/payouts/payoutsList";
// 发起提现申请
const String sendPayouts = "/client-api/wallet/escrow/payouts/sendPayouts";

// 查询转账记录
const String transferList = "/client-api/wallet/escrow/transfer/transferList";
// 发起转账
const String sendTransfer = "/client-api/wallet/escrow/transfer/sendTransfer";

// 转账设置
const String getTransferSet = "/client-api/wallet/escrow/transfer/getTransferSet";

// 获取用户指定币种可用金额
const String getMemberUseCapital = "/client-api/wallet/escrow/member/getMemberUseCapital";

// 获取谷歌验证的密钥
const String getSecretKey = "/client-api/google/getSecretKey";

// 验证 code 是否正确
const String checkCode = "/client-api/google/checkCode";

// 获取谷歌获取验证码
const String getQrcode = "/client-api/google/getQrcode";

// 是否绑定谷歌验证码接口
const String googleIsBind = "/client-api/google/isBind";

// 邀请-邀请记录
const String getInviteList = "/client-api/member/getInviteList";

// 红包设置-查询指定币种指定类型的红包设置
const String getRedPacketSetting = "/client-api/redPacket/getRedPacketSetting";

// 单聊-发起红包
const String sendSingleRedPacket = "/client-api/redPacket/sendSingleRedPacket";

// 群组-发起红包
const String sendGroupRedPacket = "/client-api/redPacket/sendGroupRedPacket";

// 获取用户统计收发红包
const String getRedPacket = "/client-api/redPacket/getRedPacket";

// 获取红包列表
const String getRedPacketList = "/client-api/redPacket/getRedPacketList";

// 拆红包
const String splitRedPacket = "/client-api/redPacket/splitRedPacket";
// 单聊-领取红包
const String receiveSingleRedPacket = "/client-api/redPacket/receiveSingleRedPacket";
// 群组-领取红包
const String receiveGroupRedPacket = "/client-api/redPacket/receiveGroupRedPacket";
// 用户-查看红包详情
const String redPacketDetail = "/client-api/redPacket/redPacketDetail";
// 用户-获取红包接收人列表
const String getReceivers = "/client-api/redPacket/getReceivers";
// 用户-查询用户红包状态
const String isReceiveRedPacket = "/client-api/redPacket/isReceiveRedPacket";


// 收藏消息-收藏消息列表
const String messageGetList = "/client-api/im/message/getList";
// 收藏消息-收藏消息
const String messageCollectApi = "/client-api/im/message/collect";

// 收藏消息-收藏消息详情
const String messageGetDetails = "/client-api/im/message/getDetails";

// 收藏消息-取消该收藏消息
const String cancelMessage = "/client-api/im/message/cancelMessage";

// 收藏消息-取消该次收藏
const String cancelCollect = "/client-api/im/message/cancelCollect";

///动态 帖子
// 帖子-发布帖子
const String postsPublish = "/client-api/posts/publish";

// 热帖-推荐用户
const String hotRecommend = "/client-api/posts/hotRecommend";
// 热帖-热帖推荐列表
const String hotRecommendList = "/client-api/posts/hotRecommendList";

// 热帖-热帖支付的设置列表
const String hotPostPaySetList = "/client-api/posts/hotPostPaySetList";

// 热帖-帮上热帖
const String hotPostPay = "/client-api/posts/hotPostPay";

// 帖子-帖子详情
const String postsDetails = "/client-api/posts/postsDetails";

// 评论-帖子评论列表
const String postsDetailsComments = "/client-api/posts/postsDetailsComments";



// 个人中心-查看用户帖子列表
const String getUserPostsListsApi = "/client-api/posts/getUserPostsLists";

// 个人中心-查看我的动态
const String getUserPostsApi = "/client-api/posts/myPosts";

// 评论回复-评论回复列表
const String commentsReplyList = "/client-api/posts/commentsReplyList";

// 评论-发布评论
const String postsComments = "/client-api/posts/postsComments";

// 评论回复-回复评论
const String commentsReply = "/client-api/posts/commentsReply";

// 评论回复-评论回复的回复
const String commentsReplyToReply = "/client-api/posts/commentsReplyToReply";

// 评论-点赞帖子
const String likePosts = "/client-api/posts/likePosts";

// 评论-点赞评论
const String likePostsComments = "/client-api/posts/likePostsComments";

// 帖子-分享帖子
const String sharePosts = "/client-api/posts/shareToUser";

// 关注-关注用户帖子
const String focusRecommendList = "/client-api/posts/focusRecommendList";

// 帖子-广场
const String squareList = "/client-api/posts/square";

// 打赏-获取打赏设置列表
const String postsRewardOptions = "/client-api/posts/postsRewardOptions";

// 打赏-打赏帖子
const String rewardPosts = "/client-api/posts/rewardPosts";

// 热帖-热门排行榜帖子列表
const String hotTopPostsList = "/client-api/posts/hotTopPostsList";

// 搜索-搜索帖子
const String searchPosts = "/client-api/posts/searchPosts";


// 帖子-查询帖子的统计数据
const String getPostsCount = "/client-api/posts/getPostsCount";

// 评论-删除评论/回复
const String deleteComments = "/client-api/posts/deleteComments";

// 帖子-收藏/取消收藏帖子
const String collectPosts = "/client-api/posts/collectPosts";

// 帖子-收藏列表
const String getCollectPostsList = "/client-api/posts/getCollectPostsList";

// 个人中心-查看动态浏览历史
const String lookHistoryPosts = "/client-api/posts/lookHistoryPosts";

// 个人中西-删除帖子浏览记录
const String deleteHistoryPosts = "/client-api/posts/deleteHistoryPosts";

// 帖子-删除帖子
const String removePosts = "/client-api/posts/removePosts";

// 帖子-删除帖子
const String draftBoxList = "/client-api/posts/draftBoxList";

// 草稿箱-草稿箱发布
const String draftBoxOPublish = "/client-api/posts/draftBoxOPublish";

// 帖子-点赞帖子列表
const String likePostsList = "/client-api/posts/likePostsList";

// 访客列表
const String getLookMeList = "/client-api/member/getLookMeList";

// 助记词-获取已绑定的助记词
const String getBindMemberMnemonicPhrase = "/client-api/phrase/getBindMemberMnemonicPhrase";

// 收藏地址-修改收藏地址
const String payoutsAddressEdit= "/client-api/wallet/escrow/payoutsAddress/edit";
// 收藏地址-取消收藏
const String canCollectAddress = "/client-api/wallet/escrow/payoutsAddress/canCollectAddress";
// 收藏地址-添加收藏
const String payoutsAddressAdd = "/client-api/wallet/escrow/payoutsAddress/add";
// 收藏地址-收藏地址列表
const String payoutsAddressList = "/client-api/wallet/escrow/payoutsAddress/list";

// 修改密码-用户修改密码
const String updateUserPassword = "/client-api/member/updateUserPassword";

import 'package:bee_chat/models/common/empty_model.dart';
import 'package:bee_chat/models/dynamic/comments_reply_list_model.dart';
import 'package:bee_chat/models/dynamic/draft_box_list_model.dart';
import 'package:bee_chat/models/dynamic/dynamic_publish_model.dart';
import 'package:bee_chat/models/dynamic/get_posts_count_model.dart';
import 'package:bee_chat/models/dynamic/hot_top_posts_list_model.dart';
import 'package:bee_chat/models/dynamic/look_history_posts_model.dart';
import 'package:bee_chat/models/dynamic/posts_details_comments_model.dart';
import 'package:bee_chat/models/dynamic/posts_details_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_model.dart';
import 'package:bee_chat/models/dynamic/posts_reward_options_model.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_list_model.dart';
import 'package:bee_chat/models/red_bag/get_red_packet_total_model.dart';
import 'package:bee_chat/models/red_bag/is_receive_red_packet_model.dart';
import 'package:bee_chat/models/red_bag/receive_red_packet_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_detail_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_get_receivers_model.dart';
import 'package:bee_chat/models/red_bag/red_packet_setting_model.dart';
import 'package:bee_chat/models/red_bag/send_group_red_packet_model.dart';
import 'package:bee_chat/models/red_bag/send_single_red_packet_model.dart';
import 'package:bee_chat/models/red_bag/split_red_packet_model.dart';

import '../utils/net/ab_Net.dart';
import '../utils/net/net_model.dart';
import 'api.dart';

class DynamicsNet {
  /* 发帖
  * */
  static Future<RequestResult<bool>> dynamicsPostsPublish(DynamicPublishModel model) {
    return ABNet.request(path: postsPublish, method: HttpMethod.post, params: model.toMap(), isShowTip: false);
  }

  /* 热帖-推荐用户
  * */
  static Future<RequestResult<List<PostsHotRecommendModel>>> dynamicsPostsHotRecommend({required int pageNum}) {
    return ABNet.request(path: hotRecommend, method: HttpMethod.get, params: {'pageNum': pageNum, 'pageSize': 50});
  }

  /* 热帖-热帖推荐列表
  * */
  static Future<RequestResult<PostsHotRecommendListModel>> dynamicsHotRecommendList({required int pageNum}) {
    return ABNet.request(path: hotRecommendList, method: HttpMethod.get, params: {'pageNum': pageNum, 'pageSize': 10});
  }

  /* 热帖-热帖支付的设置列表
  * */
  static Future<RequestResult<List<PostsRewardOptionsModel>>> dynamicsHotPostPaySetList() {
    return ABNet.request(path: hotPostPaySetList, method: HttpMethod.get, params: {});
  }

  /* 热帖-帮上热帖
  * */
  static Future<RequestResult<bool>> dynamicsHotPostPay(
      {required int postId, required int hotTimes, required double payPrice, required int hotSetId}) {
    return ABNet.request(
        path: hotPostPay,
        method: HttpMethod.post,
        params: {
          "postId": postId,
          "hotTimes": hotTimes,
          // "payPrice": payPrice,
          "hotSetId": hotSetId,
        },
        isShowTip: false,showLoading: true);
  }

  /* 帖子-帖子详情
  * */
  static Future<RequestResult<PostsDetailsModel>> dynamicsPostsDetails({required int postId}) {
    return ABNet.request(
        path: postsDetails,
        method: HttpMethod.get,
        params: {
          "postsId": postId,
        },
        isShowTip: false);
  }

  /* 评论-帖子评论列表
  * */
  static Future<RequestResult<PostsDetailsCommentsModel>> dynamicsPostsDetailsComments(
      {required int postId, required int pageNum, int? sort = 1, int? pageSize = 20}) {
    return ABNet.request(
        path: postsDetailsComments,
        method: HttpMethod.get,
        params: {
          "postsId": postId,
          "pageNum": pageNum,
          "pageSize": pageSize ?? 20,
          "sort": sort // 1:时间 2:热度
        },
        isShowTip: false);
  }

  /* 个人中心-查看用户帖子列表
  * */
  static Future<RequestResult<PostsHotRecommendListModel>> dynamicsGetUserPostsLists(
      {required int pageNum, required String memberNum}) {
    return ABNet.request(
        path: getUserPostsListsApi,
        method: HttpMethod.get,
        params: {'pageNum': pageNum, 'pageSize': 10, 'memberNum': memberNum});
  }

  /* 个人中心-查看用户帖子列表
  * */
  static Future<RequestResult<PageModel<PostsHotRecommendListRecords>>> getUserPostsLists(
      {int pageNum = 1, int pageSize = 10, required String memberNum}) {
    return ABNet.requestPage(
        path: getUserPostsListsApi,
        method: HttpMethod.get,
        params: {'pageNum': pageNum, 'pageSize': pageSize, 'memberNum': memberNum});
  }

  /* 查看我的动态
  *  type: 0-全部；1-视频；2-图片；3-文字
  * */
  static Future<RequestResult<PageModel<PostsHotRecommendListRecords>>> getMyPostsList({int pageNum = 1, int pageSize = 10, int type = 1}) {
    return ABNet.requestPage(
        path: getUserPostsApi,
        method: HttpMethod.get,
        params: {'pageNum': pageNum, 'pageSize': pageSize, 'type': type},
        isShowTip: false
    );
  }

  /* 评论回复-评论回复列表
  * */
  static Future<RequestResult<CommentsReplyListModel>> dynamicsCommentsReplyList({
    required int postId,
    required int commentsId,
    required int pageNum,
  }) {
    return ABNet.request(
        path: commentsReplyList,
        method: HttpMethod.get,
        params: {"postsId": postId, "pageNum": pageNum, "pageSize": 18, "commentsId": commentsId},
        isShowTip: false);
  }

  /* 评论-发布评论
  * */
  static Future<RequestResult<EmptyModel>> dynamicsPostsComments({required int postId, required String comment}) {
    return ABNet.request(
        path: postsComments,
        method: HttpMethod.post,
        params: {
          "postsId": postId,
          "comment": comment,
        },
        isShowTip: false,showLoading: true);
  }

  /* 评论回复-回复评论
  * */
  static Future<RequestResult<EmptyModel>> dynamicsCommentsReply({required int commentsId, required String content}) {
    return ABNet.request(
        path: commentsReply,
        method: HttpMethod.post,
        params: {
          "commentsId": commentsId,
          "content": content,
        },
        isShowTip: false,showLoading: true);
  }

  /* 评论回复-评论回复的回复
  * */
  static Future<RequestResult<EmptyModel>> dynamicsCommentsReplyToReply(
      {required int replyId, required int commentsId, required String content}) {
    return ABNet.request(
        path: commentsReplyToReply,
        method: HttpMethod.post,
        params: {
          "replyId": replyId,
          "commentsId": commentsId,
          "content": content,
        },
        isShowTip: false,showLoading: true);
  }

  /* 评论-点赞帖子
  * */
  static Future<RequestResult<EmptyModel>> dynamicsLikePosts({required int postsId, required bool isLike}) {
    return ABNet.request(
        path: likePosts,
        method: HttpMethod.get,
        params: {
          "postsId": postsId,
          "type": isLike ? 'add' : 'cancel',
        },
        isShowTip: false,showLoading: true);
  }

  /* 评论-点赞评论
  * */
  static Future<RequestResult<EmptyModel>> dynamicsLikePostsComments({required int commentsId, required bool isLike}) {
    return ABNet.request(
        path: likePostsComments,
        method: HttpMethod.get,
        params: {
          "commentsId": commentsId,
          "type": isLike ? 'add' : 'cancel',
        },
        isShowTip: false,showLoading: true);
  }

  //  分享帖子
  static Future<RequestResult<EmptyModel>> dynamicsShare({required int postsId, int num = 1}) {
    return ABNet.request(
        path: sharePosts,
        method: HttpMethod.post,
        params: {
          "postsId": postsId,
          "shareMemberCount": num,
        },
        isShowTip: false,showLoading: true);
  }

  /* 关注-关注用户帖子
  * */
  static Future<RequestResult<PostsHotRecommendListModel>> dynamicsFocusRecommendList({required int pageNum}) {
    return ABNet.request(
        path: focusRecommendList,
        method: HttpMethod.get,
        params: {
          "pageNum": pageNum,
          "pageSize": 10,
        },
        isShowTip: false);
  }

  /* 帖子-广场
  * */
  static Future<RequestResult<PostsHotRecommendListModel>> dynamicsSquareRecommendList({required int pageNum}) {
    return ABNet.request(
        path: squareList,
        method: HttpMethod.get,
        params: {
          "pageNum": pageNum,
          "pageSize": 10,
        },
        isShowTip: false);
  }

  /* 关注-关注  是否
  * */
  static Future<RequestResult<EmptyModel>> dynamicsFocus({required String memberNum, required bool isFocus}) {
    return ABNet.request(
        path: focusApi,
        method: HttpMethod.get,
        params: {
          "memberNum": memberNum,
          "type": isFocus ? 'focus' : 'notFocus',
        },
        isShowTip: false,showLoading: true);
  }

  /* 打赏-获取打赏设置列表
  * */
  static Future<RequestResult<List<PostsRewardOptionsModel>>> dynamicsRewardOptions() {
    return ABNet.request(path: postsRewardOptions, method: HttpMethod.get, params: {}, isShowTip: false);
  }

  /*  打赏-打赏帖子
  * */
  static Future<RequestResult<EmptyModel>> dynamicsRewardPosts(
      {required int postId, required double payPrice, required int rewardSettingId}) {
    return ABNet.request(
        path: rewardPosts,
        method: HttpMethod.post,
        params: {
          "postId": postId,
          "payPrice": payPrice,
          "rewardSettingId": rewardSettingId,
        },
        isShowTip: false,showLoading: true);
  }

  /* 热帖-热门排行榜帖子列表
  * */
  static Future<RequestResult<HotTopPostsListModel>> dynamicsHotTopPostsList({required int pageNum}) {
    return ABNet.request(
        path: hotTopPostsList,
        method: HttpMethod.get,
        params: {
          "pageNum": pageNum,
          "pageSize": 10,
        },
        isShowTip: false);
  }

  /* 搜索-搜索帖子
  * */
  static Future<RequestResult<PostsHotRecommendListModel>> dynamicsSearchPosts(
      {required int pageNum, required String searchKey}) {
    return ABNet.request(
        path: searchPosts,
        method: HttpMethod.get,
        params: {
          "pageNum": pageNum,
          "pageSize": 10,
          "searchKey": searchKey,
        },
        isShowTip: false);
  }

  /* 帖子-查询帖子的统计数据
  * */
  static Future<RequestResult<GetPostsCountModel>> dynamicsGetPostsCount({required int postsId}) {
    return ABNet.request(
        path: getPostsCount,
        method: HttpMethod.get,
        params: {
          "postsId": postsId,
        },
        isShowTip: false);
  }

  /* 关注-是否关注该用户
  * */
  static Future<RequestResult<bool>> dynamicsIsFocus({required String memberNum}) {
    return ABNet.request(
        path: isFocusApi,
        method: HttpMethod.get,
        params: {
          "memberNum": memberNum,
        },
        isShowTip: false);
  }

  /* 评论-删除评论/回复
  * */
  static Future<RequestResult<List?>> dynamicsDeleteComments({required int commentsId, required int type}) {
    return ABNet.request(
        path: deleteComments,
        method: HttpMethod.get,
        params: {
          "commentsId": commentsId,//评论id/回复id
          "type": type,//1:帖子评论 2：帖子回复
        },
        isShowTip: false,showLoading: true);
  }

  /* 帖子-收藏/取消收藏帖子
  * */
  static Future<RequestResult<bool>> dynamicsCollectPosts({required int postsId, required bool collect}) {
    return ABNet.request(
        path: collectPosts,
        method: HttpMethod.get,
        params: {
          "postsId": postsId,//帖子Id
          "collect": collect,//true:收藏 false:取消收藏
        },
        isShowTip: false,showLoading: true);
  }

  /* 帖子-收藏列表
  * */
  static Future<RequestResult<PostsHotRecommendListModel>> dynamicsGetCollectPostsList({required int pageNum}) {
    return ABNet.request(
        path: getCollectPostsList,
        method: HttpMethod.get,
        params: {
          "pageNum": pageNum,
          "pageSize": 10,
        },
        isShowTip: false);
  }

  /* 帖子-收藏列表
  * */
  static Future<RequestResult<LookHistoryPostsModel>> dynamicsLookHistoryPosts({required int pageNum}) {
    return ABNet.request(
        path: lookHistoryPosts,
        method: HttpMethod.get,
        params: {
          "pageNum": pageNum,
          "pageSize": 10,
        },
        isShowTip: false);
  }

  /* 个人中西-删除帖子浏览记录
  * */
  static Future<RequestResult<EmptyModel>> dynamicsDeleteHistoryPosts({required List<String> postsId}) {
    return ABNet.request(
        path: deleteHistoryPosts,
        method: HttpMethod.post,
        params: {
          "postsIds": postsId,
        },
        isShowTip: false);
  }
  /* 个人中西-删除帖子
  * */
  static Future<RequestResult<EmptyModel>> dynamicsRemovePosts({required List<String> postsId}) {
    return ABNet.request(
        path: removePosts,
        method: HttpMethod.post,
        params: {
          "postsIds": postsId,
        },
        isShowTip: false);
  }

  /* 草稿箱-草稿箱列表
  * */
  static Future<RequestResult<DraftBoxListModel>> dynamicsDraftBoxList({required int pageNum}) {
    return ABNet.request(
        path: draftBoxList,
        method: HttpMethod.get,
        params: {
          "pageNum": pageNum,
          "pageSize": 10,
        },
        isShowTip: false);
  }

  /* 草稿箱-草稿箱发布
  * */
  static Future<RequestResult<EmptyModel>> dynamicsDraftBoxOPublish({required int postsId}) {
    return ABNet.request(
        path: draftBoxOPublish,
        method: HttpMethod.get,
        params: {
          "postsId": postsId,
        },
        isShowTip: false);
  }
  /* 帖子-点赞帖子列表
  * */
  static Future<RequestResult<PostsHotRecommendListModel>> dynamicsLikePostsList({required int pageNum}) {
    return ABNet.request(
        path: likePostsList,
        method: HttpMethod.get,
        params: {
          "pageNum": pageNum,
          "pageSize": 10,
        },
        isShowTip: false);
  }


}

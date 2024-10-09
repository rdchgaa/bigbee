class ABShare {

  // 获取群组分享Url
  static String getGroupShareUrl({String? groupID}) {
    if (groupID == null || groupID.isEmpty) {
      return "beeChat://share/group";
    }
    return "beeChat://share/group?groupID=$groupID";
  }

  static String getGroupIdFromShareUrl(String url) {
    if (!url.startsWith("beeChat://share/group")) {
      return "";
    }
    final res = url.split("groupID=");
    if (res.length < 2) {
      return "";
    }
    return url.split("groupID=")[1];
  }

  // 获取个人分享Url
  static String getPersonShareUrl(String? userID) {
    if (userID == null || userID.isEmpty) {
      return "beeChat://share/person";
    }
    return "beeChat://share/person?userID=$userID";
  }

  // 获取app分享Url(可以包含邀请码)
  static String getAppShareUrl({String? inviteCode}) {
    if (inviteCode == null || inviteCode.isEmpty) {
      return "beeChat://share/app";
    }
    return "beeChat://share/app?inviteCode=$inviteCode";
  }

  // 解析分享Url
  static Map<String, String> parseShareUrl(String url) {
    Map<String, String> result = {};
    Uri uri = Uri.parse(url);
    result["scheme"] = uri.scheme;
    result["host"] = uri.host;
    result["path"] = uri.path;
    result["query"] = uri.query;
    result["queryParameters"] = uri.queryParameters.toString();
    return result;
  }

  //判断是否是邀请链接
  static String? checkInviteCodeUserId(String url) {
    if (!url.contains("?inviteCode=")) {
      return null;
    }
    final res = url.split("userId=");
    if (res.length < 2) {
      return null;
    }
    return url.split("userId=")[1];
  }

}
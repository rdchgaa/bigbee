class DynamicPublishModel {
  int trendsType; //发布类型（1：纯文字、2：文字图片、3：文字视频、4：纯图片、5：纯视频）
  String textContent;
  String imgeUrls;//图片URL（使用英文“;”隔开）
  String videoUrl;
  String addrName;
  String addrAddress;
  String addrLongitude;
  String addrLatitude;
  int showType; //展示方式（1：所有人可见、2：仅主页可见、3、仅陌生人可见、4：仅自己可见、5：仅动态广场可见、6：不给Ta看）
  int isDownload;//是否可以下载（1：可下载、2：禁止下载）
  int isShare;// 是否可以分享（1：可以分享、2：禁止分享）
  int commentScope;//可评论范围（1：所有人可评、2：我关注的人可评、3：关注我的人可评、4：所有人都不可评）
  List<String> memberNums; //禁止查看用户
  int status;//状态（1：草稿箱、2：发布）

  DynamicPublishModel(
      {required this.trendsType,
        required this.textContent,
        required this.imgeUrls,
        required this.videoUrl,
        required this.addrName,
        required this.addrAddress,
        required this.addrLongitude,
        required this.addrLatitude,
        required this.showType,
        required this.isDownload,
        required this.isShare,
        required this.commentScope,
        required this.memberNums,
        required this.status});


  DynamicPublishModel copyWith({
    int? trendsType,
    String? textContent,
    String? imgeUrls,
    String? videoUrl,
    String? addrName,
    String? addrAddress,
    String? addrLongitude,
    String? addrLatitude,
    int? showType,
    int? isDownload,
    int? isShare,
    int? commentScope,
    List<String>? memberNums,
    int? status,
  }) {
    return DynamicPublishModel(
      trendsType: trendsType ?? this.trendsType,
      textContent: textContent ?? this.textContent,
      imgeUrls: imgeUrls ?? this.imgeUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      addrName: addrName ?? this.addrName,
      addrAddress: addrAddress ?? this.addrAddress,
      addrLongitude: addrLongitude ?? this.addrLongitude,
      addrLatitude: addrLatitude ?? this.addrLatitude,
      showType: showType ?? this.showType,
      isDownload: isDownload ?? this.isDownload,
      isShare: isShare ?? this.isShare,
      commentScope: commentScope ?? this.commentScope,
      memberNums: memberNums ?? this.memberNums,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trendsType': trendsType,
      'textContent': textContent,
      'imgeUrls': imgeUrls,
      'videoUrl': videoUrl,
      'addrName': addrName,
      'addrAddress': addrAddress,
      'addrLongitude': addrLongitude,
      'addrLatitude': addrLatitude,
      'showType': showType,
      'isDownload': isDownload,
      'isShare': isShare,
      'commentScope': commentScope,
      'memberNums': memberNums.map((map) => map).toList(),
      'status': status,
    };
  }

  static DynamicPublishModel? fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return DynamicPublishModel(
      trendsType:
          null == (temp = map['trendsType']) ? 0 : (temp is num ? temp.toInt() : (num.tryParse(temp)?.toInt() ?? 0)),
      textContent: map['textContent']?.toString() ?? "",
      imgeUrls: map['imgeUrls']?.toString() ?? "",
      videoUrl: map['videoUrl']?.toString() ?? "",
      addrName: map['addrName']?.toString() ?? "",
      addrAddress: map['addrAddress']?.toString() ?? "",
      addrLongitude: map['addrLongitude']?.toString() ?? "",
      addrLatitude: map['addrLatitude']?.toString() ?? "",
      showType:
          null == (temp = map['showType']) ? 0 : (temp is num ? temp.toInt() : (num.tryParse(temp)?.toInt() ?? 0)),
      isDownload:
          null == (temp = map['isDownload']) ? 0 : (temp is num ? temp.toInt() : (num.tryParse(temp)?.toInt() ?? 0)),
      isShare: null == (temp = map['isShare']) ? 0 : (temp is num ? temp.toInt() : (num.tryParse(temp)?.toInt() ?? 0)),
      commentScope:
          null == (temp = map['commentScope']) ? 0 : (temp is num ? temp.toInt() : (num.tryParse(temp)?.toInt() ?? 0)),
      memberNums: null == (temp = map['memberNums'])
          ? []
          : (temp is List ? temp.map((map) => map?.toString() ?? "").toList() : []),
      status: null == (temp = map['status']) ? 0 : (temp is num ? temp.toInt() : (num.tryParse(temp)?.toInt() ?? 0)),
    );
  }
}

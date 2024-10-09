import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';


class SearchHistoryWidget extends StatefulWidget {
  // 点击搜索历史
  final Function(String)? onSearch;
  final bool isNeedRefreshHistory;

  const SearchHistoryWidget(
      {Key? key, this.onSearch, this.isNeedRefreshHistory = false})
      : super(key: key);

  @override
  State<SearchHistoryWidget> createState() => _SearchHistoryWidgetState();
}

class _SearchHistoryWidgetState extends State<SearchHistoryWidget> {
  List<String> _historyList = [];
  late bool isNeedRefreshHistory;

  @override
  void initState() {
    super.initState();
    isNeedRefreshHistory = widget.isNeedRefreshHistory;
  }

  /// 加载数据
  void loadData() {
    _historyList = ABSharedPreferences.getSearchHistory(); //SpManager.getSearchHistoryList() ?? [];
    isNeedRefreshHistory = false;
    setState(() {});
  }

  void _saveData() async {
    ABSharedPreferences.setSearchHistory(_historyList);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> textData = [
      "1这里是热帖内容帖子内容，是看见阿萨德后UI就是你的空间啊是肯德基拿上数据按打卡就是你的卡技术。",
      "2这里是热帖内容帖子内容，是看见阿萨德后UI就是你的空间啊是肯德基拿上数据按打卡就是你的卡技术。",
      "3这里是热帖内容帖子内容，是看见阿萨德后UI就是你的空间啊是肯德基拿上数据按打卡就是你的卡技术。",
      "4这里是热帖内容帖子内容，是看见阿萨德后UI就是你的空间啊是肯德基拿上数据按打卡就是你的卡技术。",
      "5这里是热帖内容帖子内容，是看见阿萨德后UI就是你的空间啊是肯德基拿上数据按打卡就是你的卡技术。"
    ];

    final theme = AB_theme(context);
    if (widget.isNeedRefreshHistory) {
      loadData();
    }

    List<Widget> hotItems = [];
    for (int i = 0; i < textData.length; i++) {
      hotItems.add(
        _buildItem(textData[i], i)
      );
    }

    return ColoredBox(
      color: theme.backgroundColor,
      child: Column(
        children: [
          if (_historyList.isNotEmpty) Padding(
            padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 26.px, bottom: 10.px),
            child: Row(
              children: [
                Text(
                  AB_S().searchHistory,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    setState(() {
                      _historyList.clear();
                      _saveData();
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(ABAssets.searchDeleteIcon(context), width: 24, height: 24,)
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_historyList.isNotEmpty)  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.px),
                  child: Wrap(
                    spacing: 8.0, // 主轴（水平）方向上的子组件间距
                    runSpacing: 4.0, // 交叉轴（垂直）方向上的子组件间距
                    children: _historyList.map((tag) => InkWell(
                      onTap: () {
                        widget.onSearch?.call(tag);
                      },
                      child: Container(
                        // height: 36.px,
                        padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 4.px),
                        decoration: BoxDecoration(
                          color: theme.white,
                          borderRadius: BorderRadius.circular(18.px),
                          border: Border.all(color: theme.f4f4f4, width: 1),
                        ),
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.width - 32),
                        child: Text(tag),
                      ),
                    )).toList(),
                  ),
                ),
                if (textData.isNotEmpty) Container(
                  margin: EdgeInsets.only(left: 16.px, right: 16.px, top: 16.px, bottom: MediaQuery.of(context).padding.bottom),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.white,
                      borderRadius: BorderRadius.circular(6.px),
                    ),
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16.px),
                        Row(
                          children: [
                            SizedBox(width: 16.px,),
                            Text(AB_S().hotTop, style: TextStyle(fontSize: 16.px, color: theme.black, fontWeight: FontWeight.bold),),
                            SizedBox(width: 8.px),
                            Text("🔥", style: TextStyle(color: theme.primaryColor),),
                          ],
                        ),
                        SizedBox(height: 10.px),
                        ...hotItems,
                        SizedBox(height: 6.px),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String text, int index) {
    final theme = AB_theme(context);
    Color numBackgroundColor = Colors.grey;
    if (index == 0) {
      numBackgroundColor = theme.secondaryColor;
    } else if (index == 1) {
      numBackgroundColor = theme.primaryColor;
    } else if (index == 2) {
      numBackgroundColor = Color(0xFFFFE8A5);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 9.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20.px,
            height: 20.px,
            decoration: BoxDecoration(
              color: numBackgroundColor,
              borderRadius: BorderRadius.circular(10.px),
            ),
            child: Center(child: Text("${index + 1}", style: TextStyle(color: Colors.white, fontSize: 12.px),)),
          ),
          SizedBox(width: 16.px),
          Expanded(
            child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:TextStyle()
            )
          ),
        ],
      ),
    );
  }

}

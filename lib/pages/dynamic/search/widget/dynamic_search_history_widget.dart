import 'package:bee_chat/models/dynamic/hot_top_posts_list_model.dart';
import 'package:bee_chat/models/dynamic/posts_hot_recommend_list_model.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/pages/assets/widget/alert_dialog.dart';
import 'package:bee_chat/pages/dynamic/dynamic_details_page.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_shared_preferences.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';


class DynamicSearchHistoryWidget extends StatefulWidget {
  // 点击搜索历史
  final Function(String)? onSearch;
  final bool isNeedRefreshHistory;

  const DynamicSearchHistoryWidget(
      {Key? key, this.onSearch, this.isNeedRefreshHistory = false})
      : super(key: key);

  @override
  State<DynamicSearchHistoryWidget> createState() => _DynamicSearchHistoryWidgetState();
}

class _DynamicSearchHistoryWidgetState extends State<DynamicSearchHistoryWidget> {
  List<String> _historyList = [];
  late bool isNeedRefreshHistory;

  int pageNum = 1;

  List<HotTopPostsListRecords> hotRecommendList = [];

  @override
  void initState() {
    super.initState();
    isNeedRefreshHistory = widget.isNeedRefreshHistory;
    initData();
  }

  initData() {
    getHotRecommendListData();
  }

  getHotRecommendListData() async {
    pageNum = 1;
    setState(() {});
    var resultRecords = await DynamicsNet.dynamicsHotTopPostsList(pageNum: pageNum);
    if (resultRecords.data != null) {
      hotRecommendList = resultRecords.data?.records ?? [];
      setState(() {});
    }
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

    final theme = AB_theme(context);
    if (widget.isNeedRefreshHistory) {
      loadData();
    }

    List<Widget> hotItems = [];
    for (int i = 0; i < hotRecommendList.length; i++) {
      hotItems.add(
        _buildItem(hotRecommendList[i], i)
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
                  onTap: () async{
                    var value = await showAlertDialog(
                      context,
                      title: AB_S().deleteRecordPrompt,
                      content: AB_S().deleteRecordPromptTip,
                      buttonCancel: AB_S().cancel,
                      buttonOk: AB_S().confirm,
                    );
                    if(value==true){
                      setState(() {

                        _historyList.clear();
                        _saveData();
                      });
                    }
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
                if (hotRecommendList.isNotEmpty) Container(
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

  Widget _buildItem(HotTopPostsListRecords text, int index) {
    final theme = AB_theme(context);
    Color numBackgroundColor = Colors.grey;
    if (index == 0) {
      numBackgroundColor = theme.secondaryColor;
    } else if (index == 1) {
      numBackgroundColor = theme.primaryColor;
    } else if (index == 2) {
      numBackgroundColor = Color(0xFFFFE8A5);
    }
    return InkWell(
      onTap: (){
        ABRoute.push(DynamicDetailsPage(
          postsId: text.postsId??0,
        ));
      },
      child: Padding(
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
                  (text.textContent==null||text.textContent=='')?'...':text.textContent!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:TextStyle()
              )
            ),
          ],
        ),
      ),
    );
  }

}

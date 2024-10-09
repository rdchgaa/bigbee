import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime)? onChoice;
  final Function(DateTime)? onChangeMonth;
  final List<DateTime>? initListData;
  final bool? showPoint;

  const DatePickerWidget({
    Key? key,
    this.onChoice,
    this.initListData,
    this.showPoint = false, this.onChangeMonth,
  }) : super(key: key);

  @override
  DatePickerWidgetState createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<DatePickerWidget> {
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  int _day = DateTime.now().day;
  List<CalendarModel> _datas = [];
  List<CalendarModel> _list_datas = [];

  @override
  void initState() {
    // TODO: implement initState
    //设置默认当前月日期
    _setDatas(year: _year, month: _month);

    //设置模拟数据，日历月事件，可根据接口返回的结果
    loadAttendanceMonthRecord(listData: widget.initListData);
    //日历日事件
    // _loadAttendanceDayRecord(_year.toString() + "-" + _month.toString()+"-"+_day.toString());

    super.initState();
  }

  //加载月历事件，请求接口
  loadAttendanceMonthRecord({List<DateTime>? listData}) async {
    if (listData != null) {
      for (var i = 0; i < listData.length; i++) {
        var dateTime = listData[i];
        CalendarModel bean1 = new CalendarModel(
            year: dateTime.year,
            month: dateTime.month,
            day: dateTime.day,
            work_type: ""
                "2");
        _list_datas.add(bean1);
      }
    }

    ///模拟数据
    // CalendarModel bean1= new CalendarModel(year: _year,month: _month,day: 1,work_type: "2");
    // CalendarModel bean2= new CalendarModel(year: _year,month: _month,day: 2,work_type: "1");
    // CalendarModel bean3= new CalendarModel(year: _year,month: _month,day: 3,work_type: "2");
    // CalendarModel bean4= new CalendarModel(year: _year,month: _month,day: 4,work_type: "0");
    // CalendarModel bean5= new CalendarModel(year: _year,month: _month,day: 5,work_type: "0");
    // CalendarModel bean6= new CalendarModel(year: _year,month: _month,day: 6,work_type: "1");
    // _list_datas.add(bean1);
    // _list_datas.add(bean2);
    // _list_datas.add(bean3);
    // _list_datas.add(bean4);
    // _list_datas.add(bean5);
    // _list_datas.add(bean6);
    ///模拟数据

    setState(() {
      for (int i = 0; i < _datas.length; i++) {
        for (int j = 0; j < _list_datas.length; j++) {
          if (_datas[i].year == _list_datas[j].year &&
              _datas[i].month == _list_datas[j].month &&
              _datas[i].day == _list_datas[j].day) {
            _datas[i].work_type = _list_datas[j].work_type;
          }
        }
      }
    });
  }

  //加载日事件，请求接口
  _loadAttendanceDayRecord(CalendarModel dateTime) async {
    //可根据接口返回的内容在日历下面打卡信息或者其余内容
    print("点击的是${dateTime.toString()}");
    widget.onChoice == null ? null : widget.onChoice!(DateTime(dateTime.year!, dateTime.month!, dateTime.day!));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Scaffold(
        // appBar: customAppbar(//自定义的全局标题
        //   context: context,
        //   title: "第二页",
        //   back: false,
        // ),
        body: SingleChildScrollView(
            child: Column(
      children: [
        Container(
          margin: EdgeInsets.all(20.px),
          decoration: BoxDecoration(
            //设置颜色
            // color: theme.f4f4f4,
            borderRadius: BorderRadius.all(Radius.circular(12.px)),
            //设置四周边框
          ),
          child: Column(
            children: [
              _weekHeader(),
              SizedBox(height: 15.px),
              _yearHeader(),
              _everyDay(),
            ],
          ),
        ),

        //下面可以添加日事件中的信息，例如打卡信息
        Container(),
      ],
    )));
  }

  //头部年
  Widget _yearHeader() {
    final theme = AB_theme(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$_month",
                  style: TextStyle(fontSize: 30.px, color: theme.text282109, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.px),
                  child: Text(
                    "$_month${AB_S().month}$_year${AB_S().year}",
                    style: TextStyle(fontSize: 14.px, color: theme.text282109),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                _lastMonth();
              },
              child: Container(
                margin: EdgeInsets.only(left: 20.px),
                child: Image.asset(
                  ABAssets.assetsLeft(context),
                  width: 20.px,
                  height: 20.px,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            _nextMonth();
          },
          child: Container(
            margin: EdgeInsets.only(right: 20.px),
            child: Image.asset(
              ABAssets.assetsRight(context),
              width: 20.px,
              height: 20.px,
            ),
          ),
        ),
      ],
    );
  }

  //中部周
  Widget _weekHeader() {
    final theme = AB_theme(context);
    // var array = ["一", "二", "三", "四", "五", "六", "日"];
    var array = [AB_S().one, AB_S().two, AB_S().three, AB_S().four, AB_S().five, AB_S().six, AB_S().seven];
    return Container(
      height: 20,
      child: GridView.builder(
        padding: EdgeInsets.only(left: 10, right: 10),
        itemCount: array.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
            crossAxisCount: 7,
            //纵轴间距
            // mainAxisSpacing: ScreenUtil().setHeight(10),
            // 横轴间距
            // crossAxisSpacing: ScreenUtil().setWidth(15),
            //子组件宽高长度比例
            childAspectRatio: 2),
        itemBuilder: (context, index) {
          return Container(
              alignment: Alignment.center,
              child: Text(
                array[index],
                style:
                    TextStyle(color: index == 5 || index == 6 ? theme.text282109 : theme.text282109, fontSize: 16.px),
              ));
        },
      ),
    );
  }

  //底部日
  Widget _everyDay() {
    final theme = AB_theme(context);
    return Container(
      child: GridView.builder(
        padding: EdgeInsets.only(left: 10.px, top: 10.px, right: 10.px),
        itemCount: _getRowsForMonthYear(year: _year, month: _month) * 7,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
            crossAxisCount: 7,
            // //纵轴间距
            // mainAxisSpacing: ScreenUtil().setHeight(10),
            // // 横轴间距
            // crossAxisSpacing: ScreenUtil().setWidth(10),
            //子组件宽高长度比例
            childAspectRatio: 1),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                if (_datas[index].month == _month) {
                  //判断点击的是否是当月日期，只对当前月点击的日期做处理
                  for (int i = 0; i < _datas.length; i++) {
                    if (i == index) {
                      //切换至选中的日期
                      _day = _datas[i].day!;
                      _datas[i].is_select = true;

                      //加载选中的日期事件
                      // _loadAttendanceDayRecord( _datas[i].year.toString() + "-" + _datas[i].month.toString()+"-"+ _datas[i].day.toString());
                      _loadAttendanceDayRecord(_datas[i]);
                    } else {
                      _datas[i].is_select = false;
                    }
                  }
                } else {
                  //不是当月的不做处理
                  // _datas[index].is_select=false;
                }
              });
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: 25.px,
                    height: 25.px,
                    //设置底部背景
                    decoration: _datas[index].is_select!
                        ? BoxDecoration(
                            color: theme.f4f4f4.withOpacity(0.4),
                            shape: BoxShape.circle,
                          )
                        : BoxDecoration(),
                    child: Center(
                      child: Text(
                        //不是当前月不显示值
                        _datas[index].month == _month ? _datas[index].day.toString() : "",
                        //设置选中字体颜色，以及周末和工作日颜色
                        style: _datas[index].is_select!
                            ? TextStyle(fontSize: 16.px, color: theme.secondaryColor)
                            // : (index % 7 == 5 || index % 7 == 6)
                            //     ? TextStyle(fontSize: 16.px, color: theme.textGrey)
                            : (_datas[index].month == _month &&
                                    _datas[index].work_type != "" &&
                                    _datas[index].work_type != "0")
                                ? TextStyle(fontSize: 16.px, color: theme.text282109)
                                : TextStyle(fontSize: 16.px, color: theme.textGrey),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  //设置底部小圆点，非当前月的不显示，设置为透明，其余的根据状态判断显示
                  if (widget.showPoint == true)
                    _datas[index].month == _month && _datas[index].work_type != "" && _datas[index].work_type != "0"
                        ? Container(
                            height: 6.0,
                            width: 6.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _datas[index].work_type == "1" ? Color(0xFFF48835) : Color(0xFF2C91F6)),
                          )
                        : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 获取行数
  int _getRowsForMonthYear({int? year, int? month}) {
    //当前月天数
    var _currentMonthDays = _getCurrentMonthDays(year: year, month: month);
    //
    var _placeholderDays = _getPlaceholderDays(year: year, month: month);

    int rows = (_currentMonthDays + _placeholderDays) ~/ 7;

    int remainder = (_currentMonthDays + _placeholderDays) % 7;
    if (remainder > 0) {
      rows = rows + 1;
    }
    return rows;
  }

  // 得到这个月的第一天是星期几
  int _getPlaceholderDays({int? year, int? month}) {
    return DateTime(year!, month!).weekday - 1 % 7;
  }

  // 获取当前月份天数
  int _getCurrentMonthDays({int? year, int? month}) {
    if (month == 2) {
      //判断2月份是闰年月还是平年
      if (((year! % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
        return 29;
      } else {
        return 28;
      }
    } else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
      return 31;
    } else {
      return 30;
    }
  }

  /// 获取展示信息
  _setDatas({int? year, int? month}) {
    /// 上个月占位
    var lastYear = year;
    var lastMonth = month! - 1;
    if (month == 1) {
      lastYear = year! - 1;
      lastMonth = 12;
    }

    var placeholderDays = _getPlaceholderDays(year: year, month: month);
    var lastMonthDays = _getCurrentMonthDays(year: lastYear, month: lastMonth);
    var firstDay = lastMonthDays - placeholderDays;
    for (var i = 0; i < placeholderDays; i++) {
      _datas.add(
          CalendarModel(year: lastYear!, month: lastMonth, day: firstDay + i + 1, is_select: false, work_type: ""));
    }

    /// 本月显示
    var currentMonthDays = _getCurrentMonthDays(year: year, month: month);
    for (var i = 0; i < currentMonthDays; i++) {
      if (i == _day - 1) {
        _datas.add(CalendarModel(year: year!, month: month, day: i + 1, is_select: true, work_type: ""));
      } else {
        _datas.add(CalendarModel(year: year!, month: month, day: i + 1, is_select: false, work_type: ""));
      }
    }

    /// 下个月占位
    var nextYear = year;
    var nextMonth = month + 1;
    if (month == 12) {
      nextYear = year! + 1;
      nextMonth = 1;
    }
    var nextPlaceholderDays = _getPlaceholderDays(year: nextYear, month: nextMonth);
    for (var i = 0; i < 7 - nextPlaceholderDays; i++) {
      _datas.add(CalendarModel(year: nextYear!, month: nextMonth, day: i + 1, is_select: false, work_type: ""));
    }
  }

  // 上月
  _lastMonth() {
    setState(() {
      if (_month == 1) {
        _year = _year - 1;
        _month = 12;
      } else {
        _month = _month - 1;
      }
      _day = 0; //查看上一个月时，默认选中的为第0天

      _datas.clear();
      _setDatas(year: _year, month: _month);
      //更新月历事件
      widget.onChangeMonth == null?null:widget.onChangeMonth!(DateTime(_year,_month));
      // loadAttendanceMonthRecord();
      //更新日事件
      // _loadAttendanceDayRecord(_year.toString() + "-" + _month.toString()+"-"+_day.toString());
    });
  }

  // 下月
  _nextMonth() {
    if (_month == 12) {
      //当前月是12月，下一个月就是下一年
      if (DateTime.now().year >= _year + 1) {
        //判断下一年是否大于当前年
        _setNextMonthData();
      }
    } else {
      //当前月不是12月，还处于当前年
      if (DateTime.now().year > _year) {
        _setNextMonthData();
      } else {
        if (DateTime.now().month >= _month + 1) {
          //判断下一个月是否超过当前月，超过当前月不做操作
          _setNextMonthData();
        }
      }
    }
  }

  //设置下个月的数据
  _setNextMonthData() {
    setState(() {
      if (_month == 12) {
        _year = _year + 1;
        _month = 1;
      } else {
        _month = _month + 1;
      }
      if (_month == DateTime.now().month) {
        //如果下个月时当前月，默认选中当天
        _day = DateTime.now().day;
      } else {
        //如果不是当前月，默认选中第0天
        _day = 0;
      }
      _datas.clear();
      _setDatas(year: _year, month: _month);
      //更新月历事件
      widget.onChangeMonth == null?null:widget.onChangeMonth!(DateTime(_year,_month));
      // loadAttendanceMonthRecord();

      //更新日事件
      // _loadAttendanceDayRecord(_year.toString() + "-" + _month.toString()+"-"+_day.toString());
    });
  }
}

//日历bean
class CalendarModel {
  int? year;
  int? month;
  int? day;
  String? work_type = ""; //日期事件，0，休息，1，异常，2，正常
  bool? is_select = false;

  CalendarModel({this.year, this.month, this.day, this.is_select, this.work_type});

  @override
  String toString() {
    return 'CalendarModel{year: $year, month: $month, day: $day, work_type: $work_type, is_select: $is_select}';
  }
}

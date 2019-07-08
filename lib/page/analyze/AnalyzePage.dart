
import 'package:case_manager/common/dao/AnalizeDao.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalyzePage extends StatefulWidget {
  
  @override
  _AnalyzePageState createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> with BaseWidget{

  ///set, get
  AnalizeViewModel model;
  ///現在時間
  final nowTime = DateTime.now();
  //所選日期
  var selectDate = formatDate(DateTime.now(), [yyyy,'-',mm]);
  ///是否是今日
  var isThisMonth = false;
  ///各部門title
  var titleArray = ["業務處","工程處","研發處","行政處","節目部","客服中心"];
  ///row array的擴展
  List<bool> _isExpandedArray = [false,false,false,false,false,false];
  ///裝data
  List<dynamic> originArray = [];
  List<dynamic> dataArray = [];
  ///客服
  List<dynamic> serviceArray = [];
  ///工程
  List<dynamic> enginArray = [];
  ///業務
  List<dynamic> salesArray = [];
  ///研發
  List<dynamic> developArray = [];
  ///節目
  List<dynamic> programArray = [];
  ///行政
  List<dynamic> adminArray = [];

  @override
  void initState() {
    super.initState();
    isLoading = false;
    getApiData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toogleExpand(int index) {
    setState(() {
      if (_isExpandedArray[index] == false) {
        _isExpandedArray[index] = true;
      }
      else if (_isExpandedArray[index] == true) {
        _isExpandedArray[index] = false;
      }
     
    });
  }

  ///取得api資料
  getApiData() async {
    isLoading = true;
    originArray.clear();
    serviceArray.clear();
    salesArray.clear();
    developArray.clear();
    enginArray.clear();
    programArray.clear();
    var dSplit = selectDate.split('-');
    var res = await AnalizeDao.getDeptCaseCount(searchYear: dSplit[0], searchMonth: dSplit[1]);
    if (res != null && res.result) {
      var deptArr = [];
      setState(() {
      originArray = res.data;    
        for (var dic in originArray) {
          if (!deptArr.contains(dic['DepartmentName'])) {
            deptArr.add(dic['DepartmentName']);
          }
          if (dic['DepartmentName'].toString().contains('客服')) {
            serviceArray.add(dic);
          }
          if (dic['DepartmentName'].toString().contains('業務')) {
            salesArray.add(dic);
          }
          if (dic['DepartmentName'].toString().contains('研發')) {
            developArray.add(dic);
          }
          if (dic['DepartmentName'].toString().contains('工程')) {
            enginArray.add(dic);
          }
          if (dic['DepartmentName'].toString().contains('節目')) {
            programArray.add(dic);
          }
          if (dic['DepartmentName'].toString().contains('行政')) {
            adminArray.add(dic);
          }
        }
        isLoading = false;

      });
    }

  }

  ///頁面上方head
  _renderHeader() {
    return Container(
      height: titleHeight(context),
      decoration: BoxDecoration(color: Color(MyColors.hexFromStr('#f6feff')),border: Border(top: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid), bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: titleHeight(context),
            width: deviceWidth5(context) * 2,
            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: autoTextSize('單位', TextStyle(color: Colors.black), context),
          ),
          Container(
            alignment: Alignment.center,
            height: titleHeight(context),
            width: deviceWidth5(context),
            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: autoTextSize('新案', TextStyle(color: Colors.black), context),
          ),
          Container(
            alignment: Alignment.center,
            height: titleHeight(context),
            width: deviceWidth5(context),
            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: autoTextSize('未結案', TextStyle(color: Colors.black), context),
          ),
          Container(
            alignment: Alignment.center,
            height: titleHeight(context),
            width: deviceWidth5(context),
            child: autoTextSize('超常', TextStyle(color: Colors.black), context),
          ),
        ],
      ),
    );
  }
  ///body 內容
  _renderBody() {
    
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: dataList()
      ),
    );
  }

  List<Widget> dataList() {
    List<Widget> wList = [];
    int newCount = 0;
    int noCloseCount = 0;
    int overCount = 0;
    for (var dic in titleArray) {
      var index = titleArray.indexOf(dic);
      switch(dic) {
        case '業務處':
          newCount = 0;
          noCloseCount = 0;
          overCount = 0;
          dataArray = salesArray;
          break;
        case '工程處':
          newCount = 0;
          noCloseCount = 0;
          overCount = 0;
          dataArray = enginArray;
          break;
        case '研發處':
          newCount = 0;
          noCloseCount = 0;
          overCount = 0;
          dataArray = developArray;
          break;
        case '客服中心':
          newCount = 0;
          noCloseCount = 0;
          overCount = 0;
          dataArray = serviceArray;
          break;
        case '節目部':
          newCount = 0;
          noCloseCount = 0;
          overCount = 0;
          dataArray = programArray;
          break;
        case '行政處':
          newCount = 0;
          noCloseCount = 0;
          overCount = 0;
          dataArray = adminArray;
          break;
      }
      for (var dis in dataArray) {
        newCount += int.parse(dis["NewCases"]);
        noCloseCount += int.parse(dis["TotalUncloseCases"]);
        overCount += int.parse(dis["OverdueTakeCases"]);
      }
      wList.add(
        InkWell(
          onTap: () {
             _toogleExpand(index);
          },
          child: Ink(
            decoration: BoxDecoration(color: Colors.white ,border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: titleHeight(context),
                  width: deviceWidth5(context) * 2,
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: autoTextSize(
                    _isExpandedArray[index] == false ? '▷ $dic' : '▽ $dic', 
                    TextStyle(color: Colors.black), 
                    context
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: titleHeight(context),
                  width: deviceWidth5(context),
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: autoTextSize('$newCount', TextStyle(color: Colors.black), context),
                ),
                Container(
                  alignment: Alignment.center,
                  height: titleHeight(context),
                  width: deviceWidth5(context),
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: autoTextSize('$noCloseCount', TextStyle(color: Colors.black), context),
                ),
                Container(
                  alignment: Alignment.center,
                  height: titleHeight(context),
                  width: deviceWidth5(context),
                  child: autoTextSize('$overCount', TextStyle(color: Colors.black), context),
                ),

              ],
            ),
          ),
        ),
      );
      switch(dic) {
        case '業務處':
          wList.add(
            listView(salesArray, index)
          );
           break;
        case '工程處':
          wList.add(
            listView(enginArray, index)
          );
           break;
        case '研發處':
          wList.add(
            listView(developArray, index)
          );
           break;
        case '客服中心':
          wList.add(
            listView(serviceArray, index)
          );
           break;
        case '節目部':
          wList.add(
            listView(programArray, index)
          );
           break;
        case '行政處':
          wList.add(
            listView(adminArray, index)
          );
           break;
      }
    }
    return wList;
  }
 
  Widget listView(List<dynamic> datas, int i) {
    Widget list;
    if (datas.length > 0) {
      var rowHeight = titleHeight(context) * datas.length;
      if (datas.length > 4) {
        rowHeight = titleHeight(context) * 4;
      }
      list = Container(
        height: _isExpandedArray[i] == true ?  rowHeight : 0,
        child: ListView.builder(
        itemBuilder: (context, index) {
          Widget item;
          model = AnalizeViewModel.forMap(datas[index]);
          item = ExpandedSection(
            expand: _isExpandedArray[i],
            child: Container(
              decoration: BoxDecoration(color: Color(MyColors.hexFromStr('f2f2f2')) ,border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: titleHeight(context),
                    width: deviceWidth5(context) * 2,
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child: autoTextSize(model.departmentName, TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: titleHeight(context),
                    width: deviceWidth5(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child: autoTextSize(model.newCases, TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: titleHeight(context),
                    width: deviceWidth5(context),
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child: autoTextSize(model.totalUncloseCases, TextStyle(color: Colors.black), context),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: titleHeight(context),
                    width: deviceWidth5(context),
                    child: autoTextSize(model.overdueTakeCases, TextStyle(color: Colors.black), context),
                  ),
                ],
              ),
            ),
          );
          return item;
        },
        itemCount: datas.length,
      )
      );
      
    }
    else {
      list = Container(height: 0,);
    }
    return list;
  }
  ///show body
  Widget bodyView() {
    Widget body;
    body = originArray.length < 1 ? showLoadingAnime(context) : Column(
      children: <Widget>[
        _renderHeader(),
        Expanded(
          child: _renderBody(),
        )
      ],
    );
    return body;
  }
  ///bottomNavigationBar 按鈕
  Widget bottomBar() {
    Widget bottom = Material(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth4(context),
              child: autoTextSize('刷新', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),
            ),
            onTap: () {
            },
          ),
          Container(
            alignment: Alignment.center,
            height: 30,
            // width: deviceWidth3(context),
            child: FlatButton.icon(
              icon: Image.asset('static/images/24.png'),
              color: Colors.transparent,
              label: Text(''),
              onPressed: (){
                NavigatorUtils.goLogin(context);
              },
            ),
          ),
          
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth4(context),
              child: autoTextSize('返回', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),context),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          
        ],
      ),
    );
    return bottom;
  }
  /// app bar action按鈕
  List<Widget> actions() {
    List<Widget> list = [
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                height: 38,
                alignment: Alignment.center,
                width: deviceWidth4(context),
                child: autoTextSize('', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),
              ),
              onTap: () {
                
              },
            ),
            Container(
              alignment: Alignment.center,
              height: 30,
              width: deviceWidth3(context) * 1.1,
              child: FlatButton.icon(
                icon: Image.asset('static/images/24.png'),
                color: Colors.transparent,
                label: Text(''),
                onPressed: (){
                  NavigatorUtils.goLogin(context);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: InkWell(
                child: Ink(
                  width: deviceWidth4(context),
                  height: 30,
                  child: autoTextSize('$selectDate▼', TextStyle(fontSize: MyScreen.homePageFontSize(context)), context),
                ),
                onTap: () {
                  showSelectorDateSheetController(context);
                },
              ),
            ),
            
          ],
        ),
      )
    ];
    return list;
  }

  ///日期選擇器
  showSelectorDateSheetController(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context){
        var dialog = CupertinoActionSheet(
          title: Text('選擇日期', style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消', style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: _selectorSort(),
        );
        return dialog;
      }
    );
  }
  ///alert 選項內容
  _selectorSort() {
    List<Widget> wList = [];
    for (var i=0; i< 5; i++) {
      var time = new DateTime(nowTime.year, nowTime.month - i,);
      var formatD = formatDate(time, [yyyy,'-',mm]);
      if (i == 0){
        formatD = '今月';
      }
      wList.add(
        CupertinoActionSheetAction(
          child: Text(formatD, style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
          onPressed: (){
            setState(() {
             _isExpandedArray = [false,false,false,false,false,false];
             if (i == 0) {
               formatD = formatDate(time, [yyyy,'-',mm]);
               isThisMonth = true;
             }
             else {
               isThisMonth = false;
             }
             selectDate = formatD;
            });
            isLoading = true;
            getApiData();
            Navigator.pop(context);
          },
        )
      );
    }
    return wList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: Container(),
          elevation: 0.0,
          actions: actions(),
        ),
        body: bodyView(),
        bottomNavigationBar: bottomBar()
      ),
    );
  }
}

///內部class 
///提供擴展動畫顯示
class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  ExpandedSection({this.expand = false, this.child});
  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}
class _ExpandedSectionState extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation; 

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }
 
  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.expand) {
      expandController.forward();
    }
    else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    );
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1.0,
      sizeFactor: animation,
      child: widget.child
    );
  }
}

///內class
///資料model
class AnalizeViewModel {
  String departmentID;
  String departmentName;
  String newCases;
  String takeCases;
  String closeCases;
  String overdueTakeCases;
  String overdueCloseCases;
  String totalUncloseCases;
  String totalCloseCases;
  String totalCases;
  AnalizeViewModel();
  AnalizeViewModel.forMap(data) {
    departmentID = data['DepartmentID'] == null ? '' : data['DepartmentID'];
    departmentName = data['DepartmentName'] == null ? '' : data['DepartmentName'];
    newCases = data['NewCases'] == null ? '' : data['NewCases'];
    takeCases = data['TakeCases'] == null ? '' : data['TakeCases'];
    closeCases = data['CloseCases'] == null ? '' : data['CloseCases'];
    overdueTakeCases = data['OverdueTakeCases'] == null ? '' : data['OverdueTakeCases'];
    overdueCloseCases = data['OverdueCloseCases'] == null ? '' : data['OverdueCloseCases'];
    totalUncloseCases = data['TotalUncloseCases'] == null ? '' : data['TotalUncloseCases'];
    totalCloseCases = data['TotalCloseCases'] == null ? '' : data['TotalCloseCases'];
    totalCases = data['TotalCases'] == null ? '' : data['TotalCases'];
  }
}
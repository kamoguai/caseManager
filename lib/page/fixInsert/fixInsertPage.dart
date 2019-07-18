
import 'package:case_manager/common/dao/MaintDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/model/MaintTableCell.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/redux/SysState.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/MyPullLoadWidget.dart';
import 'package:case_manager/widget/items/MaintListItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:case_manager/widget/MyListState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

///
///維修插單列表頁面
///Date: 2019-07-02
class FixInsertPage extends StatefulWidget {

  final String accName;
  FixInsertPage({this.accName});

  @override
  _FixInsertPageState createState() => _FixInsertPageState();
}

class _FixInsertPageState extends State<FixInsertPage> with AutomaticKeepAliveClientMixin<FixInsertPage>, MyListState<FixInsertPage>{
  ///app bar左邊title
  var userTitle = "工程插單";
  ///部門id
  var deptId = "";
  ///新案count
  var newCaseCount = 0;
  ///未結count
  var noCloseCount = 0;
  ///超常count
  var overCount = 0;
  ///全部筆數
  var totalCount = 0;
  ///userInfo model
  UserInfo userInfo;
  ///數據資料arr
  final List<dynamic> dataArray = [];
  ///所選caseId
  List<String> pickCaseIdArray = [];

  @override
  void initState() {
    super.initState();
    clearData();
    initParam();
  }

  @override
  void dispose() {
    super.dispose();
    clearData();
  }

  @override
  bool get isRefreshFirst => false;

  @override
  requestRefresh() async {
    return null;
  }

  @override
  requestLoadMore() async {
    return null;
  }
  //透過override pullcontroller裡面的handleRefresh覆寫數據
  @override
  Future<Null> handleRefresh() async {
    dataArray.clear();
    if (isLoading) {
      return null;
    }

    isLoading = true;
    var res = await getApiData();
    if (res != null && res.result) {
      List<MaintTableCell> list = new List();
      dataArray.addAll(res.data);
      if (dataArray.length > 0) {
        for (var dic in dataArray) {
          list.add(MaintTableCell.fromJson(dic));
        }
      }
      List<dynamic> newCount = [];
      List<dynamic> noCount = [];
      for (var dic in res.data) {
        if (dic["StatusName"] == '新案') {
          newCount.add(dic);
        }
        else if (dic["StatusName"] == '接案') {
          noCount.add(dic);
        }
      }
      if(mounted) {
        setState(() {
          totalCount = res.data.length;
          newCaseCount = newCount.length;
          noCloseCount = noCount.length;
          isLoading = false;
          pullLoadWidgetControl.dataList.clear();
          pullLoadWidgetControl.dataList.addAll(list);
          pullLoadWidgetControl.needLoadMore = false;
        });
      }
    }
  }

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }

  initParam() async {
    var userInfoData = await UserInfoDao.getUserInfoLocal();
    if (mounted) {
      setState(() {
        userInfo = userInfoData.data;
      });
    }
    showRefreshLoading();
  }
  ///列表顯示物件
  _renderItem(index) {
    MaintTableCell mtc = pullLoadWidgetControl.dataList[index];
    MaintListModel model = MaintListModel.forMap(mtc);
    return MaintListItem(model: model, userId: userInfo.userData.UserID, deptId: deptId, fromFunc: 'SalesMaint');
  }
  ///頁面上方head
  _renderHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: titleHeight(),
      decoration: BoxDecoration(color: Color(MyColors.hexFromStr('#eeffec')),border: Border(top: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid), bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          autoTextSize('新案: $newCaseCount', TextStyle(color: Colors.black)),
          SizedBox(width: 5.0,),
          autoTextSize('未結: $noCloseCount', TextStyle(color: Colors.black)),
          SizedBox(width: 5.0,),
          autoTextSize('超常: $overCount', TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  ///產生body列表
  _renderBody() {
    return MyPullLoadWidget(
        pullLoadWidgetControl,
        (BuildContext context, int index) => _renderItem(index),
        handleRefresh,
        onLoadMore,
        refreshKey: refreshIndicatorKey,
    );
  }
 
  ///取得api資料
  getApiData() async {
    
    var res = await MaintDao.getMaintListExt(userId: userInfo.userData.UserID, deptId: '4', searchCaseType: '51', itype: 1);
    return res;
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
                width: deviceWidth4(),
                child: autoTextSize('$userTitle', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
              ),
              onTap: () {
               
              },
            ),
            Container(
              alignment: Alignment.center,
              height: 30,
              width: deviceWidth3() * 1.1,
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
              height: 30,
              width: deviceWidth4(),
              child: autoTextSize('${widget.accName} $totalCount', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
          ],
        ),
      )
    ];
    return list;
  }
  Widget bodyView() {
    Widget body;
    body = isLoading ? showLoadingAnime(context) : Column(
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth6(),
              child: autoTextSize('刷新', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
              showRefreshLoading();
            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth6(),
              child: autoTextSize('', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: (){
              
            },
          ),
          Container(
            alignment: Alignment.center,
            height: 30,
            // width: deviceWidth3() * 1.1,
            child: FlatButton.icon(
              icon: Image.asset('static/images/24.png'),
              color: Colors.transparent,
              label: Text(''),
              onPressed: (){
                NavigatorUtils.goLogin(context);
              },
            ),
          ),
          SizedBox(width: deviceWidth7(),),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth6(),
              child: autoTextSize('返回', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
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


import 'package:case_manager/common/dao/InterimAuthDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/model/MaintTableCell.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/redux/SysState.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/MyPullLoadWidget.dart';
import 'package:case_manager/widget/items/MaintListItem.dart';
import 'package:flutter/material.dart';
import 'package:case_manager/widget/MyListState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
///
///個人案件處理list頁面
///Date: 2019-06-11
///
class InterimAuthPage extends StatefulWidget {
  final String accName;
  final String deptId;
  InterimAuthPage({this.accName, this.deptId});
  @override
  _InterimAuthPageState createState() => _InterimAuthPageState();
}

class _InterimAuthPageState extends State<InterimAuthPage> with AutomaticKeepAliveClientMixin<InterimAuthPage>, MyListState<InterimAuthPage>{
  ///app bar左邊title
  var userTitle = "二次臨時授權";
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
  ///變更輸入/列表畫面
  bool isChangedView = false;
  ///textField controller
  TextEditingController _editingController = TextEditingController();
  ///node
  FocusNode _node =  FocusNode();

  @override
  void initState() {
    super.initState();
    clearData();
    initParam();
  }

  @override
  void dispose() {
    clearData();
    this._editingController.clear();
    this._node.dispose();
    super.dispose();

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
    /// new node
    this._node = FocusNode();
    var userInfoData = await UserInfoDao.getUserInfoLocal();
    if (mounted) {
      setState(() {
        userInfo = userInfoData.data;
        this.getFirstTimeApiData();
      });
    }
  }
  ///列表顯示物件
  _renderItem(index) {
    MaintTableCell mtc = pullLoadWidgetControl.dataList[index];
    MaintListModel model = MaintListModel.forMap(mtc);
    return MaintListItem(model: model, userId: userInfo.userData.UserID, deptId: deptId, fromFunc: 'InterimAuth', accName: widget.accName,);
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
 
  ///第一次進入取得的資料
  getFirstTimeApiData() async {
    var res = await InterimAuthDao.getInterimAuthList(userId: userInfo.userData.UserID);
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

  ///取得api資料
  getApiData() async {
    
    var res = await InterimAuthDao.getInterimAuthList(userId: userInfo.userData.UserID);
    return res;
  }

  void updateChangedView(v) {
    setState(() {
      this.isChangedView = v;
      if (v) {
        FocusScope.of(context).requestFocus(_node);
        _editingController.text = "";
      }
    });
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
                child: autoTextSize('', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
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
              child: autoTextSize('${_getStore().state.userInfo.userData?.UserName} $totalCount', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
          ],
        ),
      )
    ];
    return list;
  }
  Widget bodyView() {
    Widget body;
    List<Widget> columnList = [];
    columnList.add(
      _renderHeader()
    );
    if (!this.isChangedView) {
      columnList.add(
        Expanded(
          child: _renderBody(),
        )
      );
    }
    else {
      columnList.add(
        Expanded(
          child: Column(
            children: <Widget>[

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _editingController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  maxLength: 10,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '客編',
                    hintText: '請輸入二次授權之客編',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                    ),
                  ),
                  onSubmitted: (v) {
                   
                  },
                ),
              ),
              Center(
                child: Container(
                  child: FlatButton(
                    color: Colors.blue[300],
                    child: autoTextSize('授權', TextStyle(color: Colors.white)),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      print(this._editingController.text);
                      if (this._editingController.text.length < 10) {
                        Fluttertoast.showToast(msg: '請輸入完整客編！');
                        return;
                      }
                      else {
                        Fluttertoast.showToast(msg: '成功！');
                        return;
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        )
      );
    }
    body = isLoading ? showLoadingAnime(context) : Column(
      children:  columnList
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
              child: autoTextSize( this.isChangedView ? '列表' : '輸入', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: (){
               var v = !this.isChangedView;
               this.updateChangedView(v);
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
              width: deviceWidth7(),
              child: autoTextSize('', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
              
            },
          ),
          
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth6(),
              child: autoTextSize('返回', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
               NavigatorUtils.goHome(context);
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
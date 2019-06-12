

import 'package:case_manager/common/dao/MaintDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/redux/SysState.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/dialog/DeptSelectorDialog.dart';
import 'package:flutter/material.dart';
import 'package:case_manager/widget/MyListState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
/**
 * 個人案件處理頁面
 * Date: 2019-06-11
 */
class MaintPage extends StatefulWidget {
  final String accName = "";
  MaintPage({accName});
  @override
  _MaintPageState createState() => _MaintPageState();
}

class _MaintPageState extends State<MaintPage> with AutomaticKeepAliveClientMixin<MaintPage>, MyListState<MaintPage>{
  
  var userTitle = "個人案件";
  ///userInfo model
  UserInfo userInfo;

  @override
  void initState() {
    super.initState();
    initParam();
  }

  @override
  void dispose() {
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

  @override
  Future<Null> handleRefresh() async {


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
    Future.delayed(const Duration(milliseconds: 50),(){
      showDialog(
      context: context,
      builder: (BuildContext context) => deptSelectorDialog(context)
      );
    });
    
  }
  ///function給DeptSelectorDialog呼叫並把值帶回
  void _callApiData(Map<String, dynamic> map) async {
    if (isLoading) {
      Fluttertoast.showToast(msg: '資料正在讀取中..');
      return;
    }
    isLoading = true;
    setState(() {
      userTitle = map["DeptName"];
    });
    var res = await getApiData(userInfo.userData.UserID, map["DeptID"]);
    if (res != null && res.result) {
      print('maintPage apiData => ${res.data}');
    }
    
  }
  ///取得api資料
  getApiData(userId, deptId) async {
    var res = await MaintDao.getMaintList(userId: userId, deptId: deptId);
    return res;
  }
  ///部門選擇dialog
  Widget deptSelectorDialog(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: DeptSelectorDialog(callApiData: _callApiData,),
      )
    );
  }
  /// app bar action按鈕
  List<Widget> actions() {
    List<Widget> list = [
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
           Container(
              margin: EdgeInsets.only(left: 5.0),
              height: 38,
              alignment: Alignment.center,
              width: deviceWidth4(),
              child: autoTextSize('$userTitle', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            Container(
              height: 30,
              width: deviceWidth2(),
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
              height: 30,
              width: deviceWidth5(),
              child: autoTextSize(widget.accName, TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            )
          ],
        ),
      )
    ];
    return list;
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
              width: deviceWidth4(),
              child: autoTextSize('刷新', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context))),
            ),
            onTap: () {
              
            },
          ),
          
          Container(
            height: 42,
            width: deviceWidth5(),
          ),
          Container(
            height: 42,
            width: deviceWidth5(),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.center,
              height: 42,
              width: deviceWidth3(),
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
        body: Container(color: Colors.white,),
        bottomNavigationBar: bottomBar()
      ),
    );
  }
}
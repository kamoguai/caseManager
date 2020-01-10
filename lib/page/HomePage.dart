
import 'package:auto_size_text/auto_size_text.dart';
import 'package:case_manager/common/config/Config.dart';
import 'package:case_manager/common/dao/HomeDao.dart';
import 'package:case_manager/common/dao/UserInfoDao.dart';
import 'package:case_manager/common/local/LocalStorage.dart';
import 'package:case_manager/common/model/UserInfo.dart';
import 'package:case_manager/common/net/Address.dart';
import 'package:case_manager/common/redux/SysState.dart';
import 'package:case_manager/common/style/MyStyle.dart';
import 'package:case_manager/common/utils/NavigatorUtils.dart';
import 'package:case_manager/widget/BaseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///首頁
///Date: 2019-06-05
///
class HomePage extends StatefulWidget {
  static final String sName = "home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BaseWidget{

  ///使用者account
  var _account = "";
  ///使用者名稱
  var _accName = "";
  ///使用者部門
  var _accDept = "";
  ///下拉city選單
  var selectArea = '新北市';
  ///使用者新案筆數
  var _newCase = "0";
  ///使用者接案筆數
  var _takeCase = "0";
  ///使用者超常筆數
  var _overCase = "0";
  ///userInfo model
  UserInfo userInfo;
  ///使用按鈕權限，維修插單處理
  var isCreateCase = false;
  ///使用按鈕權限，指派單位
  var isAssignDept = false;
  ///使用按鈕權限，指派個人
  var isAssignEmpl = false;
  ///使用按鈕權限，個人案件處理
  var isMaint = false;

  var isDPMaint = false;
  ///使用按鈕權限，單位案件處理
  var isDeptClose = false;
  ///使用按鈕權限，案件歸檔/單位結案
  var isFile = false;
  ///使用按鈕權限，區障使用權
  var isAreaBug = false;
  ///scroll
  ScrollController _scrollController = ScrollController();

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
  autoTextSize(text, style, context) {
    super.autoTextSize(text, style, context);
    return AutoSizeText(text, style: style, minFontSize: 5.0,);
  }

  initParam() async {
    
    _account = await LocalStorage.get(Config.USER_NAME_KEY);
    _getApiData(_account);
    getSnrConfigData();
    _checkServerMode();
    var userInfoData = await UserInfoDao.getUserInfoLocal();
    if (mounted) {
      setState(() {  
        userInfo = userInfoData.data;
        _accName = userInfo.userData.UserName;
        _accDept = userInfo.userData.DeptName;
        isCreateCase = userInfo.authorityData.CreateCase == "Y" ? true : false;
        isAssignDept = userInfo.authorityData.AssignDept == "Y" ? true : false;
        isAssignEmpl = userInfo.authorityData.AssignEmpl == "Y" ? true : false;
        isMaint = userInfo.authorityData.Maint == "Y" ? true : false;
        isDPMaint = userInfo.authorityData.DPMaint == "Y" ? true : false;
        isDeptClose = userInfo.authorityData.DeptClose == "Y" ? true : false;
        isFile = userInfo.authorityData.File == "Y" ? true : false;
        isAreaBug = userInfo.authorityData.AreaBug == "Y" ? true : false;
      });
    }
  }

  ///確認呼叫server路徑
  _checkServerMode() async {
    var text = await LocalStorage.get(Config.SERVERMODE);
    if (text != null && text != "prod") {
      if(mounted) {
        setState(() {
          Address.isEnterTest = true;
          Fluttertoast.showToast(msg: '歡迎使用測試機');
        });
      }
    }
  }

  ///呼叫api
  _getApiData(account) async{
    var res = await HomeDao.getUserCaseType(account);
    if (res != null && res.result) {
      if (mounted) {
        setState(() {
          _newCase = res.data["NewCase"];
          _takeCase = res.data["TakeCase"];
        });
      }
    }
  }
  ///取得snr config
  getSnrConfigData() async {
     await HomeDao.getSnrConfigAPI();
  }

  ///區域dialog, ios樣式
  _showAlertSheetController(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('選擇區域'),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, 'cancel');
            },
            child: Text('取消'),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  selectArea = '新北市';
                });
                Navigator.pop(context);
              },
              child: Text('新北市'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  selectArea = '台北市';
                });
                Navigator.pop(context);
              },
              child: Text('台北市'),
            ),
          ],
        );
        return dialog;
      });
  }

  ///button長度配置
  _buildButtonWidth() {
    double width = 0.0;
    final deviceHeight = MediaQuery.of(context).size.height; 
    if (deviceHeight < 570) {
      width = deviceWidth2(context) * 1.4;
    }
    else {
      width = deviceWidth2(context) * 1.2;
    }
    return width;
  }
  /// app bar action按鈕
  List<Widget> actions() {
    List<Widget> list = [
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                // _showAlertSheetController(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                height: 38,
                alignment: Alignment.center,
                width: deviceWidth4(context),
                // decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.white)),
                child: Text('', style: TextStyle(color: Colors.white,)),
              ),
            ),
            Container(
              height: 30,
              width: deviceWidth2(context),
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
              width: deviceWidth5(context),
            )
          ],
        ),
      )
    ];
    return list;
  }
  /// body 顯示內文
  Widget bodyColumn() {

    Widget body;
    List<Widget> columnList = [];
    List<Widget> columnList2 = [];
    columnList.add(
      Container(
        padding: EdgeInsets.only(top: 5.0),
      ),
    );
    columnList.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          autoTextSize('登入者: ', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
          autoTextSize('$_accName ($_accDept)', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context)
        ],
      ),
    );
    columnList.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          autoTextSize('新案: ', TextStyle(color: Colors.red, fontSize: MyScreen.homePageFontSize_s(context)), context),
          autoTextSize('$_newCase 筆', TextStyle(color: Colors.red, fontSize: MyScreen.homePageFontSize_s(context)), context),
          Container(padding: EdgeInsets.only(left: 5.0),),
          autoTextSize('未結案: ', TextStyle(color: Colors.red, fontSize: MyScreen.homePageFontSize_s(context)), context),
          autoTextSize('$_takeCase 筆', TextStyle(color: Colors.red, fontSize: MyScreen.homePageFontSize_s(context)), context),
          Container(padding: EdgeInsets.only(left: 5.0),),
          autoTextSize('超常: ', TextStyle(color: Colors.red, fontSize: MyScreen.homePageFontSize_s(context)), context),
          autoTextSize('$_overCase 筆', TextStyle(color: Colors.red, fontSize: MyScreen.homePageFontSize_s(context)), context),
        ],
      ),
    );
    if (userInfo.userData.DeptID == '4' || userInfo.userData.Position == '2') {
      columnList2.add(
        Container(
          padding: EdgeInsets.only(top: 5.0),   
          width: _buildButtonWidth(),       
          child: RaisedButton(
            disabledTextColor: Colors.grey,
            child: autoTextSize('維修插單處理', TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context), fontWeight: FontWeight.bold), context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
                NavigatorUtils.goFixInsert(context, _accName);
            },
          ),
        ),
      );
    }
    columnList2.add(
      Container(
        padding: EdgeInsets.only(top: 5.0),   
        width: _buildButtonWidth(),       
        child: RaisedButton(
          disabledTextColor: Colors.grey,
          child: autoTextSize('裝機問題通知', TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context), fontWeight: FontWeight.bold), context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            NavigatorUtils.goSalesMaint(context, _accName);
          },
        ),
      ),
    );
    if (isMaint) {
      columnList2.add(
        Container(
          padding: EdgeInsets.only(top: 5.0),   
          width: _buildButtonWidth(),       
          child: RaisedButton(
            disabledTextColor: Colors.grey,
            child: autoTextSize('個人案件處理', TextStyle(color: isMaint == true ? Colors.black : Colors.grey, fontSize: MyScreen.homePageFontSize(context), fontWeight: FontWeight.bold), context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              if (isMaint) {
                NavigatorUtils.goMaint(context, _accName);
              }
            },
          ),
        ),
      );
    }
    if (isAssignEmpl) {
      columnList2.add(
        Container(  
          padding: EdgeInsets.only(top: 5.0),
          width: _buildButtonWidth(),              
          child: RaisedButton(
            disabledTextColor: Colors.grey,
            child: autoTextSize('指派個人', TextStyle(color: isAssignEmpl == true ? Colors.black : Colors.grey, fontSize: MyScreen.homePageFontSize(context),fontWeight: FontWeight.bold), context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              if (isAssignEmpl) {
                NavigatorUtils.goAssign(context, _accName);
              }
            },
          ),
        ),
      );
    }
    if (isDPMaint) {
      columnList2.add(
        Container(  
          padding: EdgeInsets.only(top: 5.0),
          width: _buildButtonWidth(),      
          child: RaisedButton(
            disabledTextColor: Colors.grey,
            child: autoTextSize('單位案件處理', TextStyle(color: isDPMaint == true ? Colors.black : Colors.grey, fontSize: MyScreen.homePageFontSize(context),fontWeight: FontWeight.bold), context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              if (isDPMaint) {
                NavigatorUtils.goDPMaint(context, _accName);
              }
            },
          ),
        ),
      );
    }
    if (isAssignDept) {
      columnList2.add(
        Container(  
          padding: EdgeInsets.only(top: 5.0),
          width: _buildButtonWidth(),      
          child: RaisedButton(
            disabledTextColor: Colors.grey,
            child: autoTextSize('指派單位', TextStyle(color: isAssignDept == true ? Colors.black : Colors.grey, fontSize: MyScreen.homePageFontSize(context),fontWeight: FontWeight.bold), context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              if (isAssignDept) {
                NavigatorUtils.goDPAssign(context, _accName);
              }
            },
          ),
        ),
      );
    }
    columnList2.add(
      Container(  
        padding: EdgeInsets.only(top: 5.0),
        width: _buildButtonWidth(),      
        child: RaisedButton(
          disabledTextColor: Colors.grey,
          child: autoTextSize('案件分析', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context),fontWeight: FontWeight.bold), context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            NavigatorUtils.goAnalyze(context);
          },
        ),
      ),
    );
    columnList2.add(
      Container(  
        padding: EdgeInsets.only(top: 5.0),
        width: _buildButtonWidth(),      
        child: RaisedButton(
          disabledTextColor: Colors.grey,
          child: autoTextSize('二次臨時授權', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context),fontWeight: FontWeight.bold), context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            NavigatorUtils.goInterimAuth(context);
          },
        ),
      ),
    );
    if (isFile) {
      columnList2.add(
        Container( 
          padding: EdgeInsets.only(top: 5.0), 
          width: _buildButtonWidth(),      
          child: RaisedButton(
            disabledTextColor: Colors.grey,
            child: autoTextSize('案件歸檔/單位結案', TextStyle(color: isFile == true? Colors.black : Colors.grey, fontSize: MyScreen.homePageFontSize(context),fontWeight: FontWeight.bold), context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              if (isFile) {
                NavigatorUtils.goFileList(context, _accName);
              }
            },
          ),
        ),
      );
    }
    columnList.add(
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: Column(
            children: columnList2,
          ),
        ),
      )
    );
    body = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: columnList,
      ),
    );
    
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: columnList
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
          Container(
            padding: EdgeInsets.all(5.0),
            alignment: Alignment.center,
            height: 42,
            width: deviceWidth4(context),
            child: autoTextSize('', TextStyle(color: Colors.white, fontSize: MyScreen.loginTextFieldFontSize(context)), context),
          ),
          Container(
            height: 42,
            width: deviceWidth5(context),
          ),
          Container(
            height: 42,
            width: deviceWidth5(context),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            alignment: Alignment.center,
            height: 42,
            width: deviceWidth3(context),
            child: autoTextSize('', TextStyle(color: Colors.white, fontSize: MyScreen.loginTextFieldFontSize(context)), context),
          ),
        ],
      ),
    );
    return bottom;
  }
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<SysState>(builder: (context, store) {
      return SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: Container(),
            elevation: 0.0,
            actions: actions(),
          ),
          body: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("static/images/bg.png"), fit: BoxFit.cover), ),
            child: userInfo == null ? showLoadingAnimeB(context) : bodyColumn(),
          ),
          bottomNavigationBar: bottomBar()
        ),
      );
    });
  }

}